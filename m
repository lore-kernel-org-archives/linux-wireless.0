Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1EKRG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 13:06:26 -0400
Subject: Re: [PATCH v2] 802.11n frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 19:06:23 +0200
Message-ID: <1305133583.17892.3.camel@jlt3.sipsolutions.net> (sfid-20110511_190635_626350_8E34772B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-22 at 18:34 +0200, Matteo Croce wrote:

> --- a/net/mac80211/status.c	2011-04-22 11:34:08.833135198 +0200
> +++ b/net/mac80211/status.c	2011-04-22 11:34:54.037135187 +0200
> @@ -405,6 +405,19 @@
>  	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
>  		rthdr->rate = sband->bitrates[
>  				info->status.rates[0].idx].bitrate / 5;
> +	/* HT rates */
> +	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
> +		rthdr->hdr.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
> +		rthdr->rate = 0;
> +		rthdr->ht_known =	IEEE80211_RADIOTAP_MCS_HAVE_BW |
> +					IEEE80211_RADIOTAP_MCS_HAVE_MCS |
> +					IEEE80211_RADIOTAP_MCS_HAVE_GI;
> +		rthdr->ht_mcs = info->status.rates[0].idx;
> +		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
> +			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_BW_40;
> +		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
> +			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_SGI;
> +	}

I think you should also split the patch -- this part isn't really only
injection.

johannes

