Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1CKIqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 03:46:38 -0500
Subject: Re: [PATCH v2] mac80211: do not enable ps if 802.1x controlled
 port is unblocked
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Young <a.young.jason@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1299804200-2536-1-git-send-email-a.young.jason@gmail.com>
References: <1299804200-2536-1-git-send-email-a.young.jason@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 09:45:41 +0100
Message-ID: <1299833141.3755.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-10 at 16:43 -0800, Jason Young wrote:
> If dynamic_ps is disabled, enabling power save before the 4-way
> handshake completes may delay the station from being authorized to
> send/receive traffic, i.e. increase roaming times. It also may result in
> a failed 4-way handshake depending on the AP's timing requirements and
> beacon interval, and the station's listen interval.
> 
> To fix this, prevent power save from being enabled while the station
> isn't authorized and recalculate power save whenever the station's
> authorized state changes.
> 
> Signed-off-by: Jason Young <a.young.jason@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> 
> v2: restrict ieee80211_recalc_ps to station interfaces only
> 
>  net/mac80211/cfg.c  |    4 ++++
>  net/mac80211/mlme.c |   37 ++++++++++++++++++++++++++++++++-----
>  2 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 7b701dc..11866b4 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -834,6 +834,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  
>  	rcu_read_unlock();
>  
> +	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))
> +		ieee80211_recalc_ps(local, -1);
> +
>  	return 0;
>  }
>  
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index cc984bd..64d92d5 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -613,6 +613,37 @@ static void ieee80211_change_ps(struct ieee80211_local *local)
>  	}
>  }
>  
> +static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_managed *mgd = &sdata->u.mgd;
> +	struct sta_info *sta = NULL;
> +	u32 sta_flags = 0;
> +
> +	if (!mgd->powersave)
> +		return false;
> +
> +	if (!mgd->associated)
> +		return false;
> +
> +	if (!mgd->associated->beacon_ies)
> +		return false;
> +
> +	if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
> +			  IEEE80211_STA_CONNECTION_POLL))
> +		return false;
> +
> +	rcu_read_lock();
> +	sta = sta_info_get(sdata, mgd->bssid);
> +	if (sta)
> +		sta_flags = get_sta_flags(sta);
> +	rcu_read_unlock();
> +
> +	if (!(sta_flags & WLAN_STA_AUTHORIZED))
> +		return false;
> +
> +	return true;
> +}
> +
>  /* need to hold RTNL or interface lock */
>  void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
>  {
> @@ -647,11 +678,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
>  		count++;
>  	}
>  
> -	if (count == 1 && found->u.mgd.powersave &&
> -	    found->u.mgd.associated &&
> -	    found->u.mgd.associated->beacon_ies &&
> -	    !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
> -				    IEEE80211_STA_CONNECTION_POLL))) {
> +	if (count == 1 && ieee80211_powersave_allowed(found)) {
>  		struct ieee80211_conf *conf = &local->hw.conf;
>  		s32 beaconint_us;
>  


