Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966083Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/24] iwlwifi: move iwl_free_skb and mark it static
Date: Thu, 12 Apr 2012 14:54:02 -0700
Message-Id: <1334267661-14654-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235815_708488_F5FF60C8)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_free_skb is used only in iwl-agn.c, move
it there and mark it static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 ---------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 208b827..7398535 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2208,6 +2208,15 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 	priv->passive_no_rx = false;
 }
 
+static void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+
+	info = IEEE80211_SKB_CB(skb);
+	kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
+	dev_kfree_skb_any(skb);
+}
+
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 9ee13f3..6e8fd8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -97,7 +97,6 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 void iwl_down(struct iwl_priv *priv);
 void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
-void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0fde81d..efa6a91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -794,12 +794,3 @@ void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
-
-void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info;
-
-	info = IEEE80211_SKB_CB(skb);
-	kmem_cache_free(iwl_tx_cmd_pool, (info->driver_data[1]));
-	dev_kfree_skb_any(skb);
-}
-- 
1.7.0.4

