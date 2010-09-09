Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42057 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab0IIXBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 19:01:34 -0400
Message-ID: <4C896747.6090905@candelatech.com>
Date: Thu, 09 Sep 2010 16:01:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFC:  Allow multiple STA connected to same AP.
References: <4C8959BC.7040501@candelatech.com> <7fa0decef9a717c1562ee155bba78ce9@localhost>
In-Reply-To: <7fa0decef9a717c1562ee155bba78ce9@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2010 03:51 PM, Johannes Berg wrote:
>
> On Thu, 09 Sep 2010 15:03:40 -0700, Ben Greear<greearb@candelatech.com>
> wrote:
>> With the patch below against latest wireless-testing, I can create two
>> STA on the same ath9k phy0 and have them send traffic to each other.
>> I tested only un-encrypted STAs at this point.
>
> After connecting them to the same AP, presumably?

Yes, though hopefully it would also work connecting to different
APs so long as the APs can communicate properly.

I've also been testing WPA..and that definitely doesn't work
yet.  Seems they fail to authenticate with the AP, though they
do talk and send EAPOL pkts back and forth.

>
>> It seems the tx logic hangs after a bit, so there are still issues, but
>> I'm not sure if that is something introduced by my patch or some
>> existing ath9k bug.
>>
>> Please let me know if this is a viable approach.
>
>> +       /* If we have more than one virtual station, turn on
> PROMISC_IN_BSS
>> +        *  --Ben
>> +        */
>> +       list_for_each_entry_rcu(sdata,&local->interfaces, list) {
>> +               if (!sdata->dev || !netif_running(sdata->dev))
>> +                       continue;
>> +
>> +               if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>> +                       avifs++;
>> +                       if (avifs>  1)
>> +                               break;
>> +               }
>> +       }
>> +       if (avifs>  1)
>> +               new_flags |= FIF_PROMISC_IN_BSS;
>> +
>
> This seems weird. Why do you need to be *promisc* within a given
> BSS if you are multiple stations? You already have two MAC addrs
> that you need to accept, so that should be fine, i.e. you don't
> need to be promisc in the BSS. If ath9k needs to, it should be in
> the driver. So NAK on this change for sure.

This seems to let the driver receive pkts for the 'real' mac on
wlan0 and also the arbitrary mac on the second STA interface.

If there is supposed to be some other way for the driver to
figure out it's supposed to go promisc, please let me know and
I'll try to debug it.

>> @@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta)
>> __acquires(RCU)
>>
>>           spin_lock_irqsave(&local->sta_lock, flags);
>>           /* check if STA exists already */
>> -       if (sta_info_get_bss(sdata, sta->sta.addr)) {
>> +       if (sta_info_get(sdata, sta->sta.addr)) {
>
> I don't understand this change. These functions are the same
> if sdata is in managed mode.

The _bss method returns anything in same bss or with same
sdata.  The sta_info_get only returns if MAC and sdata match.

W/out this change, the second STA fails this check because it
has same BSS as the first one.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

