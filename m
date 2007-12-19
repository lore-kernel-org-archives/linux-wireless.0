Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:44866 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXLSQKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:17 -0500
Subject: [PATCH 128/48] libertas: convert INACTIVITY_TIMEOUT to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vA-00021Y-Bp@pmac.infradead.org> (sfid-20071219_161021_519486_DA5682CF)
Date: Wed, 19 Dec 2007 15:33:20 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 23:04:37 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   34 ++++++++++++++----------------
 drivers/net/wireless/libertas/cmd.h     |    3 ++
 drivers/net/wireless/libertas/cmdresp.c |    7 ------
 drivers/net/wireless/libertas/hostcmd.h |    3 +-
 4 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 3a7b82f..57d1707 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -171,27 +171,30 @@ static int lbs_cmd_802_11_ps_mode(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
-					      struct cmd_ds_command *cmd,
-					      u16 cmd_action, void *pdata_buf)
+int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
+				      uint16_t cmd_action, uint16_t *timeout)
 {
-	u16 *timeout = pdata_buf;
+	struct cmd_ds_802_11_inactivity_timeout cmd;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->command = cpu_to_le16(CMD_802_11_INACTIVITY_TIMEOUT);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_inactivity_timeout)
-			     + S_DS_GEN);
+	cmd.hdr.command = cpu_to_le16(CMD_802_11_INACTIVITY_TIMEOUT);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
-	cmd->params.inactivity_timeout.action = cpu_to_le16(cmd_action);
+	cmd.action = cpu_to_le16(cmd_action);
 
-	if (cmd_action)
-		cmd->params.inactivity_timeout.timeout = cpu_to_le16(*timeout);
+	if (cmd_action == CMD_ACT_SET)
+		cmd.timeout = cpu_to_le16(*timeout);
 	else
-		cmd->params.inactivity_timeout.timeout = 0;
+		cmd.timeout = 0;
 
-	lbs_deb_leave(LBS_DEB_CMD);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_INACTIVITY_TIMEOUT, &cmd);
+
+	if (!ret)
+		*timeout = le16_to_cpu(cmd.timeout);
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return 0;
 }
 
@@ -1520,11 +1523,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	case CMD_802_11_SLEEP_PARAMS:
 		ret = lbs_cmd_802_11_sleep_params(priv, cmdptr, cmd_action);
 		break;
-	case CMD_802_11_INACTIVITY_TIMEOUT:
-		ret = lbs_cmd_802_11_inactivity_timeout(priv, cmdptr,
-							 cmd_action, pdata_buf);
-		lbs_set_cmd_ctrl_node(priv, cmdnode, pdata_buf);
-		break;
 
 	case CMD_802_11_TPC_CFG:
 		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index e334f0e..50821e7 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -47,4 +47,7 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
 int lbs_suspend(struct lbs_private *priv);
 int lbs_resume(struct lbs_private *priv);
 
+int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
+				      uint16_t cmd_action, uint16_t *timeout);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 7c9ffc5..f7fb8c7 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -554,13 +554,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_SLEEP_PARAMS):
 		ret = lbs_ret_802_11_sleep_params(priv, resp);
 		break;
-	case CMD_RET(CMD_802_11_INACTIVITY_TIMEOUT):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		*((uint16_t *) priv->cur_cmd->callback_arg) =
-		    le16_to_cpu(resp->params.inactivity_timeout.timeout);
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
-
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 8cc4d77..2ad32bc 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -378,6 +378,8 @@ struct cmd_ds_802_11_sleep_params {
 };
 
 struct cmd_ds_802_11_inactivity_timeout {
+	struct cmd_header hdr;
+
 	/* ACT_GET/ACT_SET */
 	__le16 action;
 
@@ -714,7 +716,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11d_domain_info domaininforesp;
 
 		struct cmd_ds_802_11_sleep_params sleep_params;
-		struct cmd_ds_802_11_inactivity_timeout inactivity_timeout;
 		struct cmd_ds_802_11_tpc_cfg tpccfg;
 		struct cmd_ds_802_11_pwr_cfg pwrcfg;
 		struct cmd_ds_802_11_afc afc;
-- 
1.5.3.4

