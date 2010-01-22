Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0AVWXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/17] iwlwifi: cleanup station adding code
Date: Fri, 22 Jan 2010 14:22:48 -0800
Message-Id: <1264198978-5915-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The work done when a station is added is very similar whether the station
is added synchronously or asynchronously. Centralize this work. At the same
time increase the status flags being checked for when the command returns
with accompanying debug messages. Also increase checking when setting the
"ucode active" state with accompanying debugging.

This work is done in preparation for station notification support.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |  114 ++++++++++++++++++++++----------
 1 files changed, 78 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 8afa39b..842f156 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -80,46 +80,103 @@ int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 }
 EXPORT_SYMBOL(iwl_get_ra_sta_id);
 
+/* priv->sta_lock must be held */
 static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
-		IWL_ERR(priv, "ACTIVATE a non DRIVER active station %d\n",
-			sta_id);
+		IWL_ERR(priv, "ACTIVATE a non DRIVER active station id %u addr %pM\n",
+			sta_id, priv->stations[sta_id].sta.sta.addr);
 
-	priv->stations[sta_id].used |= IWL_STA_UCODE_ACTIVE;
-	IWL_DEBUG_ASSOC(priv, "Added STA to Ucode: %pM\n",
-			priv->stations[sta_id].sta.sta.addr);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	if (priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE) {
+		IWL_DEBUG_ASSOC(priv,
+				"STA id %u addr %pM already present in uCode (according to driver)\n",
+				sta_id, priv->stations[sta_id].sta.sta.addr);
+	} else {
+		priv->stations[sta_id].used |= IWL_STA_UCODE_ACTIVE;
+		IWL_DEBUG_ASSOC(priv, "Added STA id %u addr %pM to uCode\n",
+				sta_id, priv->stations[sta_id].sta.sta.addr);
+	}
 }
 
-static void iwl_add_sta_callback(struct iwl_priv *priv,
-				 struct iwl_device_cmd *cmd,
-				 struct iwl_rx_packet *pkt)
+static void iwl_process_add_sta_resp(struct iwl_priv *priv,
+				     struct iwl_addsta_cmd *addsta,
+				     struct iwl_rx_packet *pkt,
+				     bool sync)
 {
-	struct iwl_addsta_cmd *addsta =
-		(struct iwl_addsta_cmd *)cmd->cmd.payload;
 	u8 sta_id = addsta->sta.sta_id;
+	unsigned long flags;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  pkt->hdr.flags);
+			pkt->hdr.flags);
 		return;
 	}
 
+	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
+		       sta_id);
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
+		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
 		iwl_sta_ucode_activate(priv, sta_id);
-		 /* fall through */
+		break;
+	case ADD_STA_NO_ROOM_IN_TABLE:
+		IWL_ERR(priv, "Adding station %d failed, no room in table.\n",
+			sta_id);
+		break;
+	case ADD_STA_NO_BLOCK_ACK_RESOURCE:
+		IWL_ERR(priv, "Adding station %d failed, no block ack resource.\n",
+			sta_id);
+		break;
+	case ADD_STA_MODIFY_NON_EXIST_STA:
+		IWL_ERR(priv, "Attempting to modify non-existing station %d \n",
+			sta_id);
+		break;
 	default:
-		IWL_DEBUG_HC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
-			     pkt->u.add_sta.status);
+		IWL_DEBUG_ASSOC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
+				pkt->u.add_sta.status);
 		break;
 	}
+
+	IWL_DEBUG_INFO(priv, "%s station id %u addr %pM\n",
+		       priv->stations[sta_id].sta.mode ==
+		       STA_CONTROL_MODIFY_MSK ?  "Modified" : "Added",
+		       sta_id, priv->stations[sta_id].sta.sta.addr);
+
+	/*
+	 * XXX: The MAC address in the command buffer is often changed from
+	 * the original sent to the device. That is, the MAC address
+	 * written to the command buffer often is not the same MAC adress
+	 * read from the command buffer when the command returns. This
+	 * issue has not yet been resolved and this debugging is left to
+	 * observe the problem.
+	 */
+	IWL_DEBUG_INFO(priv, "%s station according to cmd buffer %pM\n",
+		       priv->stations[sta_id].sta.mode ==
+		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
+		       addsta->sta.addr);
+
+	/*
+	 * Determine if we wanted to modify or add a station,
+	 * if adding a station succeeded we have some more initialization
+	 * to do when using station notification. TODO
+	 */
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+}
+
+static void iwl_add_sta_callback(struct iwl_priv *priv,
+				 struct iwl_device_cmd *cmd,
+				 struct iwl_rx_packet *pkt)
+{
+	struct iwl_addsta_cmd *addsta =
+		(struct iwl_addsta_cmd *)cmd->cmd.payload;
+
+	iwl_process_add_sta_resp(priv, addsta, pkt, false);
+
 }
 
 int iwl_send_add_sta(struct iwl_priv *priv,
@@ -145,24 +202,9 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
 
-	pkt = (struct iwl_rx_packet *)cmd.reply_page;
-	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  pkt->hdr.flags);
-		ret = -EIO;
-	}
-
 	if (ret == 0) {
-		switch (pkt->u.add_sta.status) {
-		case ADD_STA_SUCCESS_MSK:
-			iwl_sta_ucode_activate(priv, sta->sta.sta_id);
-			IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
-			break;
-		default:
-			ret = -EIO;
-			IWL_WARN(priv, "REPLY_ADD_STA failed\n");
-			break;
-		}
+		pkt = (struct iwl_rx_packet *)cmd.reply_page;
+		iwl_process_add_sta_resp(priv, sta, pkt, true);
 	}
 	iwl_free_pages(priv, cmd.reply_page);
 
-- 
1.6.3.3

