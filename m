Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037AbXK2DLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 33/36] iwlwifi: enhance WPA authenication stability
Date: Thu, 29 Nov 2007 11:10:13 +0800
Message-Id: <1196305816-23023-34-git-send-email-yi.zhu@intel.com> (sfid-20071129_033543_553998_4538ED38)
In-Reply-To: <1196305816-23023-33-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-28-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-29-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-30-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-31-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-33-git-send-email-yi.zhu@intel.com>
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
index 51b9030..1b81545 100644
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
index 75cef3e..1f82061 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -752,6 +752,7 @@ struct iwl3945_priv {
 
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
+	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 40c795e..c8e7adf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3802,6 +3802,8 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
 	}
 }
 
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
+
 /* Called for REPLY_4965_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
@@ -3973,6 +3975,12 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
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
index 2930c10..c062738 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1082,6 +1082,7 @@ struct iwl4965_priv {
 
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
+	unsigned long next_scan_jiffies;
 	unsigned long scan_start;
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a892e26..82e4e1c 100644
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
 
@@ -7327,7 +7334,6 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
 static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
@@ -7351,16 +7357,20 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
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
index 31601d7..f806e70 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2905,7 +2905,8 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
-	if (!iwl4965_is_associated(priv) &&
+	/* drop all data frame if we are not associated */
+	if (!iwl4965_is_associated(priv) && !priv->assoc_id &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl4965_is_associated\n");
 		goto drop_unlock;
@@ -4055,6 +4056,7 @@ static void iwl4965_rx_scan_results_notif(struct iwl4965_priv *priv,
 					(priv->last_scan_jiffies, jiffies)));
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
@@ -4097,6 +4099,7 @@ static void iwl4965_rx_scan_complete_notif(struct iwl4965_priv *priv,
 	}
 
 	priv->last_scan_jiffies = jiffies;
+	priv->next_scan_jiffies = 0;
 	IWL_DEBUG_INFO("Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
@@ -7220,6 +7223,8 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+#define IWL_DELAY_NEXT_SCAN (HZ*2)
+
 static void iwl4965_bg_post_associate(struct work_struct *data)
 {
 	struct iwl4965_priv *priv = container_of(data, struct iwl4965_priv,
@@ -7335,6 +7340,8 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 #ifdef CONFIG_IWL4965_QOS
 	iwl4965_activate_qos(priv, 0);
 #endif /* CONFIG_IWL4965_QOS */
+	/* we have just associated, don't start scan too early */
+	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7801,7 +7808,6 @@ static void iwl4965_mac_erp_ie_changed(struct ieee80211_hw *hw,
 		iwl4965_send_rxon_assoc(priv);
 }
 
-#define IWL_DELAY_NEXT_SCAN (HZ*2)
 static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
@@ -7825,16 +7831,20 @@ static int iwl4965_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
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
1.5.3.6
