Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37871 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbcHQESN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 00:18:13 -0400
Subject: Re: On the ath9k performance regression with FQ and crypto
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
References: <87pop85tvr.fsf@toke.dk>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Dave Taht <dave.taht@gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <6d471495-fa0f-f750-a4a4-f467205b94bd@nbd.name> (sfid-20160817_062243_753990_2434DBA7)
Date: Wed, 17 Aug 2016 06:18:09 +0200
MIME-Version: 1.0
In-Reply-To: <87pop85tvr.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-16 22:41, Toke Høiland-Jørgensen wrote:
> So Dave and I have been spending the last couple of days trying to
> narrow down why there's a performance regression in some cases on ath9k
> with the softq-FQ patches. Felix first noticed this regression, and LEDE
> currently carries a patch [1] to disable the FQ portion of the softq
> patches to avoid it.
> 
> While we have been able to narrow it down a little bit, no solution has
> been forthcoming, so this is an attempt to describe the bug in the hope
> that someone else will have an idea about what could be causing it.
> 
> What we're seeing is the following (when the access point is running
> ath9k with the softq patches):
> 
> When running two or more flows to a station, their combined throughput
> will be roughly 20-30% lower than the throughput of a single flow to the
> same station. This happens:
> 
> - for both TCP and UDP traffic.
> - independent of the base rate (i.e. signal quality).
> - but only with crypto enabled (WPA2 CCMP in this case).
> 
> However, the regression completely disappears if either of the
> following is true:
> 
> - no crypto is enabled.
> - the FQ part of mac80211 is disabled (as in [1]).
> 
> We have been able to reproduce this behaviour on two different ath9k
> hardware chips and two different architectures.
> 
> The cause of the regression seems to be that the aggregates are smaller
> when there are two flows than when there is only one. Adding debug
> statements to the aggregate forming code indicates that this is because
> no more packets are available when the aggregates are built (i.e.
> ieee80211_tx_dequeue() returns NULL).
> 
> We have not been able to determine why the queues run empty when this
> combination of circumstances arise. Since we easily get upwards of 120
> Mbps of TCP throughput without crypto but with full FQ, it's clearly not
> the hashing overhead in itself that does it (and the hashing also
> happens with just one flow, so the overhead is still there). And the
> crypto itself should be offloaded to hardware (shouldn't it? we do see a
> marked drop in overall throughput from just enabling crypto), so how
> would the queueing (say, mixing of packets from different flows)
> influence that?
> 
> Does anyone have any ideas? We are stumped...
I have not done any further tests, but based on your analysis, I think I
finally understand what's causing this issue:
The CCMP PN (crypto IV) is assigned in the tx path before a packet is
put into the txq. It is also used to protect against replay attacks, so
it is sensitive to reordering. The receiver is simply dropping any
packet where the PN value is lower than the highest PN received so far.
To fix this, we will have to move the IV/PN assignment to
ieee80211_tx_dequeue.

- Felix
