Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45503 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0BGIVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:46 -0500
Subject: [PATCH 07/10] iwlwifi: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Date: Sun, 07 Feb 2010 10:21:37 +0200
Message-ID: <20100207082137.31474.27007.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Compile-tested only.

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   36 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 4 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3b950ae..19e8a17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3448,7 +3448,6 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.set_key = iwl_mac_set_key,
 	.update_tkip_key = iwl_mac_update_tkip_key,
 	.get_stats = iwl_mac_get_stats,
-	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 02bf17e..6733ed0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2850,42 +2850,6 @@ out:
 }
 EXPORT_SYMBOL(iwl_mac_config);
 
-int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
-			 struct ieee80211_tx_queue_stats *stats)
-{
-	struct iwl_priv *priv = hw->priv;
-	int i, avail;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq[i];
-		q = &txq->q;
-		avail = iwl_queue_space(q);
-
-		stats[i].len = q->n_window - avail;
-		stats[i].limit = q->n_window - q->high_mark;
-		stats[i].count = q->n_window;
-
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_mac_get_tx_stats);
-
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ec1fe1d..92d8060 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -341,8 +341,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_config_ap(struct iwl_priv *priv);
-int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
-			 struct ieee80211_tx_queue_stats *stats);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 119da54..eac2b9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3835,7 +3835,6 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.config = iwl_mac_config,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,

