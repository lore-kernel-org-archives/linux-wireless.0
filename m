Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D55DC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E352E206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfDZH65 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfDZH64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 03:58:56 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91C95368A5;
        Fri, 26 Apr 2019 07:58:55 +0000 (UTC)
Received: from localhost (unknown [10.40.205.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 489F7600C1;
        Fri, 26 Apr 2019 07:58:52 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v3 2/3] mt76usb: fix tx/rx stop
Date:   Fri, 26 Apr 2019 09:58:41 +0200
Message-Id: <20190426075842.2986-3-sgruszka@redhat.com>
In-Reply-To: <20190426075842.2986-1-sgruszka@redhat.com>
References: <20190426075842.2986-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 26 Apr 2019 07:58:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disabling tasklets on stopping rx/tx is wrong. If blocked tasklet
is scheduled and we remove device we will get 100% cpu usage:

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
    9 root      20   0       0      0      0 R  93.8   0.0   1:47.19 ksofti=
rqd/0

by infinite loop in tasklet_action_common() and eventuall crash on next
mt76usb module load:

[ 2068.591964] RIP: 0010:tasklet_action_common.isra.17+0x66/0x100
[ 2068.591966] Code: 41 89 f5 eb 25 f0 48 0f ba 33 00 0f 83 b1 00 00 00 48 =
8b 7a 20 48 8b 42 18 e8 56 a3 b5 00 f0 80 23 fd 48 89 ea 48 85 ed 74 53 <48=
> 8b 2a 48 8d 5a 08 f0 48 0f ba 6a 08 01 72 0b 8b 42 10 85 c0 74
[ 2068.591968] RSP: 0018:ffff98758c34be58 EFLAGS: 00010206
[ 2068.591969] RAX: ffff98758e6966d0 RBX: ffff98756e69aef8 RCX: 00000000000=
00006
[ 2068.591970] RDX: 01060a053d060305 RSI: 0000000000000006 RDI: ffff98758e6=
966d0
[ 2068.591971] RBP: 01060a053d060305 R08: 0000000000000000 R09: 00000000000=
203c0
[ 2068.591971] R10: 000003ff65b34f08 R11: 0000000000000001 R12: ffff98758e6=
966d0
[ 2068.591972] R13: 0000000000000006 R14: 0000000000000040 R15: 00000000000=
00006
[ 2068.591974] FS:  0000000000000000(0000) GS:ffff98758e680000(0000) knlGS:=
0000000000000000
[ 2068.591975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2068.591975] CR2: 00002c5f73a6cc20 CR3: 00000002f920a001 CR4: 00000000003=
606e0
[ 2068.591977] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2068.591978] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 2068.591978] Call Trace:
[ 2068.591985]  __do_softirq+0xe3/0x30a
[ 2068.591989]  ? sort_range+0x20/0x20
[ 2068.591990]  run_ksoftirqd+0x26/0x40
[ 2068.591992]  smpboot_thread_fn+0xc5/0x160
[ 2068.591995]  kthread+0x112/0x130
[ 2068.591997]  ? kthread_create_on_node+0x40/0x40
[ 2068.591998]  ret_from_fork+0x35/0x40
[ 2068.591999] Modules linked in: ccm arc4 fuse rfcomm cmac bnep sunrpc snd=
_hda_codec_hdmi snd_soc_skl snd_soc_core snd_soc_acpi_intel_match snd_hda_c=
odec_realtek snd_soc_acpi snd_hda_codec_generic snd_soc_skl_ipc snd_soc_sst=
_ipc snd_soc_sst_dsp snd_hda_ext_core iTCO_wdt snd_hda_intel intel_rapl iTC=
O_vendor_support x86_pkg_temp_thermal intel_powerclamp btusb mei_wdt corete=
mp btrtl snd_hda_codec btbcm btintel intel_cstate snd_hwdep intel_uncore uv=
cvideo snd_hda_core videobuf2_vmalloc videobuf2_memops intel_rapl_perf wmi_=
bmof videobuf2_v4l2 intel_wmi_thunderbolt snd_seq bluetooth joydev videobuf=
2_common snd_seq_device snd_pcm videodev media i2c_i801 snd_timer idma64 ec=
dh_generic intel_lpss_pci intel_lpss mei_me mei ucsi_acpi typec_ucsi proces=
sor_thermal_device intel_soc_dts_iosf intel_pch_thermal typec thinkpad_acpi=
 wmi snd soundcore rfkill int3403_thermal int340x_thermal_zone int3400_ther=
mal acpi_thermal_rel acpi_pad pcc_cpufreq uas usb_storage crc32c_intel i915=
 i2c_algo_bit nvme serio_raw
[ 2068.592033]  drm_kms_helper e1000e nvme_core drm video ipv6 [last unload=
ed: cfg80211]

Fortunate thing is that this not happen frequently, as scheduling
tasklet on blocked state is very exceptional, though might happen.

Due to different RX/TX tasklet processing fix is different for those.

For RX we have to assure rx_tasklet do fail to resubmit buffers
by poisoning urb's and kill the tasklet.

For TX we need to handle all stop cases properly (suspend, module
unload, device removal).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  7 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 10 +--
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |  8 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  1 -
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c      | 78 +++++++++++++------
 7 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wi=
reless/mediatek/mt76/mac80211.c
index 60b86ca00b3d..12c8f16096d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -390,7 +390,7 @@ void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, =
struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76_rx);
=20
-static bool mt76_has_tx_pending(struct mt76_dev *dev)
+bool mt76_has_tx_pending(struct mt76_dev *dev)
 {
 	struct mt76_queue *q;
 	int i;
@@ -403,6 +403,7 @@ static bool mt76_has_tx_pending(struct mt76_dev *dev)
=20
 	return false;
 }
+EXPORT_SYMBOL_GPL(mt76_has_tx_pending);
=20
 void mt76_set_channel(struct mt76_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wirele=
ss/mediatek/mt76/mt76.h
index 75a0d150a224..90d6e9df02a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -696,6 +696,7 @@ void mt76_release_buffered_frames(struct ieee80211_hw *=
hw,
 				  u16 tids, int nframes,
 				  enum ieee80211_frame_release_type reason,
 				  bool more_data);
+bool mt76_has_tx_pending(struct mt76_dev *dev);
 void mt76_set_channel(struct mt76_dev *dev);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
@@ -790,10 +791,10 @@ int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
-int mt76u_submit_rx_buffers(struct mt76_dev *dev);
 int mt76u_alloc_queues(struct mt76_dev *dev);
-void mt76u_stop_queues(struct mt76_dev *dev);
-void mt76u_stop_stat_wk(struct mt76_dev *dev);
+void mt76u_stop_tx(struct mt76_dev *dev);
+void mt76u_stop_rx(struct mt76_dev *dev);
+int mt76u_resume_rx(struct mt76_dev *dev);
 void mt76u_queues_deinit(struct mt76_dev *dev);
=20
 struct sk_buff *
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/=
wireless/mediatek/mt76/mt76x0/usb.c
index 53ec7dc38b9d..406ebfa74195 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -86,7 +86,7 @@ static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mt76.mac_work);
-	mt76u_stop_stat_wk(&dev->mt76);
+	mt76u_stop_tx(&dev->mt76);
 	mt76x02u_exit_beacon_config(dev);
=20
 	if (test_bit(MT76_REMOVED, &dev->mt76.state))
@@ -313,7 +313,7 @@ static int __maybe_unused mt76x0_suspend(struct usb_int=
erface *usb_intf,
 {
 	struct mt76x02_dev *dev =3D usb_get_intfdata(usb_intf);
=20
-	mt76u_stop_queues(&dev->mt76);
+	mt76u_stop_rx(&dev->mt76);
 	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
=20
@@ -323,16 +323,12 @@ static int __maybe_unused mt76x0_suspend(struct usb_i=
nterface *usb_intf,
 static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 {
 	struct mt76x02_dev *dev =3D usb_get_intfdata(usb_intf);
-	struct mt76_usb *usb =3D &dev->mt76.usb;
 	int ret;
=20
-	ret =3D mt76u_submit_rx_buffers(&dev->mt76);
+	ret =3D mt76u_resume_rx(&dev->mt76);
 	if (ret < 0)
 		goto err;
=20
-	tasklet_enable(&usb->rx_tasklet);
-	tasklet_enable(&dev->mt76.tx_tasklet);
-
 	ret =3D mt76x0u_init_hardware(dev);
 	if (ret)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/=
wireless/mediatek/mt76/mt76x2/usb.c
index c55ad617edce..7a994a783510 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -107,7 +107,7 @@ static int __maybe_unused mt76x2u_suspend(struct usb_in=
terface *intf,
 {
 	struct mt76x02_dev *dev =3D usb_get_intfdata(intf);
=20
-	mt76u_stop_queues(&dev->mt76);
+	mt76u_stop_rx(&dev->mt76);
=20
 	return 0;
 }
@@ -115,16 +115,12 @@ static int __maybe_unused mt76x2u_suspend(struct usb_=
interface *intf,
 static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 {
 	struct mt76x02_dev *dev =3D usb_get_intfdata(intf);
-	struct mt76_usb *usb =3D &dev->mt76.usb;
 	int err;
=20
-	err =3D mt76u_submit_rx_buffers(&dev->mt76);
+	err =3D mt76u_resume_rx(&dev->mt76);
 	if (err < 0)
 		goto err;
=20
-	tasklet_enable(&usb->rx_tasklet);
-	tasklet_enable(&dev->mt76.tx_tasklet);
-
 	err =3D mt76x2u_init_hardware(dev);
 	if (err < 0)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers=
/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 96ee596a69ec..f2c57d5b87f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -244,7 +244,6 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
=20
 void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 {
-	mt76u_stop_stat_wk(&dev->mt76);
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mt76.mac_work);
 	mt76x2u_mac_stop(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers=
/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index dcf67f4845be..305977a874a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -42,6 +42,7 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
=20
 	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	mt76u_stop_tx(&dev->mt76);
 	mt76x2u_stop_hw(dev);
 	mutex_unlock(&dev->mt76.mutex);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireles=
s/mediatek/mt76/usb.c
index d2c6718b5933..c299c6591072 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -540,7 +540,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 	rcu_read_unlock();
 }
=20
-int mt76u_submit_rx_buffers(struct mt76_dev *dev)
+static int mt76u_submit_rx_buffers(struct mt76_dev *dev)
 {
 	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
 	unsigned long flags;
@@ -558,7 +558,6 @@ int mt76u_submit_rx_buffers(struct mt76_dev *dev)
=20
 	return err;
 }
-EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
=20
 static int mt76u_alloc_rx(struct mt76_dev *dev)
 {
@@ -605,14 +604,29 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	memset(&q->rx_page, 0, sizeof(q->rx_page));
 }
=20
-static void mt76u_stop_rx(struct mt76_dev *dev)
+void mt76u_stop_rx(struct mt76_dev *dev)
 {
 	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
 	int i;
=20
 	for (i =3D 0; i < q->ndesc; i++)
-		usb_kill_urb(q->entry[i].urb);
+		usb_poison_urb(q->entry[i].urb);
+
+	tasklet_kill(&dev->usb.rx_tasklet);
+}
+EXPORT_SYMBOL_GPL(mt76u_stop_rx);
+
+int mt76u_resume_rx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
+	int i;
+
+	for (i =3D 0; i < q->ndesc; i++)
+		usb_unpoison_urb(q->entry[i].urb);
+
+	return mt76u_submit_rx_buffers(dev);
 }
+EXPORT_SYMBOL_GPL(mt76u_resume_rx);
=20
 static void mt76u_tx_tasklet(unsigned long data)
 {
@@ -834,38 +848,54 @@ static void mt76u_free_tx(struct mt76_dev *dev)
 	}
 }
=20
-static void mt76u_stop_tx(struct mt76_dev *dev)
+void mt76u_stop_tx(struct mt76_dev *dev)
 {
+	struct mt76_queue_entry entry;
 	struct mt76_queue *q;
-	int i, j;
+	int i, j, ret;
=20
-	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
-		q =3D dev->q_tx[i].q;
-		for (j =3D 0; j < q->ndesc; j++)
-			usb_kill_urb(q->entry[j].urb);
-	}
-}
+	ret =3D wait_event_timeout(dev->tx_wait, !mt76_has_tx_pending(dev), HZ/5);
+	if (!ret) {
+		dev_err(dev->dev, "timed out waiting for pending tx\n");
=20
-void mt76u_stop_queues(struct mt76_dev *dev)
-{
-	tasklet_disable(&dev->usb.rx_tasklet);
-	tasklet_disable(&dev->tx_tasklet);
+		for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
+			q =3D dev->q_tx[i].q;
+			for (j =3D 0; j < q->ndesc; j++)
+				usb_kill_urb(q->entry[j].urb);
+		}
=20
-	mt76u_stop_rx(dev);
-	mt76u_stop_tx(dev);
-}
-EXPORT_SYMBOL_GPL(mt76u_stop_queues);
+		tasklet_kill(&dev->tx_tasklet);
+
+		/* On device removal we maight queue skb's, but mt76u_tx_kick()
+		 * will fail to submit urb, cleanup those skb's manually.
+		 */
+		for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
+			q =3D dev->q_tx[i].q;
+
+			/* Assure we are in sync with killed tasklet. */
+			spin_lock_bh(&q->lock);
+			while (q->queued) {
+				entry =3D q->entry[q->head];
+				q->head =3D (q->head + 1) % q->ndesc;
+				q->queued--;
+
+				dev->drv->tx_complete_skb(dev, i, &entry);
+			}
+			spin_unlock_bh(&q->lock);
+		}
+	}
=20
-void mt76u_stop_stat_wk(struct mt76_dev *dev)
-{
 	cancel_delayed_work_sync(&dev->usb.stat_work);
 	clear_bit(MT76_READING_STATS, &dev->state);
+
+	mt76_tx_status_check(dev, NULL, true);
 }
-EXPORT_SYMBOL_GPL(mt76u_stop_stat_wk);
+EXPORT_SYMBOL_GPL(mt76u_stop_tx);
=20
 void mt76u_queues_deinit(struct mt76_dev *dev)
 {
-	mt76u_stop_queues(dev);
+	mt76u_stop_rx(dev);
+	mt76u_stop_tx(dev);
=20
 	mt76u_free_rx(dev);
 	mt76u_free_tx(dev);
--=20
2.20.1

