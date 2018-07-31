Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbeGaB4s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 21:56:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 30 Jul 2018 17:19:18 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87effkz6ft.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
 <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk>
 <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk>
 <25dc507c35c2dff356742626d026989d@codeaurora.org> <877elo48ea.fsf@toke.dk>
 <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org> <87k1pk3n7b.fsf@toke.dk>
 <aaa234780cad834c2ca0a36d7a007571@codeaurora.org> <87effkz6ft.fsf@toke.dk>
Message-ID: <e6d2908652d7915ed6b61eaeab3f8ece@codeaurora.org> (sfid-20180731_021923_154303_0081484C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-30 15:48, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
> Hmm, the driver really shouldn't need to do any locking apart from 
> using
> the next_txq() API. But I think you are right that the seqno mechanism
> doesn't play well with unserialised access to through next_txq() from
> multiple CPUs. I'll see what I can do about that, and also incorporate
> the other changes we've been discussing into a new RFC series.
> 
Great.. :)

>> Hmm.. reorder_txq() API may not needed. Calling next_txq() takes care
>> of reordering list though the driver is accessing txqs directly.
> 
> Right, as long as the next_txq() path is still called even while
> fetch_ind() is active, that should be fine.
> 
I am still wondering how and when to refill deficit in case next_txq()
won't be called. :(

Will post RFC change on top of yours.

-Rajkumar
