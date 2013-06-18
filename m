Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3FROZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:25:15 -0400
Message-ID: <1371565505.8318.24.camel@jlt4.sipsolutions.net> (sfid-20130618_162533_226556_57F873BE)
Subject: Re: [PATCHv3 06/18] mac80211: select and adjust bitrates according
 for channel mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 18 Jun 2013 16:25:05 +0200
In-Reply-To: <1368702045-27598-7-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368702045-27598-7-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 13:00 +0200, Simon Wunderlich wrote:
> The various components accessing the bitrates table must use consider
> the used channel bandwidth to select only available rates or calculate
> the bitrate correctly.
> 
> There are some rates in reduced bandwidth modes which can't be
> represented as multiples of 500kbps, like 2.25 MBit/s in 5 MHz mode. The
> standard suggests to round up to the next multiple of 500kbps, just do
> that in mac80211 as well.

"suggests", heh ...

> @@ -4238,7 +4238,6 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
>  		  struct ieee80211_sta *sta)
>  {
>  	int i;
> -
>  	for (i = 0; i < sband->n_bitrates; i++)

please don't do that.

>  		for (i = 0; i < params->supported_rates_len; i++) {
>  			int rate = (params->supported_rates[i] & 0x7f) * 5;
> +			int brate;
>  			for (j = 0; j < sband->n_bitrates; j++) {
> -				if (sband->bitrates[j].bitrate == rate)
> +				brate = sband->bitrates[j].bitrate;
> +				brate = DIV_ROUND_UP(brate, divisor);
> +				if ((rate_flags & sband->bitrates[i].flags)
> +				    != rate_flags)
> +					continue;
> +
> +				if (brate == rate)
>  					rates |= BIT(j);
>  			}

some refactoring might be useful ... having != at the start of a line is
a really good sign for that ;-)

johannes

