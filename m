Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46403
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXKYKL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 05:11:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: reinit on too many PHY TX errors
Date: Sun, 25 Nov 2007 11:10:33 +0100
Cc: stefano.brivio@polimi.it, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200711251110.33613.mb@bu3sch.de> (sfid-20071125_101159_694602_86D5BC92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stefano Brivio <stefano.brivio@polimi.it>

Restart the hardware on too many PHY TX errors. A thousand PHY TX errors
per 15 seconds means we won't be able to recover for sure.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h
+++ wireless-2.6/drivers/net/wireless/b43/b43.h
@@ -391,6 +391,8 @@ enum {
 #define B43_DEFAULT_SHORT_RETRY_LIMIT	7
 #define B43_DEFAULT_LONG_RETRY_LIMIT	4
 
+#define B43_PHY_TX_BADNESS_LIMIT	1000
+
 /* Max size of a security key */
 #define B43_SEC_KEYSIZE			16
 /* Security algorithms. */
@@ -546,6 +548,9 @@ struct b43_phy {
 	/* OFDM address read/write caching for hardware auto-increment. */
 	u16 ofdm_addr;
 	u8 ofdm_valid; /* 0: invalid, 1: read, 2: write */
+
+	/* PHY TX errors counter. */
+	atomic_t txerr_cnt;
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -1394,8 +1394,17 @@ static void b43_interrupt_tasklet(struct
 	if (unlikely(reason & B43_IRQ_MAC_TXERR))
 		b43err(dev->wl, "MAC transmission error\n");
 
-	if (unlikely(reason & B43_IRQ_PHY_TXERR))
+	if (unlikely(reason & B43_IRQ_PHY_TXERR)) {
 		b43err(dev->wl, "PHY transmission error\n");
+		rmb();
+		if (unlikely(atomic_dec_and_test(&dev->phy.txerr_cnt))) {
+			atomic_set(&dev->phy.txerr_cnt,
+				   B43_PHY_TX_BADNESS_LIMIT);
+			b43err(dev->wl, "Too many PHY TX errors, "
+					"restarting the controller\n");
+			b43_controller_restart(dev, "PHY TX errors");
+		}
+	}
 
 	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK |
 					  B43_DMAIRQ_NONFATALMASK))) {
@@ -2259,6 +2268,9 @@ static int b43_chip_init(struct b43_wlde
 	/* OFDM address caching. */
 	phy->ofdm_valid = 0;
 
+	/* PHY TX errors counter. */
+	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
+
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
 out:
@@ -2344,6 +2356,9 @@ static void b43_periodic_every15sec(stru
 	}
 	b43_phy_xmitpower(dev);	//FIXME: unless scanning?
 	//TODO for APHY (temperature?)
+
+	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
+	wmb();
 }
 
 static void do_periodic_work(struct b43_wldev *dev)


-------------------------------------------------------

-- 
Greetings Michael.
