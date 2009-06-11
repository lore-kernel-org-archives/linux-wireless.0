Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2100 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956AbZFKCXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:23:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] ath5k: cleanup ath5k_hw struct
Date: Wed, 10 Jun 2009 22:22:20 -0400
Message-Id: <1244686941-29223-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah_gpios array isn't used, and ah_current_channel can be a pointer
instead of an embedded struct.  Removing these and some other
write-only variables, and moving some things around for better
packing and cache utilization saves 116 bytes.

   text	   data	    bss	    dec	    hex	filename
 121762	    472	     64	 122298	  1ddba	ath5k_before.ko
 121646	    472	     64	 122182	  1dd46	ath5k.ko

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   21 +++++++--------------
 drivers/net/wireless/ath/ath5k/phy.c   |    7 +++----
 drivers/net/wireless/ath/ath5k/reset.c |    1 -
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6358233..9137511 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -713,8 +713,8 @@ struct ath5k_gain {
  * Used internaly for reset_tx_queue).
  * Also see struct struct ieee80211_channel.
  */
-#define IS_CHAN_XR(_c)	((_c.hw_value & CHANNEL_XR) != 0)
-#define IS_CHAN_B(_c)	((_c.hw_value & CHANNEL_B) != 0)
+#define IS_CHAN_XR(_c)	((_c->hw_value & CHANNEL_XR) != 0)
+#define IS_CHAN_B(_c)	((_c->hw_value & CHANNEL_B) != 0)
 
 /*
  * The following structure is used to map 2GHz channels to
@@ -1029,14 +1029,15 @@ struct ath5k_hw {
 	enum ath5k_int		ah_imr;
 
 	enum nl80211_iftype	ah_op_mode;
-	enum ath5k_power_mode	ah_power_mode;
-	struct ieee80211_channel ah_current_channel;
+	struct ieee80211_channel *ah_current_channel;
 	bool			ah_turbo;
 	bool			ah_calibration;
-	bool			ah_running;
 	bool			ah_single_chip;
 	bool			ah_combined_mic;
 
+	enum ath5k_version	ah_version;
+	enum ath5k_radio	ah_radio;
+	u32			ah_phy;
 	u32			ah_mac_srev;
 	u16			ah_mac_version;
 	u16			ah_mac_revision;
@@ -1044,13 +1045,6 @@ struct ath5k_hw {
 	u16			ah_radio_5ghz_revision;
 	u16			ah_radio_2ghz_revision;
 
-	enum ath5k_version	ah_version;
-	enum ath5k_radio	ah_radio;
-	u32			ah_phy;
-
-	bool			ah_5ghz;
-	bool			ah_2ghz;
-
 #define ah_modes		ah_capabilities.cap_mode
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version
 
@@ -1058,7 +1052,6 @@ struct ath5k_hw {
 	u32			ah_aifs;
 	u32			ah_cw_min;
 	u32			ah_cw_max;
-	bool			ah_software_retry;
 	u32			ah_limit_tx_retries;
 
 	/* Antenna Control */
@@ -1066,6 +1059,7 @@ struct ath5k_hw {
 	u8			ah_ant_mode;
 	u8			ah_tx_ant;
 	u8			ah_def_ant;
+	bool			ah_software_retry;
 
 	u8			ah_sta_id[ETH_ALEN];
 
@@ -1075,7 +1069,6 @@ struct ath5k_hw {
 	u8			ah_bssid[ETH_ALEN];
 	u8			ah_bssid_mask[ETH_ALEN];
 
-	u32			ah_gpio[AR5K_MAX_GPIO];
 	int			ah_gpio_npins;
 
 	struct ath_regulatory	ah_regulatory;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index a876ca8..2075ba9 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1085,8 +1085,7 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 				AR5K_PHY_CCKTXCTL_WORLD);
 	}
 
-	ah->ah_current_channel.center_freq = channel->center_freq;
-	ah->ah_current_channel.hw_value = channel->hw_value;
+	ah->ah_current_channel = channel;
 	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;
 
 	return 0;
@@ -1731,7 +1730,7 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
 void
 ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 {
-	struct ieee80211_channel *channel = &ah->ah_current_channel;
+	struct ieee80211_channel *channel = ah->ah_current_channel;
 	bool use_def_for_tx, update_def_on_tx, use_def_for_rts, fast_div;
 	bool use_def_for_sg;
 	u8 def_ant, tx_ant, ee_mode;
@@ -3011,7 +3010,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 {
 	/*Just a try M.F.*/
-	struct ieee80211_channel *channel = &ah->ah_current_channel;
+	struct ieee80211_channel *channel = ah->ah_current_channel;
 	u8 ee_mode;
 
 	ATH5K_TRACE(ah->ah_sc);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 8077f0a..e6db425 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -291,7 +291,6 @@ int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 	}
 
 commit:
-	ah->ah_power_mode = mode;
 	ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);
 
 	return 0;
-- 
1.6.0.6


