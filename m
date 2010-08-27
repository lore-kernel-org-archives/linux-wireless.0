Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0H0Q4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/27] iwlwifi: follow main beacon interval
Date: Fri, 27 Aug 2010 09:59:54 -0700
Message-Id: <1282928395-32762-27-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It is necessary that the PAN context always
use the same beacon interval as the BSS
context unless it is in dual-station mode,
ie. the PAN context is a station as well,
so implement that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 91ca517..a2b39fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -525,9 +525,16 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 */
 	ctx->timing.atim_window = 0;
 
-	beacon_int = iwl_adjust_beacon_interval(beacon_int,
+	if (ctx->ctxid == IWL_RXON_CTX_PAN &&
+	    (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION)) {
+		ctx->timing.beacon_interval =
+			priv->contexts[IWL_RXON_CTX_BSS].timing.beacon_interval;
+		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
+	} else {
+		beacon_int = iwl_adjust_beacon_interval(beacon_int,
 				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
-	ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
+		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
+	}
 
 	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
 	interval_tm = beacon_int * TIME_UNIT;
-- 
1.7.0.4

