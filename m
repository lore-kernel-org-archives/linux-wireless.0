Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2CDUnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 069/101] iwlwifi: move iwl_sta_id_or_broadcast to user
Date: Sun,  4 Mar 2012 11:29:23 -0800
Message-Id: <1330889395-533-70-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214523_624676_B0C81A6E)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's only one user, so the function
can be moved into the correct file. It
also loses an argument along the way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   31 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h    |   31 -----------------------------
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e707e99..14a6bde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -248,6 +248,35 @@ static void iwlagn_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 	}
 }
 
+/**
+ * iwl_sta_id_or_broadcast - return sta_id or broadcast sta
+ * @context: the current context
+ * @sta: mac80211 station
+ *
+ * In certain circumstances mac80211 passes a station pointer
+ * that may be %NULL, for example during TX or key setup. In
+ * that case, we need to use the broadcast station, so this
+ * inline wraps that pattern.
+ */
+static int iwl_sta_id_or_broadcast(struct iwl_rxon_context *context,
+				   struct ieee80211_sta *sta)
+{
+	int sta_id;
+
+	if (!sta)
+		return context->bcast_sta_id;
+
+	sta_id = iwl_sta_id(sta);
+
+	/*
+	 * mac80211 should not be passing a partially
+	 * initialised station!
+	 */
+	WARN_ON(sta_id == IWL_INVALID_STATION);
+
+	return sta_id;
+}
+
 /*
  * start REPLY_TX command process
  */
@@ -304,7 +333,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		sta_id = ctx->bcast_sta_id;
 	else {
 		/* Find index into station table for destination station */
-		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
+		sta_id = iwl_sta_id_or_broadcast(ctx, info->control.sta);
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 				       hdr->addr1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ec3a90c..8384c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -258,37 +258,6 @@ static inline int iwl_sta_id(struct ieee80211_sta *sta)
 	return ((struct iwl_station_priv *)sta->drv_priv)->sta_id;
 }
 
-/**
- * iwl_sta_id_or_broadcast - return sta_id or broadcast sta
- * @priv: iwl priv
- * @context: the current context
- * @sta: mac80211 station
- *
- * In certain circumstances mac80211 passes a station pointer
- * that may be %NULL, for example during TX or key setup. In
- * that case, we need to use the broadcast station, so this
- * inline wraps that pattern.
- */
-static inline int iwl_sta_id_or_broadcast(struct iwl_priv *priv,
-					  struct iwl_rxon_context *context,
-					  struct ieee80211_sta *sta)
-{
-	int sta_id;
-
-	if (!sta)
-		return context->bcast_sta_id;
-
-	sta_id = iwl_sta_id(sta);
-
-	/*
-	 * mac80211 should not be passing a partially
-	 * initialised station!
-	 */
-	WARN_ON(sta_id == IWL_INVALID_STATION);
-
-	return sta_id;
-}
-
 int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 			       struct iwl_rxon_context *ctx);
 int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-- 
1.7.0.4

