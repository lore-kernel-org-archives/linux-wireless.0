Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39475 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933810AbcIERtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 13:49:46 -0400
Subject: Re: [PATCH v7] mac80211: Move reorder-sensitive TX handlers to after
 TXQ dequeue.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20160902134104.29309-1-toke@toke.dk>
 <20160905113042.22271-1-toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <8ffb5fee-78c1-79aa-2297-e125c59b092c@nbd.name> (sfid-20160905_194952_856972_F9A76276)
Date: Mon, 5 Sep 2016 19:49:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160905113042.22271-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-05 13:30, Toke Høiland-Jørgensen wrote:
> The TXQ intermediate queues can cause packet reordering when more than
> one flow is active to a single station. Since some of the wifi-specific
> packet handling (notably sequence number and encryption handling) is
> sensitive to re-ordering, things break if they are applied before the
> TXQ.
> 
> This splits up the TX handlers and fast_xmit logic into two parts: An
> early part and a late part. The former is applied before TXQ enqueue,
> and the latter after dequeue. The non-TXQ path just applies both parts
> at once.
> 
> Because fragments shouldn't be split up or reordered, the fragmentation
> handler is run after dequeue. Any fragments are then kept in the TXQ and
> on subsequent dequeues they take precedence over dequeueing from the FQ
> structure.
> 
> This approach avoids having to scatter special cases for when TXQ is
> enabled, at the cost of making the fast_xmit and TX handler code
> slightly more complex.
In my test, this one completely breaks ath9k with the txq patch.
One or two packets go through, then tx stalls completely.

- Felix
