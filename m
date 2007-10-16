Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38399 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932211AbXJPNU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 09:20:56 -0400
From: Bruno Randolf <bruno@thinktube.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/3] ath5k global rename of hal to hw
Date: Tue, 16 Oct 2007 22:20:36 +0900
Message-Id: <1192540838-26985-2-git-send-email-bruno@thinktube.com> (sfid-20071016_142108_657551_B2093121)
In-Reply-To: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i don't want to see that dreaded HAL word again ;) 

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h    |  170 +++---
 drivers/net/wireless/ath5k/base.c     |   20 +-
 drivers/net/wireless/ath5k/base.h     |    2 +-
 drivers/net/wireless/ath5k/hw.c       | 1310 ++++++++++++++++----------------
 drivers/net/wireless/ath5k/hw.h       |   44 +-
 drivers/net/wireless/ath5k/initvals.c |   56 +-
 drivers/net/wireless/ath5k/phy.c      |  468 ++++++------
 drivers/net/wireless/ath5k/reg.h      |   70 +-
 8 files changed, 1070 insertions(+), 1070 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index bcf1041..9b5dd87 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -277,7 +277,7 @@ enum ath5k_tx_queue_subtype {
 };
 
 /*
- * Queue ID numbers as returned by the HAL, each number
+ * Queue ID numbers as returned by the hardware, each number
  * represents a hw queue. If hw does not support hw queues
  * (eg 5210) all data goes in one queue. These match
  * d80211 definitions (net80211/MadWiFi don't use them).
@@ -342,11 +342,11 @@ enum ath5k_pkt_type {
  */
 #define AR5K_TXPOWER_OFDM(_r, _v)	(			\
 	((0 & 1) << ((_v) + 6)) |				\
-	(((hal->ah_txpower.txp_rates[(_r)]) & 0x3f) << (_v))	\
+	(((hw->ah_txpower.txp_rates[(_r)]) & 0x3f) << (_v))	\
 )
 
 #define AR5K_TXPOWER_CCK(_r, _v)	(			\
-	(hal->ah_txpower.txp_rates[(_r)] & 0x3f) << (_v)	\
+	(hw->ah_txpower.txp_rates[(_r)] & 0x3f) << (_v)	\
 )
 
 /*
@@ -720,7 +720,7 @@ enum ath5k_ant_setting {
 };
 
 /*
- * HAL interrupt abstraction
+ * HW interrupt abstraction
  */
 
 /**
@@ -836,7 +836,7 @@ enum ath5k_power_mode {
 #define AR5K_SOFTLED_OFF	1
 
 /*
- * Chipset capabilities -see ath_hal_getcapability-
+ * Chipset capabilities -see ath5k_hw_getcapability-
  * get_capability function is not yet fully implemented
  * in OpenHAL so most of these don't work yet...
  */
@@ -1016,123 +1016,123 @@ struct ath_hw {
  */
 
 /* General Functions */
-extern int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val, bool is_set);
+extern int ath5k_hw_register_timeout(struct ath_hw *hw, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
 extern struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
-extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal, unsigned int mode);
-extern void ath5k_hw_detach(struct ath_hw *hal);
+extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hw, unsigned int mode);
+extern void ath5k_hw_detach(struct ath_hw *hw);
 /* Reset Functions */
-extern int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
+extern int ath5k_hw_reset(struct ath_hw *hw, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
-extern int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
+extern int ath5k_hw_set_power(struct ath_hw *hw, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
 /* DMA Related Functions */
-extern void ath5k_hw_start_rx(struct ath_hw *hal);
-extern int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
-extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
-extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
-extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
-extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
-extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
+extern void ath5k_hw_start_rx(struct ath_hw *hw);
+extern int ath5k_hw_stop_rx_dma(struct ath_hw *hw);
+extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hw);
+extern void ath5k_hw_put_rx_buf(struct ath_hw *hw, u32 phys_addr);
+extern int ath5k_hw_tx_start(struct ath_hw *hw, unsigned int queue);
+extern int ath5k_hw_stop_tx_dma(struct ath_hw *hw, unsigned int queue);
+extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hw, unsigned int queue);
+extern int ath5k_hw_put_tx_buf(struct ath_hw *hw, unsigned int queue, u32 phys_addr);
+extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hw, bool increase);
 /* Interrupt handling */
-extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
-extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
-extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask);
+extern bool ath5k_hw_is_intr_pending(struct ath_hw *hw);
+extern int ath5k_hw_get_isr(struct ath_hw *hw, enum ath5k_int *interrupt_mask);
+extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hw, enum ath5k_int new_mask);
 /* EEPROM access functions */
-extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
+extern int ath5k_hw_set_regdomain(struct ath_hw *hw, u16 regdomain);
 /* Protocol Control Unit Functions */
-extern int ath5k_hw_set_opmode(struct ath_hw *hal);
+extern int ath5k_hw_set_opmode(struct ath_hw *hw);
 /* BSSID Functions */
-extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
-extern int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
-extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
-extern int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
+extern void ath5k_hw_get_lladdr(struct ath_hw *hw, u8 *mac);
+extern int ath5k_hw_set_lladdr(struct ath_hw *hw, const u8 *mac);
+extern void ath5k_hw_set_associd(struct ath_hw *hw, const u8 *bssid, u16 assoc_id);
+extern int ath5k_hw_set_bssid_mask(struct ath_hw *hw, const u8 *mask);
 /* Receive start/stop functions */
-extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
-extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
+extern void ath5k_hw_start_rx_pcu(struct ath_hw *hw);
+extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hw);
 /* RX Filter functions */
-extern void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
-extern int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
-extern int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
+extern void ath5k_hw_set_mcast_filter(struct ath_hw *hw, u32 filter0, u32 filter1);
+extern int ath5k_hw_set_mcast_filterindex(struct ath_hw *hw, u32 index);
+extern int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hw, u32 index);
 extern u32 ath5k_hw_get_rx_filter(struct ath_hw *ah);
 extern void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter);
 /* Beacon related functions */
-extern u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
-extern u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
-extern void ath5k_hw_reset_tsf(struct ath_hw *hal);
-extern void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
-extern int ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
-extern void ath5k_hw_reset_beacon(struct ath_hw *hal);
-extern int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
-extern void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
+extern u32 ath5k_hw_get_tsf32(struct ath_hw *hw);
+extern u64 ath5k_hw_get_tsf64(struct ath_hw *hw);
+extern void ath5k_hw_reset_tsf(struct ath_hw *hw);
+extern void ath5k_hw_init_beacon(struct ath_hw *hw, u32 next_beacon, u32 interval);
+extern int ath5k_hw_set_beacon_timers(struct ath_hw *hw, const struct ath5k_beacon_state *state);
+extern void ath5k_hw_reset_beacon(struct ath_hw *hw);
+extern int ath5k_hw_wait_for_beacon(struct ath_hw *hw, unsigned long phys_addr);
+extern void ath5k_hw_update_mib_counters(struct ath_hw *hw, struct ath5k_mib_stats *statistics);
 /* ACK/CTS Timeouts */
-extern int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
-extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
-extern int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
-extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
+extern int ath5k_hw_set_ack_timeout(struct ath_hw *hw, unsigned int timeout);
+extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hw);
+extern int ath5k_hw_set_cts_timeout(struct ath_hw *hw, unsigned int timeout);
+extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hw);
 /* Key table (WEP) functions */
-extern int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
-extern int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry);
-extern int ath5k_hw_set_key(struct ath_hw *hal, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
-extern int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac);
+extern int ath5k_hw_reset_key(struct ath_hw *hw, u16 entry);
+extern int ath5k_hw_is_key_valid(struct ath_hw *hw, u16 entry);
+extern int ath5k_hw_set_key(struct ath_hw *hw, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
+extern int ath5k_hw_set_key_lladdr(struct ath_hw *hw, u16 entry, const u8 *mac);
 /* Queue Control Unit, DFS Control Unit Functions */
-extern int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue, const struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5k_txq_info *queue_info);
-extern void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
-extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
-extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
+extern int ath5k_hw_setup_tx_queue(struct ath_hw *hw, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_setup_tx_queueprops(struct ath_hw *hw, int queue, const struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hw, int queue, struct ath5k_txq_info *queue_info);
+extern void ath5k_hw_release_tx_queue(struct ath_hw *hw, unsigned int queue);
+extern int ath5k_hw_reset_tx_queue(struct ath_hw *hw, unsigned int queue);
+extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hw, unsigned int queue);
+extern int ath5k_hw_set_slot_time(struct ath_hw *hw, unsigned int slot_time);
+extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hw);
 /* Hardware Descriptor Functions */
-extern int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
+extern int ath5k_hw_setup_rx_desc(struct ath_hw *hw, struct ath_desc *desc, u32 size, unsigned int flags);
 /* GPIO Functions */
-extern void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state);
-extern int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio);
-extern int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio);
-extern u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio);
-extern int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val);
-extern void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio, u32 interrupt_level);
+extern void ath5k_hw_set_ledstate(struct ath_hw *hw, unsigned int state);
+extern int ath5k_hw_set_gpio_output(struct ath_hw *hw, u32 gpio);
+extern int ath5k_hw_set_gpio_input(struct ath_hw *hw, u32 gpio);
+extern u32 ath5k_hw_get_gpio(struct ath_hw *hw, u32 gpio);
+extern int ath5k_hw_set_gpio(struct ath_hw *hw, u32 gpio, u32 val);
+extern void ath5k_hw_set_gpio_intr(struct ath_hw *hw, unsigned int gpio, u32 interrupt_level);
 /* Regulatory Domain/Channels Setup */
-extern u16 ath5k_get_regdomain(struct ath_hw *hal);
+extern u16 ath5k_get_regdomain(struct ath_hw *hw);
 /* Misc functions */
-extern void ath5k_hw_dump_state(struct ath_hw *hal);
-extern int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
+extern void ath5k_hw_dump_state(struct ath_hw *hw);
+extern int ath5k_hw_get_capability(struct ath_hw *hw, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
 
 
 /* Initial register settings functions */
-extern int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel);
+extern int ath5k_hw_write_initvals(struct ath_hw *hw, u8 mode, bool change_channel);
 /* Initialize RF */
-extern int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int mode);
-extern int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq);
-extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal);
-extern int ath5k_hw_set_rfgain_opt(struct ath_hw *hal);
+extern int ath5k_hw_rfregs(struct ath_hw *hw, struct ieee80211_channel *channel, unsigned int mode);
+extern int ath5k_hw_rfgain(struct ath_hw *hw, unsigned int freq);
+extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hw);
+extern int ath5k_hw_set_rfgain_opt(struct ath_hw *hw);
 
 
 /* PHY/RF channel functions */
-extern bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags);
-extern int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel);
+extern bool ath5k_channel_ok(struct ath_hw *hw, u16 freq, unsigned int flags);
+extern int ath5k_hw_channel(struct ath_hw *hw, struct ieee80211_channel *channel);
 /* PHY calibration */
-extern int ath5k_hw_phy_calibrate(struct ath_hw *hal, struct ieee80211_channel *channel);
-extern int ath5k_hw_phy_disable(struct ath_hw *hal);
+extern int ath5k_hw_phy_calibrate(struct ath_hw *hw, struct ieee80211_channel *channel);
+extern int ath5k_hw_phy_disable(struct ath_hw *hw);
 /* Misc PHY functions */
-extern u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan);
-extern void ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant);
-extern unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal);
+extern u16 ath5k_hw_radio_revision(struct ath_hw *hw, unsigned int chan);
+extern void ath5k_hw_set_def_antenna(struct ath_hw *hw, unsigned int ant);
+extern unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hw);
 /* TX power setup */
-extern int ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int txpower);
-extern int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
+extern int ath5k_hw_txpower(struct ath_hw *hw, struct ieee80211_channel *channel, unsigned int txpower);
+extern int ath5k_hw_set_txpower_limit(struct ath_hw *hw, unsigned int power);
 
 
-static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
+static inline u32 ath5k_hw_reg_read(struct ath_hw *hw, u16 reg)
 {
-	return ioread32(hal->ah_sh + reg);
+	return ioread32(hw->ah_sh + reg);
 }
 
-static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
+static inline void ath5k_hw_reg_write(struct ath_hw *hw, u32 val, u16 reg)
 {
-	iowrite32(val, hal->ah_sh + reg);
+	iowrite32(val, hw->ah_sh + reg);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 5ca6af1..2f2ae33 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -116,7 +116,7 @@ module_param_named(debug, ath_debug, uint, 0);
 /*
  * User a static table of PCI id's for now.  While this is the
  * "new way" to do things, we may want to switch back to having
- * the HAL check them by defining a probe method.
+ * check them by defining a probe method.
  */
 static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
@@ -341,7 +341,7 @@ static unsigned int ath_rx_decrypted(struct ath_softc *sc,
 		return RX_FLAG_DECRYPTED;
 
 	/* Apparently when a default key is used to decrypt the packet
-	   the hal does not set the index used to decrypt.  In such cases
+	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
 	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED) &&
 			!(ds->ds_rxstat.rs_status & AR5K_RXERR_DECRYPT) &&
@@ -605,7 +605,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
 		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
 				sc->bhalq);
-		/* NB: the HAL still stops DMA, so proceed */
+		/* NB: the HW still stops DMA, so proceed */
 	}
 	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
 			PCI_DMA_TODEVICE);
@@ -1285,7 +1285,7 @@ static int ath_reset(struct ieee80211_hw *hw)
 
 	DPRINTF(sc, ATH_DEBUG_RESET, "resetting\n");
 	/*
-	 * Convert to a HAL channel description with the flags
+	 * Convert to a HW channel description with the flags
 	 * constrained to reflect the current operating mode.
 	 */
 	sc->curchan = hw->conf.chan;
@@ -1748,7 +1748,7 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 	do {
 		/*
 		* Figure out the reason(s) for the interrupt.  Note
-		* that the hal returns a pseudo-ISR that may include
+		* that the hw returns a pseudo-ISR that may include
 		* bits we haven't explicitly enabled so we mask the
 		* value to insure we only process bits we requested.
 		*/
@@ -1761,7 +1761,7 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 			* Fatal errors are unrecoverable.  Typically
 			* these are caused by DMA errors.  Unfortunately
 			* the exact reason is not (presently) returned
-			* by the hal.
+			* by the hw.
 			*/
 			tasklet_schedule(&sc->restq);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
@@ -2158,7 +2158,7 @@ static struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype,
 		return ERR_PTR(qnum);
 	}
 	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		printk(KERN_ERR "hal qnum %u out of range, max %tu!\n",
+		printk(KERN_ERR "ath: qnum %u out of range, max %tu!\n",
 			qnum, ARRAY_SIZE(sc->txqs));
 		ath5k_hw_release_tx_queue(ah, qnum);
 		return ERR_PTR(-EINVAL);
@@ -2243,7 +2243,7 @@ static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Allocate hardware transmit queues: one queue for
 	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that the hal handles reseting
+	 * priority.  Note that the hw handles reseting
 	 * these queues at the needed time.
 	 */
 	ret = ath_beaconq_setup(ah);
@@ -2316,13 +2316,13 @@ static void ath_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	/*
 	 * NB: the order of these is important:
-	 * o call the 802.11 layer before detaching the hal to
+	 * o call the 802.11 layer before detaching the hw to
 	 *   insure callbacks into the driver to delete global
 	 *   key cache entries can be handled
 	 * o reclaim the tx queue data structures after calling
 	 *   the 802.11 layer as we'll get called back to reclaim
 	 *   node state and potentially want to use them
-	 * o to cleanup the tx queues the hal is called, so detach
+	 * o to cleanup the tx queues the hw is called, so detach
 	 *   it last
 	 * Other than that, it's straightforward...
 	 */
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 390d3d7..0c16c07 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -190,7 +190,7 @@ struct ath_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 
 	struct ath_buf		*bbuf;		/* beacon buffer */
-	unsigned int		bhalq,		/* HAL q for outgoing beacons */
+	unsigned int		bhalq,		/* HW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval */
 				bsent;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 504f642..040aee8 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -21,7 +21,7 @@
  */
 
 /*
- * HAL interface for Atheros Wireless LAN devices.
+ * HW interface for Atheros Wireless LAN devices.
  */
 
 #include <linux/pci.h>
@@ -84,7 +84,7 @@ static int ath5k_hw_disable_pspoll(struct ath_hw *);
  * TODO: Left here for combatibility, change it in ath5k
  */
 static u16 /*TODO: Is this really hardware dependent ?*/
-ath_hal_computetxtime(struct ath_hw *hal, const struct ath5k_rate_table *rates,
+ath_hw_computetxtime(struct ath_hw *hw, const struct ath5k_rate_table *rates,
 		u32 frame_length, u16 rate_index, bool short_preamble)
 {
 	const struct ath5k_rate *rate;
@@ -165,14 +165,14 @@ static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
 /*
  * Check if a register write has been completed
  */
-int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
+int ath5k_hw_register_timeout(struct ath_hw *hw, u32 reg, u32 flag, u32 val,
 		bool is_set)
 {
 	int i;
 	u32 data;
 
 	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
-		data = ath5k_hw_reg_read(hal, reg);
+		data = ath5k_hw_reg_read(hw, reg);
 		if ((is_set == true) && (data & flag))
 			break;
 		else if ((data & flag) == val)
@@ -194,41 +194,41 @@ int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
 struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		void __iomem *sh)
 {
-	struct ath_hw *hal;
+	struct ath_hw *hw;
 	u8 mac[ETH_ALEN];
 	int ret;
 	u32 srev;
 
-	/*If we passed the test malloc a hal struct*/
-	hal = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (hal == NULL) {
+	/*If we passed the test malloc a hw struct*/
+	hw = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
+	if (hw == NULL) {
 		ret = -ENOMEM;
 		AR5K_PRINT("out of memory\n");
 		goto err;
 	}
 
-	hal->ah_sc = sc;
-	hal->ah_sh = sh;
+	hw->ah_sc = sc;
+	hw->ah_sh = sh;
 
 	/*
-	 * HAL information
+	 * HW information
 	 */
 
 	/* Regulation Stuff */
-	hal->ah_country_code = AR5K_TUNE_CTRY;
-	ath5k_get_regdomain(hal);
-
-	hal->ah_op_mode = IEEE80211_IF_TYPE_STA;
-	hal->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
-	hal->ah_turbo = false;
-	hal->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
-	hal->ah_imr = 0;
-	hal->ah_atim_window = 0;
-	hal->ah_aifs = AR5K_TUNE_AIFS;
-	hal->ah_cw_min = AR5K_TUNE_CWMIN;
-	hal->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
-	hal->ah_software_retry = false;
-	hal->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
+	hw->ah_country_code = AR5K_TUNE_CTRY;
+	ath5k_get_regdomain(hw);
+
+	hw->ah_op_mode = IEEE80211_IF_TYPE_STA;
+	hw->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
+	hw->ah_turbo = false;
+	hw->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
+	hw->ah_imr = 0;
+	hw->ah_atim_window = 0;
+	hw->ah_aifs = AR5K_TUNE_AIFS;
+	hw->ah_cw_min = AR5K_TUNE_CWMIN;
+	hw->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
+	hw->ah_software_retry = false;
+	hw->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
 
 	switch (device) {
 	case PCI_DEVICE_ID_ATHEROS_AR2413:
@@ -237,94 +237,94 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		/*
 		 * Known single chip solutions
 		 */
-		hal->ah_single_chip = true;
+		hw->ah_single_chip = true;
 		break;
 	default:
 		/*
 		 * Multi chip solutions
 		 */
-		hal->ah_single_chip = false;
+		hw->ah_single_chip = false;
 		break;
 	}
 
 	/*
 	 * Set the mac revision based on the pci id
 	 */
-	hal->ah_version = mac_version;
-
-	/*Fill the hal struct with the needed functions*/
-	if (hal->ah_version == AR5K_AR5212)
-		hal->ah_magic = AR5K_EEPROM_MAGIC_5212;
-	else if (hal->ah_version == AR5K_AR5211)
-		hal->ah_magic = AR5K_EEPROM_MAGIC_5211;
-
-	if (hal->ah_version == AR5K_AR5212) {
-		hal->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
-		hal->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		hal->ah_fill_tx_desc = ath5k_hw_fill_4word_tx_desc;
-		hal->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
+	hw->ah_version = mac_version;
+
+	/*Fill the hw struct with the needed functions*/
+	if (hw->ah_version == AR5K_AR5212)
+		hw->ah_magic = AR5K_EEPROM_MAGIC_5212;
+	else if (hw->ah_version == AR5K_AR5211)
+		hw->ah_magic = AR5K_EEPROM_MAGIC_5211;
+
+	if (hw->ah_version == AR5K_AR5212) {
+		hw->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
+		hw->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
+		hw->ah_fill_tx_desc = ath5k_hw_fill_4word_tx_desc;
+		hw->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
 	} else {
-		hal->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
-		hal->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		hal->ah_fill_tx_desc = ath5k_hw_fill_2word_tx_desc;
-		hal->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
+		hw->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
+		hw->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
+		hw->ah_fill_tx_desc = ath5k_hw_fill_2word_tx_desc;
+		hw->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
 	}
 
-	if (hal->ah_version == AR5K_AR5212)
-		hal->ah_proc_rx_desc = ath5k_hw_proc_new_rx_status;
-	else if (hal->ah_version <= AR5K_AR5211)
-		hal->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
+	if (hw->ah_version == AR5K_AR5212)
+		hw->ah_proc_rx_desc = ath5k_hw_proc_new_rx_status;
+	else if (hw->ah_version <= AR5K_AR5211)
+		hw->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
 	/* Bring device out of sleep and reset it's units */
-	ret = ath5k_hw_nic_wakeup(hal, AR5K_INIT_MODE, true);
+	ret = ath5k_hw_nic_wakeup(hw, AR5K_INIT_MODE, true);
 	if (ret)
 		goto err_free;
 
 	/* Get MAC, PHY and RADIO revisions */
-	srev = ath5k_hw_reg_read(hal, AR5K_SREV);
-	hal->ah_mac_srev = srev;
-	hal->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
-	hal->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
-	hal->ah_phy_revision = ath5k_hw_reg_read(hal, AR5K_PHY_CHIP_ID) &
+	srev = ath5k_hw_reg_read(hw, AR5K_SREV);
+	hw->ah_mac_srev = srev;
+	hw->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
+	hw->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
+	hw->ah_phy_revision = ath5k_hw_reg_read(hw, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
-	hal->ah_radio_5ghz_revision = ath5k_hw_radio_revision(hal,
+	hw->ah_radio_5ghz_revision = ath5k_hw_radio_revision(hw,
 			CHANNEL_5GHZ);
 
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_radio_2ghz_revision = 0;
+	if (hw->ah_version == AR5K_AR5210)
+		hw->ah_radio_2ghz_revision = 0;
 	else
-		hal->ah_radio_2ghz_revision = ath5k_hw_radio_revision(hal,
+		hw->ah_radio_2ghz_revision = ath5k_hw_radio_revision(hw,
 				CHANNEL_2GHZ);
 
 	/* Single chip radio */
-	if (hal->ah_radio_2ghz_revision == hal->ah_radio_5ghz_revision)
-		hal->ah_radio_2ghz_revision = 0;
+	if (hw->ah_radio_2ghz_revision == hw->ah_radio_5ghz_revision)
+		hw->ah_radio_2ghz_revision = 0;
 
 	/* Identify the radio chip*/
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_radio = AR5K_RF5110;
+	if (hw->ah_version == AR5K_AR5210)
+		hw->ah_radio = AR5K_RF5110;
 	else
-		hal->ah_radio = hal->ah_radio_5ghz_revision <
+		hw->ah_radio = hw->ah_radio_5ghz_revision <
 			AR5K_SREV_RAD_5112 ? AR5K_RF5111 : AR5K_RF5112;
 
-	hal->ah_phy = AR5K_PHY(0);
+	hw->ah_phy = AR5K_PHY(0);
 
 #ifdef AR5K_DEBUG
-	ath5k_hw_dump_state(hal);
+	ath5k_hw_dump_state(hw);
 #endif
 
 	/*
 	 * Get card capabilities, values, ...
 	 */
 
-	ret = ath5k_eeprom_init(hal);
+	ret = ath5k_eeprom_init(hw);
 	if (ret) {
 		AR5K_PRINT("unable to init EEPROM\n");
 		goto err_free;
 	}
 
 	/* Get misc capabilities */
-	ret = ath5k_hw_get_capabilities(hal);
+	ret = ath5k_hw_get_capabilities(hw);
 	if (ret) {
 		AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
 			device);
@@ -332,24 +332,24 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	}
 
 	/* Get MAC address */
-	ret = ath5k_eeprom_read_mac(hal, mac);
+	ret = ath5k_eeprom_read_mac(hw, mac);
 	if (ret) {
 		AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
 			device);
 		goto err_free;
 	}
 
-	ath5k_hw_set_lladdr(hal, mac);
+	ath5k_hw_set_lladdr(hw, mac);
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memset(hal->bssid, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(hal, hal->bssid, 0);
-	ath5k_hw_set_opmode(hal);
+	memset(hw->bssid, 0xff, ETH_ALEN);
+	ath5k_hw_set_associd(hw, hw->bssid, 0);
+	ath5k_hw_set_opmode(hw);
 
-	ath5k_hw_set_rfgain_opt(hal);
+	ath5k_hw_set_rfgain_opt(hw);
 
-	return hal;
+	return hw;
 err_free:
-	kfree(hal);
+	kfree(hw);
 err:
 	return ERR_PTR(ret);
 }
@@ -357,7 +357,7 @@ err:
 /*
  * Bring up MAC + PHY Chips
  */
-static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
+static int ath5k_hw_nic_wakeup(struct ath_hw *hw, int flags, bool initial)
 {
 	u32 turbo, mode, clock;
 	int ret;
@@ -368,12 +368,12 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 
 	AR5K_TRACE;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		/*
 		 * Get channel mode flags
 		 */
 
-		if (hal->ah_radio >= AR5K_RF5112) {
+		if (hw->ah_radio >= AR5K_RF5112) {
 			mode = AR5K_PHY_MODE_RAD_RF5112;
 			clock = AR5K_PHY_PLL_RF5112;
 		} else {
@@ -394,7 +394,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 				 * this, 5211 might support ofdm-only g after
 				 * all, there are also initial register values
 				 * in the code for g mode (see ath5k_hw.h). */
-				if (hal->ah_version == AR5K_AR5211)
+				if (hw->ah_version == AR5K_AR5211)
 					mode |= AR5K_PHY_MODE_MOD_OFDM;
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
@@ -422,7 +422,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 	} else { /* Reset and wakeup the device */
 		if (initial == true) {
 			/* ...reset hardware */
-			if (ath5k_hw_nic_reset(hal, AR5K_RESET_CTL_PCI)) {
+			if (ath5k_hw_nic_reset(hw, AR5K_RESET_CTL_PCI)) {
 				AR5K_PRINT("failed to reset the PCI chipset\n");
 				return -EIO;
 			}
@@ -431,7 +431,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 		}
 
 		/* ...wakeup */
-		ret = ath5k_hw_set_power(hal, AR5K_PM_AWAKE, true, 0);
+		ret = ath5k_hw_set_power(hw, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
 			AR5K_PRINT("failed to resume the MAC Chip\n");
 			return ret;
@@ -439,11 +439,11 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 
 		/* ...enable Atheros turbo mode if requested */
 		if (flags & CHANNEL_TURBO)
-			ath5k_hw_reg_write(hal, AR5K_PHY_TURBO_MODE,
+			ath5k_hw_reg_write(hw, AR5K_PHY_TURBO_MODE,
 					AR5K_PHY_TURBO);
 
 		/* ...reset chipset */
-		if (ath5k_hw_nic_reset(hal, AR5K_RESET_CTL_CHIP)) {
+		if (ath5k_hw_nic_reset(hw, AR5K_RESET_CTL_CHIP)) {
 			AR5K_PRINT("failed to reset the AR5210 chipset\n");
 			return -EIO;
 		}
@@ -452,35 +452,35 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 	}
 
 	/* ...reset chipset and PCI device */
-	if (hal->ah_single_chip == false && ath5k_hw_nic_reset(hal,
+	if (hw->ah_single_chip == false && ath5k_hw_nic_reset(hw,
 				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
 		AR5K_PRINT("failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}
 
-	if (hal->ah_version == AR5K_AR5210)
+	if (hw->ah_version == AR5K_AR5210)
 		udelay(2300);
 
 	/* ...wakeup */
-	ret = ath5k_hw_set_power(hal, AR5K_PM_AWAKE, true, 0);
+	ret = ath5k_hw_set_power(hw, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		AR5K_PRINT("failed to resume the MAC Chip\n");
 		return ret;
 	}
 
 	/* ...final warm reset */
-	if (ath5k_hw_nic_reset(hal, 0)) {
+	if (ath5k_hw_nic_reset(hw, 0)) {
 		AR5K_PRINT("failed to warm reset the MAC Chip\n");
 		return -EIO;
 	}
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		/* ...set the PHY operating mode */
-		ath5k_hw_reg_write(hal, clock, AR5K_PHY_PLL);
+		ath5k_hw_reg_write(hw, clock, AR5K_PHY_PLL);
 		udelay(300);
 
-		ath5k_hw_reg_write(hal, mode, AR5K_PHY_MODE);
-		ath5k_hw_reg_write(hal, turbo, AR5K_PHY_TURBO);
+		ath5k_hw_reg_write(hw, mode, AR5K_PHY_MODE);
+		ath5k_hw_reg_write(hw, turbo, AR5K_PHY_TURBO);
 	}
 
 	return 0;
@@ -489,12 +489,12 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 /*
  * Get the rate table for a specific operation mode
  */
-const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
+const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hw,
 		unsigned int mode)
 {
 	AR5K_TRACE;
 
-	if (!test_bit(mode, hal->ah_capabilities.cap_mode))
+	if (!test_bit(mode, hw->ah_capabilities.cap_mode))
 		return NULL;
 
 	/* Get rate tables */
@@ -515,17 +515,17 @@ const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
 }
 
 /*
- * Free the hal struct
+ * Free the hw struct
  */
-void ath5k_hw_detach(struct ath_hw *hal)
+void ath5k_hw_detach(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_rf_banks != NULL)
-		kfree(hal->ah_rf_banks);
+	if (hw->ah_rf_banks != NULL)
+		kfree(hw->ah_rf_banks);
 
 	/* assume interrupts are down */
-	kfree(hal);
+	kfree(hw);
 }
 
 /*******************************\
@@ -535,11 +535,11 @@ void ath5k_hw_detach(struct ath_hw *hal)
 /*
  * Main reset function
  */
-int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
+int ath5k_hw_reset(struct ath_hw *hw, enum ieee80211_if_types op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	const struct ath5k_rate_table *rt;
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	u32 data, noise_floor, s_seq, s_ant, s_led[3];
 	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
@@ -556,43 +556,43 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	 * Save some registers before a reset
 	 */
 	/*DCU/Antenna selection not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		if (change_channel == true) {
 			/* Seq number for queue 0 -do this for all queues ? */
-			s_seq = ath5k_hw_reg_read(hal,
+			s_seq = ath5k_hw_reg_read(hw,
 					AR5K_QUEUE_DFS_SEQNUM(0));
 			/*Default antenna*/
-			s_ant = ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
+			s_ant = ath5k_hw_reg_read(hw, AR5K_DEFAULT_ANTENNA);
 		}
 	}
 
 	/*GPIOs*/
-	s_led[0] = ath5k_hw_reg_read(hal, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
-	s_led[1] = ath5k_hw_reg_read(hal, AR5K_GPIOCR);
-	s_led[2] = ath5k_hw_reg_read(hal, AR5K_GPIODO);
+	s_led[0] = ath5k_hw_reg_read(hw, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
+	s_led[1] = ath5k_hw_reg_read(hw, AR5K_GPIOCR);
+	s_led[2] = ath5k_hw_reg_read(hw, AR5K_GPIODO);
 
-	if (change_channel == true && hal->ah_rf_banks != NULL)
-		ath5k_hw_get_rf_gain(hal);
+	if (change_channel == true && hw->ah_rf_banks != NULL)
+		ath5k_hw_get_rf_gain(hw);
 
 
 	/*Wakeup the device*/
-	ret = ath5k_hw_nic_wakeup(hal, channel->val, false);
+	ret = ath5k_hw_nic_wakeup(hw, channel->val, false);
 	if (ret)
 		return ret;
 
 	/*
 	 * Initialize operating mode
 	 */
-	hal->ah_op_mode = op_mode;
+	hw->ah_op_mode = op_mode;
 
 	/*
 	 * 5111/5112 Settings
 	 * 5210 only comes with RF5110
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		if (hal->ah_radio != AR5K_RF5111 &&
-				hal->ah_radio != AR5K_RF5112) {
-			AR5K_PRINTF("invalid phy radio: %u\n", hal->ah_radio);
+	if (hw->ah_version != AR5K_AR5210) {
+		if (hw->ah_radio != AR5K_RF5111 &&
+				hw->ah_radio != AR5K_RF5112) {
+			AR5K_PRINTF("invalid phy radio: %u\n", hw->ah_radio);
 			return -EINVAL;
 		}
 
@@ -625,7 +625,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 			break;
 		case CHANNEL_XR:
-			if (hal->ah_version == AR5K_AR5211) {
+			if (hw->ah_version == AR5K_AR5211) {
 				AR5K_PRINTF("XR mode not available on 5211");
 				return -EINVAL;
 			}
@@ -639,21 +639,21 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		}
 
 		/* PHY access enable */
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(hw, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 
 	}
 
-	ath5k_hw_write_initvals(hal, mode, change_channel);
+	ath5k_hw_write_initvals(hw, mode, change_channel);
 
 	/*
 	 * 5211/5212 Specific
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		/*
 		 * Write initial RF gain settings
 		 * This should work for both 5111/5112
 		 */
-		ret = ath5k_hw_rfgain(hal, freq);
+		ret = ath5k_hw_rfgain(hw, freq);
 		if (ret)
 			return ret;
 
@@ -662,25 +662,25 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		/*
 		 * Set rate duration table on 5212
 		 */
-		if (hal->ah_version == AR5K_AR5212) {
+		if (hw->ah_version == AR5K_AR5212) {
 
 			/*For 802.11b*/
 			if (!(channel->val & CHANNEL_B)) {
 
 				/*Get rate table for this operation mode*/
-				rt = ath5k_hw_get_rate_table(hal,
+				rt = ath5k_hw_get_rate_table(hw,
 						MODE_IEEE80211B);
 
 				/*Write rate duration table*/
 				for (i = 0; i < rt->rate_count; i++) {
 					data = AR5K_RATE_DUR(rt->rates[i].rate_code);
-					ath5k_hw_reg_write(hal,
-						ath_hal_computetxtime(hal, rt,
+					ath5k_hw_reg_write(hw,
+						ath_hw_computetxtime(hw, rt,
 						14, rt->rates[i].control_rate,
 						false), data);
 					if (HAS_SHPREAMBLE(i))
-						ath5k_hw_reg_write(hal,
-						    ath_hal_computetxtime(hal,
+						ath5k_hw_reg_write(hw,
+						    ath_hw_computetxtime(hw,
 						    rt, 14,
 						    rt->rates[i].control_rate,
 						    false), data +
@@ -692,14 +692,14 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 			 * O.K. for both a/g - OFDM) */
 
 				/* Get rate table for this operation mode */
-				rt = ath5k_hw_get_rate_table(hal,
+				rt = ath5k_hw_get_rate_table(hw,
 				    channel->val & CHANNEL_TURBO ?
 				    MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
 
 				/* Write rate duration table */
 				for (i = 0; i < rt->rate_count; i++)
-					ath5k_hw_reg_write(hal,
-						ath_hal_computetxtime(hal, rt,
+					ath5k_hw_reg_write(hw,
+						ath_hw_computetxtime(hw, rt,
 						14, rt->rates[i].control_rate,
 						false),
 						AR5K_RATE_DUR(rt->rates[i].rate_code));
@@ -708,22 +708,22 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		}
 
 		/* Fix for first revision of the RF5112 RF chipset */
-		if (hal->ah_radio >= AR5K_RF5112 &&
-				hal->ah_radio_5ghz_revision <
+		if (hw->ah_radio >= AR5K_RF5112 &&
+				hw->ah_radio_5ghz_revision <
 				AR5K_SREV_RAD_5112A) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_CCKTXCTL_WORLD,
+			ath5k_hw_reg_write(hw, AR5K_PHY_CCKTXCTL_WORLD,
 					AR5K_PHY_CCKTXCTL);
 			if (channel->val & CHANNEL_A)
 				data = 0xffb81020;
 			else
 				data = 0xffb80d20;
-			ath5k_hw_reg_write(hal, data, AR5K_PHY_FRAME_CTL);
+			ath5k_hw_reg_write(hw, data, AR5K_PHY_FRAME_CTL);
 		}
 
 		/*
 		 * Set TX power (XXX use txpower from net80211)
 		 */
-		ret = ath5k_hw_txpower(hal, channel, AR5K_TUNE_DEFAULT_TXPOWER);
+		ret = ath5k_hw_txpower(hw, channel, AR5K_TUNE_DEFAULT_TXPOWER);
 		if (ret)
 			return ret;
 
@@ -731,7 +731,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		 * Write RF registers
 		 * TODO:Does this work on 5211 (5111) ?
 		 */
-		ret = ath5k_hw_rfregs(hal, channel, mode);
+		ret = ath5k_hw_rfregs(hw, channel, mode);
 		if (ret)
 			return ret;
 
@@ -740,7 +740,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		 */
 
 		/* Write OFDM timings on 5212*/
-		if (hal->ah_version == AR5K_AR5212) {
+		if (hw->ah_version == AR5K_AR5212) {
 			if (channel->val & CHANNEL_OFDM) {
 				u32 coef_scaled, coef_exp, coef_man,
 					ds_coef_exp, ds_coef_man, clock;
@@ -762,84 +762,84 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 				ds_coef_man = coef_man >> (24 - coef_exp);
 				ds_coef_exp = coef_exp - 16;
 
-				AR5K_REG_WRITE_BITS(hal, AR5K_PHY_TIMING_3,
+				AR5K_REG_WRITE_BITS(hw, AR5K_PHY_TIMING_3,
 				    AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
-				AR5K_REG_WRITE_BITS(hal, AR5K_PHY_TIMING_3,
+				AR5K_REG_WRITE_BITS(hw, AR5K_PHY_TIMING_3,
 				    AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
 			}
 		}
 
 		/*Enable/disable 802.11b mode on 5111
 		(enable 2111 frequency converter + CCK)*/
-		if (hal->ah_radio == AR5K_RF5111) {
+		if (hw->ah_radio == AR5K_RF5111) {
 			if (channel->val & CHANNEL_B)
-				AR5K_REG_ENABLE_BITS(hal, AR5K_TXCFG,
+				AR5K_REG_ENABLE_BITS(hw, AR5K_TXCFG,
 				    AR5K_TXCFG_B_MODE);
 			else
-				AR5K_REG_DISABLE_BITS(hal, AR5K_TXCFG,
+				AR5K_REG_DISABLE_BITS(hw, AR5K_TXCFG,
 				    AR5K_TXCFG_B_MODE);
 		}
 
 		/* Set antenna mode */
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x44),
-			hal->ah_antenna[ee_mode][0], 0xfffffc06);
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x44),
+			hw->ah_antenna[ee_mode][0], 0xfffffc06);
 
 		if (freq == AR5K_INI_RFGAIN_2GHZ)
 			ant[0] = ant[1] = AR5K_ANT_FIXED_B;
 		else
 			ant[0] = ant[1] = AR5K_ANT_FIXED_A;
 
-		ath5k_hw_reg_write(hal, hal->ah_antenna[ee_mode][ant[0]],
+		ath5k_hw_reg_write(hw, hw->ah_antenna[ee_mode][ant[0]],
 			AR5K_PHY_ANT_SWITCH_TABLE_0);
-		ath5k_hw_reg_write(hal, hal->ah_antenna[ee_mode][ant[1]],
+		ath5k_hw_reg_write(hw, hw->ah_antenna[ee_mode][ant[1]],
 			AR5K_PHY_ANT_SWITCH_TABLE_1);
 
 		/* Commit values from EEPROM */
-		if (hal->ah_radio == AR5K_RF5111)
-			AR5K_REG_WRITE_BITS(hal, AR5K_PHY_FRAME_CTL,
+		if (hw->ah_radio == AR5K_RF5111)
+			AR5K_REG_WRITE_BITS(hw, AR5K_PHY_FRAME_CTL,
 			    AR5K_PHY_FRAME_CTL_TX_CLIP, ee->ee_tx_clip);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
 			AR5K_PHY(0x5a));
 
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x11),
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x11),
 			(ee->ee_switch_settling[ee_mode] << 7) & 0x3f80,
 			0xffffc07f);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x12),
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x12),
 			(ee->ee_ant_tx_rx[ee_mode] << 12) & 0x3f000,
 			0xfffc0fff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x14),
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x14),
 			(ee->ee_adc_desired_size[ee_mode] & 0x00ff) |
 			((ee->ee_pga_desired_size[ee_mode] << 8) & 0xff00),
 			0xffff0000);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			(ee->ee_tx_end2xpa_disable[ee_mode] << 24) |
 			(ee->ee_tx_end2xpa_disable[ee_mode] << 16) |
 			(ee->ee_tx_frm2xpa_enable[ee_mode] << 8) |
 			(ee->ee_tx_frm2xpa_enable[ee_mode]), AR5K_PHY(0x0d));
 
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x0a),
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x0a),
 			ee->ee_tx_end2xlna_enable[ee_mode] << 8, 0xffff00ff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x19),
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x19),
 			(ee->ee_thr_62[ee_mode] << 12) & 0x7f000, 0xfff80fff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x49), 4, 0xffffff01);
+		AR5K_REG_MASKED_BITS(hw, AR5K_PHY(0x49), 4, 0xffffff01);
 
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ,
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_IQ,
 		    AR5K_PHY_IQ_CORR_ENABLE |
 		    (ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
 		    ee->ee_q_cal[ee_mode]);
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			AR5K_REG_WRITE_BITS(hal, AR5K_PHY_GAIN_2GHZ,
+		if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			AR5K_REG_WRITE_BITS(hw, AR5K_PHY_GAIN_2GHZ,
 				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
 				ee->ee_margin_tx_rx[ee_mode]);
 
 	} else {
 		mdelay(1);
 		/* Disable phy and wait */
-		ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+		ath5k_hw_reg_write(hw, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 		mdelay(1);
 	}
 
@@ -847,61 +847,61 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	 * Restore saved values
 	 */
 	/*DCU/Antenna selection not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
-		ath5k_hw_reg_write(hal, s_ant, AR5K_DEFAULT_ANTENNA);
+	if (hw->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(hw, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
+		ath5k_hw_reg_write(hw, s_ant, AR5K_DEFAULT_ANTENNA);
 	}
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, s_led[0]);
-	ath5k_hw_reg_write(hal, s_led[1], AR5K_GPIOCR);
-	ath5k_hw_reg_write(hal, s_led[2], AR5K_GPIODO);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PCICFG, s_led[0]);
+	ath5k_hw_reg_write(hw, s_led[1], AR5K_GPIOCR);
+	ath5k_hw_reg_write(hw, s_led[2], AR5K_GPIODO);
 
 	/*
 	 * Misc
 	 */
-	/* XXX: add hal->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(hal, hal->bssid, 0);
+	/* XXX: add hw->aid once mac80211 gives this to us */
+	ath5k_hw_set_associd(hw, hw->bssid, 0);
 
-	ath5k_hw_set_opmode(hal);
+	ath5k_hw_set_opmode(hw);
 	/*PISR/SISR Not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, 0xffffffff, AR5K_PISR);
+	if (hw->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(hw, 0xffffffff, AR5K_PISR);
 		/* XXX: AR5K_RSSI_THR has masks and shifts defined for it, so
 		 * direct write using ath5k_hw_reg_write seems wrong. Test with:
-		 * AR5K_REG_WRITE_BITS(hal, AR5K_RSSI_THR,
+		 * AR5K_REG_WRITE_BITS(hw, AR5K_RSSI_THR,
 		 *   AR5K_RSSI_THR_BMISS, AR5K_TUNE_RSSI_THRES);
 		 * with different variables and check results compared
-		 * to ath5k_hw_reg_write(hal, )  */
-		ath5k_hw_reg_write(hal, AR5K_TUNE_RSSI_THRES, AR5K_RSSI_THR);
+		 * to ath5k_hw_reg_write(hw, )  */
+		ath5k_hw_reg_write(hw, AR5K_TUNE_RSSI_THRES, AR5K_RSSI_THR);
 	}
 
 	/*
 	 * Set Rx/Tx DMA Configuration
 	 *(passing dma size not available on 5210)
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
+	if (hw->ah_version != AR5K_AR5210) {
+		AR5K_REG_WRITE_BITS(hw, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
 				AR5K_DMASIZE_512B | AR5K_TXCFG_DMASIZE);
-		AR5K_REG_WRITE_BITS(hal, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
+		AR5K_REG_WRITE_BITS(hw, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
 				AR5K_DMASIZE_512B);
 	}
 
 	/*
 	 * Set channel and calibrate the PHY
 	 */
-	ret = ath5k_hw_channel(hal, channel);
+	ret = ath5k_hw_channel(hw, channel);
 	if (ret)
 		return ret;
 
 	/*
 	 * Enable the PHY and wait until completion
 	 */
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(hw, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
 
 	/*
 	 * 5111/5112 Specific
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		data = ath5k_hw_reg_read(hal, AR5K_PHY_RX_DELAY) &
+	if (hw->ah_version != AR5K_AR5210) {
+		data = ath5k_hw_reg_read(hw, AR5K_PHY_RX_DELAY) &
 			AR5K_PHY_RX_DELAY_M;
 		data = (channel->val & CHANNEL_CCK) ?
 			((data << 2) / 22) : (data / 10);
@@ -914,10 +914,10 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Enable calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL,
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGCCTL,
 				AR5K_PHY_AGCCTL_CAL);
 
-	if (ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	if (ath5k_hw_register_timeout(hw, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
 		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
 		return -EAGAIN;
@@ -926,10 +926,10 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Enable noise floor calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL,
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGCCTL,
 				AR5K_PHY_AGCCTL_NF);
 
-	if (ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	if (ath5k_hw_register_timeout(hw, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false)) {
 		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
 				channel->freq);
@@ -939,7 +939,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/* Wait until the noise floor is calibrated and read the value */
 	for (i = 20; i > 0; i--) {
 		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
+		noise_floor = ath5k_hw_reg_read(hw, AR5K_PHY_NF);
 
 		if (AR5K_PHY_NF_RVAL(noise_floor) &
 		AR5K_PHY_NF_ACTIVE)
@@ -955,25 +955,25 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		return -EIO;
 	}
 
-	hal->ah_calibration = false;
+	hw->ah_calibration = false;
 
 	if (!(channel->val & CHANNEL_B)) {
-		hal->ah_calibration = true;
-		AR5K_REG_WRITE_BITS(hal, AR5K_PHY_IQ,
+		hw->ah_calibration = true;
+		AR5K_REG_WRITE_BITS(hw, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ,
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_RUN);
 	}
 
 	/*
 	 * Reset queues and start beacon timers at the end of the reset routine
 	 */
-	for (i = 0; i < hal->ah_capabilities.cap_queues.q_tx_num; i++) {
+	for (i = 0; i < hw->ah_capabilities.cap_queues.q_tx_num; i++) {
 		/*No QCU on 5210*/
-		if (hal->ah_version != AR5K_AR5210)
-			AR5K_REG_WRITE_Q(hal, AR5K_QUEUE_QCUMASK(i), i);
+		if (hw->ah_version != AR5K_AR5210)
+			AR5K_REG_WRITE_Q(hw, AR5K_QUEUE_QCUMASK(i), i);
 
-		ret = ath5k_hw_reset_tx_queue(hal, i);
+		ret = ath5k_hw_reset_tx_queue(hw, i);
 		if (ret) {
 			AR5K_PRINTF("failed to reset TX queue #%d\n", i);
 			return ret;
@@ -981,8 +981,8 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	}
 
 	/* Pre-enable interrupts on 5211/5212*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_set_intr(hal, AR5K_INT_RX | AR5K_INT_TX |
+	if (hw->ah_version != AR5K_AR5210)
+		ath5k_hw_set_intr(hw, AR5K_INT_RX | AR5K_INT_TX |
 				AR5K_INT_FATAL);
 
 	/*
@@ -991,26 +991,26 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	 * TODO: Handle this in ath_intr
 	 */
 #if 0
-	if (AR5K_EEPROM_HDR_RFKILL(hal->ah_capabilities.cap_eeprom.ee_header)) {
-		ath5k_hw_set_gpio_input(hal, 0);
-		hal->ah_gpio[0] = ath5k_hw_get_gpio(hal, 0);
-		if (hal->ah_gpio[0] == 0)
-			ath5k_hw_set_gpio_intr(hal, 0, 1);
+	if (AR5K_EEPROM_HDR_RFKILL(hw->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_hw_set_gpio_input(hw, 0);
+		hw->ah_gpio[0] = ath5k_hw_get_gpio(hw, 0);
+		if (hw->ah_gpio[0] == 0)
+			ath5k_hw_set_gpio_intr(hw, 0, 1);
 		else
-			ath5k_hw_set_gpio_intr(hal, 0, 0);
+			ath5k_hw_set_gpio_intr(hw, 0, 0);
 	}
 #endif
 
 	/*
 	 * Set the 32MHz reference clock on 5212 phy clock sleep register
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(hal, hal->ah_radio == AR5K_RF5111 ?
+	if (hw->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(hw, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
+		ath5k_hw_reg_write(hw, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
+		ath5k_hw_reg_write(hw, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
+		ath5k_hw_reg_write(hw, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
+		ath5k_hw_reg_write(hw, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
+		ath5k_hw_reg_write(hw, hw->ah_radio == AR5K_RF5111 ?
 			AR5K_PHY_SPENDING_RF5111 : AR5K_PHY_SPENDING_RF5112,
 			AR5K_PHY_SPENDING);
 	}
@@ -1018,7 +1018,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Disable beacons and reset the register
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_BEACON, AR5K_BEACON_ENABLE |
+	AR5K_REG_DISABLE_BITS(hw, AR5K_BEACON, AR5K_BEACON_ENABLE |
 			AR5K_BEACON_RESET_TSF);
 
 	return 0;
@@ -1027,7 +1027,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 /*
  * Reset chipset
  */
-static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
+static int ath5k_hw_nic_reset(struct ath_hw *hw, u32 val)
 {
 	int ret;
 	u32 mask = val ? val : ~0;
@@ -1035,17 +1035,17 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 	AR5K_TRACE;
 
 	/* Read-and-clear RX Descriptor Pointer*/
-	ath5k_hw_reg_read(hal, AR5K_RXDP);
+	ath5k_hw_reg_read(hw, AR5K_RXDP);
 
 	/*
 	 * Reset the device and wait until success
 	 */
-	ath5k_hw_reg_write(hal, val, AR5K_RESET_CTL);
+	ath5k_hw_reg_write(hw, val, AR5K_RESET_CTL);
 
 	/* Wait at least 128 PCI clocks */
 	udelay(15);
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		val &= AR5K_RESET_CTL_CHIP;
 		mask &= AR5K_RESET_CTL_CHIP;
 	} else {
@@ -1053,7 +1053,7 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
 	}
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_RESET_CTL, mask, val, false);
+	ret = ath5k_hw_register_timeout(hw, AR5K_RESET_CTL, mask, val, false);
 
 	/*
 	 * Reset configuration register (for hw byte-swap). Note that this
@@ -1061,7 +1061,7 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 	 * AR5K_INIT_CFG.
 	 */
 	if ((val & AR5K_RESET_CTL_PCU) == 0)
-		ath5k_hw_reg_write(hal, AR5K_INIT_CFG, AR5K_CFG);
+		ath5k_hw_reg_write(hw, AR5K_INIT_CFG, AR5K_CFG);
 
 	return ret;
 }
@@ -1073,14 +1073,14 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 /*
  * Sleep control
  */
-int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
+int ath5k_hw_set_power(struct ath_hw *hw, enum ath5k_power_mode mode,
 		bool set_chip, u16 sleep_duration)
 {
 	unsigned int i;
 	u32 staid;
 
 	AR5K_TRACE;
-	staid = ath5k_hw_reg_read(hal, AR5K_STA_ID1);
+	staid = ath5k_hw_reg_read(hw, AR5K_STA_ID1);
 
 	switch (mode) {
 	case AR5K_PM_AUTO:
@@ -1088,7 +1088,7 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 		/* fallthrough */
 	case AR5K_PM_NETWORK_SLEEP:
 		if (set_chip == true)
-			ath5k_hw_reg_write(hal,
+			ath5k_hw_reg_write(hw,
 				AR5K_SLEEP_CTL_SLE | sleep_duration,
 				AR5K_SLEEP_CTL);
 
@@ -1097,7 +1097,7 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 
 	case AR5K_PM_FULL_SLEEP:
 		if (set_chip == true)
-			ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_SLP,
+			ath5k_hw_reg_write(hw, AR5K_SLEEP_CTL_SLE_SLP,
 				AR5K_SLEEP_CTL);
 
 		staid |= AR5K_STA_ID1_PWR_SV;
@@ -1107,18 +1107,18 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 		if (set_chip == false)
 			goto commit;
 
-		ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_WAKE,
+		ath5k_hw_reg_write(hw, AR5K_SLEEP_CTL_SLE_WAKE,
 				AR5K_SLEEP_CTL);
 
 		for (i = 5000; i > 0; i--) {
 			/* Check if the chip did wake up */
-			if ((ath5k_hw_reg_read(hal, AR5K_PCICFG) &
+			if ((ath5k_hw_reg_read(hw, AR5K_PCICFG) &
 					AR5K_PCICFG_SPWR_DN) == 0)
 				break;
 
 			/* Wait a bit and retry */
 			udelay(200);
-			ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_WAKE,
+			ath5k_hw_reg_write(hw, AR5K_SLEEP_CTL_SLE_WAKE,
 				AR5K_SLEEP_CTL);
 		}
 
@@ -1134,8 +1134,8 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 	}
 
 commit:
-	hal->ah_power_mode = mode;
-	ath5k_hw_reg_write(hal, staid, AR5K_STA_ID1);
+	hw->ah_power_mode = mode;
+	ath5k_hw_reg_write(hw, staid, AR5K_STA_ID1);
 
 	return 0;
 }
@@ -1151,27 +1151,27 @@ commit:
 /*
  * Start DMA receive
  */
-void ath5k_hw_start_rx(struct ath_hw *hal)
+void ath5k_hw_start_rx(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	ath5k_hw_reg_write(hal, AR5K_CR_RXE, AR5K_CR);
+	ath5k_hw_reg_write(hw, AR5K_CR_RXE, AR5K_CR);
 }
 
 /*
  * Stop DMA receive
  */
-int ath5k_hw_stop_rx_dma(struct ath_hw *hal)
+int ath5k_hw_stop_rx_dma(struct ath_hw *hw)
 {
 	unsigned int i;
 
 	AR5K_TRACE;
-	ath5k_hw_reg_write(hal, AR5K_CR_RXD, AR5K_CR);
+	ath5k_hw_reg_write(hw, AR5K_CR_RXD, AR5K_CR);
 
 	/*
 	 * It may take some time to disable the DMA receive unit
 	 */
 	for (i = 2000; i > 0 &&
-			(ath5k_hw_reg_read(hal, AR5K_CR) & AR5K_CR_RXE) != 0;
+			(ath5k_hw_reg_read(hw, AR5K_CR) & AR5K_CR_RXE) != 0;
 			i--)
 		udelay(10);
 
@@ -1181,20 +1181,20 @@ int ath5k_hw_stop_rx_dma(struct ath_hw *hal)
 /*
  * Get the address of the RX Descriptor
  */
-u32 ath5k_hw_get_rx_buf(struct ath_hw *hal)
+u32 ath5k_hw_get_rx_buf(struct ath_hw *hw)
 {
-	return ath5k_hw_reg_read(hal, AR5K_RXDP);
+	return ath5k_hw_reg_read(hw, AR5K_RXDP);
 }
 
 /*
  * Set the address of the RX Descriptor
  */
-void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr)
+void ath5k_hw_put_rx_buf(struct ath_hw *hw, u32 phys_addr)
 {
 	AR5K_TRACE;
 
 	/*TODO:Shouldn't we check if RX is enabled first ?*/
-	ath5k_hw_reg_write(hal, phys_addr, AR5K_RXDP);
+	ath5k_hw_reg_write(hw, phys_addr, AR5K_RXDP);
 }
 
 /*
@@ -1205,49 +1205,49 @@ void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr)
  * Start DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_tx_start(struct ath_hw *hw, unsigned int queue)
 {
 	u32 tx_queue;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (hw->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
+	if (hw->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(hw, AR5K_CR);
 
 		/*
 		 * Set the queue by type on 5210
 		 */
-		switch (hal->ah_txq[queue].tqi_type) {
+		switch (hw->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_queue |= AR5K_CR_TXE0 & ~AR5K_CR_TXD0;
 			break;
 		case AR5K_TX_QUEUE_BEACON:
 			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+			ath5k_hw_reg_write(hw, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BSR);
 			break;
 		case AR5K_TX_QUEUE_CAB:
 			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
+			ath5k_hw_reg_write(hw, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
 				AR5K_BCR_BDMAE, AR5K_BSR);
 			break;
 		default:
 			return -EINVAL;
 		}
 		/* Start queue */
-		ath5k_hw_reg_write(hal, tx_queue, AR5K_CR);
+		ath5k_hw_reg_write(hw, tx_queue, AR5K_CR);
 	} else {
 		/* Return if queue is disabled */
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXD, queue))
+		if (AR5K_REG_READ_Q(hw, AR5K_QCU_TXD, queue))
 			return -EIO;
 
 		/* Start queue */
-		AR5K_REG_WRITE_Q(hal, AR5K_QCU_TXE, queue);
+		AR5K_REG_WRITE_Q(hw, AR5K_QCU_TXE, queue);
 	}
 
 	return 0;
@@ -1257,25 +1257,25 @@ int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
  * Stop DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_stop_tx_dma(struct ath_hw *hw, unsigned int queue)
 {
 	unsigned int i = 100;
 	u32 tx_queue, pending;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (hw->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
+	if (hw->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(hw, AR5K_CR);
 
 		/*
 		 * Set by queue type
 		 */
-		switch (hal->ah_txq[queue].tqi_type) {
+		switch (hw->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_queue |= AR5K_CR_TXD0 & ~AR5K_CR_TXE0;
 			break;
@@ -1283,30 +1283,30 @@ int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 		case AR5K_TX_QUEUE_CAB:
 			/* XXX Fix me... */
 			tx_queue |= AR5K_CR_TXD1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, 0, AR5K_BSR);
+			ath5k_hw_reg_write(hw, 0, AR5K_BSR);
 			break;
 		default:
 			return -EINVAL;
 		}
 
 		/* Stop queue */
-		ath5k_hw_reg_write(hal, tx_queue, AR5K_CR);
+		ath5k_hw_reg_write(hw, tx_queue, AR5K_CR);
 	} else {
 		/*
 		 * Schedule TX disable and wait until queue is empty
 		 */
-		AR5K_REG_WRITE_Q(hal, AR5K_QCU_TXD, queue);
+		AR5K_REG_WRITE_Q(hw, AR5K_QCU_TXD, queue);
 
 		/*Check for pending frames*/
 		do {
-			pending = ath5k_hw_reg_read(hal,
+			pending = ath5k_hw_reg_read(hw,
 				AR5K_QUEUE_STATUS(queue)) &
 				AR5K_QCU_STS_FRMPENDCNT;
 			udelay(100);
 		} while (--i && pending);
 
 		/* Clear register */
-		ath5k_hw_reg_write(hal, 0, AR5K_QCU_TXD);
+		ath5k_hw_reg_write(hw, 0, AR5K_QCU_TXD);
 	}
 
 	/* TODO: Check for success else return error */
@@ -1317,19 +1317,19 @@ int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
  * Get the address of the TX Descriptor for a specific queue
  * (see also QCU/DCU functions)
  */
-u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue)
+u32 ath5k_hw_get_tx_buf(struct ath_hw *hw, unsigned int queue)
 {
 	u16 tx_reg;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
 	 * Get the transmit queue descriptor pointer from the selected queue
 	 */
 	/*5210 doesn't have QCU*/
-	if (hal->ah_version == AR5K_AR5210) {
-		switch (hal->ah_txq[queue].tqi_type) {
+	if (hw->ah_version == AR5K_AR5210) {
+		switch (hw->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_reg = AR5K_NOQCU_TXDP0;
 			break;
@@ -1344,26 +1344,26 @@ u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue)
 		tx_reg = AR5K_QUEUE_TXDP(queue);
 	}
 
-	return ath5k_hw_reg_read(hal, tx_reg);
+	return ath5k_hw_reg_read(hw, tx_reg);
 }
 
 /*
  * Set the address of the TX Descriptor for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
+int ath5k_hw_put_tx_buf(struct ath_hw *hw, unsigned int queue, u32 phys_addr)
 {
 	u16 tx_reg;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
 	 * Set the transmit queue descriptor pointer register by type
 	 * on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		switch (hal->ah_txq[queue].tqi_type) {
+	if (hw->ah_version == AR5K_AR5210) {
+		switch (hw->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_reg = AR5K_NOQCU_TXDP0;
 			break;
@@ -1380,14 +1380,14 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 		 * the selected queue on QCU for 5211+
 		 * (this won't work if the queue is still active)
 		 */
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, queue))
+		if (AR5K_REG_READ_Q(hw, AR5K_QCU_TXE, queue))
 			return -EIO;
 
 		tx_reg = AR5K_QUEUE_TXDP(queue);
 	}
 
 	/* Set descriptor pointer */
-	ath5k_hw_reg_write(hal, phys_addr, tx_reg);
+	ath5k_hw_reg_write(hw, phys_addr, tx_reg);
 
 	return 0;
 }
@@ -1395,7 +1395,7 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 /*
  * Update tx trigger level
  */
-int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
+int ath5k_hw_update_tx_triglevel(struct ath_hw *hw, bool increase)
 {
 	u32 trigger_level, imr;
 	int ret = -EIO;
@@ -1405,10 +1405,10 @@ int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 	/*
 	 * Disable interrupts by setting the mask
 	 */
-	imr = ath5k_hw_set_intr(hal, hal->ah_imr & ~AR5K_INT_GLOBAL);
+	imr = ath5k_hw_set_intr(hw, hw->ah_imr & ~AR5K_INT_GLOBAL);
 
 	/*TODO: Boundary check on trigger_level*/
-	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(hal, AR5K_TXCFG),
+	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(hw, AR5K_TXCFG),
 			AR5K_TXCFG_TXFULL);
 
 	if (increase == false) {
@@ -1421,10 +1421,10 @@ int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 	/*
 	 * Update trigger level on success
 	 */
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, trigger_level, AR5K_TRIG_LVL);
+	if (hw->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(hw, trigger_level, AR5K_TRIG_LVL);
 	else
-		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG,
+		AR5K_REG_WRITE_BITS(hw, AR5K_TXCFG,
 				AR5K_TXCFG_TXFULL, trigger_level);
 
 	ret = 0;
@@ -1433,7 +1433,7 @@ done:
 	/*
 	 * Restore interrupt mask
 	 */
-	ath5k_hw_set_intr(hal, imr);
+	ath5k_hw_set_intr(hw, imr);
 
 	return ret;
 }
@@ -1445,16 +1445,16 @@ done:
 /*
  * Check if we have pending interrupts
  */
-bool ath5k_hw_is_intr_pending(struct ath_hw *hal)
+bool ath5k_hw_is_intr_pending(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	return ath5k_hw_reg_read(hal, AR5K_INTPEND);
+	return ath5k_hw_reg_read(hw, AR5K_INTPEND);
 }
 
 /*
  * Get interrupt mask (ISR)
  */
-int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
+int ath5k_hw_get_isr(struct ath_hw *hw, enum ath5k_int *interrupt_mask)
 {
 	u32 data;
 
@@ -1464,8 +1464,8 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 	 * Read interrupt status from the Interrupt Status register
 	 * on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		data = ath5k_hw_reg_read(hal, AR5K_ISR);
+	if (hw->ah_version == AR5K_AR5210) {
+		data = ath5k_hw_reg_read(hw, AR5K_ISR);
 		if (unlikely(data == AR5K_INT_NOCARD)) {
 			*interrupt_mask = data;
 			return -ENODEV;
@@ -1475,13 +1475,13 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 		 * Read interrupt status from the Read-And-Clear shadow register
 		 * Note: PISR/SISR Not available on 5210
 		 */
-		data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
+		data = ath5k_hw_reg_read(hw, AR5K_RAC_PISR);
 	}
 
 	/*
-	 * Get abstract interrupt mask (HAL-compatible)
+	 * Get abstract interrupt mask (hw-compatible)
 	 */
-	*interrupt_mask = (data & AR5K_INT_COMMON) & hal->ah_imr;
+	*interrupt_mask = (data & AR5K_INT_COMMON) & hw->ah_imr;
 
 	if (unlikely(data == AR5K_INT_NOCARD))
 		return -ENODEV;
@@ -1492,7 +1492,7 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR))
 		*interrupt_mask |= AR5K_INT_TX;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		/*HIU = Host Interface Unit (PCI etc)*/
 		if (unlikely(data & (AR5K_ISR_HIUERR)))
 			*interrupt_mask |= AR5K_INT_FATAL;
@@ -1525,7 +1525,7 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 /*
  * Set interrupt mask
  */
-enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
+enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hw, enum ath5k_int new_mask)
 {
 	enum ath5k_int old_mask, int_mask;
 
@@ -1533,9 +1533,9 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 	 * Disable card interrupts to prevent any race conditions
 	 * (they will be re-enabled afterwards).
 	 */
-	ath5k_hw_reg_write(hal, AR5K_IER_DISABLE, AR5K_IER);
+	ath5k_hw_reg_write(hw, AR5K_IER_DISABLE, AR5K_IER);
 
-	old_mask = hal->ah_imr;
+	old_mask = hw->ah_imr;
 
 	/*
 	 * Add additional, chipset-dependent interrupt mask flags
@@ -1551,21 +1551,21 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 		int_mask |= AR5K_IMR_TXOK | AR5K_IMR_TXERR | AR5K_IMR_TXDESC |
 			AR5K_IMR_TXURN;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (hw->ah_version != AR5K_AR5210) {
 		if (new_mask & AR5K_INT_FATAL) {
 			int_mask |= AR5K_IMR_HIUERR;
-			AR5K_REG_ENABLE_BITS(hal, AR5K_SIMR2, AR5K_SIMR2_MCABT |
+			AR5K_REG_ENABLE_BITS(hw, AR5K_SIMR2, AR5K_SIMR2_MCABT |
 					AR5K_SIMR2_SSERR | AR5K_SIMR2_DPERR);
 		}
 	}
 
-	ath5k_hw_reg_write(hal, int_mask, AR5K_PIMR);
+	ath5k_hw_reg_write(hw, int_mask, AR5K_PIMR);
 
 	/* Store new interrupt mask */
-	hal->ah_imr = new_mask;
+	hw->ah_imr = new_mask;
 
 	/* ..re-enable interrupts */
-	ath5k_hw_reg_write(hal, AR5K_IER_ENABLE, AR5K_IER);
+	ath5k_hw_reg_write(hw, AR5K_IER_ENABLE, AR5K_IER);
 
 	return old_mask;
 }
@@ -1578,7 +1578,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 /*
  * Read from eeprom
  */
-static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
+static int ath5k_hw_eeprom_read(struct ath_hw *hw, u32 offset, u16 *data)
 {
 	u32 status, timeout;
 
@@ -1586,21 +1586,21 @@ static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
 	/*
 	 * Initialize EEPROM access
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_EEAE);
-		(void)ath5k_hw_reg_read(hal, AR5K_EEPROM_BASE + (4 * offset));
+	if (hw->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+		(void)ath5k_hw_reg_read(hw, AR5K_EEPROM_BASE + (4 * offset));
 	} else {
-		ath5k_hw_reg_write(hal, offset, AR5K_EEPROM_BASE);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		ath5k_hw_reg_write(hw, offset, AR5K_EEPROM_BASE);
+		AR5K_REG_ENABLE_BITS(hw, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_READ);
 	}
 
 	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(hal, AR5K_EEPROM_STATUS);
+		status = ath5k_hw_reg_read(hw, AR5K_EEPROM_STATUS);
 		if (status & AR5K_EEPROM_STAT_RDDONE) {
 			if (status & AR5K_EEPROM_STAT_RDERR)
 				return -EIO;
-			*data = (u16)(ath5k_hw_reg_read(hal, AR5K_EEPROM_DATA) &
+			*data = (u16)(ath5k_hw_reg_read(hw, AR5K_EEPROM_DATA) &
 					0xffff);
 			return 0;
 		}
@@ -1613,7 +1613,7 @@ static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
 /*
  * Write to eeprom - currently disabled, use at your own risk
  */
-static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
+static int ath5k_hw_eeprom_write(struct ath_hw *hw, u32 offset, u16 data)
 {
 #if 0
 	u32 status, timeout;
@@ -1624,10 +1624,10 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 * Initialize eeprom access
 	 */
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+	if (hw->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PCICFG, AR5K_PCICFG_EEAE);
 	} else {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		AR5K_REG_ENABLE_BITS(hw, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_RESET);
 	}
 
@@ -1635,12 +1635,12 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 * Write data to data register
 	 */
 
-	if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, data, AR5K_EEPROM_BASE + (4 * offset));
+	if (hw->ah_version == AR5K_AR5210) {
+		ath5k_hw_reg_write(hw, data, AR5K_EEPROM_BASE + (4 * offset));
 	} else {
-		ath5k_hw_reg_write(hal, offset, AR5K_EEPROM_BASE);
-		ath5k_hw_reg_write(hal, data, AR5K_EEPROM_DATA);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		ath5k_hw_reg_write(hw, offset, AR5K_EEPROM_BASE);
+		ath5k_hw_reg_write(hw, data, AR5K_EEPROM_DATA);
+		AR5K_REG_ENABLE_BITS(hw, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_WRITE);
 	}
 
@@ -1649,7 +1649,7 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 */
 
 	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(hal, AR5K_EEPROM_STATUS);
+		status = ath5k_hw_reg_read(hw, AR5K_EEPROM_STATUS);
 		if (status & AR5K_EEPROM_STAT_WRDONE) {
 			if (status & AR5K_EEPROM_STAT_WRERR)
 				return EIO;
@@ -1665,7 +1665,7 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 /*
  * Translate binary channel representation in EEPROM to frequency
  */
-static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
+static u16 ath5k_eeprom_bin2freq(struct ath_hw *hw, u16 bin, unsigned int mode)
 {
 	u16 val;
 
@@ -1673,13 +1673,13 @@ static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
 		return bin;
 
 	if (mode == AR5K_EEPROM_MODE_11A) {
-		if (hal->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (hw->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = (5 * bin) + 4800;
 		else
 			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
 				(bin * 10) + 5100;
 	} else {
-		if (hal->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (hw->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = bin + 2300;
 		else
 			val = bin + 2400;
@@ -1691,10 +1691,10 @@ static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
 /*
  * Read antenna infos from eeprom
  */
-static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
+static int ath5k_eeprom_read_ants(struct ath_hw *hw, u32 *offset,
 		unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
 	int ret, i = 0;
@@ -1726,15 +1726,15 @@ static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
 	ee->ee_ant_control[mode][i++]	= val & 0x3f;
 
 	/* Get antenna modes */
-	hal->ah_antenna[mode][0] =
+	hw->ah_antenna[mode][0] =
 	    (ee->ee_ant_control[mode][0] << 4) | 0x1;
-	hal->ah_antenna[mode][AR5K_ANT_FIXED_A] =
+	hw->ah_antenna[mode][AR5K_ANT_FIXED_A] =
 	     ee->ee_ant_control[mode][1] 	|
 	    (ee->ee_ant_control[mode][2] << 6) 	|
 	    (ee->ee_ant_control[mode][3] << 12) |
 	    (ee->ee_ant_control[mode][4] << 18) |
 	    (ee->ee_ant_control[mode][5] << 24);
-	hal->ah_antenna[mode][AR5K_ANT_FIXED_B] =
+	hw->ah_antenna[mode][AR5K_ANT_FIXED_B] =
 	     ee->ee_ant_control[mode][6] 	|
 	    (ee->ee_ant_control[mode][7] << 6) 	|
 	    (ee->ee_ant_control[mode][8] << 12) |
@@ -1750,10 +1750,10 @@ static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
 /*
  * Read supported modes from eeprom
  */
-static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
+static int ath5k_eeprom_read_modes(struct ath_hw *hw, u32 *offset,
 		unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
 	int ret;
@@ -1762,7 +1762,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	ee->ee_tx_end2xlna_enable[mode]	= (val >> 8) & 0xff;
 	ee->ee_thr_62[mode]		= val & 0xff;
 
-	if (hal->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+	if (hw->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
 		ee->ee_thr_62[mode] = mode == AR5K_EEPROM_MODE_11A ? 15 : 28;
 
 	AR5K_EEPROM_READ(o++, val);
@@ -1777,7 +1777,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	else
 		ee->ee_noise_floor_thr[mode] = val & 0xff;
 
-	if (hal->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+	if (hw->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
 		ee->ee_noise_floor_thr[mode] =
 		    mode == AR5K_EEPROM_MODE_11A ? -54 : -1;
 
@@ -1786,10 +1786,10 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	ee->ee_x_gain[mode]		= (val >> 1) & 0xf;
 	ee->ee_xpd[mode]		= val & 0x1;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
 		ee->ee_fixed_bias[mode] = (val >> 13) & 0x1;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
 		AR5K_EEPROM_READ(o++, val);
 		ee->ee_false_detect[mode] = (val >> 6) & 0x7f;
 
@@ -1801,7 +1801,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 		}
 	}
 
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
+	if (hw->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
 		ee->ee_i_gain[mode] = AR5K_EEPROM_I_GAIN;
 		ee->ee_cck_ofdm_power_delta = AR5K_EEPROM_CCK_OFDM_DELTA;
 	} else {
@@ -1814,13 +1814,13 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 			ee->ee_cck_ofdm_power_delta = (val >> 3) & 0xff;
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
 			mode == AR5K_EEPROM_MODE_11A) {
 		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
 		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
 	    mode == AR5K_EEPROM_MODE_11G)
 		ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
 
@@ -1833,9 +1833,9 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 /*
  * Initialize eeprom & capabilities structs
  */
-static int ath5k_eeprom_init(struct ath_hw *hal)
+static int ath5k_eeprom_init(struct ath_hw *hw)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	unsigned int mode, i;
 	int ret;
 	u32 offset;
@@ -1856,7 +1856,7 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
 
 	/* Return if we have an old EEPROM */
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
+	if (hw->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
 		return 0;
 
 #ifdef notyet
@@ -1874,15 +1874,15 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	}
 #endif
 
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(hal->ah_ee_version),
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(hw->ah_ee_version),
 	    ee_ant_gain);
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
 		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
 	}
 
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
+	if (hw->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
 		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
 		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
 		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
@@ -1895,8 +1895,8 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	/*
 	 * Get conformance test limit values
 	 */
-	offset = AR5K_EEPROM_CTL(hal->ah_ee_version);
-	ee->ee_ctls = AR5K_EEPROM_N_CTLS(hal->ah_ee_version);
+	offset = AR5K_EEPROM_CTL(hw->ah_ee_version);
+	ee->ee_ctls = AR5K_EEPROM_N_CTLS(hw->ah_ee_version);
 
 	for (i = 0; i < ee->ee_ctls; i++) {
 		AR5K_EEPROM_READ(offset++, val);
@@ -1912,9 +1912,9 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_turbo_max_power[mode] =
 			AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
 
-	offset = AR5K_EEPROM_MODES_11A(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11A(hw->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(hw, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1932,11 +1932,11 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
 	ee->ee_db[mode][0]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(hw, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_margin_tx_rx[mode] = val & 0x3f;
 	}
@@ -1945,9 +1945,9 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	 * Get values for 802.11b (2.4GHz)
 	 */
 	mode = AR5K_EEPROM_MODE_11B;
-	offset = AR5K_EEPROM_MODES_11B(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11B(hw->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(hw, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1956,32 +1956,32 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
 	ee->ee_db[mode][1]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(hw, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, val & 0xff, mode);
 		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(hal, (val >> 8) & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, (val >> 8) & 0xff, mode);
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, val & 0xff, mode);
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
 		ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
 
 	/*
 	 * Get values for 802.11g (2.4GHz)
 	 */
 	mode = AR5K_EEPROM_MODE_11G;
-	offset = AR5K_EEPROM_MODES_11G(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11G(hw->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(hw, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1990,16 +1990,16 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
 	ee->ee_db[mode][1]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(hw, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, val & 0xff, mode);
 		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(hal, (val >> 8) & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, (val >> 8) & 0xff, mode);
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_turbo_max_power[mode] = val & 0x7f;
@@ -2007,16 +2007,16 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(hw, val & 0xff, mode);
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+		if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
 			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
 		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
+		if (hw->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
 			AR5K_EEPROM_READ(offset++, val);
 			ee->ee_cck_ofdm_gain_delta = val & 0xff;
 		}
@@ -2032,7 +2032,7 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 /*
  * Read the MAC address from eeprom
  */
-static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
+static int ath5k_eeprom_read_mac(struct ath_hw *hw, u8 *mac)
 {
 	u8 mac_d[ETH_ALEN];
 	u32 total, offset;
@@ -2042,12 +2042,12 @@ static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
 	memset(mac, 0, ETH_ALEN);
 	memset(mac_d, 0, ETH_ALEN);
 
-	ret = ath5k_hw_eeprom_read(hal, 0x20, &data);
+	ret = ath5k_hw_eeprom_read(hw, 0x20, &data);
 	if (ret)
 		return ret;
 
 	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		ret = ath5k_hw_eeprom_read(hal, offset, &data);
+		ret = ath5k_hw_eeprom_read(hw, offset, &data);
 		if (ret)
 			return ret;
 
@@ -2068,14 +2068,14 @@ static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
 /*
  * Read/Write regulatory domain
  */
-static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
+static bool ath5k_eeprom_regulation_domain(struct ath_hw *hw, bool write,
 	enum ath5k_regdom *regdomain)
 {
 	u16 ee_regdomain;
 
 	/* Read current value */
 	if (write != true) {
-		ee_regdomain = hal->ah_capabilities.cap_eeprom.ee_regdomain;
+		ee_regdomain = hw->ah_capabilities.cap_eeprom.ee_regdomain;
 		*regdomain = ath5k_regdom_to_ieee(ee_regdomain);
 		return true;
 	}
@@ -2083,13 +2083,13 @@ static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
 	ee_regdomain = ath5k_regdom_from_ieee(*regdomain);
 
 	/* Try to write a new value */
-	if (hal->ah_capabilities.cap_eeprom.ee_protect &
+	if (hw->ah_capabilities.cap_eeprom.ee_protect &
 			AR5K_EEPROM_PROTECT_WR_128_191)
 		return false;
-	if (ath5k_hw_eeprom_write(hal, AR5K_EEPROM_REG_DOMAIN, ee_regdomain)!=0)
+	if (ath5k_hw_eeprom_write(hw, AR5K_EEPROM_REG_DOMAIN, ee_regdomain)!=0)
 		return false;
 
-	hal->ah_capabilities.cap_eeprom.ee_regdomain = ee_regdomain;
+	hw->ah_capabilities.cap_eeprom.ee_regdomain = ee_regdomain;
 
 	return true;
 }
@@ -2097,13 +2097,13 @@ static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
 /*
  * Use the above to write a new regulatory domain
  */
-int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain)
+int ath5k_hw_set_regdomain(struct ath_hw *hw, u16 regdomain)
 {
 	enum ath5k_regdom ieee_regdomain;
 
 	ieee_regdomain = ath5k_regdom_to_ieee(regdomain);
 
-	if (ath5k_eeprom_regulation_domain(hal, true, &ieee_regdomain) == true)
+	if (ath5k_eeprom_regulation_domain(hw, true, &ieee_regdomain) == true)
 		return 0;
 
 	return -EIO;
@@ -2112,27 +2112,27 @@ int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain)
 /*
  * Fill the capabilities struct
  */
-static int ath5k_hw_get_capabilities(struct ath_hw *hal)
+static int ath5k_hw_get_capabilities(struct ath_hw *hw)
 {
 	u16 ee_header;
 
 	AR5K_TRACE;
 	/* Capabilities stored in the EEPROM */
-	ee_header = hal->ah_capabilities.cap_eeprom.ee_header;
+	ee_header = hw->ah_capabilities.cap_eeprom.ee_header;
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		/*
 		 * Set radio capabilities
 		 * (The AR5110 only supports the middle 5GHz band)
 		 */
-		hal->ah_capabilities.cap_range.range_5ghz_min = 5120;
-		hal->ah_capabilities.cap_range.range_5ghz_max = 5430;
-		hal->ah_capabilities.cap_range.range_2ghz_min = 0;
-		hal->ah_capabilities.cap_range.range_2ghz_max = 0;
+		hw->ah_capabilities.cap_range.range_5ghz_min = 5120;
+		hw->ah_capabilities.cap_range.range_5ghz_max = 5430;
+		hw->ah_capabilities.cap_range.range_2ghz_min = 0;
+		hw->ah_capabilities.cap_range.range_2ghz_max = 0;
 
 		/* Set supported modes */
-		__set_bit(MODE_IEEE80211A, hal->ah_capabilities.cap_mode);
-		__set_bit(MODE_ATHEROS_TURBO, hal->ah_capabilities.cap_mode);
+		__set_bit(MODE_IEEE80211A, hw->ah_capabilities.cap_mode);
+		__set_bit(MODE_ATHEROS_TURBO, hw->ah_capabilities.cap_mode);
 	} else {
 		/*
 		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
@@ -2150,45 +2150,45 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 		 */
 
 		if (AR5K_EEPROM_HDR_11A(ee_header)) {
-			hal->ah_capabilities.cap_range.range_5ghz_min = 5005; /* 4920 */
-			hal->ah_capabilities.cap_range.range_5ghz_max = 6100;
+			hw->ah_capabilities.cap_range.range_5ghz_min = 5005; /* 4920 */
+			hw->ah_capabilities.cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */
 			__set_bit(MODE_IEEE80211A,
-					hal->ah_capabilities.cap_mode);
+					hw->ah_capabilities.cap_mode);
 			__set_bit(MODE_ATHEROS_TURBO,
-					hal->ah_capabilities.cap_mode);
-			if (hal->ah_version == AR5K_AR5212)
+					hw->ah_capabilities.cap_mode);
+			if (hw->ah_version == AR5K_AR5212)
 				__set_bit(MODE_ATHEROS_TURBOG,
-						hal->ah_capabilities.cap_mode);
+						hw->ah_capabilities.cap_mode);
 		}
 
 		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
 		 * connected */
 		if (AR5K_EEPROM_HDR_11B(ee_header) ||
 				AR5K_EEPROM_HDR_11G(ee_header)) {
-			hal->ah_capabilities.cap_range.range_2ghz_min = 2412; /* 2312 */
-			hal->ah_capabilities.cap_range.range_2ghz_max = 2732;
+			hw->ah_capabilities.cap_range.range_2ghz_min = 2412; /* 2312 */
+			hw->ah_capabilities.cap_range.range_2ghz_max = 2732;
 
 			if (AR5K_EEPROM_HDR_11B(ee_header))
 				__set_bit(MODE_IEEE80211B,
-						hal->ah_capabilities.cap_mode);
+						hw->ah_capabilities.cap_mode);
 
 			if (AR5K_EEPROM_HDR_11G(ee_header))
 				__set_bit(MODE_IEEE80211G,
-						hal->ah_capabilities.cap_mode);
+						hw->ah_capabilities.cap_mode);
 		}
 	}
 
 	/* GPIO */
-	hal->ah_gpio_npins = AR5K_NUM_GPIO;
+	hw->ah_gpio_npins = AR5K_NUM_GPIO;
 
 	/* Set number of supported TX queues */
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_capabilities.cap_queues.q_tx_num =
+	if (hw->ah_version == AR5K_AR5210)
+		hw->ah_capabilities.cap_queues.q_tx_num =
 			AR5K_NUM_TX_QUEUES_NOQCU;
 	else
-		hal->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
+		hw->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
 
 	return 0;
 }
@@ -2200,7 +2200,7 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 /*
  * Set Operation mode
  */
-int ath5k_hw_set_opmode(struct ath_hw *hal)
+int ath5k_hw_set_opmode(struct ath_hw *hw)
 {
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
@@ -2209,28 +2209,28 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 
 	AR5K_TRACE;
 
-	switch (hal->ah_op_mode) {
+	switch (hw->ah_op_mode) {
 	case IEEE80211_IF_TYPE_IBSS:
 		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(hw->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_ADHOC;
 		break;
 
 	case IEEE80211_IF_TYPE_AP:
 		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(hw->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_AP;
 		break;
 
 	case IEEE80211_IF_TYPE_STA:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(hw->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
 	case IEEE80211_IF_TYPE_MNTR:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(hw->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		break;
 
@@ -2241,16 +2241,16 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 	/*
 	 * Set PCU registers
 	 */
-	low_id = AR5K_LOW_ID(hal->ah_sta_id);
-	high_id = AR5K_HIGH_ID(hal->ah_sta_id);
-	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(hal, pcu_reg | high_id, AR5K_STA_ID1);
+	low_id = AR5K_LOW_ID(hw->ah_sta_id);
+	high_id = AR5K_HIGH_ID(hw->ah_sta_id);
+	ath5k_hw_reg_write(hw, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(hw, pcu_reg | high_id, AR5K_STA_ID1);
 
 	/*
 	 * Set Beacon Control Register on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, beacon_reg, AR5K_BCR);
+	if (hw->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(hw, beacon_reg, AR5K_BCR);
 
 	return 0;
 }
@@ -2262,28 +2262,28 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 /*
  * Get station id
  */
-void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac)
+void ath5k_hw_get_lladdr(struct ath_hw *hw, u8 *mac)
 {
 	AR5K_TRACE;
-	memcpy(mac, hal->ah_sta_id, ETH_ALEN);
+	memcpy(mac, hw->ah_sta_id, ETH_ALEN);
 }
 
 /*
  * Set station id
  */
-int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
+int ath5k_hw_set_lladdr(struct ath_hw *hw, const u8 *mac)
 {
 	u32 low_id, high_id;
 
 	AR5K_TRACE;
 	/* Set new station ID */
-	memcpy(hal->ah_sta_id, mac, ETH_ALEN);
+	memcpy(hw->ah_sta_id, mac, ETH_ALEN);
 
 	low_id = AR5K_LOW_ID(mac);
 	high_id = AR5K_HIGH_ID(mac);
 
-	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(hal, high_id, AR5K_STA_ID1);
+	ath5k_hw_reg_write(hw, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(hw, high_id, AR5K_STA_ID1);
 
 	return 0;
 }
@@ -2291,7 +2291,7 @@ int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 /*
  * Set BSSID
  */
-void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
+void ath5k_hw_set_associd(struct ath_hw *hw, const u8 *bssid, u16 assoc_id)
 {
 	u32 low_id, high_id;
 	u16 tim_offset = 0;
@@ -2299,9 +2299,9 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 	/*
 	 * Set simple BSSID mask on 5212
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, 0xfffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(hal, 0xfffffff, AR5K_BSS_IDM1);
+	if (hw->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(hw, 0xfffffff, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(hw, 0xfffffff, AR5K_BSS_IDM1);
 	}
 
 	/*
@@ -2309,20 +2309,20 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 	 */
 	low_id = AR5K_LOW_ID(bssid);
 	high_id = AR5K_HIGH_ID(bssid);
-	ath5k_hw_reg_write(hal, low_id, AR5K_BSS_ID0);
-	ath5k_hw_reg_write(hal, high_id | ((assoc_id & 0x3fff) <<
+	ath5k_hw_reg_write(hw, low_id, AR5K_BSS_ID0);
+	ath5k_hw_reg_write(hw, high_id | ((assoc_id & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
-	memcpy(&hal->ah_bssid, bssid, ETH_ALEN);
+	memcpy(&hw->ah_bssid, bssid, ETH_ALEN);
 
 	if (assoc_id == 0) {
-		ath5k_hw_disable_pspoll(hal);
+		ath5k_hw_disable_pspoll(hw);
 		return;
 	}
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_BEACON, AR5K_BEACON_TIM,
+	AR5K_REG_WRITE_BITS(hw, AR5K_BEACON, AR5K_BEACON_TIM,
 			tim_offset ? tim_offset + 4 : 0);
 
-	ath5k_hw_enable_pspoll(hal, NULL, 0);
+	ath5k_hw_enable_pspoll(hw, NULL, 0);
 }
 /**
  * ath5k_hw_set_bssid_mask - set common bits we should listen to
@@ -2333,7 +2333,7 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
  * mode with a single BSS every bit matters as well. In AP mode with
  * multiple BSSes not every bit matters.
  *
- * @hal: the &struct ath_hw
+ * @hw: the &struct ath_hw
  * @mask: the bssid_mask, a u8 array of size ETH_ALEN
  *
  * Note that this is a simple filter and *does* not filter out all
@@ -2418,17 +2418,17 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
  * IFRAME-05:  1101 --> allowed but its not for us!!!
  *
  */
-int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
+int ath5k_hw_set_bssid_mask(struct ath_hw *hw, const u8 *mask)
 {
 	u32 low_id, high_id;
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5212) {
+	if (hw->ah_version == AR5K_AR5212) {
 		low_id = AR5K_LOW_ID(mask);
 		high_id = AR5K_HIGH_ID(mask);
 
-		ath5k_hw_reg_write(hal, low_id, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(hal, high_id, AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(hw, low_id, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(hw, high_id, AR5K_BSS_IDM1);
 
 		return 0;
 	}
@@ -2443,19 +2443,19 @@ int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 /*
  * Start receive on PCU
  */
-void ath5k_hw_start_rx_pcu(struct ath_hw *hal)
+void ath5k_hw_start_rx_pcu(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+	AR5K_REG_DISABLE_BITS(hw, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /*
  * Stop receive on PCU
  */
-void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
+void ath5k_hw_stop_pcu_recv(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /*
@@ -2465,28 +2465,28 @@ void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 /*
  * Set multicast filter
  */
-void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
+void ath5k_hw_set_mcast_filter(struct ath_hw *hw, u32 filter0, u32 filter1)
 {
 	AR5K_TRACE;
 	/* Set the multicat filter */
-	ath5k_hw_reg_write(hal, filter0, AR5K_MCAST_FILTER0);
-	ath5k_hw_reg_write(hal, filter1, AR5K_MCAST_FILTER1);
+	ath5k_hw_reg_write(hw, filter0, AR5K_MCAST_FILTER0);
+	ath5k_hw_reg_write(hw, filter1, AR5K_MCAST_FILTER1);
 }
 
 /*
  * Set multicast filter by index
  */
-int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
+int ath5k_hw_set_mcast_filterindex(struct ath_hw *hw, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
-		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER1,
+		AR5K_REG_ENABLE_BITS(hw, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
-		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
+		AR5K_REG_ENABLE_BITS(hw, AR5K_MCAST_FILTER0, (1 << index));
 
 	return 0;
 }
@@ -2494,17 +2494,17 @@ int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
 /*
  * Clear Multicast filter by index
  */
-int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
+int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hw, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
-		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER1,
+		AR5K_REG_DISABLE_BITS(hw, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
-		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
+		AR5K_REG_DISABLE_BITS(hw, AR5K_MCAST_FILTER0, (1 << index));
 
 	return 0;
 }
@@ -2580,36 +2580,36 @@ void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter)
 /*
  * Get a 32bit TSF
  */
-u32 ath5k_hw_get_tsf32(struct ath_hw *hal)
+u32 ath5k_hw_get_tsf32(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	return ath5k_hw_reg_read(hal, AR5K_TSF_L32);
+	return ath5k_hw_reg_read(hw, AR5K_TSF_L32);
 }
 
 /*
  * Get the full 64bit TSF
  */
-u64 ath5k_hw_get_tsf64(struct ath_hw *hal)
+u64 ath5k_hw_get_tsf64(struct ath_hw *hw)
 {
-	u64 tsf = ath5k_hw_reg_read(hal, AR5K_TSF_U32);
+	u64 tsf = ath5k_hw_reg_read(hw, AR5K_TSF_U32);
 	AR5K_TRACE;
 
-	return ath5k_hw_reg_read(hal, AR5K_TSF_L32) | (tsf << 32);
+	return ath5k_hw_reg_read(hw, AR5K_TSF_L32) | (tsf << 32);
 }
 
 /*
  * Force a TSF reset
  */
-void ath5k_hw_reset_tsf(struct ath_hw *hal)
+void ath5k_hw_reset_tsf(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	AR5K_REG_ENABLE_BITS(hal, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
 }
 
 /*
  * Initialize beacon timers
  */
-void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
+void ath5k_hw_init_beacon(struct ath_hw *hw, u32 next_beacon, u32 interval)
 {
 	u32 timer1, timer2, timer3;
 
@@ -2617,9 +2617,9 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 	/*
 	 * Set the additional timers by mode
 	 */
-	switch (hal->ah_op_mode) {
+	switch (hw->ah_op_mode) {
 	case IEEE80211_IF_TYPE_STA:
-		if (hal->ah_version == AR5K_AR5210) {
+		if (hw->ah_version == AR5K_AR5210) {
 			timer1 = 0xffffffff;
 			timer2 = 0xffffffff;
 		} else {
@@ -2635,18 +2635,18 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 		    0x00000003;
 	}
 
-	timer3 = next_beacon + (hal->ah_atim_window ? hal->ah_atim_window : 1);
+	timer3 = next_beacon + (hw->ah_atim_window ? hw->ah_atim_window : 1);
 
 	/*
 	 * Set the beacon register and enable all timers.
 	 * (next beacon, DMA beacon, software beacon, ATIM window time)
 	 */
-	ath5k_hw_reg_write(hal, next_beacon, AR5K_TIMER0);
-	ath5k_hw_reg_write(hal, timer1, AR5K_TIMER1);
-	ath5k_hw_reg_write(hal, timer2, AR5K_TIMER2);
-	ath5k_hw_reg_write(hal, timer3, AR5K_TIMER3);
+	ath5k_hw_reg_write(hw, next_beacon, AR5K_TIMER0);
+	ath5k_hw_reg_write(hw, timer1, AR5K_TIMER1);
+	ath5k_hw_reg_write(hw, timer2, AR5K_TIMER2);
+	ath5k_hw_reg_write(hw, timer3, AR5K_TIMER3);
 
-	ath5k_hw_reg_write(hal, interval & (AR5K_BEACON_PERIOD |
+	ath5k_hw_reg_write(hw, interval & (AR5K_BEACON_PERIOD |
 			AR5K_BEACON_RESET_TSF | AR5K_BEACON_ENABLE),
 		AR5K_BEACON);
 }
@@ -2654,7 +2654,7 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 /*
  * Set beacon timers
  */
-int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
+int ath5k_hw_set_beacon_timers(struct ath_hw *hw,
 		const struct ath5k_beacon_state *state)
 {
 	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
@@ -2692,17 +2692,17 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		next_cfp = (cfp_count * state->bs_dtim_period + dtim_count) *
 			state->bs_interval;
 
-		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
+		AR5K_REG_ENABLE_BITS(hw, AR5K_STA_ID1,
 				AR5K_STA_ID1_DEFAULT_ANTENNA |
 				AR5K_STA_ID1_PCF);
-		ath5k_hw_reg_write(hal, cfp_period, AR5K_CFP_PERIOD);
-		ath5k_hw_reg_write(hal, state->bs_cfp_max_duration,
+		ath5k_hw_reg_write(hw, cfp_period, AR5K_CFP_PERIOD);
+		ath5k_hw_reg_write(hw, state->bs_cfp_max_duration,
 				AR5K_CFP_DUR);
-		ath5k_hw_reg_write(hal, (tsf + (next_cfp == 0 ? cfp_period :
+		ath5k_hw_reg_write(hw, (tsf + (next_cfp == 0 ? cfp_period :
 						next_cfp)) << 3, AR5K_TIMER2);
 	} else {
 		/* Disable PCF mode */
-		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+		AR5K_REG_DISABLE_BITS(hw, AR5K_STA_ID1,
 				AR5K_STA_ID1_DEFAULT_ANTENNA |
 				AR5K_STA_ID1_PCF);
 	}
@@ -2710,12 +2710,12 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	/*
 	 * Enable the beacon timer register
 	 */
-	ath5k_hw_reg_write(hal, state->bs_next_beacon, AR5K_TIMER0);
+	ath5k_hw_reg_write(hw, state->bs_next_beacon, AR5K_TIMER0);
 
 	/*
 	 * Start the beacon timers
 	 */
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_BEACON) &~
+	ath5k_hw_reg_write(hw, (ath5k_hw_reg_read(hw, AR5K_BEACON) &~
 		(AR5K_BEACON_PERIOD | AR5K_BEACON_TIM)) |
 		AR5K_REG_SM(state->bs_tim_offset ? state->bs_tim_offset + 4 : 0,
 		AR5K_BEACON_TIM) | AR5K_REG_SM(state->bs_interval,
@@ -2728,7 +2728,7 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	 * setting value to a largest value and seeing which values register.
 	 */
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
+	AR5K_REG_WRITE_BITS(hw, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
 			state->bs_bmiss_threshold);
 
 	/*
@@ -2736,13 +2736,13 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	 * XXX: Didn't find this in 5210 code but since this register
 	 * exists also in ar5k's 5210 headers i leave it as common code.
 	 */
-	AR5K_REG_WRITE_BITS(hal, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
+	AR5K_REG_WRITE_BITS(hw, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
 			(state->bs_sleep_duration - 3) << 3);
 
 	/*
 	 * Set enhanced sleep registers on 5212
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
+	if (hw->ah_version == AR5K_AR5212) {
 		if (state->bs_sleep_duration > state->bs_interval &&
 				roundup(state->bs_sleep_duration, interval) ==
 				state->bs_sleep_duration)
@@ -2759,18 +2759,18 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		next_beacon = interval == dtim ? state->bs_next_dtim :
 			state->bs_next_beacon;
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			AR5K_REG_SM((state->bs_next_dtim - 3) << 3,
 			AR5K_SLEEP0_NEXT_DTIM) |
 			AR5K_REG_SM(10, AR5K_SLEEP0_CABTO) |
 			AR5K_SLEEP0_ENH_SLEEP_EN |
 			AR5K_SLEEP0_ASSUME_DTIM, AR5K_SLEEP0);
 
-		ath5k_hw_reg_write(hal, AR5K_REG_SM((next_beacon - 3) << 3,
+		ath5k_hw_reg_write(hw, AR5K_REG_SM((next_beacon - 3) << 3,
 			AR5K_SLEEP1_NEXT_TIM) |
 			AR5K_REG_SM(10, AR5K_SLEEP1_BEACON_TO), AR5K_SLEEP1);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
 			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
 	}
@@ -2781,27 +2781,27 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 /*
  * Reset beacon timers
  */
-void ath5k_hw_reset_beacon(struct ath_hw *hal)
+void ath5k_hw_reset_beacon(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 	/*
 	 * Disable beacon timer
 	 */
-	ath5k_hw_reg_write(hal, 0, AR5K_TIMER0);
+	ath5k_hw_reg_write(hw, 0, AR5K_TIMER0);
 
 	/*
 	 * Disable some beacon register values
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+	AR5K_REG_DISABLE_BITS(hw, AR5K_STA_ID1,
 			AR5K_STA_ID1_DEFAULT_ANTENNA | AR5K_STA_ID1_PCF);
-	ath5k_hw_reg_write(hal, AR5K_BEACON_PERIOD, AR5K_BEACON);
+	ath5k_hw_reg_write(hw, AR5K_BEACON_PERIOD, AR5K_BEACON);
 }
 
 /*
  * Wait for beacon queue to finish
  * TODO: This function's name is misleading, rename
  */
-int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
+int ath5k_hw_wait_for_beacon(struct ath_hw *hw, unsigned long phys_addr)
 {
 	unsigned int i;
 	int ret;
@@ -2809,15 +2809,15 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 	AR5K_TRACE;
 
 	/* 5210 doesn't have QCU*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		/*
 		 * Wait for beaconn queue to finish by checking
 		 * Control Register and Beacon Status Register.
 		 */
 		for (i = AR5K_TUNE_BEACON_INTERVAL / 2; i > 0; i--) {
-			if (!(ath5k_hw_reg_read(hal, AR5K_BSR) & AR5K_BSR_TXQ1F)
+			if (!(ath5k_hw_reg_read(hw, AR5K_BSR) & AR5K_BSR_TXQ1F)
 					||
-			    !(ath5k_hw_reg_read(hal, AR5K_CR) & AR5K_BSR_TXQ1F))
+			    !(ath5k_hw_reg_read(hw, AR5K_CR) & AR5K_BSR_TXQ1F))
 				break;
 			udelay(10);
 		}
@@ -2827,8 +2827,8 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 			/*
 			 * Re-schedule the beacon queue
 			 */
-			ath5k_hw_reg_write(hal, phys_addr, AR5K_NOQCU_TXDP1);
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+			ath5k_hw_reg_write(hw, phys_addr, AR5K_NOQCU_TXDP1);
+			ath5k_hw_reg_write(hw, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BCR);
 
 			return -EIO;
@@ -2836,11 +2836,11 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 		ret = 0;
 	} else {
 	/*5211/5212*/
-		ret = ath5k_hw_register_timeout(hal,
+		ret = ath5k_hw_register_timeout(hw,
 			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
 			AR5K_QCU_STS_FRMPENDCNT, 0, false);
 
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
+		if (AR5K_REG_READ_Q(hw, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
 			return -EIO;
 	}
 
@@ -2850,23 +2850,23 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 /*
  * Update mib counters (statistics)
  */
-void ath5k_hw_update_mib_counters(struct ath_hw *hal,
+void ath5k_hw_update_mib_counters(struct ath_hw *hw,
 		struct ath5k_mib_stats *statistics)
 {
 	AR5K_TRACE;
 	/* Read-And-Clear */
-	statistics->ackrcv_bad += ath5k_hw_reg_read(hal, AR5K_ACK_FAIL);
-	statistics->rts_bad += ath5k_hw_reg_read(hal, AR5K_RTS_FAIL);
-	statistics->rts_good += ath5k_hw_reg_read(hal, AR5K_RTS_OK);
-	statistics->fcs_bad += ath5k_hw_reg_read(hal, AR5K_FCS_FAIL);
-	statistics->beacons += ath5k_hw_reg_read(hal, AR5K_BEACON_CNT);
+	statistics->ackrcv_bad += ath5k_hw_reg_read(hw, AR5K_ACK_FAIL);
+	statistics->rts_bad += ath5k_hw_reg_read(hw, AR5K_RTS_FAIL);
+	statistics->rts_good += ath5k_hw_reg_read(hw, AR5K_RTS_OK);
+	statistics->fcs_bad += ath5k_hw_reg_read(hw, AR5K_FCS_FAIL);
+	statistics->beacons += ath5k_hw_reg_read(hw, AR5K_BEACON_CNT);
 
 	/* Reset profile count registers on 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_TX);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_RX);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_RXCLR);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_CYCLE);
+	if (hw->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(hw, 0, AR5K_PROFCNT_TX);
+		ath5k_hw_reg_write(hw, 0, AR5K_PROFCNT_RX);
+		ath5k_hw_reg_write(hw, 0, AR5K_PROFCNT_RXCLR);
+		ath5k_hw_reg_write(hw, 0, AR5K_PROFCNT_CYCLE);
 	}
 }
 
@@ -2877,15 +2877,15 @@ void ath5k_hw_update_mib_counters(struct ath_hw *hal,
 /*
  * Set ACK timeout on PCU
  */
-int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_ack_timeout(struct ath_hw *hw, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
-			hal->ah_turbo) <= timeout)
+			hw->ah_turbo) <= timeout)
 		return -EINVAL;
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
-		ath5k_hw_htoclock(timeout, hal->ah_turbo));
+	AR5K_REG_WRITE_BITS(hw, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
+		ath5k_hw_htoclock(timeout, hw->ah_turbo));
 
 	return 0;
 }
@@ -2893,26 +2893,26 @@ int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
 /*
  * Read the ACK timeout from PCU
  */
-unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo);
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hw,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hw->ah_turbo);
 }
 
 /*
  * Set CTS timeout on PCU
  */
-int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_cts_timeout(struct ath_hw *hw, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
-			hal->ah_turbo) <= timeout)
+			hw->ah_turbo) <= timeout)
 		return -EINVAL;
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
-			ath5k_hw_htoclock(timeout, hal->ah_turbo));
+	AR5K_REG_WRITE_BITS(hw, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
+			ath5k_hw_htoclock(timeout, hw->ah_turbo));
 
 	return 0;
 }
@@ -2920,18 +2920,18 @@ int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
 /*
  * Read CTS timeout from PCU
  */
-unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo);
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hw,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hw->ah_turbo);
 }
 
 /*
  * Key table (WEP) functions
  */
 
-int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry)
+int ath5k_hw_reset_key(struct ath_hw *hw, u16 entry)
 {
 	unsigned int i;
 
@@ -2939,27 +2939,27 @@ int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry)
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
-		ath5k_hw_reg_write(hal, 0, AR5K_KEYTABLE_OFF(entry, i));
+		ath5k_hw_reg_write(hw, 0, AR5K_KEYTABLE_OFF(entry, i));
 
 	/* Set NULL encryption on non-5210*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(hal, AR5K_KEYTABLE_TYPE_NULL,
+	if (hw->ah_version != AR5K_AR5210)
+		ath5k_hw_reg_write(hw, AR5K_KEYTABLE_TYPE_NULL,
 				AR5K_KEYTABLE_TYPE(entry));
 
 	return 0;
 }
 
-int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry)
+int ath5k_hw_is_key_valid(struct ath_hw *hw, u16 entry)
 {
 	AR5K_TRACE;
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	/* Check the validation flag at the end of the entry */
-	return ath5k_hw_reg_read(hal, AR5K_KEYTABLE_MAC1(entry)) &
+	return ath5k_hw_reg_read(hw, AR5K_KEYTABLE_MAC1(entry)) &
 		AR5K_KEYTABLE_VALID;
 }
 
-int ath5k_hw_set_key(struct ath_hw *hal, u16 entry,
+int ath5k_hw_set_key(struct ath_hw *hw, u16 entry,
 		const struct ieee80211_key_conf *key, const u8 *mac)
 {
 	unsigned int i;
@@ -3000,15 +3000,15 @@ int ath5k_hw_set_key(struct ath_hw *hal, u16 entry,
 	}
 
 	for (i = 0; i < ARRAY_SIZE(key_v); i++)
-		ath5k_hw_reg_write(hal, le32_to_cpu(key_v[i]),
+		ath5k_hw_reg_write(hw, le32_to_cpu(key_v[i]),
 				AR5K_KEYTABLE_OFF(entry, i));
 
-	ath5k_hw_reg_write(hal, keytype, AR5K_KEYTABLE_TYPE(entry));
+	ath5k_hw_reg_write(hw, keytype, AR5K_KEYTABLE_TYPE(entry));
 
-	return ath5k_hw_set_key_lladdr(hal, entry, mac);
+	return ath5k_hw_set_key_lladdr(hw, entry, mac);
 }
 
-int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac)
+int ath5k_hw_set_key_lladdr(struct ath_hw *hw, u16 entry, const u8 *mac)
 {
 	u32 low_id, high_id;
 
@@ -3026,8 +3026,8 @@ int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac)
 		high_id = AR5K_HIGH_ID(mac) | AR5K_KEYTABLE_VALID;
 	}
 
-	ath5k_hw_reg_write(hal, low_id, AR5K_KEYTABLE_MAC0(entry));
-	ath5k_hw_reg_write(hal, high_id, AR5K_KEYTABLE_MAC1(entry));
+	ath5k_hw_reg_write(hw, low_id, AR5K_KEYTABLE_MAC0(entry));
+	ath5k_hw_reg_write(hw, high_id, AR5K_KEYTABLE_MAC1(entry));
 
 	return 0;
 }
@@ -3040,7 +3040,7 @@ Queue Control Unit, DFS Control Unit Functions
 /*
  * Initialize a transmit queue
  */
-int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
+int ath5k_hw_setup_tx_queue(struct ath_hw *hw, enum ath5k_tx_queue queue_type,
 		struct ath5k_txq_info *queue_info)
 {
 	unsigned int queue;
@@ -3052,7 +3052,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	 * Get queue by type
 	 */
 	/*5210 only has 2 queues*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
 			queue = AR5K_TX_QUEUE_ID_NOQCU_DATA;
@@ -3068,7 +3068,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
 			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
-				hal->ah_txq[queue].tqi_type !=
+				hw->ah_txq[queue].tqi_type !=
 				AR5K_TX_QUEUE_INACTIVE; queue++) {
 
 				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
@@ -3085,7 +3085,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 			queue = AR5K_TX_QUEUE_ID_CAB;
 			break;
 		case AR5K_TX_QUEUE_XR_DATA:
-			if (hal->ah_version != AR5K_AR5212)
+			if (hw->ah_version != AR5K_AR5212)
 				AR5K_PRINTF("XR data queues only supported in "
 						"5212!\n");
 			queue = AR5K_TX_QUEUE_ID_XR_DATA;
@@ -3098,12 +3098,12 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	/*
 	 * Setup internal queue structure
 	 */
-	memset(&hal->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
-	hal->ah_txq[queue].tqi_type = queue_type;
+	memset(&hw->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
+	hw->ah_txq[queue].tqi_type = queue_type;
 
 	if (queue_info != NULL) {
 		queue_info->tqi_type = queue_type;
-		ret = ath5k_hw_setup_tx_queueprops(hal, queue, queue_info);
+		ret = ath5k_hw_setup_tx_queueprops(hw, queue, queue_info);
 		if (ret)
 			return ret;
 	}
@@ -3112,7 +3112,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	 * the Secondary interrupt mask registers on 5211+
 	 * check out ath5k_hw_reset_tx_queue
 	 */
-	AR5K_Q_ENABLE_BITS(hal->ah_txq_interrupts, queue);
+	AR5K_Q_ENABLE_BITS(hw->ah_txq_interrupts, queue);
 
 	return queue;
 }
@@ -3120,23 +3120,23 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 /*
  * Setup a transmit queue
  */
-int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue,
+int ath5k_hw_setup_tx_queueprops(struct ath_hw *hw, int queue,
 				const struct ath5k_txq_info *queue_info)
 {
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (hw->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	memcpy(&hal->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
+	memcpy(&hw->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
 
 	/*XXX: Is this supported on 5210 ?*/
 	if ((queue_info->tqi_type == AR5K_TX_QUEUE_DATA &&
 			((queue_info->tqi_subtype == AR5K_WME_AC_VI) ||
 			(queue_info->tqi_subtype == AR5K_WME_AC_VO))) ||
 			queue_info->tqi_type == AR5K_TX_QUEUE_UAPSD)
-		hal->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
+		hw->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
 
 	return 0;
 }
@@ -3144,86 +3144,86 @@ int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue,
 /*
  * Get properties for a specific transmit queue
  */
-int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue,
+int ath5k_hw_get_tx_queueprops(struct ath_hw *hw, int queue,
 		struct ath5k_txq_info *queue_info)
 {
 	AR5K_TRACE;
-	memcpy(queue_info, &hal->ah_txq[queue], sizeof(struct ath5k_txq_info));
+	memcpy(queue_info, &hw->ah_txq[queue], sizeof(struct ath5k_txq_info));
 	return 0;
 }
 
 /*
  * Set a transmit queue inactive
  */
-void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue)
+void ath5k_hw_release_tx_queue(struct ath_hw *hw, unsigned int queue)
 {
 	AR5K_TRACE;
-	if (WARN_ON(queue >= hal->ah_capabilities.cap_queues.q_tx_num))
+	if (WARN_ON(queue >= hw->ah_capabilities.cap_queues.q_tx_num))
 		return;
 
 	/* This queue will be skipped in further operations */
-	hal->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
+	hw->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
 	/*For SIMR setup*/
-	AR5K_Q_DISABLE_BITS(hal->ah_txq_interrupts, queue);
+	AR5K_Q_DISABLE_BITS(hw->ah_txq_interrupts, queue);
 }
 
 /*
  * Set DFS params for a transmit queue
  */
-int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_reset_tx_queue(struct ath_hw *hw, unsigned int queue)
 {
 	u32 cw_min, cw_max, retry_lg, retry_sh;
-	struct ath5k_txq_info *tq = &hal->ah_txq[queue];
+	struct ath5k_txq_info *tq = &hw->ah_txq[queue];
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
-	tq = &hal->ah_txq[queue];
+	tq = &hw->ah_txq[queue];
 
 	if (tq->tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return 0;
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		/* Only handle data queues, others will be ignored */
 		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
 			return -EINVAL;
 
 		/* Set Slot time */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
 			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
 			AR5K_SLOT_TIME);
 		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
 			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
 			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
 		/* Set Transmit Latency */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
 			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
 			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
 		/* Set IFS0 */
-		if (hal->ah_turbo == true)
-			 ath5k_hw_reg_write(hal, ((AR5K_INIT_SIFS_TURBO +
-				(hal->ah_aifs + tq->tqi_aifs) *
+		if (hw->ah_turbo == true)
+			 ath5k_hw_reg_write(hw, ((AR5K_INIT_SIFS_TURBO +
+				(hw->ah_aifs + tq->tqi_aifs) *
 				AR5K_INIT_SLOT_TIME_TURBO) <<
 				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
 				AR5K_IFS0);
 		else
-			ath5k_hw_reg_write(hal, ((AR5K_INIT_SIFS +
-				(hal->ah_aifs + tq->tqi_aifs) *
+			ath5k_hw_reg_write(hw, ((AR5K_INIT_SIFS +
+				(hw->ah_aifs + tq->tqi_aifs) *
 				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
 				AR5K_INIT_SIFS, AR5K_IFS0);
 
 		/* Set IFS1 */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
 			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
 		/* Set PHY register 0x9844 (??) */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
-			(ath5k_hw_reg_read(hal, AR5K_PHY(17)) & ~0x7F) | 0x38 :
-			(ath5k_hw_reg_read(hal, AR5K_PHY(17)) & ~0x7F) | 0x1C,
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
+			(ath5k_hw_reg_read(hw, AR5K_PHY(17)) & ~0x7F) | 0x38 :
+			(ath5k_hw_reg_read(hw, AR5K_PHY(17)) & ~0x7F) | 0x1C,
 			AR5K_PHY(17));
 		/* Set Frame Control Register */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(hw, hw->ah_turbo == true ?
 			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
 			AR5K_PHY_TURBO_SHORT | 0x2020) :
 			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
@@ -3233,25 +3233,25 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	/*
 	 * Calculate cwmin/max by channel mode
 	 */
-	cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN;
-	cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX;
-	hal->ah_aifs = AR5K_TUNE_AIFS;
+	cw_min = hw->ah_cw_min = AR5K_TUNE_CWMIN;
+	cw_max = hw->ah_cw_max = AR5K_TUNE_CWMAX;
+	hw->ah_aifs = AR5K_TUNE_AIFS;
 	/*XR is only supported on 5212*/
-	if (IS_CHAN_XR(hal->ah_current_channel) &&
-			hal->ah_version == AR5K_AR5212) {
-		cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN_XR;
-		cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX_XR;
-		hal->ah_aifs = AR5K_TUNE_AIFS_XR;
+	if (IS_CHAN_XR(hw->ah_current_channel) &&
+			hw->ah_version == AR5K_AR5212) {
+		cw_min = hw->ah_cw_min = AR5K_TUNE_CWMIN_XR;
+		cw_max = hw->ah_cw_max = AR5K_TUNE_CWMAX_XR;
+		hw->ah_aifs = AR5K_TUNE_AIFS_XR;
 	/*B mode is not supported on 5210*/
-	} else if (IS_CHAN_B(hal->ah_current_channel) &&
-			hal->ah_version != AR5K_AR5210) {
-		cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN_11B;
-		cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX_11B;
-		hal->ah_aifs = AR5K_TUNE_AIFS_11B;
+	} else if (IS_CHAN_B(hw->ah_current_channel) &&
+			hw->ah_version != AR5K_AR5210) {
+		cw_min = hw->ah_cw_min = AR5K_TUNE_CWMIN_11B;
+		cw_max = hw->ah_cw_max = AR5K_TUNE_CWMAX_11B;
+		hw->ah_aifs = AR5K_TUNE_AIFS_11B;
 	}
 
 	cw_min = 1;
-	while (cw_min < hal->ah_cw_min)
+	while (cw_min < hw->ah_cw_min)
 		cw_min = (cw_min << 1) | 1;
 
 	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
@@ -3262,9 +3262,9 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	/*
 	 * Calculate and set retry limits
 	 */
-	if (hal->ah_software_retry == true) {
+	if (hw->ah_software_retry == true) {
 		/* XXX Need to test this */
-		retry_lg = hal->ah_limit_tx_retries;
+		retry_lg = hw->ah_limit_tx_retries;
 		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
 			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
 	} else {
@@ -3273,8 +3273,8 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	}
 
 	/*No QCU/DCU [5210]*/
-	if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(hal,
+	if (hw->ah_version == AR5K_AR5210) {
+		ath5k_hw_reg_write(hw,
 			(cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
 			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
 				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
@@ -3285,7 +3285,7 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 			AR5K_NODCU_RETRY_LMT);
 	} else {
 		/*QCU/DCU [5211+]*/
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
 				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
 			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
@@ -3300,57 +3300,57 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		 * Set initial content window (cw_min/cw_max)
 		 * and arbitrated interframe space (aifs)...
 		 */
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(hw,
 			AR5K_REG_SM(cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
 			AR5K_REG_SM(cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
-			AR5K_REG_SM(hal->ah_aifs + tq->tqi_aifs,
+			AR5K_REG_SM(hw->ah_aifs + tq->tqi_aifs,
 				AR5K_DCU_LCL_IFS_AIFS),
 			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
 
 		/*
 		 * Set misc registers
 		 */
-		ath5k_hw_reg_write(hal, AR5K_QCU_MISC_DCU_EARLY,
+		ath5k_hw_reg_write(hw, AR5K_QCU_MISC_DCU_EARLY,
 			AR5K_QUEUE_MISC(queue));
 
 		if (tq->tqi_cbr_period) {
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_cbr_period,
+			ath5k_hw_reg_write(hw, AR5K_REG_SM(tq->tqi_cbr_period,
 				AR5K_QCU_CBRCFG_INTVAL) |
 				AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
 				AR5K_QCU_CBRCFG_ORN_THRES),
 				AR5K_QUEUE_CBRCFG(queue));
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_CBR);
 			if (tq->tqi_cbr_overflow_limit)
-				AR5K_REG_ENABLE_BITS(hal,
+				AR5K_REG_ENABLE_BITS(hw,
 					AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_CBR_THRES_ENABLE);
 		}
 
 		if (tq->tqi_ready_time)
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_ready_time,
+			ath5k_hw_reg_write(hw, AR5K_REG_SM(tq->tqi_ready_time,
 				AR5K_QCU_RDYTIMECFG_INTVAL) |
 				AR5K_QCU_RDYTIMECFG_ENABLE,
 				AR5K_QUEUE_RDYTIMECFG(queue));
 
 		if (tq->tqi_burst_time) {
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_burst_time,
+			ath5k_hw_reg_write(hw, AR5K_REG_SM(tq->tqi_burst_time,
 				AR5K_DCU_CHAN_TIME_DUR) |
 				AR5K_DCU_CHAN_TIME_ENABLE,
 				AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
 
 			if (tq->tqi_flags & AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
-				AR5K_REG_ENABLE_BITS(hal,
+				AR5K_REG_ENABLE_BITS(hw,
 					AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_TXE);
 		}
 
 		if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
-			ath5k_hw_reg_write(hal, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
+			ath5k_hw_reg_write(hw, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
 				AR5K_QUEUE_DFS_MISC(queue));
 
 		if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
-			ath5k_hw_reg_write(hal, AR5K_DCU_MISC_BACKOFF_FRAG,
+			ath5k_hw_reg_write(hw, AR5K_DCU_MISC_BACKOFF_FRAG,
 				AR5K_QUEUE_DFS_MISC(queue));
 
 		/*
@@ -3358,18 +3358,18 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		 */
 		switch (tq->tqi_type) {
 		case AR5K_TX_QUEUE_BEACON:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_BCN |
 				AR5K_QCU_MISC_BCN_ENABLE);
 
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_DFS_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
 				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
 				AR5K_DCU_MISC_BCN_ENABLE);
 
-			ath5k_hw_reg_write(hal, ((AR5K_TUNE_BEACON_INTERVAL -
+			ath5k_hw_reg_write(hw, ((AR5K_TUNE_BEACON_INTERVAL -
 				(AR5K_TUNE_SW_BEACON_RESP -
 				AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
@@ -3378,18 +3378,18 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP |
 				AR5K_QCU_MISC_CBREXP_BCN);
 
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_DFS_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S));
 			break;
 
 		case AR5K_TX_QUEUE_UAPSD:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(hw, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_CBREXP);
 			break;
 
@@ -3401,13 +3401,13 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		/*
 		 * Enable tx queue in the secondary interrupt mask registers
 		 */
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(hw, AR5K_REG_SM(hw->ah_txq_interrupts,
 			AR5K_SIMR0_QCU_TXOK) |
-			AR5K_REG_SM(hal->ah_txq_interrupts,
+			AR5K_REG_SM(hw->ah_txq_interrupts,
 			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(hw, AR5K_REG_SM(hw->ah_txq_interrupts,
 			AR5K_SIMR1_QCU_TXERR), AR5K_SIMR1);
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(hw, AR5K_REG_SM(hw->ah_txq_interrupts,
 			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
 	}
 
@@ -3418,16 +3418,16 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
  * Get number of pending frames
  * for a specific queue [5211+]
  */
-u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
+u32 ath5k_hw_num_tx_pending(struct ath_hw *hw, unsigned int queue) {
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, hw->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (hw->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return false;
 
 	/* XXX: How about AR5K_CFG_TXCNT ? */
-	if (hal->ah_version == AR5K_AR5210)
+	if (hw->ah_version == AR5K_AR5210)
 		return false;
 
 	return AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT;
@@ -3436,17 +3436,17 @@ u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 /*
  * Set slot time
  */
-int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
+int ath5k_hw_set_slot_time(struct ath_hw *hw, unsigned int slot_time)
 {
 	AR5K_TRACE;
 	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, ath5k_hw_htoclock(slot_time,
-				hal->ah_turbo), AR5K_SLOT_TIME);
+	if (hw->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(hw, ath5k_hw_htoclock(slot_time,
+				hw->ah_turbo), AR5K_SLOT_TIME);
 	else
-		ath5k_hw_reg_write(hal, slot_time, AR5K_DCU_GBL_IFS_SLOT);
+		ath5k_hw_reg_write(hw, slot_time, AR5K_DCU_GBL_IFS_SLOT);
 
 	return 0;
 }
@@ -3454,14 +3454,14 @@ int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 /*
  * Get slot time
  */
-unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
+unsigned int ath5k_hw_get_slot_time(struct ath_hw *hw)
 {
 	AR5K_TRACE;
-	if (hal->ah_version == AR5K_AR5210)
-		return ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
-				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo);
+	if (hw->ah_version == AR5K_AR5210)
+		return ath5k_hw_clocktoh(ath5k_hw_reg_read(hw,
+				AR5K_SLOT_TIME) & 0xffff, hw->ah_turbo);
 	else
-		return ath5k_hw_reg_read(hal, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
+		return ath5k_hw_reg_read(hw, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
 }
 
 
@@ -3477,7 +3477,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
  * Initialize the 2-word tx descriptor on 5210/5211
  */
 static int
-ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
+ath5k_hw_setup_2word_tx_desc(struct ath_hw *hw, struct ath_desc *desc,
 	unsigned int pkt_len, unsigned int hdr_len, enum ath5k_pkt_type type,
 	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
 	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
@@ -3505,7 +3505,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	 * Verify header length
 	 * XXX: I only found that on 5210 code, does it work on 5211 ?
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		tx_desc->tx_control_0 = hdr_len &
 				AR5K_2W_TX_DESC_CTL0_HEADER_LEN;
 		if (tx_desc->tx_control_0 != hdr_len)
@@ -3513,7 +3513,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	}
 
 	/*Diferences between 5210-5211*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (hw->ah_version == AR5K_AR5210) {
 		switch (type) {
 		case AR5K_PKT_TYPE_BEACON:
 		case AR5K_PKT_TYPE_PROBE_RESP:
@@ -3561,7 +3561,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	/*
 	 * RTS/CTS Duration [5210 ?]
 	 */
-	if ((hal->ah_version == AR5K_AR5210) &&
+	if ((hw->ah_version == AR5K_AR5210) &&
 			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
 		tx_desc->tx_control_1 |= rtscts_duration &
 				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
@@ -3572,7 +3572,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Initialize the 4-word tx descriptor on 5212
  */
-static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *hal,
+static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *hw,
 	struct ath_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
 	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
 	unsigned int tx_tries0, unsigned int key_index,
@@ -3654,13 +3654,13 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *hal,
  * Initialize a 4-word XR tx descriptor on 5212
  */
 static bool
-ath5k_hw_setup_xr_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
+ath5k_hw_setup_xr_tx_desc(struct ath_hw *hw, struct ath_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
 	unsigned int tx_rate3, u_int tx_tries3)
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
 
-	if (hal->ah_version == AR5K_AR5212) {
+	if (hw->ah_version == AR5K_AR5212) {
 		tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
 
 #define _XTX_TRIES(_n)							\
@@ -3688,7 +3688,7 @@ ath5k_hw_setup_xr_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Fill the 2-word tx descriptor on 5210/5211
  */
-static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *hal,
+static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *hw,
 	struct ath_desc *desc, unsigned int segment_length,
 	bool first_segment, bool last_segment)
 {
@@ -3717,7 +3717,7 @@ static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *hal,
  * Fill the 4-word tx descriptor on 5212
  * XXX: Added an argument *last_desc -need revision
  */
-static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *hal,
+static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *hw,
 	struct ath_desc *desc, unsigned int segment_length,
 	bool first_segment, bool last_segment)
 {
@@ -3748,7 +3748,7 @@ static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *hal,
 /*
  * Proccess the tx status descriptor on 5210/5211
  */
-static int ath5k_hw_proc_2word_tx_status(struct ath_hw *hal,
+static int ath5k_hw_proc_2word_tx_status(struct ath_hw *hw,
 		struct ath_desc *desc)
 {
 	struct ath5k_hw_tx_status *tx_status;
@@ -3798,7 +3798,7 @@ static int ath5k_hw_proc_2word_tx_status(struct ath_hw *hal,
 /*
  * Proccess a tx descriptor on 5212
  */
-static int ath5k_hw_proc_4word_tx_status(struct ath_hw *hal,
+static int ath5k_hw_proc_4word_tx_status(struct ath_hw *hw,
 		struct ath_desc *desc)
 {
 	struct ath5k_hw_tx_status *tx_status;
@@ -3877,7 +3877,7 @@ static int ath5k_hw_proc_4word_tx_status(struct ath_hw *hal,
 /*
  * Initialize an rx descriptor
  */
-int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc,
+int ath5k_hw_setup_rx_desc(struct ath_hw *hw, struct ath_desc *desc,
 			u32 size, unsigned int flags)
 {
 	struct ath5k_rx_desc *rx_desc;
@@ -3912,7 +3912,7 @@ int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Proccess the rx status descriptor on 5210/5211
  */
-static int ath5k_hw_proc_old_rx_status(struct ath_hw *hal,
+static int ath5k_hw_proc_old_rx_status(struct ath_hw *hw,
 		struct ath_desc *desc)
 {
 	struct ath5k_hw_old_rx_status *rx_status;
@@ -3981,7 +3981,7 @@ static int ath5k_hw_proc_old_rx_status(struct ath_hw *hal,
 /*
  * Proccess the rx status descriptor on 5212
  */
-static int ath5k_hw_proc_new_rx_status(struct ath_hw *hal,
+static int ath5k_hw_proc_new_rx_status(struct ath_hw *hw,
 		struct ath_desc *desc)
 {
 	struct ath5k_hw_new_rx_status *rx_status;
@@ -4059,7 +4059,7 @@ static int ath5k_hw_proc_new_rx_status(struct ath_hw *hal,
 /*
  * Set led state
  */
-void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
+void ath5k_hw_set_ledstate(struct ath_hw *hw, unsigned int state)
 {
 	u32 led;
 	/*5210 has different led mode handling*/
@@ -4068,11 +4068,11 @@ void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
 	AR5K_TRACE;
 
 	/*Reset led status*/
-	if (hal->ah_version != AR5K_AR5210)
-		AR5K_REG_DISABLE_BITS(hal, AR5K_PCICFG,
+	if (hw->ah_version != AR5K_AR5210)
+		AR5K_REG_DISABLE_BITS(hw, AR5K_PCICFG,
 			AR5K_PCICFG_LEDMODE |  AR5K_PCICFG_LED);
 	else
-		AR5K_REG_DISABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_LED);
+		AR5K_REG_DISABLE_BITS(hw, AR5K_PCICFG, AR5K_PCICFG_LED);
 
 	/*
 	 * Some blinking values, define at your wish
@@ -4102,22 +4102,22 @@ void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
 	}
 
 	/*Write new status to the register*/
-	if (hal->ah_version != AR5K_AR5210)
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, led);
+	if (hw->ah_version != AR5K_AR5210)
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PCICFG, led);
 	else
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, led_5210);
+		AR5K_REG_ENABLE_BITS(hw, AR5K_PCICFG, led_5210);
 }
 
 /*
  * Set GPIO outputs
  */
-int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio)
+int ath5k_hw_set_gpio_output(struct ath_hw *hw, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &~
+	ath5k_hw_reg_write(hw, (ath5k_hw_reg_read(hw, AR5K_GPIOCR) &~
 		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_OUT(gpio), AR5K_GPIOCR);
 
 	return 0;
@@ -4126,13 +4126,13 @@ int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio)
 /*
  * Set GPIO inputs
  */
-int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio)
+int ath5k_hw_set_gpio_input(struct ath_hw *hw, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &~
+	ath5k_hw_reg_write(hw, (ath5k_hw_reg_read(hw, AR5K_GPIOCR) &~
 		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_IN(gpio), AR5K_GPIOCR);
 
 	return 0;
@@ -4141,21 +4141,21 @@ int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio)
 /*
  * Get GPIO state
  */
-u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio)
+u32 ath5k_hw_get_gpio(struct ath_hw *hw, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return 0xffffffff;
 
 	/* GPIO input magic */
-	return ((ath5k_hw_reg_read(hal, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
+	return ((ath5k_hw_reg_read(hw, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
 		0x1;
 }
 
 /*
  * Set GPIO state
  */
-int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
+int ath5k_hw_set_gpio(struct ath_hw *hw, u32 gpio, u32 val)
 {
 	u32 data;
 	AR5K_TRACE;
@@ -4164,12 +4164,12 @@ int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
 		return -EINVAL;
 
 	/* GPIO output magic */
-	data = ath5k_hw_reg_read(hal, AR5K_GPIODO);
+	data = ath5k_hw_reg_read(hw, AR5K_GPIODO);
 
 	data &= ~(1 << gpio);
 	data |= (val & 1) << gpio;
 
-	ath5k_hw_reg_write(hal, data, AR5K_GPIODO);
+	ath5k_hw_reg_write(hw, data, AR5K_GPIODO);
 
 	return 0;
 }
@@ -4177,7 +4177,7 @@ int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
 /*
  * Initialize the GPIO interrupt (RFKill switch)
  */
-void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
+void ath5k_hw_set_gpio_intr(struct ath_hw *hw, unsigned int gpio,
 		u32 interrupt_level)
 {
 	u32 data;
@@ -4189,18 +4189,18 @@ void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
 	/*
 	 * Set the GPIO interrupt
 	 */
-	data = (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &
+	data = (ath5k_hw_reg_read(hw, AR5K_GPIOCR) &
 		~(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_SELH |
 		AR5K_GPIOCR_INT_ENA | AR5K_GPIOCR_OUT(gpio))) |
 		(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_ENA);
 
-	ath5k_hw_reg_write(hal, interrupt_level ? data :
+	ath5k_hw_reg_write(hw, interrupt_level ? data :
 		(data | AR5K_GPIOCR_INT_SELH), AR5K_GPIOCR);
 
-	hal->ah_imr |= AR5K_IMR_GPIO;
+	hw->ah_imr |= AR5K_IMR_GPIO;
 
 	/* Enable GPIO interrupts */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PIMR, AR5K_IMR_GPIO);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PIMR, AR5K_IMR_GPIO);
 }
 
 
@@ -4208,7 +4208,7 @@ void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
  Regulatory Domain/Channels Setup
 \*********************************/
 
-u16 ath5k_get_regdomain(struct ath_hw *hal)
+u16 ath5k_get_regdomain(struct ath_hw *hw)
 {
 	u16 regdomain;
 	enum ath5k_regdom ieee_regdomain;
@@ -4216,8 +4216,8 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 	u16 code;
 #endif
 
-	ath5k_eeprom_regulation_domain(hal, false, &ieee_regdomain);
-	hal->ah_capabilities.cap_regdomain.reg_hw = ieee_regdomain;
+	ath5k_eeprom_regulation_domain(hw, false, &ieee_regdomain);
+	hw->ah_capabilities.cap_regdomain.reg_hw = ieee_regdomain;
 
 #ifdef COUNTRYCODE
 	/*
@@ -4229,7 +4229,7 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 #endif
 
 	regdomain = ath5k_regdom_from_ieee(ieee_regdomain);
-	hal->ah_capabilities.cap_regdomain.reg_current = regdomain;
+	hw->ah_capabilities.cap_regdomain.reg_current = regdomain;
 
 	return regdomain;
 }
@@ -4241,11 +4241,11 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 \****************/
 
 void /*O.K.*/
-ath5k_hw_dump_state(struct ath_hw *hal)
+ath5k_hw_dump_state(struct ath_hw *hw)
 {
 #ifdef AR5K_DEBUG
 #define AR5K_PRINT_REGISTER(_x)						\
-	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(hal, AR5K_##_x));
+	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(hw, AR5K_##_x));
 
 	AR5K_PRINT("MAC registers:\n");
 	AR5K_PRINT_REGISTER(CR);
@@ -4339,7 +4339,7 @@ ath5k_hw_dump_state(struct ath_hw *hal)
 #endif
 }
 
-int ath5k_hw_get_capability(struct ath_hw *hal,
+int ath5k_hw_get_capability(struct ath_hw *hw,
 		enum ath5k_capability_type cap_type,
 		u32 capability, u32 *result)
 {
@@ -4348,7 +4348,7 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	switch (cap_type) {
 	case AR5K_CAP_NUM_TXQUEUES:
 		if (result) {
-			if (hal->ah_version == AR5K_AR5210)
+			if (hw->ah_version == AR5K_AR5210)
 				*result = AR5K_NUM_TX_QUEUES_NOQCU;
 			else
 				*result = AR5K_NUM_TX_QUEUES;
@@ -4357,7 +4357,7 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	case AR5K_CAP_VEOL:
 		goto yes;
 	case AR5K_CAP_COMPRESSION:
-		if (hal->ah_version == AR5K_AR5212)
+		if (hw->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
@@ -4366,12 +4366,12 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	case AR5K_CAP_TPC:
 		goto yes;
 	case AR5K_CAP_BSSIDMASK:
-		if (hal->ah_version == AR5K_AR5212)
+		if (hw->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
 	case AR5K_CAP_XR:
-		if (hal->ah_version == AR5K_AR5212)
+		if (hw->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
@@ -4385,13 +4385,13 @@ yes:
 	return 0;
 }
 
-static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
+static int ath5k_hw_enable_pspoll(struct ath_hw *hw, u8 *bssid,
 		u16 assoc_id)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+	if (hw->ah_version == AR5K_AR5210) {
+		AR5K_REG_DISABLE_BITS(hw, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
 		return 0;
 	}
@@ -4399,12 +4399,12 @@ static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
 	return -EIO;
 }
 
-static int ath5k_hw_disable_pspoll(struct ath_hw *hal)
+static int ath5k_hw_disable_pspoll(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
+	if (hw->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(hw, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
index d48754c..103390a 100644
--- a/drivers/net/wireless/ath5k/hw.h
+++ b/drivers/net/wireless/ath5k/hw.h
@@ -284,7 +284,7 @@ struct ath5k_hw_2w_tx_desc {
 #define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_S	26
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT	(hw->ah_version == AR5K_AR5210 ? \
 						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210 : \
 						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211)
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
@@ -297,7 +297,7 @@ struct ath5k_hw_2w_tx_desc {
 #define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210	0x0007e000
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211	0x000fe000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	(hw->ah_version == AR5K_AR5210 ? \
 						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210 : \
 						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211)
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
@@ -427,9 +427,9 @@ struct ath5k_hw_tx_status {
 #define AR5K_INIT_CFG	0x00000000
 #endif
 
-/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(hal, _reg)
+/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(hw, _reg)
 
-#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(hal, _val, _reg)*/
+#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(hw, _val, _reg)*/
 
 #define AR5K_REG_SM(_val, _flags)					\
 	(((_val) << _flags##_S) & (_flags))
@@ -442,25 +442,25 @@ struct ath5k_hw_tx_status {
  * retrieve the values which we do not want to clear (lets call this
  * old_data) and then set the register with this and our new_value:
  * ( old_data | new_value) */
-#define AR5K_REG_WRITE_BITS(hal, _reg, _flags, _val)			\
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, _reg) & ~(_flags)) | \
+#define AR5K_REG_WRITE_BITS(hw, _reg, _flags, _val)			\
+	ath5k_hw_reg_write(hw, (ath5k_hw_reg_read(hw, _reg) & ~(_flags)) | \
 	    (((_val) << _flags##_S) & (_flags)), _reg)
 
-#define AR5K_REG_MASKED_BITS(hal, _reg, _flags, _mask)			\
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, _reg) &		\
+#define AR5K_REG_MASKED_BITS(hw, _reg, _flags, _mask)			\
+	ath5k_hw_reg_write(hw, (ath5k_hw_reg_read(hw, _reg) &		\
 			(_mask)) | (_flags), _reg)
 
-#define AR5K_REG_ENABLE_BITS(hal, _reg, _flags)				\
-	ath5k_hw_reg_write(hal, ath5k_hw_reg_read(hal, _reg) | (_flags), _reg)
+#define AR5K_REG_ENABLE_BITS(hw, _reg, _flags)				\
+	ath5k_hw_reg_write(hw, ath5k_hw_reg_read(hw, _reg) | (_flags), _reg)
 
-#define AR5K_REG_DISABLE_BITS(hal, _reg, _flags)			\
-	ath5k_hw_reg_write(hal, ath5k_hw_reg_read(hal, _reg) & ~(_flags), _reg)
+#define AR5K_REG_DISABLE_BITS(hw, _reg, _flags)			\
+	ath5k_hw_reg_write(hw, ath5k_hw_reg_read(hw, _reg) & ~(_flags), _reg)
 
-#define AR5K_PHY_WRITE(hal, _reg, _val)					\
-	ath5k_hw_reg_write(hal, _val, (hal)->ah_phy + ((_reg) << 2))
+#define AR5K_PHY_WRITE(hw, _reg, _val)					\
+	ath5k_hw_reg_write(hw, _val, (hw)->ah_phy + ((_reg) << 2))
 
-#define AR5K_PHY_READ(hal, _reg)					\
-	ath5k_hw_reg_read(hal, (hal)->ah_phy + ((_reg) << 2))
+#define AR5K_PHY_READ(hw, _reg)					\
+	ath5k_hw_reg_read(hw, (hw)->ah_phy + ((_reg) << 2))
 
 #define AR5K_REG_WAIT(_i) do {						\
 	if (_i % 64)							\
@@ -468,19 +468,19 @@ struct ath5k_hw_tx_status {
 } while (0)
 
 #define AR5K_EEPROM_READ(_o, _v) do {					\
-	if ((ret = ath5k_hw_eeprom_read(hal, (_o), &(_v))) != 0)	\
+	if ((ret = ath5k_hw_eeprom_read(hw, (_o), &(_v))) != 0)	\
 		return (ret);						\
 } while (0)
 
 #define AR5K_EEPROM_READ_HDR(_o, _v)					\
-	AR5K_EEPROM_READ(_o, hal->ah_capabilities.cap_eeprom._v);	\
+	AR5K_EEPROM_READ(_o, hw->ah_capabilities.cap_eeprom._v);	\
 
 /* Read status of selected queue */
-#define AR5K_REG_READ_Q(hal, _reg, _queue)				\
-	(ath5k_hw_reg_read(hal, _reg) & (1 << _queue))			\
+#define AR5K_REG_READ_Q(hw, _reg, _queue)				\
+	(ath5k_hw_reg_read(hw, _reg) & (1 << _queue))			\
 
-#define AR5K_REG_WRITE_Q(hal, _reg, _queue)				\
-	ath5k_hw_reg_write(hal, (1 << _queue), _reg)
+#define AR5K_REG_WRITE_Q(hw, _reg, _queue)				\
+	ath5k_hw_reg_write(hw, (1 << _queue), _reg)
 
 #define AR5K_Q_ENABLE_BITS(_reg, _queue) do {				\
 	_reg |= 1 << _queue;						\
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 11aeacc..870dc76 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -999,7 +999,7 @@ static const struct ath5k_ini rf5112_ini_bbgain[] = {
 /*
  * Write initial register dump
  */
-static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
+static void ath5k_hw_ini_registers(struct ath_hw *hw, unsigned int size,
 		const struct ath5k_ini *ini_regs, bool change_channel)
 {
 	unsigned int i;
@@ -1016,18 +1016,18 @@ static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
 		switch (ini_regs[i].ini_mode) {
 		case AR5K_INI_READ:
 			/* Cleared on read */
-			ath5k_hw_reg_read(hal, ini_regs[i].ini_register);
+			ath5k_hw_reg_read(hw, ini_regs[i].ini_register);
 			break;
 		case AR5K_INI_WRITE:
 		default:
 			AR5K_REG_WAIT(i);
-			ath5k_hw_reg_write(hal, ini_regs[i].ini_value,
+			ath5k_hw_reg_write(hw, ini_regs[i].ini_value,
 					ini_regs[i].ini_register);
 		}
 	}
 }
 
-static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
+static void ath5k_hw_ini_mode_registers(struct ath_hw *hw,
 		unsigned int size, const struct ath5k_ini_mode *ini_mode,
 		u8 mode)
 {
@@ -1035,33 +1035,33 @@ static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ini_mode[i].mode_value[mode],
+		ath5k_hw_reg_write(hw, ini_mode[i].mode_value[mode],
 			(u32)ini_mode[i].mode_register);
 	}
 
 }
 
-int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
+int ath5k_hw_write_initvals(struct ath_hw *hw, u8 mode, bool change_channel)
 {
 	/*
 	 * Write initial mode-specific settings
 	 */
 	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5212_ini_mode),
+	if (hw->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_mode_registers(hw, ARRAY_SIZE(ar5212_ini_mode),
 				ar5212_ini_mode, mode);
-		if (hal->ah_radio == AR5K_RF5111)
-			ath5k_hw_ini_mode_registers(hal,
+		if (hw->ah_radio == AR5K_RF5111)
+			ath5k_hw_ini_mode_registers(hw,
 					ARRAY_SIZE(ar5212_rf5111_ini_mode),
 					ar5212_rf5111_ini_mode, mode);
-		else if (hal->ah_radio == AR5K_RF5112)
-			ath5k_hw_ini_mode_registers(hal,
+		else if (hw->ah_radio == AR5K_RF5112)
+			ath5k_hw_ini_mode_registers(hw,
 					ARRAY_SIZE(ar5212_rf5112_ini_mode),
 					ar5212_rf5112_ini_mode, mode);
 	}
 	/*For 5211*/
-	if (hal->ah_version == AR5K_AR5211)
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5211_ini_mode),
+	if (hw->ah_version == AR5K_AR5211)
+		ath5k_hw_ini_mode_registers(hw, ARRAY_SIZE(ar5211_ini_mode),
 				ar5211_ini_mode, mode);
 	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
 
@@ -1069,32 +1069,32 @@ int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 	 * Write initial settings common for all modes
 	 */
 	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5212_ini),
+	if (hw->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_registers(hw, ARRAY_SIZE(ar5212_ini),
 				ar5212_ini, change_channel);
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5112,
+		if (hw->ah_radio == AR5K_RF5112) {
+			ath5k_hw_reg_write(hw, AR5K_PHY_PAPD_PROBE_INI_5112,
 					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
+			ath5k_hw_ini_registers(hw,
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
-		} else if (hal->ah_radio == AR5K_RF5111) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_GAIN_2GHZ_INI_5111,
+		} else if (hw->ah_radio == AR5K_RF5111) {
+			ath5k_hw_reg_write(hw, AR5K_PHY_GAIN_2GHZ_INI_5111,
 					AR5K_PHY_GAIN_2GHZ);
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5111,
+			ath5k_hw_reg_write(hw, AR5K_PHY_PAPD_PROBE_INI_5111,
 					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
+			ath5k_hw_ini_registers(hw,
 					ARRAY_SIZE(rf5111_ini_bbgain),
 					rf5111_ini_bbgain, change_channel);
 		}
-	} else if (hal->ah_version == AR5K_AR5211) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5211_ini),
+	} else if (hw->ah_version == AR5K_AR5211) {
+		ath5k_hw_ini_registers(hw, ARRAY_SIZE(ar5211_ini),
 				ar5211_ini, change_channel);
 		/* AR5211 only comes with 5111 */
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(rf5111_ini_bbgain),
+		ath5k_hw_ini_registers(hw, ARRAY_SIZE(rf5111_ini_bbgain),
 				rf5111_ini_bbgain, change_channel);
-	} else if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5210_ini),
+	} else if (hw->ah_version == AR5K_AR5210) {
+		ath5k_hw_ini_registers(hw, ARRAY_SIZE(ar5210_ini),
 				ar5210_ini, change_channel);
 	}
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 2b5f8fb..79b7b10 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -591,65 +591,65 @@ static unsigned int ath5k_hw_rfregs_op(u32 *rf, u32 offset, u32 reg, u32 bits,
 	return data;
 }
 
-static u32 ath5k_hw_rfregs_gainf_corr(struct ath_hw *hal)
+static u32 ath5k_hw_rfregs_gainf_corr(struct ath_hw *hw)
 {
 	u32 mix, step;
 	u32 *rf;
 
-	if (hal->ah_rf_banks == NULL)
+	if (hw->ah_rf_banks == NULL)
 		return 0;
 
-	rf = hal->ah_rf_banks;
-	hal->ah_gain.g_f_corr = 0;
+	rf = hw->ah_rf_banks;
+	hw->ah_gain.g_f_corr = 0;
 
-	if (ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0, false) != 1)
+	if (ath5k_hw_rfregs_op(rf, hw->ah_offset[7], 0, 1, 36, 0, false) != 1)
 		return 0;
 
-	step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 4, 32, 0, false);
-	mix = hal->ah_gain.g_step->gos_param[0];
+	step = ath5k_hw_rfregs_op(rf, hw->ah_offset[7], 0, 4, 32, 0, false);
+	mix = hw->ah_gain.g_step->gos_param[0];
 
 	switch (mix) {
 	case 3:
-		hal->ah_gain.g_f_corr = step * 2;
+		hw->ah_gain.g_f_corr = step * 2;
 		break;
 	case 2:
-		hal->ah_gain.g_f_corr = (step - 5) * 2;
+		hw->ah_gain.g_f_corr = (step - 5) * 2;
 		break;
 	case 1:
-		hal->ah_gain.g_f_corr = step;
+		hw->ah_gain.g_f_corr = step;
 		break;
 	default:
-		hal->ah_gain.g_f_corr = 0;
+		hw->ah_gain.g_f_corr = 0;
 		break;
 	}
 
-	return hal->ah_gain.g_f_corr;
+	return hw->ah_gain.g_f_corr;
 }
 
-static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
+static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hw)
 {
 	u32 step, mix, level[4];
 	u32 *rf;
 
-	if (hal->ah_rf_banks == NULL)
+	if (hw->ah_rf_banks == NULL)
 		return false;
 
-	rf = hal->ah_rf_banks;
+	rf = hw->ah_rf_banks;
 
-	if (hal->ah_radio == AR5K_RF5111) {
-		step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 6, 37, 0,
+	if (hw->ah_radio == AR5K_RF5111) {
+		step = ath5k_hw_rfregs_op(rf, hw->ah_offset[7], 0, 6, 37, 0,
 				false);
 		level[0] = 0;
 		level[1] = (step == 0x3f) ? 0x32 : step + 4;
 		level[2] = (step != 0x3f) ? 0x40 : level[0];
 		level[3] = level[2] + 0x32;
 
-		hal->ah_gain.g_high = level[3] -
+		hw->ah_gain.g_high = level[3] -
 			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_HI_MARGIN : -5);
-		hal->ah_gain.g_low = level[0] +
+		hw->ah_gain.g_low = level[0] +
 			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_LO_MARGIN : 0);
 	} else {
-		mix = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0,
+		mix = ath5k_hw_rfregs_op(rf, hw->ah_offset[7], 0, 1, 36, 0,
 				false);
 		level[0] = level[2] = 0;
 
@@ -657,22 +657,22 @@ static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
 			level[1] = level[3] = 83;
 		} else {
 			level[1] = level[3] = 107;
-			hal->ah_gain.g_high = 55;
+			hw->ah_gain.g_high = 55;
 		}
 	}
 
-	return (hal->ah_gain.g_current >= level[0] &&
-			hal->ah_gain.g_current <= level[1]) ||
-		(hal->ah_gain.g_current >= level[2] &&
-			hal->ah_gain.g_current <= level[3]);
+	return (hw->ah_gain.g_current >= level[0] &&
+			hw->ah_gain.g_current <= level[1]) ||
+		(hw->ah_gain.g_current >= level[2] &&
+			hw->ah_gain.g_current <= level[3]);
 }
 
-static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
+static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hw)
 {
 	const struct ath5k_gain_opt *go;
 	int ret = 0;
 
-	switch (hal->ah_radio) {
+	switch (hw->ah_radio) {
 	case AR5K_RF5111:
 		go = &rfgain_opt_5111;
 		break;
@@ -683,35 +683,35 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
 		return 0;
 	}
 
-	hal->ah_gain.g_step = &go->go_step[hal->ah_gain.g_step_idx];
+	hw->ah_gain.g_step = &go->go_step[hw->ah_gain.g_step_idx];
 
-	if (hal->ah_gain.g_current >= hal->ah_gain.g_high) {
-		if (hal->ah_gain.g_step_idx == 0)
+	if (hw->ah_gain.g_current >= hw->ah_gain.g_high) {
+		if (hw->ah_gain.g_step_idx == 0)
 			return -1;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target >=  hal->ah_gain.g_high &&
-				hal->ah_gain.g_step_idx > 0;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[--(hal->ah_gain.g_step_idx)].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
+		for (hw->ah_gain.g_target = hw->ah_gain.g_current;
+				hw->ah_gain.g_target >=  hw->ah_gain.g_high &&
+				hw->ah_gain.g_step_idx > 0;
+				hw->ah_gain.g_step =
+					&go->go_step[hw->ah_gain.g_step_idx])
+			hw->ah_gain.g_target -= 2 *
+			    (go->go_step[--(hw->ah_gain.g_step_idx)].gos_gain -
+			    hw->ah_gain.g_step->gos_gain);
 
 		ret = 1;
 		goto done;
 	}
 
-	if (hal->ah_gain.g_current <= hal->ah_gain.g_low) {
-		if (hal->ah_gain.g_step_idx == (go->go_steps_count - 1))
+	if (hw->ah_gain.g_current <= hw->ah_gain.g_low) {
+		if (hw->ah_gain.g_step_idx == (go->go_steps_count - 1))
 			return -2;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target <= hal->ah_gain.g_low &&
-				hal->ah_gain.g_step_idx < go->go_steps_count-1;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[++hal->ah_gain.g_step_idx].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
+		for (hw->ah_gain.g_target = hw->ah_gain.g_current;
+				hw->ah_gain.g_target <= hw->ah_gain.g_low &&
+				hw->ah_gain.g_step_idx < go->go_steps_count-1;
+				hw->ah_gain.g_step =
+					&go->go_step[hw->ah_gain.g_step_idx])
+			hw->ah_gain.g_target -= 2 *
+			    (go->go_step[++hw->ah_gain.g_step_idx].gos_gain -
+			    hw->ah_gain.g_step->gos_gain);
 
 		ret = 2;
 		goto done;
@@ -720,8 +720,8 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
 done:
 #ifdef AR5K_DEBUG
 	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
-		ret, hal->ah_gain.g_step_idx, hal->ah_gain.g_current,
-		hal->ah_gain.g_target);
+		ret, hw->ah_gain.g_step_idx, hw->ah_gain.g_current,
+		hw->ah_gain.g_target);
 #endif
 
 	return ret;
@@ -730,10 +730,10 @@ done:
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
  */
-static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
+static int ath5k_hw_rf5111_rfregs(struct ath_hw *hw,
 		struct ieee80211_channel *channel, unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	u32 *rf;
 	const unsigned int rf_size = ARRAY_SIZE(rfregs_5111);
 	unsigned int i;
@@ -742,7 +742,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 
 	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
 
-	rf = hal->ah_rf_banks;
+	rf = hw->ah_rf_banks;
 
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
@@ -753,7 +753,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 
 		if (bank != rfregs_5111[i].rf_bank) {
 			bank = rfregs_5111[i].rf_bank;
-			hal->ah_offset[bank] = i;
+			hw->ah_offset[bank] = i;
 		}
 
 		rf[i] = rfregs_5111[i].rf_value[mode];
@@ -767,11 +767,11 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		obdb = 0;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[0],
 				ee->ee_ob[ee_mode][obdb], 3, 119, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[0],
 				ee->ee_ob[ee_mode][obdb], 3, 122, 0, true))
 			return -EINVAL;
 
@@ -785,44 +785,44 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 			(channel->freq >= 5260 ? 1 :
 			 (channel->freq > 4000 ? 0 : -1)));
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_pwd_84, 1, 51, 3, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_pwd_90, 1, 45, 3, true))
 			return -EINVAL;
 	}
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 			!ee->ee_xpd[ee_mode], 1, 95, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 			ee->ee_x_gain[ee_mode], 4, 96, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6], obdb >= 0 ?
 			ee->ee_ob[ee_mode][obdb] : 0, 3, 104, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6], obdb >= 0 ?
 			ee->ee_db[ee_mode][obdb] : 0, 3, 107, 0, true))
 		return -EINVAL;
 
 	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[7],
 			ee->ee_i_gain[ee_mode], 6, 29, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[7],
 			ee->ee_xpd[ee_mode], 1, 4, 0, true))
 		return -EINVAL;
 
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, rf[i], rfregs_5111[i].rf_register);
+		ath5k_hw_reg_write(hw, rf[i], rfregs_5111[i].rf_register);
 	}
 
 	return 0;
@@ -831,11 +831,11 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
  */
-static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
+static int ath5k_hw_rf5112_rfregs(struct ath_hw *hw,
 		struct ieee80211_channel *channel, unsigned int mode)
 {
 	const struct ath5k_ini_rf *rf_ini;
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &hw->ah_capabilities.cap_eeprom;
 	u32 *rf;
 	unsigned int rf_size, i;
 	int obdb = -1, bank = -1;
@@ -843,9 +843,9 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 
 	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
 
-	rf = hal->ah_rf_banks;
+	rf = hw->ah_rf_banks;
 
-	if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
+	if (hw->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
 		rf_ini = rfregs_5112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 	} else {
@@ -862,7 +862,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 
 		if (bank != rf_ini[i].rf_bank) {
 			bank = rf_ini[i].rf_bank;
-			hal->ah_offset[bank] = i;
+			hw->ah_offset[bank] = i;
 		}
 
 		rf[i] = rf_ini[i].rf_value[mode];
@@ -876,11 +876,11 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		obdb = 0;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 287, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 290, 0, true))
 			return -EINVAL;
 	} else {
@@ -891,34 +891,34 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 			(channel->freq >= 5260 ? 1 :
 			    (channel->freq > 4000 ? 0 : -1)));
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 282, 0, true))
 			return -EINVAL;
 	}
 
 #ifdef notyet
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
 #endif
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[6],
 			ee->ee_xpd[ee_mode], 1, 302, 0, true))
 		return -EINVAL;
 
 	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, hw->ah_offset[7],
 			ee->ee_i_gain[ee_mode], 6, 14, 0, true))
 		return -EINVAL;
 
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++)
-		ath5k_hw_reg_write(hal, rf[i], rf_ini[i].rf_register);
+		ath5k_hw_reg_write(hw, rf[i], rf_ini[i].rf_register);
 
 	return 0;
 }
@@ -926,50 +926,50 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 /*
  * Initialize RF
  */
-int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel,
+int ath5k_hw_rfregs(struct ath_hw *hw, struct ieee80211_channel *channel,
 		unsigned int mode)
 {
 	int (*func)(struct ath_hw *, struct ieee80211_channel *, unsigned int);
 	int ret;
 
-	switch (hal->ah_radio) {
+	switch (hw->ah_radio) {
 	case AR5K_RF5111:
-		hal->ah_rf_banks_size = sizeof(rfregs_5111);
+		hw->ah_rf_banks_size = sizeof(rfregs_5111);
 		func = ath5k_hw_rf5111_rfregs;
 		break;
 	case AR5K_RF5112:
-		if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
-			hal->ah_rf_banks_size = sizeof(rfregs_5112a);
+		if (hw->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
+			hw->ah_rf_banks_size = sizeof(rfregs_5112a);
 		else
-			hal->ah_rf_banks_size = sizeof(rfregs_5112);
+			hw->ah_rf_banks_size = sizeof(rfregs_5112);
 		func = ath5k_hw_rf5112_rfregs;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (hal->ah_rf_banks == NULL) {
+	if (hw->ah_rf_banks == NULL) {
 		/* XXX do extra checks? */
-		hal->ah_rf_banks = kmalloc(hal->ah_rf_banks_size, GFP_KERNEL);
-		if (hal->ah_rf_banks == NULL) {
+		hw->ah_rf_banks = kmalloc(hw->ah_rf_banks_size, GFP_KERNEL);
+		if (hw->ah_rf_banks == NULL) {
 			AR5K_PRINT("out of memory\n");
 			return -ENOMEM;
 		}
 	}
 
-	ret = func(hal, channel, mode);
+	ret = func(hw, channel, mode);
 	if (!ret)
-		hal->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
+		hw->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
 
 	return ret;
 }
 
-int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
+int ath5k_hw_rfgain(struct ath_hw *hw, unsigned int freq)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
 	unsigned int i, size;
 
-	switch (hal->ah_radio) {
+	switch (hw->ah_radio) {
 	case AR5K_RF5111:
 		ath5k_rfg = rfgain_5111;
 		size = ARRAY_SIZE(rfgain_5111);
@@ -992,72 +992,72 @@ int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ath5k_rfg[i].rfg_value[freq],
+		ath5k_hw_reg_write(hw, ath5k_rfg[i].rfg_value[freq],
 			(u32)ath5k_rfg[i].rfg_register);
 	}
 
 	return 0;
 }
 
-enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal)
+enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hw)
 {
 	u32 data, type;
 
 	AR5K_TRACE;
 
-	if (hal->ah_rf_banks == NULL || !hal->ah_gain.g_active ||
-			hal->ah_version <= AR5K_AR5211)
+	if (hw->ah_rf_banks == NULL || !hw->ah_gain.g_active ||
+			hw->ah_version <= AR5K_AR5211)
 		return AR5K_RFGAIN_INACTIVE;
 
-	if (hal->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
+	if (hw->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
 		goto done;
 
-	data = ath5k_hw_reg_read(hal, AR5K_PHY_PAPD_PROBE);
+	data = ath5k_hw_reg_read(hw, AR5K_PHY_PAPD_PROBE);
 
 	if (!(data & AR5K_PHY_PAPD_PROBE_TX_NEXT)) {
-		hal->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
+		hw->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
 		type = AR5K_REG_MS(data, AR5K_PHY_PAPD_PROBE_TYPE);
 
 		if (type == AR5K_PHY_PAPD_PROBE_TYPE_CCK)
-			hal->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
+			hw->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
 
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_rfregs_gainf_corr(hal);
-			hal->ah_gain.g_current =
-				hal->ah_gain.g_current>=hal->ah_gain.g_f_corr ?
-				(hal->ah_gain.g_current-hal->ah_gain.g_f_corr) :
+		if (hw->ah_radio == AR5K_RF5112) {
+			ath5k_hw_rfregs_gainf_corr(hw);
+			hw->ah_gain.g_current =
+				hw->ah_gain.g_current>=hw->ah_gain.g_f_corr ?
+				(hw->ah_gain.g_current-hw->ah_gain.g_f_corr) :
 				0;
 		}
 
-		if (ath5k_hw_rfregs_gain_readback(hal) &&
-				AR5K_GAIN_CHECK_ADJUST(&hal->ah_gain) &&
-				ath5k_hw_rfregs_gain_adjust(hal))
-			hal->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
+		if (ath5k_hw_rfregs_gain_readback(hw) &&
+				AR5K_GAIN_CHECK_ADJUST(&hw->ah_gain) &&
+				ath5k_hw_rfregs_gain_adjust(hw))
+			hw->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
 	}
 
 done:
-	return hal->ah_rf_gain;
+	return hw->ah_rf_gain;
 }
 
-int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
+int ath5k_hw_set_rfgain_opt(struct ath_hw *hw)
 {
 	/* Initialize the gain optimization values */
-	switch (hal->ah_radio) {
+	switch (hw->ah_radio) {
 	case AR5K_RF5111:
-		hal->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
-		hal->ah_gain.g_step =
-		    &rfgain_opt_5111.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 35;
-		hal->ah_gain.g_active = 1;
+		hw->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
+		hw->ah_gain.g_step =
+		    &rfgain_opt_5111.go_step[hw->ah_gain.g_step_idx];
+		hw->ah_gain.g_low = 20;
+		hw->ah_gain.g_high = 35;
+		hw->ah_gain.g_active = 1;
 		break;
 	case AR5K_RF5112:
-		hal->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
-		hal->ah_gain.g_step =
-		    &rfgain_opt_5112.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 85;
-		hal->ah_gain.g_active = 1;
+		hw->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
+		hw->ah_gain.g_step =
+		    &rfgain_opt_5112.go_step[hw->ah_gain.g_step_idx];
+		hw->ah_gain.g_low = 20;
+		hw->ah_gain.g_high = 85;
+		hw->ah_gain.g_active = 1;
 		break;
 	default:
 		return -EINVAL;
@@ -1073,16 +1073,16 @@ int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
 /*
  * Check if a channel is supported
  */
-bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags)
+bool ath5k_channel_ok(struct ath_hw *hw, u16 freq, unsigned int flags)
 {
 	/* Check if the channel is in our supported range */
 	if (flags & CHANNEL_2GHZ) {
-		if ((freq >= hal->ah_capabilities.cap_range.range_2ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_2ghz_max))
+		if ((freq >= hw->ah_capabilities.cap_range.range_2ghz_min) &&
+		    (freq <= hw->ah_capabilities.cap_range.range_2ghz_max))
 			return true;
 	} else if (flags & CHANNEL_5GHZ)
-		if ((freq >= hal->ah_capabilities.cap_range.range_5ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_5ghz_max))
+		if ((freq >= hw->ah_capabilities.cap_range.range_5ghz_min) &&
+		    (freq <= hw->ah_capabilities.cap_range.range_5ghz_max))
 			return true;
 
 	return false;
@@ -1110,7 +1110,7 @@ static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 /*
  * Set channel on RF5110
  */
-static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5110_channel(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	u32 data;
@@ -1119,8 +1119,8 @@ static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
 	 * Set the channel and wait
 	 */
 	data = ath5k_hw_rf5110_chan2athchan(channel);
-	ath5k_hw_reg_write(hal, data, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, 0, AR5K_RF_BUFFER_CONTROL_0);
+	ath5k_hw_reg_write(hw, data, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(hw, 0, AR5K_RF_BUFFER_CONTROL_0);
 	mdelay(1);
 
 	return 0;
@@ -1158,7 +1158,7 @@ static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
 /*
  * Set channel on 5111
  */
-static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5111_channel(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	struct ath5k_athchan_2ghz ath_channel_2ghz;
@@ -1193,9 +1193,9 @@ static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
 			<< 2) | (clock << 1) | (1 << 10) | 1;
 	}
 
-	ath5k_hw_reg_write(hal, (data1 & 0xff) | ((data0 & 0xff) << 8),
+	ath5k_hw_reg_write(hw, (data1 & 0xff) | ((data0 & 0xff) << 8),
 			AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
+	ath5k_hw_reg_write(hw, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
 			AR5K_RF_BUFFER_CONTROL_3);
 
 	return 0;
@@ -1204,7 +1204,7 @@ static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
 /*
  * Set channel on 5112
  */
-static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5112_channel(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	u32 data, data0, data1, data2;
@@ -1243,8 +1243,8 @@ static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
 
 	data = (data0 << 4) | (data1 << 1) | (data2 << 2) | 0x1001;
 
-	ath5k_hw_reg_write(hal, data & 0xff, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
+	ath5k_hw_reg_write(hw, data & 0xff, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(hw, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
 
 	return 0;
 }
@@ -1252,7 +1252,7 @@ static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
 /*
  * Set a channel on the radio chip
  */
-int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
+int ath5k_hw_channel(struct ath_hw *hw, struct ieee80211_channel *channel)
 {
 	int ret;
 
@@ -1260,10 +1260,10 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
 	 * Check bounds supported by the PHY
 	 * (don't care about regulation restrictions at this point)
 	 */
-	if ((channel->freq < hal->ah_capabilities.cap_range.range_2ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_2ghz_max) &&
-	    (channel->freq < hal->ah_capabilities.cap_range.range_5ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_5ghz_max)) {
+	if ((channel->freq < hw->ah_capabilities.cap_range.range_2ghz_min ||
+	    channel->freq > hw->ah_capabilities.cap_range.range_2ghz_max) &&
+	    (channel->freq < hw->ah_capabilities.cap_range.range_5ghz_min ||
+	    channel->freq > hw->ah_capabilities.cap_range.range_5ghz_max)) {
 		AR5K_PRINTF("channel out of supported range (%u MHz)\n",
 			channel->freq);
 		return -EINVAL;
@@ -1272,24 +1272,24 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
 	/*
 	 * Set the channel and wait
 	 */
-	switch (hal->ah_radio) {
+	switch (hw->ah_radio) {
 	case AR5K_RF5110:
-		ret = ath5k_hw_rf5110_channel(hal, channel);
+		ret = ath5k_hw_rf5110_channel(hw, channel);
 		break;
 	case AR5K_RF5111:
-		ret = ath5k_hw_rf5111_channel(hal, channel);
+		ret = ath5k_hw_rf5111_channel(hw, channel);
 		break;
 	default:
-		ret = ath5k_hw_rf5112_channel(hal, channel);
+		ret = ath5k_hw_rf5112_channel(hw, channel);
 		break;
 	}
 
 	if (ret)
 		return ret;
 
-	hal->ah_current_channel.freq = channel->freq;
-	hal->ah_current_channel.val = channel->val;
-	hal->ah_turbo = channel->val == CHANNEL_T ? true : false;
+	hw->ah_current_channel.freq = channel->freq;
+	hw->ah_current_channel.val = channel->val;
+	hw->ah_turbo = channel->val == CHANNEL_T ? true : false;
 
 	return 0;
 }
@@ -1303,7 +1303,7 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
  * -Fix BPSK/QAM Constellation (I/Q correction)
  * -Calculate Noise Floor
  */
-static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
+static int ath5k_hw_rf5110_calibrate(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	u32 phy_sig, phy_agc, phy_sat, beacon, noise_floor;
@@ -1313,27 +1313,27 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Disable beacons and RX/TX queues, wait
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW_5210,
+	AR5K_REG_ENABLE_BITS(hw, AR5K_DIAG_SW_5210,
 		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	beacon = ath5k_hw_reg_read(hal, AR5K_BEACON_5210);
-	ath5k_hw_reg_write(hal, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
+	beacon = ath5k_hw_reg_read(hw, AR5K_BEACON_5210);
+	ath5k_hw_reg_write(hw, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
 	udelay(2300);
 
 	/*
 	 * Set the channel (with AGC turned off)
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 	udelay(10);
-	ret = ath5k_hw_channel(hal, channel);
+	ret = ath5k_hw_channel(hw, channel);
 
 	/*
 	 * Activate PHY and wait
 	 */
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(hw, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
 	mdelay(1);
 
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_DISABLE_BITS(hw, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
 	if (ret)
 		return ret;
@@ -1343,45 +1343,45 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	 */
 
 	/* Remember normal state */
-	phy_sig = ath5k_hw_reg_read(hal, AR5K_PHY_SIG);
-	phy_agc = ath5k_hw_reg_read(hal, AR5K_PHY_AGCCOARSE);
-	phy_sat = ath5k_hw_reg_read(hal, AR5K_PHY_ADCSAT);
+	phy_sig = ath5k_hw_reg_read(hw, AR5K_PHY_SIG);
+	phy_agc = ath5k_hw_reg_read(hw, AR5K_PHY_AGCCOARSE);
+	phy_sat = ath5k_hw_reg_read(hw, AR5K_PHY_ADCSAT);
 
 	/* Update radio registers */
-	ath5k_hw_reg_write(hal, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
+	ath5k_hw_reg_write(hw, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
 		AR5K_REG_SM(-1, AR5K_PHY_SIG_FIRPWR), AR5K_PHY_SIG);
 
-	ath5k_hw_reg_write(hal, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
+	ath5k_hw_reg_write(hw, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
 			AR5K_PHY_AGCCOARSE_LO)) |
 		AR5K_REG_SM(-1, AR5K_PHY_AGCCOARSE_HI) |
 		AR5K_REG_SM(-127, AR5K_PHY_AGCCOARSE_LO), AR5K_PHY_AGCCOARSE);
 
-	ath5k_hw_reg_write(hal, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
+	ath5k_hw_reg_write(hw, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
 			AR5K_PHY_ADCSAT_THR)) |
 		AR5K_REG_SM(2, AR5K_PHY_ADCSAT_ICNT) |
 		AR5K_REG_SM(12, AR5K_PHY_ADCSAT_THR), AR5K_PHY_ADCSAT);
 
 	udelay(20);
 
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 	udelay(10);
-	ath5k_hw_reg_write(hal, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	ath5k_hw_reg_write(hw, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
+	AR5K_REG_DISABLE_BITS(hw, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
 	mdelay(1);
 
 	/*
 	 * Enable calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	ret = ath5k_hw_register_timeout(hw, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false);
 
 	/* Reset to normal state */
-	ath5k_hw_reg_write(hal, phy_sig, AR5K_PHY_SIG);
-	ath5k_hw_reg_write(hal, phy_agc, AR5K_PHY_AGCCOARSE);
-	ath5k_hw_reg_write(hal, phy_sat, AR5K_PHY_ADCSAT);
+	ath5k_hw_reg_write(hw, phy_sig, AR5K_PHY_SIG);
+	ath5k_hw_reg_write(hw, phy_agc, AR5K_PHY_AGCCOARSE);
+	ath5k_hw_reg_write(hw, phy_sat, AR5K_PHY_ADCSAT);
 
 	if (ret) {
 		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
@@ -1391,9 +1391,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Enable noise floor calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	ret = ath5k_hw_register_timeout(hw, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false);
 	if (ret) {
 		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
@@ -1404,7 +1404,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/* Wait until the noise floor is calibrated */
 	for (i = 20; i > 0; i--) {
 		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
+		noise_floor = ath5k_hw_reg_read(hw, AR5K_PHY_NF);
 
 		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
 			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
@@ -1422,9 +1422,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Re-enable RX/TX and beacons
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW_5210,
+	AR5K_REG_DISABLE_BITS(hw, AR5K_DIAG_SW_5210,
 		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	ath5k_hw_reg_write(hal, beacon, AR5K_BEACON_5210);
+	ath5k_hw_reg_write(hw, beacon, AR5K_BEACON_5210);
 
 	return 0;
 }
@@ -1432,22 +1432,22 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 /*
  * Perform a PHY calibration on RF5111/5112
  */
-static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
+static int ath5k_hw_rf511x_calibrate(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
 	AR5K_TRACE;
 
-	if (hal->ah_calibration == false ||
-			ath5k_hw_reg_read(hal, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
+	if (hw->ah_calibration == false ||
+			ath5k_hw_reg_read(hw, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
 		goto done;
 
-	hal->ah_calibration = false;
+	hw->ah_calibration = false;
 
-	iq_corr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_CORR);
-	i_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_I);
-	q_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_Q);
+	iq_corr = ath5k_hw_reg_read(hw, AR5K_PHY_IQRES_CAL_CORR);
+	i_pwr = ath5k_hw_reg_read(hw, AR5K_PHY_IQRES_CAL_PWR_I);
+	q_pwr = ath5k_hw_reg_read(hw, AR5K_PHY_IQRES_CAL_PWR_Q);
 	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
 	q_coffd = q_pwr >> 6;
 
@@ -1458,19 +1458,19 @@ static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
 	q_coff = (((s32)i_pwr / q_coffd) - 64) & 0x1f;
 
 	/* Commit new IQ value */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
 		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 
 done:
 	/* Start noise floor calibration */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+	AR5K_REG_ENABLE_BITS(hw, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
 
 	/* Request RF gain */
 	if (channel->val & CHANNEL_5GHZ) {
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txpower.txp_max,
+		ath5k_hw_reg_write(hw, AR5K_REG_SM(hw->ah_txpower.txp_max,
 			AR5K_PHY_PAPD_PROBE_TXPOWER) |
 			AR5K_PHY_PAPD_PROBE_TX_NEXT, AR5K_PHY_PAPD_PROBE);
-		hal->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
+		hw->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
 	}
 
 	return 0;
@@ -1479,24 +1479,24 @@ done:
 /*
  * Perform a PHY calibration
  */
-int ath5k_hw_phy_calibrate(struct ath_hw *hal,
+int ath5k_hw_phy_calibrate(struct ath_hw *hw,
 		struct ieee80211_channel *channel)
 {
 	int ret;
 
-	if (hal->ah_radio == AR5K_RF5110)
-		ret = ath5k_hw_rf5110_calibrate(hal, channel);
+	if (hw->ah_radio == AR5K_RF5110)
+		ret = ath5k_hw_rf5110_calibrate(hw, channel);
 	else
-		ret = ath5k_hw_rf511x_calibrate(hal, channel);
+		ret = ath5k_hw_rf511x_calibrate(hw, channel);
 
 	return ret;
 }
 
-int ath5k_hw_phy_disable(struct ath_hw *hal)
+int ath5k_hw_phy_disable(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(hw, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 
 	return 0;
 }
@@ -1508,7 +1508,7 @@ int ath5k_hw_phy_disable(struct ath_hw *hal)
 /*
  * Get the PHY Chip revision
  */
-u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
+u16 ath5k_hw_radio_revision(struct ath_hw *hw, unsigned int chan)
 {
 	unsigned int i;
 	u32 srev;
@@ -1521,10 +1521,10 @@ u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
 	 */
 	switch (chan) {
 	case CHANNEL_2GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(hw, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
 		break;
 	case CHANNEL_5GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(hw, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 		break;
 	default:
 		return 0;
@@ -1533,41 +1533,41 @@ u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
 	mdelay(2);
 
 	/* ...wait until PHY is ready and read the selected radio revision */
-	ath5k_hw_reg_write(hal, 0x00001c16, AR5K_PHY(0x34));
+	ath5k_hw_reg_write(hw, 0x00001c16, AR5K_PHY(0x34));
 
 	for (i = 0; i < 8; i++)
-		ath5k_hw_reg_write(hal, 0x00010000, AR5K_PHY(0x20));
+		ath5k_hw_reg_write(hw, 0x00010000, AR5K_PHY(0x20));
 
-	if (hal->ah_version == AR5K_AR5210) {
-		srev = ath5k_hw_reg_read(hal, AR5K_PHY(256) >> 28) & 0xf;
+	if (hw->ah_version == AR5K_AR5210) {
+		srev = ath5k_hw_reg_read(hw, AR5K_PHY(256) >> 28) & 0xf;
 		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
 	} else {
-		srev = (ath5k_hw_reg_read(hal, AR5K_PHY(0x100)) >> 24) & 0xff;
+		srev = (ath5k_hw_reg_read(hw, AR5K_PHY(0x100)) >> 24) & 0xff;
 		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
 				((srev & 0x0f) << 4), 8);
 	}
 
 	/* Reset to the 5GHz mode */
-	ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+	ath5k_hw_reg_write(hw, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 
 	return ret;
 }
 
 void /*TODO:Boundary check*/
-ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant)
+ath5k_hw_set_def_antenna(struct ath_hw *hw, unsigned int ant)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(hal, ant, AR5K_DEFAULT_ANTENNA);
+	if (hw->ah_version != AR5K_AR5210)
+		ath5k_hw_reg_write(hw, ant, AR5K_DEFAULT_ANTENNA);
 }
 
-unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal)
+unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hw)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		return ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
+	if (hw->ah_version != AR5K_AR5210)
+		return ath5k_hw_reg_read(hw, AR5K_DEFAULT_ANTENNA);
 
 	return false; /*XXX: What do we return for 5210 ?*/
 }
@@ -1579,13 +1579,13 @@ unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal)
 /*
  * Initialize the tx power table (not fully implemented)
  */
-static void ath5k_txpower_table(struct ath_hw *hal,
+static void ath5k_txpower_table(struct ath_hw *hw,
 		struct ieee80211_channel *channel, s16 max_power)
 {
 	unsigned int i, min, max, n;
 	u16 txpower, *rates;
 
-	rates = hal->ah_txpower.txp_rates;
+	rates = hw->ah_txpower.txp_rates;
 
 	txpower = AR5K_TUNE_DEFAULT_TXPOWER * 2;
 	if (max_power > txpower)
@@ -1597,16 +1597,16 @@ static void ath5k_txpower_table(struct ath_hw *hal,
 
 	/* XXX setup target powers by rate */
 
-	hal->ah_txpower.txp_min = rates[7];
-	hal->ah_txpower.txp_max = rates[0];
-	hal->ah_txpower.txp_ofdm = rates[0];
+	hw->ah_txpower.txp_min = rates[7];
+	hw->ah_txpower.txp_max = rates[0];
+	hw->ah_txpower.txp_ofdm = rates[0];
 
 	/* Calculate the power table */
-	n = ARRAY_SIZE(hal->ah_txpower.txp_pcdac);
+	n = ARRAY_SIZE(hw->ah_txpower.txp_pcdac);
 	min = AR5K_EEPROM_PCDAC_START;
 	max = AR5K_EEPROM_PCDAC_STOP;
 	for (i = 0; i < n; i += AR5K_EEPROM_PCDAC_STEP)
-		hal->ah_txpower.txp_pcdac[i] =
+		hw->ah_txpower.txp_pcdac[i] =
 #ifdef notyet
 		min + ((i * (max - min)) / n);
 #else
@@ -1618,10 +1618,10 @@ static void ath5k_txpower_table(struct ath_hw *hal,
  * Set transmition power
  */
 int /*O.K. - txpower_table is unimplemented so this doesn't work*/
-ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
+ath5k_hw_txpower(struct ath_hw *hw, struct ieee80211_channel *channel,
 		unsigned int txpower)
 {
-	bool tpc = hal->ah_txpower.txp_tpc;
+	bool tpc = hw->ah_txpower.txp_tpc;
 	unsigned int i;
 
 	AR5K_TRACE;
@@ -1631,56 +1631,56 @@ ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
 	}
 
 	/* Reset TX power values */
-	memset(&hal->ah_txpower, 0, sizeof(hal->ah_txpower));
-	hal->ah_txpower.txp_tpc = tpc;
+	memset(&hw->ah_txpower, 0, sizeof(hw->ah_txpower));
+	hw->ah_txpower.txp_tpc = tpc;
 
 	/* Initialize TX power table */
-	ath5k_txpower_table(hal, channel, txpower);
+	ath5k_txpower_table(hw, channel, txpower);
 
 	/*
 	 * Write TX power values
 	 */
 	for (i = 0; i < (AR5K_EEPROM_POWER_TABLE_SIZE / 2); i++) {
-		ath5k_hw_reg_write(hal,
-			((((hal->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
-			(((hal->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
+		ath5k_hw_reg_write(hw,
+			((((hw->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
+			(((hw->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
 			AR5K_PHY_PCDAC_TXPOWER(i));
 	}
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(3, 24) |
+	ath5k_hw_reg_write(hw, AR5K_TXPOWER_OFDM(3, 24) |
 		AR5K_TXPOWER_OFDM(2, 16) | AR5K_TXPOWER_OFDM(1, 8) |
 		AR5K_TXPOWER_OFDM(0, 0), AR5K_PHY_TXPOWER_RATE1);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(7, 24) |
+	ath5k_hw_reg_write(hw, AR5K_TXPOWER_OFDM(7, 24) |
 		AR5K_TXPOWER_OFDM(6, 16) | AR5K_TXPOWER_OFDM(5, 8) |
 		AR5K_TXPOWER_OFDM(4, 0), AR5K_PHY_TXPOWER_RATE2);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(10, 24) |
+	ath5k_hw_reg_write(hw, AR5K_TXPOWER_CCK(10, 24) |
 		AR5K_TXPOWER_CCK(9, 16) | AR5K_TXPOWER_CCK(15, 8) |
 		AR5K_TXPOWER_CCK(8, 0), AR5K_PHY_TXPOWER_RATE3);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(14, 24) |
+	ath5k_hw_reg_write(hw, AR5K_TXPOWER_CCK(14, 24) |
 		AR5K_TXPOWER_CCK(13, 16) | AR5K_TXPOWER_CCK(12, 8) |
 		AR5K_TXPOWER_CCK(11, 0), AR5K_PHY_TXPOWER_RATE4);
 
-	if (hal->ah_txpower.txp_tpc == true)
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
+	if (hw->ah_txpower.txp_tpc == true)
+		ath5k_hw_reg_write(hw, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
 			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
 	else
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX |
+		ath5k_hw_reg_write(hw, AR5K_PHY_TXPOWER_RATE_MAX |
 			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
 
 	return 0;
 }
 
-int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power)
+int ath5k_hw_set_txpower_limit(struct ath_hw *hw, unsigned int power)
 {
 	/*Just a try M.F.*/
-	struct ieee80211_channel *channel = &hal->ah_current_channel;
+	struct ieee80211_channel *channel = &hw->ah_current_channel;
 
 	AR5K_TRACE;
 #ifdef AR5K_DEBUG
 	AR5K_PRINTF("changing txpower to %d\n", power);
 #endif
-	return ath5k_hw_txpower(hal, channel, power);
+	return ath5k_hw_txpower(hw, channel, power);
 }
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 1537517..83fc936 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -999,7 +999,7 @@
  */
 #define AR5K_EEPROM_DATA_5211	0x6004
 #define AR5K_EEPROM_DATA_5210	0x6800
-#define	AR5K_EEPROM_DATA	(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_EEPROM_DATA	(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_EEPROM_DATA_5210 : AR5K_EEPROM_DATA_5211)
 
 /*
@@ -1015,7 +1015,7 @@
  */
 #define AR5K_EEPROM_STAT_5210	0x6c00			/* Register Address [5210] */
 #define AR5K_EEPROM_STAT_5211	0x600c			/* Register Address [5211+] */
-#define	AR5K_EEPROM_STATUS	(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_EEPROM_STATUS	(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_EEPROM_STAT_5210 : AR5K_EEPROM_STAT_5211)
 #define AR5K_EEPROM_STAT_RDERR	0x00000001	/* EEPROM read failed */
 #define AR5K_EEPROM_STAT_RDDONE	0x00000002	/* EEPROM read successful */
@@ -1055,7 +1055,7 @@
 #define AR5K_STA_ID1_NO_PSPOLL		0x00100000	/* No power save polling [5210] */
 #define AR5K_STA_ID1_PCF_5211		0x00100000	/* Enable PCF on [5211+] */
 #define AR5K_STA_ID1_PCF_5210		0x00200000	/* Enable PCF on [5210]*/
-#define	AR5K_STA_ID1_PCF		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_STA_ID1_PCF		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_STA_ID1_PCF_5210 : AR5K_STA_ID1_PCF_5211)
 #define AR5K_STA_ID1_DEFAULT_ANTENNA	0x00200000	/* Use default antenna */
 #define AR5K_STA_ID1_DESC_ANTENNA	0x00400000	/* Update antenna from descriptor */
@@ -1100,7 +1100,7 @@
 #define AR5K_RSSI_THR_BMISS_5210_S	8
 #define AR5K_RSSI_THR_BMISS_5211	0x0000ff00	/* Mask for Beacon Missed threshold [5211+] */
 #define AR5K_RSSI_THR_BMISS_5211_S	8
-#define	AR5K_RSSI_THR_BMISS		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RSSI_THR_BMISS		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_RSSI_THR_BMISS_5210 : AR5K_RSSI_THR_BMISS_5211)
 #define	AR5K_RSSI_THR_BMISS_S		8
 
@@ -1108,7 +1108,7 @@
  * 5210 has more PCU registers because there is no QCU/DCU
  * so queue parameters are set here, this way a lot common
  * registers have different address for 5210. To make things
- * easier we define a macro based on hal->ah_version for common
+ * easier we define a macro based on hw->ah_version for common
  * registers with different addresses and common flags.
  */
 
@@ -1134,7 +1134,7 @@
  */
 #define AR5K_USEC_5210			0x8020			/* Register Address [5210] */
 #define AR5K_USEC_5211			0x801c			/* Register Address [5211+] */
-#define AR5K_USEC			(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_USEC			(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_USEC_5210 : AR5K_USEC_5211)
 #define AR5K_USEC_1			0x0000007f
 #define AR5K_USEC_1_S			0
@@ -1154,7 +1154,7 @@
  */
 #define AR5K_BEACON_5210	0x8024
 #define AR5K_BEACON_5211	0x8020
-#define AR5K_BEACON		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_BEACON		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_BEACON_5210 : AR5K_BEACON_5211)
 #define AR5K_BEACON_PERIOD	0x0000ffff
 #define AR5K_BEACON_PERIOD_S	0
@@ -1168,7 +1168,7 @@
  */
 #define AR5K_CFP_PERIOD_5210	0x8028
 #define AR5K_CFP_PERIOD_5211	0x8024
-#define AR5K_CFP_PERIOD		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_CFP_PERIOD		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_CFP_PERIOD_5210 : AR5K_CFP_PERIOD_5211)
 
 /*
@@ -1176,7 +1176,7 @@
  */
 #define AR5K_TIMER0_5210	0x802c
 #define AR5K_TIMER0_5211	0x8028
-#define AR5K_TIMER0		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER0		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER0_5210 : AR5K_TIMER0_5211)
 
 /*
@@ -1184,7 +1184,7 @@
  */
 #define AR5K_TIMER1_5210	0x8030
 #define AR5K_TIMER1_5211	0x802c
-#define AR5K_TIMER1		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER1		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER1_5210 : AR5K_TIMER1_5211)
 
 /*
@@ -1192,7 +1192,7 @@
  */
 #define AR5K_TIMER2_5210	0x8034
 #define AR5K_TIMER2_5211	0x8030
-#define AR5K_TIMER2		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER2		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER2_5210 : AR5K_TIMER2_5211)
 
 /*
@@ -1200,7 +1200,7 @@
  */
 #define AR5K_TIMER3_5210	0x8038
 #define AR5K_TIMER3_5211	0x8034
-#define AR5K_TIMER3		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER3		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER3_5210 : AR5K_TIMER3_5211)
 
 
@@ -1229,7 +1229,7 @@
  */
 #define AR5K_CFP_DUR_5210	0x8048
 #define AR5K_CFP_DUR_5211	0x8038
-#define AR5K_CFP_DUR		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_CFP_DUR		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_CFP_DUR_5210 : AR5K_CFP_DUR_5211)
 
 /*
@@ -1264,7 +1264,7 @@
  */
 #define AR5K_MCAST_FILTER0_5210	0x8050
 #define AR5K_MCAST_FILTER0_5211	0x8040
-#define AR5K_MCAST_FILTER0	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_MCAST_FILTER0	(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_MCAST_FILTER0_5210 : AR5K_MCAST_FILTER0_5211)
 
 /*
@@ -1272,7 +1272,7 @@
  */
 #define AR5K_MCAST_FILTER1_5210	0x8054
 #define AR5K_MCAST_FILTER1_5211	0x8044
-#define AR5K_MCAST_FILTER1	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_MCAST_FILTER1	(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_MCAST_FILTER1_5210 : AR5K_MCAST_FILTER1_5211)
 
 
@@ -1305,7 +1305,7 @@
  */
 #define AR5K_DIAG_SW_5210		0x8068			/* Register Address [5210] */
 #define AR5K_DIAG_SW_5211		0x8048			/* Register Address [5211+] */
-#define AR5K_DIAG_SW			(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW			(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_5210 : AR5K_DIAG_SW_5211)
 #define AR5K_DIAG_SW_DIS_WEP_ACK	0x00000001
 #define AR5K_DIAG_SW_DIS_ACK		0x00000002	/* Disable ACKs (?) */
@@ -1315,23 +1315,23 @@
 #define AR5K_DIAG_SW_DIS_TX		0x00000020	/* Disable transmit [5210] */
 #define AR5K_DIAG_SW_DIS_RX_5210	0x00000040	/* Disable recieve */
 #define AR5K_DIAG_SW_DIS_RX_5211	0x00000020
-#define	AR5K_DIAG_SW_DIS_RX		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_DIAG_SW_DIS_RX		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_DIS_RX_5210 : AR5K_DIAG_SW_DIS_RX_5211)
 #define AR5K_DIAG_SW_LOOP_BACK_5210	0x00000080	/* Loopback (i guess it goes with DIS_TX) [5210] */
 #define AR5K_DIAG_SW_LOOP_BACK_5211	0x00000040
-#define AR5K_DIAG_SW_LOOP_BACK		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_LOOP_BACK		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_LOOP_BACK_5210 : AR5K_DIAG_SW_LOOP_BACK_5211)
 #define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100
 #define AR5K_DIAG_SW_CORR_FCS_5211	0x00000080
-#define AR5K_DIAG_SW_CORR_FCS		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_CORR_FCS		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CORR_FCS_5210 : AR5K_DIAG_SW_CORR_FCS_5211)
 #define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200
 #define AR5K_DIAG_SW_CHAN_INFO_5211	0x00000100
-#define AR5K_DIAG_SW_CHAN_INFO		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_CHAN_INFO		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CHAN_INFO_5210 : AR5K_DIAG_SW_CHAN_INFO_5211)
 #define AR5K_DIAG_SW_EN_SCRAM_SEED_5211	0x00000200	/* Scrambler seed (?) */
 #define AR5K_DIAG_SW_EN_SCRAM_SEED_5210	0x00000400
-#define AR5K_DIAG_SW_EN_SCRAM_SEED	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_EN_SCRAM_SEED	(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_EN_SCRAM_SEED_5210 : AR5K_DIAG_SW_EN_SCRAM_SEED_5211)
 #define AR5K_DIAG_SW_ECO_ENABLE		0x00000400	/* [5211+] */
 #define AR5K_DIAG_SW_SCVRAM_SEED	0x0003f800	/* [5210] */
@@ -1340,7 +1340,7 @@
 #define AR5K_DIAG_SW_DIS_SEQ_INC	0x00040000	/* Disable seqnum increment (?)[5210] */
 #define AR5K_DIAG_SW_FRAME_NV0_5210	0x00080000
 #define AR5K_DIAG_SW_FRAME_NV0_5211	0x00020000
-#define	AR5K_DIAG_SW_FRAME_NV0		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_DIAG_SW_FRAME_NV0		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_FRAME_NV0_5210 : AR5K_DIAG_SW_FRAME_NV0_5211)
 #define AR5K_DIAG_SW_OBSPT_M		0x000c0000
 #define AR5K_DIAG_SW_OBSPT_S		18
@@ -1350,7 +1350,7 @@
  */
 #define AR5K_TSF_L32_5210	0x806c
 #define AR5K_TSF_L32_5211	0x804c
-#define	AR5K_TSF_L32		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_TSF_L32		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TSF_L32_5210 : AR5K_TSF_L32_5211)
 
 /*
@@ -1358,7 +1358,7 @@
  */
 #define AR5K_TSF_U32_5210	0x8070
 #define AR5K_TSF_U32_5211	0x8050
-#define	AR5K_TSF_U32		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_TSF_U32		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_TSF_U32_5210 : AR5K_TSF_U32_5211)
 
 /*
@@ -1400,7 +1400,7 @@
  */
 #define AR5K_NAV_5210		0x808c
 #define AR5K_NAV_5211		0x8084
-#define	AR5K_NAV		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_NAV		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_NAV_5210 : AR5K_NAV_5211)
 
 /*
@@ -1408,7 +1408,7 @@
  */
 #define AR5K_RTS_OK_5210	0x8090
 #define AR5K_RTS_OK_5211	0x8088
-#define	AR5K_RTS_OK		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RTS_OK		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_RTS_OK_5210 : AR5K_RTS_OK_5211)
 
 /*
@@ -1416,7 +1416,7 @@
  */
 #define AR5K_RTS_FAIL_5210	0x8094
 #define AR5K_RTS_FAIL_5211	0x808c
-#define	AR5K_RTS_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RTS_FAIL		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_RTS_FAIL_5210 : AR5K_RTS_FAIL_5211)
 
 /*
@@ -1424,7 +1424,7 @@
  */
 #define AR5K_ACK_FAIL_5210	0x8098
 #define AR5K_ACK_FAIL_5211	0x8090
-#define	AR5K_ACK_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_ACK_FAIL		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_ACK_FAIL_5210 : AR5K_ACK_FAIL_5211)
 
 /*
@@ -1432,7 +1432,7 @@
  */
 #define AR5K_FCS_FAIL_5210	0x809c
 #define AR5K_FCS_FAIL_5211	0x8094
-#define	AR5K_FCS_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_FCS_FAIL		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_FCS_FAIL_5210 : AR5K_FCS_FAIL_5211)
 
 /*
@@ -1440,7 +1440,7 @@
  */
 #define AR5K_BEACON_CNT_5210	0x80a0
 #define AR5K_BEACON_CNT_5211	0x8098
-#define	AR5K_BEACON_CNT		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_BEACON_CNT		(hw->ah_version == AR5K_AR5210 ? \
 				AR5K_BEACON_CNT_5210 : AR5K_BEACON_CNT_5211)
 
 
@@ -1576,7 +1576,7 @@
 #define AR5K_KEYTABLE_0_5211		0x8800
 #define AR5K_KEYTABLE_5210(_n)		(AR5K_KEYTABLE_0_5210 + ((_n) << 5))
 #define AR5K_KEYTABLE_5211(_n)		(AR5K_KEYTABLE_0_5211 + ((_n) << 5))
-#define	AR5K_KEYTABLE(_n)		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_KEYTABLE(_n)		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_KEYTABLE_5210(_n) : AR5K_KEYTABLE_5211(_n))
 #define AR5K_KEYTABLE_OFF(_n, x)	(AR5K_KEYTABLE(_n) + (x << 2))
 #define AR5K_KEYTABLE_TYPE(_n)		AR5K_KEYTABLE_OFF(_n, 5)
@@ -1606,7 +1606,7 @@
  */
 #define AR5K_KEYTABLE_SIZE_5210		64
 #define AR5K_KEYTABLE_SIZE_5211		128
-#define	AR5K_KEYTABLE_SIZE		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_KEYTABLE_SIZE		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211)
 
 
@@ -1722,11 +1722,11 @@
 #define	AR5K_PHY_PLL_20MHZ		0x13	/* For half rate (?) [5111+] */
 #define	AR5K_PHY_PLL_40MHZ_5211		0x18	/* For 802.11a */
 #define	AR5K_PHY_PLL_40MHZ_5212		0x000000aa
-#define	AR5K_PHY_PLL_40MHZ		(hal->ah_version == AR5K_AR5211 ? \
+#define	AR5K_PHY_PLL_40MHZ		(hw->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_40MHZ_5211 : AR5K_PHY_PLL_40MHZ_5212)
 #define	AR5K_PHY_PLL_44MHZ_5211		0x19	/* For 802.11b/g */
 #define	AR5K_PHY_PLL_44MHZ_5212		0x000000ab
-#define	AR5K_PHY_PLL_44MHZ		(hal->ah_version == AR5K_AR5211 ? \
+#define	AR5K_PHY_PLL_44MHZ		(hw->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_44MHZ_5211 : AR5K_PHY_PLL_44MHZ_5212)
 #define AR5K_PHY_PLL_RF5111		0x00000000
 #define AR5K_PHY_PLL_RF5112		0x00000040
@@ -1845,7 +1845,7 @@
  */
 #define	AR5K_PHY_FRAME_CTL_5210		0x9804
 #define	AR5K_PHY_FRAME_CTL_5211		0x9944
-#define	AR5K_PHY_FRAME_CTL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_PHY_FRAME_CTL		(hw->ah_version == AR5K_AR5210 ? \
 					AR5K_PHY_FRAME_CTL_5210 : AR5K_PHY_FRAME_CTL_5211)
 /*---[5111+]---*/
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP	0x00000038
-- 
1.5.3.4

