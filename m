Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeILFJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 01:09:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 11 Sep 2018 17:07:45 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <87h8ixli4s.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
 <153635897061.14170.17999956909203163571.stgit@alrua-x1>
 <1536567496.3224.36.camel@sipsolutions.net> <87h8ixli4s.fsf@toke.dk>
Message-ID: <e90d3540e3c92c6e894217982cd77ff1@codeaurora.org> (sfid-20180912_020749_422566_777C5CDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-10 04:13, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>>> -			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>>> -			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>>> -			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : 
>>> "");
>>> +			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>>> +			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>>> +			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" 
>>> : "");
>> 
>> consider BIT() instead as a cleanup? :)
>> 
>> (or maybe this is just a leftover from merging some other patches?)
> 
> Yeah, this is a merging artifact; Rajkumar's patch added another flag,
> that I removed again. Didn't notice that there was still a whitespace
> change in this patch...
> 
I added the flag based on our last discussion. The driver needs to check
txq status for each tx_dequeue(). One time txq check is not sufficient
as it allows the driver to dequeue all frames from txq.

drv_func() {
       while (ieee80211_airtime_may_transmit(txq) &&
               hw_has_space() &&
              (pkt = ieee80211_tx_dequeue(hw, txq)))
           push_to_hw(pkt);
}

>>> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>>> +				struct ieee80211_txq *txq)
>>> +{
>>> +	struct ieee80211_local *local = hw_to_local(hw);
>>> +	struct txq_info *txqi = to_txq_info(txq);
>>> +	bool may_tx = false;
>>> +
>>> +	spin_lock_bh(&local->active_txq_lock);
>>> +
>>> +	if (ieee80211_txq_check_deficit(local, txqi)) {
>>> +		may_tx = true;
>>> +		list_del_init(&txqi->schedule_order);
>> 

To handle above case, may_transmit should remove the node only
when it is in list.

if (list_empty(&txqi->schedule_order))
        list_del_init(&txqi->schedule_order);

So that it can be used to determine whether txq is running negative.

-Rajkumar
