Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55616 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbeBWLYy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 06:24:54 -0500
Message-ID: <1519385092.2231.6.camel@sipsolutions.net> (sfid-20180223_122457_949460_D5FF72F4)
Subject: Re: [PATCH 4/4] mac80211: support station 4-addr mode fast-rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Fri, 23 Feb 2018 12:24:52 +0100
In-Reply-To: <20180223090606.55726-4-nbd@nbd.name>
References: <20180223090606.55726-1-nbd@nbd.name>
         <20180223090606.55726-4-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-02-23 at 10:06 +0100, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/mac80211/cfg.c |  2 --
>  net/mac80211/rx.c  | 11 +++++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 6f9d5beec73e..72b5a2ec4e94 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -160,7 +160,6 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>  	if (type == NL80211_IFTYPE_AP_VLAN &&
>  	    params && params->use_4addr == 0) {
>  		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
> -		ieee80211_check_fast_rx_iface(sdata);
>  	} else if (type == NL80211_IFTYPE_STATION &&
>  		   params && params->use_4addr >= 0) {
>  		sdata->u.mgd.use_4addr = params->use_4addr;
> @@ -1575,7 +1574,6 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>  			}
>  
>  			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
> -			__ieee80211_check_fast_rx_iface(vlansdata);
>  		}
>  
>  		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&

I'm not convinced this is right - don't you have to recheck to modify
the station data? Otherwise you'd just drop all the frames to the
slowpath again due to the first patch in the series, no?

johannes
