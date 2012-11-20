Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55090 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2KTITN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:19:13 -0500
Message-ID: <1353399515.10872.153.camel@cumari.coelho.fi> (sfid-20121120_091917_187101_29E2ADEF)
Subject: Re: [PATCH 15/15] wlcore: configure the remote rates with our own
 rates
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 10:18:35 +0200
In-Reply-To: <1353343170-26516-16-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-16-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
> With the new connection flow, start_sta is called before
> the remote rates where updated. Use our own supported rates
> instead to make sure we don't disable any potential rate
> (the rate policies will be updated later, but there is
> currently no way to update the remote rates)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/cmd.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
> index 4c2ed25..ec7e8b3 100644
> --- a/drivers/net/wireless/ti/wlcore/cmd.c
> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
> @@ -479,7 +479,12 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  	}
>  	cmd->sta.hlid = wlvif->sta.hlid;
>  	cmd->sta.session = wl12xx_get_new_session_id(wl, wlvif);
> -	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
> +	/*
> +	 * We don't have the correct remote rates in this stage, and there
> +	 * is no way to update them later, so use our supported rates instead.
> +	 * The fw will take the configured rate policies into account anyway.
> +	 */
> +	cmd->sta.remote_rates = cpu_to_le32(supported_rates);

Why do we even have to pass this value, then? Any hidden reason that we
may be overlooking?

--
Luca.

