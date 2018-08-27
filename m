Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60158 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbeH0WVy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 18:21:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 27 Aug 2018 11:34:09 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <87a7pe8xn5.fsf@toke.dk>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
 <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org>
 <87a7pfaovy.fsf@toke.dk> <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org>
 <87a7pe8xn5.fsf@toke.dk>
Message-ID: <5a697a77c65745cdabb0e8a3ab0931ef@codeaurora.org> (sfid-20180827_203414_349932_BF447DBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-22 04:10, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-08-21 05:24, Toke Høiland-Jørgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> 
[...]

> Yeah, but the fairness comes from all TXQs being given the *same 
> amount*
> of deficit increase. I.e., with reorder_txq() there needs to be a
> guarantee that it is called the same number of times for all active
> TXQs. Which is what the round-robin scheduling ensures in next_txq().
> 
Understood.

>> As mentioned earlier, next_txq() can not be used for fetching txq
>> directly. So reorder_txq() needs to take care of refilling txq after
>> serving them.
> 
> Yeah, I got that; but see above. Unless there's a guarantee that the
> push/pull mechanism will be round-robin scheduled (which as I'm reading
> the code there isn't), just increasing the deficit on every call to
> reorder_txq() is not going to ensure fairness (it'll probably help 
> some,
> but it won't be completely fair).
> 
> However, if we add the check to reorder_txq() so the deficit increase +
> rotation is only done if the TXQ is at the head of the list, we'll get
> round-robin-equivalent behaviour since a TXQ will only get to continue
> when it happens to have rotated to the head of the queue. As I 
> mentioned
> previously it will break MIMO, but I we could fix that later once we've
> verified that the basic mechanism works.
> 
Hmm... The pull mechanism operates in round-robin fashion. Agree that
accessing only head node is right way of ensuring fairness. Will fix it
and rename as ieee80211_txq_can_transmit().

Thanks Toke for your feedback.

-Rajkumar
