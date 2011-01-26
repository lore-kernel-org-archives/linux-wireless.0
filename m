Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1AZIbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:31:16 -0500
Subject: Re: [PATCH 1/2] wl12xx: Enable the IEEE80211_HW_SPECTRUM_MGMT hw
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296030565-23778-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030565-23778-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:31:11 +0100
Message-ID: <1296030672.3635.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 10:29 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> It's mandatory to support this along with 11a.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index dfab21e..bc09812 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -3215,7 +3215,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
>  		IEEE80211_HW_SUPPORTS_UAPSD |
>  		IEEE80211_HW_HAS_RATE_CONTROL |
>  		IEEE80211_HW_CONNECTION_MONITOR |
> -		IEEE80211_HW_SUPPORTS_CQM_RSSI;
> +		IEEE80211_HW_SUPPORTS_CQM_RSSI |
> +		IEEE80211_HW_SPECTRUM_MGMT;

I once had a patch to remove this flag completely since it has very
little effect at all on mac80211. Can I convince you to review the flag
use in mac80211 and tell me why you think it is, or not, present?

johannes

