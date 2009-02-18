Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbZBRXuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwl3945: use iwl_rx_reply_error notification
Date: Wed, 18 Feb 2009 15:54:29 -0800
Message-Id: <1235001273-7808-5-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005041_417140_B6318F19)
In-Reply-To: <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch removes duplicate code from iwl3945 and uses
iwl_rx_reply_error and spectrum notifications from iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 ----------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 +-------------------------
 4 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index aac75b2..a3de6ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -751,20 +751,6 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		IWL_WARN(priv, "uCode did not respond OK.\n");
 }
 
-static void iwl_rx_reply_error(struct iwl_priv *priv,
-				   struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-
-	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
-		"seq 0x%04X ser 0x%08X\n",
-		le32_to_cpu(pkt->u.err_resp.error_type),
-		get_cmd_string(pkt->u.err_resp.cmd_id),
-		pkt->u.err_resp.cmd_id,
-		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
-		le32_to_cpu(pkt->u.err_resp.error_info));
-}
-
 static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7a2c695..61b9902 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2002,3 +2002,19 @@ void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
+
+void iwl_rx_reply_error(struct iwl_priv *priv,
+			struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+
+	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
+		"seq 0x%04X ser 0x%08X\n",
+		le32_to_cpu(pkt->u.err_resp.error_type),
+		get_cmd_string(pkt->u.err_resp.cmd_id),
+		pkt->u.err_resp.cmd_id,
+		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
+		le32_to_cpu(pkt->u.err_resp.error_info));
+}
+EXPORT_SYMBOL(iwl_rx_reply_error);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8ecbe4b..f2f75d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -256,6 +256,8 @@ void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_reply_error(struct iwl_priv *priv,
+			struct iwl_rx_mem_buffer *rxb);
 
 /*****************************************************
 * RX
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e8bb11c..62ec67a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1385,38 +1385,6 @@ static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
 	return;
 }
 
-static void iwl3945_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-
-	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
-		"seq 0x%04X ser 0x%08X\n",
-		le32_to_cpu(pkt->u.err_resp.error_type),
-		get_cmd_string(pkt->u.err_resp.cmd_id),
-		pkt->u.err_resp.cmd_id,
-		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
-		le32_to_cpu(pkt->u.err_resp.error_info));
-}
-
-static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
-
-	if (!report->state) {
-		IWL_DEBUG(priv, IWL_DL_11H | IWL_DL_INFO,
-			  "Spectrum Measure Notification: Start\n");
-		return;
-	}
-
-	memcpy(&priv->measure_report, report, sizeof(*report));
-	priv->measurement_status |= MEASUREMENT_READY;
-#endif
-}
-
 static void iwl3945_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -1515,10 +1483,8 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl3945_rx_reply_alive;
 	priv->rx_handlers[REPLY_ADD_STA] = iwl3945_rx_reply_add_sta;
-	priv->rx_handlers[REPLY_ERROR] = iwl3945_rx_reply_error;
+	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
-	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-	    iwl3945_rx_spectrum_measure_notif;
 	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
 	    iwl_rx_pm_debug_statistics_notif;
@@ -1532,6 +1498,7 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
 
+	iwl_setup_spectrum_handlers(priv);
 	iwl_setup_rx_scan_handlers(priv);
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
 
-- 
1.5.4.3

