Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60369 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0BSB2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 20:28:36 -0500
Subject: [PATCH 2/3] ath5k: remove useless "extern" from function
 declarations
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 18 Feb 2010 20:28:23 -0500
Message-ID: <20100219012823.12460.41391.stgit@mj.roinet.com>
In-Reply-To: <20100219012802.12460.42239.stgit@mj.roinet.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust formatting of the affected lines to satisfy checkpatch.pl.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |  181 +++++++++++++++++---------------
 1 files changed, 95 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 9e4ea19..f4e50ef 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1158,67 +1158,69 @@ struct ath5k_hw {
  */
 
 /* Attach/Detach Functions */
-extern int ath5k_hw_attach(struct ath5k_softc *sc);
-extern void ath5k_hw_detach(struct ath5k_hw *ah);
+int ath5k_hw_attach(struct ath5k_softc *sc);
+void ath5k_hw_detach(struct ath5k_hw *ah);
 
 /* LED functions */
-extern int ath5k_init_leds(struct ath5k_softc *sc);
-extern void ath5k_led_enable(struct ath5k_softc *sc);
-extern void ath5k_led_off(struct ath5k_softc *sc);
-extern void ath5k_unregister_leds(struct ath5k_softc *sc);
+int ath5k_init_leds(struct ath5k_softc *sc);
+void ath5k_led_enable(struct ath5k_softc *sc);
+void ath5k_led_off(struct ath5k_softc *sc);
+void ath5k_unregister_leds(struct ath5k_softc *sc);
 
 /* Reset Functions */
-extern int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
-extern int ath5k_hw_on_hold(struct ath5k_hw *ah);
-extern int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode, struct ieee80211_channel *channel, bool change_channel);
+int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
+int ath5k_hw_on_hold(struct ath5k_hw *ah);
+int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
+		   struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
 
 /* DMA Related Functions */
-extern void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
-extern int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
-extern u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah);
-extern void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
-extern int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
-extern u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue,
+void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
+int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
+u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah);
+void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
+int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue);
+int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
+u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue);
+int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue,
 				u32 phys_addr);
-extern int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase);
+int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase);
 /* Interrupt handling */
-extern bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
-extern int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
-extern enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum
-ath5k_int new_mask);
-extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ieee80211_low_level_stats *stats);
+bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
+int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
+enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask);
+void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
+				  struct ieee80211_low_level_stats *stats);
 
 /* EEPROM access functions */
-extern int ath5k_eeprom_init(struct ath5k_hw *ah);
-extern void ath5k_eeprom_detach(struct ath5k_hw *ah);
-extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
+int ath5k_eeprom_init(struct ath5k_hw *ah);
+void ath5k_eeprom_detach(struct ath5k_hw *ah);
+int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 
 /* Protocol Control Unit Functions */
-extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
-extern void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
+int ath5k_hw_set_opmode(struct ath5k_hw *ah);
+void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* BSSID Functions */
-extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
-extern void ath5k_hw_set_associd(struct ath5k_hw *ah);
-extern void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
+int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
+void ath5k_hw_set_associd(struct ath5k_hw *ah);
+void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
-extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
-extern void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
+void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
+void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
 /* RX Filter functions */
-extern void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
-extern u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
-extern void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
+void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
+u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
+void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
 /* Beacon control functions */
-extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
-extern void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
-extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
-extern void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
+u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
+void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
+void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
+void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
 #if 0
-extern int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah, const struct ath5k_beacon_state *state);
-extern void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
-extern int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr);
+int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
+			       const struct ath5k_beacon_state *state);
+void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
+int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr);
 #endif
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
@@ -1227,73 +1229,80 @@ unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
 unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
 unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah);
 /* Key table (WEP) functions */
-extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
-extern int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
-extern int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
+int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
+int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
+		     const struct ieee80211_key_conf *key, const u8 *mac);
+int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
 
 /* Queue Control Unit, DFS Control Unit Functions */
-extern int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue, struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
-				const struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
-				enum ath5k_tx_queue queue_type,
-				struct ath5k_txq_info *queue_info);
-extern u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
-extern void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
-extern int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
+int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
+			       struct ath5k_txq_info *queue_info);
+int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
+			       const struct ath5k_txq_info *queue_info);
+int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
+			    enum ath5k_tx_queue queue_type,
+			    struct ath5k_txq_info *queue_info);
+u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
+void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
+int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
+int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
 
 /* Hardware Descriptor Functions */
-extern int ath5k_hw_init_desc_functions(struct ath5k_hw *ah);
+int ath5k_hw_init_desc_functions(struct ath5k_hw *ah);
 
 /* GPIO Functions */
-extern void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
-extern int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
-extern int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio);
-extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
-extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
-extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
+void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
+int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
+int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio);
+u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
+int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
+void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
+			    u32 interrupt_level);
 
 /* rfkill Functions */
-extern void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
-extern void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
+void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
+void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
 
 /* Misc functions */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
-extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
-extern int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid, u16 assoc_id);
-extern int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
+int ath5k_hw_get_capability(struct ath5k_hw *ah,
+			    enum ath5k_capability_type cap_type, u32 capability,
+			    u32 *result);
+int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid, u16 assoc_id);
+int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
 
 /* Initial register settings functions */
-extern int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
+int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
 
 /* Initialize RF */
-extern int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
-				struct ieee80211_channel *channel,
-				unsigned int mode);
-extern int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq);
-extern enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah);
-extern int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah);
+int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
+			 struct ieee80211_channel *channel,
+			 unsigned int mode);
+int ath5k_hw_rfgain_init(struct ath5k_hw *ah, unsigned int freq);
+enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah);
+int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah);
 /* PHY/RF channel functions */
-extern bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
-extern int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
+bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
+int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 /* PHY calibration */
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
-extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel *channel);
-extern void ath5k_hw_calibration_poll(struct ath5k_hw *ah);
+int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
+			   struct ieee80211_channel *channel);
+void ath5k_hw_calibration_poll(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
-				struct ieee80211_channel *channel);
+				  struct ieee80211_channel *channel);
 void ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
-				struct ieee80211_channel *channel);
+					 struct ieee80211_channel *channel);
 /* Misc PHY functions */
-extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
-extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
+int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Antenna control */
-extern void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
+void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
 /* TX power setup */
-extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, u8 ee_mode, u8 txpower);
-extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
+int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
+		     u8 ee_mode, u8 txpower);
+int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
 
 /*
  * Functions used internaly
