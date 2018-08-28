Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41381 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbeH1OL3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 10:11:29 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <5a697a77c65745cdabb0e8a3ab0931ef@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org> <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org> <87a7pfaovy.fsf@toke.dk> <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org> <87a7pe8xn5.fsf@toke.dk> <5a697a77c65745cdabb0e8a3ab0931ef@codeaurora.org>
Date: Tue, 28 Aug 2018 12:20:31 +0200
Message-ID: <87d0u24wsw.fsf@toke.dk> (sfid-20180828_122036_964161_64D29F1F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

>>> As mentioned earlier, next_txq() can not be used for fetching txq
>>> directly. So reorder_txq() needs to take care of refilling txq after
>>> serving them.
>> 
>> Yeah, I got that; but see above. Unless there's a guarantee that the
>> push/pull mechanism will be round-robin scheduled (which as I'm reading
>> the code there isn't), just increasing the deficit on every call to
>> reorder_txq() is not going to ensure fairness (it'll probably help 
>> some,
>> but it won't be completely fair).
>> 
>> However, if we add the check to reorder_txq() so the deficit increase +
>> rotation is only done if the TXQ is at the head of the list, we'll get
>> round-robin-equivalent behaviour since a TXQ will only get to continue
>> when it happens to have rotated to the head of the queue. As I 
>> mentioned
>> previously it will break MIMO, but I we could fix that later once we've
>> verified that the basic mechanism works.
>> 
> Hmm... The pull mechanism operates in round-robin fashion. Agree that
> accessing only head node is right way of ensuring fairness.


Ah, excellent; then it should be no problem to enforce the head node
access; worst case the pull mechanism will be at a different point in
the round-robin, which will sync up quickly.

> Will fix it and rename as ieee80211_txq_can_transmit().

Cool. If you send an updated patchset I can fold it into an updated
version of my RFC and send it as a proper patch once I've verified
everything works with ath9k :)

> Thanks Toke for your feedback.

You're welcome! And thanks for working on this :)

-Toke
