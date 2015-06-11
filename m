Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbFKLoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:44:22 -0400
Message-ID: <1434023059.1915.12.camel@sipsolutions.net> (sfid-20150611_134425_751997_90307234)
Subject: Re: [PATCHv2 1/4] cfg80211: handle minimum bandwidth for quarter
 and half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jun 2015 13:44:19 +0200
In-Reply-To: <1434020791-16291-2-git-send-email-matthias.may@neratec.com> (sfid-20150611_130650_868019_E29B6AA4)
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
	 <1434020791-16291-2-git-send-email-matthias.may@neratec.com>
	 (sfid-20150611_130650_868019_E29B6AA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 13:06 +0200, Matthias May wrote:

>  const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
> -					       u32 center_freq)
> +					       u32 center_freq, u32 min_bw)
>  {
>  	const struct ieee80211_regdomain *regd;
> +	const struct ieee80211_reg_rule *rr_tmp = NULL;
> +	const struct ieee80211_reg_rule *reg_rule = NULL;
> +	u32 bw;
>  
>  	regd = reg_get_regdomain(wiphy);
>  
> -	return freq_reg_info_regd(wiphy, center_freq, regd);
> +	for(bw=min_bw; bw <= MHZ_TO_KHZ(20); bw=bw*2) {
> +		rr_tmp = freq_reg_info_regd(wiphy, center_freq, bw, regd);
> +		if(!reg_rule || !IS_ERR(rr_tmp))
> +			reg_rule = rr_tmp;
> +	}
> +
> +	return reg_rule;

This makes no sense to me.

You have the same code below, but why would you care? You can just look
at the reg_rule's max_bandwidth, no?

johannes

