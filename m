Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33573 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbcBGLcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 06:32:46 -0500
Received: by mail-lf0-f42.google.com with SMTP id m1so82070192lfg.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2016 03:32:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B72115.10709@openwrt.org>
References: <1454668864-31777-1-git-send-email-nbd@openwrt.org>
	<CANUX_P3xJBopdHcNjwJ2UcXLPZcNHJtE+mC2=3i8b4p=J8kjXQ@mail.gmail.com>
	<56B70978.3030900@openwrt.org>
	<CANUX_P0VWG78s8fs5Y58n-JwK+bamkLQV=M9aYroDGWrhrrR0g@mail.gmail.com>
	<CANUX_P0QkRhSpdxrd9jAobCX9E=TED55=YaTOJ6QwwuJQHfTqA@mail.gmail.com>
	<56B72115.10709@openwrt.org>
Date: Sun, 7 Feb 2016 13:32:45 +0200
Message-ID: <CANUX_P3kt90a2xiW=KtS7eA2movyne49OwG2XmJY6vrH7Oy12g@mail.gmail.com> (sfid-20160207_123250_907039_0FF15EF3)
Subject: Re: [RFC v2] mac80211: add A-MSDU tx support
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 7, 2016 at 12:48 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2016-02-07 11:22, Emmanuel Grumbach wrote:
>> On Sun, Feb 7, 2016 at 12:06 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> On Sun, Feb 7, 2016 at 11:08 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> On 2016-02-07 08:25, Emmanuel Grumbach wrote:
>>>>> On Fri, Feb 5, 2016 at 12:41 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>>> Requires software tx queueing support. frag_list support (for zero-copy)
>>>>>> is optional.
>>>>>>
>>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>>
>>>>> Looks nice!
>>>>> This would allow us to create aggregates of TCP Acks, the problem is
>>>>> that when you are mostly receiving data, the hardware queues are
>>>>> pretty much empty (nothing besides the TCP Acks which should go out
>>>>> quickly) so that packets don't pile up in the software queues and
>>>>> hence you don't have enough material to build an A-MSDU.
>>>>> I guess that for AP oriented devices, this is ideal solution since you
>>>>> can't rely on TSO (packets are not locally generated) and this allows
>>>>> to build an A-MSDU without adding more latency since you build an
>>>>> A-MSDU with packets that are already in the queue waiting instead of
>>>>> delaying transmission of the first packet.
>>>>> IIRC, the latter was the approach chose by the new Marvell driver
>>>>> posted a few weeks ago. This approach is better in my eyes.
>>>>> For iwlwifi which is much more station oriented (of GO which is
>>>>> basically an AP with locally generated traffic), I took the TSO
>>>>> approach. I guess we could try to change iwlwifi to use your tx
>>>>> queues, and check how that works. This would allow us to have A-MSDU
>>>>> on bridged traffic as well, although this use case is much less common
>>>>> for Intel devices.
>>>
>>>
>>>> Can the iwlwifi firmware maintain per-sta per-tid queues? Because that
>>>> way you would get the most benefits from using that tx queueing
>>>> infrastructure.
>>>
>>> Well... iwlwifi and athXk are very different. iwlwifi really has the
>>> concept of queues and not flat descriptors.
>>> Any Tx descriptor lives in the context of a Tx queue which is
>>> per-sta-per tid when A-MPDUs is enabled.
>>> We are now moving to a scheme in which we will have per-sta-per-tid
>>> queue regardless of the A-MPDU state which will make much sense to tie
>>> to the tx queueing infrastructure.
>>> Thing is that in that case I am afraid we will not have enough packets
>>> in the software tx queue to get A-MSDUs from your code. with TSO, it
>>> is easier :) Still worth trying to work with this instead of TSO and
>>> see how it goes. That won't happen anytime soon though.
>>>
>>>>
>>>>>> +
>>>>>> +static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
>>>>>> +                                     struct sta_info *sta,
>>>>>> +                                     struct ieee80211_fast_tx *fast_tx,
>>>>>> +                                     struct sk_buff *skb)
>>>>>> +{
>>>>>> +       struct ieee80211_local *local = sdata->local;
>>>>>> +       u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>>>>>> +       struct ieee80211_txq *txq = sta->sta.txq[tid];
>>>>>> +       struct txq_info *txqi;
>>>>>> +       struct sk_buff **frag_tail, *head;
>>>>>> +       int subframe_len = skb->len - ETH_ALEN;
>>>>>> +       int max_amsdu_len;
>>>>>> +       __be16 len;
>>>>>> +       void *data;
>>>>>> +       bool ret = false;
>>>>>> +       int n = 1;
>>>>>> +
>>>>>> +       if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
>>>>>> +               return false;
>>>>>> +
>>>>>> +       if (!txq)
>>>>>> +               return false;
>>>>>> +
>>>>>> +       txqi = to_txq_info(txq);
>>>>>> +       if (test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags))
>>>>>> +               return false;
>>>>>> +
>>>>>> +       /*
>>>>>> +        * A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
>>>>>> +        * sessions are started/stopped without txq flush, use the limit here
>>>>>> +        * to avoid having to de-aggregate later.
>>>>>> +        */
>>>>>> +       max_amsdu_len = min_t(int, sta->sta.max_amsdu_len, 4095);
>>>>>
>>>>> So you can't get 10K A-MSDUs? I don't see where you check that you
>>>>> have an A-MPDU session here. You seem to be applying the 4095 limit
>>>>> also for streams that are not an A-MPDU?
>>>>> I guess you could check if the sta is a VHT peer, in that case, no
>>>>> limit applies.
>>>> The explanation for the missing A-MPDU change is in that comment -
>>>> checking for an active A-MPDU session would make it unnecessarily complex.
>>>> Good point about checking for VHT capabilities to remove this limit, I
>>>> will add that.
>>
>> Yes - I read the comment, but it seemed very sub-optimal to limit all
>> the A-MSDUs to 4K. With TSO I can get up to 10K and it really helps
>> TPT.
> This was built with the assumption that most scenarios use A-MPDU anyway
> and thus don't need really large A-MSDUs.

Yes - so that's interesting. We can chose to have long A-MSDUs inside
a short (in terms of number of MPDUs) A-MPDU, of with shorter A-MSDU
and squeeze more of these into a single A-MDPU.
The first intuition says that we'd better have more MPDUs because of
the CRC check for each MPDU which doesn't exist in A-MSDU. OTOH, I
remember I could clearly see that I get a higher TPT with longer
A-MSDUs. Maybe I wasn't looking right at the size of the A-MPDU? I
guess I'd need to go back to the table with all the values we had, but
since we pretty much got what we wanted, I am not sure I will able to
find time for this :)

>
>> One more point. In VHT, there may be a limit on the numbers of
>> subframes in the A-MSDU. I don't see you handle that. Maybe I missed
>> it?
> I haven't looked at that much yet. Right now the driver can only specify
> a limit for the number of subframes.

I am talking about a limitation the peer can advertise. Check this out:
https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/cfg.c#n1134

I couldn't see the limit the driver can specify in your code. I may
very well have missed it.

>
>> And... in case the driver doesn't handle frag_list, you linearize the
>> skb which is pretty much the only thing you can do at this stage. But,
>> when you'll lift the 4095 bytes limit, you'll get 11K A-MSDU,
>> linarizing such a long packet is really putting the memory manager
>> under pressure.
> I added no-frag_list support primarily for debugging purposes, it's not
> supposed to perform well.

ok.

>
>> This is an order 4 allocation, for each A-MSDU. Note
>> that iwlwifi (and probably other drivers) can handle gather DMA in Tx,
>> but they have a limited number of frags they can handle. iwlwifi e.g.
>> can handle up to 20 frags, but 3 are taken for "paperwork". You'll
>> have 2 frags per subframe at least (assuming that each subframe's
>> payload is nicely contiguous and not on a page boundary). I think that
>> it may be worthwhile to ask the driver how many frags it is supposed
>> to handle. I can't promise iwlwifi will use it, but I guess it will be
>> useful for someone.
> You mean an extra frag limit in addition to the driver subframe limit,
> in case individual subframes are fragmented as well?
>

well.. Yes, you can't assume that you'll have one descriptor for one
MSDU payload  (unless the driver doesn't advertise SG to the
netstack).

> - Felix
