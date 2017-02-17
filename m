Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51974 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933361AbdBQKJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 05:09:10 -0500
Subject: Re: [linux-stable] 4fc2942b6e kernel BUG at
 kernel/time/hrtimer.c:109!
To: Thomas Gleixner <tglx@linutronix.de>,
        kernel test robot <fengguang.wu@intel.com>
References: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com>
 <alpine.DEB.2.20.1702171014430.3536@nanos>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sasha Levin <alexander.levin@verizon.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com> (sfid-20170217_110958_816816_1EF27E2D)
Date: Fri, 17 Feb 2017 10:09:06 +0000
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702171014430.3536@nanos>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/02/17 09:28, Thomas Gleixner wrote:
> On Fri, 17 Feb 2017, kernel test robot wrote:
> 
>> Hi Marc,
>>
>> We find this oops in linux-4.4.y. The gcc-6 compiled mainline kernel is fine.

The last bit is worrying, as mainline has the exact same bug. Has it
been tested the same way?

>>
>> commit 4fc2942b6e2de2efc8a9d3784d4b0d3543149613
>>      hrtimer: Catch illegal clockids
> 
> And that commit is doing what the subject line says. Catch illegal usage.
> 
>> [   38.101342] Call Trace:
>> [   38.101342] Call Trace:
>> [   38.102045]  [<ffffffff8109aee1>] tasklet_hrtimer_init+0x16/0x52
>> [   38.102045]  [<ffffffff8109aee1>] tasklet_hrtimer_init+0x16/0x52
>> [   38.103698]  [<ffffffff81c767c7>] mac80211_hwsim_new_radio+0x766/0x84d
> 
> The real bug is in this code:
> 
> drivers/net/wireless/mac80211_hwsim.c
> 
> mac80211_hwsim_new_radio()
> 
>         tasklet_hrtimer_init(&data->beacon_timer,
>                              mac80211_hwsim_beacon,
>                              CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
> 
> CLOCK_MONOTONIC_RAW is not a supported clockid for hrtimers. Sigh.
> 
> Fix below.
> 
> Thanks,
> 
> 	tglx
> 
> 8<------------------
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 0cd95120bc78..da363ec91a1c 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2535,9 +2535,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  				    data->debugfs,
>  				    data, &hwsim_simulate_radar);
>  
> -	tasklet_hrtimer_init(&data->beacon_timer,
> -			     mac80211_hwsim_beacon,
> -			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
> +	tasklet_hrtimer_init(&data->beacon_timer, mac80211_hwsim_beacon,
> +			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>  
>  	spin_lock_bh(&hwsim_radio_lock);
>  	list_add_tail(&data->list, &hwsim_radios);
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
