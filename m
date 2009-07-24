Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZGXSNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/14] iwlwifi: remove command callback return value
Date: Fri, 24 Jul 2009 11:13:06 -0700
Message-Id: <1248459194-10239-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

No existing callbacks use anything other than the return
value 1, which means that the caller should free the
reply skb, so it seems safer in terms of not introducing
memory leaks to simply remove the return value and let
the caller always free the skb.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   21 +++++++++------------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   26 ++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 6 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index b379382..8c29ded 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -79,11 +79,10 @@ static const struct {
 #define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /*Exclude Solid on*/
 #define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
 
-static int iwl3945_led_cmd_callback(struct iwl_priv *priv,
-				    struct iwl_device_cmd *cmd,
-				    struct sk_buff *skb)
+static void iwl3945_led_cmd_callback(struct iwl_priv *priv,
+				     struct iwl_device_cmd *cmd,
+				     struct sk_buff *skb)
 {
-	return 1;
 }
 
 static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4156deb..febcf76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -446,9 +446,9 @@ int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id,
 				  u16 len, const void *data);
 int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   const void *data,
-			   int (*callback)(struct iwl_priv *priv,
-					   struct iwl_device_cmd *cmd,
-					   struct sk_buff *skb));
+			   void (*callback)(struct iwl_priv *priv,
+					    struct iwl_device_cmd *cmd,
+					    struct sk_buff *skb));
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ce765f7..3ca188a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -163,9 +163,9 @@ struct iwl_cmd_meta {
 	 * invoked for SYNC commands, if it were and its result passed
 	 * through it would be simpler...)
 	 */
-	int (*callback)(struct iwl_priv *priv,
-			struct iwl_device_cmd *cmd,
-			struct sk_buff *skb);
+	void (*callback)(struct iwl_priv *priv,
+			 struct iwl_device_cmd *cmd,
+			 struct sk_buff *skb);
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
 	 * structure is stored at the end of the shared queue memory. */
@@ -383,9 +383,9 @@ struct iwl_device_cmd {
 struct iwl_host_cmd {
 	const void *data;
 	struct sk_buff *reply_skb;
-	int (*callback)(struct iwl_priv *priv,
-			struct iwl_device_cmd *cmd,
-			struct sk_buff *skb);
+	void (*callback)(struct iwl_priv *priv,
+			 struct iwl_device_cmd *cmd,
+			 struct sk_buff *skb);
 	u32 flags;
 	u16 len;
 	u8 id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index d8a3eac..b82ad15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -103,23 +103,23 @@ EXPORT_SYMBOL(get_cmd_string);
 
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
 
-static int iwl_generic_cmd_callback(struct iwl_priv *priv,
-				    struct iwl_device_cmd *cmd,
-				    struct sk_buff *skb)
+static void iwl_generic_cmd_callback(struct iwl_priv *priv,
+				     struct iwl_device_cmd *cmd,
+				     struct sk_buff *skb)
 {
 	struct iwl_rx_packet *pkt = NULL;
 
 	if (!skb) {
 		IWL_ERR(priv, "Error: Response NULL in %s.\n",
 				get_cmd_string(cmd->hdr.cmd));
-		return 1;
+		return;
 	}
 
 	pkt = (struct iwl_rx_packet *)skb->data;
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from %s (0x%08X)\n",
 			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-		return 1;
+		return;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -128,15 +128,12 @@ static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 	case SENSITIVITY_CMD:
 		IWL_DEBUG_HC_DUMP(priv, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
-				break;
+		break;
 	default:
 		IWL_DEBUG_HC(priv, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 	}
 #endif
-
-	/* Let iwl_tx_complete free the response skb */
-	return 1;
 }
 
 static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
@@ -275,9 +272,9 @@ EXPORT_SYMBOL(iwl_send_cmd_pdu);
 
 int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
 			   u8 id, u16 len, const void *data,
-			   int (*callback)(struct iwl_priv *priv,
-					   struct iwl_device_cmd *cmd,
-					   struct sk_buff *skb))
+			   void (*callback)(struct iwl_priv *priv,
+					    struct iwl_device_cmd *cmd,
+					    struct sk_buff *skb))
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 1571ace..79ea5cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -97,9 +97,9 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-static int iwl_add_sta_callback(struct iwl_priv *priv,
-				struct iwl_device_cmd *cmd,
-				struct sk_buff *skb)
+static void iwl_add_sta_callback(struct iwl_priv *priv,
+				 struct iwl_device_cmd *cmd,
+				 struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
 	struct iwl_addsta_cmd *addsta =
@@ -108,14 +108,14 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 
 	if (!skb) {
 		IWL_ERR(priv, "Error: Response NULL in REPLY_ADD_STA.\n");
-		return 1;
+		return;
 	}
 
 	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
-		return 1;
+		return;
 	}
 
 	switch (res->u.add_sta.status) {
@@ -127,9 +127,6 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 			     res->u.add_sta.status);
 		break;
 	}
-
-	/* We didn't cache the SKB; let the caller free it */
-	return 1;
 }
 
 int iwl_send_add_sta(struct iwl_priv *priv,
@@ -325,9 +322,9 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-static int iwl_remove_sta_callback(struct iwl_priv *priv,
-				   struct iwl_device_cmd *cmd,
-				   struct sk_buff *skb)
+static void iwl_remove_sta_callback(struct iwl_priv *priv,
+				    struct iwl_device_cmd *cmd,
+				    struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
 	struct iwl_rem_sta_cmd *rm_sta =
@@ -336,14 +333,14 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 
 	if (!skb) {
 		IWL_ERR(priv, "Error: Response NULL in REPLY_REMOVE_STA.\n");
-		return 1;
+		return;
 	}
 
 	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 		res->hdr.flags);
-		return 1;
+		return;
 	}
 
 	switch (res->u.rem_sta.status) {
@@ -354,9 +351,6 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 		IWL_ERR(priv, "REPLY_REMOVE_STA failed\n");
 		break;
 	}
-
-	/* We didn't cache the SKB; let the caller free it */
-	return 1;
 }
 
 static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 51ddbab..e1558db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1144,8 +1144,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	if (meta->flags & CMD_WANT_SKB) {
 		meta->source->reply_skb = rxb->skb;
 		rxb->skb = NULL;
-	} else if (meta->callback && !meta->callback(priv, cmd, rxb->skb))
-		rxb->skb = NULL;
+	} else if (meta->callback)
+		meta->callback(priv, cmd, rxb->skb);
 
 	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
-- 
1.5.6.3

