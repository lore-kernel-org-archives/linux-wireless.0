Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0G0SCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:02:22 -0400
Subject: [wt PATCH 10/16] libertas: convert CMD_FWT_ACCESS to a direct
 command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:03:46 -0700
Message-ID: <1280261026.19686.26.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Slightly different approach here since there are so many arguments to
the firmware command.  Just let the caller fill them in before pushing
the command to the firmware.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |    8 -------
 drivers/net/wireless/libertas/cmdresp.c |    9 --------
 drivers/net/wireless/libertas/host.h    |    3 +-
 drivers/net/wireless/libertas/mesh.c    |   34 ++++++++++++++++++------------
 drivers/net/wireless/libertas/mesh.h    |    6 +++-
 5 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index dd25b2a..2c96cf3 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1206,14 +1206,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_802_11_ps_mode(cmdptr, cmd_action);
 		break;
 
-#ifdef CONFIG_LIBERTAS_MESH
-
-	case CMD_FWT_ACCESS:
-		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
-		break;
-
-#endif
-
 	case CMD_802_11_DEEP_SLEEP:
 		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 098b645..26a30db 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -59,7 +59,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 {
 	struct cmd_ds_command *resp = (struct cmd_ds_command *) cmd_response;
 	int ret = 0;
-	unsigned long flags;
 	uint16_t respcmd = le16_to_cpu(resp->command);
 
 	lbs_deb_enter(LBS_DEB_HOST);
@@ -68,14 +67,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_FWT_ACCESS):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		if (priv->cur_cmd->callback_arg)
-			memcpy((void *)priv->cur_cmd->callback_arg, &resp->params.fwt,
-			       sizeof(resp->params.fwt));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
-
 	default:
 		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
 			   le16_to_cpu(resp->command));
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 99de232..ea041ac 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -912,6 +912,8 @@ struct cmd_ds_bt_access {
 } __attribute__ ((packed));
 
 struct cmd_ds_fwt_access {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le32 id;
 	u8 valid;
@@ -961,7 +963,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_fwt_access fwt;
 	} params;
 } __attribute__ ((packed));
 #endif
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index 35ee574..194762a 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -613,25 +613,31 @@ int lbs_mesh_bt_get_entry(struct lbs_private *priv, u32 id, u8 *addr1)
 	return ret;
 }
 
-int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
-			       u16 cmd_action, void *pdata_buf)
+/**
+ *  @brief Access the mesh forwarding table
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param cmd_action	The forwarding table action to perform
+ *  @param cmd		The pre-filled FWT_ACCESS command
+ *
+ *  @return 	   	0 on success and 'cmd' will be filled with the
+ *                        firmware's response
+ */
+int lbs_cmd_fwt_access(struct lbs_private *priv, u16 cmd_action,
+			struct cmd_ds_fwt_access *cmd)
 {
-	struct cmd_ds_fwt_access *fwt_access = &cmd->params.fwt;
-	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
+	int ret;
 
-	cmd->command = cpu_to_le16(CMD_FWT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) +
-		sizeof(struct cmd_header));
-	cmd->result = 0;
+	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
-	if (pdata_buf)
-		memcpy(fwt_access, pdata_buf, sizeof(*fwt_access));
-	else
-		memset(fwt_access, 0, sizeof(*fwt_access));
+	cmd->hdr.command = cpu_to_le16(CMD_FWT_ACCESS);
+	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access));
+	cmd->hdr.result = 0;
+	cmd->action = cpu_to_le16(cmd_action);
 
-	fwt_access->action = cpu_to_le16(cmd_action);
+	ret = lbs_cmd_with_response(priv, CMD_FWT_ACCESS, cmd);
 
-	lbs_deb_leave(LBS_DEB_CMD);
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/libertas/mesh.h b/drivers/net/wireless/libertas/mesh.h
index 8554979..afb2e8d 100644
--- a/drivers/net/wireless/libertas/mesh.h
+++ b/drivers/net/wireless/libertas/mesh.h
@@ -8,6 +8,7 @@
 #include <net/iw_handler.h>
 #include <net/lib80211.h>
 
+#include "host.h"
 
 #ifdef CONFIG_LIBERTAS_MESH
 
@@ -57,8 +58,9 @@ int lbs_mesh_bt_get_inverted(struct lbs_private *priv, bool *inverted);
 int lbs_mesh_bt_set_inverted(struct lbs_private *priv, bool inverted);
 int lbs_mesh_bt_get_entry(struct lbs_private *priv, u32 id, u8 *addr1);
 
-int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
-	u16 cmd_action, void *pdata_buf);
+int lbs_cmd_fwt_access(struct lbs_private *priv, u16 cmd_action,
+			struct cmd_ds_fwt_access *cmd);
+
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 		    struct cmd_ds_mesh_access *cmd);
 int lbs_mesh_config_send(struct lbs_private *priv,
-- 
1.7.1.1


