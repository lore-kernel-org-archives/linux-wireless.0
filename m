Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50643 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753495AbcIFWEG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 18:04:06 -0400
Subject: Re: [PATCH v8] mac80211: Move reorder-sensitive TX handlers to after
 TXQ dequeue.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20160905113042.22271-1-toke@toke.dk>
 <20160906114426.25520-1-toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <9063eae7-53c7-a1c0-c973-9dc519cf66cd@nbd.name> (sfid-20160907_000410_924381_638ED8F8)
Date: Wed, 7 Sep 2016 00:04:02 +0200
MIME-Version: 1.0
In-Reply-To: <20160906114426.25520-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-06 13:44, Toke Høiland-Jørgensen wrote:
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
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Felix Fietkau <nbd@nbd.name>
