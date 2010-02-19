Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab0BSB2S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 20:28:18 -0500
Subject: [PATCH 1/3] ath5k: remove stale function declarations,
 make some functions static
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 18 Feb 2010 20:28:02 -0500
Message-ID: <20100219012802.12460.42239.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all unnecessary function declarations from ath5k.h.  Comment out
unused functions.  Remove ath5k_hw_get_tsf32(), which is too trivial to
be commented out.  Make functions static if suggested by sparse.  Make
ath5k_pm_ops static.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   16 ----------------
 drivers/net/wireless/ath/ath5k/base.c  |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c   |   29 ++++++++++++-----------------
 drivers/net/wireless/ath/ath5k/phy.c   |    6 ++++--
 drivers/net/wireless/ath/ath5k/qcu.c   |    2 ++
 drivers/net/wireless/ath/ath5k/reset.c |    4 ++--
 6 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ac67f02..9e4ea19 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1172,7 +1172,6 @@ extern int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
 extern int ath5k_hw_on_hold(struct ath5k_hw *ah);
 extern int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
-extern int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
 
 /* DMA Related Functions */
 extern void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
@@ -1196,7 +1195,6 @@ extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ieee80211_l
 extern int ath5k_eeprom_init(struct ath5k_hw *ah);
 extern void ath5k_eeprom_detach(struct ath5k_hw *ah);
 extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
-extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 
 /* Protocol Control Unit Functions */
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
@@ -1210,12 +1208,9 @@ extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
 extern void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
 /* RX Filter functions */
 extern void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
-extern int ath5k_hw_set_mcast_filter_idx(struct ath5k_hw *ah, u32 index);
-extern int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index);
 extern u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
 extern void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
 /* Beacon control functions */
-extern u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah);
 extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 extern void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
@@ -1227,18 +1222,12 @@ extern int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
 #endif
 /* ACK bit rate */
 void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
-/* ACK/CTS Timeouts */
-extern int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout);
-extern unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah);
-extern int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout);
-extern unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah);
 /* Clock rate related functions */
 unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
 unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
 unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah);
 /* Key table (WEP) functions */
 extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
-extern int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry);
 extern int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
 extern int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
 
@@ -1252,7 +1241,6 @@ extern int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
 extern u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 extern void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 extern int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
-extern unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah);
 extern int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
 
 /* Hardware Descriptor Functions */
@@ -1292,8 +1280,6 @@ extern int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *chann
 /* PHY calibration */
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
 extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel *channel);
-extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
-extern s16 ath5k_hw_get_noise_floor(struct ath5k_hw *ah);
 extern void ath5k_hw_calibration_poll(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
@@ -1305,8 +1291,6 @@ extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
 extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Antenna control */
 extern void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
-extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant);
-extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
 /* TX power setup */
 extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, u8 ee_mode, u8 txpower);
 extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2468c64..6baf00e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -198,7 +198,7 @@ static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
 static int		ath5k_pci_suspend(struct device *dev);
 static int		ath5k_pci_resume(struct device *dev);
 
-SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
+static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
 #define ATH5K_PM_OPS	(&ath5k_pm_ops)
 #else
 #define ATH5K_PM_OPS	NULL
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index aefe84f..be69ebb 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -178,6 +178,7 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
 * ACK/CTS Timeouts *
 \******************/
 
+#if 0
 /**
  * ath5k_hw_het_ack_timeout - Get ACK timeout from PCU in usec
  *
@@ -190,6 +191,7 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
 			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK));
 }
+#endif
 
 /**
  * ath5k_hw_set_ack_timeout - Set ACK timeout on PCU
@@ -197,7 +199,7 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
  * @ah: The &struct ath5k_hw
  * @timeout: Timeout in usec
  */
-int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
+static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK))
@@ -210,6 +212,7 @@ int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 	return 0;
 }
 
+#if 0
 /**
  * ath5k_hw_get_cts_timeout - Get CTS timeout from PCU in usec
  *
@@ -221,6 +224,7 @@ unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 	return ath5k_hw_clocktoh(ah, AR5K_REG_MS(ath5k_hw_reg_read(ah,
 			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS));
 }
+#endif
 
 /**
  * ath5k_hw_set_cts_timeout - Set CTS timeout on PCU
@@ -228,7 +232,7 @@ unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
  * @ah: The &struct ath5k_hw
  * @timeout: Timeout in usec
  */
-int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
+static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS))
@@ -290,7 +294,7 @@ unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah)
  *
  * @ah: The &struct ath5k_hw
  */
-unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
+static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 
@@ -308,7 +312,7 @@ unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
  *
  * @ah: The &struct ath5k_hw
  */
-unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
+static unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 
@@ -451,6 +455,7 @@ void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
 }
 
+#if 0
 /*
  * Set multicast filter by index
  */
@@ -486,6 +491,7 @@ int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
 
 	return 0;
 }
+#endif
 
 /**
  * ath5k_hw_get_rx_filter - Get current rx filter
@@ -572,19 +578,6 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 \****************/
 
 /**
- * ath5k_hw_get_tsf32 - Get a 32bit TSF
- *
- * @ah: The &struct ath5k_hw
- *
- * Returns lower 32 bits of current TSF
- */
-u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
-{
-	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_reg_read(ah, AR5K_TSF_L32);
-}
-
-/**
  * ath5k_hw_get_tsf64 - Get the full 64bit TSF
  *
  * @ah: The &struct ath5k_hw
@@ -971,6 +964,7 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 	return 0;
 }
 
+#if 0
 /*
  * Check if a table entry is valid
  */
@@ -983,6 +977,7 @@ int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
 	return ath5k_hw_reg_read(ah, AR5K_KEYTABLE_MAC1(entry)) &
 		AR5K_KEYTABLE_VALID;
 }
+#endif
 
 static
 int ath5k_keycache_type(const struct ieee80211_key_conf *key)
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 72474c0..ac2a57a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1190,7 +1190,7 @@ static s16 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
  * The median of the values in the history is then loaded into the
  * hardware for its own use for RSSI and CCA measurements.
  */
-void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
+static void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 val;
@@ -1767,7 +1767,7 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 * Antenna control *
 \*****************/
 
-void /*TODO:Boundary check*/
+static void /*TODO:Boundary check*/
 ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 {
 	ATH5K_TRACE(ah->ah_sc);
@@ -1776,6 +1776,7 @@ ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 		ath5k_hw_reg_write(ah, ant & 0x7, AR5K_DEFAULT_ANTENNA);
 }
 
+#if 0
 unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
@@ -1785,6 +1786,7 @@ unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
 
 	return false; /*XXX: What do we return for 5210 ?*/
 }
+#endif
 
 /*
  * Enable/disable fast rx antenna diversity
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 9122a85..d9cab7c 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -516,6 +516,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	return 0;
 }
 
+#if 0
 /*
  * Get slot time from DCU
  */
@@ -532,6 +533,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 
 	return ath5k_hw_clocktoh(ah, slot_time_clock & 0xffff);
 }
+#endif
 
 /*
  * Set slot time on DCU
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index a35a7db..8decf21 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -221,8 +221,8 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 /*
  * Sleep control
  */
-int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
-		bool set_chip, u16 sleep_duration)
+static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
+			      bool set_chip, u16 sleep_duration)
 {
 	unsigned int i;
 	u32 staid, data;
