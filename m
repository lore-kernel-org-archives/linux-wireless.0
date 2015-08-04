Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbbHDU67 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:59 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/37] iwlwifi: dvm: move ADD_STA response handling to sync command
Date: Tue,  4 Aug 2015 23:42:58 +0300
Message-Id: <1438721007-23283-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230715_812817_C95AA422)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This driver currently has some very confusing ADD_STA response handling
that runs asynchronously in the background for all of the commands, but
is only really necessary for synchronous ones (the really asynchronous
ones can only be done for already existing stations), and for the sync
ones it actually waits for the RX handler to return a status code.

Rework this to keep the debug printing in the handler, but do the code
that's supposed to have an effect only for sync commands in the command
sending function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 6ec86ad..346077f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -66,12 +66,11 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 {
 	struct iwl_add_sta_resp *add_sta_resp = (void *)pkt->data;
 	u8 sta_id = addsta->sta.sta_id;
-	int ret = -EIO;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			pkt->hdr.flags);
-		return ret;
+		return 0;
 	}
 
 	IWL_DEBUG_INFO(priv, "Processing response for adding station %u\n",
@@ -82,7 +81,6 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	switch (add_sta_resp->status) {
 	case ADD_STA_SUCCESS_MSK:
 		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
-		ret = iwl_sta_ucode_activate(priv, sta_id);
 		break;
 	case ADD_STA_NO_ROOM_IN_TABLE:
 		IWL_ERR(priv, "Adding station %d failed, no room in table.\n",
@@ -121,7 +119,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		       addsta->sta.addr);
 	spin_unlock_bh(&priv->sta_lock);
 
-	return ret;
+	return 0;
 }
 
 int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
@@ -146,6 +144,8 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		.len = { sizeof(*sta), },
 	};
 	u8 sta_id __maybe_unused = sta->sta.sta_id;
+	struct iwl_rx_packet *pkt;
+	struct iwl_add_sta_resp *add_sta_resp;
 
 	IWL_DEBUG_INFO(priv, "Adding sta %u (%pM) %ssynchronously\n",
 		       sta_id, sta->sta.addr, flags & CMD_ASYNC ?  "a" : "");
@@ -159,16 +159,23 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
-	/*else the command was successfully sent in SYNC mode, need to free
-	 * the reply page */
 
-	iwl_free_resp(&cmd);
+	pkt = cmd.resp_pkt;
+	add_sta_resp = (void *)pkt->data;
 
-	if (cmd.handler_status)
-		IWL_ERR(priv, "%s - error in the CMD response %d\n", __func__,
-			cmd.handler_status);
+	/* debug messages are printed in the handler */
+	if (!(pkt->hdr.flags & IWL_CMD_FAILED_MSK) &&
+	    add_sta_resp->status == ADD_STA_SUCCESS_MSK) {
+		spin_lock_bh(&priv->sta_lock);
+		ret = iwl_sta_ucode_activate(priv, sta_id);
+		spin_unlock_bh(&priv->sta_lock);
+	} else {
+		ret = -EIO;
+	}
+
+	iwl_free_resp(&cmd);
 
-	return cmd.handler_status;
+	return ret;
 }
 
 bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
-- 
2.1.4

