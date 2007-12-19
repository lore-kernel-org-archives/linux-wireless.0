Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40756 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXLSQJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:09:52 -0500
Subject: [PATCH 127/48] libertas: convert RADIO_CONTROL to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50v8-00021S-92@pmac.infradead.org> (sfid-20071219_160955_849473_BEFA98B1)
Date: Wed, 19 Dec 2007 15:33:18 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 22:43:48 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   76 +++++++++++--------------------
 drivers/net/wireless/libertas/cmdresp.c |    1 -
 drivers/net/wireless/libertas/hostcmd.h |    4 +-
 3 files changed, 29 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 0ae9851..3a7b82f 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -603,45 +603,6 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_radio_control(struct lbs_private *priv,
-					 struct cmd_ds_command *cmd,
-					 int cmd_action)
-{
-	struct cmd_ds_802_11_radio_control *pradiocontrol = &cmd->params.radio;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd->size =
-	    cpu_to_le16((sizeof(struct cmd_ds_802_11_radio_control)) +
-			     S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_RADIO_CONTROL);
-
-	pradiocontrol->action = cpu_to_le16(cmd_action);
-
-	switch (priv->preamble) {
-	case CMD_TYPE_SHORT_PREAMBLE:
-		pradiocontrol->control = cpu_to_le16(SET_SHORT_PREAMBLE);
-		break;
-
-	case CMD_TYPE_LONG_PREAMBLE:
-		pradiocontrol->control = cpu_to_le16(SET_LONG_PREAMBLE);
-		break;
-
-	case CMD_TYPE_AUTO_PREAMBLE:
-	default:
-		pradiocontrol->control = cpu_to_le16(SET_AUTO_PREAMBLE);
-		break;
-	}
-
-	if (priv->radioon)
-		pradiocontrol->control |= cpu_to_le16(TURN_ON_RF);
-	else
-		pradiocontrol->control &= cpu_to_le16(~TURN_ON_RF);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_802_11_rf_tx_power(struct lbs_private *priv,
 				       struct cmd_ds_command *cmd,
 				       u16 cmd_action, void *pdata_buf)
@@ -1315,16 +1276,37 @@ void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 int lbs_set_radio_control(struct lbs_private *priv)
 {
 	int ret = 0;
+	struct cmd_ds_802_11_radio_control cmd;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	ret = lbs_prepare_and_send_command(priv,
-				    CMD_802_11_RADIO_CONTROL,
-				    CMD_ACT_SET,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+
+	switch (priv->preamble) {
+	case CMD_TYPE_SHORT_PREAMBLE:
+		cmd.control = cpu_to_le16(SET_SHORT_PREAMBLE);
+		break;
+
+	case CMD_TYPE_LONG_PREAMBLE:
+		cmd.control = cpu_to_le16(SET_LONG_PREAMBLE);
+		break;
+
+	case CMD_TYPE_AUTO_PREAMBLE:
+	default:
+		cmd.control = cpu_to_le16(SET_AUTO_PREAMBLE);
+		break;
+	}
 
-	lbs_deb_cmd("RADIO_SET: radio %d, preamble %d\n",
-	       priv->radioon, priv->preamble);
+	if (priv->radioon)
+		cmd.control |= cpu_to_le16(TURN_ON_RF);
+	else
+		cmd.control &= cpu_to_le16(~TURN_ON_RF);
+
+	lbs_deb_cmd("RADIO_SET: radio %d, preamble %d\n", priv->radioon,
+		    priv->preamble);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RADIO_CONTROL, &cmd);
 
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
@@ -1467,10 +1449,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 						  cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_RADIO_CONTROL:
-		ret = lbs_cmd_802_11_radio_control(priv, cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_RATE_ADAPT_RATESET:
 		ret = lbs_cmd_802_11_rate_adapt_rateset(priv,
 							 cmdptr, cmd_action);
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 0cd9662..7c9ffc5 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -516,7 +516,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_SET_WEP):
 	case CMD_RET(CMD_802_11_RESET):
 	case CMD_RET(CMD_802_11_AUTHENTICATE):
-	case CMD_RET(CMD_802_11_RADIO_CONTROL):
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index b38502f..8cc4d77 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -342,6 +342,8 @@ struct cmd_ds_rf_reg_access {
 };
 
 struct cmd_ds_802_11_radio_control {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 control;
 };
@@ -697,8 +699,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_rate_adapt_rateset rateset;
 		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
-		struct cmd_ds_802_11_radio_control radio;
-		struct cmd_ds_802_11_rf_channel rfchannel;
 		struct cmd_ds_802_11_rssi rssi;
 		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_802_11_disassociate dassociate;
-- 
1.5.3.4

