Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbBXHfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 02:35:08 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: [PATCH] mac80211: iterate using station list in AP SMPS
Date: Tue, 24 Feb 2015 07:35:03 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B655045@hasmsx107.ger.corp.intel.com> (sfid-20150224_083513_094701_82B127F5)
References: <1424734489-19115-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1424734489-19115-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When changing AP SMPS, we need to look up all the stations for this
> interface, so there's no reason to iterate over hash chains rather than doing
> the simpler iteration over the station list.

Yup - thank you for that.
I remember I tried to find a better to do that when I implemented this back then, don't why I didn't do what you are doing now...


> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c | 69 ++++++++++++++++++++++++------------------------
> ------
>  1 file changed, 30 insertions(+), 39 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c index
> dd4ff36c557a..06557e4f9588 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2273,7 +2273,6 @@ int __ieee80211_request_smps_ap(struct
> ieee80211_sub_if_data *sdata,  {
>  	struct sta_info *sta;
>  	enum ieee80211_smps_mode old_req;
> -	int i;
> 
>  	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_AP))
>  		return -EINVAL;
> @@ -2301,48 +2300,40 @@ int __ieee80211_request_smps_ap(struct
> ieee80211_sub_if_data *sdata,
>  	       smps_mode, atomic_read(&sdata->u.ap.num_mcast_sta));
> 
>  	mutex_lock(&sdata->local->sta_mtx);
> -	for (i = 0; i < STA_HASH_SIZE; i++) {
> -		for (sta = rcu_dereference_protected(sdata->local-
> >sta_hash[i],
> -				lockdep_is_held(&sdata->local->sta_mtx));
> -		     sta;
> -		     sta = rcu_dereference_protected(sta->hnext,
> -				lockdep_is_held(&sdata->local->sta_mtx))) {
> -			/*
> -			 * Only stations associated to our AP and
> -			 * associated VLANs
> -			 */
> -			if (sta->sdata->bss != &sdata->u.ap)
> -				continue;
> +	list_for_each_entry(sta, &sdata->local->sta_list, list) {
> +		/*
> +		 * Only stations associated to our AP and
> +		 * associated VLANs
> +		 */
> +		if (sta->sdata->bss != &sdata->u.ap)
> +			continue;
> 
> -			/* This station doesn't support MIMO - skip it */
> -			if (sta_info_tx_streams(sta) == 1)
> -				continue;
> +		/* This station doesn't support MIMO - skip it */
> +		if (sta_info_tx_streams(sta) == 1)
> +			continue;
> 
> -			/*
> -			 * Don't wake up a STA just to send the action frame
> -			 * unless we are getting more restrictive.
> -			 */
> -			if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
> -			    !ieee80211_smps_is_restrictive(sta-
> >known_smps_mode,
> -							   smps_mode)) {
> -				ht_dbg(sdata,
> -				       "Won't send SMPS to sleeping STA
> %pM\n",
> -				       sta->sta.addr);
> -				continue;
> -			}
> +		/*
> +		 * Don't wake up a STA just to send the action frame
> +		 * unless we are getting more restrictive.
> +		 */
> +		if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
> +		    !ieee80211_smps_is_restrictive(sta->known_smps_mode,
> +						   smps_mode)) {
> +			ht_dbg(sdata, "Won't send SMPS to sleeping STA
> %pM\n",
> +			       sta->sta.addr);
> +			continue;
> +		}
> 
> -			/*
> -			 * If the STA is not authorized, wait until it gets
> -			 * authorized and the action frame will be sent then.
> -			 */
> -			if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
> -				continue;
> +		/*
> +		 * If the STA is not authorized, wait until it gets
> +		 * authorized and the action frame will be sent then.
> +		 */
> +		if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
> +			continue;
> 
> -			ht_dbg(sdata, "Sending SMPS to %pM\n", sta-
> >sta.addr);
> -			ieee80211_send_smps_action(sdata, smps_mode,
> -						   sta->sta.addr,
> -						   sdata->vif.bss_conf.bssid);
> -		}
> +		ht_dbg(sdata, "Sending SMPS to %pM\n", sta->sta.addr);
> +		ieee80211_send_smps_action(sdata, smps_mode, sta-
> >sta.addr,
> +					   sdata->vif.bss_conf.bssid);
>  	}
>  	mutex_unlock(&sdata->local->sta_mtx);
> 
> --
> 2.1.4

