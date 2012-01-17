Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:56421 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab2AQNR7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:17:59 -0500
Message-ID: <4F157505.3060306@lri.fr> (sfid-20120117_141801_887100_91CEA0D5)
Date: Tue, 17 Jan 2012 14:17:57 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion
References: <1326737526-29750-1-git-send-email-ordex@autistici.org>
In-Reply-To: <1326737526-29750-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/01/2012 19:12, Antonio Quartulli wrote:
> -static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
> +static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
> +						  bool auth)
>  	__acquires(RCU)
>  {
>  	struct ieee80211_sub_if_data *sdata = sta->sdata;
> @@ -289,13 +265,15 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
>  		    addr, sdata->name);
>  #endif
>  
> +	if (auth) {
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -	printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
> -	       "(auth_transaction=1)\n", sdata->vif.addr,
> -	       sdata->u.ibss.bssid, addr);
> +		printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
> +		       "(auth_transaction=1)\n", sdata->vif.addr,
> +		       sdata->u.ibss.bssid, addr);
>  #endif
> -	ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
> -			    addr, sdata->u.ibss.bssid, NULL, 0, 0);
> +		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
> +				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
> +	}
>  
>  	sta_info_move_state(sta, IEEE80211_STA_AUTH);
>  	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
[added context]
	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);

	rate_control_rate_init(sta);

	/* If it fails, maybe we raced another insertion? */
	if (sta_info_insert_rcu(sta))
		return sta_info_get(sdata, addr);
	return sta;
}


I tested your patch, but quickly run into a race condition where i would
get Auth frame multiplication.

The worst case apparently happen when A boots for the first time and the
first message that B receives is an Auth frame.  In that case, there are
several ieee80211_ibss_add_sta() calls running concurrently on B  (A and
B are SMP systems)  but only one succeeds,  except that your patch sends
Auth frames before the check, so B sends several Auth frames to A.

Then A proceed to reset B.  After A deletes B's sta_info,  but before
it reinserts it, some other code (ieee80211_ibss_rx_no_sta?) may call
ieee80211_ibss_add_sta()  concurrently,  sending more Auth frames...
increasing the odds of another race condition...

By calling send_auth only when sta_info_insert_rcu() succeeds, i'm no
longer able to reproduce the Auth flood.
