Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40437 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab0KWShM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:37:12 -0500
Received: by ewy5 with SMTP id 5so2633562ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:37:10 -0800 (PST)
Date: Tue, 23 Nov 2010 20:36:45 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 01/30] ath5k: Reset cleanup and generic cleanup
Message-ID: <20101123183645.GA4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * No functional changes

 * Clean up reset:
 Introduce init functions for each unit and call them instead
 of having everything inside ath5k_hw_reset (it's just c/p for
 now so nothing changes except calling order -I tested it with
 various cards and it's ok-)
    
 * Further cleanups:
 ofdm_timings belongs to phy.c
 rate_duration belongs to pcu.c
 clock functions are general and belong to reset.c (more to follow)
    
 * Reorder functions for better organization:
 We start with helpers and other functions follow in categories,
 init functions are last
    
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/ani.c    |    4 +-
 drivers/net/wireless/ath/ath5k/ath5k.h  |   60 ++--
 drivers/net/wireless/ath/ath5k/desc.c   |   24 +-
 drivers/net/wireless/ath/ath5k/dma.c    |   45 ++
 drivers/net/wireless/ath/ath5k/eeprom.c |  151 ++++---
 drivers/net/wireless/ath/ath5k/pcu.c    |  438 ++++++++++++--------
 drivers/net/wireless/ath/ath5k/phy.c    |  444 ++++++++++++++++-----
 drivers/net/wireless/ath/ath5k/qcu.c    |  130 ++++---
 drivers/net/wireless/ath/ath5k/reset.c  |  662 +++++++++----------------------
 9 files changed, 1053 insertions(+), 905 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index db98a85..8f1d3cb 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -58,7 +58,7 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 {
 	/* TODO:
 	 * ANI documents suggest the following five levels to use, but the HAL
-	 * and ath9k use only use the last two levels, making this
+	 * and ath9k use only the last two levels, making this
 	 * essentially an on/off option. There *may* be a reason for this (???),
 	 * so i stick with the HAL version for now...
 	 */
@@ -68,9 +68,9 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	const s8 sz[] = { -34, -41, -48, -55, -62 };
 	const s8 fr[] = { -70, -72, -75, -78, -80 };
 #else
-	const s8 sz[] = { -55, -62 };
 	const s8 lo[] = { -64, -70 };
 	const s8 hi[] = { -14, -12 };
+	const s8 sz[] = { -55, -62 };
 	const s8 fr[] = { -78, -80 };
 #endif
 	if (level < 0 || level >= ARRAY_SIZE(sz)) {
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2718136..85ff822 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1140,12 +1140,14 @@ void ath5k_hw_detach(struct ath5k_hw *ah);
 int ath5k_sysfs_register(struct ath5k_softc *sc);
 void ath5k_sysfs_unregister(struct ath5k_softc *sc);
 
+
 /* LED functions */
 int ath5k_init_leds(struct ath5k_softc *sc);
 void ath5k_led_enable(struct ath5k_softc *sc);
 void ath5k_led_off(struct ath5k_softc *sc);
 void ath5k_unregister_leds(struct ath5k_softc *sc);
 
+
 /* Reset Functions */
 int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
 int ath5k_hw_on_hold(struct ath5k_hw *ah);
@@ -1155,6 +1157,13 @@ int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 			      bool is_set);
 /* Power management functions */
 
+
+/* Clock rate related functions */
+unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
+unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
+void ath5k_hw_set_clockrate(struct ath5k_hw *ah);
+
+
 /* DMA Related Functions */
 void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
 int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
@@ -1171,26 +1180,28 @@ bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
 int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
 enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask);
 void ath5k_hw_update_mib_counters(struct ath5k_hw *ah);
+/* Init function */
+void ath5k_hw_dma_init(struct ath5k_hw *ah);
 
 /* EEPROM access functions */
 int ath5k_eeprom_init(struct ath5k_hw *ah);
 void ath5k_eeprom_detach(struct ath5k_hw *ah);
 int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 
+
 /* Protocol Control Unit Functions */
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
-/* BSSID Functions */
+/* RX filter control*/
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
 void ath5k_hw_set_bssid(struct ath5k_hw *ah);
 void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
-/* Receive start/stop functions */
-void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
-void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
-/* RX Filter functions */
 void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
 u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
 void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
+/* Receive (DRU) start/stop functions */
+void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
+void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
 /* Beacon control functions */
 u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
@@ -1199,10 +1210,9 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
 bool ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval);
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
-/* Clock rate related functions */
-unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
-unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
-void ath5k_hw_set_clockrate(struct ath5k_hw *ah);
+/* Init function */
+void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
+								u8 mode);
 
 /* Queue Control Unit, DFS Control Unit Functions */
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
@@ -1216,6 +1226,8 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
+/* Init function */
+int ath5k_hw_init_queues(struct ath5k_hw *ah);
 
 /* Hardware Descriptor Functions */
 int ath5k_hw_init_desc_functions(struct ath5k_hw *ah);
@@ -1225,6 +1237,7 @@ int ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
 	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3);
 
+
 /* GPIO Functions */
 void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
 int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
@@ -1234,11 +1247,13 @@ int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 			    u32 interrupt_level);
 
-/* rfkill Functions */
+
+/* RFkill Functions */
 void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
 void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
 
-/* Misc functions */
+
+/* Misc functions TODO: Cleanup */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
 int ath5k_hw_get_capability(struct ath5k_hw *ah,
 			    enum ath5k_capability_type cap_type, u32 capability,
@@ -1246,19 +1261,20 @@ int ath5k_hw_get_capability(struct ath5k_hw *ah,
 int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid, u16 assoc_id);
 int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
 
+
 /* Initial register settings functions */
 int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
 
-/* Initialize RF */
-int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
-			 struct ieee80211_channel *channel,
-			 unsigned int mode);
-int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq);
+
+/* PHY functions */
+/* Misc PHY functions */
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
+int ath5k_hw_phy_disable(struct ath5k_hw *ah);
+/* Gain_F optimization */
 enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah);
 int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah);
 /* PHY/RF channel functions */
 bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
-int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 /* PHY calibration */
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
 int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
@@ -1267,18 +1283,14 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 				  struct ieee80211_channel *channel);
-void ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
-					 struct ieee80211_channel *channel);
-/* Misc PHY functions */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
-int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Antenna control */
 void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
 void ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode);
 /* TX power setup */
-int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-		     u8 ee_mode, u8 txpower);
 int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
+/* Init function */
+int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
+						u8 mode, u8 ee_mode, u8 freq);
 
 /*
  * Functions used internaly
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 4324438..16b44ff 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -26,9 +26,10 @@
 #include "debug.h"
 #include "base.h"
 
-/*
- * TX Descriptors
- */
+
+/************************\
+* TX Control descriptors *
+\************************/
 
 /*
  * Initialize the 2-word tx control descriptor on 5210/5211
@@ -335,6 +336,11 @@ ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	return 0;
 }
 
+
+/***********************\
+* TX Status descriptors *
+\***********************/
+
 /*
  * Proccess the tx status descriptor on 5210/5211
  */
@@ -476,9 +482,10 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * RX Descriptors
- */
+
+/****************\
+* RX Descriptors *
+\****************/
 
 /*
  * Initialize an rx control descriptor
@@ -666,6 +673,11 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	return 0;
 }
 
+
+/********\
+* Attach *
+\********/
+
 /*
  * Init function pointers inside ath5k_hw struct
  */
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 923c9ca..b991b05 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -37,6 +37,7 @@
 #include "debug.h"
 #include "base.h"
 
+
 /*********\
 * Receive *
 \*********/
@@ -427,6 +428,7 @@ done:
 	return ret;
 }
 
+
 /*******************\
 * Interrupt masking *
 \*******************/
@@ -688,3 +690,46 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 	return old_mask;
 }
 
+
+/********************\
+ Init/Stop functions
+\********************/
+
+/**
+ * ath5k_hw_dma_init - Initialize DMA unit
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Set DMA size and pre-enable interrupts
+ * (driver handles tx/rx buffer setup and
+ * dma start/stop)
+ *
+ * XXX: Save/restore RXDP/TXDP registers ?
+ */
+void ath5k_hw_dma_init(struct ath5k_hw *ah)
+{
+	/*
+	 * Set Rx/Tx DMA Configuration
+	 *
+	 * Set standard DMA size (128). Note that
+	 * a DMA size of 512 causes rx overruns and tx errors
+	 * on pci-e cards (tested on 5424 but since rx overruns
+	 * also occur on 5416/5418 with madwifi we set 128
+	 * for all PCI-E cards to be safe).
+	 *
+	 * XXX: need to check 5210 for this
+	 * TODO: Check out tx triger level, it's always 64 on dumps but I
+	 * guess we can tweak it and see how it goes ;-)
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
+			AR5K_TXCFG_SDMAMR, AR5K_DMASIZE_128B);
+		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG,
+			AR5K_RXCFG_SDMAMW, AR5K_DMASIZE_128B);
+	}
+
+	/* Pre-enable interrupts on 5211/5212*/
+	if (ah->ah_version != AR5K_AR5210)
+		ath5k_hw_set_imr(ah, ah->ah_imr);
+
+}
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 39722dd..033eab9 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -28,6 +28,43 @@
 #include "debug.h"
 #include "base.h"
 
+
+/******************\
+* Helper functions *
+\******************/
+
+/*
+ * Translate binary channel representation in EEPROM to frequency
+ */
+static u16 ath5k_eeprom_bin2freq(struct ath5k_eeprom_info *ee, u16 bin,
+							unsigned int mode)
+{
+	u16 val;
+
+	if (bin == AR5K_EEPROM_CHANNEL_DIS)
+		return bin;
+
+	if (mode == AR5K_EEPROM_MODE_11A) {
+		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
+			val = (5 * bin) + 4800;
+		else
+			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
+				(bin * 10) + 5100;
+	} else {
+		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
+			val = bin + 2300;
+		else
+			val = bin + 2400;
+	}
+
+	return val;
+}
+
+
+/*********\
+* Parsers *
+\*********/
+
 /*
  * Read from eeprom
  */
@@ -63,33 +100,6 @@ static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
 }
 
 /*
- * Translate binary channel representation in EEPROM to frequency
- */
-static u16 ath5k_eeprom_bin2freq(struct ath5k_eeprom_info *ee, u16 bin,
-                                 unsigned int mode)
-{
-	u16 val;
-
-	if (bin == AR5K_EEPROM_CHANNEL_DIS)
-		return bin;
-
-	if (mode == AR5K_EEPROM_MODE_11A) {
-		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
-			val = (5 * bin) + 4800;
-		else
-			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
-				(bin * 10) + 5100;
-	} else {
-		if (ee->ee_version > AR5K_EEPROM_VERSION_3_2)
-			val = bin + 2300;
-		else
-			val = bin + 2400;
-	}
-
-	return val;
-}
-
-/*
  * Initialize eeprom & capabilities structs
  */
 static int
@@ -647,6 +657,7 @@ ath5k_eeprom_init_11bg_2413(struct ath5k_hw *ah, unsigned int mode, int offset)
 	return 0;
 }
 
+
 /*
  * Read power calibration for RF5111 chips
  *
@@ -1514,6 +1525,7 @@ ath5k_eeprom_read_target_rate_pwr_info(struct ath5k_hw *ah, unsigned int mode)
 	return 0;
 }
 
+
 /*
  * Read per channel calibration info from EEPROM
  *
@@ -1607,15 +1619,6 @@ ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
 	return 0;
 }
 
-void
-ath5k_eeprom_detach(struct ath5k_hw *ah)
-{
-	u8 mode;
-
-	for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++)
-		ath5k_eeprom_free_pcal_info(ah, mode);
-}
-
 /* Read conformance test limits used for regulatory control */
 static int
 ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
@@ -1757,37 +1760,6 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 }
 
 /*
- * Initialize eeprom data structure
- */
-int
-ath5k_eeprom_init(struct ath5k_hw *ah)
-{
-	int err;
-
-	err = ath5k_eeprom_init_header(ah);
-	if (err < 0)
-		return err;
-
-	err = ath5k_eeprom_init_modes(ah);
-	if (err < 0)
-		return err;
-
-	err = ath5k_eeprom_read_pcal_info(ah);
-	if (err < 0)
-		return err;
-
-	err = ath5k_eeprom_read_ctl_info(ah);
-	if (err < 0)
-		return err;
-
-	err = ath5k_eeprom_read_spur_chans(ah);
-	if (err < 0)
-		return err;
-
-	return 0;
-}
-
-/*
  * Read the MAC address from eeprom
  */
 int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
@@ -1819,3 +1791,48 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 
 	return 0;
 }
+
+
+/***********************\
+* Init/Detach functions *
+\***********************/
+
+/*
+ * Initialize eeprom data structure
+ */
+int
+ath5k_eeprom_init(struct ath5k_hw *ah)
+{
+	int err;
+
+	err = ath5k_eeprom_init_header(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_init_modes(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_read_pcal_info(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_read_ctl_info(ah);
+	if (err < 0)
+		return err;
+
+	err = ath5k_eeprom_read_spur_chans(ah);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+void
+ath5k_eeprom_detach(struct ath5k_hw *ah)
+{
+	u8 mode;
+
+	for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++)
+		ath5k_eeprom_free_pcal_info(ah, mode);
+}
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 074b4c6..ae99e37 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -32,86 +32,47 @@
 #include "base.h"
 
 /*******************\
-* Generic functions *
+* Helper functions *
 \*******************/
 
 /**
- * ath5k_hw_set_opmode - Set PCU operating mode
+ * ath5k_hw_get_default_slottime - Get the default slot time for current mode
  *
  * @ah: The &struct ath5k_hw
- * @op_mode: &enum nl80211_iftype operating mode
- *
- * Initialize PCU for the various operating modes (AP/STA etc)
  */
-int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
+static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 {
-	struct ath_common *common = ath5k_hw_common(ah);
-	u32 pcu_reg, beacon_reg, low_id, high_id;
-
-	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_MODE, "mode %d\n", op_mode);
-
-	/* Preserve rest settings */
-	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
-	pcu_reg &= ~(AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_AP
-			| AR5K_STA_ID1_KEYSRCH_MODE
-			| (ah->ah_version == AR5K_AR5210 ?
-			(AR5K_STA_ID1_PWR_SV | AR5K_STA_ID1_NO_PSPOLL) : 0));
+	struct ieee80211_channel *channel = ah->ah_current_channel;
 
-	beacon_reg = 0;
+	if (channel->hw_value & CHANNEL_TURBO)
+		return 6; /* both turbo modes */
 
-	switch (op_mode) {
-	case NL80211_IFTYPE_ADHOC:
-		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_KEYSRCH_MODE;
-		beacon_reg |= AR5K_BCR_ADHOC;
-		if (ah->ah_version == AR5K_AR5210)
-			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
-		else
-			AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
-		break;
+	if (channel->hw_value & CHANNEL_CCK)
+		return 20; /* 802.11b */
 
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_MESH_POINT:
-		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_KEYSRCH_MODE;
-		beacon_reg |= AR5K_BCR_AP;
-		if (ah->ah_version == AR5K_AR5210)
-			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
-		else
-			AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
-		break;
-
-	case NL80211_IFTYPE_STATION:
-		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
-			| (ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_PWR_SV : 0);
-	case NL80211_IFTYPE_MONITOR:
-		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
-			| (ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
-		break;
+	return 9; /* 802.11 a/g */
+}
 
-	default:
-		return -EINVAL;
-	}
+/**
+ * ath5k_hw_get_default_sifs - Get the default SIFS for current mode
+ *
+ * @ah: The &struct ath5k_hw
+ */
+static unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
+{
+	struct ieee80211_channel *channel = ah->ah_current_channel;
 
-	/*
-	 * Set PCU registers
-	 */
-	low_id = get_unaligned_le32(common->macaddr);
-	high_id = get_unaligned_le16(common->macaddr + 4);
-	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
+	if (channel->hw_value & CHANNEL_TURBO)
+		return 8; /* both turbo modes */
 
-	/*
-	 * Set Beacon Control Register on 5210
-	 */
-	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, beacon_reg, AR5K_BCR);
+	if (channel->hw_value & CHANNEL_5GHZ)
+		return 16; /* 802.11a */
 
-	return 0;
+	return 10; /* 802.11 b/g */
 }
 
 /**
- * ath5k_hw_update - Update MIB counters (mac layer statistics)
+ * ath5k_hw_update_mib_counters - Update MIB counters (mac layer statistics)
  *
  * @ah: The &struct ath5k_hw
  *
@@ -163,6 +124,82 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
 * ACK/CTS Timeouts *
 \******************/
 
+/*
+ * index into rates for control rates, we can set it up like this because
+ * this is only used for AR5212 and we know it supports G mode
+ */
+static const unsigned int control_rates[] =
+	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
+
+/**
+ * ath5k_hw_write_rate_duration - fill rate code to duration table
+ *
+ * @ah: the &struct ath5k_hw
+ * @mode: one of enum ath5k_driver_mode
+ *
+ * Write the rate code to duration table upon hw reset. This is a helper for
+ * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout on
+ * the hardware, based on current mode, for each rate. The rates which are
+ * capable of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have
+ * different rate code so we write their value twice (one for long preamble
+ * and one for short).
+ *
+ * Note: Band doesn't matter here, if we set the values for OFDM it works
+ * on both a and g modes. So all we have to do is set values for all g rates
+ * that include all OFDM and CCK rates. If we operate in turbo or xr/half/
+ * quarter rate mode, we need to use another set of bitrates (that's why we
+ * need the mode parameter) but we don't handle these proprietary modes yet.
+ */
+static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
+						unsigned int mode)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	struct ieee80211_rate *rate;
+	unsigned int i;
+
+	/* Write rate duration table */
+	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
+		u32 reg;
+		u16 tx_time;
+
+		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
+
+		/* Set ACK timeout */
+		reg = AR5K_RATE_DUR(rate->hw_value);
+
+		/* An ACK frame consists of 10 bytes. If you add the FCS,
+		 * which ieee80211_generic_frame_duration() adds,
+		 * its 14 bytes. Note we use the control rate and not the
+		 * actual rate for this rate. See mac80211 tx.c
+		 * ieee80211_duration() for a brief description of
+		 * what rate we should choose to TX ACKs. */
+		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
+							NULL, 10, rate));
+
+		ath5k_hw_reg_write(ah, tx_time, reg);
+
+		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
+			continue;
+
+		/*
+		 * We're not distinguishing short preamble here,
+		 * This is true, all we'll get is a longer value here
+		 * which is not necessarilly bad. We could use
+		 * export ieee80211_frame_duration() but that needs to be
+		 * fixed first to be properly used by mac802111 drivers:
+		 *
+		 *  - remove erp stuff and let the routine figure ofdm
+		 *    erp rates
+		 *  - remove passing argument ieee80211_local as
+		 *    drivers don't have access to it
+		 *  - move drivers using ieee80211_generic_frame_duration()
+		 *    to this
+		 */
+		ath5k_hw_reg_write(ah, tx_time,
+			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
+	}
+}
+
 /**
  * ath5k_hw_set_ack_timeout - Set ACK timeout on PCU
  *
@@ -199,88 +236,10 @@ static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 	return 0;
 }
 
-/**
- * ath5k_hw_htoclock - Translate usec to hw clock units
- *
- * @ah: The &struct ath5k_hw
- * @usec: value in microseconds
- */
-unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
-{
-	struct ath_common *common = ath5k_hw_common(ah);
-	return usec * common->clockrate;
-}
 
-/**
- * ath5k_hw_clocktoh - Translate hw clock units to usec
- * @clock: value in hw clock units
- */
-unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
-{
-	struct ath_common *common = ath5k_hw_common(ah);
-	return clock / common->clockrate;
-}
-
-/**
- * ath5k_hw_set_clockrate - Set common->clockrate for the current channel
- *
- * @ah: The &struct ath5k_hw
- */
-void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
-{
-	struct ieee80211_channel *channel = ah->ah_current_channel;
-	struct ath_common *common = ath5k_hw_common(ah);
-	int clock;
-
-	if (channel->hw_value & CHANNEL_5GHZ)
-		clock = 40; /* 802.11a */
-	else if (channel->hw_value & CHANNEL_CCK)
-		clock = 22; /* 802.11b */
-	else
-		clock = 44; /* 802.11g */
-
-	/* Clock rate in turbo modes is twice the normal rate */
-	if (channel->hw_value & CHANNEL_TURBO)
-		clock *= 2;
-
-	common->clockrate = clock;
-}
-
-/**
- * ath5k_hw_get_default_slottime - Get the default slot time for current mode
- *
- * @ah: The &struct ath5k_hw
- */
-static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
-{
-	struct ieee80211_channel *channel = ah->ah_current_channel;
-
-	if (channel->hw_value & CHANNEL_TURBO)
-		return 6; /* both turbo modes */
-
-	if (channel->hw_value & CHANNEL_CCK)
-		return 20; /* 802.11b */
-
-	return 9; /* 802.11 a/g */
-}
-
-/**
- * ath5k_hw_get_default_sifs - Get the default SIFS for current mode
- *
- * @ah: The &struct ath5k_hw
- */
-static unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
-{
-	struct ieee80211_channel *channel = ah->ah_current_channel;
-
-	if (channel->hw_value & CHANNEL_TURBO)
-		return 8; /* both turbo modes */
-
-	if (channel->hw_value & CHANNEL_5GHZ)
-		return 16; /* 802.11a */
-
-	return 10; /* 802.11 b/g */
-}
+/*******************\
+* RX filter Control *
+\*******************/
 
 /**
  * ath5k_hw_set_lladdr - Set station id
@@ -362,39 +321,6 @@ void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 		ath_hw_setbssidmask(common);
 }
 
-/************\
-* RX Control *
-\************/
-
-/**
- * ath5k_hw_start_rx_pcu - Start RX engine
- *
- * @ah: The &struct ath5k_hw
- *
- * Starts RX engine on PCU so that hw can process RXed frames
- * (ACK etc).
- *
- * NOTE: RX DMA should be already enabled using ath5k_hw_start_rx_dma
- */
-void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
-{
-	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
-}
-
-/**
- * at5k_hw_stop_rx_pcu - Stop RX engine
- *
- * @ah: The &struct ath5k_hw
- *
- * Stops RX engine on PCU
- *
- * TODO: Detach ANI here
- */
-void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
-{
-	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
-}
-
 /*
  * Set multicast filter
  */
@@ -761,3 +687,161 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
 
 	ah->ah_coverage_class = coverage_class;
 }
+
+/***************************\
+* Init/Start/Stop functions *
+\***************************/
+
+/**
+ * ath5k_hw_start_rx_pcu - Start RX engine
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Starts RX engine on PCU so that hw can process RXed frames
+ * (ACK etc).
+ *
+ * NOTE: RX DMA should be already enabled using ath5k_hw_start_rx_dma
+ */
+void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
+{
+	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+}
+
+/**
+ * at5k_hw_stop_rx_pcu - Stop RX engine
+ *
+ * @ah: The &struct ath5k_hw
+ *
+ * Stops RX engine on PCU
+ */
+void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
+{
+	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+}
+
+/**
+ * ath5k_hw_set_opmode - Set PCU operating mode
+ *
+ * @ah: The &struct ath5k_hw
+ * @op_mode: &enum nl80211_iftype operating mode
+ *
+ * Configure PCU for the various operating modes (AP/STA etc)
+ */
+int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
+{
+	struct ath_common *common = ath5k_hw_common(ah);
+	u32 pcu_reg, beacon_reg, low_id, high_id;
+
+	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_MODE, "mode %d\n", op_mode);
+
+	/* Preserve rest settings */
+	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
+	pcu_reg &= ~(AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_AP
+			| AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
+			(AR5K_STA_ID1_PWR_SV | AR5K_STA_ID1_NO_PSPOLL) : 0));
+
+	beacon_reg = 0;
+
+	switch (op_mode) {
+	case NL80211_IFTYPE_ADHOC:
+		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_KEYSRCH_MODE;
+		beacon_reg |= AR5K_BCR_ADHOC;
+		if (ah->ah_version == AR5K_AR5210)
+			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
+		else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
+		break;
+
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
+		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_KEYSRCH_MODE;
+		beacon_reg |= AR5K_BCR_AP;
+		if (ah->ah_version == AR5K_AR5210)
+			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
+		else
+			AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_PWR_SV : 0);
+	case NL80211_IFTYPE_MONITOR:
+		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
+				AR5K_STA_ID1_NO_PSPOLL : 0);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Set PCU registers
+	 */
+	low_id = get_unaligned_le32(common->macaddr);
+	high_id = get_unaligned_le16(common->macaddr + 4);
+	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
+
+	/*
+	 * Set Beacon Control Register on 5210
+	 */
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, beacon_reg, AR5K_BCR);
+
+	return 0;
+}
+
+void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
+								u8 mode)
+{
+	/* Set bssid and bssid mask */
+	ath5k_hw_set_bssid(ah);
+
+	/* Set PCU config */
+	ath5k_hw_set_opmode(ah, op_mode);
+
+	/* Write rate duration table only on AR5212 and if
+	 * virtual interface has already been brought up
+	 * XXX: rethink this after new mode changes to
+	 * mac80211 are integrated */
+	if (ah->ah_version == AR5K_AR5212 &&
+		ah->ah_sc->nvifs)
+		ath5k_hw_write_rate_duration(ah, mode);
+
+	/* Set RSSI/BRSSI thresholds
+	 *
+	 * Note: If we decide to set this value
+	 * dynamicaly, have in mind that when AR5K_RSSI_THR
+	 * register is read it might return 0x40 if we haven't
+	 * wrote anything to it plus BMISS RSSI threshold is zeroed.
+	 * So doing a save/restore procedure here isn't the right
+	 * choice. Instead store it on ath5k_hw */
+	ath5k_hw_reg_write(ah, (AR5K_TUNE_RSSI_THRES |
+				AR5K_TUNE_BMISS_THRES <<
+				AR5K_RSSI_THR_BMISS_S),
+				AR5K_RSSI_THR);
+
+	/* MIC QoS support */
+	if (ah->ah_mac_srev >= AR5K_SREV_AR2413) {
+		ath5k_hw_reg_write(ah, 0x000100aa, AR5K_MIC_QOS_CTL);
+		ath5k_hw_reg_write(ah, 0x00003210, AR5K_MIC_QOS_SEL);
+	}
+
+	/* QoS NOACK Policy */
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah,
+			AR5K_REG_SM(2, AR5K_QOS_NOACK_2BIT_VALUES) |
+			AR5K_REG_SM(5, AR5K_QOS_NOACK_BIT_OFFSET)  |
+			AR5K_REG_SM(0, AR5K_QOS_NOACK_BYTE_OFFSET),
+			AR5K_QOS_NOACK);
+	}
+
+	/* Restore slot time and ACK timeouts */
+	if (ah->ah_coverage_class > 0)
+		ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);
+
+	return;
+}
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6b43f53..1c41fa83 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -29,6 +29,95 @@
 #include "rfbuffer.h"
 #include "rfgain.h"
 
+
+/******************\
+* Helper functions *
+\******************/
+
+/*
+ * Get the PHY Chip revision
+ */
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
+{
+	unsigned int i;
+	u32 srev;
+	u16 ret;
+
+	/*
+	 * Set the radio chip access register
+	 */
+	switch (chan) {
+	case CHANNEL_2GHZ:
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
+		break;
+	case CHANNEL_5GHZ:
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		break;
+	default:
+		return 0;
+	}
+
+	mdelay(2);
+
+	/* ...wait until PHY is ready and read the selected radio revision */
+	ath5k_hw_reg_write(ah, 0x00001c16, AR5K_PHY(0x34));
+
+	for (i = 0; i < 8; i++)
+		ath5k_hw_reg_write(ah, 0x00010000, AR5K_PHY(0x20));
+
+	if (ah->ah_version == AR5K_AR5210) {
+		srev = ath5k_hw_reg_read(ah, AR5K_PHY(256) >> 28) & 0xf;
+		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
+	} else {
+		srev = (ath5k_hw_reg_read(ah, AR5K_PHY(0x100)) >> 24) & 0xff;
+		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
+				((srev & 0x0f) << 4), 8);
+	}
+
+	/* Reset to the 5GHz mode */
+	ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+
+	return ret;
+}
+
+/*
+ * Check if a channel is supported
+ */
+bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags)
+{
+	/* Check if the channel is in our supported range */
+	if (flags & CHANNEL_2GHZ) {
+		if ((freq >= ah->ah_capabilities.cap_range.range_2ghz_min) &&
+		    (freq <= ah->ah_capabilities.cap_range.range_2ghz_max))
+			return true;
+	} else if (flags & CHANNEL_5GHZ)
+		if ((freq >= ah->ah_capabilities.cap_range.range_5ghz_min) &&
+		    (freq <= ah->ah_capabilities.cap_range.range_5ghz_max))
+			return true;
+
+	return false;
+}
+
+bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
+				struct ieee80211_channel *channel)
+{
+	u8 refclk_freq;
+
+	if ((ah->ah_radio == AR5K_RF5112) ||
+	(ah->ah_radio == AR5K_RF5413) ||
+	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
+		refclk_freq = 40;
+	else
+		refclk_freq = 32;
+
+	if ((channel->center_freq % refclk_freq != 0) &&
+	((channel->center_freq % refclk_freq < 10) ||
+	(channel->center_freq % refclk_freq > 22)))
+		return true;
+	else
+		return false;
+}
+
 /*
  * Used to modify RF Banks before writing them to AR5K_RF_BUFFER
  */
@@ -110,6 +199,78 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
 	return data;
 }
 
+/**
+ * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
+ *
+ * @ah: the &struct ath5k_hw
+ * @channel: the currently set channel upon reset
+ *
+ * Write the delta slope coefficient (used on pilot tracking ?) for OFDM
+ * operation on the AR5212 upon reset. This is a helper for ath5k_hw_phy_init.
+ *
+ * Since delta slope is floating point we split it on its exponent and
+ * mantissa and provide these values on hw.
+ *
+ * For more infos i think this patent is related
+ * http://www.freepatentsonline.com/7184495.html
+ */
+static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
+	struct ieee80211_channel *channel)
+{
+	/* Get exponent and mantissa and set it */
+	u32 coef_scaled, coef_exp, coef_man,
+		ds_coef_exp, ds_coef_man, clock;
+
+	BUG_ON(!(ah->ah_version == AR5K_AR5212) ||
+		!(channel->hw_value & CHANNEL_OFDM));
+
+	/* Get coefficient
+	 * ALGO: coef = (5 * clock / carrier_freq) / 2
+	 * we scale coef by shifting clock value by 24 for
+	 * better precision since we use integers */
+	/* TODO: Half/quarter rate */
+	clock =  (channel->hw_value & CHANNEL_TURBO) ? 80 : 40;
+	coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;
+
+	/* Get exponent
+	 * ALGO: coef_exp = 14 - highest set bit position */
+	coef_exp = ilog2(coef_scaled);
+
+	/* Doesn't make sense if it's zero*/
+	if (!coef_scaled || !coef_exp)
+		return -EINVAL;
+
+	/* Note: we've shifted coef_scaled by 24 */
+	coef_exp = 14 - (coef_exp - 24);
+
+
+	/* Get mantissa (significant digits)
+	 * ALGO: coef_mant = floor(coef_scaled* 2^coef_exp+0.5) */
+	coef_man = coef_scaled +
+		(1 << (24 - coef_exp - 1));
+
+	/* Calculate delta slope coefficient exponent
+	 * and mantissa (remove scaling) and set them on hw */
+	ds_coef_man = coef_man >> (24 - coef_exp);
+	ds_coef_exp = coef_exp - 16;
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
+
+	return 0;
+}
+
+int ath5k_hw_phy_disable(struct ath5k_hw *ah)
+{
+	/*Just a try M.F.*/
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+
+	return 0;
+}
+
+
 /**********************\
 * RF Gain optimization *
 \**********************/
@@ -436,7 +597,7 @@ done:
 /* Write initial RF gain table to set the RF sensitivity
  * this one works on all RF chips and has nothing to do
  * with gain_F calibration */
-int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
+static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
 	unsigned int i, size;
@@ -494,12 +655,11 @@ int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq)
 * RF Registers setup *
 \********************/
 
-
 /*
  * Setup RF registers by writing RF buffer on hw
  */
-int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-		unsigned int mode)
+static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
+	struct ieee80211_channel *channel, unsigned int mode)
 {
 	const struct ath5k_rf_reg *rf_regs;
 	const struct ath5k_ini_rfbuffer *ini_rfb;
@@ -822,24 +982,6 @@ int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 \**************************/
 
 /*
- * Check if a channel is supported
- */
-bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags)
-{
-	/* Check if the channel is in our supported range */
-	if (flags & CHANNEL_2GHZ) {
-		if ((freq >= ah->ah_capabilities.cap_range.range_2ghz_min) &&
-		    (freq <= ah->ah_capabilities.cap_range.range_2ghz_max))
-			return true;
-	} else if (flags & CHANNEL_5GHZ)
-		if ((freq >= ah->ah_capabilities.cap_range.range_5ghz_min) &&
-		    (freq <= ah->ah_capabilities.cap_range.range_5ghz_max))
-			return true;
-
-	return false;
-}
-
-/*
  * Convertion needed for RF5110
  */
 static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
@@ -1045,7 +1187,8 @@ static int ath5k_hw_rf2425_channel(struct ath5k_hw *ah,
 /*
  * Set a channel on the radio chip
  */
-int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
+static int ath5k_hw_channel(struct ath5k_hw *ah,
+		struct ieee80211_channel *channel)
 {
 	int ret;
 	/*
@@ -1419,31 +1562,12 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 	return ret;
 }
 
+
 /***************************\
 * Spur mitigation functions *
 \***************************/
 
-bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
-				struct ieee80211_channel *channel)
-{
-	u8 refclk_freq;
-
-	if ((ah->ah_radio == AR5K_RF5112) ||
-	(ah->ah_radio == AR5K_RF5413) ||
-	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
-		refclk_freq = 40;
-	else
-		refclk_freq = 32;
-
-	if ((channel->center_freq % refclk_freq != 0) &&
-	((channel->center_freq % refclk_freq < 10) ||
-	(channel->center_freq % refclk_freq > 22)))
-		return true;
-	else
-		return false;
-}
-
-void
+static void
 ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 				struct ieee80211_channel *channel)
 {
@@ -1666,63 +1790,6 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 	}
 }
 
-/********************\
-  Misc PHY functions
-\********************/
-
-int ath5k_hw_phy_disable(struct ath5k_hw *ah)
-{
-	/*Just a try M.F.*/
-	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
-
-	return 0;
-}
-
-/*
- * Get the PHY Chip revision
- */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
-{
-	unsigned int i;
-	u32 srev;
-	u16 ret;
-
-	/*
-	 * Set the radio chip access register
-	 */
-	switch (chan) {
-	case CHANNEL_2GHZ:
-		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
-		break;
-	case CHANNEL_5GHZ:
-		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
-		break;
-	default:
-		return 0;
-	}
-
-	mdelay(2);
-
-	/* ...wait until PHY is ready and read the selected radio revision */
-	ath5k_hw_reg_write(ah, 0x00001c16, AR5K_PHY(0x34));
-
-	for (i = 0; i < 8; i++)
-		ath5k_hw_reg_write(ah, 0x00010000, AR5K_PHY(0x20));
-
-	if (ah->ah_version == AR5K_AR5210) {
-		srev = ath5k_hw_reg_read(ah, AR5K_PHY(256) >> 28) & 0xf;
-		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
-	} else {
-		srev = (ath5k_hw_reg_read(ah, AR5K_PHY(0x100)) >> 24) & 0xff;
-		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
-				((srev & 0x0f) << 4), 8);
-	}
-
-	/* Reset to the 5GHz mode */
-	ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
-
-	return ret;
-}
 
 /*****************\
 * Antenna control *
@@ -2984,7 +3051,7 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 /*
  * Set transmission power
  */
-int
+static int
 ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		u8 ee_mode, u8 txpower)
 {
@@ -3108,3 +3175,176 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 
 	return ath5k_hw_txpower(ah, channel, ee_mode, txpower);
 }
+
+/*************\
+ Init function
+\*************/
+
+int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
+						u8 mode, u8 ee_mode, u8 freq)
+{
+	int ret, i;
+	u32 phy_tst1;
+
+	ret = 0;
+
+	/*
+	 * 5211/5212 Specific
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+
+		/*
+		 * Write initial RF gain settings
+		 * This should work for both 5111/5112
+		 */
+		ret = ath5k_hw_rfgain_init(ah, freq);
+		if (ret)
+			return ret;
+
+		mdelay(1);
+
+		/*
+		 * Set TX power
+		 */
+		ret = ath5k_hw_txpower(ah, channel, ee_mode,
+					ah->ah_txpower.txp_max_pwr / 2);
+		if (ret)
+			return ret;
+
+		/*
+		 * Write RF buffer
+		 */
+		ret = ath5k_hw_rfregs_init(ah, channel, mode);
+		if (ret)
+			return ret;
+
+
+		/* Write OFDM timings on 5212*/
+		if (ah->ah_version == AR5K_AR5212 &&
+			channel->hw_value & CHANNEL_OFDM) {
+
+			ret = ath5k_hw_write_ofdm_timings(ah, channel);
+			if (ret)
+				return ret;
+
+			/* Spur info is available only from EEPROM versions
+			 * greater than 5.3, but the EEPROM routines will use
+			 * static values for older versions */
+			if (ah->ah_mac_srev >= AR5K_SREV_AR5424)
+				ath5k_hw_set_spur_mitigation_filter(ah,
+								    channel);
+		}
+
+		/*Enable/disable 802.11b mode on 5111
+		(enable 2111 frequency converter + CCK)*/
+		if (ah->ah_radio == AR5K_RF5111) {
+			if (mode == AR5K_MODE_11B)
+				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
+				    AR5K_TXCFG_B_MODE);
+			else
+				AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
+				    AR5K_TXCFG_B_MODE);
+		}
+
+	} else {
+		/*
+		 * For 5210 we do all initialization using
+		 * initvals, so we don't have to modify
+		 * any settings (5210 also only supports
+		 * a/aturbo modes)
+		 */
+		mdelay(1);
+		/* Disable phy and wait */
+		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+		mdelay(1);
+	}
+
+	/* Set channel on PHY */
+	ret = ath5k_hw_channel(ah, channel);
+	if (ret)
+		return ret;
+
+	/*
+	 * Enable the PHY and wait until completion
+	 * This includes BaseBand and Synthesizer
+	 * activation.
+	 */
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+
+	/*
+	 * On 5211+ read activation -> rx delay
+	 * and use it.
+	 *
+	 * TODO: Half/quarter rate support
+	 */
+	if (ah->ah_version != AR5K_AR5210) {
+		u32 delay;
+		delay = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
+			AR5K_PHY_RX_DELAY_M;
+		delay = (channel->hw_value & CHANNEL_CCK) ?
+			((delay << 2) / 22) : (delay / 10);
+
+		udelay(100 + (2 * delay));
+	} else {
+		mdelay(1);
+	}
+
+	/*
+	 * Perform ADC test to see if baseband is ready
+	 * Set TX hold and check ADC test register
+	 */
+	phy_tst1 = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
+	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
+	for (i = 0; i <= 20; i++) {
+		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
+			break;
+		udelay(200);
+	}
+	ath5k_hw_reg_write(ah, phy_tst1, AR5K_PHY_TST1);
+
+	/*
+	 * Start automatic gain control calibration
+	 *
+	 * During AGC calibration RX path is re-routed to
+	 * a power detector so we don't receive anything.
+	 *
+	 * This method is used to calibrate some static offsets
+	 * used together with on-the fly I/Q calibration (the
+	 * one performed via ath5k_hw_phy_calibrate), which doesn't
+	 * interrupt rx path.
+	 *
+	 * While rx path is re-routed to the power detector we also
+	 * start a noise floor calibration to measure the
+	 * card's noise floor (the noise we measure when we are not
+	 * transmitting or receiving anything).
+	 *
+	 * If we are in a noisy environment, AGC calibration may time
+	 * out and/or noise floor calibration might timeout.
+	 */
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+				AR5K_PHY_AGCCTL_CAL | AR5K_PHY_AGCCTL_NF);
+
+	/* At the same time start I/Q calibration for QAM constellation
+	 * -no need for CCK- */
+	ah->ah_calibration = false;
+	if (!(mode == AR5K_MODE_11B)) {
+		ah->ah_calibration = true;
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
+				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
+				AR5K_PHY_IQ_RUN);
+	}
+
+	/* Wait for gain calibration to finish (we check for I/Q calibration
+	 * during ath5k_phy_calibrate) */
+	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_CAL, 0, false)) {
+		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
+			channel->center_freq);
+	}
+
+	/* Restore antenna mode */
+	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 84c717d..52eee34f 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -25,14 +25,52 @@ Queue Control Unit, DFS Control Unit Functions
 #include "debug.h"
 #include "base.h"
 
+
+/******************\
+* Helper functions *
+\******************/
+
 /*
- * Get properties for a transmit queue
+ * Get number of pending frames
+ * for a specific queue [5211+]
  */
-int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
-		struct ath5k_txq_info *queue_info)
+u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 {
-	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
-	return 0;
+	u32 pending;
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
+
+	/* Return if queue is declared inactive */
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+		return false;
+
+	/* XXX: How about AR5K_CFG_TXCNT ? */
+	if (ah->ah_version == AR5K_AR5210)
+		return false;
+
+	pending = ath5k_hw_reg_read(ah, AR5K_QUEUE_STATUS(queue));
+	pending &= AR5K_QCU_STS_FRMPENDCNT;
+
+	/* It's possible to have no frames pending even if TXE
+	 * is set. To indicate that q has not stopped return
+	 * true */
+	if (!pending && AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
+		return true;
+
+	return pending;
+}
+
+/*
+ * Set a transmit queue inactive
+ */
+void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
+{
+	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
+		return;
+
+	/* This queue will be skipped in further operations */
+	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
+	/*For SIMR setup*/
+	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
 }
 
 /*
@@ -50,6 +88,16 @@ static u16 ath5k_cw_validate(u16 cw_req)
 }
 
 /*
+ * Get properties for a transmit queue
+ */
+int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
+		struct ath5k_txq_info *queue_info)
+{
+	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
+	return 0;
+}
+
+/*
  * Set properties for a transmit queue
  */
 int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
@@ -172,48 +220,10 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	return queue;
 }
 
-/*
- * Get number of pending frames
- * for a specific queue [5211+]
- */
-u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
-{
-	u32 pending;
-	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
-	/* Return if queue is declared inactive */
-	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return false;
-
-	/* XXX: How about AR5K_CFG_TXCNT ? */
-	if (ah->ah_version == AR5K_AR5210)
-		return false;
-
-	pending = ath5k_hw_reg_read(ah, AR5K_QUEUE_STATUS(queue));
-	pending &= AR5K_QCU_STS_FRMPENDCNT;
-
-	/* It's possible to have no frames pending even if TXE
-	 * is set. To indicate that q has not stopped return
-	 * true */
-	if (!pending && AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
-		return true;
-
-	return pending;
-}
-
-/*
- * Set a transmit queue inactive
- */
-void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
-{
-	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
-		return;
-
-	/* This queue will be skipped in further operations */
-	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
-	/*For SIMR setup*/
-	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
-}
+/*******************************\
+* Single QCU/DCU initialization *
+\*******************************/
 
 /*
  * Set DFS properties for a transmit queue on DCU
@@ -512,6 +522,11 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	return 0;
 }
 
+
+/**************************\
+* Global QCU/DCU functions *
+\**************************/
+
 /*
  * Set slot time on DCU
  */
@@ -530,3 +545,26 @@ int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 	return 0;
 }
 
+int ath5k_hw_init_queues(struct ath5k_hw *ah)
+{
+	int i, ret;
+
+	/* TODO: HW Compression support for data queues */
+	/* TODO: Burst prefetch for data queues */
+
+	/*
+	 * Reset queues and start beacon timers at the end of the reset routine
+	 * This also sets QCU mask on each DCU for 1:1 qcu to dcu mapping
+	 * Note: If we want we can assign multiple qcus on one dcu.
+	 */
+	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
+		ret = ath5k_hw_reset_tx_queue(ah, i);
+		if (ret) {
+			ATH5K_ERR(ah->ah_sc,
+				"failed to reset TX queue #%d\n", i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 5b179d0..9dd5792 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -32,6 +32,11 @@
 #include "base.h"
 #include "debug.h"
 
+
+/******************\
+* Helper functions *
+\******************/
+
 /*
  * Check if a register write has been completed
  */
@@ -53,146 +58,165 @@ int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 	return (i <= 0) ? -EAGAIN : 0;
 }
 
+
+/*************************\
+* Clock related functions *
+\*************************/
+
 /**
- * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
- *
- * @ah: the &struct ath5k_hw
- * @channel: the currently set channel upon reset
+ * ath5k_hw_htoclock - Translate usec to hw clock units
  *
- * Write the delta slope coefficient (used on pilot tracking ?) for OFDM
- * operation on the AR5212 upon reset. This is a helper for ath5k_hw_reset().
- *
- * Since delta slope is floating point we split it on its exponent and
- * mantissa and provide these values on hw.
- *
- * For more infos i think this patent is related
- * http://www.freepatentsonline.com/7184495.html
+ * @ah: The &struct ath5k_hw
+ * @usec: value in microseconds
  */
-static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
-	struct ieee80211_channel *channel)
+unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
 {
-	/* Get exponent and mantissa and set it */
-	u32 coef_scaled, coef_exp, coef_man,
-		ds_coef_exp, ds_coef_man, clock;
-
-	BUG_ON(!(ah->ah_version == AR5K_AR5212) ||
-		!(channel->hw_value & CHANNEL_OFDM));
-
-	/* Get coefficient
-	 * ALGO: coef = (5 * clock / carrier_freq) / 2
-	 * we scale coef by shifting clock value by 24 for
-	 * better precision since we use integers */
-	/* TODO: Half/quarter rate */
-	clock =  (channel->hw_value & CHANNEL_TURBO) ? 80 : 40;
-	coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;
-
-	/* Get exponent
-	 * ALGO: coef_exp = 14 - highest set bit position */
-	coef_exp = ilog2(coef_scaled);
-
-	/* Doesn't make sense if it's zero*/
-	if (!coef_scaled || !coef_exp)
-		return -EINVAL;
-
-	/* Note: we've shifted coef_scaled by 24 */
-	coef_exp = 14 - (coef_exp - 24);
-
-
-	/* Get mantissa (significant digits)
-	 * ALGO: coef_mant = floor(coef_scaled* 2^coef_exp+0.5) */
-	coef_man = coef_scaled +
-		(1 << (24 - coef_exp - 1));
-
-	/* Calculate delta slope coefficient exponent
-	 * and mantissa (remove scaling) and set them on hw */
-	ds_coef_man = coef_man >> (24 - coef_exp);
-	ds_coef_exp = coef_exp - 16;
-
-	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-		AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
-	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-		AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
+	struct ath_common *common = ath5k_hw_common(ah);
+	return usec * common->clockrate;
+}
 
-	return 0;
+/**
+ * ath5k_hw_clocktoh - Translate hw clock units to usec
+ * @clock: value in hw clock units
+ */
+unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
+{
+	struct ath_common *common = ath5k_hw_common(ah);
+	return clock / common->clockrate;
 }
 
+/**
+ * ath5k_hw_set_clockrate - Set common->clockrate for the current channel
+ *
+ * @ah: The &struct ath5k_hw
+ */
+void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
+{
+	struct ieee80211_channel *channel = ah->ah_current_channel;
+	struct ath_common *common = ath5k_hw_common(ah);
+	int clock;
+
+	if (channel->hw_value & CHANNEL_5GHZ)
+		clock = 40; /* 802.11a */
+	else if (channel->hw_value & CHANNEL_CCK)
+		clock = 22; /* 802.11b */
+	else
+		clock = 44; /* 802.11g */
+
+	/* Clock rate in turbo modes is twice the normal rate */
+	if (channel->hw_value & CHANNEL_TURBO)
+		clock *= 2;
+
+	common->clockrate = clock;
+}
 
 /*
- * index into rates for control rates, we can set it up like this because
- * this is only used for AR5212 and we know it supports G mode
- */
-static const unsigned int control_rates[] =
-	{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
-
-/**
- * ath5k_hw_write_rate_duration - fill rate code to duration table
- *
- * @ah: the &struct ath5k_hw
- * @mode: one of enum ath5k_driver_mode
- *
- * Write the rate code to duration table upon hw reset. This is a helper for
- * ath5k_hw_reset(). It seems all this is doing is setting an ACK timeout on
- * the hardware, based on current mode, for each rate. The rates which are
- * capable of short preamble (802.11b rates 2Mbps, 5.5Mbps, and 11Mbps) have
- * different rate code so we write their value twice (one for long preample
- * and one for short).
+ * If there is an external 32KHz crystal available, use it
+ * as ref. clock instead of 32/40MHz clock and baseband clocks
+ * to save power during sleep or restore normal 32/40MHz
+ * operation.
  *
- * Note: Band doesn't matter here, if we set the values for OFDM it works
- * on both a and g modes. So all we have to do is set values for all g rates
- * that include all OFDM and CCK rates. If we operate in turbo or xr/half/
- * quarter rate mode, we need to use another set of bitrates (that's why we
- * need the mode parameter) but we don't handle these proprietary modes yet.
+ * XXX: When operating on 32KHz certain PHY registers (27 - 31,
+ *	123 - 127) require delay on access.
  */
-static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
-       unsigned int mode)
+static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
-	struct ieee80211_rate *rate;
-	unsigned int i;
-
-	/* Write rate duration table */
-	for (i = 0; i < sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates; i++) {
-		u32 reg;
-		u16 tx_time;
-
-		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[control_rates[i]];
-
-		/* Set ACK timeout */
-		reg = AR5K_RATE_DUR(rate->hw_value);
-
-		/* An ACK frame consists of 10 bytes. If you add the FCS,
-		 * which ieee80211_generic_frame_duration() adds,
-		 * its 14 bytes. Note we use the control rate and not the
-		 * actual rate for this rate. See mac80211 tx.c
-		 * ieee80211_duration() for a brief description of
-		 * what rate we should choose to TX ACKs. */
-		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
-							NULL, 10, rate));
-
-		ath5k_hw_reg_write(ah, tx_time, reg);
-
-		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
-			continue;
-
-		/*
-		 * We're not distinguishing short preamble here,
-		 * This is true, all we'll get is a longer value here
-		 * which is not necessarilly bad. We could use
-		 * export ieee80211_frame_duration() but that needs to be
-		 * fixed first to be properly used by mac802111 drivers:
-		 *
-		 *  - remove erp stuff and let the routine figure ofdm
-		 *    erp rates
-		 *  - remove passing argument ieee80211_local as
-		 *    drivers don't have access to it
-		 *  - move drivers using ieee80211_generic_frame_duration()
-		 *    to this
-		 */
-		ath5k_hw_reg_write(ah, tx_time,
-			reg + (AR5K_SET_SHORT_PREAMBLE << 2));
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	u32 scal, spending, usec32;
+
+	/* Only set 32KHz settings if we have an external
+	 * 32KHz crystal present */
+	if ((AR5K_EEPROM_HAS32KHZCRYSTAL(ee->ee_misc1) ||
+	AR5K_EEPROM_HAS32KHZCRYSTAL_OLD(ee->ee_misc1)) &&
+	enable) {
+
+		/* 1 usec/cycle */
+		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, 1);
+		/* Set up tsf increment on each cycle */
+		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 61);
+
+		/* Set baseband sleep control registers
+		 * and sleep control rate */
+		ath5k_hw_reg_write(ah, 0x1f, AR5K_PHY_SCR);
+
+		if ((ah->ah_radio == AR5K_RF5112) ||
+		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
+			spending = 0x14;
+		else
+			spending = 0x18;
+		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
+
+		if ((ah->ah_radio == AR5K_RF5112) ||
+		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
+			ath5k_hw_reg_write(ah, 0x26, AR5K_PHY_SLMT);
+			ath5k_hw_reg_write(ah, 0x0d, AR5K_PHY_SCAL);
+			ath5k_hw_reg_write(ah, 0x07, AR5K_PHY_SCLOCK);
+			ath5k_hw_reg_write(ah, 0x3f, AR5K_PHY_SDELAY);
+			AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
+				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0x02);
+		} else {
+			ath5k_hw_reg_write(ah, 0x0a, AR5K_PHY_SLMT);
+			ath5k_hw_reg_write(ah, 0x0c, AR5K_PHY_SCAL);
+			ath5k_hw_reg_write(ah, 0x03, AR5K_PHY_SCLOCK);
+			ath5k_hw_reg_write(ah, 0x20, AR5K_PHY_SDELAY);
+			AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
+				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0x03);
+		}
+
+		/* Enable sleep clock operation */
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG,
+				AR5K_PCICFG_SLEEP_CLOCK_EN);
+
+	} else {
+
+		/* Disable sleep clock operation and
+		 * restore default parameters */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
+				AR5K_PCICFG_SLEEP_CLOCK_EN);
+
+		AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
+				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0);
+
+		ath5k_hw_reg_write(ah, 0x1f, AR5K_PHY_SCR);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
+
+		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
+			scal = AR5K_PHY_SCAL_32MHZ_2417;
+		else if (ee->ee_is_hb63)
+			scal = AR5K_PHY_SCAL_32MHZ_HB63;
+		else
+			scal = AR5K_PHY_SCAL_32MHZ;
+		ath5k_hw_reg_write(ah, scal, AR5K_PHY_SCAL);
+
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
+
+		if ((ah->ah_radio == AR5K_RF5112) ||
+		(ah->ah_radio == AR5K_RF5413) ||
+		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
+			spending = 0x14;
+		else
+			spending = 0x18;
+		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
+
+		if ((ah->ah_radio == AR5K_RF5112) ||
+		(ah->ah_radio == AR5K_RF5413))
+			usec32 = 39;
+		else
+			usec32 = 31;
+		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, usec32);
+
+		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 1);
 	}
 }
 
+
+/*********************\
+* Reset/Sleep control *
+\*********************/
+
 /*
  * Reset chipset
  */
@@ -522,107 +546,10 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	return 0;
 }
 
-/*
- * If there is an external 32KHz crystal available, use it
- * as ref. clock instead of 32/40MHz clock and baseband clocks
- * to save power during sleep or restore normal 32/40MHz
- * operation.
- *
- * XXX: When operating on 32KHz certain PHY registers (27 - 31,
- * 	123 - 127) require delay on access.
- */
-static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 scal, spending, usec32;
 
-	/* Only set 32KHz settings if we have an external
-	 * 32KHz crystal present */
-	if ((AR5K_EEPROM_HAS32KHZCRYSTAL(ee->ee_misc1) ||
-	AR5K_EEPROM_HAS32KHZCRYSTAL_OLD(ee->ee_misc1)) &&
-	enable) {
-
-		/* 1 usec/cycle */
-		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, 1);
-		/* Set up tsf increment on each cycle */
-		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 61);
-
-		/* Set baseband sleep control registers
-		 * and sleep control rate */
-		ath5k_hw_reg_write(ah, 0x1f, AR5K_PHY_SCR);
-
-		if ((ah->ah_radio == AR5K_RF5112) ||
-		(ah->ah_radio == AR5K_RF5413) ||
-		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
-			spending = 0x14;
-		else
-			spending = 0x18;
-		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
-
-		if ((ah->ah_radio == AR5K_RF5112) ||
-		(ah->ah_radio == AR5K_RF5413) ||
-		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
-			ath5k_hw_reg_write(ah, 0x26, AR5K_PHY_SLMT);
-			ath5k_hw_reg_write(ah, 0x0d, AR5K_PHY_SCAL);
-			ath5k_hw_reg_write(ah, 0x07, AR5K_PHY_SCLOCK);
-			ath5k_hw_reg_write(ah, 0x3f, AR5K_PHY_SDELAY);
-			AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
-				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0x02);
-		} else {
-			ath5k_hw_reg_write(ah, 0x0a, AR5K_PHY_SLMT);
-			ath5k_hw_reg_write(ah, 0x0c, AR5K_PHY_SCAL);
-			ath5k_hw_reg_write(ah, 0x03, AR5K_PHY_SCLOCK);
-			ath5k_hw_reg_write(ah, 0x20, AR5K_PHY_SDELAY);
-			AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
-				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0x03);
-		}
-
-		/* Enable sleep clock operation */
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG,
-				AR5K_PCICFG_SLEEP_CLOCK_EN);
-
-	} else {
-
-		/* Disable sleep clock operation and
-		 * restore default parameters */
-		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
-				AR5K_PCICFG_SLEEP_CLOCK_EN);
-
-		AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
-				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0);
-
-		ath5k_hw_reg_write(ah, 0x1f, AR5K_PHY_SCR);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
-
-		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
-			scal = AR5K_PHY_SCAL_32MHZ_2417;
-		else if (ee->ee_is_hb63)
-			scal = AR5K_PHY_SCAL_32MHZ_HB63;
-		else
-			scal = AR5K_PHY_SCAL_32MHZ;
-		ath5k_hw_reg_write(ah, scal, AR5K_PHY_SCAL);
-
-		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
-		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-
-		if ((ah->ah_radio == AR5K_RF5112) ||
-		(ah->ah_radio == AR5K_RF5413) ||
-		(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
-			spending = 0x14;
-		else
-			spending = 0x18;
-		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
-
-		if ((ah->ah_radio == AR5K_RF5112) ||
-		(ah->ah_radio == AR5K_RF5413))
-			usec32 = 39;
-		else
-			usec32 = 31;
-		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, usec32);
-
-		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 1);
-	}
-}
+/**************************************\
+* Post-initvals register modifications *
+\**************************************/
 
 /* TODO: Half/Quarter rate */
 static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
@@ -705,7 +632,8 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
 	}
 
-	if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
+	if ((ah->ah_radio == AR5K_RF5112) &&
+	(ah->ah_mac_srev < AR5K_SREV_AR5211)) {
 		u32 usec_reg;
 		/* 5311 has different tx/rx latency masks
 		 * from 5211, since we deal 5311 the same
@@ -734,6 +662,10 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	s16 cck_ofdm_pwr_delta;
 
+	/* TODO: Add support for AR5210 EEPROM */
+	if (ah->ah_version == AR5K_AR5210)
+		return;
+
 	/* Adjust power delta for channel 14 */
 	if (channel->center_freq == 2484)
 		cck_ofdm_pwr_delta =
@@ -870,15 +802,16 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 		ath5k_hw_reg_write(ah, 0, AR5K_PHY_HEAVY_CLIP_ENABLE);
 }
 
-/*
- * Main reset function
- */
+
+/*********************\
+* Main reset function *
+\*********************/
+
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 s_seq[10], s_led[3], staid1_flags, tsf_up, tsf_lo;
-	u32 phy_tst1;
 	u8 mode, freq, ee_mode;
 	int i, ret;
 
@@ -1026,93 +959,15 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		return ret;
 
 	/*
-	 * 5211/5212 Specific
+	 * Tweak initval settings for revised
+	 * chipsets and add some more config
+	 * bits
 	 */
-	if (ah->ah_version != AR5K_AR5210) {
+	ath5k_hw_tweak_initval_settings(ah, channel);
 
-		/*
-		 * Write initial RF gain settings
-		 * This should work for both 5111/5112
-		 */
-		ret = ath5k_hw_rfgain_init(ah, freq);
-		if (ret)
-			return ret;
+	/* Commit values from EEPROM */
+	ath5k_hw_commit_eeprom_settings(ah, channel, ee_mode);
 
-		mdelay(1);
-
-		/*
-		 * Tweak initval settings for revised
-		 * chipsets and add some more config
-		 * bits
-		 */
-		ath5k_hw_tweak_initval_settings(ah, channel);
-
-		/*
-		 * Set TX power
-		 */
-		ret = ath5k_hw_txpower(ah, channel, ee_mode,
-					ah->ah_txpower.txp_max_pwr / 2);
-		if (ret)
-			return ret;
-
-		/* Write rate duration table only on AR5212 and if
-		 * virtual interface has already been brought up
-		 * XXX: rethink this after new mode changes to
-		 * mac80211 are integrated */
-		if (ah->ah_version == AR5K_AR5212 &&
-			ah->ah_sc->nvifs)
-			ath5k_hw_write_rate_duration(ah, mode);
-
-		/*
-		 * Write RF buffer
-		 */
-		ret = ath5k_hw_rfregs_init(ah, channel, mode);
-		if (ret)
-			return ret;
-
-
-		/* Write OFDM timings on 5212*/
-		if (ah->ah_version == AR5K_AR5212 &&
-			channel->hw_value & CHANNEL_OFDM) {
-
-			ret = ath5k_hw_write_ofdm_timings(ah, channel);
-			if (ret)
-				return ret;
-
-			/* Spur info is available only from EEPROM versions
-			 * greater than 5.3, but the EEPROM routines will use
-			 * static values for older versions */
-			if (ah->ah_mac_srev >= AR5K_SREV_AR5424)
-				ath5k_hw_set_spur_mitigation_filter(ah,
-								    channel);
-		}
-
-		/*Enable/disable 802.11b mode on 5111
-		(enable 2111 frequency converter + CCK)*/
-		if (ah->ah_radio == AR5K_RF5111) {
-			if (mode == AR5K_MODE_11B)
-				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
-				    AR5K_TXCFG_B_MODE);
-			else
-				AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
-				    AR5K_TXCFG_B_MODE);
-		}
-
-		/* Commit values from EEPROM */
-		ath5k_hw_commit_eeprom_settings(ah, channel, ee_mode);
-
-	} else {
-		/*
-		 * For 5210 we do all initialization using
-		 * initvals, so we don't have to modify
-		 * any settings (5210 also only supports
-		 * a/aturbo modes)
-		 */
-		mdelay(1);
-		/* Disable phy and wait */
-		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
-		mdelay(1);
-	}
 
 	/*
 	 * Restore saved values
@@ -1156,194 +1011,39 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 
 	/*
-	 * Configure PCU
+	 * Initialize PCU
 	 */
-
-	/* Restore bssid and bssid mask */
-	ath5k_hw_set_bssid(ah);
-
-	/* Set PCU config */
-	ath5k_hw_set_opmode(ah, op_mode);
+	ath5k_hw_pcu_init(ah, op_mode, mode);
 
 	/* Clear any pending interrupts
 	 * PISR/SISR Not available on 5210 */
 	if (ah->ah_version != AR5K_AR5210)
 		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
 
-	/* Set RSSI/BRSSI thresholds
-	 *
-	 * Note: If we decide to set this value
-	 * dynamically, keep in mind that when AR5K_RSSI_THR
-	 * register is read, it might return 0x40 if we haven't
-	 * written anything to it.  Also, BMISS RSSI threshold is zeroed.
-	 * So doing a save/restore procedure here isn't the right
-	 * choice. Instead, store it in ath5k_hw */
-	ath5k_hw_reg_write(ah, (AR5K_TUNE_RSSI_THRES |
-				AR5K_TUNE_BMISS_THRES <<
-				AR5K_RSSI_THR_BMISS_S),
-				AR5K_RSSI_THR);
-
-	/* MIC QoS support */
-	if (ah->ah_mac_srev >= AR5K_SREV_AR2413) {
-		ath5k_hw_reg_write(ah, 0x000100aa, AR5K_MIC_QOS_CTL);
-		ath5k_hw_reg_write(ah, 0x00003210, AR5K_MIC_QOS_SEL);
-	}
-
-	/* QoS NOACK Policy */
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(2, AR5K_QOS_NOACK_2BIT_VALUES) |
-			AR5K_REG_SM(5, AR5K_QOS_NOACK_BIT_OFFSET)  |
-			AR5K_REG_SM(0, AR5K_QOS_NOACK_BYTE_OFFSET),
-			AR5K_QOS_NOACK);
-	}
-
-
 	/*
-	 * Configure PHY
+	 * Initialize PHY
 	 */
-
-	/* Set channel on PHY */
-	ret = ath5k_hw_channel(ah, channel);
-	if (ret)
+	ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, freq);
+	if (ret) {
+		ATH5K_ERR(ah->ah_sc,
+			"failed to initialize PHY (%i) !\n", ret);
 		return ret;
-
-	/*
-	 * Enable the PHY and wait until completion
-	 * This includes BaseBand and Synthesizer
-	 * activation.
-	 */
-	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
-
-	/*
-	 * On 5211+ read activation -> rx delay
-	 * and use it.
-	 *
-	 * TODO: Half/quarter rate support
-	 */
-	if (ah->ah_version != AR5K_AR5210) {
-		u32 delay;
-		delay = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
-			AR5K_PHY_RX_DELAY_M;
-		delay = (channel->hw_value & CHANNEL_CCK) ?
-			((delay << 2) / 22) : (delay / 10);
-
-		udelay(100 + (2 * delay));
-	} else {
-		mdelay(1);
 	}
 
 	/*
-	 * Perform ADC test to see if baseband is ready
-	 * Set TX hold and check ADC test register
-	 */
-	phy_tst1 = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
-	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
-	for (i = 0; i <= 20; i++) {
-		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
-			break;
-		udelay(200);
-	}
-	ath5k_hw_reg_write(ah, phy_tst1, AR5K_PHY_TST1);
-
-	/*
-	 * Start automatic gain control calibration
-	 *
-	 * During AGC calibration RX path is re-routed to
-	 * a power detector so we don't receive anything.
-	 *
-	 * This method is used to calibrate some static offsets
-	 * used together with on-the fly I/Q calibration (the
-	 * one performed via ath5k_hw_phy_calibrate), which doesn't
-	 * interrupt rx path.
-	 *
-	 * While rx path is re-routed to the power detector we also
-	 * start a noise floor calibration to measure the
-	 * card's noise floor (the noise we measure when we are not
-	 * transmitting or receiving anything).
-	 *
-	 * If we are in a noisy environment, AGC calibration may time
-	 * out and/or noise floor calibration might timeout.
-	 */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
-				AR5K_PHY_AGCCTL_CAL | AR5K_PHY_AGCCTL_NF);
-
-	/* At the same time start I/Q calibration for QAM constellation
-	 * -no need for CCK- */
-	ah->ah_calibration = false;
-	if (!(mode == AR5K_MODE_11B)) {
-		ah->ah_calibration = true;
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
-				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
-				AR5K_PHY_IQ_RUN);
-	}
-
-	/* Wait for gain calibration to finish (we check for I/Q calibration
-	 * during ath5k_phy_calibrate) */
-	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_CAL, 0, false)) {
-		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
-			channel->center_freq);
-	}
-
-	/* Restore antenna mode */
-	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
-
-	/* Restore slot time and ACK timeouts */
-	if (ah->ah_coverage_class > 0)
-		ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);
-
-	/*
 	 * Configure QCUs/DCUs
 	 */
+	ret = ath5k_hw_init_queues(ah);
+	if (ret)
+		return ret;
 
-	/* TODO: HW Compression support for data queues */
-	/* TODO: Burst prefetch for data queues */
 
 	/*
-	 * Reset queues and start beacon timers at the end of the reset routine
-	 * This also sets QCU mask on each DCU for 1:1 qcu to dcu mapping
-	 * Note: If we want we can assign multiple qcus on one dcu.
+	 * Initialize DMA/Interrupts
 	 */
-	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
-		ret = ath5k_hw_reset_tx_queue(ah, i);
-		if (ret) {
-			ATH5K_ERR(ah->ah_sc,
-				"failed to reset TX queue #%d\n", i);
-			return ret;
-		}
-	}
+	ath5k_hw_dma_init(ah);
 
 
-	/*
-	 * Configure DMA/Interrupts
-	 */
-
-	/*
-	 * Set Rx/Tx DMA Configuration
-	 *
-	 * Set standard DMA size (128). Note that
-	 * a DMA size of 512 causes rx overruns and tx errors
-	 * on pci-e cards (tested on 5424 but since rx overruns
-	 * also occur on 5416/5418 with madwifi we set 128
-	 * for all PCI-E cards to be safe).
-	 *
-	 * XXX: need to check 5210 for this
-	 * TODO: Check out tx triger level, it's always 64 on dumps but I
-	 * guess we can tweak it and see how it goes ;-)
-	 */
-	if (ah->ah_version != AR5K_AR5210) {
-		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
-			AR5K_TXCFG_SDMAMR, AR5K_DMASIZE_128B);
-		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG,
-			AR5K_RXCFG_SDMAMW, AR5K_DMASIZE_128B);
-	}
-
-	/* Pre-enable interrupts on 5211/5212*/
-	if (ah->ah_version != AR5K_AR5210)
-		ath5k_hw_set_imr(ah, ah->ah_imr);
-
 	/* Enable 32KHz clock function for AR5212+ chips
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
