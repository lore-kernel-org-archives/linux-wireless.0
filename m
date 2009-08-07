Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZHGWl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/16] iwlwifi: fix missing EXPORT_SYMBOL
Date: Fri,  7 Aug 2009 15:41:49 -0700
Message-Id: <1249684912-22936-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When compiling without CONFIG_IWLWIFI_DEBUGFS there is a missing
iwl_update_stats symbol. This is fixed by making this function an inline in
the case when CONFIG_IWLWIFI_DEBUGFS is not set due to the hot path in
which it is used.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   16 ----------------
 drivers/net/wireless/iwlwifi/iwl-core.h |   19 +++++++++++++++++--
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 22961e9..44d01a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3172,22 +3172,6 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 	}
 }
 EXPORT_SYMBOL(iwl_update_stats);
-
-#else
-void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
-{
-	struct traffic_stats	*stats;
-
-	if (is_tx)
-		stats = &priv->tx_stats;
-	else
-		stats = &priv->rx_stats;
-
-	if (ieee80211_is_data(fc)) {
-		/* data */
-		stats->data_bytes += len;
-	}
-}
 #endif
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ea8748d..32750f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -314,6 +314,8 @@ const char *get_mgmt_string(int cmd);
 const char *get_ctrl_string(int cmd);
 void iwl_clear_tx_stats(struct iwl_priv *priv);
 void iwl_clear_rx_stats(struct iwl_priv *priv);
+void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
+		      u16 len);
 #else
 static inline int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
@@ -333,9 +335,22 @@ static inline void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 		      u16 length, struct ieee80211_hdr *header)
 {
 }
+static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
+				    __le16 fc, u16 len)
+{
+	struct traffic_stats	*stats;
+
+	if (is_tx)
+		stats = &priv->tx_stats;
+	else
+		stats = &priv->rx_stats;
+
+	if (ieee80211_is_data(fc)) {
+		/* data */
+		stats->data_bytes += len;
+	}
+}
 #endif
-void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
-		      u16 len);
 /*****************************************************
  * RX handlers.
  * **************************************************/
-- 
1.5.6.3

