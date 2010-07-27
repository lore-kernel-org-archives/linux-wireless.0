Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab0G0SAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:00:16 -0400
Subject: [wt PATCH 9/16] libertas: convert Mesh Blinding Table access to a
 direct command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:01:47 -0700
Message-ID: <1280260907.19686.24.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |    4 -
 drivers/net/wireless/libertas/cmdresp.c |    7 -
 drivers/net/wireless/libertas/host.h    |    3 +-
 drivers/net/wireless/libertas/mesh.c    |  182 +++++++++++++++++++++++++------
 drivers/net/wireless/libertas/mesh.h    |    8 +-
 5 files changed, 158 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index b8df1fd..dd25b2a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1208,10 +1208,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 #ifdef CONFIG_LIBERTAS_MESH
 
-	case CMD_BT_ACCESS:
-		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
-		break;
-
 	case CMD_FWT_ACCESS:
 		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 810d758..098b645 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -68,13 +68,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_BT_ACCESS):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		if (priv->cur_cmd->callback_arg)
-			memcpy((void *)priv->cur_cmd->callback_arg,
-			       &resp->params.bt.addr1, 2 * ETH_ALEN);
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
 	case CMD_RET(CMD_FWT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (priv->cur_cmd->callback_arg)
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index bd86d65..99de232 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -903,6 +903,8 @@ struct cmd_ds_get_tsf {
 } __attribute__ ((packed));
 
 struct cmd_ds_bt_access {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le32 id;
 	u8 addr1[ETH_ALEN];
@@ -959,7 +961,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 	} params;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index bc5bc13..35ee574 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -455,44 +455,162 @@ void lbs_mesh_set_txpd(struct lbs_private *priv,
  * Mesh command handling
  */
 
-int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
-			       u16 cmd_action, void *pdata_buf)
+/**
+ *  @brief Add or delete Mesh Blinding Table entries
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param add  	TRUE to add the entry, FALSE to delete it
+ *  @param addr1        Destination address to blind or unblind
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_mesh_bt_add_del(struct lbs_private *priv, bool add, u8 *addr1)
 {
-	struct cmd_ds_bt_access *bt_access = &cmd->params.bt;
-	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
+	struct cmd_ds_bt_access cmd;
+	int ret = 0;
 
-	cmd->command = cpu_to_le16(CMD_BT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) +
-		sizeof(struct cmd_header));
-	cmd->result = 0;
-	bt_access->action = cpu_to_le16(cmd_action);
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	BUG_ON(addr1 == NULL);
 
-	switch (cmd_action) {
-	case CMD_ACT_BT_ACCESS_ADD:
-		memcpy(bt_access->addr1, pdata_buf, 2 * ETH_ALEN);
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	memcpy(cmd.addr1, addr1, ETH_ALEN);
+	if (add) {
+		cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_ADD);
 		lbs_deb_hex(LBS_DEB_MESH, "BT_ADD: blinded MAC addr",
-			bt_access->addr1, 6);
-		break;
-	case CMD_ACT_BT_ACCESS_DEL:
-		memcpy(bt_access->addr1, pdata_buf, 1 * ETH_ALEN);
+			addr1, ETH_ALEN);
+	} else {
+		cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_DEL);
 		lbs_deb_hex(LBS_DEB_MESH, "BT_DEL: blinded MAC addr",
-			bt_access->addr1, 6);
-		break;
-	case CMD_ACT_BT_ACCESS_LIST:
-		bt_access->id = cpu_to_le32(*(u32 *) pdata_buf);
-		break;
-	case CMD_ACT_BT_ACCESS_RESET:
-		break;
-	case CMD_ACT_BT_ACCESS_SET_INVERT:
-		bt_access->id = cpu_to_le32(*(u32 *) pdata_buf);
-		break;
-	case CMD_ACT_BT_ACCESS_GET_INVERT:
-		break;
-	default:
-		break;
+			addr1, ETH_ALEN);
 	}
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+
+	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Reset/clear the mesh blinding table
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_mesh_bt_reset(struct lbs_private *priv)
+{
+	struct cmd_ds_bt_access cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_RESET);
+
+	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Gets the inverted status of the mesh blinding table
+ *
+ *  Normally the firmware "blinds" or ignores traffic from mesh nodes in the
+ *  table, but an inverted table allows *only* traffic from nodes listed in
+ *  the table.
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param invert  	On success, TRUE if the blinding table is inverted,
+ *                        FALSE if it is not inverted
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_mesh_bt_get_inverted(struct lbs_private *priv, bool *inverted)
+{
+	struct cmd_ds_bt_access cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	BUG_ON(inverted == NULL);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_GET_INVERT);
+
+	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
+	if (ret == 0)
+		*inverted = !!cmd.id;
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Sets the inverted status of the mesh blinding table
+ *
+ *  Normally the firmware "blinds" or ignores traffic from mesh nodes in the
+ *  table, but an inverted table allows *only* traffic from nodes listed in
+ *  the table.
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param invert  	TRUE to invert the blinding table (only traffic from
+ *                         listed nodes allowed), FALSE to return it
+ *                         to normal state (listed nodes ignored)
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_mesh_bt_set_inverted(struct lbs_private *priv, bool inverted)
+{
+	struct cmd_ds_bt_access cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_SET_INVERT);
+	cmd.id = !!inverted;
+
+	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief List an entry in the mesh blinding table
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param id		The ID of the entry to list
+ *  @param addr1	MAC address associated with the table entry
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_mesh_bt_get_entry(struct lbs_private *priv, u32 id, u8 *addr1)
+{
+	struct cmd_ds_bt_access cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	BUG_ON(addr1 == NULL);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_SET_INVERT);
+	cmd.id = cpu_to_le32(id);
+
+	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
+	if (ret == 0)
+		memcpy(addr1, cmd.addr1, sizeof(cmd.addr1));
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
diff --git a/drivers/net/wireless/libertas/mesh.h b/drivers/net/wireless/libertas/mesh.h
index 84ea248..8554979 100644
--- a/drivers/net/wireless/libertas/mesh.h
+++ b/drivers/net/wireless/libertas/mesh.h
@@ -51,8 +51,12 @@ struct cmd_ds_command;
 struct cmd_ds_mesh_access;
 struct cmd_ds_mesh_config;
 
-int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
-	u16 cmd_action, void *pdata_buf);
+int lbs_mesh_bt_add_del(struct lbs_private *priv, bool add, u8 *addr1);
+int lbs_mesh_bt_reset(struct lbs_private *priv);
+int lbs_mesh_bt_get_inverted(struct lbs_private *priv, bool *inverted);
+int lbs_mesh_bt_set_inverted(struct lbs_private *priv, bool inverted);
+int lbs_mesh_bt_get_entry(struct lbs_private *priv, u32 id, u8 *addr1);
+
 int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
 	u16 cmd_action, void *pdata_buf);
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
-- 
1.7.1.1


