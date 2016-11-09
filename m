Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11415 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754334AbcKIWm5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 17:42:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v6] ath9k: Switch to using mac80211 intermediate software queues.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161109113149.5724-1-toke@toke.dk>
References: <20161109113149.5724-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <make-wifi-fast@lists.bufferbloat.net>,
        <linux-wireless@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Message-ID: <689eea51fa77432cbe4c70c6c2fe7b13@euamsexm01a.eu.qualcomm.com> (sfid-20161109_234300_835703_9F1CD07F)
Date: Wed, 9 Nov 2016 23:42:47 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:
> This switches ath9k over to using the mac80211 intermediate software
> queueing mechanism for data packets. It removes the queueing inside the
> driver, except for the retry queue, and instead pulls from mac80211 when
> a packet is needed. The retry queue is used to store a packet that was
> pulled but can't be sent immediately.
> 
> The old code path in ath_tx_start that would queue packets has been
> removed completely, as has the qlen limit tunables (since there's no
> longer a queue in the driver to limit).
> 
> The mac80211 intermediate software queues offer significant latency
> reductions, and this patch allows ath9k to realise them. The exact gains
> from this varies with the test scenario, but in an access point scenario
> we have seen latency reductions ranging from 1/3 to as much as an order
> of magnitude. We also achieve slightly better aggregation.
> 
> Median latency (ping) figures with this patch applied at the access point,
> with two high-rate stations and one low-rate station (HT20 5Ghz), running
> a Flent rtt_fair_var_up test with one TCP flow and one ping flow going to
> each station:
> 
>                                  Fast station        Slow station
> Default pfifo_fast qdisc:            430.4 ms            638.7 ms
> fq_codel qdisc on iface:              35.5 ms            211.8 ms
> This patch set:                       22.4 ms             38.2 ms
> 
> Median aggregation sizes over the same test:
> 
> Default pfifo_fast qdisc:            9.5 pkts            1.9 pkts
> fq_codel qdisc on iface:            11.2 pkts            1.9 pkts
> This patch set:                     13.9 pkts            1.9 pkts
> 
> This patch is based on Tim's original patch set, but reworked quite
> thoroughly.
> 
> Cc: Tim Shepard <shep@alum.mit.edu>
> Cc: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

Perfect, just what I was hoping to see :) Unless something really
surprising comes up I should apply this within the next few days.

-- 
https://patchwork.kernel.org/patch/9419029/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
