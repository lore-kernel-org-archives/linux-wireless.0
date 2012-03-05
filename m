Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122Ab2CEUiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 20/33] iwlwifi: pass response packet directly
Date: Mon,  5 Mar 2012 11:24:38 -0800
Message-Id: <1330975491-19680-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213859_544061_9364A22D)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When CMD_WANT_SKB is set for a (synchronous)
command, the response is passed back to the
caller which is then responsible for freeing
it. Make this more abstract with real API,
passing directly the response packet in the
new cmd.resp_pkt member and also introduce
iwl_free_resp() to free the pages -- this
way the upper layers don't have to directly
touch the page implementation.

NOTE: This breaks IDI -- the new code isn't reflected there yet!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    5 -----
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   16 ++++++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   13 +++++++++++--
 6 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 7a713ba..9ef8da4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -160,7 +160,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	/*else the command was successfully sent in SYNC mode, need to free
 	 * the reply page */
 
-	iwl_free_pages(priv->shrd, cmd.reply_page);
+	iwl_free_resp(&cmd);
 
 	if (cmd.handler_status)
 		IWL_ERR(priv, "%s - error in the CMD response %d", __func__,
@@ -415,7 +415,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	if (ret)
 		return ret;
 
-	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	pkt = cmd.resp_pkt;
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 			  pkt->hdr.flags);
@@ -438,7 +438,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 			break;
 		}
 	}
-	iwl_free_pages(priv->shrd, cmd.reply_page);
+	iwl_free_resp(&cmd);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 766572b..c0fc368 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -76,7 +76,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	if (ret)
 		return ret;
 
-	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	pkt = cmd.resp_pkt;
 	if (pkt->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -88,7 +88,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		ret = -EIO;
 	}
 
-	iwl_free_pages(priv->shrd, cmd.reply_page);
+	iwl_free_resp(&cmd);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a7dbcab..53244d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -413,11 +413,6 @@ static inline bool iwl_have_debug_level(u32 level)
 	return iwlagn_mod_params.debug_level & level;
 }
 
-static inline void iwl_free_pages(struct iwl_shared *shrd, unsigned long page)
-{
-	free_pages(page, shrd->hw_params.rx_page_order);
-}
-
 /**
  * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
  * @index -- current index
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 23eea06..cc1f3e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -292,7 +292,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 		return ret;
 
 	/* Handling return of SKB to the user */
-	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	pkt = cmd.resp_pkt;
 	if (!pkt) {
 		IWL_ERR(priv, "HCMD received a null response packet\n");
 		return ret;
@@ -309,7 +309,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	/* The reply is in a page, that we cannot send to user space. */
 	memcpy(reply_buf, &(pkt->hdr), reply_len);
-	iwl_free_pages(priv->shrd, cmd.reply_page);
+	iwl_free_resp(&cmd);
 
 	NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT);
 	NLA_PUT(skb, IWL_TM_ATTR_UCODE_RX_PKT, reply_len, reply_buf);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index de2a0d9..771fae2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -879,9 +879,13 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
-		meta->source->handler_status = handler_status;
+		struct page *p = rxb->page;
+
 		rxb->page = NULL;
+		meta->source->resp_pkt = pkt;
+		meta->source->_rx_page_addr = (unsigned long)page_address(p);
+		meta->source->_rx_page_order = hw_params(trans).rx_page_order;
+		meta->source->handler_status = handler_status;
 	}
 
 	iwl_hcmd_queue_reclaim(trans, txq_id, index);
@@ -985,7 +989,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		}
 	}
 
-	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
+	if ((cmd->flags & CMD_WANT_SKB) && !cmd->resp_pkt) {
 		IWL_ERR(trans, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
@@ -1006,9 +1010,9 @@ cancel:
 							~CMD_WANT_SKB;
 	}
 
-	if (cmd->reply_page) {
-		iwl_free_pages(trans->shrd, cmd->reply_page);
-		cmd->reply_page = 0;
+	if (cmd->resp_pkt) {
+		iwl_free_resp(cmd);
+		cmd->resp_pkt = NULL;
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 83f04c9..e8ab8d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -173,7 +173,9 @@ enum iwl_hcmd_dataflag {
  * struct iwl_host_cmd - Host command to the uCode
  *
  * @data: array of chunks that composes the data of the host command
- * @reply_page: pointer to the page that holds the response to the host command
+ * @resp_pkt: response packet, if %CMD_WANT_SKB was set
+ * @_rx_page_order: (internally used to free response packet)
+ * @_rx_page_addr: (internally used to free response packet)
  * @handler_status: return value of the handler of the command
  *	(put in setup_rx_handlers) - valid for SYNC mode only
  * @flags: can be CMD_*
@@ -183,7 +185,9 @@ enum iwl_hcmd_dataflag {
  */
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TFDS];
-	unsigned long reply_page;
+	struct iwl_rx_packet *resp_pkt;
+	unsigned long _rx_page_addr;
+	u32 _rx_page_order;
 	int handler_status;
 
 	u32 flags;
@@ -192,6 +196,11 @@ struct iwl_host_cmd {
 	u8 id;
 };
 
+static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
+{
+	free_pages(cmd->_rx_page_addr, cmd->_rx_page_order);
+}
+
 /**
  * struct iwl_trans_ops - transport specific operations
  *
-- 
1.7.0.4

