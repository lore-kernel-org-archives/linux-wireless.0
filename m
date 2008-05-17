Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:43764 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbYETDOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 23:14:41 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2139563waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 20:14:41 -0700 (PDT)
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Cc: dwmw2@infradead.org, carrano@laptop.org, dilinger@queued.net
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 17 May 2008 00:55:10 -0700
Subject: [PATCH 1/2] Extend MESH_CONFIG command to access non-volatile configuration.
Message-ID: <48324220.1997600a.4f22.35be@mx.google.com> (sfid-20080520_051446_056534_2363D08E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on a patch from Shailendra Govardhan and Brian Cavagnolo.
It extends the MESH_CONFIG command to configure non-volatile parameters on
libertas devices that support them (e.g. OLPC Active Antenna).

This patch only implements the driver/firmware interface.

See http://dev.laptop.org/ticket/6823 for minimal testing results and known
issues.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/assoc.c |    6 ++-
 drivers/net/wireless/libertas/cmd.c   |   69 +++++++++++++++++++++++++++------
 drivers/net/wireless/libertas/cmd.h   |    2 +
 drivers/net/wireless/libertas/defs.h  |   10 +++++
 drivers/net/wireless/libertas/host.h  |   17 ++++++++
 drivers/net/wireless/libertas/main.c  |   13 ++++--
 drivers/net/wireless/libertas/types.h |   30 ++++++++++++++
 drivers/net/wireless/libertas/wext.c  |    5 +-
 8 files changed, 131 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index c9c3640..b17f9df 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -603,7 +603,8 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		/* Change mesh channel first; 21.p21 firmware won't let
 		   you change channel otherwise (even though it'll return
 		   an error to this */
-		lbs_mesh_config(priv, 0, assoc_req->channel);
+		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP,
+							assoc_req->channel);
 	}
 
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
@@ -642,7 +643,8 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
  restore_mesh:
 	if (priv->mesh_dev)
-		lbs_mesh_config(priv, 1, priv->curbssparams.channel);
+		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+					priv->curbssparams.channel);
 
  done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6328b95..7c9cd29 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -4,6 +4,7 @@
   */
 
 #include <net/iw_handler.h>
+#include <net/ieee80211.h>
 #include <linux/kfifo.h>
 #include "host.h"
 #include "hostcmd.h"
@@ -1052,24 +1053,68 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 	return ret;
 }
 
-int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan)
+int lbs_mesh_config_send(struct lbs_private *priv,
+			struct cmd_ds_mesh_config *cmd, u16 action, u16 type)
+{
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd->hdr.command = cpu_to_le16(CMD_MESH_CONFIG);
+	cmd->hdr.size = cpu_to_le16(sizeof(struct cmd_ds_mesh_config));
+	cmd->hdr.result = 0;
+
+	cmd->type = cpu_to_le16(type);
+	cmd->action = cpu_to_le16(action);
+
+	ret = lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
+
+/* This function is the CMD_MESH_CONFIG legacy function.  It only handles the
+ * START and STOP actions.  The extended actions supported by CMD_MESH_CONFIG
+ * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
+ * lbs_mesh_config_send.
+ */
+int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
 {
 	struct cmd_ds_mesh_config cmd;
+	struct mrvl_meshie *ie;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.action = cpu_to_le16(enable);
 	cmd.channel = cpu_to_le16(chan);
-	cmd.type = cpu_to_le16(priv->mesh_tlv);
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-
-	if (enable) {
-		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
-		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
+	ie = (struct mrvl_meshie *)cmd.data;
+
+	switch (action) {
+	case CMD_ACT_MESH_CONFIG_START:
+		ie->hdr.id = MFIE_TYPE_GENERIC;
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
+		ie->hdr.len = sizeof(struct mrvl_meshie_val) -
+			IW_ESSID_MAX_SIZE + priv->mesh_ssid_len;
+		cmd.length = sizeof(struct mrvl_meshie_val);
+		break;
+	case CMD_ACT_MESH_CONFIG_STOP:
+		break;
+	default:
+		return -1;
 	}
-	lbs_deb_cmd("mesh config enable %d TLV %x channel %d SSID %s\n",
-		    enable, priv->mesh_tlv, chan,
-		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
-	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, &cmd);
+	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
+			action, priv->mesh_tlv, chan,
+			escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
+
+	return lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
 
 static int lbs_cmd_bcn_ctrl(struct lbs_private * priv,
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 3dfc2d4..a80de18 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -40,6 +40,8 @@ int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 int lbs_get_channel(struct lbs_private *priv);
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
+int lbs_mesh_config_send(struct lbs_private *priv,
+		struct cmd_ds_mesh_config *cmd, u16 action, u16 type);
 int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index d395201..0120d6c 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -170,6 +170,16 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 
 #define MARVELL_MESH_IE_LENGTH		9
 
+/* Values used to populate the struct mrvl_mesh_ie.  The only time you need this
+ * is when enabling the mesh using CMD_MESH_CONFIG.
+ */
+#define MARVELL_MESH_IE_TYPE	4
+#define MARVELL_MESH_IE_SUBTYPE	0
+#define MARVELL_MESH_IE_VERSION	0
+#define MARVELL_MESH_PROTO_ID_HWMP	0
+#define MARVELL_MESH_METRIC_ID	0
+#define MARVELL_MESH_CAPABILITY	0
+
 /** INT status Bit Definition*/
 #define MRVDRV_TX_DNLD_RDY		0x0001
 #define MRVDRV_RX_UPLD_RDY		0x0002
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 3915c31..c92e41b 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -256,6 +256,23 @@ enum cmd_mesh_access_opts {
 	CMD_ACT_MESH_GET_AUTOSTART_ENABLED,
 };
 
+/* Define actions and types for CMD_MESH_CONFIG */
+enum cmd_mesh_config_actions {
+	CMD_ACT_MESH_CONFIG_STOP = 0,
+	CMD_ACT_MESH_CONFIG_START,
+	CMD_ACT_MESH_CONFIG_SET,
+	CMD_ACT_MESH_CONFIG_GET,
+};
+
+enum cmd_mesh_config_types {
+	CMD_TYPE_MESH_SET_BOOTFLAG = 1,
+	CMD_TYPE_MESH_SET_BOOTTIME,
+	CMD_TYPE_MESH_SET_DEF_CHANNEL,
+	CMD_TYPE_MESH_SET_MESH_IE,
+	CMD_TYPE_MESH_GET_DEFAULTS,
+	CMD_TYPE_MESH_GET_MESH_IE, /* GET_DEFAULTS is superset of GET_MESHIE */
+};
+
 /** Card Event definition */
 #define MACREG_INT_CODE_TX_PPA_FREE		0
 #define MACREG_INT_CODE_TX_DMA_DONE		1
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 406f54d..5001888 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -343,14 +343,15 @@ static ssize_t lbs_mesh_set(struct device *dev,
 {
 	struct lbs_private *priv = to_net_dev(dev)->priv;
 	int enable;
-	int ret;
+	int ret, action = CMD_ACT_MESH_CONFIG_STOP;
 
 	sscanf(buf, "%x", &enable);
 	enable = !!enable;
 	if (enable == !!priv->mesh_dev)
 		return count;
-
-	ret = lbs_mesh_config(priv, enable, priv->curbssparams.channel);
+	if (enable)
+		action = CMD_ACT_MESH_CONFIG_START;
+	ret = lbs_mesh_config(priv, action, priv->curbssparams.channel);
 	if (ret)
 		return ret;
 
@@ -1235,9 +1236,11 @@ int lbs_start_card(struct lbs_private *priv)
 		   useful */
 
 		priv->mesh_tlv = 0x100 + 291;
-		if (lbs_mesh_config(priv, 1, priv->curbssparams.channel)) {
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+						priv->curbssparams.channel)) {
 			priv->mesh_tlv = 0x100 + 37;
-			if (lbs_mesh_config(priv, 1, priv->curbssparams.channel))
+			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+						priv->curbssparams.channel))
 				priv->mesh_tlv = 0;
 		}
 		if (priv->mesh_tlv) {
diff --git a/drivers/net/wireless/libertas/types.h b/drivers/net/wireless/libertas/types.h
index 4031be4..e0c2599 100644
--- a/drivers/net/wireless/libertas/types.h
+++ b/drivers/net/wireless/libertas/types.h
@@ -6,6 +6,8 @@
 
 #include <linux/if_ether.h>
 #include <asm/byteorder.h>
+#include <linux/wireless.h>
+#include <net/ieee80211.h>
 
 struct ieeetypes_cfparamset {
 	u8 elementid;
@@ -252,4 +254,32 @@ struct mrvlietypes_ledbhv {
 	struct led_bhv ledbhv[1];
 } __attribute__ ((packed));
 
+/* Meant to be packed as the value member of a struct ieee80211_info_element.
+ * Note that the len member of the ieee80211_info_element varies depending on
+ * the mesh_id_len */
+struct mrvl_meshie_val {
+	uint8_t oui[P80211_OUI_LEN];
+	uint8_t type;
+	uint8_t subtype;
+	uint8_t version;
+	uint8_t active_protocol_id;
+	uint8_t active_metric_id;
+	uint8_t mesh_capability;
+	uint8_t mesh_id_len;
+	uint8_t mesh_id[IW_ESSID_MAX_SIZE];
+} __attribute__ ((packed));
+
+struct mrvl_meshie {
+	struct ieee80211_info_element hdr;
+	struct mrvl_meshie_val val;
+} __attribute__ ((packed));
+
+struct mrvl_mesh_defaults {
+	__le32 bootflag;
+	uint8_t boottime;
+	uint8_t reserved;
+	__le16 channel;
+	struct mrvl_meshie meshie;
+} __attribute__ ((packed));
+
 #endif
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 0973d01..8c9292e 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1002,7 +1002,7 @@ static int lbs_mesh_set_freq(struct net_device *dev,
 		else if (priv->mode == IW_MODE_ADHOC)
 			lbs_stop_adhoc_network(priv);
 	}
-	lbs_mesh_config(priv, 1, fwrq->m);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, fwrq->m);
 	lbs_update_channel(priv);
 	ret = 0;
 
@@ -2011,7 +2011,8 @@ static int lbs_mesh_set_essid(struct net_device *dev,
 		priv->mesh_ssid_len = dwrq->length;
 	}
 
-	lbs_mesh_config(priv, 1, priv->curbssparams.channel);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+						priv->curbssparams.channel);
  out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
-- 
1.5.2.4



