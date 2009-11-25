Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50608 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbZKYMLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 07:11:20 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 5/5] libertas: move mesh command handling into mesh.c
Date: Wed, 25 Nov 2009 13:11:16 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911251311.17050.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -3,7 +3,6 @@
   * It prepares command and sends it to firmware when it is ready.
   */
 
-#include <net/lib80211.h>
 #include <linux/kfifo.h>
 #include <linux/sched.h>
 
@@ -697,173 +696,6 @@
 	return 0;
 }
 
-static int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
-			       u16 cmd_action, void *pdata_buf)
-{
-	struct cmd_ds_bt_access *bt_access = &cmd->params.bt;
-	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
-
-	cmd->command = cpu_to_le16(CMD_BT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) +
-		sizeof(struct cmd_header));
-	cmd->result = 0;
-	bt_access->action = cpu_to_le16(cmd_action);
-
-	switch (cmd_action) {
-	case CMD_ACT_BT_ACCESS_ADD:
-		memcpy(bt_access->addr1, pdata_buf, 2 * ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_MESH, "BT_ADD: blinded MAC addr", bt_access->addr1, 6);
-		break;
-	case CMD_ACT_BT_ACCESS_DEL:
-		memcpy(bt_access->addr1, pdata_buf, 1 * ETH_ALEN);
-		lbs_deb_hex(LBS_DEB_MESH, "BT_DEL: blinded MAC addr", bt_access->addr1, 6);
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
-	}
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
-static int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
-			       u16 cmd_action, void *pdata_buf)
-{
-	struct cmd_ds_fwt_access *fwt_access = &cmd->params.fwt;
-	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
-
-	cmd->command = cpu_to_le16(CMD_FWT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) +
-		sizeof(struct cmd_header));
-	cmd->result = 0;
-
-	if (pdata_buf)
-		memcpy(fwt_access, pdata_buf, sizeof(*fwt_access));
-	else
-		memset(fwt_access, 0, sizeof(*fwt_access));
-
-	fwt_access->action = cpu_to_le16(cmd_action);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
-int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
-		    struct cmd_ds_mesh_access *cmd)
-{
-	int ret;
-
-	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
-
-	cmd->hdr.command = cpu_to_le16(CMD_MESH_ACCESS);
-	cmd->hdr.size = cpu_to_le16(sizeof(*cmd));
-	cmd->hdr.result = 0;
-
-	cmd->action = cpu_to_le16(cmd_action);
-
-	ret = lbs_cmd_with_response(priv, CMD_MESH_ACCESS, cmd);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return ret;
-}
-
-static int __lbs_mesh_config_send(struct lbs_private *priv,
-				  struct cmd_ds_mesh_config *cmd,
-				  uint16_t action, uint16_t type)
-{
-	int ret;
-	u16 command = CMD_MESH_CONFIG_OLD;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/*
-	 * Command id is 0xac for v10 FW along with mesh interface
-	 * id in bits 14-13-12.
-	 */
-	if (priv->mesh_fw_ver == MESH_FW_NEW)
-		command = CMD_MESH_CONFIG |
-			  (MESH_IFACE_ID << MESH_IFACE_BIT_OFFSET);
-
-	cmd->hdr.command = cpu_to_le16(command);
-	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_config));
-	cmd->hdr.result = 0;
-
-	cmd->type = cpu_to_le16(type);
-	cmd->action = cpu_to_le16(action);
-
-	ret = lbs_cmd_with_response(priv, command, cmd);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return ret;
-}
-
-int lbs_mesh_config_send(struct lbs_private *priv,
-			 struct cmd_ds_mesh_config *cmd,
-			 uint16_t action, uint16_t type)
-{
-	int ret;
-
-	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
-		return -EOPNOTSUPP;
-
-	ret = __lbs_mesh_config_send(priv, cmd, action, type);
-	return ret;
-}
-
-/* This function is the CMD_MESH_CONFIG legacy function.  It only handles the
- * START and STOP actions.  The extended actions supported by CMD_MESH_CONFIG
- * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
- * lbs_mesh_config_send.
- */
-int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_meshie *ie;
-	DECLARE_SSID_BUF(ssid);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.channel = cpu_to_le16(chan);
-	ie = (struct mrvl_meshie *)cmd.data;
-
-	switch (action) {
-	case CMD_ACT_MESH_CONFIG_START:
-		ie->id = WLAN_EID_GENERIC;
-		ie->val.oui[0] = 0x00;
-		ie->val.oui[1] = 0x50;
-		ie->val.oui[2] = 0x43;
-		ie->val.type = MARVELL_MESH_IE_TYPE;
-		ie->val.subtype = MARVELL_MESH_IE_SUBTYPE;
-		ie->val.version = MARVELL_MESH_IE_VERSION;
-		ie->val.active_protocol_id = MARVELL_MESH_PROTO_ID_HWMP;
-		ie->val.active_metric_id = MARVELL_MESH_METRIC_ID;
-		ie->val.mesh_capability = MARVELL_MESH_CAPABILITY;
-		ie->val.mesh_id_len = priv->mesh_ssid_len;
-		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
-		ie->len = sizeof(struct mrvl_meshie_val) -
-			IEEE80211_MAX_SSID_LEN + priv->mesh_ssid_len;
-		cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie_val));
-		break;
-	case CMD_ACT_MESH_CONFIG_STOP:
-		break;
-	default:
-		return -1;
-	}
-	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
-		    action, priv->mesh_tlv, chan,
-		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
-
-	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
-}
-
 static void lbs_queue_cmd(struct lbs_private *priv,
 			  struct cmd_ctrl_node *cmdnode)
 {
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -6,6 +6,7 @@
 
 
 #include <net/iw_handler.h>
+#include <net/lib80211.h>
 
 
 /* Mesh statistics */
@@ -42,6 +43,16 @@
 	struct net_device *dev, struct txpd *txpd);
 
 
+/* Command handling */
+
+struct cmd_ds_command;
+
+int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
+	u16 cmd_action, void *pdata_buf);
+int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
+	u16 cmd_action, void *pdata_buf);
+
+
 /* Persistent configuration */
 
 void lbs_persist_config_init(struct net_device *net);
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -441,6 +441,181 @@
 
 
 /***************************************************************************
+ * Mesh command handling
+ */
+
+int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
+			       u16 cmd_action, void *pdata_buf)
+{
+	struct cmd_ds_bt_access *bt_access = &cmd->params.bt;
+	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
+
+	cmd->command = cpu_to_le16(CMD_BT_ACCESS);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) +
+		sizeof(struct cmd_header));
+	cmd->result = 0;
+	bt_access->action = cpu_to_le16(cmd_action);
+
+	switch (cmd_action) {
+	case CMD_ACT_BT_ACCESS_ADD:
+		memcpy(bt_access->addr1, pdata_buf, 2 * ETH_ALEN);
+		lbs_deb_hex(LBS_DEB_MESH, "BT_ADD: blinded MAC addr",
+			bt_access->addr1, 6);
+		break;
+	case CMD_ACT_BT_ACCESS_DEL:
+		memcpy(bt_access->addr1, pdata_buf, 1 * ETH_ALEN);
+		lbs_deb_hex(LBS_DEB_MESH, "BT_DEL: blinded MAC addr",
+			bt_access->addr1, 6);
+		break;
+	case CMD_ACT_BT_ACCESS_LIST:
+		bt_access->id = cpu_to_le32(*(u32 *) pdata_buf);
+		break;
+	case CMD_ACT_BT_ACCESS_RESET:
+		break;
+	case CMD_ACT_BT_ACCESS_SET_INVERT:
+		bt_access->id = cpu_to_le32(*(u32 *) pdata_buf);
+		break;
+	case CMD_ACT_BT_ACCESS_GET_INVERT:
+		break;
+	default:
+		break;
+	}
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+int lbs_cmd_fwt_access(struct cmd_ds_command *cmd,
+			       u16 cmd_action, void *pdata_buf)
+{
+	struct cmd_ds_fwt_access *fwt_access = &cmd->params.fwt;
+	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
+
+	cmd->command = cpu_to_le16(CMD_FWT_ACCESS);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) +
+		sizeof(struct cmd_header));
+	cmd->result = 0;
+
+	if (pdata_buf)
+		memcpy(fwt_access, pdata_buf, sizeof(*fwt_access));
+	else
+		memset(fwt_access, 0, sizeof(*fwt_access));
+
+	fwt_access->action = cpu_to_le16(cmd_action);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd)
+{
+	int ret;
+
+	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
+
+	cmd->hdr.command = cpu_to_le16(CMD_MESH_ACCESS);
+	cmd->hdr.size = cpu_to_le16(sizeof(*cmd));
+	cmd->hdr.result = 0;
+
+	cmd->action = cpu_to_le16(cmd_action);
+
+	ret = lbs_cmd_with_response(priv, CMD_MESH_ACCESS, cmd);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
+
+static int __lbs_mesh_config_send(struct lbs_private *priv,
+				  struct cmd_ds_mesh_config *cmd,
+				  uint16_t action, uint16_t type)
+{
+	int ret;
+	u16 command = CMD_MESH_CONFIG_OLD;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	/*
+	 * Command id is 0xac for v10 FW along with mesh interface
+	 * id in bits 14-13-12.
+	 */
+	if (priv->mesh_fw_ver == MESH_FW_NEW)
+		command = CMD_MESH_CONFIG |
+			  (MESH_IFACE_ID << MESH_IFACE_BIT_OFFSET);
+
+	cmd->hdr.command = cpu_to_le16(command);
+	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_config));
+	cmd->hdr.result = 0;
+
+	cmd->type = cpu_to_le16(type);
+	cmd->action = cpu_to_le16(action);
+
+	ret = lbs_cmd_with_response(priv, command, cmd);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
+
+int lbs_mesh_config_send(struct lbs_private *priv,
+			 struct cmd_ds_mesh_config *cmd,
+			 uint16_t action, uint16_t type)
+{
+	int ret;
+
+	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
+		return -EOPNOTSUPP;
+
+	ret = __lbs_mesh_config_send(priv, cmd, action, type);
+	return ret;
+}
+
+/* This function is the CMD_MESH_CONFIG legacy function.  It only handles the
+ * START and STOP actions.  The extended actions supported by CMD_MESH_CONFIG
+ * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
+ * lbs_mesh_config_send.
+ */
+int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
+{
+	struct cmd_ds_mesh_config cmd;
+	struct mrvl_meshie *ie;
+	DECLARE_SSID_BUF(ssid);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.channel = cpu_to_le16(chan);
+	ie = (struct mrvl_meshie *)cmd.data;
+
+	switch (action) {
+	case CMD_ACT_MESH_CONFIG_START:
+		ie->id = WLAN_EID_GENERIC;
+		ie->val.oui[0] = 0x00;
+		ie->val.oui[1] = 0x50;
+		ie->val.oui[2] = 0x43;
+		ie->val.type = MARVELL_MESH_IE_TYPE;
+		ie->val.subtype = MARVELL_MESH_IE_SUBTYPE;
+		ie->val.version = MARVELL_MESH_IE_VERSION;
+		ie->val.active_protocol_id = MARVELL_MESH_PROTO_ID_HWMP;
+		ie->val.active_metric_id = MARVELL_MESH_METRIC_ID;
+		ie->val.mesh_capability = MARVELL_MESH_CAPABILITY;
+		ie->val.mesh_id_len = priv->mesh_ssid_len;
+		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
+		ie->len = sizeof(struct mrvl_meshie_val) -
+			IEEE80211_MAX_SSID_LEN + priv->mesh_ssid_len;
+		cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie_val));
+		break;
+	case CMD_ACT_MESH_CONFIG_STOP:
+		break;
+	default:
+		return -1;
+	}
+	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
+		    action, priv->mesh_tlv, chan,
+		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
+
+	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
+}
+
+
+
+/***************************************************************************
  * Persistent configuration support
  */
 

-- 
http://www.holgerschurig.de
