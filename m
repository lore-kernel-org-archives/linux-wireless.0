Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYE2Ihj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 18/43] iwlwifi: move add sta handler to iwl-sta.c
Date: Thu, 29 May 2008 16:35:03 +0800
Message-Id: <1212050128-17132-19-git-send-email-yi.zhu@intel.com> (sfid-20080529_110545_306844_C47A87B8)
In-Reply-To: <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves add_sta hander to iwl-sta.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   37 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 -------
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 11ec408..ed07566 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -74,6 +74,39 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 }
 EXPORT_SYMBOL(iwl_find_station);
 
+static int iwl_add_sta_callback(struct iwl_priv *priv,
+				   struct iwl_cmd *cmd, struct sk_buff *skb)
+{
+	struct iwl_rx_packet *res = NULL;
+
+	if (!skb) {
+		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
+		return 1;
+	}
+
+	res = (struct iwl_rx_packet *)skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+			  res->hdr.flags);
+		return 1;
+	}
+
+	switch (res->u.add_sta.status) {
+	case ADD_STA_SUCCESS_MSK:
+		/* FIXME: implement iwl_sta_ucode_activate(priv, addr); */
+		/* fail through */
+	default:
+		IWL_DEBUG_HC("Received REPLY_ADD_STA:(0x%08X)\n",
+			     res->u.add_sta.status);
+		break;
+	}
+
+	/* We didn't cache the SKB; let the caller free it */
+	return 1;
+}
+
+
+
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
@@ -86,7 +119,9 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		.data = data,
 	};
 
-	if (!(flags & CMD_ASYNC))
+	if (flags & CMD_ASYNC)
+		cmd.meta.u.callback = iwl_add_sta_callback;
+	else
 		cmd.meta.flags |= CMD_WANT_SKB;
 
 	cmd.len = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 185d667..f3815b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1921,15 +1921,6 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		IWL_WARNING("uCode did not respond OK.\n");
 }
 
-static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
-				     struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-
-	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
-	return;
-}
-
 static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb)
 {
@@ -2238,7 +2229,6 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
-	priv->rx_handlers[REPLY_ADD_STA] = iwl4965_rx_reply_add_sta;
 	priv->rx_handlers[REPLY_ERROR] = iwl4965_rx_reply_error;
 	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl4965_rx_csa;
 	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-- 
1.5.3.6

