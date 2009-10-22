Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33999 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZJVNfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:20 -0400
Message-Id: <20091022133415.785611323@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:54 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 11/19] libertas: remove handling for CMD_GET_TSF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... which just resided as an old-style command in cmd/cmdresp, but
was nowhere useed. If we ever need it, we can re-add it as a newstyle
command.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -1190,12 +1190,6 @@
 		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_GET_TSF:
-		cmdptr->command = cpu_to_le16(CMD_GET_TSF);
-		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_get_tsf) +
-					   S_DS_GEN);
-		ret = 0;
-		break;
 	case CMD_802_11_BEACON_CTRL:
 		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
 		break;
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -188,12 +188,6 @@
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
 
-	case CMD_RET(CMD_GET_TSF):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memcpy((void *)priv->cur_cmd->callback_arg,
-		       &resp->params.gettsf.tsfvalue, sizeof(u64));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
 	case CMD_RET(CMD_BT_ACCESS):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (priv->cur_cmd->callback_arg)
--- linux-wl.orig/drivers/net/wireless/libertas/host.h
+++ linux-wl/drivers/net/wireless/libertas/host.h
@@ -968,7 +968,6 @@
 
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
-		struct cmd_ds_get_tsf gettsf;
 		struct cmd_ds_802_11_beacon_control bcn_ctrl;
 	} params;
 } __attribute__ ((packed));

-- 
