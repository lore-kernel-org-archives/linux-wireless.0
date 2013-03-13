Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21027 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3CMMNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:31 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/14] wil6210: new SW reset
Date: Wed, 13 Mar 2013 14:12:49 +0200
Message-ID: <1363176771-10082-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131346_405515_ED91F961)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware allows for shorter SW reset procedure.
After SW reset, FW raises "fw done" IRQ, at this
moment mailbox control structures are initialized, driver caches it.

New status bit wil_status_reset_done introduced to track completion
of the reset. It is set by "fw ready" irq, and required for WMI rx flow
to access control structures.

WMI Tx flow protected by other status bit, wil_status_fwready. It can't
be set before wil_status_reset_done is set by design.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |   11 +++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |   23 -----------------------
 drivers/net/wireless/ath/wil6210/wil6210.h   |    1 +
 drivers/net/wireless/ath/wil6210/wmi.c       |    5 +++++
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index de9b971..e3c1e76 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -240,6 +240,15 @@ static void wil_notify_fw_error(struct wil6210_priv *wil)
 	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
+static void wil_cache_mbox_regs(struct wil6210_priv *wil)
+{
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+}
+
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
@@ -268,6 +277,8 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
+		wil_cache_mbox_regs(wil);
+		set_bit(wil_status_reset_done, &wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f11efa4..9d05628 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -103,15 +103,6 @@ static void wil_connect_timer_fn(ulong x)
 	schedule_work(&wil->disconnect_worker);
 }
 
-static void wil_cache_mbox_regs(struct wil6210_priv *wil)
-{
-	/* make shadow copy of registers that should not change on run time */
-	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
-			     sizeof(struct wil6210_mbox_ctl));
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
-}
-
 static void wil_connect_worker(struct work_struct *work)
 {
 	int rc;
@@ -161,8 +152,6 @@ int wil_priv_init(struct wil6210_priv *wil)
 		return -EAGAIN;
 	}
 
-	wil_cache_mbox_regs(wil);
-
 	return 0;
 }
 
@@ -199,15 +188,11 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
 
-	msleep(100);
-
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000170);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
 
-	msleep(100);
-
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
@@ -217,12 +202,6 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
-	msleep(2000);
-
-	W(RGF_USER_USER_CPU_0, BIT(0)); /* user_cpu_man_de_rst */
-
-	msleep(2000);
-
 	wil_dbg_misc(wil, "Reset completed\n");
 
 #undef W
@@ -279,8 +258,6 @@ int wil_reset(struct wil6210_priv *wil)
 	wil->pending_connect_cid = -1;
 	INIT_COMPLETION(wil->wmi_ready);
 
-	wil_cache_mbox_regs(wil);
-
 	/* TODO: release MAC reset */
 	wil6210_enable_irq(wil);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 5f500de..2ec7258 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -186,6 +186,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_fwready = 0,
 	wil_status_fwconnected,
 	wil_status_dontscan,
+	wil_status_reset_done,
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8d9e145..ed2b097 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -585,6 +585,11 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 	void __iomem *src;
 	ulong flags;
 
+	if (!test_bit(wil_status_reset_done, &wil->status)) {
+		wil_err(wil, "Reset not completed\n");
+		return;
+	}
+
 	for (;;) {
 		u16 len;
 
-- 
1.7.10.4

