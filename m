Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848F3A6F11
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522415; cv=none; b=Qw9kz/LgqbACc9yhVwE2rOXPfLXh+xLQlCnue48bLuUB0carTE+rhRHaKrGcim+aQrXDU0GWRoYWtGI9wjyKGX7KKQzwopGsrsLWom/QlpEKeJzeDmxGsBQ7mt/ACIFbve+PjTSrpbhH7AFssPlqJO58v8MbG2sBkZkItKbnCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522415; c=relaxed/simple;
	bh=eyKocvX3UttCaC534y8Qs1Z86d6NrKhSHOJYy0COTX0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EWMu/cXpOH/GgdYFgXaAOqk3xf50aW307jYsIxjSDdy8wjYH3bRWCu0YKMRha7VGSjTAUv81Ny9dC+yaNY/ya//IDaqyL263na0zSMx6hfRbCKOaMxSDHntFkrxbNPU+1vbyiNU0DG37hEJbjTBf/00VZ027nzEyMMc8RTUS77M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Julius Bairaktaris <julius@bairaktaris.de>, Johannes Berg
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
In-Reply-To: <CAC1t37KSg4rHmWBWvF1OkGfjYjVuQ44oDu-F=s4-7RXpkZD7kg@mail.gmail.com>
References: <20260824142435.1757391-1-julius@bairaktaris.de>
 <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
 <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com>
 <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
 <CAC1t37LF9Y=s23DNXmg9WM6sV+ENg+hTNgRNiW5ZMEwqx9CZJg@mail.gmail.com>
 <b1fee6e45c4e2d215437f112c8819d74547ac11a.camel@sipsolutions.net>
 <CAC1t37KSg4rHmWBWvF1OkGfjYjVuQ44oDu-F=s4-7RXpkZD7kg@mail.gmail.com>
Date: Fri, 04 Sep 2026 13:46:49 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87tso5tf12.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Julius Bairaktaris <julius@bairaktaris.de> writes:

>> Now I'm confused - I was thinking it'd be wrong _only_ for ath9k etc.,
>> but you just corrected me and said that ieee80211_next_txq() is called
>> anyway, so then wouldn't it also be wrong on ath11k? Or not wrong on
>> all?
>
> Both run the DRR:
>
> ath11k drains the selected queue until AQL stops it
>
>     net/mac80211/util.c, wake_tx_push_queue():
>         while (1) {
>                 skb = ieee80211_tx_dequeue(&local->hw, queue);
>
> so every station has a full queue in the chip and the firmware picks
> the next one. The DRR order doesn't get exposed to the fw.
>
> ath9k hands over one aggregate per selection
>
>     drivers/net/wireless/ath/ath9k/xmit.c, ath_tx_sched_aggr():
>         if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
>                 return -EBUSY;
>
> so there the DRR order is the air order and the weight already works.

ath9k doesn't use AQL at all (as you say, it schedules transmissions
directly), so that's not really relevant to any discussion of AQL :)

So I think the reason the weight is not working is that there's no
pushback from the driver in the wake_tx_push_queue() callback. The DRR
mechanism for achieving fairness (or, in the case of weights,
unfairness) is basically:

1. Driver pushes data to the hardware until the hardware buffer fills up.
   Crucially, the assumption here is that there's a single shared buffer
   that we fill.

2. When some space in the hardware becomes available it pulls the next
   data, and DRR can influence the order of packets going into the
   (shared) hardware buffer, which is how it controls the division of
   airtime between stations.

Crucially, between 1. and 2. (i.e., from the buffer fills up until
there's space again), the driver does not pull any packets from the TXQs
until there's space again. In ath10k (for example) this is achieved by
the ath10k_mac_tx_can_push() check in its wake_tx_queue function.

However, the mac80211 implementation of wake_tx_queue() just calls
drv_tx() without any pushback, so every time a packet arrives, the push
function will re-run, iterating through the available TXQs and pushing
data into the driver. Looking at the ath11k specifically, it seems
that the driver will just keep pushing data into the hardware, only
stopping when it runs out of TX descriptors across all TX rings. At
which point I guess packets will just start getting dropped in drv_tx()?

Which means that for ath11k, stations will pretty much always have their
full AQL limit worth of packets enqueued in the firmware. And changing
that limit to take into account the weights does not seem like a totally
insane way of influencing the relative weight between stations in the
absence of other knobs. The main drawback is that this means that
giving a station a higher share of the airtime also translates into
worse latency for that station (as it'll have more data queued outside
the influence of fq_codel). It's not quite clear to me whether the
increased access to the medium will offset this.

An alternative to this approach would be to impose the global limit from
the mac80211 side by refusing to dequeue any packets into the hardware
while local->aql_total_pending_airtime is above a certain level. In
theory, at least, that should achieve the same thing by letting DRR do
its thing.

-Toke
