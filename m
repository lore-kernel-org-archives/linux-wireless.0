Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3FLUrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 16:47:15 -0400
Message-ID: <1371070023.8601.36.camel@jlt4.sipsolutions.net> (sfid-20130612_224718_867405_8F885F46)
Subject: Re: [RFC] mac80211:  Ensure tid_start_tx is protected by sta->lock.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 22:47:03 +0200
In-Reply-To: <1371068409-10407-1-git-send-email-greearb@candelatech.com> (sfid-20130612_222023_756658_E80BFC74)
References: <1371068409-10407-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130612_222023_756658_E80BFC74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-12 at 13:20 -0700, greearb@candelatech.com wrote:

> I believe this is more correct, though it did not fix the
> memory leak I was chasing when I found this code.

That description could use some work :-)

> +		spin_lock_bh(&sta->lock);
> +
>  		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
>  		if (tid_tx) {
>  			/*
>  			 * Assign it over to the normal tid_tx array
>  			 * where it "goes live".
>  			 */
> -			spin_lock_bh(&sta->lock);
>  
>  			sta->ampdu_mlme.tid_start_tx[tid] = NULL;
>  			/* could there be a race? */
> @@ -301,6 +302,8 @@ void ieee80211_ba_session_work(struct work_struct *work)
>  
>  			ieee80211_tx_ba_session_handle_start(sta, tid);
>  			continue;
> +		} else {
> +			spin_unlock_bh(&sta->lock);
>  		}
>  

You could just put the unlock after the if block, given the continue in
it, I think I'd prefer that.

>  		tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index c509423..0f85418 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -204,6 +204,7 @@ struct tid_ampdu_rx {
>   *	driver requested to close until the work for it runs
>   * @mtx: mutex to protect all TX data (except non-NULL assignments
>   *	to tid_tx[idx], which are protected by the sta spinlock)
> + *      tid_start_tx is also protected by sta->lock.

That should be a tab.

johannes

