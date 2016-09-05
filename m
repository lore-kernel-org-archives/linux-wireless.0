Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:57529 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932234AbcIER7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 13:59:12 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160902134104.29309-1-toke@toke.dk>
        <20160905113042.22271-1-toke@toke.dk>
        <8ffb5fee-78c1-79aa-2297-e125c59b092c@nbd.name>
Date: Mon, 05 Sep 2016 19:59:06 +0200
In-Reply-To: <8ffb5fee-78c1-79aa-2297-e125c59b092c@nbd.name> (Felix Fietkau's
        message of "Mon, 5 Sep 2016 19:49:42 +0200")
Message-ID: <87wpiq9qj9.fsf@toke.dk> (sfid-20160905_195916_075689_4A70D6C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2016-09-05 13:30, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The TXQ intermediate queues can cause packet reordering when more than
>> one flow is active to a single station. Since some of the wifi-specific
>> packet handling (notably sequence number and encryption handling) is
>> sensitive to re-ordering, things break if they are applied before the
>> TXQ.
>>=20
>> This splits up the TX handlers and fast_xmit logic into two parts: An
>> early part and a late part. The former is applied before TXQ enqueue,
>> and the latter after dequeue. The non-TXQ path just applies both parts
>> at once.
>>=20
>> Because fragments shouldn't be split up or reordered, the fragmentation
>> handler is run after dequeue. Any fragments are then kept in the TXQ and
>> on subsequent dequeues they take precedence over dequeueing from the FQ
>> structure.
>>=20
>> This approach avoids having to scatter special cases for when TXQ is
>> enabled, at the cost of making the fast_xmit and TX handler code
>> slightly more complex.
> In my test, this one completely breaks ath9k with the txq patch.
> One or two packets go through, then tx stalls completely.

I assume you are testing on LEDE? It requires a change to work with the
patch in the LEDE tree that puts hdrlen into ieee80211_tx_data. Did you
fix that? Otherwise multicast (and possibly other things) will break
badly.

I have a version that should work with LEDE here:

https://kau.toke.dk/git/lede/tree/package/kernel/mac80211/patches/346-mac80=
211-move-reorder-sensitive-tx-handlers-to-after-TXQ-dequeue.patch

-Toke
