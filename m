Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1HIMhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:37:06 -0400
Subject: Re: [PATCH v2 2/2] mac80211: fix race condition between assoc_done
 and first EAP packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311762139-18252-1-git-send-email-guy@wizery.com> (sfid-20110727_122441_437167_3B74A86C)
References: <1311762139-18252-1-git-send-email-guy@wizery.com>
	 (sfid-20110727_122441_437167_3B74A86C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:37:04 +0200
Message-ID: <1312893424.4109.41.camel@jlt3.sipsolutions.net> (sfid-20110809_143711_029617_6859EF7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-27 at 13:22 +0300, Guy Eilam wrote:

> +++ b/net/mac80211/mlme.c
> @@ -1495,10 +1495,14 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  
>  	ifmgd->aid = aid;
>  
> -	sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
> -	if (!sta) {
> -		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
> -		       " the AP\n", sdata->name);
> +	mutex_lock(&sdata->local->sta_mtx);
> +	/*
> +	 * station info was already allocated and inserted before
> +	 * the association and should be available to us
> +	 */
> +	sta = sta_info_get_rx(sdata, cbss->bssid);
> +	if (WARN_ON(!sta)) {
> +		mutex_unlock(&sdata->local->sta_mtx);
>  		return false;
>  	}
>  
> @@ -1569,8 +1573,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>  	if (elems.wmm_param)
>  		set_sta_flags(sta, WLAN_STA_WME);
>  
> -	err = sta_info_insert(sta);
> +	err = sta_info_insert_notify(sta);

I think I'd prefer if you could just call sta_info_insert() again with
the existing station entry?

>  	sta = NULL;
> +	/* sta_info_insert_notify changed the mutex lock with rcu lock */
> +	rcu_read_unlock();

This was previously part of sta_info_insert() right?

> +++ b/net/mac80211/rx.c
> @@ -842,8 +842,21 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
>  		      ieee80211_is_pspoll(hdr->frame_control)) &&
>  		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
>  		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
> -		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC))))
> +		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
> +		if (rx->sta && rx->sta->dummy &&
> +		    ieee80211_is_data(hdr->frame_control)) {
> +			u16 ethertype;
> +			u8 *payload;
> +
> +			payload = rx->skb->data +
> +				ieee80211_hdrlen(hdr->frame_control);
> +			ethertype = (payload[6] << 8) | payload[7];
> +			if (cpu_to_be16(ethertype) ==
> +				rx->sdata->control_port_protocol)

Is there a frame length check here? Also can you just indent the
rx->sdata part with four spaces instead of a tab so it's more clearly
part of the if please.

> +++ b/net/mac80211/sta_info.c
> @@ -102,6 +102,30 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>  				    lockdep_is_held(&local->sta_mtx));
>  	while (sta) {
>  		if (sta->sdata == sdata &&
> +		    !sta->dummy &&

maybe put those on one line

> @@ -450,17 +510,28 @@ static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
>  	 */
>  
>  	spin_lock_irqsave(&local->sta_lock, flags);
> -	/* check if STA exists already */
> -	if (sta_info_get_bss(sdata, sta->sta.addr)) {
> -		spin_unlock_irqrestore(&local->sta_lock, flags);
> -		mutex_unlock(&local->sta_mtx);
> -		rcu_read_lock();
> -		return -EEXIST;
> +	/*
> +	 * check if STA exists already.
> +	 * only accept a scenario of a second call to sta_info_insert_mgd
> +	 * with a dummy station entry that was inserted earlier
> +	 * in that case - assume that the dummy station flag should
> +	 * be removed.
> +	 */
> +	exist_sta = sta_info_get_bss_rx(sdata, sta->sta.addr);
> +	if (exist_sta) {
> +		if (exist_sta == sta && sta->dummy && !sta_list_add) {
> +			sta->dummy = false;

two things: why "sta_list_add"? I think it can be implicit.

Secondly, I think sta->dummy must only be set to false in
finish_insert(), when it would typically add it into the hash table etc.
to preserve the right order of things and not introduce races with
finding a non-dummy station that hasn't been fully inserted yet.

>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> -	wiphy_debug(local->hw.wiphy, "Inserted STA %pM\n", sta->sta.addr);
> +	wiphy_debug(local->hw.wiphy, "Inserted %sSTA %pM\n",
> +			sta->dummy ? "Dummy " : "", sta->sta.addr);
>  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */

I think you should lowercase "dummy" in debug messages where it's and
adjective :)
 
>  	/* move reference to rcu-protected */
>  	rcu_read_lock();
>  	mutex_unlock(&local->sta_mtx);
>  
> -	if (ieee80211_vif_is_mesh(&sdata->vif))
> +	if (ieee80211_vif_is_mesh(&sdata->vif) && !sta->dummy)
>  		mesh_accept_plinks_update(sdata);

why this? can't have a dummy on mesh anyway, no?
 
> @@ -435,9 +440,15 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
>  struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>  			      const u8 *addr);
>  
> +struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
> +			      const u8 *addr);
> +
>  struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
>  				  const u8 *addr);
>  
> +struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
> +				  const u8 *addr);
> +
>  static inline
>  void for_each_sta_info_type_check(struct ieee80211_local *local,
>  				  const u8 *addr,
> @@ -458,6 +469,22 @@ void for_each_sta_info_type_check(struct ieee80211_local *local,
>  		_sta = nxt,						\
>  		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
>  	     )								\
> +	/* run code only if address matches and it's not a dummy sta */	\
> +	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0 &&\

please keep the backslashes lined up

Ok the only real problem is the place where you set dummy=false, but I'd
also make the patch & code simpler by making it more implicit -- instead
of having the sta_list_add argument everywhere I'd just check if it's a
dummy being re-inserted etc. 

johannes

