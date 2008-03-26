Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbYCZOSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 10:18:40 -0400
Subject: Re: [PATCH] libertas: remove CMD_802_11_PWR_CFG
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803260957.45917.hs4233@mail.mn-solutions.de>
References: <200803260957.45917.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:17:31 -0400
Message-Id: <1206541051.30998.11.camel@localhost.localdomain> (sfid-20080326_141846_013259_630E1757)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 09:57 +0100, Holger Schurig wrote:
> This has nowhere been used. Note: in the firmware manual this was
> documented as CMD_802_11_PA_CFG. If we ever need it, we can/should
> re-implement it as a direct command.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c
> @@ -1453,16 +1453,6 @@
>  			break;
>  		}
>  
> -	case CMD_802_11_PWR_CFG:
> -		cmdptr->command = cpu_to_le16(CMD_802_11_PWR_CFG);
> -		cmdptr->size =
> -		    cpu_to_le16(sizeof(struct cmd_ds_802_11_pwr_cfg) +
> -				     S_DS_GEN);
> -		memmove(&cmdptr->params.pwrcfg, pdata_buf,
> -			sizeof(struct cmd_ds_802_11_pwr_cfg));
> -
> -		ret = 0;
> -		break;
>  	case CMD_BT_ACCESS:
>  		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
>  		break;
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> @@ -312,14 +312,6 @@
>  		spin_unlock_irqrestore(&priv->driver_lock, flags);
>  		break;
>  
> -	case CMD_RET(CMD_802_11_PWR_CFG):
> -		spin_lock_irqsave(&priv->driver_lock, flags);
> -		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.pwrcfg,
> -			sizeof(struct cmd_ds_802_11_pwr_cfg));
> -		spin_unlock_irqrestore(&priv->driver_lock, flags);
> -
> -		break;
> -
>  	case CMD_RET(CMD_GET_TSF):
>  		spin_lock_irqsave(&priv->driver_lock, flags);
>  		memcpy((void *)priv->cur_cmd->callback_arg,
> --- wireless-testing.orig/drivers/net/wireless/libertas/host.h
> +++ wireless-testing/drivers/net/wireless/libertas/host.h
> @@ -84,7 +84,6 @@
>  #define CMD_802_11_INACTIVITY_TIMEOUT		0x0067
>  #define CMD_802_11_SLEEP_PERIOD			0x0068
>  #define CMD_802_11_TPC_CFG			0x0072
> -#define CMD_802_11_PWR_CFG			0x0073
>  #define CMD_802_11_FW_WAKE_METHOD		0x0074
>  #define CMD_802_11_SUBSCRIBE_EVENT		0x0075
>  #define CMD_802_11_RATE_ADAPT_RATESET		0x0076
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> @@ -616,14 +616,6 @@
>  	u8 data[256];
>  } __attribute__ ((packed));
>  
> -struct cmd_ds_802_11_pwr_cfg {
> -	__le16 action;
> -	u8 enable;
> -	s8 PA_P0;
> -	s8 PA_P1;
> -	s8 PA_P2;
> -} __attribute__ ((packed));
> -
>  struct cmd_ds_802_11_afc {
>  	__le16 afc_auto;
>  	union {
> @@ -728,7 +720,6 @@
>  		struct cmd_ds_802_11d_domain_info domaininforesp;
>  
>  		struct cmd_ds_802_11_tpc_cfg tpccfg;
> -		struct cmd_ds_802_11_pwr_cfg pwrcfg;
>  		struct cmd_ds_802_11_afc afc;
>  		struct cmd_ds_802_11_led_ctrl ledgpio;
>  

