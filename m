Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53631 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3AKUP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 15:15:26 -0500
Message-ID: <1357935264.28524.8.camel@cumari.coelho.fi> (sfid-20130111_211529_595509_6F2E3C43)
Subject: Re: [PATCH] wireless: make the reg_notifier() void
From: Luciano Coelho <coelho@ti.com>
To: <mcgrof@do-not-panic.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Date: Fri, 11 Jan 2013 22:14:24 +0200
In-Reply-To: <1357929576-11609-1-git-send-email-mcgrof@do-not-panic.com>
References: <1357929576-11609-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 18:39 +0000, mcgrof@do-not-panic.com wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The reg_notifier()'s return value need not be checked
> as it is only supposed to do post regulatory work and
> that should never fail. Any behaviour to regulatory
> that needs to be considered before cfg80211 does work
> to a driver should be specified by using the already
> existing flags, the reg_notifier() just does post
> processing should it find it needs to.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---

For the wlcore part:

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index d7de063..ce6e62a 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -89,8 +89,8 @@ static int wl12xx_set_authorized(struct wl1271 *wl,
>  	return 0;
>  }
>  
> -static int wl1271_reg_notify(struct wiphy *wiphy,
> -			     struct regulatory_request *request)
> +static void wl1271_reg_notify(struct wiphy *wiphy,
> +			      struct regulatory_request *request)
>  {
>  	struct ieee80211_supported_band *band;
>  	struct ieee80211_channel *ch;
> @@ -107,8 +107,6 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
>  				     IEEE80211_CHAN_PASSIVE_SCAN;
>  
>  	}
> -
> -	return 0;
>  }
>  
>  static int wl1271_set_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,

Acked-by: Luciano Coelho <coelho@ti.com>

--
Luca.

