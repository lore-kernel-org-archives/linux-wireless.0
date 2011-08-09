Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1HIMUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:20:19 -0400
Subject: Re: [PATCH 1/2] mac80211: refactor sta_info_insert_rcu to 3 main
 stages
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311715772-8855-1-git-send-email-guy@wizery.com> (sfid-20110726_233144_501539_6CB55590)
References: <1311715772-8855-1-git-send-email-guy@wizery.com>
	 (sfid-20110726_233144_501539_6CB55590)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:20:17 +0200
Message-ID: <1312892417.4109.32.camel@jlt3.sipsolutions.net> (sfid-20110809_142022_536594_B959B17D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-27 at 00:29 +0300, Guy Eilam wrote:

> -int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
> +static int sta_info_insert_check(struct sta_info *sta)
>  {
> -	struct ieee80211_local *local = sta->local;
>  	struct ieee80211_sub_if_data *sdata = sta->sdata;
> -	unsigned long flags;
> -	int err = 0;
>  
>  	/*
>  	 * Can't be a WARN_ON because it can be triggered through a race:
>  	 * something inserts a STA (on one CPU) without holding the RTNL
>  	 * and another CPU turns off the net device.
>  	 */
> -	if (unlikely(!ieee80211_sdata_running(sdata))) {
> -		err = -ENETDOWN;
> -		rcu_read_lock();
> -		goto out_free;
> -	}
> +	if (unlikely(!ieee80211_sdata_running(sdata)))
> +		return -ENETDOWN;
>  
>  	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->vif.addr) == 0 ||
> -		    is_multicast_ether_addr(sta->sta.addr))) {
> -		err = -EINVAL;
> +		    is_multicast_ether_addr(sta->sta.addr)))
> +		return -EINVAL;
> +
> +	return 0;
> +}

That seems nice, even simplifying the code :)

> +static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)
> +{
> +	struct ieee80211_local *local = sta->local;
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&local->sta_lock, flags);
> +	/* check if STA exists already */
> +	if (sta_info_get_bss(sdata, sta->sta.addr)) {
> +		spin_unlock_irqrestore(&local->sta_lock, flags);
>  		rcu_read_lock();
> -		goto out_free;
> +		__sta_info_free(local, sta);
> +		return -EEXIST;
>  	}
>  
> -	/*
> -	 * In ad-hoc mode, we sometimes need to insert stations
> -	 * from tasklet context from the RX path. To avoid races,
> -	 * always do so in that case -- see the comment below.
> -	 */
> -	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
> -		spin_lock_irqsave(&local->sta_lock, flags);
> -		/* check if STA exists already */
> -		if (sta_info_get_bss(sdata, sta->sta.addr)) {
> -			spin_unlock_irqrestore(&local->sta_lock, flags);
> -			rcu_read_lock();
> -			err = -EEXIST;
> -			goto out_free;
> -		}
> -
> -		local->num_sta++;
> -		local->sta_generation++;
> -		smp_mb();
> -		sta_info_hash_add(local, sta);
> +	local->num_sta++;
> +	local->sta_generation++;
> +	smp_mb();
> +	sta_info_hash_add(local, sta);
>  
> -		list_add_tail(&sta->list, &local->sta_pending_list);
> +	list_add_tail(&sta->list, &local->sta_pending_list);
>  
> -		rcu_read_lock();
> -		spin_unlock_irqrestore(&local->sta_lock, flags);
> +	rcu_read_lock();
> +	spin_unlock_irqrestore(&local->sta_lock, flags);
>  
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> -		wiphy_debug(local->hw.wiphy, "Added IBSS STA %pM\n",
> -			    sta->sta.addr);
> +	wiphy_debug(local->hw.wiphy, "Added IBSS STA %pM\n",
> +			sta->sta.addr);
>  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
>  
> -		ieee80211_queue_work(&local->hw, &local->sta_finish_work);
> +	ieee80211_queue_work(&local->hw, &local->sta_finish_work);
>  
> -		return 0;
> -	}
> +	return 0;
> +}

Yup, that looks good too, just the patch is a bit odd due to the code
indentation change.

> +/*
> + * should be called with sta_mtx locked
> + * this function replaces the mutex lock
> + * with a RCU lock
> + */
> +static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
> +{
> +	struct ieee80211_local *local = sta->local;
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	unsigned long flags;
> +	int err = 0;
> +
> +	lockdep_assert_held(&local->sta_mtx);
>  
>  	/*
>  	 * On first glance, this will look racy, because the code
> -	 * below this point, which inserts a station with sleeping,
> +	 * in this function, which inserts a station with sleeping,
>  	 * unlocks the sta_lock between checking existence in the
>  	 * hash table and inserting into it.
>  	 *
>  	 * However, it is not racy against itself because it keeps
> -	 * the mutex locked. It still seems to race against the
> -	 * above code that atomically inserts the station... That,
> -	 * however, is not true because the above code can only
> -	 * be invoked for IBSS interfaces, and the below code will
> -	 * not be -- and the two do not race against each other as
> -	 * the hash table also keys off the interface.
> +	 * the mutex locked.
>  	 */
>  
> -	might_sleep();
> -
> -	mutex_lock(&local->sta_mtx);
> -
>  	spin_lock_irqsave(&local->sta_lock, flags);
>  	/* check if STA exists already */
>  	if (sta_info_get_bss(sdata, sta->sta.addr)) {
>  		spin_unlock_irqrestore(&local->sta_lock, flags);
>  		mutex_unlock(&local->sta_mtx);
>  		rcu_read_lock();
> -		err = -EEXIST;
> -		goto out_free;
> +		return -EEXIST;

Isn't that missing the free now?

>  	}
>  
>  	spin_unlock_irqrestore(&local->sta_lock, flags);
> @@ -466,7 +464,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
>  	if (err) {
>  		mutex_unlock(&local->sta_mtx);
>  		rcu_read_lock();
> -		goto out_free;
> +		return err;

and here?

> +int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
> +{
> +	struct ieee80211_local *local = sta->local;
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	int err = 0;
> +
> +	err = sta_info_insert_check(sta);
> +	if (err) {
> +		rcu_read_lock();
> +		goto out_free;
> +	}
> +
> +	/*
> +	 * In ad-hoc mode, we sometimes need to insert stations
> +	 * from tasklet context from the RX path. To avoid races,
> +	 * always do so in that case -- see the comment below.
> +	 */
> +	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
> +		return sta_info_insert_adhoc(sta);
> +
> +	/*
> +	 * It might seem that the function called below is in race against
> +	 * the function call above that atomically inserts the station... That,
> +	 * however, is not true because the above code can only
> +	 * be invoked for IBSS interfaces, and the below code will
> +	 * not be -- and the two do not race against each other as
> +	 * the hash table also keys off the interface.
> +	 */
> +
> +	might_sleep();
> +
> +	mutex_lock(&local->sta_mtx);
> +
> +	err = sta_info_insert_mgd(sta);
> +	if (err)
> +		goto out_free;
> +
> +	return 0;
>   out_free:
>  	BUG_ON(!err);
>  	__sta_info_free(local, sta);

Ah, ok, I guess not.

Hmm. Can we make the ibss vs. non-IBSS code paths more similar wrt.
freeing? The _ibss one will free it, but the _mgd one won't, that seems
a bit strange to me.

Also, I'd prefer to move the might_sleep/locking into _mgd() if
possible?

johannes

