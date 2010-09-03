Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab0ICMBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:01:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/13] iwlwifi: force scan complete after timeout
Date: Fri,  3 Sep 2010 13:57:33 +0200
Message-Id: <1283515056-11523-11-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we do not get notification from hardware about scan complete after
timeout do mac80211 scan completion anyway. This assure we end scan
in case of firmware hung.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   15 +++------------
 drivers/net/wireless/iwlwifi/iwl-scan.c |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 87a2e40..7c1819f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2041,7 +2041,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	bool scan_completed = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -2050,15 +2049,10 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	WARN_ON(ctx->vif != vif);
 	ctx->vif = NULL;
 
-	iwl_scan_cancel_timeout(priv, 100);
+	if (priv->scan_vif == vif)
+		iwl_scan_cancel_timeout(priv, 100);
 	iwl_set_mode(priv, vif);
 
-	if (priv->scan_vif == vif) {
-		scan_completed = true;
-		priv->scan_vif = NULL;
-		priv->scan_request = NULL;
-	}
-
 	/*
 	 * When removing the IBSS interface, overwrite the
 	 * BT traffic load with the stored one from the last
@@ -2072,9 +2066,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	memset(priv->bssid, 0, ETH_ALEN);
 	mutex_unlock(&priv->mutex);
 
-	if (scan_completed)
-		ieee80211_scan_completed(priv->hw, true);
-
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 }
@@ -2255,6 +2246,7 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	iwl_scan_cancel_timeout(priv, 100);
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		mutex_unlock(&priv->mutex);
@@ -2264,7 +2256,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
-	iwl_scan_cancel_timeout(priv, 100);
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv, ctx);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index f79fb3e..fcc826e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -106,6 +106,15 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 	priv->scan_request = NULL;
 }
 
+static void iwl_force_scan_end(struct iwl_priv *priv)
+{
+	IWL_DEBUG_SCAN(priv, "Forcing scan end\n");
+	clear_bit(STATUS_SCANNING, &priv->status);
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	iwl_complete_scan(priv, true);
+}
+
 static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
@@ -125,10 +134,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 	ret = iwl_send_scan_abort(priv);
 	if (ret) {
 		IWL_DEBUG_SCAN(priv, "Send scan abort failed %d\n", ret);
-		clear_bit(STATUS_SCANNING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		iwl_complete_scan(priv, true);
+		iwl_force_scan_end(priv);
 	} else
 		IWL_DEBUG_SCAN(priv, "Sucessfully send scan abort\n");
 }
@@ -151,6 +157,7 @@ EXPORT_SYMBOL(iwl_scan_cancel);
  */
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
+	int ret;
 	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
 	lockdep_assert_held(&priv->mutex);
@@ -165,7 +172,10 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 		msleep(20);
 	}
 
-	return test_bit(STATUS_SCAN_HW, &priv->status);
+	ret = test_bit(STATUS_SCAN_HW, &priv->status);
+	if (ret)
+		iwl_force_scan_end(priv);
+	return ret;
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-- 
1.7.1

