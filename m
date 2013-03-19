Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3CSUVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:21:40 -0400
Message-ID: <1363724490.8336.18.camel@jlt4.sipsolutions.net> (sfid-20130319_212154_017216_D724C3C7)
Subject: Re: [PATCH v2] mac80211:  Don't restart sta-timer if not associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 21:21:30 +0100
In-Reply-To: <1363307043-23771-1-git-send-email-greearb@candelatech.com> (sfid-20130315_012436_532333_DCDE8CD4)
References: <1363307043-23771-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130315_012436_532333_DCDE8CD4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-14 at 17:24 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> I found another crash when deleting lots of virtual stations
> in a congested environment.  I think the problem is that
> the ieee80211_mlme_notify_scan_completed could call
> ieee80211_restart_sta_timer for a non-associated interface
> that was about to be deleted.
> 
> With the following patch I am unable to reproduce the
> crash.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> v2:  Be more selective:  Still need to do sdata->work even
>   if not associated so that we *can* associate.
> 
> :100644 100644 81e0619... da805e2... M	net/mac80211/mlme.c
>  net/mac80211/mlme.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 81e0619..da805e2 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2935,11 +2935,14 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
>  
>  		/* let's probe the connection once */
>  		flags = sdata->local->hw.flags;
> -		if (!(flags & IEEE80211_HW_CONNECTION_MONITOR))
> +		if ((!(flags & IEEE80211_HW_CONNECTION_MONITOR)) &&
> +		    sdata->u.mgd.associated)

You really didn't need those extra parentheses :-)

>  			ieee80211_queue_work(&sdata->local->hw,
>  					     &sdata->u.mgd.monitor_work);
> +
>  		/* and do all the other regular work too */
> -		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
> +		if (ieee80211_sdata_running(sdata))
> +			ieee80211_queue_work(&sdata->local->hw, &sdata->work);

Overall, it seems that it would be safe to just check
ieee80211_sdata_running() in the beginning of the function instead?

Maybe you could also look at the ibss/mesh code and fix this issue for
good?

johannes

