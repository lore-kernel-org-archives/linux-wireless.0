Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3785 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3CTVRO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:17:14 -0400
Message-ID: <514A274F.5030303@broadcom.com> (sfid-20130320_221718_169332_52605D2E)
Date: Wed, 20 Mar 2013 22:17:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "David Spinadel" <dvdspndl@gmail.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: rcutree tree warning during P2P device support testing
References: <5149CD81.40301@broadcom.com>
 <1363792139.8224.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363792139.8224.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2013 04:08 PM, Johannes Berg wrote:
> 
>> I am testing the P2P device support patches. Upon stopping the
>> wpa_supplicant I get the following warning and when I unload brcmfmac it
>> hangs resulting in hung_task_timeout message. The whole rcu stuff still
>> needs to settle in my brain. I suspect the warning is related to
>> brcmfmac unload failure, but maybe you have some ideas where I should look.
> 
> Hmm, why would stopping the supplicant cause brcmfmac to unload?? Or are
> you saying you first stop the supplicant, which gets you that warning,
> and then unload fails?

Indeed, upon stopping wpa_supplicant I get the warning. And doing a
rmmod from the command line after that fails in the hang.

>> [ 1634.039095] WARNING: at kernel/rcutree.c:1960
>> rcu_process_callbacks+0x469/0x560()
> 
>> [ 1634.133917] Call Trace:
>> [ 1634.139833]  [<c1039c92>] warn_slowpath_common+0x72/0xa0
>> [ 1634.148659]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
>> [ 1634.157914]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
>> [ 1634.167121]  [<c1039ce2>] warn_slowpath_null+0x22/0x30
>> [ 1634.175725]  [<c10c61f9>] rcu_process_callbacks+0x469/0x560
> 
> Can't say I understand this warning ...
>

At least we are on the same page then ;-)

>> [ 3606.381631] INFO: task khubd:30 blocked for more than 120 seconds.
>> [ 3606.388366] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 3606.396931] khubd           D f4f01cd8     0    30      2 0x00000000
>> [ 3606.403609]  f4f01d10 00000092 00000000 f4f01cd8 00000246 c1748000
>> c183fb40 c183fb40
>> [ 3606.411731]  d46b6273 0000031c f53e7b40 f4d323c0 c1748000 00000246
>> 00000000 f0820090
>> [ 3606.419807]  00000246 f4f01cd8 00000046 00000001 00000046 00000000
>> 00000002 f0820090
>> [ 3606.427881] Call Trace:
>> [ 3606.430518]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
>> [ 3606.435907]  [<c1525ff3>] schedule+0x23/0x60
>> [ 3606.440402]  [<f8230c65>] wiphy_unregister+0xa5/0x2e0 [cfg80211]
> 
> This seems to be because you don't remove the p2p device if it's still
> present when you unload the driver. Call cfg80211_unregister_wdev() at
> some appropriate place.

The p2p device is already removed upon stopping wpa_supplicant through
.del_virtual_intf() callback. Took a quick peek in
net/mac80211/iface.c:ieee80211_if_remove() and wonder whether I should
do cfg80211_unregister_wdev() in that code path as well. Guess so, right?

Gr. AvS


