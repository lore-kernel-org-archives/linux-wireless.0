Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:41106 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXLGCMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 21:12:36 -0500
Received: by mu-out-0910.google.com with SMTP id i10so238487mue
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 18:12:34 -0800 (PST)
Date: Fri, 7 Dec 2007 10:12:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: 2.6.24-rc4-mm1
Message-ID: <20071207021258.GA12624@darkstar.lan> (sfid-20071207_021240_706499_1F908D5E)
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2.6.24-rc4-mm1 build failed at drivers/net/wireless/ath5k/base.c for some inline functions like this:
drivers/net/wireless/ath5k/base.c:292: sorry, unimplemented: inlining failed in call to 'ath5k_extend_tsf': function body not available

fix it with adjust the order of inline function body.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/net/wireless/ath5k/base.c |   67 ++++++++++++++++----------------------
1 file changed, 29 insertions(+), 38 deletions(-)

diff -upr linux/drivers/net/wireless/ath5k/base.c linux.new/drivers/net/wireless/ath5k/base.c
--- linux/drivers/net/wireless/ath5k/base.c	2007-12-07 10:01:42.000000000 +0800
+++ linux.new/drivers/net/wireless/ath5k/base.c	2007-12-07 10:01:49.000000000 +0800
@@ -250,8 +250,19 @@ static int 	ath5k_rxbuf_setup(struct ath
 static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf,
 				struct ieee80211_tx_control *ctl);
+
 static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
-				struct ath5k_buf *bf);
+				struct ath5k_buf *bf)
+{
+	BUG_ON(!bf);
+	if (!bf->skb)
+		return;
+	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
+			PCI_DMA_TODEVICE);
+	dev_kfree_skb(bf->skb);
+	bf->skb = NULL;
+}
+
 /* Queues setup */
 static struct 	ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
 				int qtype, int subtype);
@@ -278,14 +289,29 @@ static int 	ath5k_beacon_setup(struct at
 				struct ieee80211_tx_control *ctl);
 static void 	ath5k_beacon_send(struct ath5k_softc *sc);
 static void 	ath5k_beacon_config(struct ath5k_softc *sc);
-static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp);
+
+static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
+{
+	u64 tsf = ath5k_hw_get_tsf64(ah);
+
+	if ((tsf & 0x7fff) < rstamp)
+		tsf -= 0x8000;
+
+	return (tsf & ~0x7fff) | rstamp;
+}
+
 /* Interrupt handling */
 static int 	ath5k_init(struct ath5k_softc *sc);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
 static int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
-static inline void ath5k_update_txpow(struct ath5k_softc *sc);
+
+static inline void ath5k_update_txpow(struct ath5k_softc *sc)
+{
+	ath5k_hw_set_txpower_limit(sc->ah, 0);
+}
+
 static void 	ath5k_calibrate(unsigned long data);
 /* LED functions */
 static void 	ath5k_led_off(unsigned long data);
@@ -1341,21 +1367,6 @@ err_unmap:
 	return ret;
 }
 
-static inline void
-ath5k_txbuf_free(struct ath5k_softc *sc, struct ath5k_buf *bf)
-{
-	BUG_ON(!bf);
-	if (!bf->skb)
-		return;
-	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
-			PCI_DMA_TODEVICE);
-	dev_kfree_skb(bf->skb);
-	bf->skb = NULL;
-}
-
-
-
-
 /**************\
 * Queues setup *
 \**************/
@@ -2046,20 +2057,6 @@ ath5k_beacon_config(struct ath5k_softc *
 #undef TSF_TO_TU
 }
 
-static inline
-u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
-{
-	u64 tsf = ath5k_hw_get_tsf64(ah);
-
-	if ((tsf & 0x7fff) < rstamp)
-		tsf -= 0x8000;
-
-	return (tsf & ~0x7fff) | rstamp;
-}
-
-
-
-
 /********************\
 * Interrupt handling *
 \********************/
@@ -2295,12 +2292,6 @@ ath5k_tasklet_reset(unsigned long data)
 	ath5k_reset(sc->hw);
 }
 
-static inline void
-ath5k_update_txpow(struct ath5k_softc *sc)
-{
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
-}
-
 /*
  * Periodically recalibrate the PHY to account
  * for temperature/environment changes.
