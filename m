Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51819 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1JSSEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 14:04:00 -0400
Message-ID: <4E9F110A.5000608@candelatech.com> (sfid-20111019_200407_284364_114DACA6)
Date: Wed, 19 Oct 2011 11:03:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211: fix remain_off_channel regression
References: <1311607763-12603-1-git-send-email-eliad@wizery.com> <1311607763-12603-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1311607763-12603-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 08:29 AM, Eliad Peller wrote:
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
>
> Signed-off-by: Eliad Peller<eliad@wizery.com>

Both Johannes and I agreed with this patch shortly after it
was posted, and I have just done a quick test with multiple
stations and it appears to work fine.

Eliad:  Please re-send this patch w/out the RFC, and you
can add:

Tested-by: Ben Greear <greearb@candelatech.com>

Thanks,
Ben



> ---
>   net/mac80211/work.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index a94b312..3291958 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -1068,8 +1068,8 @@ static void ieee80211_work_work(struct work_struct *work)
>   			continue;
>   		if (wk->chan != local->tmp_channel)
>   			continue;
> -		if (ieee80211_work_ct_coexists(wk->chan_type,
> -					       local->tmp_channel_type))
> +		if (!ieee80211_work_ct_coexists(wk->chan_type,
> +						local->tmp_channel_type))
>   			continue;
>   		remain_off_channel = true;
>   	}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

