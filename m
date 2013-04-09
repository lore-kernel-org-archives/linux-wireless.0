Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3DIJ6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:58:02 -0400
Message-ID: <1365501478.8465.17.camel@jlt4.sipsolutions.net> (sfid-20130409_115808_969808_46938599)
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX
 performance.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Apr 2013 11:57:58 +0200
In-Reply-To: <1365007698-25295-1-git-send-email-greearb@candelatech.com> (sfid-20130403_184908_772897_29241D1E)
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130403_184908_772897_29241D1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 09:48 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When one has multiple station VIFS all connected to the same
> AP, the rx logic becomes a linear walk of all stations.  To
> improve performance in this case, hash the station VIFs on
> the VIF MAC.  This significantly improves performance:  70Mbps
> without the patch, 190Mbps with patch, when using 50 stations
> receiving TCP traffic.
> 
> Probably not many people doing this, so not worth pushing upstream
> at this time.

I tend to agree.

> +++ b/net/mac80211/sta_info.c
> @@ -77,19 +77,42 @@ static int sta_info_hash_del(struct ieee80211_local *local,
>  	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
>  				      lockdep_is_held(&local->sta_mtx));
>  	if (!s)
> -		return -ENOENT;
> +		goto try_lhash;

Does this make sense? If the station doesn't exist in the regular hash,
it really shouldn't be in the vif hash either, no?

>  	if (rcu_access_pointer(s->hnext)) {
>  		rcu_assign_pointer(s->hnext, sta->hnext);
> +		goto try_lhash;
> +	}
> +
> +	/* Remove from the local VIF addr hash */
> +try_lhash:

That last goto there seems a bit pointless :)

> +	s = rcu_dereference_protected(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
> +				      lockdep_is_held(&local->sta_mtx));
> +	if (!s)
> +		return -ENONET;

You probably want -ENOENT, not -ENONET.

> +struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
> +				     const u8 *vif_addr, const u8 * sta_addr) {
> +	struct sta_info *sta;
> +
> +	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(vif_addr)],
> +				    lockdep_is_held(&local->sta_mtx));
> +	while (sta) {
> +		if (ether_addr_equal(sta->sdata->vif.addr, vif_addr) &&
> +		    ether_addr_equal(sta->sta.addr, sta_addr))
> +			break;
> +		sta = rcu_dereference_check(sta->vnext,
> +					    lockdep_is_held(&local->sta_mtx));

Almost all of your rcu_dereference_check() invocations should be
rcu_dereference_protected(). See include/linux/rcupdate.h :)

johannes

