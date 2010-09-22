Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46444 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0IVEdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 00:33:31 -0400
Message-ID: <4C99870C.20006@candelatech.com>
Date: Tue, 21 Sep 2010 21:33:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org> <1285097307.12764.11.camel@jlt3.sipsolutions.net> <4C990859.70709@openwrt.org> <4C99135A.3090103@candelatech.com> <4C99348F.2090504@openwrt.org>
In-Reply-To: <4C99348F.2090504@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 03:41 PM, Felix Fietkau wrote:
> On 2010-09-21 10:19 PM, Ben Greear wrote:
>> On 09/21/2010 12:32 PM, Felix Fietkau wrote:
>>> On 2010-09-21 9:28 PM, Johannes Berg wrote:
>>>> On Tue, 2010-09-21 at 20:00 +0200, Felix Fietkau wrote:
>>>>
>>>>>> Could we just poke a pointer to the STA into the ath_buf structure?
>>>>
>>>>> No, that doesn't work because of RCU.
>>>>
>>>> Well, it could work, if you walk all the structures upon sta_notify and
>>>> remove now stale pointers (or just drop the frames or something).
>>> I think it would be much better to just add the helper function that
>>> checks the RA on STA lookup. Keeps things simple, especially since
>>> nothing else in the tx path needs the vif.
>>
>> How about this.  Seems to do the trick on my system:
>>
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 85a7323..09815a1 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -328,8 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>>
>>           rcu_read_lock();
>>
>> -       /* XXX: use ieee80211_find_sta! */
>> -       sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
>> +       sta = tx_info->control.sta;
> As I mentioned in another email: at the time we get the tx status
> report, we have to consider the sta pointer stale. It may or may not
> still be valid.

How about this one.  I think it ensures that the sta will never be stale,
since it flushes the tx queue on vif removal.  Minimal testing shows it
working, but of course I might be missing something.

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b327bc..8485729 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1459,6 +1459,12 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,

         mutex_lock(&sc->mutex);

+       /* Make sure we have no outstanding packets that might reference
+        * the vif.  This way, we can always reference tx_info->control.sta
+        * in the tx_complete logic.
+        */
+       ath_drain_all_txq(sc, false);
+
         /* Stop ANI */
         sc->sc_flags &= ~SC_OP_ANI_RUN;
         del_timer_sync(&common->ani.timer);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 85a7323..09815a1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -328,8 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,

         rcu_read_lock();

-       /* XXX: use ieee80211_find_sta! */
-       sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
+       sta = tx_info->control.sta;
         if (!sta) {
                 rcu_read_unlock();


Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
