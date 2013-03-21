Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4667 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3CUME7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 08:04:59 -0400
Message-ID: <514AF761.7070607@broadcom.com> (sfid-20130321_130503_262419_D30D870A)
Date: Thu, 21 Mar 2013 13:04:49 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"David Spinadel" <dvdspndl@gmail.com>
Subject: Re: rcutree tree warning during P2P device support testing
References: <5149CD81.40301@broadcom.com>
 <1363792139.8224.10.camel@jlt4.sipsolutions.net>
 <514A274F.5030303@broadcom.com>
 <1363814947.9284.10.camel@jlt4.sipsolutions.net>
 <514A2E47.7080108@broadcom.com>
In-Reply-To: <514A2E47.7080108@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2013 10:46 PM, Arend van Spriel wrote:
> On 03/20/2013 10:29 PM, Johannes Berg wrote:
>> On Wed, 2013-03-20 at 22:17 +0100, Arend van Spriel wrote:
>>>> Hmm, why would stopping the supplicant cause brcmfmac to unload?? Or are
>>>> you saying you first stop the supplicant, which gets you that warning,
>>>> and then unload fails?
>>>
>>> Indeed, upon stopping wpa_supplicant I get the warning. And doing a
>>> rmmod from the command line after that fails in the hang.
>>
>> Right, ok.
>>
>>>>> [ 1634.039095] WARNING: at kernel/rcutree.c:1960
>>>>> rcu_process_callbacks+0x469/0x560()
>>>>
>>>>> [ 1634.133917] Call Trace:
>>>>> [ 1634.139833]  [<c1039c92>] warn_slowpath_common+0x72/0xa0
>>>>> [ 1634.148659]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
>>>>> [ 1634.157914]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
>>>>> [ 1634.167121]  [<c1039ce2>] warn_slowpath_null+0x22/0x30
>>>>> [ 1634.175725]  [<c10c61f9>] rcu_process_callbacks+0x469/0x560
>>>>
>>>> Can't say I understand this warning ...
>>>>
>>>
>>> At least we are on the same page then ;-)
>>
>> It looks like some rcu head list corruption ... no idea really.
>>
> 
> I have now (I think). I did a kfree of the driver's vif structure, which
> is container of the wireless_dev and that is still on the rcu head list.
> 
>>> The p2p device is already removed upon stopping wpa_supplicant through
>>> .del_virtual_intf() callback. Took a quick peek in
>>> net/mac80211/iface.c:ieee80211_if_remove() and wonder whether I should
>>> do cfg80211_unregister_wdev() in that code path as well. Guess so, right?
>>
>> I think so, yes. Does the warning go away if you do? :)
> 
> Not tested yet.

That did the trick. Apparently, wpa_s/driver_nl80211 does not do a
stop_p2p_device. That is triggered by cfg80211_unregister_wdev(). Should
wpa_s do the stop_p2p_device before deleting it or is the current
behaviour fine.

Regards,
Arend


