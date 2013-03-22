Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3CVKXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:23:24 -0400
Message-ID: <1363947798.8238.7.camel@jlt4.sipsolutions.net> (sfid-20130322_112328_248354_BF5EBF19)
Subject: Re: [PATCH v2] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 11:23:18 +0100
In-Reply-To: <1363740764-1679-1-git-send-email-greearb@candelatech.com> (sfid-20130320_015255_058611_041FEECF)
References: <1363740764-1679-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130320_015255_058611_041FEECF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RCU logic isn't quite right yet:

> @@ -1312,7 +1313,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  			prev_4addr = true;
>  		}
>  
> +		some_sta = rcu_dereference(sta->sdata->some_sta);
> +		if (some_sta == sta)
> +			rcu_assign_pointer(sta->sdata->some_sta, NULL);

That must be under mutex since you also assign below, therefore you
should use rcu_dereference_protected()

>  		sta->sdata = vlansdata;
> +		rcu_assign_pointer(sta->sdata->some_sta, sta);

> +++ b/net/mac80211/sta_info.c
> @@ -67,7 +67,11 @@
>  static int sta_info_hash_del(struct ieee80211_local *local,
>  			     struct sta_info *sta)
>  {
> -	struct sta_info *s;
> +	struct sta_info *s, *some_sta;
> +
> +	some_sta = rcu_dereference(sta->sdata->some_sta);
> +	if (some_sta == sta)
> +		rcu_assign_pointer(sta->sdata->some_sta, NULL);

same here.

johannes

