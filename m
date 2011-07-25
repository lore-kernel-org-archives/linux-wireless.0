Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40878 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1GYRSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 13:18:31 -0400
Message-ID: <4E2DA564.5070305@candelatech.com> (sfid-20110725_191834_961898_92A781D4)
Date: Mon, 25 Jul 2011 10:18:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
References: <1311607763-12603-1-git-send-email-eliad@wizery.com> <1311607763-12603-3-git-send-email-eliad@wizery.com>
In-Reply-To: <1311607763-12603-3-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 08:29 AM, Eliad Peller wrote:
> The hw is currently not configured when going
> back on-channel.

I am less sure about this patch.  With the existing code,
I think it should catch going from on channel to off
and do the hw config properly.

With your change it will also reconfig the hardware, but it will
reconfig even if we were already on-channel (if, for instance,
local->tmp_channel is oper-channel), right?

Can you please explain in more detail how this code is
broken?

Thanks,
Ben

>
> Signed-off-by: Eliad Peller<eliad@wizery.com>
> ---
>   net/mac80211/work.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 3291958..e6abb15 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -1075,7 +1075,6 @@ static void ieee80211_work_work(struct work_struct *work)
>   	}
>
>   	if (!remain_off_channel&&  local->tmp_channel) {
> -		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>   		local->tmp_channel = NULL;
>   		/* If tmp_channel wasn't operating channel, then
>   		 * we need to go back on-channel.
> @@ -1085,7 +1084,7 @@ static void ieee80211_work_work(struct work_struct *work)
>   		 * we still need to do a hardware config.  Currently,
>   		 * we cannot be here while scanning, however.
>   		 */
> -		if (ieee80211_cfg_on_oper_channel(local)&&  !on_oper_chan)
> +		if (!ieee80211_cfg_on_oper_channel(local))
>   			ieee80211_hw_config(local, 0);
>
>   		/* At the least, we need to disable offchannel_ps,


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

