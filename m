Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761596Ab3DCM6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:58:09 -0400
Message-ID: <1364993882.8351.39.camel@jlt4.sipsolutions.net> (sfid-20130403_145813_645552_1066EB1E)
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Apr 2013 14:58:02 +0200
In-Reply-To: <1364572823-28071-1-git-send-email-greearb@candelatech.com> (sfid-20130329_170033_026763_9F6C74DD)
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130329_170033_026763_9F6C74DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1287,6 +1287,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  	if (params->vlan && params->vlan != sta->sdata->dev) {
>  		bool prev_4addr = false;
>  		bool new_4addr = false;
> +		struct sta_info *some_sta;
>  
>  		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
>  
> @@ -1312,7 +1313,12 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  			prev_4addr = true;
>  		}
>  
> +		some_sta = rcu_dereference_protected(sta->sdata->some_sta,
> +					lockdep_is_held(&local->sta_mtx));
> +		if (some_sta == sta)
> +			rcu_assign_pointer(sta->sdata->some_sta, NULL);
>  		sta->sdata = vlansdata;
> +		rcu_assign_pointer(sta->sdata->some_sta, sta);
>  
>  		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
>  		    prev_4addr != new_4addr) {

I think you can drop all this code since you don't allow this for
non-station interfaces, and stations here can only be reassigned between
AP/AP_VLAN, no?


> @@ -278,6 +297,8 @@ static void sta_info_hash_add(struct ieee80211_local *local,
>  	lockdep_assert_held(&local->sta_mtx);
>  	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
>  	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
> +
> +	rcu_assign_pointer(sta->sdata->some_sta, sta);

Maybe also assign it only for station to start with?

johannes

