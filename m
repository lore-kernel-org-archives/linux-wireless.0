Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbbHDU67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/37] iwlwifi: dvm: remove ADD_STA prints relying on station ID
Date: Tue,  4 Aug 2015 23:42:59 +0300
Message-Id: <1438721007-23283-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230041_419454_A6D822F4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This makes the logging a little less useful, but as they're mostly
synchronous commands it won't matter much. It gets rid of the
dependency on the input command, which this is the only user of.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 346077f..6e1e23e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -61,11 +61,9 @@ static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 }
 
 static int iwl_process_add_sta_resp(struct iwl_priv *priv,
-				    struct iwl_addsta_cmd *addsta,
 				    struct iwl_rx_packet *pkt)
 {
 	struct iwl_add_sta_resp *add_sta_resp = (void *)pkt->data;
-	u8 sta_id = addsta->sta.sta_id;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
@@ -73,8 +71,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		return 0;
 	}
 
-	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
-		       sta_id);
+	IWL_DEBUG_INFO(priv, "Processing response for adding station\n");
 
 	spin_lock_bh(&priv->sta_lock);
 
@@ -83,16 +80,14 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
 		break;
 	case ADD_STA_NO_ROOM_IN_TABLE:
-		IWL_ERR(priv, "Adding station %d failed, no room in table.\n",
-			sta_id);
+		IWL_ERR(priv, "Adding station failed, no room in table.\n");
 		break;
 	case ADD_STA_NO_BLOCK_ACK_RESOURCE:
-		IWL_ERR(priv, "Adding station %d failed, no block ack "
-			"resource.\n", sta_id);
+		IWL_ERR(priv,
+			"Adding station failed, no block ack resource.\n");
 		break;
 	case ADD_STA_MODIFY_NON_EXIST_STA:
-		IWL_ERR(priv, "Attempting to modify non-existing station %d\n",
-			sta_id);
+		IWL_ERR(priv, "Attempting to modify non-existing station\n");
 		break;
 	default:
 		IWL_DEBUG_ASSOC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
@@ -100,23 +95,6 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		break;
 	}
 
-	IWL_DEBUG_INFO(priv, "%s station id %u addr %pM\n",
-		       priv->stations[sta_id].sta.mode ==
-		       STA_CONTROL_MODIFY_MSK ?  "Modified" : "Added",
-		       sta_id, priv->stations[sta_id].sta.sta.addr);
-
-	/*
-	 * XXX: The MAC address in the command buffer is often changed from
-	 * the original sent to the device. That is, the MAC address
-	 * written to the command buffer often is not the same MAC address
-	 * read from the command buffer when the command returns. This
-	 * issue has not yet been resolved and this debugging is left to
-	 * observe the problem.
-	 */
-	IWL_DEBUG_INFO(priv, "%s station according to cmd buffer %pM\n",
-		       priv->stations[sta_id].sta.mode ==
-		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
-		       addsta->sta.addr);
 	spin_unlock_bh(&priv->sta_lock);
 
 	return 0;
@@ -130,7 +108,7 @@ int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	if (!cmd)
 		return 0;
 
-	return iwl_process_add_sta_resp(priv, (void *)cmd->payload, pkt);
+	return iwl_process_add_sta_resp(priv, pkt);
 }
 
 int iwl_send_add_sta(struct iwl_priv *priv,
-- 
2.1.4

