Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1F0Mut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:50:49 -0400
Subject: Re: [RFC v3 3/3] mac80211: HT operation in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308671609.2656.10.camel@alex-2> (sfid-20110621_175338_716675_C53F4621)
References: <1308671129.2656.4.camel@alex-2>
	 <1308671609.2656.10.camel@alex-2> (sfid-20110621_175338_716675_C53F4621)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:50:53 +0200
Message-ID: <1309179053.3911.22.camel@jlt3.sipsolutions.net> (sfid-20110627_150040_132200_50263E1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 17:53 +0200, Alexander Simon wrote:
> +	/* entering a legacy IBSS. Use given HT configuration. */
> +	if (channel_type == NL80211_CHAN_NO_HT)
> +		channel_type = ifibss->channel_type;
> +
>  	local->oper_channel = chan;
> -	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
> +	WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));

I don't think you can now safely assume that set_channel_type() will
succeed, but I didn't check the chan.c code for IBSS now. Please explain
why this is OK now if you think that it is. NO_HT is always compatible,
but the HT mode you used won't necessarily be. I think for fixed-channel
mode this might be an issue.

> +					local->_oper_channel_type =
> +								channel_type;
> +					WARN_ON(!ieee80211_set_channel_type(
> +								local,
> +								sdata,
> +								channel_type));

Same here of course.

> @@ -404,7 +482,7 @@ static void ieee80211_rx_bss_info(struct
>  		ieee80211_sta_join_ibss(sdata, bss);
>  		supp_rates = ieee80211_sta_get_rates(local, elems, band);
>  		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> -				       supp_rates, GFP_KERNEL);
> +				    supp_rates, elems->ht_cap_elem, GFP_KERNEL);

indentation?

johannes

