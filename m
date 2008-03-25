Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbYCYXdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/6] iwlwifi: allow a default callback for ASYNC host commands
Date: Tue, 25 Mar 2008 16:33:40 -0700
Message-Id: <1206488021-4193-6-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233413_456117_71A28213)
In-Reply-To: <1206488021-4193-5-git-send-email-reinette.chatre@intel.com>
References: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-3-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-4-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch provides a default callback for ASYNC host commands instead
of calling to BUG_ON. Most of the callbacks are now just empty functions

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 559ff73..51c9949 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -97,6 +97,31 @@ EXPORT_SYMBOL(get_cmd_string);
 
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
 
+static int iwl_generic_cmd_callback(struct iwl_priv *priv,
+				    struct iwl_cmd *cmd, struct sk_buff *skb)
+{
+	struct iwl4965_rx_packet *pkt = NULL;
+
+	if (!skb) {
+		IWL_ERROR("Error: Response NULL in %s.\n",
+				get_cmd_string(cmd->hdr.cmd));
+		return 1;
+	}
+
+	pkt = (struct iwl4965_rx_packet *)skb->data;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from %s (0x%08X)\n",
+			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+		return 1;
+	}
+
+	IWL_DEBUG_HC("back from %s (0x%08X)\n",
+			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
+
+	/* Let iwl_tx_complete free the response skb */
+	return 1;
+}
+
 static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
@@ -106,8 +131,9 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	/* An asynchronous command can not expect an SKB to be set. */
 	BUG_ON(cmd->meta.flags & CMD_WANT_SKB);
 
-	/* An asynchronous command MUST have a callback. */
-	BUG_ON(!cmd->meta.u.callback);
+	/* Assign a generic callback if one is not provided */
+	if (!cmd->meta.u.callback)
+		cmd->meta.u.callback = iwl_generic_cmd_callback;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EBUSY;
-- 
1.5.3.4

