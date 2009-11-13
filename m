Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbZKMT4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/16] iwlwifi: eliminate the possible 1/2 dBm tx power loss in 6x00 & 6x50 series
Date: Fri, 13 Nov 2009 11:56:30 -0800
Message-Id: <1258142198-3223-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In both 6x00 and 6x50 series, the enhanced/extended tx power table in
EEPROM is used to set the max. tx power limit.
This new tx power table is in 1/2 dBm format, which creates an issue of
possibility of 1/2 dBm loss when driver set the tx power limit; because
of driver keep track and report the tx power in dBm format.

In order to prevent the 1/2 dBm loss, keep track of the true max tx
power in 1/2 dBm format in driver; do the comparison and adjust the tx
power if needed when send tx power command to uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   16 +++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   49 ++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e23d301..60b1a7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1251,6 +1251,22 @@ int  iwl5000_send_tx_power(struct iwl_priv *priv)
 
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
+
+	if (priv->tx_power_lmt_in_half_dbm &&
+	    priv->tx_power_lmt_in_half_dbm < tx_power_cmd.global_lmt) {
+		/*
+		 * For the newer devices which using enhanced/extend tx power
+		 * table in EEPROM, the format is in half dBm. driver need to
+		 * convert to dBm format before report to mac80211.
+		 * By doing so, there is a possibility of 1/2 dBm resolution
+		 * lost. driver will perform "round-up" operation before
+		 * reporting, but it will cause 1/2 dBm tx power over the
+		 * regulatory limit. Perform the checking here, if the
+		 * "tx_power_user_lmt" is higher than EEPROM value (in
+		 * half-dBm format), lower the tx power based on EEPROM
+		 */
+		tx_power_cmd.global_lmt = priv->tx_power_lmt_in_half_dbm;
+	}
 	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 774a315..a474383 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1247,6 +1247,7 @@ struct iwl_priv {
 	/* TX Power */
 	s8 tx_power_user_lmt;
 	s8 tx_power_device_lmt;
+	s8 tx_power_lmt_in_half_dbm; /* max tx power in half-dBm format */
 
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index e42eb64..ac88ff0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -762,7 +762,8 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
  *     find the highest tx power from all chains for the channel
  */
 static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower, int element)
+		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
+		int element, s8 *max_txpower_in_half_dbm)
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
@@ -794,10 +795,14 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].mimo3_max;
 
-	/* max. tx power in EEPROM is in 1/2 dBm format
-	 * convert from 1/2 dBm to dBm
+	/*
+	 * max. tx power in EEPROM is in 1/2 dBm format
+	 * convert from 1/2 dBm to dBm (round-up convert)
+	 * but we also do not want to loss 1/2 dBm resolution which
+	 * will impact performance
 	 */
-	return max_txpower_avg >> 1;
+	*max_txpower_in_half_dbm = max_txpower_avg;
+	return (max_txpower_avg & 0x01) + (max_txpower_avg >> 1);
 }
 
 /**
@@ -806,7 +811,7 @@ static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
  */
 static s8 iwl_update_common_txpower(struct iwl_priv *priv,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int section, int element)
+		int section, int element, s8 *max_txpower_in_half_dbm)
 {
 	struct iwl_channel_info *ch_info;
 	int ch;
@@ -820,20 +825,22 @@ static s8 iwl_update_common_txpower(struct iwl_priv *priv,
 	if (element == EEPROM_TXPOWER_COMMON_HT40_INDEX)
 		is_ht40 = true;
 	max_txpower_avg =
-		iwl_get_max_txpower_avg(priv, enhanced_txpower, element);
+		iwl_get_max_txpower_avg(priv, enhanced_txpower,
+					element, max_txpower_in_half_dbm);
+
 	ch_info = priv->channel_info;
 
 	for (ch = 0; ch < priv->channel_count; ch++) {
 		/* find matching band and update tx power if needed */
 		if ((ch_info->band == enhinfo[section].band) &&
-		    (ch_info->max_power_avg < max_txpower_avg) && (!is_ht40)) {
+		    (ch_info->max_power_avg < max_txpower_avg) &&
+		    (!is_ht40)) {
 			/* Update regulatory-based run-time data */
 			ch_info->max_power_avg = ch_info->curr_txpow =
-			    max_txpower_avg;
+				max_txpower_avg;
 			ch_info->scan_power = max_txpower_avg;
 		}
 		if ((ch_info->band == enhinfo[section].band) && is_ht40 &&
-		    ch_info->ht40_max_power_avg &&
 		    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
 			/* Update regulatory-based run-time data */
 			ch_info->ht40_max_power_avg = max_txpower_avg;
@@ -849,7 +856,7 @@ static s8 iwl_update_common_txpower(struct iwl_priv *priv,
  */
 static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int section, int element)
+		int section, int element, s8 *max_txpower_in_half_dbm)
 {
 	struct iwl_channel_info *ch_info;
 	int ch;
@@ -858,7 +865,8 @@ static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
 
 	channel = enhinfo[section].iwl_eeprom_section_channel[element];
 	max_txpower_avg =
-		iwl_get_max_txpower_avg(priv, enhanced_txpower, element);
+		iwl_get_max_txpower_avg(priv, enhanced_txpower,
+					element, max_txpower_in_half_dbm);
 
 	ch_info = priv->channel_info;
 	for (ch = 0; ch < priv->channel_count; ch++) {
@@ -872,7 +880,6 @@ static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
 				ch_info->scan_power = max_txpower_avg;
 			}
 			if ((enhinfo[section].is_ht40) &&
-			    (ch_info->ht40_max_power_avg) &&
 			    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
 				/* Update regulatory-based run-time data */
 				ch_info->ht40_max_power_avg = max_txpower_avg;
@@ -894,6 +901,7 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 	struct iwl_eeprom_enhanced_txpwr *enhanced_txpower;
 	u32 offset;
 	s8 max_txpower_avg; /* (dBm) */
+	s8 max_txpower_in_half_dbm; /* (half-dBm) */
 
 	/* Loop through all the sections
 	 * adjust bands and channel's max tx power
@@ -920,16 +928,29 @@ void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv)
 			if (enhinfo[section].is_common)
 				max_txpower_avg =
 					iwl_update_common_txpower(priv,
-					enhanced_txpower, section, element);
+						enhanced_txpower, section,
+						element,
+						&max_txpower_in_half_dbm);
 			else
 				max_txpower_avg =
 					iwl_update_channel_txpower(priv,
-					enhanced_txpower, section, element);
+						enhanced_txpower, section,
+						element,
+						&max_txpower_in_half_dbm);
 
 			/* Update the tx_power_user_lmt to the highest power
 			 * supported by any channel */
 			if (max_txpower_avg > priv->tx_power_user_lmt)
 				priv->tx_power_user_lmt = max_txpower_avg;
+
+			/*
+			 * Update the tx_power_lmt_in_half_dbm to
+			 * the highest power supported by any channel
+			 */
+			if (max_txpower_in_half_dbm >
+			    priv->tx_power_lmt_in_half_dbm)
+				priv->tx_power_lmt_in_half_dbm =
+					max_txpower_in_half_dbm;
 		}
 	}
 }
-- 
1.5.6.3

