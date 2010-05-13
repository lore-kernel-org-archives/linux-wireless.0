Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0EMVuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/17] iwlwifi: use proper short slot/preamble settings
Date: Thu, 13 May 2010 14:49:57 -0700
Message-Id: <1273787399-9280-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The short preamble setting might change on the
fly, and then we already use the right mac80211
variable. However, in other places we don't,
which is especially wrong in the AP code since
in that case the assoc_capability is invalid.
Also, the IBSS special case is not needed since
"use_short_slot" will be properly cleared, but
the "assoc_capability" might be invalid (which
must be the reason for the special case).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 ++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 ++++-------------
 3 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5bfa7b3..eb74f28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2860,20 +2860,16 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
-	if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+	if (vif->bss_conf.use_short_preamble)
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-		if (vif->bss_conf.assoc_capability &
-					WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif->bss_conf.use_short_slot)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		if (vif->type == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
 	iwlcore_commit_rxon(priv);
@@ -3099,8 +3095,7 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		priv->staging_rxon.assoc_id = 0;
 
-		if (vif->bss_conf.assoc_capability &
-						WLAN_CAPABILITY_SHORT_PREAMBLE)
+		if (vif->bss_conf.use_short_preamble)
 			priv->staging_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
@@ -3108,17 +3103,12 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-			if (vif->bss_conf.assoc_capability &
-						WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			if (vif->bss_conf.use_short_slot)
 				priv->staging_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
-
-			if (vif->type == NL80211_IFTYPE_ADHOC)
-				priv->staging_rxon.flags &=
-					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5f56a0e..10ce008 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -904,14 +904,11 @@ static void iwl_set_flags_for_band(struct iwl_priv *priv,
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
 		/* Copied from iwl_post_associate() */
-		if (vif && vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif && vif->bss_conf.use_short_slot)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (vif && vif->type == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
 		priv->staging_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
 		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 82beeb5..09f8aca 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3096,19 +3096,16 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
-	if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+	if (vif->bss_conf.use_short_preamble)
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-		if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif->bss_conf.use_short_slot)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		if (vif->type == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 	}
 
 	iwlcore_commit_rxon(priv);
@@ -3272,8 +3269,7 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		priv->staging_rxon.assoc_id = 0;
 
-		if (vif->bss_conf.assoc_capability &
-					WLAN_CAPABILITY_SHORT_PREAMBLE)
+		if (vif->bss_conf.use_short_preamble)
 			priv->staging_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
@@ -3281,17 +3277,12 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-			if (vif->bss_conf.assoc_capability &
-					WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			if (vif->bss_conf.use_short_slot)
 				priv->staging_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
-
-			if (vif->type == NL80211_IFTYPE_ADHOC)
-				priv->staging_rxon.flags &=
-					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-- 
1.6.3.3

