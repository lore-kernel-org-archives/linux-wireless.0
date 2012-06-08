Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59017 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614Ab2FHRsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:48:03 -0400
Date: Fri, 8 Jun 2012 13:39:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: stop Rx during HW reconfig
Message-ID: <20120608173901.GC13889@tuxdriver.com> (sfid-20120608_194809_755227_618F29EF)
References: <1338971102-4872-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338971102-4872-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should this go to 3.5 and/or stable?

On Wed, Jun 06, 2012 at 11:25:02AM +0300, Arik Nemtsov wrote:
> While HW reconfig is in progress, drop all incoming Rx. This prevents
> incoming packets from changing the internal state of the driver or
> calling callbacks of the low level driver while it is in inconsistent
> state.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  net/mac80211/ieee80211_i.h |    3 +++
>  net/mac80211/main.c        |    7 +++++++
>  net/mac80211/rx.c          |    4 ++++
>  net/mac80211/util.c        |    3 +++
>  4 files changed, 17 insertions(+)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ae046b5..04e8912 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -912,6 +912,9 @@ struct ieee80211_local {
>  	/* device is started */
>  	bool started;
>  
> +	/* device is during a HW reconfig */
> +	bool in_reconfig;
> +
>  	/* wowlan is enabled -- don't reconfig on resume */
>  	bool wowlan;
>  
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index b70f7f0..eb4a5b9 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -345,6 +345,13 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
>  	ieee80211_stop_queues_by_reason(hw,
>  		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
>  
> +	/*
> +	 * Stop all Rx during the reconfig. We don't want state changes
> +	 * or driver callbacks while this is in progress.
> +	 */
> +	local->in_reconfig = true;
> +	barrier();
> +
>  	schedule_work(&local->restart_work);
>  }
>  EXPORT_SYMBOL(ieee80211_restart_hw);
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index d5ac02f..3b488e3 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -3033,6 +3033,10 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	if (unlikely(local->quiescing || local->suspended))
>  		goto drop;
>  
> +	/* We might be during a HW reconfig, prevent Rx for the same reason */
> +	if (unlikely(local->in_reconfig))
> +		goto drop;
> +
>  	/*
>  	 * The same happens when we're not even started,
>  	 * but that's worth a warning.
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 76f90c1..ee46273 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1399,6 +1399,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		if (ieee80211_sdata_running(sdata))
>  			ieee80211_enable_keys(sdata);
>  
> +	local->in_reconfig = false;
> +	barrier();
> +
>   wake_up:
>  	/*
>  	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
