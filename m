Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab2IDOMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:12:53 -0400
Message-ID: <1346768117.26638.3.camel@dcbw.foobar.com> (sfid-20120904_161256_883815_9C6B47AE)
Subject: Re: [PATCH] libertas: set mac control synchronously
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Tue, 04 Sep 2012 09:15:17 -0500
In-Reply-To: <20120903194934.04E06FAA0A@dev.laptop.org>
References: <20120903194934.04E06FAA0A@dev.laptop.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-03 at 15:49 -0400, Daniel Drake wrote:
> CMD_MAC_CONTROL is currently sent async to the firmware, and is sent
> from the lbs_setup_firmware() path during device init.
> 
> This means that device init can complete with commands pending, and
> the if_sdio driver will sometimes power down the device (after init)
> with this command still pending.
> 
> This was causing an occasional spurious command timeout after init,
> leading to a device reset.
> 
> Fix this by making CMD_MAC_CONTROL synchronous - there is currently
> no reason for it to be async (although there may have been in 2008
> when commit c97329e2 was made).

Hmm, any chance we could just have another function
(lbs_cmd_mac_control_sync?) that does it sync?  That's called from a
bunch of places and we were trying to make most of the commands done
from major flows async to reduce driver blocking and bad stalls when the
firmware times out commands.  It shouldn't be too hard to have both
sync/async calls for it.

Dan

> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/cmd.c  | 6 ++++--
>  drivers/net/wireless/libertas/cmd.h  | 2 +-
>  drivers/net/wireless/libertas/main.c | 4 +++-
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 26e6832..df0e4af5 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -1144,9 +1144,10 @@ out:
>  	return ret;
>  }
>  
> -void lbs_set_mac_control(struct lbs_private *priv)
> +int lbs_set_mac_control(struct lbs_private *priv)
>  {
>  	struct cmd_ds_mac_control cmd;
> +	int ret;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
> @@ -1154,9 +1155,10 @@ void lbs_set_mac_control(struct lbs_private *priv)
>  	cmd.action = cpu_to_le16(priv->mac_control);
>  	cmd.reserved = 0;
>  
> -	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
> +	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
>  
>  	lbs_deb_leave(LBS_DEB_CMD);
> +	return ret;
>  }
>  
>  /**
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index ab07608..43df4c4 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -95,7 +95,7 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv);
>  
>  int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on);
>  
> -void lbs_set_mac_control(struct lbs_private *priv);
> +int lbs_set_mac_control(struct lbs_private *priv);
>  
>  int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
>  		     s16 *maxlevel);
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index fe1ea43..b878b45 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -682,8 +682,10 @@ static int lbs_setup_firmware(struct lbs_private *priv)
>  
>  	/* Send cmd to FW to enable 11D function */
>  	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
> +	if (ret)
> +		goto done;
>  
> -	lbs_set_mac_control(priv);
> +	ret = lbs_set_mac_control(priv);
>  done:
>  	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
>  	return ret;


