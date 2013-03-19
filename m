Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3CSUMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:12:39 -0400
Message-ID: <1363723948.8336.15.camel@jlt4.sipsolutions.net> (sfid-20130319_211243_931265_DFC5E9C8)
Subject: Re: [RFC 2/2] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 21:12:28 +0100
In-Reply-To: <1363381993-31496-2-git-send-email-greearb@candelatech.com> (sfid-20130315_221333_293041_95169062)
References: <1363381993-31496-1-git-send-email-greearb@candelatech.com>
	 <1363381993-31496-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130315_221333_293041_95169062)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-15 at 14:13 -0700, greearb@candelatech.com wrote:
 
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -669,6 +669,12 @@ struct ieee80211_sub_if_data {
>  	/* count for keys needing tailroom space allocation */
>  	int crypto_tx_tailroom_needed_cnt;
>  
> +	/* A pointer to some station associated with this interface, or
> +	 * NULL.  This aids oportunistic lookup for sta_info objects when

typo: opportunistic. Also it should probably say "allows opportunistic
lookup" :-)

> +	/* Shortcut for finding station entries when sdata is a station */
> +	some_sta = rcu_dereference(sdata->some_sta);
> +	if (some_sta) {
> +		if (WARN_ON(some_sta->sdata != sdata))
> +			rcu_assign_pointer(sdata->some_sta, NULL);
> +		else
> +			if (ether_addr_equal(some_sta->sta.addr, addr))
> +				return some_sta;

I worry a little bit about the overhead in the "always cache miss" case.
Is this really helpful for AP interfaces? Maybe it should be limited to
managed virtual interfaces.

>  
>  	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
>  				    lockdep_is_held(&local->sta_mtx));
> @@ -263,10 +273,14 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
>   */
>  void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
>  {
> +	struct sta_info* some_sta;
>  	if (sta->rate_ctrl)

missing blank line

>  		rate_control_free_sta(sta);
>  
>  	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
> +	some_sta = rcu_dereference(sta->sdata->some_sta);
> +	if (some_sta == sta)
> +		rcu_assign_pointer(sta->sdata->some_sta, NULL);

This clearing is WAY too late. You can look up the station way after you
must be allowed to, this will invariably crash eventually. It absolutely
must be when the station is unhashed, not when it's freed.

> @@ -373,6 +387,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
>  		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
>  
> +	rcu_assign_pointer(sta->sdata->some_sta, sta);

This is too early, the station might not even be used, this must only be
done when the station is hashed.

johannes

