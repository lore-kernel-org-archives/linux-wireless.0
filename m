Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbeIUPoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 11:44:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC] mac80211: budget outstanding airtime for transmission
References: <1537430613-16849-1-git-send-email-rmanohar@codeaurora.org>
        <875zz08tah.fsf@toke.dk>
        <3d06a48a76b2dc5905d8c5e76579b3cb@codeaurora.org>
Date: Fri, 21 Sep 2018 12:56:09 +0300
In-Reply-To: <3d06a48a76b2dc5905d8c5e76579b3cb@codeaurora.org> (Rajkumar
        Manoharan's message of "Thu, 20 Sep 2018 11:46:48 -0700")
Message-ID: <87zhwbqime.fsf@purkki.adurom.net> (sfid-20180921_115619_943676_730161A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

>>> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
>>> index b1b0fd6a2e21..ddc2c882c91c 100644
>>> --- a/net/mac80211/sta_info.h
>>> +++ b/net/mac80211/sta_info.h
>>> @@ -135,6 +135,7 @@ struct airtime_info {
>>>  	u64 rx_airtime;
>>>  	u64 tx_airtime;
>>>  	s64 deficit;
>>> +	s32 budget;
>>
>> Why signed? This should never become negative unless something is wrong
>> with the accounting somewhere?
>>
>> Related, are we sure there are no "leaks", i.e., packets that increase
>> the budget on dequeue, but are never tx_completed?
>
> Just to avoid wraparound issue. Yeah... Irrespective of signedness if
> there is mismatch in tx and tx-compl, it may stall tx. no? I was
> worrying what if the driver is freeing skb silently instead of
> free_txskb().
>
> Will change it to unsigned and add WARN_ON statement upon adjustment.
> is it OK?

Just note that WARN_ON() is pretty dangerous, especially on data path,
as it can kill the host with excessive spamming. WARN_ON_ONCE() or a
ratelimited printk() variant are much safer choises.

-- 
Kalle Valo
