Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1HIMNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:13:42 -0400
Subject: Re: [RFC 1/2] mac80211: fix remain_off_channel regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311607763-12603-2-git-send-email-eliad@wizery.com> (sfid-20110725_172946_527229_E71DD0F8)
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	 <1311607763-12603-2-git-send-email-eliad@wizery.com>
	 (sfid-20110725_172946_527229_E71DD0F8)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:13:40 +0200
Message-ID: <1312892020.4109.26.camel@jlt3.sipsolutions.net> (sfid-20110809_141345_643026_200C3379)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-25 at 18:29 +0300, Eliad Peller wrote:
> i'm not familiar enough with the off_channel flow,
> but this one looks completely broken - we should
> remain_off_channel if the work was started, and
> the work's channel and channel_type are the same
> as local->tmp_channel and local->tmp_channel_type.
> 
> however, if wk->chan_type and local->tmp_channel_type
> coexist (e.g. have the same channel type), we won't
> remain_off_channel.
> 
> this behavior was introduced by commit da2fd1f
> ("mac80211: Allow work items to use existing
> channel type.")

Yeah this seems obvious.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Now that I look at ieee80211_work_ct_coexists() itself again though it
seems to do HT20 wrong?

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/work.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index a94b312..3291958 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -1068,8 +1068,8 @@ static void ieee80211_work_work(struct work_struct *work)
>  			continue;
>  		if (wk->chan != local->tmp_channel)
>  			continue;
> -		if (ieee80211_work_ct_coexists(wk->chan_type,
> -					       local->tmp_channel_type))
> +		if (!ieee80211_work_ct_coexists(wk->chan_type,
> +						local->tmp_channel_type))
>  			continue;
>  		remain_off_channel = true;
>  	}


