Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2E2JHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 05:07:50 -0400
Message-ID: <1338282467.4342.31.camel@jlt3.sipsolutions.net> (sfid-20120529_110753_439344_45AC97D7)
Subject: Re: [PATCH] mac80211: fix ADDBA declined after suspend with wowlan
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 11:07:47 +0200
In-Reply-To: <1338282022-28857-1-git-send-email-eyal@wizery.com> (sfid-20120529_110103_492186_1380448B)
References: <1338282022-28857-1-git-send-email-eyal@wizery.com>
	 (sfid-20120529_110103_492186_1380448B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-29 at 02:00 -0700, Eyal Shapira wrote:
> WLAN_STA_BLOCK_BA is set while suspending but doesn't get cleared
> when resuming in case of wowlan. This causes further ADDBA requests
> received to be rejected. Fix it by clearing it in the wowlan path
> as well.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Cc: stable I think as well


> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
> The diff is a bit confusing as it appears to 
> be messing with the keys but actually what happens 
> here is that we move the BLOCK_BA code block 
> below the wake_up label so it'll get called in 
> the wowlan path as well.
> Git was adamant about formatting the diff this way.
> 
>  net/mac80211/util.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 22f2216..a44c680 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1371,6 +1371,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		}
>  	}
>  
> +	/* add back keys */
> +	list_for_each_entry(sdata, &local->interfaces, list)
> +		if (ieee80211_sdata_running(sdata))
> +			ieee80211_enable_keys(sdata);
> +
> + wake_up:
>  	/*
>  	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
>  	 * sessions can be established after a resume.
> @@ -1392,12 +1398,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		mutex_unlock(&local->sta_mtx);
>  	}
>  
> -	/* add back keys */
> -	list_for_each_entry(sdata, &local->interfaces, list)
> -		if (ieee80211_sdata_running(sdata))
> -			ieee80211_enable_keys(sdata);
> -
> - wake_up:
>  	ieee80211_wake_queues_by_reason(hw,
>  			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
>  


