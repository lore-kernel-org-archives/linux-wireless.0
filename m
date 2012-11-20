Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53238 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2KTHkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:40:01 -0500
Message-ID: <1353397163.10872.136.camel@cumari.coelho.fi> (sfid-20121120_084006_391095_B35D4918)
Subject: Re: [PATCH 11/15] wlcore: set active psm on association
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 20 Nov 2012 09:39:23 +0200
In-Reply-To: <1353343170-26516-12-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-12-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
> The default ps mode of the fw is auto, while the default
> ps mode of mac80211 is active (ps off).
> In order to sync them, configure active ps on association.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index e1f0606..0dd0ec1 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -2534,6 +2534,15 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  					   ACX_KEEP_ALIVE_TPL_VALID);
>  	if (ret < 0)
>  		goto out;
> +
> +	/*
> +	 * The default fw psm configuration is AUTO, while mac80211 default
> +	 * setting is off (ACTIVE), so sync the fw with the correct value.
> +	 */
> +	ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE);
> +	if (ret < 0)
> +		goto out;
> +

Does mac80211 enable PS soon after this by default?

--
Luca.

