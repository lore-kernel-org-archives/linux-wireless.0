Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966089Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/24] iwlwifi: move iwl_set_rate to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:09 -0700
Message-Id: <1334267661-14654-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235813_258565_EEDEB438)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of  iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 -------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 994fb21..18776ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -715,6 +715,19 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 	}
 }
 
+void iwl_set_rate(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+
+	for_each_context(priv, ctx) {
+		ctx->staging.cck_basic_rates =
+		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+
+		ctx->staging.ofdm_basic_rates =
+		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+	}
+}
+
 static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 				  struct iwl_rxon_context *ctx, int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 8f9ea33..3588d3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -136,6 +136,8 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
+void iwl_set_rate(struct iwl_priv *priv);
+
 /* uCode */
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 942cbdb..40eb91a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,19 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-void iwl_set_rate(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx;
-
-	for_each_context(priv, ctx) {
-		ctx->staging.cck_basic_rates =
-		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-		ctx->staging.ofdm_basic_rates =
-		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	}
-}
-
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 {
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8f6b16b..9cf1a94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -78,7 +78,6 @@ struct iwl_cmd;
  *   L i b                 *
  ***************************/
 
-void iwl_set_rate(struct iwl_priv *priv);
 int iwl_cmd_echo_test(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
-- 
1.7.0.4

