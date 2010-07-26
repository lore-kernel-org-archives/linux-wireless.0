Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58926 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0GZRoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 13:44:55 -0400
Message-ID: <4C4DC98E.6090002@openwrt.org>
Date: Mon, 26 Jul 2010 19:44:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: improve aggregation throughput by
 using	only first rate
References: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>
In-Reply-To: <AANLkTimWoSTAtb0m9V=0CNowhy=KtpiKj-O3vdmV8qxB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-26 7:10 PM, Björn Smedman wrote:
> Hi all,
> 
> I've been running a lot of iperf on AR913x /
> compat-wireless-2010-07-16 (w/ openwrt/trunk@22388).
> 
> I think there are some (in theory) simple improvements that can be
> done to the tx aggregation / rate control logic. A proof of concept of
> one such improvement is provided below. Basically, it's a hack that
> makes ath9k output aggregates with only the first rate in the rate
> series. The reasoning is that a failure is not a problem for
> aggregates because there is software retry. Retrying in hardware at a
> slower rate is counter productive. So, better to fail and do a
> software retry at possibly another rate. Also, since the aggregate
> size is often limited by the slowest rate in the MRR series (4 ms txop
> limit) having a slow rate in the series may affect performance even if
> it is never used by the hardware.
> 
> In my (not so scientific) tests max AP downstream throughput increases
> about 30-40% with the patch below (from 33.9 to 55.7 Mbit/s with HT20
> in noisy environment with 20 meters and a few walls between AP and
> client).
> 
> Of course, if all rates in the series are high then this patch has no effect.
I think it makes sense to rely less on on-chip MRR for fallback, but I
think to make this workable, we really should use the MRR table for
something, otherwise the rate control algorithm will take much longer to
adapt.
It's probably better to fix this properly after I'm done with my A-MPDU
rewrite, because then I can more easily push parts of the software
retransmission behaviour into minstrel_ht directly.

- Felix
