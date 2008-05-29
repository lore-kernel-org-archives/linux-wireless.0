Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYE2Ihr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 30/43] iwlwifi: move iwl_sta_modify_enable_tid_tx to iwl-sta.c
Date: Thu, 29 May 2008 16:35:15 +0800
Message-Id: <1212050128-17132-31-git-send-email-yi.zhu@intel.com> (sfid-20080529_110546_418390_4B5AB541)
In-Reply-To: <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl_sta_modify_enable_tid_tx into iwl-sta.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   21 ++-------------------
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    1 +
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1d95e8c..b719d19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -44,6 +44,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-calib.h"
+#include "iwl-sta.h"
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
@@ -2900,24 +2901,6 @@ static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 #ifdef CONFIG_IWL4965_HT
 
 /**
- * iwl4965_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
- */
-static void iwl4965_sta_modify_enable_tid_tx(struct iwl_priv *priv,
-					 int sta_id, int tid)
-{
-	unsigned long flags;
-
-	/* Remove "disable" flag, to enable Tx for this TID */
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
-	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-}
-
-/**
  * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
  *
  * Go through block-ack's bitmap of ACK'd frames, update driver's record of
@@ -3193,7 +3176,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	/* Modify device's station table to Tx this TID */
-	iwl4965_sta_modify_enable_tid_tx(priv, sta_id, tid);
+	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	rc = iwl_grab_nic_access(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ed07566..983f107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -921,3 +921,23 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 }
 EXPORT_SYMBOL(iwl_get_sta_id);
 
+
+/**
+ * iwl_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
+ */
+void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid)
+{
+	unsigned long flags;
+
+	/* Remove "disable" flag, to enable Tx for this TID */
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_TID_DISABLE_TX;
+	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le16(~(1 << tid));
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_sta_modify_enable_tid_tx);
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 500e1df..3d55716 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -45,4 +45,5 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
+void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid);
 #endif /* __iwl_sta_h__ */
-- 
1.5.3.6

