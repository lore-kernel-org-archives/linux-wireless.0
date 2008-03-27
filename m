Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbYC0VY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 17:24:58 -0400
Subject: Re: [PATCH] libertas: convert CMD_802_11_MAC_ADDRESS to a direct
	command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803260958.32270.hs4233@mail.mn-solutions.de>
References: <200803260958.32270.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 17:23:38 -0400
Message-Id: <1206653018.21106.6.camel@localhost.localdomain> (sfid-20080327_212504_872533_4CA628FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 09:58 +0100, Holger Schurig wrote:
> * directly call lbs_cmd_with_response()
> * only overwrite priv->current_addr once the firmware call succeeded
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c
> @@ -970,29 +970,6 @@
>  	return 0;
>  }
>  
> -static int lbs_cmd_802_11_mac_address(struct lbs_private *priv,
> -				       struct cmd_ds_command *cmd,
> -				       u16 cmd_action)
> -{
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -	cmd->command = cpu_to_le16(CMD_802_11_MAC_ADDRESS);
> -	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_mac_address) +
> -			     S_DS_GEN);
> -	cmd->result = 0;
> -
> -	cmd->params.macadd.action = cpu_to_le16(cmd_action);
> -
> -	if (cmd_action == CMD_ACT_SET) {
> -		memcpy(cmd->params.macadd.macadd,
> -		       priv->current_addr, ETH_ALEN);
> -		lbs_deb_hex(LBS_DEB_CMD, "SET_CMD: MAC addr", priv->current_addr, 6);
> -	}
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  static int lbs_cmd_802_11_eeprom_access(struct cmd_ds_command *cmd,
>  					void *pdata_buf)
>  {
> @@ -1448,10 +1425,6 @@
>  		ret = lbs_cmd_80211_ad_hoc_stop(cmdptr);
>  		break;
>  
> -	case CMD_802_11_MAC_ADDRESS:
> -		ret = lbs_cmd_802_11_mac_address(priv, cmdptr, cmd_action);
> -		break;
> -
>  	case CMD_802_11_EEPROM_ACCESS:
>  		ret = lbs_cmd_802_11_eeprom_access(cmdptr, pdata_buf);
>  		break;
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> @@ -179,19 +179,6 @@
>  	return 0;
>  }
>  
> -static int lbs_ret_802_11_mac_address(struct lbs_private *priv,
> -				       struct cmd_ds_command *resp)
> -{
> -	struct cmd_ds_802_11_mac_address *macadd = &resp->params.macadd;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	memcpy(priv->current_addr, macadd->macadd, ETH_ALEN);
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
>  				       struct cmd_ds_command *resp)
>  {
> @@ -325,10 +312,6 @@
>  		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
>  		break;
>  
> -	case CMD_RET(CMD_802_11_MAC_ADDRESS):
> -		ret = lbs_ret_802_11_mac_address(priv, resp);
> -		break;
> -
>  	case CMD_RET(CMD_802_11_AD_HOC_STOP):
>  		ret = lbs_ret_80211_ad_hoc_stop(priv);
>  		break;
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> @@ -429,6 +429,8 @@
>  };
>  
>  struct cmd_ds_802_11_mac_address {
> +	struct cmd_header hdr;
> +
>  	__le16 action;
>  	u8 macadd[ETH_ALEN];
>  };
> @@ -716,7 +718,6 @@
>  		struct cmd_ds_mac_multicast_adr madr;
>  		struct cmd_ds_802_11_ad_hoc_join adj;
>  		struct cmd_ds_802_11_disassociate dassociate;
> -		struct cmd_ds_802_11_mac_address macadd;
>  		struct cmd_ds_mac_reg_access macreg;
>  		struct cmd_ds_bbp_reg_access bbpreg;
>  		struct cmd_ds_rf_reg_access rfreg;
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c
> +++ wireless-testing/drivers/net/wireless/libertas/main.c
> @@ -530,34 +530,27 @@
>  	int ret = 0;
>  	struct lbs_private *priv = (struct lbs_private *) dev->priv;
>  	struct sockaddr *phwaddr = addr;
> +	struct cmd_ds_802_11_mac_address cmd;
>  
>  	lbs_deb_enter(LBS_DEB_NET);
>  
>  	/* In case it was called from the mesh device */
> -	dev = priv->dev ;
> -
> -	memset(priv->current_addr, 0, ETH_ALEN);
> -
> -	/* dev->dev_addr is 8 bytes */
> -	lbs_deb_hex(LBS_DEB_NET, "dev->dev_addr", dev->dev_addr, ETH_ALEN);
> -
> -	lbs_deb_hex(LBS_DEB_NET, "addr", phwaddr->sa_data, ETH_ALEN);
> -	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
> +	dev = priv->dev;
>  
> -	ret = lbs_prepare_and_send_command(priv, CMD_802_11_MAC_ADDRESS,
> -				    CMD_ACT_SET,
> -				    CMD_OPTION_WAITFORRSP, 0, NULL);
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +	cmd.action = cpu_to_le16(CMD_ACT_SET);
> +	memcpy(cmd.macadd, phwaddr->sa_data, ETH_ALEN);
>  
> +	ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS, &cmd);
>  	if (ret) {
>  		lbs_deb_net("set MAC address failed\n");
> -		ret = -1;
>  		goto done;
>  	}
>  
> -	lbs_deb_hex(LBS_DEB_NET, "priv->macaddr", priv->current_addr, ETH_ALEN);
> -	memcpy(dev->dev_addr, priv->current_addr, ETH_ALEN);
> +	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
> +	memcpy(dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
>  	if (priv->mesh_dev)
> -		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
> +		memcpy(priv->mesh_dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
>  
>  done:
>  	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);

