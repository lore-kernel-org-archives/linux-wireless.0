Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45112 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0I2QpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 12:45:12 -0400
Message-ID: <4CA36D14.9080400@candelatech.com>
Date: Wed, 29 Sep 2010 09:45:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: vif adhoc fixup
References: <20100929092221.12160.62425.stgit@tt-desk>
In-Reply-To: <20100929092221.12160.62425.stgit@tt-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 02:22 AM, Bruno Randolf wrote:
> hi ben!
>
> i made these changes on top of your v7 patch, please tell me what you think!
> and feel free to merge the changes into your patch, if you agree with them.

I'll merge them in and do some quick testing and re-post the full
patch.

> use staggered beacons only when multiple AP interfaces are configured.
> this fixes single-interface ad-hoc mode and also reduces the impact of the vif
> changes for the more common single-interface AP setups (beacon interval and
> SWBA interrupts).
>
> btw: we can always only have one ad-hoc interface. mac80211 makes sure of that,
> because it's impossible to synchronize to more than one TSF. this is the most
> important "feature" of ad-hoc, i think: it has to (and will) adapt the TSF of
> beacons in the same IBSS. that means the local TSF can make jumps (into the
> future only).
>
> i'm not sure where that leaves us concerning one ad-hoc interface + multiple AP
> interfaces. to allow the TSF updates we would have to keep the HW opmode in
> ad-hoc though. would VAPs still work that way? also how about stations? aren't
> they supposed to adapt the TSF of their AP? as i see the HW is in AP mode if
> there is at least one AP, so that does not happen if there is an AP interface
> too. how would multiple STA sync their TSF if they are connected to different
> AP with different TSF? but maybe the TSF does not matter as much for STA as it
> does for IBSS mode... if that is the case we could allow one adhoc + multiple
> STA interfaces and drive the HW in adhoc mode.
>
> oh, another thing: ad-hoc interfaces could potentially move to another channel
> (if it is not set to a fixed channel). i quess in most cases a fixed channel
> will be used, but it wouldn't be good for the other STAs if that happens. but
> thinking about it - doesn't the same apply with multiple STA interfaces? how
> do you avoid one STA from changing to another channel?

For STAs, I use the can-scan-one logic so that after the first interface
associates, future automated scans will not scan more than the single channel.
That helps keep us on the same channel.

But, if all interfaces disassociate, then full scans will happen again,
and the first interface to associate gets to choose the channel.

If the channel is changed for any reason, all of the old stations are
un-associated and attempt full rescan to re-associate.

That scan-one logic is probably not going into the upstream kernel though,
so to keep confusion to a minimum, you would have to make sure that
your STAs are all configured for APs on the same channel.

In general, APs and STAs have worked well together for us..but we have
never used adhoc.  It sounds to me like you know a lot more about this
stuff than I do, so perhaps you can make more progress.

>
> so... many questions about the coexistence of adhoc and other interfaces... and
> honestly, i don't care much about adhoc + other vif at this time. as long as
> one adhoc interface works, i'm fine.
>
> btw: i think we should cleanup the beacon code, but i might do that after your
> vif changes got merged...

If we can get agreement on the patch as is (with your changes included), I'd
love to get it pushed upstream.  Then folks can improve it further.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

