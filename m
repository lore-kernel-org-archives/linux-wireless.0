Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXLCLph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:37 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 31/34] iwlwifi: enhance WPA authenication stability
Date: Mon,  3 Dec 2007 13:43:43 +0200
Message-Id: <1196682232185-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120556_787736_08E6524A)
In-Reply-To: <11966822321066-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
 <11966822311945-git-send-email-tomas.winkler@intel.com>
 <11966822312882-git-send-email-tomas.winkler@intel.com>
 <11966822323269-git-send-email-tomas.winkler@intel.com>
 <11966822321249-git-send-email-tomas.winkler@intel.com>
 <11966822324036-git-send-email-tomas.winkler@intel.com>
 <11966822321616-git-send-email-tomas.winkler@intel.com>
 <1196682232443-git-send-email-tomas.winkler@intel.com>
 <11966822323588-git-send-email-tomas.winkler@intel.com>
 <11966822321066-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch enhanced WPA authenication stability by avoiding scan
immediately followed by association. We don't do any scanning right
after association in next several seconds. This will allow WPA
authentication to take place without any interruption.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   24 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 +++++++++++++++++-------
 6 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b58bcc2..7d15b33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -285,6 +285,8 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 	rxb->skb = NULL;
 }
 
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
+
 static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 				struct iwl3945_rx_mem_buffer *rxb)
 {
@@ -442,6 +444,13 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 		case IEEE80211_STYPE_REASSOC_RESP:{
 				struct ieee80211_mgmt *mgnt =
 				    (struct ieee80211_mgmt *)header;
+
+				/* We have just associated, give some
+				 * time for the 4-way handshake if
+				 * any. Don't start scan too early. */
+				priv->next_scan_jiffies = jiffies +
+					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
+
 				priv->assoc_id = (~((1 << 15) | (1 << 14)) &
 						  le16_to_cpu(mgnt->u.
 							      assoc_resp.aid));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 6f097a0..ca80b82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -754,6 +754,7 @@ struct iwl3945_priv {
 
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
+	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 56d0134..f65fd6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3840,6 +3840,8 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
 	}
 }
 
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
+
 /* Called for REPLY_4965_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
@@ -4011,6 +4013,12 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 				struct ieee80211_mgmt *mgnt =
 					(struct ieee80211_mgmt *)header;
 
+				/* We have just associated, give some
+				 * time for the 4-way handshake if
+				 * any. Don't start scan too early. */
+				priv->next_scan_jiffies = jiffies +
+					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
+
 				priv->assoc_id = (~((1 << 15) | (1 << 14))
 					& le16_to_cpu(mgnt->u.assoc_resp.aid));
 				priv->assoc_capability =
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index dd62db6..2c27997 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1085,6 +1085,7 @@ struct iwl4965_priv {
 
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
+	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1808464..4c2b037 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2800,7 +2800,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
-	if (!iwl3945_is_associated(priv) &&
+	/* drop all data frame if we are not associated */
+	if (!iwl3945_is_associated(priv) && !priv->assoc_id &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
@@ -3737,6 +3738,7 @@ static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 					(priv->last_scan_jiffies, jiffies)));
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
@@ -3779,6 +3781,7 @@ static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
 	}
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 	IWL_DEBUG_INFO("Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
@@ -6798,6 +6801,8 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+#define IWL_DELAY_NEXT_SCAN (HZ*2)
+
 static void iwl3945_bg_post_associate(struct work_struct *data)
 {
 	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv,
@@ -6898,6 +6903,8 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 #ifdef CONFIG_IWL3945_QOS
 	iwl3945_activate_qos(priv, 0);
 #endif /* CONFIG_IWL3945_QOS */
+	/* we have just associated, don't start scan too early */
+	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7352,7 +7359,6 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
 static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
@@ -7376,16 +7382,20 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 		goto out_unlock;
 	}
 
+	/* we don't schedule scan within next_scan_jiffies period */
+	if (priv->next_scan_jiffies &&
+			time_after(priv->next_scan_jiffies, jiffies)) {
+		rc = -EAGAIN;
+		goto out_unlock;
+	}
 	/* if we just finished scan ask for delay */
-	if (priv->last_scan_jiffies &&
-	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN,
-		       jiffies)) {
+	if (priv->last_scan_jiffies && time_after(priv->last_scan_jiffies +
+				IWL_DELAY_NEXT_SCAN, jiffies)) {
 		rc = -EAGAIN;
 		goto out_unlock;
 	}
 	if (len) {
-		IWL_DEBUG_SCAN("direct scan for  "
-			       "%s [%d]\n ",
+		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
 			       iwl3945_escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1a9dada..e9cdf70 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2921,7 +2921,8 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
-	if (!iwl4965_is_associated(priv) &&
+	/* drop all data frame if we are not associated */
+	if (!iwl4965_is_associated(priv) && !priv->assoc_id &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl4965_is_associated\n");
 		goto drop_unlock;
@@ -4071,6 +4072,7 @@ static void iwl4965_rx_scan_results_notif(struct iwl4965_priv *priv,
 					(priv->last_scan_jiffies, jiffies)));
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
@@ -4113,6 +4115,7 @@ static void iwl4965_rx_scan_complete_notif(struct iwl4965_priv *priv,
 	}
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 	IWL_DEBUG_INFO("Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
@@ -7230,6 +7233,8 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+#define IWL_DELAY_NEXT_SCAN (HZ*2)
+
 static void iwl4965_bg_post_associate(struct work_struct *data)
 {
 	struct iwl4965_priv *priv = container_of(data, struct iwl4965_priv,
@@ -7340,6 +7345,8 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 #ifdef CONFIG_IWL4965_QOS
 	iwl4965_activate_qos(priv, 0);
 #endif /* CONFIG_IWL4965_QOS */
+	/* we have just associated, don't start scan too early */
+	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7830,7 +7837,6 @@ static void iwl4965_mac_erp_ie_changed(struct ieee80211_hw *hw,
 		iwl4965_send_rxon_assoc(priv);
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
 static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
@@ -7854,16 +7860,20 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 		goto out_unlock;
 	}
 
+	/* we don't schedule scan within next_scan_jiffies period */
+	if (priv->next_scan_jiffies &&
+			time_after(priv->next_scan_jiffies, jiffies)) {
+		rc = -EAGAIN;
+		goto out_unlock;
+	}
 	/* if we just finished scan ask for delay */
-	if (priv->last_scan_jiffies &&
-	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN,
-		       jiffies)) {
+	if (priv->last_scan_jiffies && time_after(priv->last_scan_jiffies +
+				IWL_DELAY_NEXT_SCAN, jiffies)) {
 		rc = -EAGAIN;
 		goto out_unlock;
 	}
 	if (len) {
-		IWL_DEBUG_SCAN("direct scan for  "
-			       "%s [%d]\n ",
+		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
 			       iwl4965_escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
