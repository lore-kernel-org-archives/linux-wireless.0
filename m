Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab0JNSEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/9] iwlwifi: rewrite RXON checks
Date: Thu, 14 Oct 2010 11:02:47 -0700
Message-Id: <1287079370-20587-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The RXON checking is a bit magical, and prints
out too much information if something goes wrong.
Make it less magical and print out only the items
that were actually wrong.

Also remove the comment about removing it -- the
driver is constantly changing so these checks are
useful.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |  100 +++++++++++++++----------------
 1 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 09a4d17..ecf5c9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -510,76 +510,74 @@ void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 }
 EXPORT_SYMBOL(iwl_set_rxon_hwcrypto);
 
-/**
- * iwl_check_rxon_cmd - validate RXON structure is valid
- *
- * NOTE:  This is really only useful during development and can eventually
- * be #ifdef'd out once the driver is stable and folks aren't actively
- * making changes
- */
+/* validate RXON structure is valid */
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
-	int error = 0;
-	int counter = 1;
 	struct iwl_rxon_cmd *rxon = &ctx->staging;
+	bool error = false;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |= le32_to_cpu(rxon->flags &
-				(RXON_FLG_TGJ_NARROW_BAND_MSK |
-				 RXON_FLG_RADAR_DETECT_MSK));
-		if (error)
-			IWL_WARN(priv, "check 24G fields %d | %d\n",
-				    counter++, error);
+		if (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK) {
+			IWL_WARN(priv, "check 2.4G: wrong narrow\n");
+			error = true;
+		}
+		if (rxon->flags & RXON_FLG_RADAR_DETECT_MSK) {
+			IWL_WARN(priv, "check 2.4G: wrong radar\n");
+			error = true;
+		}
 	} else {
-		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
-				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 fields %d | %d\n",
-				    counter++, error);
-		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
-		if (error)
-			IWL_WARN(priv, "check 52 CCK %d | %d\n",
-				    counter++, error);
-	}
-	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
-	if (error)
-		IWL_WARN(priv, "check mac addr %d | %d\n", counter++, error);
+		if (!(rxon->flags & RXON_FLG_SHORT_SLOT_MSK)) {
+			IWL_WARN(priv, "check 5.2G: not short slot!\n");
+			error = true;
+		}
+		if (rxon->flags & RXON_FLG_CCK_MSK) {
+			IWL_WARN(priv, "check 5.2G: CCK!\n");
+			error = true;
+		}
+	}
+	if ((rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1) {
+		IWL_WARN(priv, "mac/bssid mcast!\n");
+		error = true;
+	}
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
-	if (error)
-		IWL_WARN(priv, "check basic rate %d | %d\n", counter++, error);
+	if ((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0 &&
+	    (rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0) {
+		IWL_WARN(priv, "neither 1 nor 6 are basic\n");
+		error = true;
+	}
 
-	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
-	if (error)
-		IWL_WARN(priv, "check assoc id %d | %d\n", counter++, error);
+	if (le16_to_cpu(rxon->assoc_id) > 2007) {
+		IWL_WARN(priv, "aid > 2007\n");
+		error = true;
+	}
 
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK and short slot %d | %d\n",
-			    counter++, error);
+	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) {
+		IWL_WARN(priv, "CCK and short slot\n");
+		error = true;
+	}
 
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
-	if (error)
-		IWL_WARN(priv, "check CCK & auto detect %d | %d\n",
-			    counter++, error);
+	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
+		IWL_WARN(priv, "CCK and auto detect");
+		error = true;
+	}
 
-	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
-			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
-	if (error)
-		IWL_WARN(priv, "check TGG and auto detect %d | %d\n",
-			    counter++, error);
+	if ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
+			    RXON_FLG_TGG_PROTECT_MSK)) ==
+			    RXON_FLG_TGG_PROTECT_MSK) {
+		IWL_WARN(priv, "TGg but no auto-detect\n");
+		error = true;
+	}
 
 	if (error)
 		IWL_WARN(priv, "Tuning to channel %d\n",
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERR(priv, "Not a valid iwl_rxon_assoc_cmd field values\n");
-		return -1;
+		IWL_ERR(priv, "Invalid RXON\n");
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
1.7.0.4

