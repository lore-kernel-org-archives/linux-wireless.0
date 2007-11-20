Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXKTWsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:51 -0500
Subject: [PATCH 6/6] libertas: configurable beacon interval
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>,
	Javier Cardona <javier@cozybit.com>,
	Brajesh Dave <brajeshd@marvell.com>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:44:28 -0500
Message-Id: <1195598668.32309.31.camel@localhost.localdomain> (sfid-20071120_224915_933445_58034F96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brajesh Dave <brajeshd@marvell.com>

Requires firmware version 5.110.19.p0 or newer, available here:
http://dev.laptop.org/pub/firmware/libertas/

Signed-off-by: Ashish Shukla <ashishs@marvell.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index b4d1b14..f7ef1db 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -901,6 +901,28 @@ static int lbs_cmd_mesh_access(lbs_private * priv,
 	return 0;
 }
 
+static int lbs_cmd_bcn_ctrl(lbs_private * priv,
+					      struct cmd_ds_command *cmd,
+					      u16 cmd_action)
+{
+	struct cmd_ds_802_11_beacon_control
+		*bcn_ctrl = &cmd->params.bcn_ctrl;
+	lbs_adapter *adapter = priv->adapter;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	cmd->size =
+	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
+			     + S_DS_GEN);
+	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
+
+	bcn_ctrl->action = cpu_to_le16(cmd_action);
+	bcn_ctrl->beacon_enable = cpu_to_le16(adapter->beacon_enable);
+	bcn_ctrl->beacon_period = cpu_to_le16(adapter->beacon_period);
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
 static int lbs_cmd_set_boot2_ver(lbs_private * priv,
 				struct cmd_ds_command *cmd,
 				u16 cmd_action, void *pdata_buf)
@@ -1400,6 +1422,9 @@ int lbs_prepare_and_send_command(lbs_private * priv,
 					   S_DS_GEN);
 		ret = 0;
 		break;
+	case CMD_802_11_BEACON_CTRL:
+		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
+		break;
 	default:
 		lbs_deb_host("PREP_CMD: unknown command 0x%04x\n", cmd_no);
 		ret = -1;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 11b93f2..c215fe2 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -536,6 +536,24 @@ static int lbs_ret_802_11_enable_rsn(lbs_private * priv,
 	return 0;
 }
 
+static int lbs_ret_802_11_bcn_ctrl(lbs_private * priv,
+					      struct cmd_ds_command *resp)
+{
+	struct cmd_ds_802_11_beacon_control *bcn_ctrl =
+	    &resp->params.bcn_ctrl;
+	lbs_adapter *adapter = priv->adapter;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (bcn_ctrl->action == CMD_ACT_GET) {
+		adapter->beacon_enable = (u8) le16_to_cpu(bcn_ctrl->beacon_enable);
+		adapter->beacon_period = le16_to_cpu(bcn_ctrl->beacon_period);
+	}
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	return 0;
+}
+
 static inline int handle_cmd_response(u16 respcmd,
 				      struct cmd_ds_command *resp,
 				      lbs_private *priv)
@@ -704,6 +722,10 @@ static inline int handle_cmd_response(u16 respcmd,
 			memcpy(adapter->cur_cmd->pdata_buf, &resp->params.mesh,
 			       sizeof(resp->params.mesh));
 		break;
+	case CMD_RET(CMD_802_11_BEACON_CTRL):
+		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
+		break;
+
 	default:
 		lbs_deb_host("CMD_RESP: unknown cmd response 0x%04x\n",
 			    resp->command);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 433b9bd..53776bc 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -263,6 +263,8 @@ struct _lbs_adapter {
 	struct list_head network_free_list;
 	struct bss_descriptor *networks;
 
+	u16 beacon_period;
+	u8 beacon_enable;
 	u8 adhoccreate;
 
 	/** capability Info used in Association, start, join */
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 3746f70..256cac2 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -116,6 +116,8 @@
 
 #define CMD_SET_BOOT2_VER                 0x00a5
 
+#define CMD_802_11_BEACON_CTRL        0x00b0
+
 /* For the IEEE Power Save */
 #define CMD_SUBCMD_ENTER_PS               0x0030
 #define CMD_SUBCMD_EXIT_PS                0x0031
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 6477ce0..f4a265d 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -332,6 +332,12 @@ struct cmd_ds_802_11_radio_control {
 	__le16 control;
 };
 
+struct cmd_ds_802_11_beacon_control {
+	__le16 action;
+	__le16 beacon_enable;
+	__le16 beacon_period;
+};
+
 struct cmd_ds_802_11_sleep_params {
 	/* ACT_GET/ACT_SET */
 	__le16 action;
@@ -668,6 +674,7 @@ struct cmd_ds_command {
 		struct cmd_ds_set_boot2_ver boot2_ver;
 		struct cmd_ds_get_tsf gettsf;
 		struct cmd_ds_802_11_subscribe_event subscribe_event;
+		struct cmd_ds_802_11_beacon_control bcn_ctrl;
 	} params;
 } __attribute__ ((packed));
 
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 3854d91..ca67524 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -510,7 +510,9 @@ int lbs_cmd_80211_ad_hoc_start(lbs_private *priv,
 	/* set the BSS type */
 	adhs->bsstype = CMD_BSS_TYPE_IBSS;
 	adapter->mode = IW_MODE_ADHOC;
-	adhs->beaconperiod = cpu_to_le16(MRVDRV_BEACON_INTERVAL);
+	if (adapter->beacon_period == 0)
+		adapter->beacon_period = MRVDRV_BEACON_INTERVAL;
+	adhs->beaconperiod = cpu_to_le16(adapter->beacon_period);
 
 	/* set Physical param set */
 #define DS_PARA_IE_ID   3

