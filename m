Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154Ab1IOQVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 12:21:39 -0400
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de> (sfid-20110915_181048_539834_E4954A19)
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de>
	 (sfid-20110915_181048_539834_E4954A19)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 18:21:38 +0200
Message-ID: <1316103698.3992.12.camel@jlt3.sipsolutions.net> (sfid-20110915_182142_156356_19C2A3C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How is this related to configuration? Shouldn't the configuration check
be in cfg80211 instead?

johannes


On Thu, 2011-09-15 at 18:07 +0200, Marek Lindner wrote:
> Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
> ---
>  net/mac80211/ibss.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 4f9235b..9c7991e 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -588,12 +588,10 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
>  	capability = WLAN_CAPABILITY_IBSS;
>  	if (ifibss->privacy)
>  		capability |= WLAN_CAPABILITY_PRIVACY;
> -	if (ifibss->fixed_bssid)
> +	if (ifibss->fixed_bssid && !is_zero_ether_addr(ifibss->bssid))
>  		bssid = ifibss->bssid;
>  	if (ifibss->fixed_channel)
>  		chan = ifibss->channel;
> -	if (!is_zero_ether_addr(ifibss->bssid))
> -		bssid = ifibss->bssid;
>  	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
>  				ifibss->ssid, ifibss->ssid_len,
>  				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,


