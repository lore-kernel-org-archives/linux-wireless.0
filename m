Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYE2Ihu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 33/43] iwlwifi: Rx handlers common use for 4965 and 5000
Date: Thu, 29 May 2008 16:35:18 +0800
Message-Id: <1212050128-17132-34-git-send-email-yi.zhu@intel.com> (sfid-20080529_103802_443424_4762E536)
In-Reply-To: <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
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
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch moves Rx handlers from iwl 4965 only use to common use along
with iwl 5000, thus enables Rx path to iwl 5000.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   19 ++-----------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 ++++++++++++++++--
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 556e59e..aee7014 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2689,7 +2689,7 @@ static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
+void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -2863,17 +2863,6 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	}
 }
 
-/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
- * This will be used later in iwl4965_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	priv->last_phy_res[0] = 1;
-	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
-	       sizeof(struct iwl4965_rx_phy_res));
-}
-
 #ifdef CONFIG_IWL4965_HT
 
 /**
@@ -3522,11 +3511,7 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
 	priv->rx_handlers[REPLY_RX] = iwl4965_rx_reply_rx;
-
-	/* High-throughput (HT) Rx frames */
-	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl4965_rx_reply_rx_phy;
-	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl4965_rx_reply_rx;
-
+	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 
 #ifdef CONFIG_IWL4965_HT
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8c258d6..a2b9817 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -702,6 +702,8 @@ extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
+extern void iwl4965_rx_reply_rx(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb);
 
 /**
  * iwl_find_station - Find station id for a given BSSID
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4322cd6..49e72d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1872,6 +1872,17 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		wake_up_interruptible(&priv->wait_command_queue);
 }
 
+/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
+ * This will be used later in iwl4965_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
+static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	priv->last_phy_res[0] = 1;
+	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
+	       sizeof(struct iwl4965_rx_phy_res));
+}
+
 /**
  * iwl4965_setup_rx_handlers - Initialize Rx handler callbacks
  *
@@ -1900,18 +1911,21 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	 */
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl4965_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl4965_hw_rx_statistics;
-
+	/* scan handlers */
 	priv->rx_handlers[REPLY_SCAN_CMD] = iwl4965_rx_reply_scan;
 	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl4965_rx_scan_start_notif;
 	priv->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
 	    iwl4965_rx_scan_results_notif;
 	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
 	    iwl4965_rx_scan_complete_notif;
+	/* status change handler */
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl4965_rx_card_state_notif;
 
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl_rx_missed_beacon_notif;
-
+	/* Rx handlers */
+	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl4965_rx_reply_rx_phy;
+	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl4965_rx_reply_rx;
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
-- 
1.5.3.6

