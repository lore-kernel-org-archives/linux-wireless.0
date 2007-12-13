Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55923 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762797AbXLMG7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:34 -0500
Subject: [PATCH 67/48] libertas: convert CMD_MESH_ACCESS to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2n-0005sP-5G@shinybook.infradead.org> (sfid-20071213_070635_921419_ED126E4C)
Date: Thu, 13 Dec 2007 01:59:41 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 15:23:59 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   28 ++++++++-------------
 drivers/net/wireless/libertas/cmd.h     |    3 ++
 drivers/net/wireless/libertas/cmdresp.c |    5 ----
 drivers/net/wireless/libertas/hostcmd.h |    3 +-
 drivers/net/wireless/libertas/if_usb.c  |   11 ++------
 drivers/net/wireless/libertas/main.c    |   40 +++++++++++++++---------------
 6 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index eeb09e0..9d621fe 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -976,27 +976,25 @@ static int lbs_cmd_fwt_access(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_mesh_access(struct lbs_private *priv,
-				struct cmd_ds_command *cmd,
-				u16 cmd_action, void *pdata_buf)
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd)
 {
-	struct cmd_ds_mesh_access *mesh_access = &cmd->params.mesh;
+	int ret;
+
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
-	cmd->command = cpu_to_le16(CMD_MESH_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mesh_access) + S_DS_GEN);
-	cmd->result = 0;
+	cmd->hdr.command = cpu_to_le16(CMD_MESH_ACCESS);
+	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_access) + S_DS_GEN);
+	cmd->hdr.result = 0;
 
-	if (pdata_buf)
-		memcpy(mesh_access, pdata_buf, sizeof(*mesh_access));
-	else
-		memset(mesh_access, 0, sizeof(*mesh_access));
+	cmd->action = cpu_to_le16(cmd_action);
 
-	mesh_access->action = cpu_to_le16(cmd_action);
+	ret = lbs_cmd_with_response(priv, CMD_MESH_ACCESS, (*cmd));
 
 	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	return ret;
 }
+EXPORT_SYMBOL_GPL(lbs_mesh_access);
 
 static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
 				struct cmd_ds_command *cmd,
@@ -1486,10 +1484,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_fwt_access(priv, cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_MESH_ACCESS:
-		ret = lbs_cmd_mesh_access(priv, cmdptr, cmd_action, pdata_buf);
-		break;
-
 	case CMD_GET_TSF:
 		cmdptr->command = cpu_to_le16(CMD_GET_TSF);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_get_tsf) +
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index b8e5d21..716f25b 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -24,4 +24,7 @@ int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 
 int lbs_update_hw_spec(struct lbs_private *priv);
 
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index b4cd7b7..6ff705b 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -653,11 +653,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 			       sizeof(resp->params.fwt));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
-	case CMD_RET(CMD_MESH_ACCESS):
-		if (priv->cur_cmd->pdata_buf)
-			memcpy(priv->cur_cmd->pdata_buf, &resp->params.mesh,
-			       sizeof(resp->params.mesh));
-		break;
 	case CMD_RET(CMD_802_11_BEACON_CTRL):
 		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index e5e2106..d9b151a 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -623,6 +623,8 @@ struct cmd_ds_fwt_access {
 } __attribute__ ((packed));
 
 struct cmd_ds_mesh_access {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le32 data[32];	/* last position reserved */
 } __attribute__ ((packed));
@@ -687,7 +689,6 @@ struct cmd_ds_command {
 		struct cmd_tx_rate_query txrate;
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
-		struct cmd_ds_mesh_access mesh;
 		struct cmd_ds_get_tsf gettsf;
 		struct cmd_ds_802_11_subscribe_event subscribe_event;
 		struct cmd_ds_802_11_beacon_control bcn_ctrl;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 5f2d944..a0866ef 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -990,11 +990,9 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 		 */
 		struct cmd_ds_mesh_access mesh_access;
 		memset(&mesh_access, 0, sizeof(mesh_access));
+
 		mesh_access.data[0] = cpu_to_le32(1);
-		lbs_prepare_and_send_command(priv,
-				CMD_MESH_ACCESS,
-				CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
-				CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+		lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
 	}
 
 	netif_device_detach(cardp->eth_dev);
@@ -1031,10 +1029,7 @@ static int if_usb_resume(struct usb_interface *intf)
 		struct cmd_ds_mesh_access mesh_access;
 		memset(&mesh_access, 0, sizeof(mesh_access));
 		mesh_access.data[0] = cpu_to_le32(0);
-		lbs_prepare_and_send_command(priv,
-				CMD_MESH_ACCESS,
-				CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
-				CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+		lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
 	}
 
 	lbs_deb_leave(LBS_DEB_USB);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index a081b91..7f6b3cc 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -217,13 +217,15 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
 static ssize_t lbs_anycast_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
 {
+	struct lbs_private *priv = to_net_dev(dev)->priv;
 	struct cmd_ds_mesh_access mesh_access;
+	int ret;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
-	lbs_prepare_and_send_command(to_net_dev(dev)->priv,
-			CMD_MESH_ACCESS,
-			CMD_ACT_MESH_GET_ANYCAST,
-			CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_ANYCAST, &mesh_access);
+	if (ret)
+		return ret;
 
 	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
 }
@@ -234,17 +236,19 @@ static ssize_t lbs_anycast_get(struct device *dev,
 static ssize_t lbs_anycast_set(struct device *dev,
 		struct device_attribute *attr, const char * buf, size_t count)
 {
+	struct lbs_private *priv = to_net_dev(dev)->priv;
 	struct cmd_ds_mesh_access mesh_access;
 	uint32_t datum;
+	int ret;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
 	sscanf(buf, "%x", &datum);
 	mesh_access.data[0] = cpu_to_le32(datum);
 
-	lbs_prepare_and_send_command((to_net_dev(dev))->priv,
-			CMD_MESH_ACCESS,
-			CMD_ACT_MESH_SET_ANYCAST,
-			CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_ANYCAST, &mesh_access);
+	if (ret)
+		return ret;
+
 	return strlen(buf);
 }
 
@@ -323,14 +327,15 @@ static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
 static ssize_t lbs_autostart_enabled_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
 {
+	struct lbs_private *priv = to_net_dev(dev)->priv;
 	struct cmd_ds_mesh_access mesh_access;
+	int ret;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
-	lbs_prepare_and_send_command(to_net_dev(dev)->priv,
-			CMD_MESH_ACCESS,
-			CMD_ACT_MESH_GET_AUTOSTART_ENABLED,
-			CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
 
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_AUTOSTART_ENABLED, &mesh_access);
+	if (ret)
+		return ret;
 	return sprintf(buf, "%d\n", le32_to_cpu(mesh_access.data[0]));
 }
 
@@ -346,10 +351,7 @@ static ssize_t lbs_autostart_enabled_set(struct device *dev,
 	sscanf(buf, "%d", &datum);
 	mesh_access.data[0] = cpu_to_le32(datum);
 
-	ret = lbs_prepare_and_send_command(priv,
-			CMD_MESH_ACCESS,
-			CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
-			CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
 	if (ret == 0)
 		priv->mesh_autostart_enabled = datum ? 1 : 0;
 
@@ -866,10 +868,8 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 	if (priv->mesh_dev) {
 		memset(&mesh_access, 0, sizeof(mesh_access));
 		mesh_access.data[0] = cpu_to_le32(0);
-		ret = lbs_prepare_and_send_command(priv,
-				CMD_MESH_ACCESS,
-				CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
-				CMD_OPTION_WAITFORRSP, 0, (void *)&mesh_access);
+		ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
+				      &mesh_access);
 		if (ret) {
 			ret = -1;
 			goto done;
-- 
1.5.3.4

