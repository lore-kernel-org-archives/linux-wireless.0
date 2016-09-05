Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40477 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933773AbcIESpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 14:45:04 -0400
Subject: Re: [PATCH v7] mac80211: Move reorder-sensitive TX handlers to after
 TXQ dequeue.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20160902134104.29309-1-toke@toke.dk>
 <20160905113042.22271-1-toke@toke.dk>
 <8ffb5fee-78c1-79aa-2297-e125c59b092c@nbd.name> <87wpiq9qj9.fsf@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <41f0fbc5-c837-65b4-47c0-c875b774f8d5@nbd.name> (sfid-20160905_204726_829893_44B43659)
Date: Mon, 5 Sep 2016 20:44:59 +0200
MIME-Version: 1.0
In-Reply-To: <87wpiq9qj9.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-05 19:59, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2016-09-05 13:30, Toke Høiland-Jørgensen wrote:
>>> The TXQ intermediate queues can cause packet reordering when more than
>>> one flow is active to a single station. Since some of the wifi-specific
>>> packet handling (notably sequence number and encryption handling) is
>>> sensitive to re-ordering, things break if they are applied before the
>>> TXQ.
>>> 
>>> This splits up the TX handlers and fast_xmit logic into two parts: An
>>> early part and a late part. The former is applied before TXQ enqueue,
>>> and the latter after dequeue. The non-TXQ path just applies both parts
>>> at once.
>>> 
>>> Because fragments shouldn't be split up or reordered, the fragmentation
>>> handler is run after dequeue. Any fragments are then kept in the TXQ and
>>> on subsequent dequeues they take precedence over dequeueing from the FQ
>>> structure.
>>> 
>>> This approach avoids having to scatter special cases for when TXQ is
>>> enabled, at the cost of making the fast_xmit and TX handler code
>>> slightly more complex.
>> In my test, this one completely breaks ath9k with the txq patch.
>> One or two packets go through, then tx stalls completely.
> 
> I assume you are testing on LEDE? It requires a change to work with the
> patch in the LEDE tree that puts hdrlen into ieee80211_tx_data. Did you
> fix that? Otherwise multicast (and possibly other things) will break
> badly.
You're right, I missed that.

> I have a version that should work with LEDE here:
> 
> https://kau.toke.dk/git/lede/tree/package/kernel/mac80211/patches/346-mac80211-move-reorder-sensitive-tx-handlers-to-after-TXQ-dequeue.patch
That one works fine in my test.

Thanks,

- Felix
