Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYIJNDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:03:51 -0400
Subject: [PATCH] libertas: remove unused generic RESET command
From: Dan Williams <dcbw@redhat.com>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:04:33 -0400
Message-Id: <1221051873.4648.3.camel@localhost.localdomain> (sfid-20080910_150356_306919_96CF611A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic reset command is unused.  Each interface type needs to
handle the reset command differently since after reset, the firmware is
dead and interface-specific mechanisms must be used to reinitialize the
card.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 802547e..c68b113 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -480,20 +480,6 @@ int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 	return ret;
 }
 
-static int lbs_cmd_802_11_reset(struct cmd_ds_command *cmd, int cmd_action)
-{
-	struct cmd_ds_802_11_reset *reset = &cmd->params.reset;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	cmd->command = cpu_to_le16(CMD_802_11_RESET);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_reset) + S_DS_GEN);
-	reset->action = cpu_to_le16(cmd_action);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd,
 				    int cmd_action,
@@ -1419,10 +1405,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_80211_associate(priv, cmdptr, pdata_buf);
 		break;
 
-	case CMD_802_11_RESET:
-		ret = lbs_cmd_802_11_reset(cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_AUTHENTICATE:
 		ret = lbs_cmd_80211_authenticate(priv, cmdptr, pdata_buf);
 		break;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 0371c83..f305b04 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -271,7 +271,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 		break;
 
-	case CMD_RET(CMD_802_11_RESET):
 	case CMD_RET(CMD_802_11_AUTHENTICATE):
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index d27c276..5a66786 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -151,10 +151,6 @@ struct cmd_ds_get_hw_spec {
 	__le32 fwcapinfo;
 } __attribute__ ((packed));
 
-struct cmd_ds_802_11_reset {
-	__le16 action;
-};
-
 struct cmd_ds_802_11_subscribe_event {
 	struct cmd_header hdr;
 
@@ -703,7 +699,6 @@ struct cmd_ds_command {
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
 		struct cmd_ds_802_11_associate associate;
-		struct cmd_ds_802_11_reset reset;
 		struct cmd_ds_802_11_authenticate auth;
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 7b02d61..cafbccb 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -439,11 +439,10 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
 	*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
 
 	cmd->command = cpu_to_le16(CMD_802_11_RESET);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_reset) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_header));
 	cmd->result = cpu_to_le16(0);
 	cmd->seqnum = cpu_to_le16(0x5a5a);
-	cmd->params.reset.action = cpu_to_le16(CMD_ACT_HALT);
-	usb_tx_block(cardp, cardp->ep_out_buf, 4 + S_DS_GEN + sizeof(struct cmd_ds_802_11_reset));
+	usb_tx_block(cardp, cardp->ep_out_buf, 4 + sizeof(struct cmd_header));
 
 	msleep(100);
 	ret = usb_reset_device(cardp->udev);


