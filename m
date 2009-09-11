Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbZIKRiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/13] iwlwifi: clean up ht config a little
Date: Fri, 11 Sep 2009 10:38:13 -0700
Message-Id: <1252690699-25796-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

is_ht can be bool instead of u8, and there's
no need to use IWL_CHANNEL_WIDTH_* constants
in supported_chan_width when that could just
be named is_40mhz instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   14 +++++---------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    7 ++-----
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index acfd7b4..7c50065 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -636,8 +636,7 @@ u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 {
 	struct iwl_ht_info *iwl_ht_conf = &priv->current_ht_config;
 
-	if ((!iwl_ht_conf->is_ht) ||
-	    (iwl_ht_conf->supported_chan_width != IWL_CHANNEL_WIDTH_40MHZ))
+	if (!iwl_ht_conf->is_ht || !iwl_ht_conf->is_40mhz)
 		return 0;
 
 	/* We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
@@ -2799,21 +2798,18 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			if (conf_is_ht40_minus(conf)) {
 				ht_conf->extension_chan_offset =
 					IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-				ht_conf->supported_chan_width =
-					IWL_CHANNEL_WIDTH_40MHZ;
+				ht_conf->is_40mhz = true;
 			} else if (conf_is_ht40_plus(conf)) {
 				ht_conf->extension_chan_offset =
 					IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-				ht_conf->supported_chan_width =
-					IWL_CHANNEL_WIDTH_40MHZ;
+				ht_conf->is_40mhz = true;
 			} else {
 				ht_conf->extension_chan_offset =
 					IEEE80211_HT_PARAM_CHA_SEC_NONE;
-				ht_conf->supported_chan_width =
-					IWL_CHANNEL_WIDTH_20MHZ;
+				ht_conf->is_40mhz = false;
 			}
 		} else
-			ht_conf->supported_chan_width = IWL_CHANNEL_WIDTH_20MHZ;
+			ht_conf->is_40mhz = false;
 		/* Default to no protection. Protection mode will later be set
 		 * from BSS config in iwl_ht_conf */
 		ht_conf->ht_protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 028d505..961d534 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -504,8 +504,8 @@ union iwl_ht_rate_supp {
 
 struct iwl_ht_info {
 	/* self configuration data */
-	u8 is_ht;
-	u8 supported_chan_width;
+	bool is_ht;
+	bool is_40mhz;
 	u8 sm_ps;
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
@@ -726,9 +726,6 @@ struct iwl_dma_ptr {
 	size_t size;
 };
 
-#define IWL_CHANNEL_WIDTH_20MHZ   0
-#define IWL_CHANNEL_WIDTH_40MHZ   1
-
 #define IWL_OPERATION_MODE_AUTO     0
 #define IWL_OPERATION_MODE_HT_ONLY  1
 #define IWL_OPERATION_MODE_MIXED    2
-- 
1.5.6.3

