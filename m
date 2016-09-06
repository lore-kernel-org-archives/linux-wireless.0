Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51763 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933172AbcIFLpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 07:45:30 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160905113042.22271-1-toke@toke.dk>
        <20160906114311.24522-1-toke@toke.dk>
Date: Tue, 06 Sep 2016 13:45:27 +0200
In-Reply-To: <20160906114311.24522-1-toke@toke.dk> ("Toke =?utf-8?Q?H?=
        =?utf-8?Q?=C3=B8iland-J=C3=B8rgensen=22's?=
        message of "Tue, 6 Sep 2016 13:43:11 +0200")
Message-ID: <87k2ep45go.fsf@toke.dk> (sfid-20160906_134533_539136_17A497B8)
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

Sorry for sending this again; meant to send v8. :/

-Toke
