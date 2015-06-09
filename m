Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54984 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbbFIU3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:29:52 -0400
Message-ID: <1433881789.1892.29.camel@sipsolutions.net> (sfid-20150609_222955_029866_5B55186E)
Subject: Re: [PATCH] cfg80211: check correct maximum bandwidth for quarter
 and half rate.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Jun 2015 22:29:49 +0200
In-Reply-To: <1433863625-30579-1-git-send-email-matthias.may@neratec.com> (sfid-20150609_173523_482237_45077999)
References: <1433863625-30579-1-git-send-email-matthias.may@neratec.com>
	 (sfid-20150609_173523_482237_45077999)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 17:27 +0200, Matthias May wrote:
> When using quarter and half rates we might want to use self defined
> frequencies with self defined country codes closer to the border.
> To avoid these frequencies to be disabled, we need to check if
> the frequency fits the band with the actual bandwidth.

> +++ b/net/wireless/reg.c
> @@ -1016,6 +1016,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
>  	for (i = 0; i < regd->n_reg_rules; i++) {
>  		const struct ieee80211_reg_rule *rr;
>  		const struct ieee80211_freq_range *fr = NULL;
> +		u32 max_bw = MHZ_TO_KHZ(20);
>  
>  		rr = &regd->reg_rules[i];
>  		fr = &rr->freq_range;
> @@ -1028,8 +1028,10 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
>  		 */
>  		if (!band_rule_found)
>  			band_rule_found = freq_in_rule_band(fr, center_freq);
> +		if (fr->max_bandwidth_khz < max_bw)
> +			max_bw = fr->max_bandwidth_khz;
>  
> -		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
> +		bw_fits = reg_does_bw_fit(fr, center_freq, max_bw);

So the old code here assumes 20 MHz channel bandwidth, which was
reasonable until 5/10 MHz were supported.

However, your change looks very odd.

Consider a situation where for some reason you have a regulatory domain
without 20 MHz channels at all, only allowing a max bandwidth of 10 MHz.
Then, this code will cause all checks for "channels" to be erroneously
successful, since you're not really checking the request against the
regd.

What's needed instead is to actually pass in the requested bandwidth
from the caller. Additionally, it seems that at least the caller in
handle_channel_custom() must loop through the available bandwidths
(5/10/20) and disable those that don't fit, instead of disabling the
channel if 20 MHz doesn't fit.

johannes

