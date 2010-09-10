Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46642 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0IJEwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 00:52:37 -0400
Message-ID: <4C89B98F.3090000@candelatech.com>
Date: Thu, 09 Sep 2010 21:52:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFC:  Allow multiple STA connected to same AP.
References: <4C8959BC.7040501@candelatech.com> <7fa0decef9a717c1562ee155bba78ce9@localhost> <4C896747.6090905@candelatech.com> <9b3afa510682d20c031f85f20345abd7@localhost>
In-Reply-To: <9b3afa510682d20c031f85f20345abd7@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2010 04:08 PM, Johannes Berg wrote:
>
> On Thu, 09 Sep 2010 16:01:27 -0700, Ben Greear<greearb@candelatech.com>
> wrote:
>>>> +       /* If we have more than one virtual station, turn on
>>> PROMISC_IN_BSS
>>>> +        *  --Ben
>>>> +        */
>>>> +       list_for_each_entry_rcu(sdata,&local->interfaces, list) {
>>>> +               if (!sdata->dev || !netif_running(sdata->dev))
>>>> +                       continue;
>>>> +
>>>> +               if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>>>> +                       avifs++;
>>>> +                       if (avifs>   1)
>>>> +                               break;
>>>> +               }
>>>> +       }
>>>> +       if (avifs>   1)
>>>> +               new_flags |= FIF_PROMISC_IN_BSS;
>>>> +
>>>
>>> This seems weird. Why do you need to be *promisc* within a given
>>> BSS if you are multiple stations? You already have two MAC addrs
>>> that you need to accept, so that should be fine, i.e. you don't
>>> need to be promisc in the BSS. If ath9k needs to, it should be in
>>> the driver. So NAK on this change for sure.
>>
>> This seems to let the driver receive pkts for the 'real' mac on
>> wlan0 and also the arbitrary mac on the second STA interface.
>>
>> If there is supposed to be some other way for the driver to
>> figure out it's supposed to go promisc, please let me know and
>> I'll try to debug it.
>
> But you can do the exact same thing in the driver. I just think
> it doesn't belong into mac80211, since mac80211 doesn't need you
> to be promisc, it just needs you to receive frames for those *two*
> addresses that you've added. And you already know about those,
> since you were notified about the interfaces going up and down
> and associating etc.

After some more debugging, it seems at least part of the problem is that
ath9k uses ieee80211_iterate_active_interfaces_atomic to determine which
MACs to add to the BSSID mask.  But, before things are associated properly,
sdata isn't 'running', so ath9k doesn't calc the mask properly.

Looks a bit like chicken-and-egg issue, and for some reason, it doesn't
seem to happen with WPA (but then, WPA doesn't authenticate properly either).

Maybe a new iterator is needed to get interfaces that want to go active
(maybe by determining if sdata->dev is 'UP') ?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
