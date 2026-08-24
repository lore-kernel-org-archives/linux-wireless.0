Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB813AA1AE
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568818; cv=none; b=aM0Fa+bMQCImVVf9ytk9s3Ll3P3MLt6pe4EHzlEraM9N8smSA3zcPfBNbywj058OVZeUsg8RjgDLkSdH0vZ2evoVJGaDHPHUrJCIaMYl91H1joLUjjav/rClJ+HQKEKuJqGq+SClNkHefZktWbFZsPH8DTVjonIizW+6ntYJPyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568818; c=relaxed/simple;
	bh=YxYqyWhF8jVUPOayUCIRYu2TYnEdqmifixKbrw4KZ+g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q5f2J0ILcDmfx1f9pKBCNp+Qoxd7Zio1Lv5BhvwhTKPn2aKS9VKMWsefV8Yx769Dj1PoLwGKfp+uGT0NwVkn2W6KVH6NSL970/+5qNkWYITKQ3beDLEVeH8kGAICC8/d3+mVRrBv6lrrZUtAMS7VJ4W7AjQalg7G6uGq9d0Cseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Julius Bairaktaris <julius@bairaktaris.de>, Jeff Johnson
 <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v1 4/4] wifi: ath11k: report tx airtime and enable
 airtime fairness
In-Reply-To: <20260823195703.49198-5-julius@bairaktaris.de>
References: <20260823195703.49198-1-julius@bairaktaris.de>
 <20260823195703.49198-5-julius@bairaktaris.de>
Date: Mon, 24 Aug 2026 12:53:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87se43eqmq.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Julius Bairaktaris <julius@bairaktaris.de> writes:

> mac80211's airtime scheduler charges sta->airtime[ac].deficit from one
> place, ieee80211_sta_register_airtime(). Unlike AQL there is no estimator
> fallback, and ath11k never calls it, so the ATF feature bit cannot be
> advertised on its own: the deficit would only ever be
> replenished, every station would stay permanently in credit, and the DRR
> would be inert. The bit is not a no-op in that state either, because it
> also moves txq insertion to the head of the active list, which
> __ieee80211_schedule_txq() documents as safe only because the DRR moves a
> station back once its deficit goes negative.
>
> fes_duration_us arrives with every PPDU's stats and is already
> accumulated into arsta->tx_duration a few lines above. Register it, and
> set the feature bit in the same change so the two cannot be separated.
>
> Measured on an IPQ8074 AP with two stations on one radio, a 1x1 VHT
> client at 433 Mbit/s and a 2x2 HE client, both receiving at once. Before,
> 'iw station set <mac> airtime_weight' is refused with -EOPNOTSUPP and the
> per-station airtime file reads zero. After, the weight is accepted and
> read back, TX airtime accumulates, and the per-AC deficits move.
>
> The fairness this delivers is coarse. Weighting the fast station 4:1 moves
> the slow station's share of airtime from 59.5% to 52.1% and the fast
> station's throughput from 315 to 392 Mbit/s: the direction is correct, the
> magnitude is not the ratio requested.

How consistent is this change between runs? Seems a bit marginal if the
policy was supposed to give a 4:1 ratio between stations, so does this
work at all?

-Toke
