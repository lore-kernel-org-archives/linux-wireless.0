Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42120 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752707AbaCXMZv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 08:25:51 -0400
Message-ID: <1395663944.4515.45.camel@dubbel> (sfid-20140324_132555_576498_F686B297)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 24 Mar 2014 14:25:44 +0200
In-Reply-To: <1395408675-26013-2-git-send-email-michal.kazior@tieto.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/4] mac80211: fix CSA tx queue locking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
> It was possible for tx queues to be stuck locked
> if AP CSA finalization failed.

I think it's clearer if you say "tx queue stopping" or something to
avoid confusion with the word "locking".  Same applies to the commit
subject.

[...]
> It is still possible to have tx queues stopped
> after CSA failure but as soon as offending
> interfaces are stopped from userspace (stop_ap or
> ifdown) tx queues are woken up properly.

Isn't there any way to avoid this? I mean, if you have identified some
cases, why not fix them too? :)

[...]
> @@ -3092,8 +3122,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>  		goto unlock;
>  
>  	ieee80211_csa_finalize(sdata);
> +	if (!ieee80211_csa_needs_block_tx(local))
> +		ieee80211_wake_queues_by_reason(&local->hw,
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);

This should remain inside ieee80211_csa_finalize() as it was before,
because otherwise you won't wake up the queues in case of an immediate
switch.  Look at the bottom of your new  __ieee80211_channel_switch(),
we call ieee80211_csa_finalize() directly if the beacon didn't change.

Actually, in the beacon-didn't-change case, we should probably not even
stop the queues?

[...]
> @@ -3271,15 +3307,15 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>  		return err;
>  
>  	sdata->csa_radar_required = params->radar_required;
> -
> -	if (params->block_tx)
> -		ieee80211_stop_queues_by_reason(&local->hw,
> -				IEEE80211_MAX_QUEUE_MAP,
> -				IEEE80211_QUEUE_STOP_REASON_CSA);
> -
>  	sdata->csa_chandef = params->chandef;
> +	sdata->csa_block_tx = params->block_tx;
>  	sdata->vif.csa_active = true;
>  
> +	if (sdata->csa_block_tx)
> +		ieee80211_wake_queues_by_reason(&local->hw,
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);

Shouldn't this be *stop* queues?

You can call ieee80211_stop_queues_by_reason() even if it is already
stopped for this reason, but maybe you could call
ieee80211_csa_needs_block_tx() here to avoid eventually calling it
multiple times.  I think this is also a bit more consistent.

	if(ieee80211_csa_needs_block_tx(...))
		ieee80211_stop_queues_by_reason(...)


[...]
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index bbc2175..2ca1472 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -952,15 +952,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>  	/* XXX: shouldn't really modify cfg80211-owned data! */
>  	ifmgd->associated->channel = sdata->csa_chandef.chan;
>  
> -	/* XXX: wait for a beacon first? */
> -	ieee80211_wake_queues_by_reason(&local->hw,
> -					IEEE80211_MAX_QUEUE_MAP,
> -					IEEE80211_QUEUE_STOP_REASON_CSA);
> -
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  
>   out:
> +	mutex_lock(&local->mtx);
>  	sdata->vif.csa_active = false;
> +	/* XXX: wait for a beacon first? */
> +	if (!ieee80211_csa_needs_block_tx(local))
> +		ieee80211_wake_queues_by_reason(&local->hw,
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);
> +	mutex_unlock(&local->mtx);

Instead of moving this to the out label, I guess the right place for it
would be in ieee80211_set_disassoc().  Then we would catch the
csa_connection_drop_work cases plus a few other cases that seem to be
missing(?).

[...]
> @@ -1077,12 +1080,16 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>  	mutex_unlock(&local->chanctx_mtx);
>  
>  	sdata->csa_chandef = csa_ie.chandef;
> +
> +	mutex_lock(&local->mtx);
>  	sdata->vif.csa_active = true;
> +	sdata->csa_block_tx = csa_ie.mode;
>  
> -	if (csa_ie.mode)
> +	if (sdata->csa_block_tx)
>  		ieee80211_stop_queues_by_reason(&local->hw,
> -				IEEE80211_MAX_QUEUE_MAP,
> -				IEEE80211_QUEUE_STOP_REASON_CSA);
> +					IEEE80211_MAX_QUEUE_MAP,
> +					IEEE80211_QUEUE_STOP_REASON_CSA);
> +	mutex_unlock(&local->mtx);

Same thing as before, maybe it's more consistent to call
ieee80211_csa_needs_block_tx()?

[...]
> @@ -2035,10 +2043,14 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
>  			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
>  			       true, frame_buf);
>  	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
> +
> +	mutex_lock(&local->mtx);
>  	sdata->vif.csa_active = false;
> -	ieee80211_wake_queues_by_reason(&sdata->local->hw,
> +	if (!ieee80211_csa_needs_block_tx(local))
> +		ieee80211_wake_queues_by_reason(&local->hw,
>  					IEEE80211_MAX_QUEUE_MAP,
>  					IEEE80211_QUEUE_STOP_REASON_CSA);
> +	mutex_unlock(&local->mtx);

As I said before, it's probably better to do this in
ieee80211_set_disassoc().  But maybe in a separate patch?

--
Luca.

