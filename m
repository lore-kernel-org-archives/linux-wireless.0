Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44679 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0IVIcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 04:32:07 -0400
Message-ID: <4C99BEFC.2060209@openwrt.org>
Date: Wed, 22 Sep 2010 10:31:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org> <1285097307.12764.11.camel@jlt3.sipsolutions.net> <4C990859.70709@openwrt.org> <4C99135A.3090103@candelatech.com> <4C99348F.2090504@openwrt.org> <4C99870C.20006@candelatech.com>
In-Reply-To: <4C99870C.20006@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-22 6:33 AM, Ben Greear wrote:
> On 09/21/2010 03:41 PM, Felix Fietkau wrote:
>> On 2010-09-21 10:19 PM, Ben Greear wrote:
>>> On 09/21/2010 12:32 PM, Felix Fietkau wrote:
>>>> On 2010-09-21 9:28 PM, Johannes Berg wrote:
>>>>> On Tue, 2010-09-21 at 20:00 +0200, Felix Fietkau wrote:
>>>>>
>>>>>>> Could we just poke a pointer to the STA into the ath_buf structure?
>>>>>
>>>>>> No, that doesn't work because of RCU.
>>>>>
>>>>> Well, it could work, if you walk all the structures upon sta_notify and
>>>>> remove now stale pointers (or just drop the frames or something).
>>>> I think it would be much better to just add the helper function that
>>>> checks the RA on STA lookup. Keeps things simple, especially since
>>>> nothing else in the tx path needs the vif.
>>>
>>> How about this.  Seems to do the trick on my system:
>>>
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>> index 85a7323..09815a1 100644
>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>> @@ -328,8 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>>>
>>>           rcu_read_lock();
>>>
>>> -       /* XXX: use ieee80211_find_sta! */
>>> -       sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
>>> +       sta = tx_info->control.sta;
>> As I mentioned in another email: at the time we get the tx status
>> report, we have to consider the sta pointer stale. It may or may not
>> still be valid.
> 
> How about this one.  I think it ensures that the sta will never be stale,
No, it doesn't. At least not in AP mode.

> since it flushes the tx queue on vif removal.  Minimal testing shows it
> working, but of course I might be missing something.
In AP mode, a vif has multiple sta. And draining the queue when a sta
gets removed is not a good idea.

- Felix
