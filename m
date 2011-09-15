Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429Ab1IOTcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/27] iwlagn: free the Tx cmd when a non empty Tx queue is freed
Date: Thu, 15 Sep 2011 11:46:30 -0700
Message-Id: <1316112414-6341-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213320_984375_07D0C85D)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When a non-empty Tx queueis freed, the buffer it contains must be
freed too. Since the Tx cmd are now allocated from a pool, the Tx
cmd must be freed too.

This patch avoids to destroy a non-empty pool of Tx cmd.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c          |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    7 +++++--
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7f6c58e..1142d85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1522,6 +1522,8 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (priv->shrd->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
+	iwl_trans_stop_device(trans(priv));
+
 	/* Clear out all status bits but a few that are stable across reset */
 	priv->shrd->status &=
 			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status) <<
@@ -1533,8 +1535,6 @@ static void __iwl_down(struct iwl_priv *priv)
 			test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) <<
 				STATUS_EXIT_PENDING;
 
-	iwl_trans_stop_device(trans(priv));
-
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9270f99..5e490db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1876,3 +1876,12 @@ void iwl_nic_config(struct iwl_priv *priv)
 	priv->cfg->lib->nic_config(priv);
 
 }
+
+void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+
+	info = IEEE80211_SKB_CB(skb);
+	kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
+	dev_kfree_skb_any(skb);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index d987bee..bdfbc60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -390,6 +390,7 @@ void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
 				u8 sta_id, u8 tid);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
+void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index c7ddb22..15cb0ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -225,9 +225,12 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 
 		skb = txq->skbs[index];
 
-		/* can be called from irqs-disabled context */
+		/* Can be called from irqs-disabled context
+		 * If skb is not NULL, it means that the whole queue is being
+		 * freed and that the queue is not empty - free the skb
+		 */
 		if (skb) {
-			dev_kfree_skb_any(skb);
+			iwl_free_skb(priv(trans), skb);
 			txq->skbs[index] = NULL;
 		}
 	}
-- 
1.7.0.4

