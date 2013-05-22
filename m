Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3EVTYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 15:24:42 -0400
Message-ID: <1369250674.8207.26.camel@jlt4.sipsolutions.net> (sfid-20130522_212445_327444_A1FBEF77)
Subject: Re: [PATCH 1/3] mac80211: add STBC flag for radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Wed, 22 May 2013 21:24:34 +0200
In-Reply-To: <1368949136-6079-2-git-send-email-linux@rempel-privat.de> (sfid-20130519_093926_441072_B1D2886A)
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
	 <1368949136-6079-2-git-send-email-linux@rempel-privat.de>
	 (sfid-20130519_093926_441072_B1D2886A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-05-19 at 09:38 +0200, Oleksij Rempel wrote:

> + * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3

> +	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),



> @@ -258,6 +258,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>  	pos += 2;
>  
>  	if (status->flag & RX_FLAG_HT) {
> +		unsigned int stbc = status->flag & RX_FLAG_STBC_MASK;
>  		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
>  		*pos++ = local->hw.radiotap_mcs_details;
>  		*pos = 0;
> @@ -267,6 +268,9 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>  			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
>  		if (status->flag & RX_FLAG_HT_GF)
>  			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
> +		if (stbc)
> +			*pos |= (stbc >> RX_FLAG_STBC_SHIFT)
> +					<< IEEE80211_RADIOTAP_MCS_STBC_SHIFT;
>  		pos++;
>  		*pos++ = status->rate_idx;

Here you forgot the "HAVE" bit.


> -			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
> +			 IEEE80211_RADIOTAP_MCS_HAVE_BW |
> +			 IEEE80211_RADIOTAP_MCS_HAVE_STBC;

And here it's completely bogus.

johannes

