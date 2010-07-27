Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0G0Rzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:55:54 -0400
Subject: [wt PATCH 5/16] libertas: remove unused Automatic Frequency
 Control command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:57:27 -0700
Message-ID: <1280260647.19686.18.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It hasn't been hooked up to anything in a long time and it's not
even listed in any of the firmware documentation I have (and I
have v5.1, v8, v9, and v10).

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |   13 -------------
 drivers/net/wireless/libertas/cmdresp.c |    9 ---------
 drivers/net/wireless/libertas/host.h    |    4 +++-
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 76a892e..15cfc52 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1204,19 +1204,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_SET_AFC:
-	case CMD_802_11_GET_AFC:
-
-		cmdptr->command = cpu_to_le16(cmd_no);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_afc) +
-					   sizeof(struct cmd_header));
-
-		memmove(&cmdptr->params.afc,
-			pdata_buf, sizeof(struct cmd_ds_802_11_afc));
-
-		ret = 0;
-		goto done;
-
 #ifdef CONFIG_LIBERTAS_MESH
 
 	case CMD_BT_ACCESS:
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 6bc40c6..c3cbc8a 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -113,15 +113,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_reg_access(priv, respcmd, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_SET_AFC):
-	case CMD_RET(CMD_802_11_GET_AFC):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.afc,
-			sizeof(struct cmd_ds_802_11_afc));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-
-		break;
-
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index a15f5d0..76bbcec 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -882,7 +882,10 @@ struct cmd_ds_802_11_led_ctrl {
 	u8 data[256];
 } __attribute__ ((packed));
 
+/* Automatic Frequency Control */
 struct cmd_ds_802_11_afc {
+	struct cmd_header hdr;
+
 	__le16 afc_auto;
 	union {
 		struct {
@@ -965,7 +968,6 @@ struct cmd_ds_command {
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
 
-		struct cmd_ds_802_11_afc afc;
 		struct cmd_ds_802_11_led_ctrl ledgpio;
 
 		struct cmd_ds_bt_access bt;
-- 
1.7.1.1


