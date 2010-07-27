Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0G0RzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:55:17 -0400
Subject: [wt PATCH 4/16] libertas: remove unused indirect TPC_CFG command
 leftovers
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:56:44 -0700
Message-ID: <1280260604.19686.17.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were no longer used but were left around; Transmit Power
Control is done through the lbs_set_tpc_cfg() function.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |   12 ------------
 drivers/net/wireless/libertas/cmdresp.c |    7 -------
 drivers/net/wireless/libertas/host.h    |    1 -
 3 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2aa362f..76a892e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1217,18 +1217,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = 0;
 		goto done;
 
-	case CMD_802_11_TPC_CFG:
-		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
-		cmdptr->size =
-		    cpu_to_le16(sizeof(struct cmd_ds_802_11_tpc_cfg) +
-				     sizeof(struct cmd_header));
-
-		memmove(&cmdptr->params.tpccfg,
-			pdata_buf, sizeof(struct cmd_ds_802_11_tpc_cfg));
-
-		ret = 0;
-		break;
-
 #ifdef CONFIG_LIBERTAS_MESH
 
 	case CMD_BT_ACCESS:
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 35b8ceb..6bc40c6 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -125,13 +125,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_802_11_TPC_CFG):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
-			sizeof(struct cmd_ds_802_11_tpc_cfg));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
-
 	case CMD_RET(CMD_BT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (priv->cur_cmd->callback_arg)
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index ad46c36..a15f5d0 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -965,7 +965,6 @@ struct cmd_ds_command {
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
 
-		struct cmd_ds_802_11_tpc_cfg tpccfg;
 		struct cmd_ds_802_11_afc afc;
 		struct cmd_ds_802_11_led_ctrl ledgpio;
 
-- 
1.7.1.1


