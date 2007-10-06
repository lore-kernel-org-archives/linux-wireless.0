Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:24540 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbXJFBRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:17:14 -0400
Received: by wx-out-0506.google.com with SMTP id h31so633669wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:17:13 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:18:37 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 2/6] ath5k: Enable radar detection
Message-ID: <20071006011837.GB25022@pogo> (sfid-20071006_021721_050241_E87F0F33)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006011657.GA24862@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable radar detection, and clean up ath5k_hw_attach() definition.

Specifically this patch:

o On struct ath_hw:
        * renames ah_sh to ah_iobase to make its use clear
        * move ah_sc to non-opaque struct, as we only currently use
          it as struct ath_softc. We we add SoC support we can figure
          an alternative.
        * Move out radar struct definition into new struct ath_radar

o On ath5k_hw_attach() we currenlty pass the ath_sofct struct and
  sc->iobase. No point in passing both since we're already passing sc.

o Remove any comments referring to a "HAL". We don't have one anymore.
  Another patch later will replace 'hal' -> 'ahw'.

o On ath5k_hw_get_isr() only read AR5K_RAC_PISR on non-AR5210s

o Capture AR5K_IMR_RXPHY and pass it as AR5K_INT_RXPHY to our
  interrupt handler. Upon detection call ath5k_radar_alert(). Upper
  layers need radar detection handling support. Right now just
  announce detection. We enable radar detection through new
  ath5k_hw_enable_radar_alert().

Changes to ath5k_base.[ch]
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC
Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   65 +++++++++++++++++--------------
 drivers/net/wireless/ath5k/base.c  |   44 ++++++++++++++++-----
 drivers/net/wireless/ath5k/base.h  |    2 +-
 drivers/net/wireless/ath5k/hw.c    |   74 +++++++++++++++++++++++++++++-------
 4 files changed, 130 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 9308916..445fde8 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -274,10 +274,10 @@ enum ath5k_tx_queue_subtype {
 };
 
 /*
- * Queue ID numbers as returned by the HAL, each number
- * represents a hw queue. If hw does not support hw queues
- * (eg 5210) all data goes in one queue. These match
- * d80211 definitions (net80211/MadWiFi don't use them).
+ * Queue ID numbers as used by ath5k_hw_setup_tx_queue() and
+ * ath5k_hw_wait_for_beacon(). Each number represents a hw queue. 
+ * If hw does not support hw queues (eg 5210) all data goes in one 
+ * queue. These match mac0211 definitions.
  */
 enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_NOQCU_DATA	= 0,
@@ -323,7 +323,8 @@ struct ath5k_txq_info {
 
 /*
  * Transmit packet types.
- * These are not fully used inside OpenHAL yet
+ * These are currently only used in ath5k_hw_setup_2word_tx_desc() to 
+ * distinguish frame types on AR5210.
  */
 enum ath5k_pkt_type {
 	AR5K_PKT_TYPE_NORMAL		= 0,
@@ -573,8 +574,7 @@ struct ath_desc {
 #define CHANNEL_MODES		CHANNEL_ALL
 
 /*
- * Used internaly in OpenHAL (ar5211.c/ar5212.c
- * for reset_tx_queue). Also see struct struct ieee80211_channel.
+ * Used internaly in ath5k_hw_reset_tx_queue()
  */
 #define IS_CHAN_XR(_c)	((_c.val & CHANNEL_XR) != 0)
 #define IS_CHAN_B(_c)	((_c.val & CHANNEL_B) != 0)
@@ -717,13 +717,14 @@ enum ath5k_ant_setting {
 };
 
 /*
- * HAL interrupt abstraction
+ * Hardware interrupt masks helpers
  */
 
 /*
  * These are mapped to take advantage of some common bits
  * between the MAC chips, to be able to set intr properties
- * easier. Some of them are not used yet inside OpenHAL.
+ * easier. Some of them are not used yet inside hw.c. Most map
+ * to the respective hw interrupt value.
  */
 enum ath5k_int {
 	AR5K_INT_RX	= 0x00000001,
@@ -773,8 +774,8 @@ enum ath5k_power_mode {
 };
 
 /*
- * These match net80211 definitions (not used in
- * d80211).
+ * These match net80211 definitions 
+ * XXX: move to mac80211 led work
  */
 #define AR5K_LED_INIT	0 /*IEEE80211_S_INIT*/
 #define AR5K_LED_SCAN	1 /*IEEE80211_S_SCAN*/
@@ -788,9 +789,8 @@ enum ath5k_power_mode {
 #define AR5K_SOFTLED_OFF	1
 
 /*
- * Chipset capabilities -see ath_hal_getcapability-
- * get_capability function is not yet fully implemented
- * in OpenHAL so most of these don't work yet...
+ * Chipset capabilities. See ath5k_hw_get_capability(), 
+ * we do what we can as we make progress
  */
 enum ath5k_capability_type {
 	AR5K_CAP_REG_DMN		= 0,	/* Used to get current reg. domain id */
@@ -862,14 +862,20 @@ struct ath5k_capabilities {
  * Misc defines
  */
 
+struct ath_radar {
+	bool	r_enabled;
+	int	r_last_alert;
+	struct ieee80211_channel r_last_channel;
+};
+
 #define AR5K_MAX_GPIO		10
 #define AR5K_MAX_RF_BANKS	8
 
 struct ath_hw {
 	u32			ah_magic;
 
-	void			*ah_sc;
-	void __iomem		*ah_sh;
+	struct ath_softc	*ah_sc;
+	void __iomem		*ah_iobase;
 	enum ath5k_countrycode	ah_country_code;
 
 	enum ath5k_int		ah_imr;
@@ -937,11 +943,7 @@ struct ath_hw {
 		s16		txp_ofdm;
 	} ah_txpower;
 
-	struct {
-		bool		r_enabled;
-		int		r_last_alert;
-		struct ieee80211_channel r_last_channel;
-	} ah_radar;
+	struct ath_radar	ah_radar;
 
 	/*
 	 * Function pointers
@@ -966,7 +968,8 @@ struct ath_hw {
 /* General Functions */
 extern int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
-extern struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
+extern struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version,
+	struct ath_softc *sc);
 extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal, unsigned int mode);
 extern void ath5k_hw_detach(struct ath_hw *hal);
 /* Reset Functions */
@@ -981,12 +984,15 @@ extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
 extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
 extern int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
 extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
+extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, 
+	u32 phys_addr);
 extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
 /* Interrupt handling */
 extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
 extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
-extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask);
+extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, 
+	enum ath5k_int new_mask);
+extern void ath5k_hw_enable_radar_alert(struct ath_hw *hal, bool enable);
 /* EEPROM access functions */
 extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
 /* Protocol Control Unit Functions */
@@ -994,7 +1000,8 @@ extern int ath5k_hw_set_opmode(struct ath_hw *hal);
 /* BSSID Functions */
 extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
 extern int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
-extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
+extern void ath5k_hw_set_associd(struct ath_hw *hal, 
+	const u8 *bssid, u16 assoc_id);
 extern int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
@@ -1073,14 +1080,14 @@ extern int ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channe
 extern int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
 
 
-static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
+static inline u32 ath5k_hw_reg_read(struct ath_hw *ahw, u16 reg)
 {
-	return ioread32(hal->ah_sh + reg);
+	return ioread32(ahw->ah_iobase + reg);
 }
 
-static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
+static inline void ath5k_hw_reg_write(struct ath_hw *ahw, u32 val, u16 reg)
 {
-	iowrite32(val, hal->ah_sh + reg);
+	iowrite32(val, ahw->ah_iobase + reg);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index afcc7e1..fa591eb 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -114,9 +114,8 @@ module_param_named(debug, ath_debug, uint, 0);
 #endif
 
 /*
- * User a static table of PCI id's for now.  While this is the
- * "new way" to do things, we may want to switch back to having
- * the HAL check them by defining a probe method.
+ * ath5k_hw_attach() may also do further checking. Some devices keep the same
+ * PCI vendor:device ID but may differ. ath5k_hw_attach() will check there.
  */
 static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
@@ -596,7 +595,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
 		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
 				sc->bhalq);
-		/* NB: the HAL still stops DMA, so proceed */
+		/* ath5k_hw_stop_tx_dma() still stops DMA, so proceed */
 	}
 	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
 			PCI_DMA_TODEVICE);
@@ -717,6 +716,8 @@ static void ath_beacon_config(struct ath_softc *sc)
 				ath5k_hw_hasveol(ah))
 			ath_beacon_send(sc);
 	}
+	/* Enable radar alerts */
+	ath5k_hw_enable_radar_alert(ah, true);
 #undef TSF_TO_TU
 }
 
@@ -1135,7 +1136,7 @@ static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
 		 *
 		 * XXX needed?
 		 */
-/*		ath_chan_change(sc, chan); */
+		//ath_chan_set(sc, sc->curchan);
 
 		/*
 		 * Re-enable interrupts.
@@ -1260,10 +1261,6 @@ static int ath_reset(struct ieee80211_hw *hw)
 	int ret;
 
 	DPRINTF(sc, ATH_DEBUG_RESET, "resetting\n");
-	/*
-	 * Convert to a HAL channel description with the flags
-	 * constrained to reflect the current operating mode.
-	 */
 	sc->curchan = hw->conf.chan;
 
 	ath5k_hw_set_intr(ah, 0);
@@ -1289,7 +1286,7 @@ static int ath_reset(struct ieee80211_hw *hw)
 	 *
 	 * XXX needed?
 	 */
-/*	ath_chan_change(sc, c); */
+	//ath_chan_set(sc, sc->curchan);
 	ath_beacon_config(sc);
 	/* intrs are started by ath_beacon_config */
 
@@ -1669,6 +1666,28 @@ static void ath_led_event(struct ath_softc *sc, int event)
 	}
 }
 
+static void ath5k_radar_alert(struct ath_hw *ahw)
+{
+	struct ath_radar *radar = &ahw->ah_radar;
+	struct ieee80211_channel *radar_chan = &radar->r_last_channel;
+	struct ieee80211_channel *curr_chan = &ahw->ah_current_channel;
+
+	/* Limit ~1/s */
+	if (radar_chan->chan == curr_chan->chan &&
+		jiffies < (radar->r_last_alert + 1 * HZ))
+	return;
+
+	memcpy(radar_chan, curr_chan, sizeof(struct ieee80211_channel));
+	radar->r_last_alert = jiffies;
+
+	dev_info(&ahw->ah_sc->pdev->dev,
+		"Possible radar activity detected at "
+		"%u MHz (jiffies %u)\n", radar->r_last_alert,
+		curr_chan->chan);
+
+	/* Higher layer should probably do something here... TBC */
+}
+
 static irqreturn_t ath_intr(int irq, void *dev_id)
 {
 	struct ath_softc *sc = dev_id;
@@ -1701,6 +1720,9 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 			tasklet_schedule(&sc->restq);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
 			tasklet_schedule(&sc->restq);
+		} else if ((unlikely(status & AR5K_INT_RXPHY)) &&
+			ah->ah_radar.r_enabled) {
+				ath5k_radar_alert(ah);
 		} else {
 			if (status & AR5K_INT_SWBA) {
 				/*
@@ -2373,7 +2395,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 		goto err_free;
 	}
 
-	sc->ah = ath5k_hw_attach(pdev->device, id->driver_data, sc, sc->iobase);
+	sc->ah = ath5k_hw_attach(pdev->device, id->driver_data, sc);
 	if (IS_ERR(sc->ah)) {
 		ret = PTR_ERR(sc->ah);
 		goto err_irq;
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 4a624cc..1bd1d1f 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -191,7 +191,7 @@ struct ath_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 
 	struct ath_buf		*bbuf;		/* beacon buffer */
-	unsigned int		bhalq,		/* HAL q for outgoing beacons */
+	unsigned int		bhalq,		/* Hw q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval */
 				bsent;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ae4c5b5..6ef492c 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -21,7 +21,7 @@
  */
 
 /*
- * HAL interface for Atheros Wireless LAN devices.
+ * Hardware interface for Atheros Wireless LAN devices.
  */
 
 #include <linux/pci.h>
@@ -29,6 +29,7 @@
 
 #include "ath5k.h"
 #include "reg.h"
+#include "base.h"
 
 /*Rate tables*/
 static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
@@ -191,8 +192,8 @@ int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
 /*
  * Check if the device is supported and initialize the needed structs
  */
-struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
-		void __iomem *sh)
+struct ath_hw *ath5k_hw_attach(u16 device, 
+	u8 mac_version, struct ath_softc *sc)
 {
 	struct ath_hw *hal;
 	u8 mac[ETH_ALEN];
@@ -208,10 +209,10 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	}
 
 	hal->ah_sc = sc;
-	hal->ah_sh = sh;
+	hal->ah_iobase = sc->iobase;
 
 	/*
-	 * HAL information
+	 * Hardware cached data
 	 */
 
 	/* Regulation Stuff */
@@ -1474,14 +1475,15 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 			return -ENODEV;
 		}
 	}
+	else {
+		/*
+		 * Read interrupt status from the Read-And-Clear shadow register
+		 */
+		data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
+	}
 
 	/*
-	 * Read interrupt status from the Read-And-Clear shadow register
-	 */
-	data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
-
-	/*
-	 * Get abstract interrupt mask (HAL-compatible)
+	 * Get abstract interrupt mask
 	 */
 	*interrupt_mask = (data & AR5K_INT_COMMON) & hal->ah_imr;
 
@@ -1494,6 +1496,9 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR))
 		*interrupt_mask |= AR5K_INT_TX;
 
+	if (data & AR5K_IMR_RXPHY)
+		*interrupt_mask |= AR5K_INT_RXPHY;
+
 	if (hal->ah_version != AR5K_AR5210) {
 		/*HIU = Host Interface Unit (PCI etc)*/
 		if (unlikely(data & (AR5K_ISR_HIUERR)))
@@ -1504,12 +1509,14 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 			*interrupt_mask |= AR5K_INT_BNR;
 	}
 
+#if 0
 	/*
 	 * XXX: BMISS interrupts may occur after association.
-	 * I found this on 5210 code but it needs testing
+	 * Needs testing.
 	 */
-#if 0
-	interrupt_mask &= ~AR5K_INT_BMISS;
+	if (hal->ah_version != AR5K_AR5210) {
+		interrupt_mask &= ~AR5K_INT_BMISS;
+	}
 #endif
 
 	/*
@@ -1570,6 +1577,45 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 	return old_mask;
 }
 
+/*
+ * Enable HW radar detection
+ */
+void ath5k_hw_enable_radar_alert(struct ath_hw *ahw, bool enable)
+{
+
+	AR5K_TRACE;
+	/*
+	 * Enable radar detection
+	 */
+
+	/* Disable interupts */
+	ath5k_hw_reg_write(ahw, AR5K_IER_DISABLE, AR5K_IER);
+
+	/*
+	 * Set the RXPHY interrupt to be able to detect
+	 * possible radar activity.
+	 */
+	if (ahw->ah_version == AR5K_AR5210) {
+		if (enable) 
+			AR5K_REG_ENABLE_BITS(ahw, AR5K_IMR, AR5K_IMR_RXPHY);
+		else
+			AR5K_REG_DISABLE_BITS(ahw, AR5K_IMR, AR5K_IMR_RXPHY);
+	} else {
+		/* Also set AR5K_PHY_RADAR register on 5111/5112 */
+		if (enable) {
+			ath5k_hw_reg_write(ahw, AR5K_PHY_RADAR_ENABLE,
+				AR5K_PHY_RADAR);
+			AR5K_REG_ENABLE_BITS(ahw, AR5K_PIMR, AR5K_IMR_RXPHY);
+		} else {
+			ath5k_hw_reg_write(ahw, AR5K_PHY_RADAR_DISABLE,
+				AR5K_PHY_RADAR);
+			AR5K_REG_DISABLE_BITS(ahw, AR5K_PIMR, AR5K_IMR_RXPHY);
+		}
+	}
+
+	/* Re-enable interrupts */
+	ath5k_hw_reg_write(ahw, AR5K_IER_ENABLE,  AR5K_IER);
+}
 
 /*************************\
   EEPROM access functions
-- 
1.5.2.5


