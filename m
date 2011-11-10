Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab1KJBdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/28] iwlwifi: move hw_scan into _mac80211 file
Date: Wed,  9 Nov 2011 16:39:18 -0800
Message-Id: <1320885571-19122-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023433_397710_FC060DD4)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlagn_mac_hw_scan should belong to _mac80211 callback.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 --
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   46 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   45 --------------------------
 3 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ee3692a..fa47f75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -312,9 +312,6 @@ void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 void iwl_force_scan_end(struct iwl_priv *priv);
-int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif,
-		    struct cfg80211_scan_request *req);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 1b2dbb0..6df08bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1801,6 +1801,52 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 	return err;
 }
 
+static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif,
+		    struct cfg80211_scan_request *req)
+{
+	struct iwl_priv *priv = hw->priv;
+	int ret;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (req->n_channels == 0)
+		return -EINVAL;
+
+	mutex_lock(&priv->shrd->mutex);
+
+	/*
+	 * If an internal scan is in progress, just set
+	 * up the scan_request as per above.
+	 */
+	if (priv->scan_type != IWL_SCAN_NORMAL) {
+		IWL_DEBUG_SCAN(priv,
+			       "SCAN request during internal scan - defer\n");
+		priv->scan_request = req;
+		priv->scan_vif = vif;
+		ret = 0;
+	} else {
+		priv->scan_request = req;
+		priv->scan_vif = vif;
+		/*
+		 * mac80211 will only ask for one band at a time
+		 * so using channels[0] here is ok
+		 */
+		ret = iwl_scan_initiate(priv, vif, IWL_SCAN_NORMAL,
+					req->channels[0]->band);
+		if (ret) {
+			priv->scan_request = NULL;
+			priv->scan_vif = NULL;
+		}
+	}
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+	mutex_unlock(&priv->shrd->mutex);
+
+	return ret;
+}
+
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a26fbd3..625beec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -939,51 +939,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 	return 0;
 }
 
-int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif,
-		    struct cfg80211_scan_request *req)
-{
-	struct iwl_priv *priv = hw->priv;
-	int ret;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (req->n_channels == 0)
-		return -EINVAL;
-
-	mutex_lock(&priv->shrd->mutex);
-
-	/*
-	 * If an internal scan is in progress, just set
-	 * up the scan_request as per above.
-	 */
-	if (priv->scan_type != IWL_SCAN_NORMAL) {
-		IWL_DEBUG_SCAN(priv,
-			       "SCAN request during internal scan - defer\n");
-		priv->scan_request = req;
-		priv->scan_vif = vif;
-		ret = 0;
-	} else {
-		priv->scan_request = req;
-		priv->scan_vif = vif;
-		/*
-		 * mac80211 will only ask for one band at a time
-		 * so using channels[0] here is ok
-		 */
-		ret = iwl_scan_initiate(priv, vif, IWL_SCAN_NORMAL,
-					req->channels[0]->band);
-		if (ret) {
-			priv->scan_request = NULL;
-			priv->scan_vif = NULL;
-		}
-	}
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	mutex_unlock(&priv->shrd->mutex);
-
-	return ret;
-}
 
 /*
  * internal short scan, this function should only been called while associated.
-- 
1.7.0.4

