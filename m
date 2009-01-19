Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZASX2S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/15] iwlwifi: remove unused or twice defined members in iwl_priv
Date: Mon, 19 Jan 2009 15:30:29 -0800
Message-Id: <1232407835-19451-10-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002831_439053_4D06EA3C)
In-Reply-To: <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes user_txpower_limit and max_channel_txpower_limit
and use tx_power_user_lmt and tx_power_channel_lmt instead
call_post_assoc_from_beacon is not used

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 -----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++--------
 5 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1f3305b..fe907f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1675,7 +1675,7 @@ static void iwl3945_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_in
 	/* further limit to user's max power preference.
 	 * FIXME:  Other spectrum management power limitations do not
 	 *   seem to apply?? */
-	power = min(power, priv->user_txpower_limit);
+	power = min(power, priv->tx_power_user_lmt);
 	scan_power_info->requested_power = power;
 
 	/* find difference between new scan *power* and current "normal"
@@ -1947,14 +1947,14 @@ int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 	u8 a_band;
 	u8 i;
 
-	if (priv->user_txpower_limit == power) {
+	if (priv->tx_power_user_lmt == power) {
 		IWL_DEBUG_POWER("Requested Tx power same as current "
 				"limit: %ddBm.\n", power);
 		return 0;
 	}
 
 	IWL_DEBUG_POWER("Setting upper limit clamp to %ddBm.\n", power);
-	priv->user_txpower_limit = power;
+	priv->tx_power_user_lmt = power;
 
 	/* set up new Tx powers for each and every channel, 2.4 and 5.x */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 31315de..b2985e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1306,7 +1306,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	s32 factory_actual_pwr[2];
 	s32 power_index;
 
-	/* user_txpower_limit is in dBm, convert to half-dBm (half-dB units
+	/* tx_power_user_lmt is in dBm, convert to half-dBm (half-dB units
 	 *   are used for indexing into txpower table) */
 	user_target_power = 2 * priv->tx_power_user_lmt;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5b5e011..75ef8d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1068,9 +1068,6 @@ struct iwl_priv {
 
 	/*For 3945*/
 #define IWL_DEFAULT_TX_POWER 0x0F
-	s8 user_txpower_limit;
-	s8 max_channel_txpower_limit;
-
 	/* We declare this const so it can only be
 	 * changed via explicit cast within the
 	 * routines that actually update the physical
@@ -1088,8 +1085,6 @@ struct iwl_priv {
 	struct iwl3945_eeprom eeprom39;
 
 	u32 sta_supp_rates;
-	u8 call_post_assoc_from_beacon;
-
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index c8afcd1..cebfb8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -520,7 +520,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 					     flags & EEPROM_CHANNEL_RADAR))
 				       ? "" : "not ");
 
-			/* Set the user_txpower_limit to the highest power
+			/* Set the tx_power_user_lmt to the highest power
 			 * supported by any channel */
 			if (eeprom_ch_info[ch].max_power_avg >
 						priv->tx_power_user_lmt)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 47436ad..a986a5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3943,11 +3943,11 @@ static int iwl3945_init_channel_map(struct iwl_priv *priv)
 					     flags & EEPROM_CHANNEL_RADAR))
 				       ? "" : "not ");
 
-			/* Set the user_txpower_limit to the highest power
+			/* Set the tx_power_user_lmt to the highest power
 			 * supported by any channel */
 			if (eeprom_ch_info[ch].max_power_avg >
-			    priv->user_txpower_limit)
-				priv->user_txpower_limit =
+			    priv->tx_power_user_lmt)
+				priv->tx_power_user_lmt =
 				    eeprom_ch_info[ch].max_power_avg;
 
 			ch_info++;
@@ -4222,8 +4222,8 @@ static int iwl3945_init_geos(struct iwl_priv *priv)
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
 				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
-			if (ch->max_power_avg > priv->max_channel_txpower_limit)
-				priv->max_channel_txpower_limit =
+			if (ch->max_power_avg > priv->tx_power_channel_lmt)
+				priv->tx_power_channel_lmt =
 				    ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
@@ -6301,7 +6301,6 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
 	priv->assoc_capability = 0;
-	priv->call_post_assoc_from_beacon = 0;
 
 	/* new association get rid of ibss beacon skb */
 	if (priv->ibss_beacon)
@@ -6445,7 +6444,7 @@ static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	return sprintf(buf, "%d\n", priv->user_txpower_limit);
+	return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
 }
 
 static ssize_t store_tx_power(struct device *d,
@@ -6968,7 +6967,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL39_POWER_AC;
-	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 
 	ret = iwl3945_init_channel_map(priv);
 	if (ret) {
-- 
1.5.4.3

