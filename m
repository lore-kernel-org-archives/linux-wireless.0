Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41287 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbXKXWg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 17:36:58 -0500
Date: Sat, 24 Nov 2007 23:35:25 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5 V2] b43legacy: reinit on too many PHY TX errors
Message-ID: <20071124233525.7ba147f3@morte> (sfid-20071124_223702_790552_C15CCC40)
In-Reply-To: <20071124201301.797261738@polimi.it>
References: <20071124201107.785472828@polimi.it>
	<20071124201301.797261738@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restart the hardware on too many PHY TX errors. A thousand PHY TX errors
per 15 seconds means we won't be able to recover for sure.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -276,6 +276,8 @@
 #define B43legacy_DEFAULT_SHORT_RETRY_LIMIT	7
 #define B43legacy_DEFAULT_LONG_RETRY_LIMIT	4
 
+#define B43legacy_PHY_TX_BADNESS_LIMIT		1000
+
 /* Max size of a security key */
 #define B43legacy_SEC_KEYSIZE		16
 /* Security algorithms. */
@@ -511,6 +513,9 @@ struct b43legacy_phy {
 	u16 lofcal;
 
 	u16 initval;
+
+	/* PHY TX errors counter. */
+	atomic_t txerr_cnt;
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1221,8 +1221,15 @@ static void b43legacy_interrupt_tasklet(
 	if (unlikely(reason & B43legacy_IRQ_MAC_TXERR))
 		b43legacyerr(dev->wl, "MAC transmission error\n");
 
-	if (unlikely(reason & B43legacy_IRQ_PHY_TXERR))
+	if (unlikely(reason & B43legacy_IRQ_PHY_TXERR)) {
 		b43legacyerr(dev->wl, "PHY transmission error\n");
+		rmb();
+		if (unlikely(atomic_dec_and_test(&dev->phy.txerr_cnt))) {
+			b43legacyerr(dev->wl, "Too many PHY TX errors, "
+					      "restarting the controller\n");
+			b43legacy_controller_restart(dev, "PHY TX errors");
+		}
+	}
 
 	if (unlikely(merged_dma_reason & (B43legacy_DMAIRQ_FATALMASK |
 					  B43legacy_DMAIRQ_NONFATALMASK))) {
@@ -2094,6 +2101,9 @@ static int b43legacy_chip_init(struct b4
 	b43legacy_write16(dev, B43legacy_MMIO_POWERUP_DELAY,
 			  dev->dev->bus->chipco.fast_pwrup_delay);
 
+	/* PHY TX errors counter. */
+	atomic_set(&phy->txerr_cnt, B43legacy_PHY_TX_BADNESS_LIMIT);
+
 	B43legacy_WARN_ON(err != 0);
 	b43legacydbg(dev->wl, "Chip initialized\n");
 out:
@@ -2138,6 +2148,9 @@ static void b43legacy_periodic_every30se
 static void b43legacy_periodic_every15sec(struct b43legacy_wldev *dev)
 {
 	b43legacy_phy_xmitpower(dev); /* FIXME: unless scanning? */
+
+	atomic_set(&dev->phy.txerr_cnt, B43legacy_PHY_TX_BADNESS_LIMIT);
+	wmb();
 }
 
 static void do_periodic_work(struct b43legacy_wldev *dev)


-- 
Ciao
Stefano
