Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:40622 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754446AbXKTJJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 04:09:35 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: 
Date: Tue, 20 Nov 2007 18:09:27 +0900
Message-Id: <1195549767-21983-1-git-send-email-bruno@thinktube.com> (sfid-20071120_090955_945359_A7EBE237)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    ath5k: more consistent debug, info and error logging

    * added 4 new macros AR5K_INFO, AR5K_WARN, AR5K_ERR and AR5K_DBG, and changed all
    printk, most dev_info and most AR5K_PRINTF lines to use these macros instead.
    they get a reference to sc, so we can automatically add additional information:
    right now they prepend "ath5k phyX:" to all strings, but it would be possible
    to switch to dev_info/warn/... instead too. i think using "phyX" makes the
    output more readable and easier to match with the output from mac80211. in
    cases where we don't have sc available we still use AR5K_PRINTF.
    this is mostly cosmetics, but it's important for distinguishing log messages
    between different cards in setups with more than one atheros card.

    * deleted AR5K_PRINT because it's easy to use AR5K_PRINTF instead.

    * moved all debugging related stuff to debug.h and debug.c

    * added debugfs entry (ath5k/phyX/debug) to control the debug level for
    each device

    * consistent use of AR5K_DBG instead of DPRINTF and others. AR5K_DBG honors the
    debugging flags set on module load or by debugfs. moved all instances where the
    debugging output was controlled by additional defines (like ATH_DUMP_SKB) to
    use these debugging flags too.

    * better skb dumping, allowing control wether we want to see RX or TX frames.

    for base.c
    Changes-licensed-under: 3-clause-BSD

    for all others...
    Changes-licensed-under: ISC

    Signed-off-by: Bruno Randolf <bruno@thinktube.com>
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
index f27560b..321641f 100644
--- a/drivers/net/wireless/ath5k/Makefile
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -1,2 +1,2 @@
-ath5k-objs		= base.o hw.o regdom.o initvals.o phy.o
+ath5k-objs		= base.o hw.o regdom.o initvals.o phy.o debug.o
 obj-$(CONFIG_ATH5K)	+= ath5k.o
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index c5e37d2..27593d6 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -25,8 +25,8 @@
  * you've been warned. */
 #define CHAN_DEBUG	0
 
-/* Uncomment this for debuging (warning that it results in TOO much output) */
-/* #define AR5K_DEBUG	1 */
+/* set this to 1 for debugging output */
+#define AR5K_DEBUG	0
 
 #include <linux/io.h>
 #include <linux/types.h>
@@ -70,12 +70,25 @@
 \****************************/
 
 #define AR5K_PRINTF(fmt, ...)   printk("%s: " fmt, __func__, ##__VA_ARGS__)
-#define AR5K_PRINT(fmt)         printk("%s: " fmt, __func__)
-#ifdef AR5K_DEBUG
-#define AR5K_TRACE              printk(KERN_DEBUG "%s:%d\n", __func__, __LINE__)
-#else
-#define AR5K_TRACE
-#endif
+
+#define AR5K_PRINTK(_sc, _level, _fmt, ...) \
+	printk(_level "ath5k %s: " _fmt, \
+		((_sc) && (_sc)->hw) ? wiphy_name((_sc)->hw->wiphy) : "", \
+		##__VA_ARGS__)
+
+#define AR5K_PRINTK_LIMIT(_sc, _level, _fmt, ...) do { \
+	if (net_ratelimit()) \
+		AR5K_PRINTK(_sc, _level, _fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define AR5K_INFO(_sc, _fmt, ...) \
+	AR5K_PRINTK(_sc, KERN_INFO, _fmt, ##__VA_ARGS__)
+
+#define AR5K_WARN(_sc, _fmt, ...) \
+	AR5K_PRINTK_LIMIT(_sc, KERN_WARNING, _fmt, ##__VA_ARGS__)
+
+#define AR5K_ERR(_sc, _fmt, ...) \
+	AR5K_PRINTK_LIMIT(_sc, KERN_ERR, _fmt, ##__VA_ARGS__)
 
 /*
  * Some tuneable values (these should be changeable by the user)
@@ -1095,7 +1108,6 @@ extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 i
 /* Regulatory Domain/Channels Setup */
 extern u16 ath5k_get_regdomain(struct ath5k_hw *ah);
 /* Misc functions */
-extern void ath5k_hw_dump_state(struct ath5k_hw *ah);
 extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
 
 
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 77e3855..6ca7ebf 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -56,40 +56,12 @@
 
 #include "base.h"
 #include "reg.h"
-
-#define ATH_DEBUG_MODES		0 /* Show found modes in the log? */
-#define ATH_DUMP_SKB		0 /* show skb contents */
-#define AR_DEBUG		1
+#include "debug.h"
 
 /* unaligned little endian access */
 #define LE_READ_2(_p) (le16_to_cpu(get_unaligned((__le16 *)(_p))))
 #define LE_READ_4(_p) (le32_to_cpu(get_unaligned((__le32 *)(_p))))
 
-#if AR_DEBUG
-#define	DPRINTF(sc, _m, _fmt...) do {				\
-	if (unlikely(((sc)->debug & (_m)) && net_ratelimit()))	\
-		printk(KERN_DEBUG _fmt);			\
-} while (0)
-#else
-static inline int __attribute__ ((format (printf, 3, 4)))
-DPRINTF(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...)
-{
-	return 0;
-}
-#endif
-enum {
-	ATH_DEBUG_XMIT		= 0x00000001,	/* basic xmit operation */
-	ATH_DEBUG_RESET		= 0x00000020,	/* reset processing */
-	ATH_DEBUG_MODE		= 0x00000040,	/* mode init/setup */
-	ATH_DEBUG_BEACON	= 0x00000080,	/* beacon handling */
-	ATH_DEBUG_INTR		= 0x00001000,	/* ISR */
-	ATH_DEBUG_BEACON_PROC	= 0x00008000,	/* beacon ISR proc */
-	ATH_DEBUG_CALIBRATE	= 0x00010000,	/* periodic calibration */
-	ATH_DEBUG_LED		= 0x00100000,	/* led management */
-	ATH_DEBUG_FATAL		= 0x80000000,	/* fatal errors */
-	ATH_DEBUG_ANY		= 0xffffffff
-};
-
 enum {
 	ATH_LED_TX,
 	ATH_LED_RX,
@@ -97,73 +69,6 @@ enum {
 
 static int ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
 
-#if AR_DEBUG
-static unsigned int ath5k_debug;
-module_param_named(debug, ath5k_debug, uint, 0);
-#endif
-
-#if AR_DEBUG
-static void ath5k_printrxbuf(struct ath5k_buf *bf, int done)
-{
-	struct ath5k_desc *ds = bf->desc;
-
-	printk(KERN_DEBUG "R (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
-		ds, (unsigned long long)bf->daddr,
-		ds->ds_link, ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
-		ds->ds_hw[0], ds->ds_hw[1],
-		!done ? ' ' : (ds->ds_rxstat.rs_status == 0) ? '*' : '!');
-}
-
-static void ath5k_printtxbuf(struct ath5k_buf *bf, int done)
-{
-	struct ath5k_desc *ds = bf->desc;
-
-	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
-		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
-		ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
-		ds->ds_hw[0], ds->ds_hw[1], ds->ds_hw[2], ds->ds_hw[3],
-		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
-}
-#endif
-
-#if ATH_DUMP_SKB
-static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix)
-{
-	print_hex_dump_bytes(prefix, DUMP_PREFIX_NONE, skb->data,
-			min(200U, skb->len));
-}
-#else
-static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix) {}
-#endif
-
-#if ATH_DEBUG_MODES
-static void ath5k_dump_modes(struct ieee80211_hw_mode *modes)
-{
-	unsigned int m, i;
-
-	for (m = 0; m < NUM_DRIVER_MODES; m++) {
-		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
-				modes[m].num_channels, modes[m].num_rates);
-		printk(KERN_DEBUG " channels:\n");
-		for (i = 0; i < modes[m].num_channels; i++)
-			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
-					modes[m].channels[i].chan,
-					modes[m].channels[i].freq,
-					modes[m].channels[i].val,
-					modes[m].channels[i].flag);
-		printk(KERN_DEBUG " rates:\n");
-		for (i = 0; i < modes[m].num_rates; i++)
-			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
-					modes[m].rates[i].rate,
-					modes[m].rates[i].val,
-					modes[m].rates[i].flags,
-					modes[m].rates[i].val2);
-	}
-}
-#else
-static inline void ath5k_dump_modes(struct ieee80211_hw_mode *modes) {}
-#endif
-
 
 /******************\
 * Internal defines *
@@ -399,6 +304,8 @@ init_ath5k_pci(void)
 {
 	int ret;
 
+	ath5k_debug_init();
+
 	ret = pci_register_driver(&ath5k_pci_drv_id);
 	if (ret) {
 		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
@@ -412,6 +319,8 @@ static void __exit
 exit_ath5k_pci(void)
 {
 	pci_unregister_driver(&ath5k_pci_drv_id);
+
+	ath5k_debug_finish();
 }
 
 module_init(init_ath5k_pci);
@@ -519,6 +428,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		goto err_map;
 	}
 
+	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
+
 	/* Initialize driver private data */
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
@@ -529,13 +440,12 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->hw = hw;
 	sc->pdev = pdev;
 
+	ath5k_debug_init_device(sc);
+
 	/*
 	 * Mark the device as detached to avoid processing
 	 * interrupts until setup is complete.
 	 */
-#if AR_DEBUG
-	sc->debug = ath5k_debug;
-#endif
 	__set_bit(ATH_STAT_INVALID, sc->status);
 
 	sc->iobase = mem; /* So we can unmap it on detach */
@@ -554,7 +464,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	/* Setup interrupt handler */
 	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed\n");
+		AR5K_ERR(sc, "request_irq failed\n");
 		goto err_free;
 	}
 
@@ -570,7 +480,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_ah;
 
-	dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
+	AR5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
 			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
 					sc->ah->ah_mac_srev,
 					sc->ah->ah_phy_revision);
@@ -580,27 +490,28 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
 			/* No 5GHz support -> report 2GHz radio */
 			if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
-				dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
+				AR5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 							sc->ah->ah_radio_5ghz_revision);
 			/* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
 			} else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
-				dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
+				AR5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 							sc->ah->ah_radio_5ghz_revision);
 			/* Multiband radio */
 			} else {
-				dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
+				AR5K_INFO(sc, "RF%s multiband radio found"
+					" (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 							sc->ah->ah_radio_5ghz_revision);
 			}
 		}
 		/* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
 		else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
-			dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
+			AR5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
 				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
 						sc->ah->ah_radio_5ghz_revision);
-			dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
+			AR5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
 				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
 						sc->ah->ah_radio_2ghz_revision);
 		}
@@ -634,6 +545,7 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
 
+	ath5k_debug_finish_device(sc);
 	ath5k_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
 	free_irq(pdev->irq, sc);
@@ -710,7 +622,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	unsigned int i;
 	int ret;
 
-	DPRINTF(sc, ATH_DEBUG_ANY, "%s: devid 0x%x\n", __func__, pdev->device);
+	AR5K_DBG(sc, ATH_DEBUG_ANY, "devid 0x%x\n", pdev->device);
 
 	/*
 	 * Check if the MAC has multi-rate retry support.
@@ -737,7 +649,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 */
 	ret = ath5k_getchannels(hw);
 	if (ret) {
-		dev_err(&pdev->dev, "can't get channels\n");
+		AR5K_ERR(sc, "can't get channels\n");
 		goto err;
 	}
 
@@ -752,7 +664,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 */
 	ret = ath5k_desc_alloc(sc, pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "can't allocate descriptors\n");
+		AR5K_ERR(sc, "can't allocate descriptors\n");
 		goto err;
 	}
 
@@ -764,14 +676,14 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 */
 	ret = ath5k_beaconq_setup(ah);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
+		AR5K_ERR(sc, "can't setup a beacon xmit queue\n");
 		goto err_desc;
 	}
 	sc->bhalq = ret;
 
 	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
 	if (IS_ERR(sc->txq)) {
-		dev_err(&pdev->dev, "can't setup xmit queue\n");
+		AR5K_ERR(sc, "can't setup xmit queue\n");
 		ret = PTR_ERR(sc->txq);
 		goto err_bhal;
 	}
@@ -810,7 +722,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
-		dev_err(&pdev->dev, "can't register ieee80211 hw\n");
+		AR5K_ERR(sc, "can't register ieee80211 hw\n");
 		goto err_queues;
 	}
 
@@ -944,7 +856,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		chfreq = CHANNEL_2GHZ;
 		break;
 	default:
-		printk(KERN_WARNING "bad mode, not copying channels\n");
+		AR5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
 		return 0;
 	}
 
@@ -998,7 +910,7 @@ ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
 			continue;
 		ret = ieee80211_register_hwmode(hw, &modes[i]);
 		if (ret) {
-			printk(KERN_ERR "can't register hwmode %u\n", m);
+			AR5K_ERR(sc, "can't register hwmode %u\n", m);
 			return ret;
 		}
 		return 0;
@@ -1061,7 +973,7 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 		REGISTER_MODE(MODE_IEEE80211B);
 	REGISTER_MODE(MODE_IEEE80211A);
 
-	ath5k_dump_modes(modes);
+	ath5k_debug_dump_modes(sc, modes);
 
 	return ret;
 }
@@ -1078,8 +990,8 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: %u (%u MHz) -> %u (%u MHz)\n",
-		__func__, sc->curchan->chan, sc->curchan->freq,
+	AR5K_DBG(sc, ATH_DEBUG_RESET, "%u (%u MHz) -> %u (%u MHz)\n",
+		sc->curchan->chan, sc->curchan->freq,
 		chan->chan, chan->freq);
 
 	if (chan->freq != sc->curchan->freq || chan->val != sc->curchan->val) {
@@ -1094,7 +1006,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		ath5k_rx_stop(sc);		/* turn off frame recv */
 		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
 		if (ret) {
-			printk(KERN_ERR "%s: unable to reset channel %u "
+			AR5K_ERR(sc, "%s: unable to reset channel %u "
 				"(%u Mhz)\n", __func__, chan->chan, chan->freq);
 			return ret;
 		}
@@ -1106,7 +1018,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		 */
 		ret = ath5k_rx_start(sc);
 		if (ret) {
-			printk(KERN_ERR "%s: unable to restart recv logic\n",
+			AR5K_ERR(sc, "%s: unable to restart recv logic\n",
 					__func__);
 			return ret;
 		}
@@ -1208,7 +1120,7 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	ath5k_hw_set_opmode(ah);
 
 	ath5k_hw_set_mcast_filter(ah, 0, 0);
-	DPRINTF(sc, ATH_DEBUG_MODE, "%s: RX filter 0x%x\n", __func__, rfilt);
+	AR5K_DBG(sc, ATH_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
 
@@ -1232,19 +1144,19 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
 	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
 	if (sc->desc == NULL) {
-		dev_err(&pdev->dev, "can't allocate descriptors\n");
+		AR5K_ERR(sc, "can't allocate descriptors\n");
 		ret = -ENOMEM;
 		goto err;
 	}
 	ds = sc->desc;
 	da = sc->desc_daddr;
-	DPRINTF(sc, ATH_DEBUG_ANY, "%s: DMA map: %p (%zu) -> %llx\n",
-		__func__, ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
+	AR5K_DBG(sc, ATH_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
+		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
 
 	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
 			sizeof(struct ath5k_buf), GFP_KERNEL);
 	if (bf == NULL) {
-		dev_err(&pdev->dev, "can't allocate bufptr\n");
+		AR5K_ERR(sc, "can't allocate bufptr\n");
 		ret = -ENOMEM;
 		goto err_free;
 	}
@@ -1320,7 +1232,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		 */
 		skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
 		if (unlikely(skb == NULL)) {
-			printk(KERN_ERR "ath: can't alloc skbuff of size %u\n",
+			AR5K_ERR(sc, "can't alloc skbuff of size %u\n",
 					sc->rxbufsize + sc->cachelsz - 1);
 			return -ENOMEM;
 		}
@@ -1337,7 +1249,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		bf->skbaddr = pci_map_single(sc->pdev,
 			skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
 		if (unlikely(pci_dma_mapping_error(bf->skbaddr))) {
-			printk(KERN_ERR "%s: DMA mapping failed\n", __func__);
+			AR5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 			dev_kfree_skb(skb);
 			bf->skb = NULL;
 			return -ENOMEM;
@@ -1482,7 +1394,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		return ERR_PTR(qnum);
 	}
 	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
+		AR5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
 			qnum, ARRAY_SIZE(sc->txqs));
 		ath5k_hw_release_tx_queue(ah, qnum);
 		return ERR_PTR(-EINVAL);
@@ -1535,7 +1447,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 
 	ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret) {
-		printk(KERN_ERR "%s: unable to update parameters for beacon "
+		AR5K_ERR(sc, "%s: unable to update parameters for beacon "
 			"hardware queue!\n", __func__);
 		return ret;
 	}
@@ -1554,11 +1466,9 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	 */
 	spin_lock_bh(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-#if AR_DEBUG
-		if (sc->debug & ATH_DEBUG_RESET)
-			ath5k_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
-						bf->desc));
-#endif
+		ath5k_debug_printtxbuf(sc, bf, !sc->ah->ah_proc_tx_desc(sc->ah,
+					bf->desc));
+
 		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
@@ -1584,13 +1494,13 @@ ath5k_txq_cleanup(struct ath5k_softc *sc)
 	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
 		/* don't touch the hardware if marked invalid */
 		(void)ath5k_hw_stop_tx_dma(ah, sc->bhalq);
-		DPRINTF(sc, ATH_DEBUG_RESET, "%s: beacon queue %x\n", __func__,
+		AR5K_DBG(sc, ATH_DEBUG_RESET, "beacon queue %x\n",
 			ath5k_hw_get_tx_buf(ah, sc->bhalq));
 		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 			if (sc->txqs[i].setup) {
 				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
-				DPRINTF(sc, ATH_DEBUG_RESET, "%s: txq [%u] %x, "
-					"link %p\n", __func__,
+				AR5K_DBG(sc, ATH_DEBUG_RESET, "txq [%u] %x, "
+					"link %p\n",
 					sc->txqs[i].qnum,
 					ath5k_hw_get_tx_buf(ah,
 							sc->txqs[i].qnum),
@@ -1636,8 +1546,8 @@ ath5k_rx_start(struct ath5k_softc *sc)
 
 	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->cachelsz);
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: cachelsz %u rxbufsize %u\n",
-		__func__, sc->cachelsz, sc->rxbufsize);
+	AR5K_DBG(sc, ATH_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
+		sc->cachelsz, sc->rxbufsize);
 
 	sc->rxlink = NULL;
 
@@ -1674,25 +1584,9 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
 	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
 	mdelay(3);			/* 3ms is long enough for 1 frame */
-#if AR_DEBUG
-	if (unlikely(sc->debug & (ATH_DEBUG_RESET | ATH_DEBUG_FATAL))) {
-		struct ath5k_desc *ds;
-		struct ath5k_buf *bf;
-		int status;
-
-		printk(KERN_DEBUG "%s: rx queue %x, link %p\n", __func__,
-			ath5k_hw_get_rx_buf(ah), sc->rxlink);
-
-		spin_lock_bh(&sc->rxbuflock);
-		list_for_each_entry(bf, &sc->rxbuf, list) {
-			ds = bf->desc;
-			status = ah->ah_proc_rx_desc(ah, ds);
-			if (!status || (sc->debug & ATH_DEBUG_FATAL))
-				ath5k_printrxbuf(bf, status == 0);
-		}
-		spin_unlock_bh(&sc->rxbuflock);
-	}
-#endif
+
+	ath5k_debug_printrxbuffs(sc, ah);
+
 	sc->rxlink = NULL;		/* just in case */
 }
 
@@ -1739,8 +1633,7 @@ ath5k_tasklet_rx(unsigned long data)
 	spin_lock(&sc->rxbuflock);
 	do {
 		if (unlikely(list_empty(&sc->rxbuf))) {
-			if (net_ratelimit())
-				printk(KERN_WARNING "ath: empty rx buf pool\n");
+			AR5K_WARN(sc, "empty rx buf pool\n");
 			break;
 		}
 		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
@@ -1759,15 +1652,12 @@ ath5k_tasklet_rx(unsigned long data)
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
-			if (net_ratelimit())
-				printk(KERN_ERR "ath: error in processing rx "
-					"descriptor\n");
+			AR5K_ERR(sc, "error in processing rx descriptor\n");
 			return;
 		}
 
 		if (unlikely(ds->ds_rxstat.rs_more)) {
-			if (net_ratelimit())
-				printk(KERN_INFO "ath: unsupported jumbo\n");
+			AR5K_WARN(sc, "unsupported jumbo\n");
 			goto next;
 		}
 
@@ -1836,7 +1726,7 @@ accept:
 		rxs.rate = ds->ds_rxstat.rs_rate;
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
 
-		ath5k_dump_skb(skb, "RX  ");
+		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
 		sc->led_rxrate = ds->ds_rxstat.rs_rate;
@@ -1874,8 +1764,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
-			printk(KERN_ERR "ath: error %d while processing "
-				"queue %u\n", ret, txq->qnum);
+			AR5K_ERR(sc, "error %d while processing queue %u\n",
+				ret, txq->qnum);
 			break;
 		}
 
@@ -1946,11 +1836,11 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
 			PCI_DMA_TODEVICE);
-	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: skb %p [data %p len %u] "
-			"skbaddr %llx\n", __func__, skb, skb->data, skb->len,
+	AR5K_DBG(sc, ATH_DEBUG_BEACON, "skb %p [data %p len %u] "
+			"skbaddr %llx\n", skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
 	if (pci_dma_mapping_error(bf->skbaddr)) {
-		printk(KERN_ERR "ath: beacon DMA mapping failed\n");
+		AR5K_ERR(sc, "beacon DMA mapping failed\n");
 		return -EIO;
 	}
 
@@ -2002,12 +1892,11 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	struct ath5k_buf *bf = sc->bbuf;
 	struct ath5k_hw *ah = sc->ah;
 
-	DPRINTF(sc, ATH_DEBUG_BEACON_PROC, "%s\n", __func__);
+	AR5K_DBG(sc, ATH_DEBUG_BEACON_PROC, "in beacon_send\n");
 
 	if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
 			sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
-		printk(KERN_WARNING "ath: bf=%p bf_skb=%p\n", bf,
-				bf ? bf->skb : NULL);
+		AR5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
 		return;
 	}
 	/*
@@ -2019,21 +1908,20 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 */
 	if (unlikely(ath5k_hw_num_tx_pending(ah, sc->bhalq) != 0)) {
 		sc->bmisscount++;
-		DPRINTF(sc, ATH_DEBUG_BEACON_PROC,
-			"%s: missed %u consecutive beacons\n",
-			__func__, sc->bmisscount);
+		AR5K_DBG(sc, ATH_DEBUG_BEACON_PROC,
+			"missed %u consecutive beacons\n", sc->bmisscount);
 		if (sc->bmisscount > 3) {		/* NB: 3 is a guess */
-			DPRINTF(sc, ATH_DEBUG_BEACON_PROC,
-				"%s: stuck beacon time (%u missed)\n",
-				__func__, sc->bmisscount);
+			AR5K_DBG(sc, ATH_DEBUG_BEACON_PROC,
+				"stuck beacon time (%u missed)\n",
+				sc->bmisscount);
 			tasklet_schedule(&sc->restq);
 		}
 		return;
 	}
 	if (unlikely(sc->bmisscount != 0)) {
-		DPRINTF(sc, ATH_DEBUG_BEACON_PROC,
-			"%s: resume beacon xmit after %u misses\n",
-			__func__, sc->bmisscount);
+		AR5K_DBG(sc, ATH_DEBUG_BEACON_PROC,
+			"resume beacon xmit after %u misses\n",
+			sc->bmisscount);
 		sc->bmisscount = 0;
 	}
 
@@ -2043,8 +1931,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 * are still pending on the queue.
 	 */
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
-		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
-				sc->bhalq);
+		AR5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
 	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
@@ -2052,8 +1939,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
 	ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_tx_start(ah, sc->bhalq);
-	DPRINTF(sc, ATH_DEBUG_BEACON_PROC, "%s: TXDP[%u] = %llx (%p)\n",
-		__func__, sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
+	AR5K_DBG(sc, ATH_DEBUG_BEACON_PROC, "TXDP[%u] = %llx (%p)\n",
+		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
 	sc->bsent++;
 }
@@ -2089,8 +1976,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	tsf = ath5k_hw_get_tsf64(ah);
 	tsftu = TSF_TO_TU((u32)(tsf >> 32), (u32)tsf);
 
-	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: intval %u hw tsftu %u\n", __func__,
-			intval, tsftu);
+	AR5K_DBG(sc, ATH_DEBUG_BEACON, "intval %u hw tsftu %u\n",
+		intval, tsftu);
 
 	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
 			(sc->opmode == IEEE80211_IF_TYPE_IBSS &&
@@ -2109,8 +1996,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 			 */
 			nexttbtt = tsftu + 2 * intval;
 
-			DPRINTF(sc, ATH_DEBUG_BEACON, "%s: nexttbtt %u "
-				"intval %u\n", __func__, nexttbtt, intval);
+			AR5K_DBG(sc, ATH_DEBUG_BEACON, "nexttbtt %u "
+				"intval %u\n", nexttbtt, intval);
 
 			/*
 			 * In IBSS mode enable the beacon timers but only
@@ -2166,7 +2053,7 @@ ath5k_init(struct ath5k_softc *sc)
 
 	mutex_lock(&sc->lock);
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: mode %d\n", __func__, sc->opmode);
+	AR5K_DBG(sc, ATH_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
 	 * Stop anything previously setup.  This is safe
@@ -2184,7 +2071,7 @@ ath5k_init(struct ath5k_softc *sc)
 	sc->curchan = sc->hw->conf.chan;
 	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
 	if (ret) {
-		printk(KERN_ERR "unable to reset hardware: %d\n", ret);
+		AR5K_ERR(sc, "unable to reset hardware: %d\n", ret);
 		goto done;
 	}
 	/*
@@ -2228,7 +2115,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "%s: invalid %u\n", __func__,
+	AR5K_DBG(sc, ATH_DEBUG_RESET, "invalid %u\n",
 			test_bit(ATH_STAT_INVALID, sc->status));
 
 	/*
@@ -2295,11 +2182,11 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 			 * don't put newer MAC revisions > 7.8 to sleep because
 			 * of the above mentioned problems
 			 */
-			DPRINTF(sc, ATH_DEBUG_RESET, "%s: mac version > 7.8, "
-				"not putting device to sleep\n", __func__);
+			AR5K_DBG(sc, ATH_DEBUG_RESET, "mac version > 7.8, "
+				"not putting device to sleep\n");
 		} else {
-			DPRINTF(sc, ATH_DEBUG_RESET,
-				"%s: putting device to full sleep\n", __func__);
+			AR5K_DBG(sc, ATH_DEBUG_RESET,
+				"putting device to full sleep\n");
 			ath5k_hw_set_power(sc->ah, AR5K_PM_FULL_SLEEP, true, 0);
 		}
 	}
@@ -2331,7 +2218,7 @@ ath5k_intr(int irq, void *dev_id)
 		 * value to insure we only process bits we requested.
 		 */
 		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
-		DPRINTF(sc, ATH_DEBUG_INTR, "%s: status 0x%x/0x%x\n", __func__,
+		AR5K_DBG(sc, ATH_DEBUG_INTR, "status 0x%x/0x%x\n",
 				status, sc->imask);
 		status &= sc->imask; /* discard unasked for bits */
 		if (unlikely(status & AR5K_INT_FATAL)) {
@@ -2376,9 +2263,8 @@ ath5k_intr(int irq, void *dev_id)
 		}
 	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
 
-	if (unlikely(!counter && net_ratelimit()))
-		printk(KERN_WARNING "ath: too many interrupts, giving up for "
-				"now\n");
+	if (unlikely(!counter))
+		AR5K_WARN(sc, "too many interrupts, giving up for now\n");
 
 	return IRQ_HANDLED;
 }
@@ -2407,7 +2293,7 @@ ath5k_calibrate(unsigned long data)
 	struct ath5k_softc *sc = (void *)data;
 	struct ath5k_hw *ah = sc->ah;
 
-	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath: channel %u/%x\n",
+	AR5K_DBG(sc, ATH_DEBUG_CALIBRATE, "channel %u/%x\n",
 		sc->curchan->chan, sc->curchan->val);
 
 	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
@@ -2415,11 +2301,11 @@ ath5k_calibrate(unsigned long data)
 		 * Rfgain is out of bounds, reset the chip
 		 * to load new gain values.
 		 */
-		DPRINTF(sc, ATH_DEBUG_RESET, "calibration, resetting\n");
+		AR5K_DBG(sc, ATH_DEBUG_RESET, "calibration, resetting\n");
 		ath5k_reset(sc->hw);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
-		printk(KERN_ERR "ath: calibration of channel %u failed\n",
+		AR5K_ERR(sc, "calibration of channel %u failed\n",
 				sc->curchan->chan);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
@@ -2453,7 +2339,7 @@ static void
 ath5k_led_blink(struct ath5k_softc *sc, unsigned int on,
 		unsigned int off)
 {
-	DPRINTF(sc, ATH_DEBUG_LED, "%s: on %u off %u\n", __func__, on, off);
+	AR5K_DBG(sc, ATH_DEBUG_LED, "on %u off %u\n", on, off);
 	ath5k_hw_set_gpio(sc->ah, sc->led_pin, sc->led_on);
 	__set_bit(ATH_STAT_LEDBLINKING, sc->status);
 	__clear_bit(ATH_STAT_LEDENDBLINK, sc->status);
@@ -2497,10 +2383,10 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	int hdrlen;
 	int pad;
 
-	ath5k_dump_skb(skb, "TX  ");
+	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
 	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
-		DPRINTF(sc, ATH_DEBUG_XMIT, "tx in monitor (scan?)\n");
+		AR5K_DBG(sc, ATH_DEBUG_XMIT, "tx in monitor (scan?)\n");
 
 	/*
 	 * the hardware expects the header padded to 4 byte boundaries
@@ -2510,10 +2396,9 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (hdrlen & 3) {
 		pad = hdrlen % 4;
 		if (skb_headroom(skb) < pad) {
-			if (net_ratelimit())
-				printk(KERN_ERR "ath: tx hdrlen not %%4: %d "
-					"not enough headroom to pad %d\n",
-					hdrlen, pad);
+			AR5K_ERR(sc, "tx hdrlen not %%4: %d "
+				"not enough headroom to pad %d\n",
+				hdrlen, pad);
 			return -1;
 		}
 		skb_push(skb, pad);
@@ -2524,9 +2409,8 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
-		if (net_ratelimit())
-			printk(KERN_ERR "ath: no further txbuf available, "
-				"dropping packet\n");
+		AR5K_ERR(sc, "no further txbuf available, "
+			"dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
 		ieee80211_stop_queue(hw, ctl->queue);
 		return -1;
@@ -2560,7 +2444,7 @@ ath5k_reset(struct ieee80211_hw *hw)
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
-	DPRINTF(sc, ATH_DEBUG_RESET, "resetting\n");
+	AR5K_DBG(sc, ATH_DEBUG_RESET, "resetting\n");
 	/*
 	 * Convert to a hw channel description with the flags
 	 * constrained to reflect the current operating mode.
@@ -2573,14 +2457,14 @@ ath5k_reset(struct ieee80211_hw *hw)
 
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ath: can't reset hardware (%d)\n", ret);
+		AR5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
 	}
 	ath5k_update_txpow(sc);
 
 	ret = ath5k_rx_start(sc);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ath: can't start recv logic\n");
+		AR5K_ERR(sc, "can't start recv logic\n");
 		goto err;
 	}
 	/*
@@ -2845,7 +2729,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case SET_KEY:
 		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key, addr);
 		if (ret) {
-			printk(KERN_ERR "ath: can't set the key\n");
+			AR5K_ERR(sc, "can't set the key\n");
 			goto unlock;
 		}
 		__set_bit(key->keyidx, sc->keymap);
@@ -2910,7 +2794,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
 
-	ath5k_dump_skb(skb, "BC  ");
+	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
 	mutex_lock(&sc->lock);
 
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index c13e54b..94e71ca 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -100,7 +100,9 @@ struct ath5k_softc {
 	enum ieee80211_if_types	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
-	int			debug;
+	unsigned int		debug;
+	struct dentry		*debugfs_phydir;
+	struct dentry		*debugfs_debug;
 
 	struct ath5k_buf	*bufptr;	/* allocated buffer ptr */
 	struct ath5k_desc	*desc;		/* TX/RX descriptors */
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
new file mode 100644
index 0000000..ee9ec69
--- /dev/null
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -0,0 +1,256 @@
+/*
+ * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "debug.h"
+
+#if AR5K_DEBUG
+
+#include "reg.h"
+
+static unsigned int ath5k_debug;
+
+module_param_named(debug, ath5k_debug, uint, 0);
+
+static struct dentry *ath5k_global_debugfs;
+
+void
+ath5k_debug_init(void)
+{
+	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
+}
+
+void
+ath5k_debug_init_device(struct ath5k_softc *sc)
+{
+	sc->debug = ath5k_debug;
+	sc->debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
+				ath5k_global_debugfs);
+	sc->debugfs_debug = debugfs_create_u32("debug",
+				0666, sc->debugfs_phydir, &sc->debug);
+}
+
+void
+ath5k_debug_finish(void)
+{
+	debugfs_remove(ath5k_global_debugfs);
+}
+
+void
+ath5k_debug_finish_device(struct ath5k_softc *sc)
+{
+	debugfs_remove(sc->debugfs_debug);
+	debugfs_remove(sc->debugfs_phydir);
+}
+
+void
+ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode *modes)
+{
+	unsigned int m, i;
+
+	if (likely(!(sc->debug & ATH_DEBUG_DUMPMODES)))
+		return;
+
+	for (m = 0; m < NUM_DRIVER_MODES; m++) {
+		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
+				modes[m].num_channels, modes[m].num_rates);
+		printk(KERN_DEBUG " channels:\n");
+		for (i = 0; i < modes[m].num_channels; i++)
+			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
+					modes[m].channels[i].chan,
+					modes[m].channels[i].freq,
+					modes[m].channels[i].val,
+					modes[m].channels[i].flag);
+		printk(KERN_DEBUG " rates:\n");
+		for (i = 0; i < modes[m].num_rates; i++)
+			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
+					modes[m].rates[i].rate,
+					modes[m].rates[i].val,
+					modes[m].rates[i].flags,
+					modes[m].rates[i].val2);
+	}
+}
+
+void
+ath5k_debug_dump_hwstate(struct ath5k_hw *ah)
+{
+	if (!(ah->ah_sc->debug & ATH_DEBUG_DUMPSTATE))
+		return;
+
+#define AR5K_PRINT_REGISTER(_x)						\
+	AR5K_PRINTF("(%s: %08x)\n", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
+
+	AR5K_PRINTF("MAC registers:\n");
+	AR5K_PRINT_REGISTER(CR);
+	AR5K_PRINT_REGISTER(CFG);
+	AR5K_PRINT_REGISTER(IER);
+	AR5K_PRINT_REGISTER(TXCFG);
+	AR5K_PRINT_REGISTER(RXCFG);
+	AR5K_PRINT_REGISTER(MIBC);
+	AR5K_PRINT_REGISTER(TOPS);
+	AR5K_PRINT_REGISTER(RXNOFRM);
+	AR5K_PRINT_REGISTER(RPGTO);
+	AR5K_PRINT_REGISTER(RFCNT);
+	AR5K_PRINT_REGISTER(MISC);
+	AR5K_PRINT_REGISTER(PISR);
+	AR5K_PRINT_REGISTER(SISR0);
+	AR5K_PRINT_REGISTER(SISR1);
+	AR5K_PRINT_REGISTER(SISR3);
+	AR5K_PRINT_REGISTER(SISR4);
+	AR5K_PRINT_REGISTER(DCM_ADDR);
+	AR5K_PRINT_REGISTER(DCM_DATA);
+	AR5K_PRINT_REGISTER(DCCFG);
+	AR5K_PRINT_REGISTER(CCFG);
+	AR5K_PRINT_REGISTER(CCFG_CUP);
+	AR5K_PRINT_REGISTER(CPC0);
+	AR5K_PRINT_REGISTER(CPC1);
+	AR5K_PRINT_REGISTER(CPC2);
+	AR5K_PRINT_REGISTER(CPCORN);
+	AR5K_PRINT_REGISTER(QCU_TXE);
+	AR5K_PRINT_REGISTER(QCU_TXD);
+	AR5K_PRINT_REGISTER(DCU_GBL_IFS_SIFS);
+	AR5K_PRINT_REGISTER(DCU_GBL_IFS_SLOT);
+	AR5K_PRINT_REGISTER(DCU_FP);
+	AR5K_PRINT_REGISTER(DCU_TXP);
+	AR5K_PRINT_REGISTER(DCU_TX_FILTER);
+	AR5K_PRINT_REGISTER(INTPEND);
+	AR5K_PRINT_REGISTER(PCICFG);
+	AR5K_PRINT_REGISTER(GPIOCR);
+	AR5K_PRINT_REGISTER(GPIODO);
+	AR5K_PRINT_REGISTER(SREV);
+	AR5K_PRINT_REGISTER(EEPROM_BASE);
+	AR5K_PRINT_REGISTER(EEPROM_DATA);
+	AR5K_PRINT_REGISTER(EEPROM_CMD);
+	AR5K_PRINT_REGISTER(EEPROM_CFG);
+	AR5K_PRINT_REGISTER(PCU_MIN);
+	AR5K_PRINT_REGISTER(STA_ID0);
+	AR5K_PRINT_REGISTER(STA_ID1);
+	AR5K_PRINT_REGISTER(BSS_ID0);
+	AR5K_PRINT_REGISTER(SLOT_TIME);
+	AR5K_PRINT_REGISTER(TIME_OUT);
+	AR5K_PRINT_REGISTER(RSSI_THR);
+	AR5K_PRINT_REGISTER(BEACON);
+	AR5K_PRINT_REGISTER(CFP_PERIOD);
+	AR5K_PRINT_REGISTER(TIMER0);
+	AR5K_PRINT_REGISTER(TIMER2);
+	AR5K_PRINT_REGISTER(TIMER3);
+	AR5K_PRINT_REGISTER(CFP_DUR);
+	AR5K_PRINT_REGISTER(MCAST_FILTER0);
+	AR5K_PRINT_REGISTER(MCAST_FILTER1);
+	AR5K_PRINT_REGISTER(DIAG_SW);
+	AR5K_PRINT_REGISTER(TSF_U32);
+	AR5K_PRINT_REGISTER(ADDAC_TEST);
+	AR5K_PRINT_REGISTER(DEFAULT_ANTENNA);
+	AR5K_PRINT_REGISTER(LAST_TSTP);
+	AR5K_PRINT_REGISTER(NAV);
+	AR5K_PRINT_REGISTER(RTS_OK);
+	AR5K_PRINT_REGISTER(ACK_FAIL);
+	AR5K_PRINT_REGISTER(FCS_FAIL);
+	AR5K_PRINT_REGISTER(BEACON_CNT);
+	AR5K_PRINT_REGISTER(TSF_PARM);
+	AR5K_PRINTF("\n");
+
+	AR5K_PRINTF("PHY registers:\n");
+	AR5K_PRINT_REGISTER(PHY_TURBO);
+	AR5K_PRINT_REGISTER(PHY_AGC);
+	AR5K_PRINT_REGISTER(PHY_TIMING_3);
+	AR5K_PRINT_REGISTER(PHY_CHIP_ID);
+	AR5K_PRINT_REGISTER(PHY_AGCCTL);
+	AR5K_PRINT_REGISTER(PHY_NF);
+	AR5K_PRINT_REGISTER(PHY_SCR);
+	AR5K_PRINT_REGISTER(PHY_SLMT);
+	AR5K_PRINT_REGISTER(PHY_SCAL);
+	AR5K_PRINT_REGISTER(PHY_RX_DELAY);
+	AR5K_PRINT_REGISTER(PHY_IQ);
+	AR5K_PRINT_REGISTER(PHY_PAPD_PROBE);
+	AR5K_PRINT_REGISTER(PHY_TXPOWER_RATE1);
+	AR5K_PRINT_REGISTER(PHY_TXPOWER_RATE2);
+	AR5K_PRINT_REGISTER(PHY_RADAR);
+	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_0);
+	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_1);
+	AR5K_PRINTF("\n");
+}
+
+static inline void
+ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done)
+{
+	struct ath5k_desc *ds = bf->desc;
+
+	printk(KERN_DEBUG "R (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
+		ds, (unsigned long long)bf->daddr,
+		ds->ds_link, ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
+		ds->ds_hw[0], ds->ds_hw[1],
+		!done ? ' ' : (ds->ds_rxstat.rs_status == 0) ? '*' : '!');
+}
+
+void
+ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
+{
+	struct ath5k_desc *ds;
+	struct ath5k_buf *bf;
+	int status;
+
+	if (likely(!(sc->debug & (ATH_DEBUG_RESET | ATH_DEBUG_FATAL))))
+		return;
+
+	printk(KERN_DEBUG "rx queue %x, link %p\n",
+		ath5k_hw_get_rx_buf(ah), sc->rxlink);
+
+	spin_lock_bh(&sc->rxbuflock);
+	list_for_each_entry(bf, &sc->rxbuf, list) {
+		ds = bf->desc;
+		status = ah->ah_proc_rx_desc(ah, ds);
+		if (!status || (sc->debug & ATH_DEBUG_FATAL))
+			ath5k_debug_printrxbuf(bf, status == 0);
+	}
+	spin_unlock_bh(&sc->rxbuflock);
+}
+
+void
+ath5k_debug_dump_skb(struct ath5k_softc *sc,
+			struct sk_buff *skb, const char *prefix, int tx)
+{
+	char buf[16];
+
+	if (likely(!((tx && (sc->debug & ATH_DEBUG_DUMP_TX)) ||
+		     (!tx && (sc->debug & ATH_DEBUG_DUMP_RX)))))
+		return;
+
+	snprintf(buf, sizeof(buf), "%s %s", wiphy_name(sc->hw->wiphy), prefix);
+
+	print_hex_dump_bytes(buf, DUMP_PREFIX_NONE, skb->data,
+		min(200U, skb->len));
+
+	printk(KERN_DEBUG "\n");
+}
+
+void
+ath5k_debug_printtxbuf(struct ath5k_softc *sc,
+			struct ath5k_buf *bf, int done)
+{
+	struct ath5k_desc *ds = bf->desc;
+
+	if (likely(!(sc->debug & ATH_DEBUG_RESET)))
+		return;
+
+	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
+		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
+		ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
+		ds->ds_hw[0], ds->ds_hw[1], ds->ds_hw[2], ds->ds_hw[3],
+		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
+}
+
+#endif /* if AR5K_DEBUG */
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
new file mode 100644
index 0000000..d166395
--- /dev/null
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _ATH5K_DEBUG_H
+#define _ATH5K_DEBUG_H
+
+#include "base.h"
+
+#if AR5K_DEBUG
+
+enum {
+	ATH_DEBUG_RESET		= 0x00000001,	/* reset processing */
+	ATH_DEBUG_INTR		= 0x00000002,	/* ISR */
+	ATH_DEBUG_MODE		= 0x00000004,	/* mode init/setup */
+	ATH_DEBUG_XMIT		= 0x00000008,	/* basic xmit operation */
+	ATH_DEBUG_BEACON	= 0x00000010,	/* beacon handling */
+	ATH_DEBUG_BEACON_PROC	= 0x00000020,	/* beacon ISR proc */
+	ATH_DEBUG_CALIBRATE	= 0x00000100,	/* periodic calibration */
+	ATH_DEBUG_TXPOWER	= 0x00000200,	/* transmit power */
+	ATH_DEBUG_LED		= 0x00000400,	/* led management */
+	ATH_DEBUG_DUMP_RX	= 0x00001000,	/* print received skb content */
+	ATH_DEBUG_DUMP_TX	= 0x00002000,	/* print transmit skb content */
+	ATH_DEBUG_DUMPSTATE	= 0x00004000,	/* dump register state */
+	ATH_DEBUG_DUMPMODES	= 0x00008000,	/* dump modes */
+	ATH_DEBUG_TRACE		= 0x00010000,	/* trace function calls */
+	ATH_DEBUG_FATAL		= 0x80000000,	/* fatal errors */
+	ATH_DEBUG_ANY		= 0xffffffff
+};
+
+#define AR5K_TRACE(_sc) do { \
+	if (unlikely((_sc)->debug & ATH_DEBUG_TRACE)) \
+		printk(KERN_DEBUG "ath5k trace %s:%d\n", __func__, __LINE__); \
+	} while (0)
+
+#define AR5K_DBG(_sc, _m, _fmt, ...) do { \
+	if (unlikely((_sc)->debug & (_m) && net_ratelimit())) \
+		AR5K_PRINTK(_sc, KERN_DEBUG, "(%s:%d): " _fmt, \
+			__func__, __LINE__, ##__VA_ARGS__); \
+	} while (0)
+
+void
+ath5k_debug_init(void);
+
+void
+ath5k_debug_init_device(struct ath5k_softc *sc);
+
+void
+ath5k_debug_finish(void);
+
+void
+ath5k_debug_finish_device(struct ath5k_softc *sc);
+
+void
+ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah);
+
+void
+ath5k_debug_dump_modes(struct ath5k_softc *sc,
+			struct ieee80211_hw_mode *modes);
+
+void
+ath5k_debug_dump_hwstate(struct ath5k_hw *ah);
+
+void
+ath5k_debug_dump_skb(struct ath5k_softc *sc,
+			struct sk_buff *skb, const char *prefix, int tx);
+
+void
+ath5k_debug_printtxbuf(struct ath5k_softc *sc,
+			struct ath5k_buf *bf, int done);
+
+#else /* no debugging */
+
+#define AR5K_TRACE(_sc)
+
+#define AR5K_DBG(...) do { } while (0)
+
+static inline void
+ath5k_debug_init(void) {}
+
+static inline void
+ath5k_debug_init_device(struct ath5k_softc *sc) {}
+
+static inline void
+ath5k_debug_finish(void) {}
+
+static inline void
+ath5k_debug_finish_device(struct ath5k_softc *sc) {}
+
+static inline void
+ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah) {}
+
+static inline void
+ath5k_debug_dump_modes(struct ath5k_softc *sc,
+			struct ieee80211_hw_mode *modes) {}
+
+static inline void
+ath5k_debug_dump_hwstate(struct ath5k_hw *ah) {}
+
+static inline void
+ath5k_debug_dump_skb(struct ath5k_softc *sc,
+			struct sk_buff *skb, const char *prefix, int tx) {}
+
+static inline void
+ath5k_debug_printtxbuf(struct ath5k_softc *sc,
+			struct ath5k_buf *bf, int done) {}
+
+#endif
+
+#endif
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 4aca069..484d702 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -29,6 +29,7 @@
 
 #include "reg.h"
 #include "base.h"
+#include "debug.h"
 
 /*Rate tables*/
 static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
@@ -128,7 +129,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
 	if (ah == NULL) {
 		ret = -ENOMEM;
-		AR5K_PRINT("out of memory\n");
+		AR5K_ERR(sc, "out of memory\n");
 		goto err;
 	}
 
@@ -203,14 +204,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	/* Return on unsuported chips (unsupported eeprom etc) */
 	if(srev >= AR5K_SREV_VER_AR5416){
-		printk(KERN_ERR "ath5k: Device not yet supported.\n");
+		AR5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
 		goto err_free;
 	}
 
 	/* Warn for partially supported chips (unsupported phy etc) */
 	if(srev >= AR5K_SREV_VER_AR2424){
-		printk(KERN_DEBUG "ath5k: Device partially supported.\n");
+		AR5K_WARN(sc, "Device only partially supported.\n");
 	}
 
 	/* Identify single chip solutions */
@@ -238,9 +239,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	ah->ah_phy = AR5K_PHY(0);
 
-#ifdef AR5K_DEBUG
-	ath5k_hw_dump_state(ah);
-#endif
+	ath5k_debug_dump_hwstate(ah);
 
 	/*
 	 * Get card capabilities, values, ...
@@ -248,14 +247,14 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	ret = ath5k_eeprom_init(ah);
 	if (ret) {
-		AR5K_PRINT("unable to init EEPROM\n");
+		AR5K_ERR(sc, "unable to init EEPROM\n");
 		goto err_free;
 	}
 
 	/* Get misc capabilities */
 	ret = ath5k_hw_get_capabilities(ah);
 	if (ret) {
-		AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
+		AR5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
 			sc->pdev->device);
 		goto err_free;
 	}
@@ -263,7 +262,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	/* Get MAC address */
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
-		AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
+		AR5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
 			sc->pdev->device);
 		goto err_free;
 	}
@@ -295,7 +294,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	mode = 0;
 	clock = 0;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_version != AR5K_AR5210) {
 		/*
@@ -328,7 +327,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
 			} else {
-				AR5K_PRINT("invalid radio modulation mode\n");
+				AR5K_ERR(ah->ah_sc,
+					"invalid radio modulation mode\n");
 				return -EINVAL;
 			}
 		} else if (flags & CHANNEL_5GHZ) {
@@ -338,11 +338,12 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			if (flags & CHANNEL_OFDM)
 				mode |= AR5K_PHY_MODE_MOD_OFDM;
 			else {
-				AR5K_PRINT("invalid radio modulation mode\n");
+				AR5K_ERR(ah->ah_sc,
+					"invalid radio modulation mode\n");
 				return -EINVAL;
 			}
 		} else {
-			AR5K_PRINT("invalid radio frequency mode\n");
+			AR5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
 			return -EINVAL;
 		}
 
@@ -352,7 +353,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		if (initial == true) {
 			/* ...reset hardware */
 			if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCI)) {
-				AR5K_PRINT("failed to reset the PCI chipset\n");
+				AR5K_ERR(ah->ah_sc,
+					"failed to reset the PCI chipset\n");
 				return -EIO;
 			}
 
@@ -362,7 +364,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		/* ...wakeup */
 		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
-			AR5K_PRINT("failed to resume the MAC Chip\n");
+			AR5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
 			return ret;
 		}
 
@@ -373,7 +375,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 		/* ...reset chipset */
 		if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_CHIP)) {
-			AR5K_PRINT("failed to reset the AR5210 chipset\n");
+			AR5K_ERR(ah->ah_sc,
+				"failed to reset the AR5210 chipset\n");
 			return -EIO;
 		}
 
@@ -383,7 +386,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	/* ...reset chipset and PCI device */
 	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
 				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
-		AR5K_PRINT("failed to reset the MAC Chip + PCI\n");
+		AR5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}
 
@@ -393,13 +396,13 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	/* ...wakeup */
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
-		AR5K_PRINT("failed to resume the MAC Chip\n");
+		AR5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
 		return ret;
 	}
 
 	/* ...final warm reset */
 	if (ath5k_hw_nic_reset(ah, 0)) {
-		AR5K_PRINT("failed to warm reset the MAC Chip\n");
+		AR5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
 		return -EIO;
 	}
 
@@ -421,7 +424,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah,
 		unsigned int mode)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (!test_bit(mode, ah->ah_capabilities.cap_mode))
 		return NULL;
@@ -448,7 +451,7 @@ const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah,
  */
 void ath5k_hw_detach(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_rf_banks != NULL)
 		kfree(ah->ah_rf_banks);
@@ -594,7 +597,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	unsigned int i, mode, freq, ee_mode, ant[2], driver_mode = -1;
 	int ret;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	s_seq = 0;
 	s_ant = 1;
@@ -643,7 +646,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		if (ah->ah_radio != AR5K_RF5111 &&
 			ah->ah_radio != AR5K_RF5112 &&
 			ah->ah_radio != AR5K_RF5413) {
-			AR5K_PRINTF("invalid phy radio: %u\n", ah->ah_radio);
+			AR5K_ERR(ah->ah_sc,
+				"invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
 		}
 
@@ -681,7 +685,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 			break;
 		case CHANNEL_XR:
 			if (ah->ah_version == AR5K_AR5211) {
-				AR5K_PRINTF("XR mode not available on 5211");
+				AR5K_ERR(ah->ah_sc,
+					"XR mode not available on 5211");
 				return -EINVAL;
 			}
 			mode = AR5K_INI_VAL_XR;
@@ -690,7 +695,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 			driver_mode = MODE_IEEE80211A;
 			break;
 		default:
-			AR5K_PRINTF("invalid channel: %d\n", channel->freq);
+			AR5K_ERR(ah->ah_sc, "invalid channel: %d\n",
+				channel->freq);
 			return -EINVAL;
 		}
 
@@ -905,7 +911,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
-		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
+		AR5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
+			channel->freq);
 		return -EAGAIN;
 	}
 
@@ -917,7 +924,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false)) {
-		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
+		AR5K_ERR(ah->ah_sc,
+				"noise floor calibration timeout (%uMHz)\n",
 				channel->freq);
 		return -EAGAIN;
 	}
@@ -935,7 +943,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	}
 
 	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
-		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
+		AR5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
 			channel->freq);
 		return -EIO;
 	}
@@ -962,7 +970,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 
 		ret = ath5k_hw_reset_tx_queue(ah, i);
 		if (ret) {
-			AR5K_PRINTF("failed to reset TX queue #%d\n", i);
+			AR5K_ERR(ah->ah_sc,
+				"failed to reset TX queue #%d\n", i);
 			return ret;
 		}
 	}
@@ -1019,7 +1028,7 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 	int ret;
 	u32 mask = val ? val : ~0U;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/* Read-and-clear RX Descriptor Pointer*/
 	ath5k_hw_reg_read(ah, AR5K_RXDP);
@@ -1066,7 +1075,7 @@ int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 	unsigned int i;
 	u32 staid;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
 
 	switch (mode) {
@@ -1140,7 +1149,7 @@ commit:
  */
 void ath5k_hw_start_rx(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
 }
 
@@ -1151,7 +1160,7 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 {
 	unsigned int i;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
 
 	/*
@@ -1178,7 +1187,7 @@ u32 ath5k_hw_get_rx_buf(struct ath5k_hw *ah)
  */
 void ath5k_hw_put_rx_buf(struct ath5k_hw *ah, u32 phys_addr)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*TODO:Shouldn't we check if RX is enabled first ?*/
 	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
@@ -1196,7 +1205,7 @@ int ath5k_hw_tx_start(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 tx_queue;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -1249,7 +1258,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 	unsigned int i = 100;
 	u32 tx_queue, pending;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -1308,7 +1317,7 @@ u32 ath5k_hw_get_tx_buf(struct ath5k_hw *ah, unsigned int queue)
 {
 	u16 tx_reg;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
@@ -1342,7 +1351,7 @@ int ath5k_hw_put_tx_buf(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
 {
 	u16 tx_reg;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
@@ -1387,7 +1396,7 @@ int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
 	u32 trigger_level, imr;
 	int ret = -EIO;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*
 	 * Disable interrupts by setting the mask
@@ -1434,7 +1443,7 @@ done:
  */
 bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	return ath5k_hw_reg_read(ah, AR5K_INTPEND);
 }
 
@@ -1445,7 +1454,7 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
 	u32 data;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*
 	 * Read interrupt status from the Interrupt Status register
@@ -1569,7 +1578,7 @@ static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
 {
 	u32 status, timeout;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*
 	 * Initialize EEPROM access
 	 */
@@ -1605,7 +1614,7 @@ static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
 #if 0
 	u32 status, timeout;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*
 	 * Initialize eeprom access
@@ -1856,7 +1865,7 @@ static int ath5k_eeprom_init(struct ath5k_hw *ah)
 		cksum ^= val;
 	}
 	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		AR5K_PRINTF("Invalid EEPROM checksum 0x%04x\n", cksum);
+		AR5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
 		return -EIO;
 	}
 #endif
@@ -2103,7 +2112,7 @@ static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
 {
 	u16 ee_header;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/* Capabilities stored in the EEPROM */
 	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
 
@@ -2194,7 +2203,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 	pcu_reg = 0;
 	beacon_reg = 0;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	switch (ah->ah_op_mode) {
 	case IEEE80211_IF_TYPE_IBSS:
@@ -2251,7 +2260,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
  */
 void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	memcpy(mac, ah->ah_sta_id, ETH_ALEN);
 }
 
@@ -2262,7 +2271,7 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
 	u32 low_id, high_id;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/* Set new station ID */
 	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
 
@@ -2408,7 +2417,7 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
 	u32 low_id, high_id;
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_version == AR5K_AR5212) {
 		low_id = AR5K_LOW_ID(mask);
@@ -2432,7 +2441,7 @@ int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
  */
 void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
@@ -2441,7 +2450,7 @@ void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
  */
 void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
@@ -2454,7 +2463,7 @@ void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
  */
 void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/* Set the multicat filter */
 	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
 	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
@@ -2466,7 +2475,7 @@ void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index)
 {
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
@@ -2484,7 +2493,7 @@ int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index)
 int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
 {
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
@@ -2503,7 +2512,7 @@ u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
 {
 	u32 data, filter = 0;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	filter = ath5k_hw_reg_read(ah, AR5K_RX_FILTER);
 
 	/*Radar detection for 5212*/
@@ -2526,7 +2535,7 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 {
 	u32 data = 0;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/* Set PHY error filter register on 5212*/
 	if (ah->ah_version == AR5K_AR5212) {
@@ -2569,7 +2578,7 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
  */
 u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	return ath5k_hw_reg_read(ah, AR5K_TSF_L32);
 }
 
@@ -2579,7 +2588,7 @@ u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
 u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
 	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
 }
@@ -2589,7 +2598,7 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
  */
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
 }
 
@@ -2600,7 +2609,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 {
 	u32 timer1, timer2, timer3;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*
 	 * Set the additional timers by mode
 	 */
@@ -2658,7 +2667,7 @@ int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
 	u32 cfp_count = 0; /* XXX */
 	u32 tsf = 0; /* XXX */
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/* Return on an invalid beacon state */
 	if (state->bs_interval < 1)
 		return -EINVAL;
@@ -2770,7 +2779,7 @@ int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
  */
 void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*
 	 * Disable beacon timer
 	 */
@@ -2793,7 +2802,7 @@ int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr)
 	unsigned int i;
 	int ret;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/* 5210 doesn't have QCU*/
 	if (ah->ah_version == AR5K_AR5210) {
@@ -2840,7 +2849,7 @@ int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr)
 void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
 		struct ath5k_mib_stats *statistics)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/* Read-And-Clear */
 	statistics->ackrcv_bad += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
 	statistics->rts_bad += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
@@ -2885,7 +2894,7 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
  */
 int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
 			ah->ah_turbo) <= timeout)
 		return -EINVAL;
@@ -2901,7 +2910,7 @@ int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
  */
 unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
 			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
@@ -2912,7 +2921,7 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
  */
 int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
 			ah->ah_turbo) <= timeout)
 		return -EINVAL;
@@ -2928,7 +2937,7 @@ int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
  */
 unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
 			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
 }
@@ -2941,7 +2950,7 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 {
 	unsigned int i;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
@@ -2957,7 +2966,7 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 
 int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	/* Check the validation flag at the end of the entry */
@@ -2972,7 +2981,7 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 	__le32 key_v[5] = {};
 	u32 keytype;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/* key->keylen comes in from mac80211 in bytes */
 
@@ -3018,7 +3027,7 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 low_id, high_id;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	 /* Invalid entry (key table overflow) */
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
@@ -3052,7 +3061,7 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	unsigned int queue;
 	int ret;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*
 	 * Get queue by type
@@ -3092,8 +3101,9 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 			break;
 		case AR5K_TX_QUEUE_XR_DATA:
 			if (ah->ah_version != AR5K_AR5212)
-				AR5K_PRINTF("XR data queues only supported in "
-						"5212!\n");
+				AR5K_ERR(ah->ah_sc,
+					"XR data queues only supported"
+					" in 5212!\n");
 			queue = AR5K_TX_QUEUE_ID_XR_DATA;
 			break;
 		default:
@@ -3129,7 +3139,7 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue,
 				const struct ath5k_txq_info *queue_info)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
@@ -3153,7 +3163,7 @@ int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue,
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 		struct ath5k_txq_info *queue_info)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
 	return 0;
 }
@@ -3163,7 +3173,7 @@ int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
  */
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
 		return;
 
@@ -3181,7 +3191,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	u32 cw_min, cw_max, retry_lg, retry_sh;
 	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	tq = &ah->ah_txq[queue];
@@ -3425,7 +3435,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
  * for a specific queue [5211+]
  */
 u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue) {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -3444,7 +3454,7 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue) {
  */
 int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
@@ -3462,7 +3472,7 @@ int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
  */
 unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (ah->ah_version == AR5K_AR5210)
 		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
 				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
@@ -3610,7 +3620,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	struct ath5k_hw_tx_status *tx_status;
 	unsigned int buff_len;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
 	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
 
@@ -3791,7 +3801,7 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	struct ath5k_hw_tx_status *tx_status;
 	struct ath5k_hw_4w_tx_desc *tx_desc;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
 	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
 
@@ -3869,7 +3879,7 @@ int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 {
 	struct ath5k_rx_desc *rx_desc;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	rx_desc = (struct ath5k_rx_desc *)&desc->ds_ctl0;
 
 	/*
@@ -3974,7 +3984,7 @@ static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
 	struct ath5k_hw_new_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	rx_status = (struct ath5k_hw_new_rx_status *)&desc->ds_hw[0];
 
 	/* Overlay on error */
@@ -4052,7 +4062,7 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 	/*5210 has different led mode handling*/
 	u32 led_5210;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*Reset led status*/
 	if (ah->ah_version != AR5K_AR5210)
@@ -4100,7 +4110,7 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
  */
 int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
@@ -4115,7 +4125,7 @@ int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
  */
 int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
@@ -4130,7 +4140,7 @@ int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
  */
 u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (gpio > AR5K_NUM_GPIO)
 		return 0xffffffff;
 
@@ -4145,7 +4155,7 @@ u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 {
 	u32 data;
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
@@ -4169,7 +4179,7 @@ void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 {
 	u32 data;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (gpio > AR5K_NUM_GPIO)
 		return;
 
@@ -4222,115 +4232,15 @@ u16 ath5k_get_regdomain(struct ath5k_hw *ah)
 }
 
 
-
 /****************\
   Misc functions
 \****************/
 
-void /*O.K.*/
-ath5k_hw_dump_state(struct ath5k_hw *ah)
-{
-#ifdef AR5K_DEBUG
-#define AR5K_PRINT_REGISTER(_x)						\
-	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
-
-	AR5K_PRINT("MAC registers:\n");
-	AR5K_PRINT_REGISTER(CR);
-	AR5K_PRINT_REGISTER(CFG);
-	AR5K_PRINT_REGISTER(IER);
-	AR5K_PRINT_REGISTER(TXCFG);
-	AR5K_PRINT_REGISTER(RXCFG);
-	AR5K_PRINT_REGISTER(MIBC);
-	AR5K_PRINT_REGISTER(TOPS);
-	AR5K_PRINT_REGISTER(RXNOFRM);
-	AR5K_PRINT_REGISTER(RPGTO);
-	AR5K_PRINT_REGISTER(RFCNT);
-	AR5K_PRINT_REGISTER(MISC);
-	AR5K_PRINT_REGISTER(PISR);
-	AR5K_PRINT_REGISTER(SISR0);
-	AR5K_PRINT_REGISTER(SISR1);
-	AR5K_PRINT_REGISTER(SISR3);
-	AR5K_PRINT_REGISTER(SISR4);
-	AR5K_PRINT_REGISTER(DCM_ADDR);
-	AR5K_PRINT_REGISTER(DCM_DATA);
-	AR5K_PRINT_REGISTER(DCCFG);
-	AR5K_PRINT_REGISTER(CCFG);
-	AR5K_PRINT_REGISTER(CCFG_CUP);
-	AR5K_PRINT_REGISTER(CPC0);
-	AR5K_PRINT_REGISTER(CPC1);
-	AR5K_PRINT_REGISTER(CPC2);
-	AR5K_PRINT_REGISTER(CPCORN);
-	AR5K_PRINT_REGISTER(QCU_TXE);
-	AR5K_PRINT_REGISTER(QCU_TXD);
-	AR5K_PRINT_REGISTER(DCU_GBL_IFS_SIFS);
-	AR5K_PRINT_REGISTER(DCU_GBL_IFS_SLOT);
-	AR5K_PRINT_REGISTER(DCU_FP);
-	AR5K_PRINT_REGISTER(DCU_TXP);
-	AR5K_PRINT_REGISTER(DCU_TX_FILTER);
-	AR5K_PRINT_REGISTER(INTPEND);
-	AR5K_PRINT_REGISTER(PCICFG);
-	AR5K_PRINT_REGISTER(GPIOCR);
-	AR5K_PRINT_REGISTER(GPIODO);
-	AR5K_PRINT_REGISTER(SREV);
-	AR5K_PRINT_REGISTER(EEPROM_BASE);
-	AR5K_PRINT_REGISTER(EEPROM_DATA);
-	AR5K_PRINT_REGISTER(EEPROM_CMD);
-	AR5K_PRINT_REGISTER(EEPROM_CFG);
-	AR5K_PRINT_REGISTER(PCU_MIN);
-	AR5K_PRINT_REGISTER(STA_ID0);
-	AR5K_PRINT_REGISTER(STA_ID1);
-	AR5K_PRINT_REGISTER(BSS_ID0);
-	AR5K_PRINT_REGISTER(SLOT_TIME);
-	AR5K_PRINT_REGISTER(TIME_OUT);
-	AR5K_PRINT_REGISTER(RSSI_THR);
-	AR5K_PRINT_REGISTER(BEACON);
-	AR5K_PRINT_REGISTER(CFP_PERIOD);
-	AR5K_PRINT_REGISTER(TIMER0);
-	AR5K_PRINT_REGISTER(TIMER2);
-	AR5K_PRINT_REGISTER(TIMER3);
-	AR5K_PRINT_REGISTER(CFP_DUR);
-	AR5K_PRINT_REGISTER(MCAST_FILTER0);
-	AR5K_PRINT_REGISTER(MCAST_FILTER1);
-	AR5K_PRINT_REGISTER(DIAG_SW);
-	AR5K_PRINT_REGISTER(TSF_U32);
-	AR5K_PRINT_REGISTER(ADDAC_TEST);
-	AR5K_PRINT_REGISTER(DEFAULT_ANTENNA);
-	AR5K_PRINT_REGISTER(LAST_TSTP);
-	AR5K_PRINT_REGISTER(NAV);
-	AR5K_PRINT_REGISTER(RTS_OK);
-	AR5K_PRINT_REGISTER(ACK_FAIL);
-	AR5K_PRINT_REGISTER(FCS_FAIL);
-	AR5K_PRINT_REGISTER(BEACON_CNT);
-	AR5K_PRINT_REGISTER(TSF_PARM);
-	AR5K_PRINT("\n");
-
-	AR5K_PRINT("PHY registers:\n");
-	AR5K_PRINT_REGISTER(PHY_TURBO);
-	AR5K_PRINT_REGISTER(PHY_AGC);
-	AR5K_PRINT_REGISTER(PHY_TIMING_3);
-	AR5K_PRINT_REGISTER(PHY_CHIP_ID);
-	AR5K_PRINT_REGISTER(PHY_AGCCTL);
-	AR5K_PRINT_REGISTER(PHY_NF);
-	AR5K_PRINT_REGISTER(PHY_SCR);
-	AR5K_PRINT_REGISTER(PHY_SLMT);
-	AR5K_PRINT_REGISTER(PHY_SCAL);
-	AR5K_PRINT_REGISTER(PHY_RX_DELAY);
-	AR5K_PRINT_REGISTER(PHY_IQ);
-	AR5K_PRINT_REGISTER(PHY_PAPD_PROBE);
-	AR5K_PRINT_REGISTER(PHY_TXPOWER_RATE1);
-	AR5K_PRINT_REGISTER(PHY_TXPOWER_RATE2);
-	AR5K_PRINT_REGISTER(PHY_RADAR);
-	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_0);
-	AR5K_PRINT_REGISTER(PHY_ANT_SWITCH_TABLE_1);
-	AR5K_PRINT("\n");
-#endif
-}
-
 int ath5k_hw_get_capability(struct ath5k_hw *ah,
 		enum ath5k_capability_type cap_type,
 		u32 capability, u32 *result)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	switch (cap_type) {
 	case AR5K_CAP_NUM_TXQUEUES:
@@ -4375,7 +4285,7 @@ yes:
 static int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
 		u16 assoc_id)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_version == AR5K_AR5210) {
 		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
@@ -4388,7 +4298,7 @@ static int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
 
 static int ath5k_hw_disable_pspoll(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_version == AR5K_AR5210) {
 		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index d5aec18..5319bf0 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -23,6 +23,8 @@
 
 #include "ath5k.h"
 #include "reg.h"
+#include "base.h"
+#include "debug.h"
 
 /* Struct to hold initial RF register values (RF Banks) */
 struct ath5k_ini_rf {
@@ -879,11 +881,10 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw *ah)
 	}
 
 done:
-#ifdef AR5K_DEBUG
-	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
+	AR5K_DBG(ah->ah_sc, ATH_DEBUG_CALIBRATE,
+		"ret %d, gain step %u, current gain %u, target gain %u\n",
 		ret, ah->ah_gain.g_step_idx, ah->ah_gain.g_current,
 		ah->ah_gain.g_target);
-#endif
 
 	return ret;
 }
@@ -908,7 +909,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
 		if (rfregs_5111[i].rf_bank >= AR5K_RF5111_INI_RF_MAX_BANKS) {
-			AR5K_PRINT("invalid bank\n");
+			AR5K_ERR(ah->ah_sc, "invalid bank\n");
 			return -EINVAL;
 		}
 
@@ -1017,7 +1018,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
 		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
-			AR5K_PRINT("invalid bank\n");
+			AR5K_ERR(ah->ah_sc, "invalid bank\n");
 			return -EINVAL;
 		}
 
@@ -1105,7 +1106,7 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
 		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
-			AR5K_PRINT("invalid bank\n");
+			AR5K_ERR(ah->ah_sc, "invalid bank\n");
 			return -EINVAL;
 		}
 
@@ -1167,7 +1168,7 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		/* XXX do extra checks? */
 		ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
 		if (ah->ah_rf_banks == NULL) {
-			AR5K_PRINT("out of memory\n");
+			AR5K_ERR(ah->ah_sc, "out of memory\n");
 			return -ENOMEM;
 		}
 	}
@@ -1222,7 +1223,7 @@ enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah)
 {
 	u32 data, type;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_rf_banks == NULL || !ah->ah_gain.g_active ||
 			ah->ah_version <= AR5K_AR5211)
@@ -1484,7 +1485,7 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	    channel->freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
 	    (channel->freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
 	    channel->freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
-		AR5K_PRINTF("channel out of supported range (%u MHz)\n",
+		AR5K_ERR(ah->ah_sc, "channel out of supported range (%u MHz)\n",
 			channel->freq);
 		return -EINVAL;
 	}
@@ -1605,7 +1606,8 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	ath5k_hw_reg_write(ah, phy_sat, AR5K_PHY_ADCSAT);
 
 	if (ret) {
-		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
+		AR5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
+				channel->freq);
 		return ret;
 	}
 
@@ -1617,7 +1619,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false);
 	if (ret) {
-		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
+		AR5K_ERR(ah->ah_sc, "noise floor calibration timeout (%uMHz)\n",
 				channel->freq);
 		return ret;
 	}
@@ -1635,7 +1637,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	}
 
 	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
-		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
+		AR5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
 			channel->freq);
 		return -EIO;
 	}
@@ -1658,7 +1660,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 {
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	if (ah->ah_calibration == false ||
 			ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
@@ -1715,7 +1717,7 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 
 int ath5k_hw_phy_disable(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*Just a try M.F.*/
 	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 
@@ -1735,7 +1737,7 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 	u32 srev;
 	u16 ret;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 
 	/*
 	 * Set the radio chip access register
@@ -1777,7 +1779,7 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 void /*TODO:Boundary check*/
 ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*Just a try M.F.*/
 	if (ah->ah_version != AR5K_AR5210)
 		ath5k_hw_reg_write(ah, ant, AR5K_DEFAULT_ANTENNA);
@@ -1785,7 +1787,7 @@ ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant)
 
 unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
 {
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	/*Just a try M.F.*/
 	if (ah->ah_version != AR5K_AR5210)
 		return ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
@@ -1845,9 +1847,9 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	bool tpc = ah->ah_txpower.txp_tpc;
 	unsigned int i;
 
-	AR5K_TRACE;
+	AR5K_TRACE(ah->ah_sc);
 	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
-		AR5K_PRINTF("invalid tx power: %u\n", txpower);
+		AR5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
 	}
 
@@ -1899,9 +1901,9 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power)
 	/*Just a try M.F.*/
 	struct ieee80211_channel *channel = &ah->ah_current_channel;
 
-	AR5K_TRACE;
-#ifdef AR5K_DEBUG
-	AR5K_PRINTF("changing txpower to %d\n", power);
-#endif
+	AR5K_TRACE(ah->ah_sc);
+	AR5K_DBG(ah->ah_sc, ATH_DEBUG_TXPOWER,
+		"changing txpower to %d\n", power);
+
 	return ath5k_hw_txpower(ah, channel, power);
 }
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 015b3f8..16afd24 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2647,7 +2647,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	local->sta_scanning = 0;
 
 	if (ieee80211_hw_config(local))
-		printk(KERN_DEBUG "%s: failed to restore operational"
+		printk(KERN_DEBUG "%s: failed to restore operational "
 		       "channel after scan\n", dev->name);
 
 
