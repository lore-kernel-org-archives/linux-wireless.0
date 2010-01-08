Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0AHSEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:32 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: disable tx on beacon update notification
Date: Fri,  8 Jan 2010 10:04:31 -0800
Message-Id: <1262973871-2483-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1262973871-2483-1-git-send-email-reinette.chatre@intel.com>
References: <1262973871-2483-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

On beacon change update notification from mac we are not disabling
the tx in adhoc mode. Mac sends BSS_CHANGED_BEACON_ENABLED when
station leaves IBSS. Driver should indicate uCode to not to send
anything on receiving this notification.

Functionality to indicate uCode is duplicated across
two notifications so created a common function called iwl_set_no_assoc.

Fix the issue at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2133.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   45 +++++++++++++++++-------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 574d366..5461f10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2344,6 +2344,21 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+static inline void iwl_set_no_assoc(struct iwl_priv *priv)
+{
+	priv->assoc_id = 0;
+	iwl_led_disassociate(priv);
+	/*
+	 * inform the ucode that there is no longer an
+	 * association and that no more packets should be
+	 * sent
+	 */
+	priv->staging_rxon.filter_flags &=
+		~RXON_FILTER_ASSOC_MSK;
+	priv->staging_rxon.assoc_id = 0;
+	iwlcore_commit_rxon(priv);
+}
+
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
@@ -2475,20 +2490,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			if (!iwl_is_rfkill(priv))
 				priv->cfg->ops->lib->post_associate(priv);
-		} else {
-			priv->assoc_id = 0;
-			iwl_led_disassociate(priv);
-
-			/*
-			 * inform the ucode that there is no longer an
-			 * association and that no more packets should be
-			 * send
-			 */
-			priv->staging_rxon.filter_flags &=
-				~RXON_FILTER_ASSOC_MSK;
-			priv->staging_rxon.assoc_id = 0;
-			iwlcore_commit_rxon(priv);
-		}
+		} else
+			iwl_set_no_assoc(priv);
 	}
 
 	if (changes && iwl_is_associated(priv) && priv->assoc_id) {
@@ -2503,12 +2506,14 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if ((changes & BSS_CHANGED_BEACON_ENABLED) &&
-	    vif->bss_conf.enable_beacon) {
-		memcpy(priv->staging_rxon.bssid_addr,
-		       bss_conf->bssid, ETH_ALEN);
-		memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
-		iwlcore_config_ap(priv);
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		if (vif->bss_conf.enable_beacon) {
+			memcpy(priv->staging_rxon.bssid_addr,
+			       bss_conf->bssid, ETH_ALEN);
+			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+			iwlcore_config_ap(priv);
+		} else
+			iwl_set_no_assoc(priv);
 	}
 
 	mutex_unlock(&priv->mutex);
-- 
1.5.6.3

