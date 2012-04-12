Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966084Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/24] iwlwifi: move iwl_set_hw_rfkill_state and mark it static
Date: Thu, 12 Apr 2012 14:54:03 -0700
Message-Id: <1334267661-14654-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235821_226406_882CEC44)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_set_hw_rfkill_state is used only in
iwl-agn.c. Move it there and mark it static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c |   12 ------------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7398535..b0cadcc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2217,6 +2217,18 @@ static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
+static void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	if (state)
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+
+	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
+}
+
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 6e8fd8b..3b66e30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -100,7 +100,6 @@ void iwlagn_prepare_restart(struct iwl_priv *priv);
 int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
-void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
 
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index efa6a91..e1129dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -782,15 +782,3 @@ int iwl_cmd_echo_test(struct iwl_priv *priv)
 		IWL_DEBUG_INFO(priv, "echo testing pass\n");
 	return ret;
 }
-
-void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
-{
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-
-	if (state)
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
-	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-
-	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
-}
-- 
1.7.0.4

