Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761542AbXLPW6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:41 -0500
Subject: [PATCH 109/48] libertas: kill pdata_buf member of struct cmd_ctrl_node
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42S7-00038a-OL@shinybook.infradead.org> (sfid-20071216_232741_677657_8A78F592)
Date: Sun, 16 Dec 2007 17:59:19 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 02:38:17 -0500

We can use the callback_arg for it; that's the way we're heading anyway...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    4 +---
 drivers/net/wireless/libertas/cmdresp.c |   26 +++++++++++++-------------
 drivers/net/wireless/libertas/hostcmd.h |    1 -
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index e7f07c3..f2e027b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1280,7 +1280,6 @@ static void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 	if (!cmdnode)
 		goto out;
 
-	cmdnode->pdata_buf = NULL;
 	cmdnode->callback = NULL;
 	cmdnode->callback_arg = 0;
 
@@ -1801,9 +1800,8 @@ static void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 	if (!ptempnode)
 		return;
 
-	ptempnode->pdata_buf = pdata_buf;
 	ptempnode->callback = NULL;
-	ptempnode->callback_arg = 0;
+	ptempnode->callback_arg = (unsigned long)pdata_buf;
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 89f8316..4c22e78 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -399,13 +399,13 @@ static int lbs_ret_802_11_enable_rsn(struct lbs_private *priv,
                                           struct cmd_ds_command *resp)
 {
 	struct cmd_ds_802_11_enable_rsn *enable_rsn = &resp->params.enbrsn;
-	u32 * pdata_buf = priv->cur_cmd->pdata_buf;
+	uint32_t * pdata_buf = (uint32_t *)priv->cur_cmd->callback_arg;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	if (enable_rsn->action == cpu_to_le16(CMD_ACT_GET)) {
 		if (pdata_buf)
-			*pdata_buf = (u32) le16_to_cpu(enable_rsn->enable);
+			*pdata_buf = (uint32_t) le16_to_cpu(enable_rsn->enable);
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -435,7 +435,7 @@ static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
 	struct cmd_ds_802_11_subscribe_event *cmd_event =
 		&resp->params.subscribe_event;
 	struct cmd_ds_802_11_subscribe_event *dst_event =
-		priv->cur_cmd->pdata_buf;
+		(void *)priv->cur_cmd->callback_arg;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -505,7 +505,7 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_SET_AFC):
 	case CMD_RET(CMD_802_11_GET_AFC):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove(priv->cur_cmd->pdata_buf, &resp->params.afc,
+		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.afc,
 			sizeof(struct cmd_ds_802_11_afc));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -557,20 +557,20 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		break;
 	case CMD_RET(CMD_802_11_INACTIVITY_TIMEOUT):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		*((u16 *) priv->cur_cmd->pdata_buf) =
+		*((uint16_t *) priv->cur_cmd->callback_arg) =
 		    le16_to_cpu(resp->params.inactivity_timeout.timeout);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove(priv->cur_cmd->pdata_buf, &resp->params.tpccfg,
+		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
 			sizeof(struct cmd_ds_802_11_tpc_cfg));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_802_11_LED_GPIO_CTRL):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove(priv->cur_cmd->pdata_buf, &resp->params.ledgpio,
+		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.ledgpio,
 			sizeof(struct cmd_ds_802_11_led_ctrl));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
@@ -580,7 +580,7 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 	case CMD_RET(CMD_802_11_PWR_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove(priv->cur_cmd->pdata_buf, &resp->params.pwrcfg,
+		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.pwrcfg,
 			sizeof(struct cmd_ds_802_11_pwr_cfg));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 
@@ -588,21 +588,21 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 	case CMD_RET(CMD_GET_TSF):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		memcpy(priv->cur_cmd->pdata_buf,
+		memcpy((void *)priv->cur_cmd->callback_arg,
 		       &resp->params.gettsf.tsfvalue, sizeof(u64));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_BT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		if (priv->cur_cmd->pdata_buf)
-			memcpy(priv->cur_cmd->pdata_buf,
+		if (priv->cur_cmd->callback_arg)
+			memcpy((void *)priv->cur_cmd->callback_arg,
 			       &resp->params.bt.addr1, 2 * ETH_ALEN);
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 	case CMD_RET(CMD_FWT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
-		if (priv->cur_cmd->pdata_buf)
-			memcpy(priv->cur_cmd->pdata_buf, &resp->params.fwt,
+		if (priv->cur_cmd->callback_arg)
+			memcpy((void *)priv->cur_cmd->callback_arg, &resp->params.fwt,
 			       sizeof(resp->params.fwt));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 1b31250..719da73 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -75,7 +75,6 @@ struct cmd_header {
 struct cmd_ctrl_node {
 	struct list_head list;
 	/* command response */
-	void *pdata_buf;
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *);
 	unsigned long callback_arg;
 	/* command data */
-- 
1.5.3.4

