Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161467Ab2COU2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/26] iwlwifi: move iwl_full_rxon_required and mark it static
Date: Thu, 15 Mar 2012 13:27:02 -0700
Message-Id: <1331843226-29860-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212839_067450_D82087D4)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_full_rxon_required is used only in
iwl-agn-rxon.c. Move it there and mark it
static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   64 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   64 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 3 files changed, 64 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8eb2946..73d8ab4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -24,6 +24,7 @@
  *
  *****************************************************************************/
 
+#include <linux/etherdevice.h>
 #include "iwl-dev.h"
 #include "iwl-agn.h"
 #include "iwl-core.h"
@@ -586,6 +587,69 @@ static int iwl_check_rxon_cmd(struct iwl_priv *priv,
 }
 
 /**
+ * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
+ * @priv: staging_rxon is compared to active_rxon
+ *
+ * If the RXON structure is changing enough to require a new tune,
+ * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
+ * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
+ */
+static int iwl_full_rxon_required(struct iwl_priv *priv,
+				  struct iwl_rxon_context *ctx)
+{
+	const struct iwl_rxon_cmd *staging = &ctx->staging;
+	const struct iwl_rxon_cmd *active = &ctx->active;
+
+#define CHK(cond)							\
+	if ((cond)) {							\
+		IWL_DEBUG_INFO(priv, "need full RXON - " #cond "\n");	\
+		return 1;						\
+	}
+
+#define CHK_NEQ(c1, c2)						\
+	if ((c1) != (c2)) {					\
+		IWL_DEBUG_INFO(priv, "need full RXON - "	\
+			       #c1 " != " #c2 " - %d != %d\n",	\
+			       (c1), (c2));			\
+		return 1;					\
+	}
+
+	/* These items are only settable from the full RXON command */
+	CHK(!iwl_is_associated_ctx(ctx));
+	CHK(compare_ether_addr(staging->bssid_addr, active->bssid_addr));
+	CHK(compare_ether_addr(staging->node_addr, active->node_addr));
+	CHK(compare_ether_addr(staging->wlap_bssid_addr,
+				active->wlap_bssid_addr));
+	CHK_NEQ(staging->dev_type, active->dev_type);
+	CHK_NEQ(staging->channel, active->channel);
+	CHK_NEQ(staging->air_propagation, active->air_propagation);
+	CHK_NEQ(staging->ofdm_ht_single_stream_basic_rates,
+		active->ofdm_ht_single_stream_basic_rates);
+	CHK_NEQ(staging->ofdm_ht_dual_stream_basic_rates,
+		active->ofdm_ht_dual_stream_basic_rates);
+	CHK_NEQ(staging->ofdm_ht_triple_stream_basic_rates,
+		active->ofdm_ht_triple_stream_basic_rates);
+	CHK_NEQ(staging->assoc_id, active->assoc_id);
+
+	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
+	 * be updated with the RXON_ASSOC command -- however only some
+	 * flag transitions are allowed using RXON_ASSOC */
+
+	/* Check if we are not switching bands */
+	CHK_NEQ(staging->flags & RXON_FLG_BAND_24G_MSK,
+		active->flags & RXON_FLG_BAND_24G_MSK);
+
+	/* Check if we are switching association toggle */
+	CHK_NEQ(staging->filter_flags & RXON_FILTER_ASSOC_MSK,
+		active->filter_flags & RXON_FILTER_ASSOC_MSK);
+
+#undef CHK
+#undef CHK_NEQ
+
+	return 0;
+}
+
+/**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
  * The RXON command in staging_rxon is committed to the hardware and
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5633869..ec250b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -28,7 +28,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/etherdevice.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
@@ -88,69 +87,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			ctx->ht.extension_chan_offset);
 }
 
-/**
- * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
- * @priv: staging_rxon is compared to active_rxon
- *
- * If the RXON structure is changing enough to require a new tune,
- * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
- * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
- */
-int iwl_full_rxon_required(struct iwl_priv *priv,
-			   struct iwl_rxon_context *ctx)
-{
-	const struct iwl_rxon_cmd *staging = &ctx->staging;
-	const struct iwl_rxon_cmd *active = &ctx->active;
-
-#define CHK(cond)							\
-	if ((cond)) {							\
-		IWL_DEBUG_INFO(priv, "need full RXON - " #cond "\n");	\
-		return 1;						\
-	}
-
-#define CHK_NEQ(c1, c2)						\
-	if ((c1) != (c2)) {					\
-		IWL_DEBUG_INFO(priv, "need full RXON - "	\
-			       #c1 " != " #c2 " - %d != %d\n",	\
-			       (c1), (c2));			\
-		return 1;					\
-	}
-
-	/* These items are only settable from the full RXON command */
-	CHK(!iwl_is_associated_ctx(ctx));
-	CHK(compare_ether_addr(staging->bssid_addr, active->bssid_addr));
-	CHK(compare_ether_addr(staging->node_addr, active->node_addr));
-	CHK(compare_ether_addr(staging->wlap_bssid_addr,
-				active->wlap_bssid_addr));
-	CHK_NEQ(staging->dev_type, active->dev_type);
-	CHK_NEQ(staging->channel, active->channel);
-	CHK_NEQ(staging->air_propagation, active->air_propagation);
-	CHK_NEQ(staging->ofdm_ht_single_stream_basic_rates,
-		active->ofdm_ht_single_stream_basic_rates);
-	CHK_NEQ(staging->ofdm_ht_dual_stream_basic_rates,
-		active->ofdm_ht_dual_stream_basic_rates);
-	CHK_NEQ(staging->ofdm_ht_triple_stream_basic_rates,
-		active->ofdm_ht_triple_stream_basic_rates);
-	CHK_NEQ(staging->assoc_id, active->assoc_id);
-
-	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
-	 * be updated with the RXON_ASSOC command -- however only some
-	 * flag transitions are allowed using RXON_ASSOC */
-
-	/* Check if we are not switching bands */
-	CHK_NEQ(staging->flags & RXON_FLG_BAND_24G_MSK,
-		active->flags & RXON_FLG_BAND_24G_MSK);
-
-	/* Check if we are switching association toggle */
-	CHK_NEQ(staging->filter_flags & RXON_FILTER_ASSOC_MSK,
-		active->filter_flags & RXON_FILTER_ASSOC_MSK);
-
-#undef CHK
-#undef CHK_NEQ
-
-	return 0;
-}
-
 static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 			     struct iwl_ht_config *ht_conf,
 			     struct iwl_rxon_context *ctx)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f49a69c..2488fc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -93,7 +93,6 @@ struct iwl_lib_ops {
  *   L i b                 *
  ***************************/
 
-int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
-- 
1.7.0.4

