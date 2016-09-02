Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:59245 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932299AbcIBOol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 10:44:41 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160901160312.31540-1-toke@toke.dk>
        <20160902134104.29309-1-toke@toke.dk>
Date: Fri, 02 Sep 2016 16:44:36 +0200
In-Reply-To: <20160902134104.29309-1-toke@toke.dk> ("Toke =?utf-8?Q?H?=
        =?utf-8?Q?=C3=B8iland-J=C3=B8rgensen=22's?=
        message of "Fri, 2 Sep 2016 15:41:04 +0200")
Message-ID: <8737li5pkb.fsf@toke.dk> (sfid-20160902_164454_773552_13066E10)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

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
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> ---
> Changes since v5:
> - Move the fragmentation handler to *after* TXQ dequeue. Fragments are
>   kept in the TXQ for subsequent dequeues. This change also means that
>   the changes to make some of the handlers fragmentation aware are no
>   longer necessary.
> - One of the TX stats updates in the fast path was done before the
>   enqueue step; move that to xmit_fast_finish().
> - Move the rate selection handler to after dequeue, so it's run closer
>   to the time where the packet is actually transmitted.

Found one other thing that needs fixing shortly after posting this, but
figure that I'm probably not done anyway, so will leave it for the next
round. :)

-Toke
