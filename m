Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab0IIXIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 19:08:39 -0400
To: Ben Greear <greearb@candelatech.com>
Subject: Re: RFC:  Allow multiple STA connected to same AP.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Sep 2010 01:08:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <4C896747.6090905@candelatech.com>
References: <4C8959BC.7040501@candelatech.com> <7fa0decef9a717c1562ee155bba78ce9@localhost> <4C896747.6090905@candelatech.com>
Message-ID: <9b3afa510682d20c031f85f20345abd7@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 09 Sep 2010 16:01:27 -0700, Ben Greear <greearb@candelatech.com>
wrote:
>>> +       /* If we have more than one virtual station, turn on
>> PROMISC_IN_BSS
>>> +        *  --Ben
>>> +        */
>>> +       list_for_each_entry_rcu(sdata,&local->interfaces, list) {
>>> +               if (!sdata->dev || !netif_running(sdata->dev))
>>> +                       continue;
>>> +
>>> +               if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>>> +                       avifs++;
>>> +                       if (avifs>  1)
>>> +                               break;
>>> +               }
>>> +       }
>>> +       if (avifs>  1)
>>> +               new_flags |= FIF_PROMISC_IN_BSS;
>>> +
>>
>> This seems weird. Why do you need to be *promisc* within a given
>> BSS if you are multiple stations? You already have two MAC addrs
>> that you need to accept, so that should be fine, i.e. you don't
>> need to be promisc in the BSS. If ath9k needs to, it should be in
>> the driver. So NAK on this change for sure.
> 
> This seems to let the driver receive pkts for the 'real' mac on
> wlan0 and also the arbitrary mac on the second STA interface.
> 
> If there is supposed to be some other way for the driver to
> figure out it's supposed to go promisc, please let me know and
> I'll try to debug it.

But you can do the exact same thing in the driver. I just think
it doesn't belong into mac80211, since mac80211 doesn't need you
to be promisc, it just needs you to receive frames for those *two*
addresses that you've added. And you already know about those,
since you were notified about the interfaces going up and down
and associating etc.

>>> @@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta)
>>> __acquires(RCU)
>>>
>>>           spin_lock_irqsave(&local->sta_lock, flags);
>>>           /* check if STA exists already */
>>> -       if (sta_info_get_bss(sdata, sta->sta.addr)) {
>>> +       if (sta_info_get(sdata, sta->sta.addr)) {
>>
>> I don't understand this change. These functions are the same
>> if sdata is in managed mode.
> 
> The _bss method returns anything in same bss or with same
> sdata.  The sta_info_get only returns if MAC and sdata match.
> 
> W/out this change, the second STA fails this check because it
> has same BSS as the first one.

I'll have to look at this, I may misremember the way this works
internally, but this change will certainly break some things
since it'd allow adding the same STA to multiple VLANs that sit
on top of the same BSS.

johannes
