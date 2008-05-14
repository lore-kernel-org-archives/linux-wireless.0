Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbYENOq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 10:46:59 -0400
Subject: Re: [PATCH] libertas: remove lbs_get_data_rate()
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805141627.18368.hs4233@mail.mn-solutions.de>
References: <200805141627.18368.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 14 May 2008 10:42:29 -0400
Message-Id: <1210776149.22992.7.camel@localhost.localdomain> (sfid-20080514_164704_179934_90009564)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 16:27 +0200, Holger Schurig wrote:
> lbs_get_data_rate() get's called, but no-one uses it's result.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

We currently get the iwconfig current rate from the last received packet
when the rate is 'auto'; I guess if we care about the TX data rate at
some future time we can use a combination of DATA_RATE (< 5.1 firmware)
and TX_RATEQUERY (>= 5.1 firmware) to get it.

> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-05-14 14:58:06.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-05-14 14:58:15.000000000 +0200
> @@ -697,38 +697,6 @@ static int lbs_cmd_802_11_rate_adapt_rat
>  }
>  
>  /**
> - *  @brief Get the current data rate
> - *
> - *  @param priv    	A pointer to struct lbs_private structure
> - *
> - *  @return 	   	The data rate on success, error on failure
> - */
> -int lbs_get_data_rate(struct lbs_private *priv)
> -{
> -	struct cmd_ds_802_11_data_rate cmd;
> -	int ret = -1;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	memset(&cmd, 0, sizeof(cmd));
> -	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> -	cmd.action = cpu_to_le16(CMD_ACT_GET_TX_RATE);
> -
> -	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, &cmd);
> -	if (ret)
> -		goto out;
> -
> -	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
> -
> -	ret = (int) lbs_fw_index_to_data_rate(cmd.rates[0]);
> -	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", ret);
> -
> -out:
> -	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
> -	return ret;
> -}
> -
> -/**
>   *  @brief Set the data rate
>   *
>   *  @param priv    	A pointer to struct lbs_private structure
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-05-14 14:59:07.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-05-14 14:59:11.000000000 +0200
> @@ -34,7 +34,6 @@ int lbs_update_hw_spec(struct lbs_privat
>  int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
>  		    struct cmd_ds_mesh_access *cmd);
>  
> -int lbs_get_data_rate(struct lbs_private *priv);
>  int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
>  
>  int lbs_get_channel(struct lbs_private *priv);
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-14 14:58:28.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-14 15:04:14.000000000 +0200
> @@ -928,20 +928,10 @@ static int lbs_setup_firmware(struct lbs
>  	 */
>  	memset(priv->current_addr, 0xff, ETH_ALEN);
>  	ret = lbs_update_hw_spec(priv);
> -	if (ret) {
> -		ret = -1;
> +	if (ret)
>  		goto done;
> -	}
>  
>  	lbs_set_mac_control(priv);
> -
> -	ret = lbs_get_data_rate(priv);
> -	if (ret < 0) {
> -		ret = -1;
> -		goto done;
> -	}
> -
> -	ret = 0;
>  done:
>  	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
>  	return ret;

