Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYCMBn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 21:43:57 -0400
Subject: Re: libertas: convert CMD_MAC_CONTROL to a direct command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803121605.41013.hs4233@mail.mn-solutions.de>
References: <200803121605.41013.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 21:38:51 -0400
Message-Id: <1205372331.23943.8.camel@localhost.localdomain> (sfid-20080313_014359_900005_6B428B36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-12 at 16:05 +0100, Holger Schurig wrote:
> convert CMD_MAC_CONTROL to a direct command
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-12 14:51:41.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-12 14:56:12.000000000 +0100
> @@ -1200,24 +1200,6 @@ static void lbs_submit_command(struct lb
>  	lbs_deb_leave(LBS_DEB_HOST);
>  }
>  
> -static int lbs_cmd_mac_control(struct lbs_private *priv,
> -				struct cmd_ds_command *cmd)
> -{
> -	struct cmd_ds_mac_control *mac = &cmd->params.macctrl;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	cmd->command = cpu_to_le16(CMD_MAC_CONTROL);
> -	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_control) + S_DS_GEN);
> -	mac->action = cpu_to_le16(priv->currentpacketfilter);
> -
> -	lbs_deb_cmd("MAC_CONTROL: action 0x%04x, size %d\n",
> -		    le16_to_cpu(mac->action), le16_to_cpu(cmd->size));
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  /**
>   *  This function inserts command node to cmdfreeq
>   *  after cleans it. Requires priv->driver_lock held.
> @@ -1307,12 +1289,15 @@ int lbs_set_radio_control(struct lbs_pri
>  int lbs_set_mac_packet_filter(struct lbs_private *priv)
>  {
>  	int ret = 0;
> +	struct cmd_ds_mac_control cmd;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> -	/* Send MAC control command to station */
> -	ret = lbs_prepare_and_send_command(priv,
> -				    CMD_MAC_CONTROL, 0, 0, 0, NULL);
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +	cmd.action = cpu_to_le16(priv->currentpacketfilter);
> +	cmd.reserved = 0;
> +
> +	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
>  
>  	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
>  	return ret;
> @@ -1382,10 +1367,6 @@ int lbs_prepare_and_send_command(struct 
>  		ret = lbs_cmd_802_11_ps_mode(priv, cmdptr, cmd_action);
>  		break;
>  
> -	case CMD_MAC_CONTROL:
> -		ret = lbs_cmd_mac_control(priv, cmdptr);
> -		break;
> -
>  	case CMD_802_11_ASSOCIATE:
>  	case CMD_802_11_REASSOCIATE:
>  		ret = lbs_cmd_80211_associate(priv, cmdptr, pdata_buf);
> Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-12 14:51:41.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-12 14:55:30.000000000 +0100
> @@ -394,7 +394,6 @@ static inline int handle_cmd_response(st
>  		break;
>  
>  	case CMD_RET(CMD_MAC_MULTICAST_ADR):
> -	case CMD_RET(CMD_MAC_CONTROL):
>  	case CMD_RET(CMD_802_11_RESET):
>  	case CMD_RET(CMD_802_11_AUTHENTICATE):
>  	case CMD_RET(CMD_802_11_BEACON_STOP):
> Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-12 14:51:41.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-12 14:55:30.000000000 +0100
> @@ -211,8 +211,9 @@ struct cmd_ds_802_11_get_log {
>  };
>  
>  struct cmd_ds_mac_control {
> +	struct cmd_header hdr;
>  	__le16 action;
> -	__le16 reserved;
> +	u16 reserved;
>  };
>  
>  struct cmd_ds_mac_multicast_adr {
> @@ -695,7 +696,6 @@ struct cmd_ds_command {
>  	/* command Body */
>  	union {
>  		struct cmd_ds_802_11_ps_mode psmode;
> -		struct cmd_ds_mac_control macctrl;
>  		struct cmd_ds_802_11_associate associate;
>  		struct cmd_ds_802_11_deauthenticate deauth;
>  		struct cmd_ds_802_11_ad_hoc_start ads;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

