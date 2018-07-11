Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732348AbeGKMd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 08:33:57 -0400
Date: Wed, 11 Jul 2018 14:29:47 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: mt76x2e MCU message 31 timed out
Message-ID: <20180711122947.GA5309@redhat.com> (sfid-20180711_142956_097219_26BCCFDA)
References: <CAFED-jkby2sk9OQnuH5PD8isr0n_CM6Eufs7Ds5fhavYfYdLBw@mail.gmail.com>
 <20180622144809.GA9773@redhat.com>
 <CAFED-jkt6yoRjvAAJNs2Ob5Rq53s7qa1Ydpy-G2A7gkLDT7V2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
In-Reply-To: <CAFED-jkt6yoRjvAAJNs2Ob5Rq53s7qa1Ydpy-G2A7gkLDT7V2Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(correct Felix email address)

On Fri, Jun 22, 2018 at 05:51:53PM +0200, Janusz Dziedzic wrote:
> 2018-06-22 16:48 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> > Hi
> >
> > On Fri, Jun 22, 2018 at 10:37:35AM +0200, Janusz Dziedzic wrote:
> >> Have this card in my laptop:
> >> 02:00.0 Network controller: MEDIATEK Corp. Device 7612
> >>
> >> [    8.478104] mt76x2e 0000:02:00.0: ASIC revision: 76120044
> >> [    8.489582] mt76x2e 0000:02:00.0: ROM patch already applied
> >> [    8.833476] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
> >> [    8.833477] mt76x2e 0000:02:00.0: Build: 1
> >> [    8.833479] mt76x2e 0000:02:00.0: Build Time: 201507311614____
> >> [    8.856115] mt76x2e 0000:02:00.0: Firmware running!
> >> [    9.558075] mt76x2e 0000:02:00.0 wlp2s0: renamed from wlan1
> >
> > I'm just curious. Does the card was installed in the laptop by default?
> > If so what is the model of the laptop?
> >
> No, I just buy this card on aliexpress and put into some dell (MTK
> MT7612 2x2 half miniPCIE).
> 
> >> Linux test4 4.17.0-rc7+ #5 SMP Mon May 28 12:35:22 CEST 2018 x86_64 GNU/Linux
> >>
> >> Seems iw scan works correctly and first assoc. After will run some
> >> traffic (iperf in such case) get:
> >>
> >> [  432.372081] wlp2s0: associate with 52:b4:f7:f0:16:c2 (try 2/3)
> >> [  432.375255] wlp2s0: RX AssocResp from 52:b4:f7:f0:16:c2
> >> (capab=0x511 status=0 aid=2)
> >> [  432.375336] wlp2s0: associated
> >> [  432.451097] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
> >> [  522.562157] mt76x2e 0000:02:00.0: MCU message 31 (seq 13) timed out
> >> [  524.610281] mt76x2e 0000:02:00.0: MCU message 31 (seq 14) timed out
> >> [  526.658384] mt76x2e 0000:02:00.0: MCU message 31 (seq 15) timed out
> >> [  528.258455] mt76x2e 0000:02:00.0: MCU message 30 (seq 1) timed out
> >> [  529.282499] mt76x2e 0000:02:00.0: MCU message 30 (seq 2) timed out
> >> [  530.402544] mt76x2e 0000:02:00.0: MCU message 30 (seq 3) timed out
> >> [  531.426587] mt76x2e 0000:02:00.0: MCU message 30 (seq 4) timed out
> >> [  531.427444] wlp2s0: authenticate with 52:b4:f7:f0:14:ac
> >> [  532.450624] mt76x2e 0000:02:00.0: MCU message 30 (seq 5) timed out
> >> [  533.474666] mt76x2e 0000:02:00.0: MCU message 30 (seq 6) timed out
> >> [  534.498709] mt76x2e 0000:02:00.0: MCU message 30 (seq 7) timed out
> >> [  535.522736] mt76x2e 0000:02:00.0: MCU message 30 (seq 8) timed out
> >> [  535.522807] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 1/3)
> >> [  535.726740] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 2/3)
> >> [  535.930742] wlp2s0: send auth to 52:b4:f7:f0:14:ac (try 3/3)
> >> [  536.134747] wlp2s0: authentication with 52:b4:f7:f0:14:ac timed out
> >
> > I observed quite similar issue on some rt2800 devices when
> > I applied  this patch:
> > https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
> > It works on some devices and does not work on others with similar
> > symptoms - correctly associate but stop to work as soon as some
> > data traffic is performed.
> >
> > So, I would check if send IEEE80211_TX_CTL_RATE_CTRL_PROBE frames
> > with qsel = MT_QSEL_EDCA would help.
> >
> Thanks, will check this.

I guess it does not help? You can check attached patch instead
(note I only compile tested it).

Regards
Stanislaw
> 
> > Another thing to try is checkout vendor driver and see if there is need
> > to add extra code if device is_mt7612() .
> >
> > Regards
> > Stanislaw
> 
> 
> 
> -- 
> Janusz Dziedzic

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mt76x2-reset-HW-before-probe.patch"

>From 4f7cf0a78dd34b88f8158197e911624a5c4a862a Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 11 Jul 2018 14:22:28 +0200
Subject: [PATCH v2] mt76x2: reset HW before probe

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c  | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 71fcfa44fb2e..33318ac8fe81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -180,6 +180,7 @@ static inline void mt76x2_irq_disable(struct mt76x2_dev *dev, u32 mask)
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x2_dev *dev);
+void mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable);
 void mt76x2_init_debugfs(struct mt76x2_dev *dev);
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 79ab93613e06..782b350fee65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -498,7 +498,7 @@ void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
 		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
 }
 
-static void
+void
 mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
 {
 	u32 val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
index e66f047ea448..50f29d8393f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -54,6 +54,8 @@
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
 
+	mt76x2_set_wlan_state(dev, false);
+
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-- 
1.9.3


--Q68bSM7Ycu6FN28Q--
