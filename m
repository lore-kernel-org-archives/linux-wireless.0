Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33993 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbZJVNfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:19 -0400
Message-Id: <20091022133414.541621830@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:53 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 10/19] libertas: remove handling for CMD_802_11_LED_GPIO_CTRL
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... which just resided as an old-style command in cmd/cmdresp, but
was nowhere useed. If we ever need it, we can re-add it as a newstyle
command.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -1181,29 +1181,6 @@
 
 		ret = 0;
 		break;
-	case CMD_802_11_LED_GPIO_CTRL:
-		{
-			struct mrvl_ie_ledgpio *gpio =
-			    (struct mrvl_ie_ledgpio*)
-			    cmdptr->params.ledgpio.data;
-
-			memmove(&cmdptr->params.ledgpio,
-				pdata_buf,
-				sizeof(struct cmd_ds_802_11_led_ctrl));
-
-			cmdptr->command =
-			    cpu_to_le16(CMD_802_11_LED_GPIO_CTRL);
-
-#define ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN 8
-			cmdptr->size =
-			    cpu_to_le16(le16_to_cpu(gpio->header.len)
-				+ S_DS_GEN
-				+ ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
-			gpio->header.len = gpio->header.len;
-
-			ret = 0;
-			break;
-		}
 
 	case CMD_BT_ACCESS:
 		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -187,12 +187,6 @@
 			sizeof(struct cmd_ds_802_11_tpc_cfg));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
-	case CMD_RET(CMD_802_11_LED_GPIO_CTRL):
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.ledgpio,
-			sizeof(struct cmd_ds_802_11_led_ctrl));
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
-		break;
 
 	case CMD_RET(CMD_GET_TSF):
 		spin_lock_irqsave(&priv->driver_lock, flags);

-- 
