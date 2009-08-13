Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbZHMUbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwlwifi: configure HT40 channels in iwl_mac_config
Date: Thu, 13 Aug 2009 13:30:57 -0700
Message-Id: <1250195462-15811-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

As indicated by note in iwl_ht_conf, some HT parameters are set on association
(e.g., channel width) and some vary over time (HT protection mode) and per
station (e.g., short GI support).  The global parameters should be set in
iwl_mac_config and the local/varying parameters in iwl_ht_conf.

This patch moves the channel width configuration from iwl_ht_conf to
iwl_mac_config, and defers further cleanup of the local/global conflation for a
later patch.

This fixes a bug in using HT40 channels in some modes.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   46 +++++++++++++++++--------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 08345b9..104fd95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2398,25 +2398,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 
 	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
 
-	iwl_conf->supported_chan_width =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
-	/*
-	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
-	 *	to be done there correctly.
-	 */
-
-	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-	if (conf_is_ht40_minus(&priv->hw->conf))
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-	else if (conf_is_ht40_plus(&priv->hw->conf))
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-
-	/* If no above or below channel supplied disable HT40 channel */
-	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
-	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		iwl_conf->supported_chan_width = 0;
-
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
@@ -2733,6 +2714,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = hw->priv;
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct iwl_ht_info *ht_conf = &priv->current_ht_config;
 	unsigned long flags = 0;
 	int ret = 0;
 	u16 ch;
@@ -2774,10 +2756,32 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto set_ch_out;
 		}
 
-		priv->current_ht_config.is_ht = conf_is_ht(conf);
-
 		spin_lock_irqsave(&priv->lock, flags);
 
+		/* Configure HT40 channels */
+		ht_conf->is_ht = conf_is_ht(conf);
+		if (ht_conf->is_ht) {
+			if (conf_is_ht40_minus(conf)) {
+				ht_conf->extension_chan_offset =
+					IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+				ht_conf->supported_chan_width =
+					IWL_CHANNEL_WIDTH_40MHZ;
+			} else if (conf_is_ht40_plus(conf)) {
+				ht_conf->extension_chan_offset =
+					IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+				ht_conf->supported_chan_width =
+					IWL_CHANNEL_WIDTH_40MHZ;
+			} else {
+				ht_conf->extension_chan_offset =
+					IEEE80211_HT_PARAM_CHA_SEC_NONE;
+				ht_conf->supported_chan_width =
+					IWL_CHANNEL_WIDTH_20MHZ;
+			}
+		} else
+			ht_conf->supported_chan_width = IWL_CHANNEL_WIDTH_20MHZ;
+		/* Default to no protection. Protection mode will later be set
+		 * from BSS config in iwl_ht_conf */
+		ht_conf->ht_protection = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
 		/* if we are switching from ht to 2.4 clear flags
 		 * from any ht related info since 2.4 does not
-- 
1.5.6.3

