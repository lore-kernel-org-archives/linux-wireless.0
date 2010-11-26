Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:52300 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0KZNEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:04:08 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAQD459N017154
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 15:04:05 +0200
Subject: Re: [PATCH] wl12xx: disable 11a channels when regulatory changes
 if 11a is not supported
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
References: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:03:45 +0200
Message-ID: <1290776625.4284.304.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-26 at 14:43 +0200, luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> Instead of simply not scanning for the 11a channels when not supported by the
> hardware, disable the channels in reg_notify.  This centralizes the decision
> on whether to scan 5GHz channel in one place and allows userspace to know
> exactly which channels are in use.
> 
> Based on Juuso Oikarinen's idea.
> 
> Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 35cfcf6..97eb186 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -336,7 +336,9 @@ out:
>  }
>  
>  static int wl1271_reg_notify(struct wiphy *wiphy,
> -			     struct regulatory_request *request) {
> +			     struct regulatory_request *request)
> +{
> +	struct wl1271 *wl = wiphy_to_ieee80211_hw(wiphy)->priv;
>  	struct ieee80211_supported_band *band;
>  	struct ieee80211_channel *ch;
>  	int i;
> @@ -347,6 +349,11 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
>  		if (ch->flags & IEEE80211_CHAN_DISABLED)
>  			continue;
>  
> +		if (!wl->enable_11a) {
> +			ch->flags |= IEEE80211_CHAN_DISABLED;
> +			continue;
> +		}
> +
>  		if (ch->flags & IEEE80211_CHAN_RADAR)
>  			ch->flags |= IEEE80211_CHAN_NO_IBSS |
>  				     IEEE80211_CHAN_PASSIVE_SCAN;

I think this is more verbose towards user-space this way.

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

