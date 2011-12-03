Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49442 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1LCRFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 12:05:07 -0500
Message-ID: <4EDA56B5.7020504@candelatech.com> (sfid-20111203_180518_904387_E828BF19)
Date: Sat, 03 Dec 2011 09:04:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com> <1321644720-8245-2-git-send-email-greearb@candelatech.com> <201112031736.03787.chunkeey@googlemail.com>
In-Reply-To: <201112031736.03787.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2011 08:36 AM, Christian Lamparter wrote:
> On Friday 18 November 2011 20:32:00 greearb@candelatech.com wrote:

Thanks for the bug report.  I'll try to get a fix for this later
today.

Thanks,
Ben


> WARNING: at net/mac80211/ht.c:50 ieee80211_apply_htcap_overrides+0x28/0xeb [mac80211]()
>
> Pid: 2912, comm: hostapd Not tainted #4
>
> Call Trace:
>
> [<ffffffff8102f957>] ? warn_slowpath_common+0x78/0x8c
>
> [<ffffffffa0305671>] ? ieee80211_apply_htcap_overrides+0x28/0xeb [mac80211]
>
> [<ffffffffa031188c>] ? sta_apply_parameters+0x1c7/0x24d [mac80211]
>
> [<ffffffffa0312bcb>] ? ieee80211_add_station+0xf5/0x14c [mac80211]
>
> [<ffffffffa005532e>] ? nl80211_new_station+0x201/0x227 [cfg80211]
>
> [<ffffffffa0052d0b>] ? nl80211_pre_doit+0x8f/0x10b [cfg80211]
>
> [<ffffffff813ab02f>] ? genl_rcv_msg+0x1c2/0x1fa
>
> [...]
>
> ---[ end trace 222d1b5c0c3ca878 ]---
>
>
> I think the WARN_ON_ONCE has to go to a different place. it triggers in AP mode.
>
> [And no, I didn't do any overrides at all, it's just that ieee80211_add_station
>
> calls sta_apply_parameters which in turn calls ieee80211_apply_htcap_overrides
>
> and so on]
>
>
> Regards,
>
> Chr
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
