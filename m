Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000Ab2CEUiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 04/33] iwlwifi: simplify code in iwlagn_key_sta_id
Date: Mon,  5 Mar 2012 11:24:22 -0800
Message-Id: <1330975491-19680-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213916_348796_0599E251)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simplify the code by returning directly in the
error case and replacing the switch/if with a
single if statement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index f1298cd..3eb8fd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1080,32 +1080,19 @@ static u8 iwlagn_key_sta_id(struct iwl_priv *priv,
 			    struct ieee80211_sta *sta)
 {
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	u8 sta_id = IWL_INVALID_STATION;
 
 	if (sta)
-		sta_id = iwl_sta_id(sta);
+		return iwl_sta_id(sta);
 
 	/*
 	 * The device expects GTKs for station interfaces to be
 	 * installed as GTKs for the AP station. If we have no
 	 * station ID, then use the ap_sta_id in that case.
 	 */
-	if (!sta && vif && vif_priv->ctx) {
-		switch (vif->type) {
-		case NL80211_IFTYPE_STATION:
-			sta_id = vif_priv->ctx->ap_sta_id;
-			break;
-		default:
-			/*
-			 * In all other cases, the key will be
-			 * used either for TX only or is bound
-			 * to a station already.
-			 */
-			break;
-		}
-	}
+	if (vif->type == NL80211_IFTYPE_STATION && vif_priv->ctx)
+		return vif_priv->ctx->ap_sta_id;
 
-	return sta_id;
+	return IWL_INVALID_STATION;
 }
 
 static int iwlagn_send_sta_key(struct iwl_priv *priv,
-- 
1.7.0.4

