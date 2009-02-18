Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZBRXuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8] iwl3945: use iwl rx handlers
Date: Wed, 18 Feb 2009 15:54:28 -0800
Message-Id: <1235001273-7808-4-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005040_917888_4C1A7CB6)
In-Reply-To: <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch removes duplicate rx handlers(pm_sleep and pm_debug) from 3945 and
uses handlers from iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   21 ---------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   26 ++------------------------
 4 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0027a77..aac75b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -765,27 +765,6 @@ static void iwl_rx_reply_error(struct iwl_priv *priv,
 		le32_to_cpu(pkt->u.err_resp.error_info));
 }
 
-static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
-		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
-#endif
-}
-
-static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
-			"notification for %s:\n",
-			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
-}
-
 static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4a51044..7a2c695 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1979,3 +1979,26 @@ void iwl_bg_rf_kill(struct work_struct *work)
 	iwl_rfkill_set_hw_state(priv);
 }
 EXPORT_SYMBOL(iwl_bg_rf_kill);
+
+void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
+			   struct iwl_rx_mem_buffer *rxb)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
+		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
+#endif
+}
+EXPORT_SYMBOL(iwl_rx_pm_sleep_notif);
+
+void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+				      struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
+			"notification for %s:\n",
+			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+}
+EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f3aa07c..8ecbe4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -250,6 +250,14 @@ int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
 
 /*****************************************************
+ * RX handlers.
+ * **************************************************/
+void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
+			   struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
+				      struct iwl_rx_mem_buffer *rxb);
+
+/*****************************************************
 * RX
 ******************************************************/
 void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d348b7d..e8bb11c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1417,28 +1417,6 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
 #endif
 }
 
-static void iwl3945_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
-		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
-#endif
-}
-
-static void iwl3945_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
-			"notification for %s:\n",
-			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw,
-			   le32_to_cpu(pkt->len));
-}
-
 static void iwl3945_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -1541,9 +1519,9 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
 	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
 	    iwl3945_rx_spectrum_measure_notif;
-	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl3945_rx_pm_sleep_notif;
+	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    iwl3945_rx_pm_debug_statistics_notif;
+	    iwl_rx_pm_debug_statistics_notif;
 	priv->rx_handlers[BEACON_NOTIFICATION] = iwl3945_rx_beacon_notif;
 
 	/*
-- 
1.5.4.3

