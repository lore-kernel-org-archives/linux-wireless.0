Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZJUS2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:28:48 -0400
Subject: Re: [PATCH] libertas: remove handling for CMD_802_11_LED_GPIO_CTRL
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910191331.20476.hs4233@mail.mn-solutions.de>
References: <200910191331.20476.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:28:50 -0700
Message-Id: <1256149730.5010.39.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-19 at 13:31 +0200, Holger Schurig wrote:
> ... which just resided as an old-style command in cmd/cmdresp, but
> was nowhere useed. If we ever need it, we can re-add it as a newstyle
> command.

It's actually used by the OLPC folks; but right now there's simply no
mechanism to configure that ability via WEXT.  Is there some way to do
this via the kernel LED  framework instead that libertas should be
using?

Dan

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
> +++ linux-wl/drivers/net/wireless/libertas/cmd.c
> @@ -1181,29 +1181,6 @@
>  
>  		ret = 0;
>  		break;
> -	case CMD_802_11_LED_GPIO_CTRL:
> -		{
> -			struct mrvl_ie_ledgpio *gpio =
> -			    (struct mrvl_ie_ledgpio*)
> -			    cmdptr->params.ledgpio.data;
> -
> -			memmove(&cmdptr->params.ledgpio,
> -				pdata_buf,
> -				sizeof(struct cmd_ds_802_11_led_ctrl));
> -
> -			cmdptr->command =
> -			    cpu_to_le16(CMD_802_11_LED_GPIO_CTRL);
> -
> -#define ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN 8
> -			cmdptr->size =
> -			    cpu_to_le16(le16_to_cpu(gpio->header.len)
> -				+ S_DS_GEN
> -				+ ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
> -			gpio->header.len = gpio->header.len;
> -
> -			ret = 0;
> -			break;
> -		}
>  
>  	case CMD_BT_ACCESS:
>  		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
> --- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
> +++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
> @@ -187,12 +187,6 @@
>  			sizeof(struct cmd_ds_802_11_tpc_cfg));
>  		spin_unlock_irqrestore(&priv->driver_lock, flags);
>  		break;
> -	case CMD_RET(CMD_802_11_LED_GPIO_CTRL):
> -		spin_lock_irqsave(&priv->driver_lock, flags);
> -		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.ledgpio,
> -			sizeof(struct cmd_ds_802_11_led_ctrl));
> -		spin_unlock_irqrestore(&priv->driver_lock, flags);
> -		break;
>  
>  	case CMD_RET(CMD_GET_TSF):
>  		spin_lock_irqsave(&priv->driver_lock, flags);
> 

