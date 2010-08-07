Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35492 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0HGO26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 10:28:58 -0400
Message-ID: <4C5D6DA7.4050707@openwrt.org>
Date: Sat, 07 Aug 2010 16:28:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] minstrel_ht: fill out more than 3 rates
References: <201008070007.53294.chunkeey@googlemail.com>
In-Reply-To: <201008070007.53294.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-07 12:07 AM, Christian Lamparter wrote:
> Hello Felix,
> 
> I've stumbled into this conundrum a while ago...
> then as usual: forgot that it existed, until yesterday:
> 
> As you know minstrel (our non ht fallback) enables mrr-mode
> only if the driver sets hw->max_rates to 4 or more. 
> minstrel_ht - on the other hand - just prepares a set
> of 3 rates, so at least one additional retry with
> different tx-vectors remains unused...
> 
> How the last tries should be used is up for debate,
> I've opted out for lowest possible MCS.
> (although, some devices may also use a legacy
>  rate for the final tries...)
> 
> And the reason why I think it's worth to do an additional
> round: The reordering penalty for lost MPDUs on the receiver-
> side can be as high as 100ms, which is quite expensive compared
> to some extra airtime...
The problem here is that we have very different forms of retransmission
that receive the same kind of tx rate information, even though they
should be treated in a different way.

With drivers like ath9k, we don't need many retransmission steps. The
hardware-level retransmission stops as soon as it receives a Block Ack,
even if that may only ACK one of many frames (or maybe even none at
all). Software retransmission is then used to ensure that we don't
usually see lost MPDUs (under sane conditions, software-level excessive
retries should be pretty rare).

With this form of aggregation, the processing of the MRR chain is always
restarted for the next transmission attempt.
Since the table is for hw-level retransmission only, we do need to
ensure that we don't put unnecessarily low rates into the MRR array, as
this will limit aggregation size based on the 4-ms limit.

When using hardware aggregation, the behaviour kind of depends on how
the hardware interprets the retransmission information and how many
times it retransmits failed subframes of an A-MPDU transmission that
received a Block Ack.

I think in the long run we need to split this up. In my software
aggregation rewrite, I plan to add rate control lookups per A-MPDU, so
that the rate control algorithm can make a decision based on the number
of failed subframes (or the delta between first frame seqno and last
frame seqno, to better utilize the block ack window). In this case, the
rate control can be (and should be) much more optimistic about rates,
whereas with hardware aggregation we should probably put more emphasis
on reliability to reduce the latency.

- Felix
