Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab0JGXIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/22] iwlwifi: remove agn rates info there
Date: Thu,  7 Oct 2010 16:07:49 -0700
Message-Id: <1286492881-15743-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Code and data related to agn bitrates can be
part of the agn module rather than being in
the core module.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    9 ++++
 drivers/net/wireless/iwlwifi/iwl-3945.h   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   68 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |   10 ----
 drivers/net/wireless/iwlwifi/iwl-core.c   |   70 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 -
 6 files changed, 80 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4b3eb78..ba3ab04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -87,6 +87,15 @@ const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945] = {
 	IWL_DECLARE_RATE_INFO(54, 48, INV, 48, INV, 48, INV),/* 54mbps */
 };
 
+static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
+{
+	u8 rate = iwl3945_rates[rate_index].prev_ieee;
+
+	if (rate == IWL_RATE_INVALID)
+		rate = rate_index;
+	return rate;
+}
+
 /* 1 = enable the iwl3945_disable_events() function */
 #define IWL_EVT_DISABLE (0)
 #define IWL_EVT_DISABLE_SIZE (1532/32)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 77e8e19..09391f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -138,8 +138,6 @@ enum iwl3945_antenna {
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-#include "iwl-agn-rs.h"
-
 #define IWL_TX_FIFO_AC0	0
 #define IWL_TX_FIFO_AC1	1
 #define IWL_TX_FIFO_AC2	2
@@ -301,6 +299,9 @@ extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl3945_post_scan(struct iwl_priv *priv);
 
+/* rates */
+extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945];
+
 /* Requires full declaration of iwl_priv before including */
 #include "iwl-io.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 7e5cf1a..5abe2e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -77,6 +77,74 @@ static const u8 ant_toggle_lookup[] = {
 	/*ANT_ABC  -> */ ANT_ABC,
 };
 
+#define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
+	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
+				    IWL_RATE_SISO_##s##M_PLCP, \
+				    IWL_RATE_MIMO2_##s##M_PLCP,\
+				    IWL_RATE_MIMO3_##s##M_PLCP,\
+				    IWL_RATE_##r##M_IEEE,      \
+				    IWL_RATE_##ip##M_INDEX,    \
+				    IWL_RATE_##in##M_INDEX,    \
+				    IWL_RATE_##rp##M_INDEX,    \
+				    IWL_RATE_##rn##M_INDEX,    \
+				    IWL_RATE_##pp##M_INDEX,    \
+				    IWL_RATE_##np##M_INDEX }
+
+/*
+ * Parameter order:
+ *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
+ *
+ * If there isn't a valid next or previous rate then INV is used which
+ * maps to IWL_RATE_INVALID
+ *
+ */
+const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
+	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
+	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
+	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
+	IWL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),      /* 11mbps */
+	IWL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
+	IWL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),       /*  9mbps */
+	IWL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
+	IWL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),   /* 18mbps */
+	IWL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),   /* 24mbps */
+	IWL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
+	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
+	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
+	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
+	/* FIXME:RS:          ^^    should be INV (legacy) */
+};
+
+static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
+{
+	int idx = 0;
+
+	/* HT rate format */
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		idx = (rate_n_flags & 0xff);
+
+		if (idx >= IWL_RATE_MIMO3_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO3_6M_PLCP;
+		else if (idx >= IWL_RATE_MIMO2_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
+
+		idx += IWL_FIRST_OFDM_RATE;
+		/* skip 9M not supported in ht*/
+		if (idx >= IWL_RATE_9M_INDEX)
+			idx += 1;
+		if ((idx >= IWL_FIRST_OFDM_RATE) && (idx <= IWL_LAST_OFDM_RATE))
+			return idx;
+
+	/* legacy rate format, search for match in table */
+	} else {
+		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
+			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+				return idx;
+	}
+
+	return -1;
+}
+
 static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 357cdb2..75e50d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -299,7 +299,6 @@ enum {
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
 extern const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
-extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT_3945];
 
 enum iwl_table_type {
 	LQ_NONE,
@@ -453,15 +452,6 @@ static inline u8 first_antenna(u8 mask)
 }
 
 
-static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
-{
-	u8 rate = iwl3945_rates[rate_index].prev_ieee;
-
-	if (rate == IWL_RATE_INVALID)
-		rate = rate_index;
-	return rate;
-}
-
 /**
  * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index eefcb2d..2950384 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -69,79 +69,9 @@ EXPORT_SYMBOL_GPL(bt_coex_active);
 module_param(bt_coex_active, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
-#define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
-	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
-				    IWL_RATE_SISO_##s##M_PLCP, \
-				    IWL_RATE_MIMO2_##s##M_PLCP,\
-				    IWL_RATE_MIMO3_##s##M_PLCP,\
-				    IWL_RATE_##r##M_IEEE,      \
-				    IWL_RATE_##ip##M_INDEX,    \
-				    IWL_RATE_##in##M_INDEX,    \
-				    IWL_RATE_##rp##M_INDEX,    \
-				    IWL_RATE_##rn##M_INDEX,    \
-				    IWL_RATE_##pp##M_INDEX,    \
-				    IWL_RATE_##np##M_INDEX }
-
 u32 iwl_debug_level;
 EXPORT_SYMBOL(iwl_debug_level);
 
-/*
- * Parameter order:
- *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
- *
- * If there isn't a valid next or previous rate then INV is used which
- * maps to IWL_RATE_INVALID
- *
- */
-const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
-	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
-	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
-	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
-	IWL_DECLARE_RATE_INFO(11, INV, 9, 12, 9, 12, 5, 18),      /* 11mbps */
-	IWL_DECLARE_RATE_INFO(6, 6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
-	IWL_DECLARE_RATE_INFO(9, 6, 6, 11, 6, 11, 5, 11),       /*  9mbps */
-	IWL_DECLARE_RATE_INFO(12, 12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
-	IWL_DECLARE_RATE_INFO(18, 18, 12, 24, 12, 24, 11, 24),   /* 18mbps */
-	IWL_DECLARE_RATE_INFO(24, 24, 18, 36, 18, 36, 18, 36),   /* 24mbps */
-	IWL_DECLARE_RATE_INFO(36, 36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
-	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
-	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
-	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
-	/* FIXME:RS:          ^^    should be INV (legacy) */
-};
-EXPORT_SYMBOL(iwl_rates);
-
-int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
-{
-	int idx = 0;
-
-	/* HT rate format */
-	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		idx = (rate_n_flags & 0xff);
-
-		if (idx >= IWL_RATE_MIMO3_6M_PLCP)
-			idx = idx - IWL_RATE_MIMO3_6M_PLCP;
-		else if (idx >= IWL_RATE_MIMO2_6M_PLCP)
-			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
-
-		idx += IWL_FIRST_OFDM_RATE;
-		/* skip 9M not supported in ht*/
-		if (idx >= IWL_RATE_9M_INDEX)
-			idx += 1;
-		if ((idx >= IWL_FIRST_OFDM_RATE) && (idx <= IWL_LAST_OFDM_RATE))
-			return idx;
-
-	/* legacy rate format, search for match in table */
-	} else {
-		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
-				return idx;
-	}
-
-	return -1;
-}
-EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
-
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 31ec9db..56251de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -547,8 +547,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
  * Rate
  ******************************************************************************/
 
-int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
-
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx);
 
-- 
1.7.0.4

