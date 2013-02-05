Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BEKFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 05:05:47 -0500
Message-ID: <1360058766.8376.3.camel@jlt4.sipsolutions.net> (sfid-20130205_110552_286324_FEACC92F)
Subject: Re: [PATCH] cfg80211: Fix memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>, mcgrof@do-not-panic.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Tue, 05 Feb 2013 11:06:06 +0100
In-Reply-To: <1360013624-4973-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130204_223416_570378_EE2CC644)
References: <1360013624-4973-1-git-send-email-Larry.Finger@lwfinger.net>
	 (sfid-20130204_223416_570378_EE2CC644)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 15:33 -0600, Larry Finger wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> When a driver requests a specific regulatory domain after cfg80211 already
> has one, a struct ieee80211_regdomain is leaked.

Thanks Larry!

> Johannes,
> 
> I added a From: for you as the content of this patch is yours.

I changed it back, it's really your patch, I only suggested a bit of the
code :-)

> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2189,10 +2189,14 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
>  		 * However if a driver requested this specific regulatory
>  		 * domain we keep it for its private use
>  		 */
> -		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER)
> +		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
> +			const struct ieee80211_regdomain *tmp =
> +						get_wiphy_regdom(request_wiphy);
>  			rcu_assign_pointer(request_wiphy->regd, rd);
> -		else
> +			rcu_free_regdom(tmp);

Luis, when you get back can you please audit the other places? I'm not
convinced that there aren't more places that need to free the regdom,
but I don't really want to dig into the code right now.

johannes

