Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FUSGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/9] iwlwifi: return ucode errors from station management
Date: Mon, 21 Jun 2010 11:06:34 -0700
Message-Id: <1277143600-32554-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When station management calls to ucode return
an error we could previously do nothing, but
now that almost all calls are synchronous we
can actually let the error bubble up. Use EIO
as the error as it best indicates a problem
with the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d39bfac..6a9cd08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -55,18 +55,19 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 	}
 }
 
-static void iwl_process_add_sta_resp(struct iwl_priv *priv,
-				     struct iwl_addsta_cmd *addsta,
-				     struct iwl_rx_packet *pkt,
-				     bool sync)
+static int iwl_process_add_sta_resp(struct iwl_priv *priv,
+				    struct iwl_addsta_cmd *addsta,
+				    struct iwl_rx_packet *pkt,
+				    bool sync)
 {
 	u8 sta_id = addsta->sta.sta_id;
 	unsigned long flags;
+	int ret = -EIO;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			pkt->hdr.flags);
-		return;
+		return ret;
 	}
 
 	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
@@ -78,6 +79,7 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 	case ADD_STA_SUCCESS_MSK:
 		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
 		iwl_sta_ucode_activate(priv, sta_id);
+		ret = 0;
 		break;
 	case ADD_STA_NO_ROOM_IN_TABLE:
 		IWL_ERR(priv, "Adding station %d failed, no room in table.\n",
@@ -115,6 +117,8 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 		       STA_CONTROL_MODIFY_MSK ? "Modified" : "Added",
 		       addsta->sta.addr);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
 }
 
 static void iwl_add_sta_callback(struct iwl_priv *priv,
@@ -159,7 +163,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 	if (ret == 0) {
 		pkt = (struct iwl_rx_packet *)cmd.reply_page;
-		iwl_process_add_sta_resp(priv, sta, pkt, true);
+		ret = iwl_process_add_sta_resp(priv, sta, pkt, true);
 	}
 	iwl_free_pages(priv, cmd.reply_page);
 
-- 
1.7.0.4

