Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeH2Dsq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 23:48:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 28 Aug 2018 16:54:43 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <87d0u24wsw.fsf@toke.dk>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
 <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org>
 <87a7pfaovy.fsf@toke.dk> <d8775275d843cc7aa65c5005fd4c42af@codeaurora.org>
 <87a7pe8xn5.fsf@toke.dk> <5a697a77c65745cdabb0e8a3ab0931ef@codeaurora.org>
 <87d0u24wsw.fsf@toke.dk>
Message-ID: <a0fa5a1bb754b56b6d076afa71d14c57@codeaurora.org> (sfid-20180829_015446_791687_14A7A4C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-28 03:20, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
> Ah, excellent; then it should be no problem to enforce the head node
> access; worst case the pull mechanism will be at a different point in
> the round-robin, which will sync up quickly.
> 
>> Will fix it and rename as ieee80211_txq_can_transmit().
> 
> Cool. If you send an updated patchset I can fold it into an updated
> version of my RFC and send it as a proper patch once I've verified
> everything works with ath9k :)
> 
Sure. Found an issue in txq pause change. The drivers assume that
ieee80211_tx_dequeue() returns NULL only when txq is empty. Adding a
IEEE80211_TXQ_PAUSE check in tx_dequeue() breaks this assumption. 
Moreover
once txq is paused, it should be queued to tail not at head.

Will send updated version ASAP.

-Rajkumar
