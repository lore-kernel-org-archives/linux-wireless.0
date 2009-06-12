Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZFLUPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8 v2.6.31 and w-t ] iwlwifi: revamp bss_info_changed
Date: Fri, 12 Jun 2009 13:22:48 -0700
Message-Id: <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

My earlier patch,
	"mac80211: unify config_interface and bss_info_changed"
introduced a bug in iwlwifi where it will do some things
incorrectly now when reassociating.

Revamp iwl_bss_info_changed to fix that issue and make it
easier to read. Also, while at it, add comments about things
that it should do but currently doesn't.

Finally, also improve the locking in the function.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |  114 +++++++++++++++++++------------
 1 files changed, 70 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f9d16ca..e05faa0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2390,39 +2390,46 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
-	if ((changes & BSS_CHANGED_BSSID) && !iwl_is_rfkill(priv)) {
-		/* If there is currently a HW scan going on in the background
-		 * then we need to cancel it else the RXON below will fail. */
+	if (changes & BSS_CHANGED_BEACON_INT) {
+		priv->beacon_int = bss_conf->beacon_int;
+		/* TODO: in AP mode, do something to make this take effect */
+	}
+
+	if (changes & BSS_CHANGED_BSSID) {
+		IWL_DEBUG_MAC80211(priv, "BSSID %pM\n", bss_conf->bssid);
+
+		/*
+		 * If there is currently a HW scan going on in the
+		 * background then we need to cancel it else the RXON
+		 * below/in post_associate will fail.
+		 */
 		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress "
-				    "after 100ms\n");
+			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
 			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
 			return;
 		}
-		memcpy(priv->staging_rxon.bssid_addr,
-		       bss_conf->bssid, ETH_ALEN);
 
-		/* TODO: Audit driver for usage of these members and see
-		 * if mac80211 deprecates them (priv->bssid looks like it
-		 * shouldn't be there, but I haven't scanned the IBSS code
-		 * to verify) - jpk */
-		memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+		/* mac80211 only sets assoc when in STATION mode */
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC ||
+		    bss_conf->assoc) {
+			memcpy(priv->staging_rxon.bssid_addr,
+			       bss_conf->bssid, ETH_ALEN);
 
-		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwlcore_config_ap(priv);
-		else {
-			int rc = iwlcore_commit_rxon(priv);
-			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-				iwl_rxon_add_station(
-					priv, priv->active_rxon.bssid_addr, 1);
+			/* currently needed in a few places */
+			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+		} else {
+			priv->staging_rxon.filter_flags &=
+				~RXON_FILTER_ASSOC_MSK;
 		}
-	} else if (!iwl_is_rfkill(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
+
 	}
 
+	/*
+	 * This needs to be after setting the BSSID in case
+	 * mac80211 decides to do both changes at once because
+	 * it will invoke post_associate.
+	 */
 	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	    changes & BSS_CHANGED_BEACON) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -2431,8 +2438,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			iwl_mac_beacon_update(hw, beacon);
 	}
 
-	mutex_unlock(&priv->mutex);
-
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
@@ -2450,6 +2455,23 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 	}
 
+	if (changes & BSS_CHANGED_BASIC_RATES) {
+		/* XXX use this information
+		 *
+		 * To do that, remove code from iwl_set_rate() and put something
+		 * like this here:
+		 *
+		if (A-band)
+			priv->staging_rxon.ofdm_basic_rates =
+				bss_conf->basic_rates;
+		else
+			priv->staging_rxon.ofdm_basic_rates =
+				bss_conf->basic_rates >> 4;
+			priv->staging_rxon.cck_basic_rates =
+				bss_conf->basic_rates & 0xF;
+		 */
+	}
+
 	if (changes & BSS_CHANGED_HT) {
 		iwl_ht_conf(priv, bss_conf);
 
@@ -2459,10 +2481,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
-		/* This should never happen as this function should
-		 * never be called from interrupt context. */
-		if (WARN_ON_ONCE(in_interrupt()))
-			return;
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
@@ -2470,27 +2488,35 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 
-			/* we have just associated, don't start scan too early
-			 * leave time for EAPOL exchange to complete
+			/*
+			 * We have just associated, don't start scan too early
+			 * leave time for EAPOL exchange to complete.
+			 *
+			 * XXX: do this in mac80211
 			 */
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-			mutex_lock(&priv->mutex);
-			priv->cfg->ops->lib->post_associate(priv);
-			mutex_unlock(&priv->mutex);
-		} else {
+			if (!iwl_is_rfkill(priv))
+				priv->cfg->ops->lib->post_associate(priv);
+		} else
 			priv->assoc_id = 0;
-			IWL_DEBUG_MAC80211(priv, "DISASSOC %d\n", bss_conf->assoc);
+
+	}
+
+	if (changes && iwl_is_associated(priv) && priv->assoc_id) {
+		IWL_DEBUG_MAC80211(priv, "Changes (%#x) while associated\n",
+				   changes);
+		ret = iwl_send_rxon_assoc(priv);
+		if (!ret) {
+			/* Sync active_rxon with latest change. */
+			memcpy((void *)&priv->active_rxon,
+				&priv->staging_rxon,
+				sizeof(struct iwl_rxon_cmd));
 		}
-	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
-			IWL_DEBUG_MAC80211(priv, "Associated Changes %d\n", changes);
-			ret = iwl_send_rxon_assoc(priv);
-			if (!ret)
-				/* Sync active_rxon with latest change. */
-				memcpy((void *)&priv->active_rxon,
-					&priv->staging_rxon,
-					sizeof(struct iwl_rxon_cmd));
 	}
+
+	mutex_unlock(&priv->mutex);
+
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 EXPORT_SYMBOL(iwl_bss_info_changed);
-- 
1.5.6.3

