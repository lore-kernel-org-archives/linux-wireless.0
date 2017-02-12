Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41142 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbdBLPy3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2017 10:54:29 -0500
Subject: Re: [PATCH] ath9k: clean up and fix ath_tx_count_airtime
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20170212132931.43510-1-nbd@nbd.name>
 <87lgtb5t9h.fsf@alrua-karlstad>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <fbda67b4-7db6-984a-af50-610ec25d2fe0@nbd.name> (sfid-20170212_165432_358548_6EB60500)
Date: Sun, 12 Feb 2017 16:54:17 +0100
MIME-Version: 1.0
In-Reply-To: <87lgtb5t9h.fsf@alrua-karlstad>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-12 16:22, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> ath_tx_count_airtime is doing a lot of unnecessary work:
>>
>> - Redundant station lookup
>> - Redundant rcu_read_lock/unlock
>> - Useless memcpy of bf->rates
>> - Useless NULL check of bf->bf_mpdu
>> - Redundant lookup of the skb tid
>>
>> Additionally, it tries to look up the mac80211 queue index from the txq,
>> which fails if the frame was delivered via the power save queue.
>>
>> This patch fixes all of these issues by passing down the right set of
>> pointers instead of doing extra work
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling between stations")
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> Not sure if there's anything for stable to do with this; don't think the
> airtime fairness code has gone into a release yet? Otherwise:
> 
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
I added this, because I'm not sure this patch will make it to 4.10 in
time, since we're really close to a release. I assume this patch will
probably go into 4.11.

- Felix
