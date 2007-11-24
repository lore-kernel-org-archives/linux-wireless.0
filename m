Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38403 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752677AbXKXWg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 17:36:58 -0500
Date: Sat, 24 Nov 2007 23:35:13 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/5 V2] b43: reinit on too many PHY TX errors
Message-ID: <20071124233513.134a6ae6@morte> (sfid-20071124_223703_700502_0192A530)
In-Reply-To: <200711242131.27870.mb@bu3sch.de>
References: <20071124201107.785472828@polimi.it>
	<20071124201107.785472828@polimi.it>
	<20071124201301.178475691@polimi.it>
	<200711242131.27870.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restart the hardware on too many PHY TX errors. A thousand PHY TX errors
per 15 seconds means we won't be able to recover for sure.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

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


-- 
Ciao
Stefano
