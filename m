Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0H0Q4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/27] iwlwifi: clamp scanning dwell time to all contexts
Date: Fri, 27 Aug 2010 09:59:38 -0700
Message-Id: <1282928395-32762-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dwell time should at least fit into all
context's beacon intervals.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fe4cb57..556dcaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -286,19 +286,28 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 			       enum ieee80211_band band,
 			       struct ieee80211_vif *vif)
 {
+	struct iwl_rxon_context *ctx;
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
 	if (iwl_is_any_associated(priv)) {
-		/* TODO: should use minimum of all contexts */
-		/* If we're associated, we clamp the maximum passive
-		 * dwell time to be 98% of the beacon interval (minus
-		 * 2 * channel tune time) */
-		passive = vif ? vif->bss_conf.beacon_int : 0;
-		if ((passive > IWL_PASSIVE_DWELL_BASE) || !passive)
-			passive = IWL_PASSIVE_DWELL_BASE;
-		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+		/*
+		 * If we're associated, we clamp the maximum passive
+		 * dwell time to be 98% of the smallest beacon interval
+		 * (minus 2 * channel tune time)
+		 */
+		for_each_context(priv, ctx) {
+			u16 value;
+
+			if (!iwl_is_associated_ctx(ctx))
+				continue;
+			value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
+			if ((value > IWL_PASSIVE_DWELL_BASE) || !value)
+				value = IWL_PASSIVE_DWELL_BASE;
+			value = (value * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+			passive = min(value, passive);
+		}
 	}
 
 	return passive;
-- 
1.7.0.4

