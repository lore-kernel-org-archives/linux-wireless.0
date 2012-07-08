Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37431 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2GHOer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 10:34:47 -0400
Message-ID: <4FF99A80.9040700@candelatech.com> (sfid-20120708_163451_418840_C1C14F8A)
Date: Sun, 08 Jul 2012 07:34:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: use full power if off-channel
References: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2012 02:35 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of using full power when scanning, use
> full power when off-channel. This is different
> since off-channel can be remain-on-channel.

What if we are scanning on our current channel?  Shouldn't
it be full-power then as well?

Thanks,
Ben

>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mac80211/main.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index e706f9e..35c4b1d 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -148,9 +148,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>   		changed |= IEEE80211_CONF_CHANGE_SMPS;
>   	}
>
> -	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
> -	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
> -	    test_bit(SCAN_HW_SCANNING, &local->scanning))
> +	if (local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL)
>   		power = chan->max_power;
>   	else
>   		power = local->power_constr_level ?
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


