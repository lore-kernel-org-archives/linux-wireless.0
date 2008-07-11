Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYGKD4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/14] iwlwifi: fixes RTS / CTS support
Date: Fri, 11 Jul 2008 11:53:31 +0800
Message-Id: <1215748422-12672-4-git-send-email-yi.zhu@intel.com> (sfid-20080711_055654_521525_4B3B9B36)
In-Reply-To: <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes the RTS / CTS support in iwlwifi. 5000 will send CTS to
self when allowed by spec, 4965 will send RTS or CTS to self according to
mac80211 request.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    8 +-------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +++
 6 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 04365b3..e0e43bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -642,6 +642,18 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 	data->beacon_count = 0;
 }
 
+static void iwl4965_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+			__le32 *tx_flags)
+{
+	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
+		*tx_flags |= TX_CMD_FLG_RTS_MSK;
+		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
+	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
+		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+		*tx_flags |= TX_CMD_FLG_CTS_MSK;
+	}
+}
+
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -2372,6 +2384,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
+	.rts_tx_cmd_flag = iwl4965_rts_tx_cmd_flag,
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3697d03..b518792 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -370,6 +370,16 @@ static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 	}
 }
 
+static void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+			__le32 *tx_flags)
+{
+	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
+	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT))
+		*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
+	else
+		*tx_flags &= ~TX_CMD_FLG_RTS_CTS_MSK;
+}
+
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 95,
 	.max_nrg_cck = 0,
@@ -1437,6 +1447,7 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
 	.gain_computation = iwl5000_gain_computation,
 	.chain_noise_reset = iwl5000_chain_noise_reset,
+	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index fe05d60..d877039 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -556,6 +556,8 @@ enum {
 #define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3 << 25)
 #define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1 << 25)
 #define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2 << 25)
+/* CTS to self (if spec allows) flag */
+#define RXON_FLG_SELF_CTS_EN			__constant_cpu_to_le32(0x1<<30)
 
 /* rx_config filter flags */
 /* accept all data frames */
@@ -1139,6 +1141,11 @@ struct iwl4965_rx_mpdu_res_start {
 
 /* REPLY_TX Tx flags field */
 
+/* 1: Use RTS/CTS protocol or CTS-to-self if spec alows it
+ * before this frame. if CTS-to-self required check
+ * RXON_FLG_SELF_CTS_EN status. */
+#define TX_CMD_FLG_RTS_CTS_MSK __constant_cpu_to_le32(1 << 0)
+
 /* 1: Use Request-To-Send protocol before this frame.
  * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
 #define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dafd62c..8d18227 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -93,6 +93,8 @@ struct iwl_hcmd_utils_ops {
 			u16 min_average_noise_antennat_i,
 			u32 min_average_noise);
 	void (*chain_noise_reset)(struct iwl_priv *priv);
+	void (*rts_tx_cmd_flag)(struct ieee80211_tx_info *info,
+			__le32 *tx_flags);
 };
 
 struct iwl_lib_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 0be2a71..9b50b10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -601,13 +601,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
-		tx_flags |= TX_CMD_FLG_RTS_MSK;
-		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
-		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-		tx_flags |= TX_CMD_FLG_CTS_MSK;
-	}
+	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
 
 	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
 		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 47071f2..aea00d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -250,6 +250,9 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	/* always get timestamp with Rx frame */
 	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
+	/* allow CTS-to-self if possible. this is relevant only for
+	 * 5000, but will not damage 4965 */
+	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
 	ret = iwl4965_check_rxon_cmd(&priv->staging_rxon);
 	if (ret) {
-- 
1.5.3.6

