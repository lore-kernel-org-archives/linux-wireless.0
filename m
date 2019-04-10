Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F946C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F24DD2084B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QZUwB7HN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cXDNXjM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfDJGfn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:35:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfDJGfm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 02:35:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7E3B5602B7; Wed, 10 Apr 2019 06:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554878141;
        bh=WL7kv6dFag/MIxyLiV0PnZs5Yvt33txR23mRSh7wbQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QZUwB7HNbd6AgymdbTyFDphTtzVjpa/JO3PVdiSkPVrqVZswUz+sRlqS1T0GipeH7
         QQaga06ddtDMPoRuX/se42ctG+fgdZwrT4+KD+UHc9wUsJq0GrXAmV1GHeiKtfPEgd
         eoZ9o1fy2WvlG80OKbgHTJewyQKBE0nhBgFvznwg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id CA317602B7;
        Wed, 10 Apr 2019 06:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554878139;
        bh=WL7kv6dFag/MIxyLiV0PnZs5Yvt33txR23mRSh7wbQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cXDNXjM/Brn+PKTMjwx6QRezRlK1ftGrOC9D/ELu4aF8ZHIpGm6EJ8DD6dzBo6p5L
         /jNnmIad3FtkPIme56oakA8gqBCr0wzdKYOnU4p0GmRmG/4xdXTpv5JThPnSN/jyfn
         UEbbwE9LAcsvOTS5M8kENqhIRv6tY5MmtqQxAMP8=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 10 Apr 2019 14:35:39 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime
 scheduler
In-Reply-To: <877ec2ykrh.fsf@toke.dk>
References: <20190215170512.31512-1-toke@redhat.com>
 <753b328855b85f960ceaf974194a7506@codeaurora.org> <87ftqy41ea.fsf@toke.dk>
 <acd33756e87ea64c608e306e5ee60aa2@codeaurora.org> <877ec2ykrh.fsf@toke.dk>
Message-ID: <89d32174b282006c8d4e7614657171be@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-10 04:41, Toke Høiland-Jørgensen wrote:
> Yibo Zhao <yiboz@codeaurora.org> writes:
> 
>> On 2019-04-04 16:31, Toke Høiland-Jørgensen wrote:
>>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>> 
>>>> On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
>>>>> This switches the airtime scheduler in mac80211 to use a virtual
>>>>> time-based
>>>>> scheduler instead of the round-robin scheduler used before. This 
>>>>> has
>>>>> a
>>>>> couple of advantages:
>>>>> 
>>>>> - No need to sync up the round-robin scheduler in firmware/hardware
>>>>> with
>>>>>   the round-robin airtime scheduler.
>>>>> 
>>>>> - If several stations are eligible for transmission we can schedule
>>>>> both of
>>>>>   them; no need to hard-block the scheduling rotation until the 
>>>>> head
>>>>> of
>>>>> the
>>>>>   queue has used up its quantum.
>>>>> 
>>>>> - The check of whether a station is eligible for transmission 
>>>>> becomes
>>>>>   simpler (in ieee80211_txq_may_transmit()).
>>>>> 
>>>>> The drawback is that scheduling becomes slightly more expensive, as
>>>>> we
>>>>> need
>>>>> to maintain an rbtree of TXQs sorted by virtual time. This means 
>>>>> that
>>>>> ieee80211_register_airtime() becomes O(logN) in the number of
>>>>> currently
>>>>> scheduled TXQs. However, hopefully this number rarely grows too big
>>>>> (it's
>>>>> only TXQs currently backlogged, not all associated stations), so it
>>>>> shouldn't be too big of an issue.
>>>>> 
>>>>> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
>>>>> ieee80211_sta *pubsta, u8 tid,
>>>>>  {
>>>>>  	struct sta_info *sta = container_of(pubsta, struct sta_info, 
>>>>> sta);
>>>>>  	struct ieee80211_local *local = sta->sdata->local;
>>>>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>>>>>  	u8 ac = ieee80211_ac_from_tid(tid);
>>>>> -	u32 airtime = 0;
>>>>> +	u64 airtime = 0, weight_sum;
>>>>> +
>>>>> +	if (!txq)
>>>>> +		return;
>>>>> 
>>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_TX)
>>>>>  		airtime += tx_airtime;
>>>>>  	if (sta->local->airtime_flags & AIRTIME_USE_RX)
>>>>>  		airtime += rx_airtime;
>>>>> 
>>>>> +	/* Weights scale so the unit weight is 256 */
>>>>> +	airtime <<= 8;
>>>>> +
>>>>>  	spin_lock_bh(&local->active_txq_lock[ac]);
>>>>> +
>>>>>  	sta->airtime[ac].tx_airtime += tx_airtime;
>>>>>  	sta->airtime[ac].rx_airtime += rx_airtime;
>>>>> -	sta->airtime[ac].deficit -= airtime;
>>>>> +
>>>>> +	weight_sum = local->airtime_weight_sum[ac] ?: 
>>>>> sta->airtime_weight;
>>>>> +
>>>>> +	local->airtime_v_t[ac] += airtime / weight_sum;
>>>> Hi Toke,
>>>> 
>>>> Please ignore the previous two broken emails regarding this new
>>>> proposal
>>>> from me.
>>>> 
>>>> It looks like local->airtime_v_t acts like a Tx criteria. Only the
>>>> stations with less airtime than that are valid for Tx. That means
>>>> there
>>>> are situations, like 50 clients, that some of the stations can be 
>>>> used
>>>> to Tx when putting next_txq in the loop. Am I right?
>>> 
>>> I'm not sure what you mean here. Are you referring to the case where
>>> new
>>> stations appear with a very low (zero) airtime_v_t? That is handled
>>> when
>>> the station is enqueued.
>> Hi Toke,
>> 
>> Sorry for the confusion. I am not referring to the case that you
>> mentioned though it can be solved by your subtle design, max(local vt,
>> sta vt). :-)
>> 
>> Actually, my concern is situation about putting next_txq in the loop.
>> Let me explain a little more and see below.
>> 
>>> @@ -3640,126 +3638,191 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
>>>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8
>>> ac)
>>>  {
>>>  	struct ieee80211_local *local = hw_to_local(hw);
>>> +	struct rb_node *node = local->schedule_pos[ac];
>>>  	struct txq_info *txqi = NULL;
>>> +	bool first = false;
>>> 
>>>  	lockdep_assert_held(&local->active_txq_lock[ac]);
>>> 
>>> - begin:
>>> -	txqi = list_first_entry_or_null(&local->active_txqs[ac],
>>> -					struct txq_info,
>>> -					schedule_order);
>>> -	if (!txqi)
>>> +	if (!node) {
>>> +		node = rb_first_cached(&local->active_txqs[ac]);
>>> +		first = true;
>>> +	} else
>>> +		node = rb_next(node);
>> 
>> Consider below piece of code from ath10k_mac_schedule_txq:
>> 
>>          ieee80211_txq_schedule_start(hw, ac);
>>          while ((txq = ieee80211_next_txq(hw, ac))) {
>>                  while (ath10k_mac_tx_can_push(hw, txq)) {
>>                          ret = ath10k_mac_tx_push_txq(hw, txq);
>>                          if (ret < 0)
>>                                  break;
>>                  }
>>                  ieee80211_return_txq(hw, txq);
>>                  ath10k_htt_tx_txq_update(hw, txq);
>>                  if (ret == -EBUSY)
>>                          break;
>>          }
>>          ieee80211_txq_schedule_end(hw, ac);
>> 
>> If my understanding is right, local->schedule_pos is used to record 
>> the
>> last scheduled node and used for traversal rbtree for valid txq. There
>> is chance that an empty txq is feeded to return_txq and got removed 
>> from
>> rbtree. The empty txq will always be the rb_first node. Then in the
>> following next_txq, local->schedule_pos becomes meaningless since its
>> rb_next will return NULL and the loop break. Only rb_first get 
>> dequeued
>> during this loop.
>> 
>> 	if (!node || RB_EMPTY_NODE(node)) {
>> 		node = rb_first_cached(&local->active_txqs[ac]);
>> 		first = true;
>> 	} else
>> 		node = rb_next(node);
> 
> Ah, I see what you mean. Yes, that would indeed be a problem - nice
> catch! :)
> 
>> How about this? The nodes on the rbtree will be dequeued and removed
>> from rbtree one by one until HW is busy. Please note local vt and sta
>> vt will not be updated since txq lock is held during this time.
> 
> Insertion and removal from the rbtree are relatively expensive, so I'd
> rather not do that for every txq. I think a better way to solve this
> is to just defer the actual removal from the tree until
> ieee80211_txq_schedule_end()... Will fix that when I submit this again.

Do you mean we keep the empty txqs in the rbtree until loop finishes and 
remove them in ieee80211_txq_schedule_end(may be put return_txq in it)? 
If it is the case, I suppose a list is needed to store the empty txqs so 
as to dequeue them in ieee80211_txq_schedule_end.

And one more thing,

> +               if (sta->airtime[ac].v_t > local->airtime_v_t[ac]) {
> +                       if (first)
> +                               local->airtime_v_t[ac] = 
> sta->airtime[ac].v_t;
> +                       else
> +                               return NULL;

As local->airtime_v_t will not be updated during loop, we don't need to 
return NULL.

> 
> -Toke

-- 
Yibo
