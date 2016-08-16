Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35481 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbcHPUr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 16:47:26 -0400
Received: by mail-pa0-f65.google.com with SMTP id cf3so5748085pad.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 13:47:26 -0700 (PDT)
Message-ID: <1471380444.4943.17.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20160816_224730_309856_C6EDAA43)
Subject: Re: [Make-wifi-fast] On the ath9k performance regression with FQ
 and crypto
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Date: Tue, 16 Aug 2016 13:47:24 -0700
In-Reply-To: <87pop85tvr.fsf@toke.dk>
References: <87pop85tvr.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Do you have tcpdumps of

1) sample with crypto

2) sample without crypto.

Looks like some TCP Small queue interaction with skb->truesize, if GSO
is involved, or encapsulation adding overhead.


On Tue, 2016-08-16 at 22:41 +0200, Toke Høiland-Jørgensen wrote:
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
> 
> -Toke
> 
> [1] https://git.lede-project.org/?p=lede/nbd/staging.git;a=blob;f=package/kernel/mac80211/patches/220-fq_disable_hack.patch;h=7f420beea56335d5043de6fd71b5febae3e9bd79;hb=HEAD
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
