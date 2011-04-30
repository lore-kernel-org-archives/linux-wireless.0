Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab1D3Qkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/14] iwlagn: improve RXON checking
Date: Sat, 30 Apr 2011 09:17:38 -0700
Message-Id: <1304180260-13875-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184058_283396_45F4884F)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current RXON checking doesn't verify that
the channel is valid (or at least non-zero),
so add that. Also, add a WARN() so we get a
stacktrace, and capture a bitmask of errors
in order to capture all necessary information
in the warning itself (in case the previous
messages are snipped off.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   38 +++++++++++++++---------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1b2a7d9..98cfbb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -416,72 +416,72 @@ void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_rxon_cmd *rxon = &ctx->staging;
-	bool error = false;
+	u32 errors = 0;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		if (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK) {
 			IWL_WARN(priv, "check 2.4G: wrong narrow\n");
-			error = true;
+			errors |= BIT(0);
 		}
 		if (rxon->flags & RXON_FLG_RADAR_DETECT_MSK) {
 			IWL_WARN(priv, "check 2.4G: wrong radar\n");
-			error = true;
+			errors |= BIT(1);
 		}
 	} else {
 		if (!(rxon->flags & RXON_FLG_SHORT_SLOT_MSK)) {
 			IWL_WARN(priv, "check 5.2G: not short slot!\n");
-			error = true;
+			errors |= BIT(2);
 		}
 		if (rxon->flags & RXON_FLG_CCK_MSK) {
 			IWL_WARN(priv, "check 5.2G: CCK!\n");
-			error = true;
+			errors |= BIT(3);
 		}
 	}
 	if ((rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1) {
 		IWL_WARN(priv, "mac/bssid mcast!\n");
-		error = true;
+		errors |= BIT(4);
 	}
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
 	if ((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0 &&
 	    (rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0) {
 		IWL_WARN(priv, "neither 1 nor 6 are basic\n");
-		error = true;
+		errors |= BIT(5);
 	}
 
 	if (le16_to_cpu(rxon->assoc_id) > 2007) {
 		IWL_WARN(priv, "aid > 2007\n");
-		error = true;
+		errors |= BIT(6);
 	}
 
 	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) {
 		IWL_WARN(priv, "CCK and short slot\n");
-		error = true;
+		errors |= BIT(7);
 	}
 
 	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
 		IWL_WARN(priv, "CCK and auto detect");
-		error = true;
+		errors |= BIT(8);
 	}
 
 	if ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
 			    RXON_FLG_TGG_PROTECT_MSK)) ==
 			    RXON_FLG_TGG_PROTECT_MSK) {
 		IWL_WARN(priv, "TGg but no auto-detect\n");
-		error = true;
+		errors |= BIT(9);
 	}
 
-	if (error)
-		IWL_WARN(priv, "Tuning to channel %d\n",
-			    le16_to_cpu(rxon->channel));
-
-	if (error) {
-		IWL_ERR(priv, "Invalid RXON\n");
-		return -EINVAL;
+	if (rxon->channel == 0) {
+		IWL_WARN(priv, "zero channel is invalid\n");
+		errors |= BIT(10);
 	}
-	return 0;
+
+	WARN(errors, "Invalid RXON (%#x), channel %d",
+	     errors, le16_to_cpu(rxon->channel));
+
+	return errors ? -EINVAL : 0;
 }
 
 /**
-- 
1.7.0.4

