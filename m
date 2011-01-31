Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab1AaVxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/11] iwlwifi: fix beacon notification parsing
Date: Mon, 31 Jan 2011 13:40:44 -0800
Message-Id: <1296510047-24576-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The beacon notification changed between 4965 and
agn because the embedded TX response changed, but
iwlwifi was never updated to know about this.
Update it now so the IBSS manager status will be
tracked correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +++++++
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ace0b98..8998ed1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2266,6 +2266,29 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
+static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl4965_beacon_notif *beacon = (void *)pkt->u.raw;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
+
+	IWL_DEBUG_RX(priv, "beacon status %#x, retries:%d ibssmgr:%d "
+		"tsf:0x%.8x%.8x rate:%d\n",
+		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
+		beacon->beacon_notify_hdr.failure_frame,
+		le32_to_cpu(beacon->ibss_mgr_status),
+		le32_to_cpu(beacon->high_tsf),
+		le32_to_cpu(beacon->low_tsf), rate);
+#endif
+
+	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
+
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+		queue_work(priv->workqueue, &priv->beacon_update);
+}
+
 static int iwl4965_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp)
 {
@@ -2308,6 +2331,7 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_RX] = iwlagn_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
+	priv->rx_handlers[BEACON_NOTIFICATION] = iwl4965_rx_beacon_notif;
 
 	/* set up notification wait support */
 	spin_lock_init(&priv->_agn.notif_wait_lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cf285f5..d62e592 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -704,18 +704,18 @@ static void iwl_bg_ucode_trace(unsigned long data)
 	}
 }
 
-static void iwl_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static void iwlagn_rx_beacon_notif(struct iwl_priv *priv,
+				   struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl4965_beacon_notif *beacon =
-		(struct iwl4965_beacon_notif *)pkt->u.raw;
+	struct iwlagn_beacon_notif *beacon = (void *)pkt->u.raw;
 #ifdef CONFIG_IWLWIFI_DEBUG
+	u16 status = le16_to_cpu(beacon->beacon_notify_hdr.status.status);
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
-	IWL_DEBUG_RX(priv, "beacon status %x retries %d iss %d "
-		"tsf %d %d rate %d\n",
-		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
+	IWL_DEBUG_RX(priv, "beacon status %#x, retries:%d ibssmgr:%d "
+		"tsf:0x%.8x%.8x rate:%d\n",
+		status & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
 		le32_to_cpu(beacon->ibss_mgr_status),
 		le32_to_cpu(beacon->high_tsf),
@@ -818,7 +818,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
 	    iwl_rx_pm_debug_statistics_notif;
-	priv->rx_handlers[BEACON_NOTIFICATION] = iwl_rx_beacon_notif;
+	priv->rx_handlers[BEACON_NOTIFICATION] = iwlagn_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 935b19e..c3ab6ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3083,6 +3083,13 @@ struct iwl4965_beacon_notif {
 	__le32 ibss_mgr_status;
 } __packed;
 
+struct iwlagn_beacon_notif {
+	struct iwlagn_tx_resp beacon_notify_hdr;
+	__le32 low_tsf;
+	__le32 high_tsf;
+	__le32 ibss_mgr_status;
+} __packed;
+
 /*
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
-- 
1.7.0.4

