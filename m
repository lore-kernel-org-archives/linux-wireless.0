Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab2CDUnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 061/101] iwlwifi: virtualize nic_config
Date: Sun,  4 Mar 2012 11:29:15 -0800
Message-Id: <1330889395-533-62-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214538_324411_0DC3CB34)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The nic_config sets uCode dependent register
bits, so it must be virtual in the op_mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c       |    5 -----
 drivers/net/wireless/iwlwifi/iwl-op-mode.h    |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    2 +-
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index afded29..98f32e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1422,6 +1422,13 @@ static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 	}
 }
 
+static void iwl_nic_config(struct iwl_op_mode *op_mode)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	cfg(priv)->lib->nic_config(priv);
+}
+
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
@@ -1432,6 +1439,7 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.free_skb = iwl_free_skb,
 	.nic_error = iwl_nic_error,
 	.cmd_queue_full = iwl_cmd_queue_full,
+	.nic_config = iwl_nic_config,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c60c4a8..6648c1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1479,11 +1479,6 @@ void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
 
-void iwl_nic_config(struct iwl_priv *priv)
-{
-	cfg(priv)->lib->nic_config(priv);
-}
-
 void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index a4a4907..6ea4163 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -123,6 +123,8 @@ struct iwl_fw;
  *	Must be atomic
  * @nic_error: error notification. Must be atomic
  * @cmd_queue_full: Called when the command queue gets full. Must be atomic.
+ * @nic_config: configure NIC, called before firmware is started.
+ *	May sleep
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
@@ -136,6 +138,7 @@ struct iwl_op_mode_ops {
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 	void (*nic_error)(struct iwl_op_mode *op_mode);
 	void (*cmd_queue_full)(struct iwl_op_mode *op_mode);
+	void (*nic_config)(struct iwl_op_mode *op_mode);
 };
 
 /**
@@ -199,6 +202,12 @@ static inline void iwl_op_mode_cmd_queue_full(struct iwl_op_mode *op_mode)
 	op_mode->ops->cmd_queue_full(op_mode);
 }
 
+static inline void iwl_op_mode_nic_config(struct iwl_op_mode *op_mode)
+{
+	might_sleep();
+	op_mode->ops->nic_config(op_mode);
+}
+
 /*****************************************************
 * Op mode layers implementations
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 4fc8967..a6c2539 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -416,7 +416,6 @@ enum iwl_rxon_context_id {
 };
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
-void iwl_nic_config(struct iwl_priv *priv);
 const char *get_cmd_string(u8 cmd);
 
 #define IWL_CMD(x) case x: return #x
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index d68dd65..836e067 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -823,7 +823,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	iwl_set_pwr_vmain(trans);
 
-	iwl_nic_config(priv(trans));
+	iwl_op_mode_nic_config(trans->op_mode);
 
 #ifndef CONFIG_IWLWIFI_IDI
 	/* Allocate the RX queue, or reset if it is already allocated */
-- 
1.7.0.4

