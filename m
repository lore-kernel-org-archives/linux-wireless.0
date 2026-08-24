Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB3F3EEAC4
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 10:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568379; cv=none; b=fK2B9qtn948C627cGLP9eocxbq+YJQXd16MbRIlhM8a5O7H59jvKp6rFU5wLPC8rIGWkgQn/ywfUo8TQueI9+ASGPqwiwgWmuwhouXawdp+gZ2UWvqq9rqbY2uhpky5xDyAb6LxnDi3HoVkJDgrevfsusF4+Rurt0SRrrPzJ3oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568379; c=relaxed/simple;
	bh=SvsWS6j+dl/P6nzXApBy9aetSb9gdiDTKDgGSSlbxB4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XULNGVGRuIS2VC7Im+AAVgSc1O9ZuUJzYsjy4BZnI50CBR4SS24wahipyH87Dhur/4cdcd87IVAuIsZkQDLBaw2EUFNSXyyuVs8bNK1RnwNKKK6gRLwK9IC9/WqqUgdGWtMfA0vFQJWyX9ZlV/NuQqLW+LN0OFGNQLZcARCMjt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Julius Bairaktaris <julius@bairaktaris.de>, Jeff Johnson
 <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v1 2/4] wifi: ath11k: enable airtime queue limits
In-Reply-To: <20260823195703.49198-3-julius@bairaktaris.de>
References: <20260823195703.49198-1-julius@bairaktaris.de>
 <20260823195703.49198-3-julius@bairaktaris.de>
Date: Mon, 24 Aug 2026 12:46:12 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v78zeqyz.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Julius Bairaktaris <julius@bairaktaris.de> writes:

> ath11k does not advertise NL80211_EXT_FEATURE_AQL, and every user of AQL in
> mac80211 is gated on that bit: the airtime charge in
> ieee80211_tx_dequeue(), ieee80211_txq_airtime_check(),
> ieee80211_sta_update_pending_airtime(), and the per-station aql file in
> debugfs, which is not even created. AQL is not untuned on this driver, it
> is absent.
>
> That matters here more than it would elsewhere, because AQL is the only
> brake. ath11k uses ieee80211_handle_wake_tx_queue(), whose
> wake_tx_push_queue() drains a selected txq whole into the driver, and the
> check at the top of ieee80211_tx_dequeue() is what stops that drain.
> Without the feature bit nothing does, so mac80211 holds no backlog and
> every queued byte of a saturated download sits in the hardware TX rings,
> where there is no AQM and no flow separation.
>
> Measured on an IPQ8074 AP against one HE 160 MHz station at MCS 11, taken
> from that station's own aql file while it received 280 Mbit/s: its BE queue
> depth reaches 6356 us of the 12000 us default limit, and 2972 us when the
> limit is lowered to 500/1000 us. Without this patch the file does not exist
> and the limits are never consulted.

Did you test if this actually has any impact on latency under load for
the station in question?

> The rate the estimator needs is already there: ath11k keeps a per-station
> rate_info in arsta->last_txrate and passes it to ieee80211_tx_status_ext(),
> which stores it as tx_stats.last_rate_info, and that is what
> ieee80211_calc_expected_tx_airtime() reads. Where no rate is known yet the
> estimator returns zero, no airtime is charged, and AQL stays inert, so this
> cannot behave worse than the current code.
>
> The estimate is only as fresh as arsta->last_txrate, which is updated from
> the HTT PPDU stats when a descriptor is evicted from ar->ppdu_stats_info,
> so the rate behind it can lag a rate change by up to
> HTT_PPDU_DESC_MAX_DEPTH PPDUs.
>
> ieee80211_sta_update_pending_airtime() returns the airtime but does not
> reschedule the txq, and ath11k has no completion-side push, so a queue held
> back by AQL is re-poked only by the next enqueue or queue wake.

This sounds like it could leave to stuck queues? :/

-Toke
