Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECC93A873D
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515257; cv=pass; b=bhrAbav4o8+qU74Hpt8PLTtMC6bOkc3AMq/9m5VpTHxqmNo7vgnDLI9uoMyABpAI1W6IT9RiY21SuPLv1J5ZJcyQPOCS03Q5z+7Fn9ObWY3AF5lO8VaEmR9gURV6mbBzqCEEvR1S4w7CohY7oT23FiCiOzsCsZaTHPAnwl5C78g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515257; c=relaxed/simple;
	bh=Yz1dJ9K1hx+/8eNBFtZlZR/sMtIEesjXSl7NFRFA0bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpIfzx26sRUYnAHw7rGhcidqOQMGmYzDZElt8URFELZgBdVt80L3BEvI3kEl5ABI+xEKzjBPuzvbA1pVNehNA17KevYQmoRndRcjehqm7RyCkZ93M0+4Hr6uyFj+HPrKfME/W4HbaaX9Vd8vRd7lO45GwuQ9EJyjxEyH1rXb7Us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=fYfusDc5; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="fYfusDc5"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66f96418909so296549d50.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 02:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788515255; cv=none;
        d=google.com; s=arc-20260327;
        b=UFmLhj7Dx8ECblvhrFh0Ex1Vjvf2B6nV+guJcHz0OU65ttboBEdwWnHl69zdhMuV4O
         MAiDjyV26tBFoe+mmifuISC4WikE9b5QybuLht0/YqsD3YEsA5yATPYxDqrXx4oEJqYg
         0qvk6G3IKJhAV9gKU020KnUSvnKidxESZ0SOFxxtRuzlhan97bwjG2e+Wql2ezu/ohEX
         +0SGSQCusZoVlDRDNnPNMONozUUnAatG9VZ2q/kiic0kiZUxqgxfz4Zwl7MfEHFb2N76
         +89gfT0PPrraMPHeEBtpQSDRGC91ASg6zzN8kd1T6mSda84ui5jxIP+dx+vO1ZuRy18p
         /ynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9xq3FYKzQXcz8qw68xSqv0Caz3RvbOs4tSynZuW52CY=;
        fh=i847w8/GjPHkxOu2eKCyAxBvYHGhotaJJtx/YY1Gn7E=;
        b=swUqn44IdrFInF/a/g9gN47Bev/ULl5iIQNjUcqnB3TyhDUZ61TZQUrkEV3lXSQzNJ
         ZhJzUayuz8/1+Ix8+duPoJJHDQMQ6kixpnxrRAoZsGp/MqCVDsxmhj8DJCbu4s7CDP7n
         bYOuppnw6wbpncSxjNelNHdJesXqKIB4nLDigKCVbgsV7xHI+T0WVaCgSztcjpE3PWsb
         DX+PfWIi9IuJx3V8qV4CZL7oMn3pGwTFn9xt/r3PXsT4pfab2SZsxmPLMr/w8vNFkbqK
         riyNSSHpnJyxjzpT5nDl/EiXsOWsSxXnWZ1CuSLIJEKM6k76Fvv6lzsDaWW4sI+OMl80
         wulw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788515255; x=1789120055; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9xq3FYKzQXcz8qw68xSqv0Caz3RvbOs4tSynZuW52CY=;
        b=fYfusDc5Y2HAdDnELTGobDJka0EQKPGjW4AlfykISRaNGTBume5bBte3GrN4wQmTe0
         ndk3c118mCMDIpI1ABpwCNUecYnZGtj4IdL10A2m/q62ydW2dSOH1yFZ+El4wh3cTDG/
         K0gVBk7o7e31wWw3Ow97aaNYnrAb5QgfypjyuNfjuHCZgBhDR7yAV0y48mWzPCTqidk2
         bn+fH/hedREvTdxc8sZBErLaBFklgFF1vseuY2+XOo3h+O4IblAtQnKpegXvFw2ivHaY
         CGJsDgVr6O3uEGN4sNs9R/H2KGzePejxtpuTK0HkdN9hbgnr34YPbFV/tNI0bhGtTv6I
         8Eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788515255; x=1789120055;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9xq3FYKzQXcz8qw68xSqv0Caz3RvbOs4tSynZuW52CY=;
        b=Qi7arAgtEaTckcWdsYCFrEl2U5NuxHYCe/3TCfiCB/lhw+RsPtH7oVxJV8nugm0+S4
         rWmzfcild+bvU9Xhw9fKMyuVWNcI7NSKcGMxlylwz3i9cNDWqrOj09xH5DX8+mqLCaSS
         Z2ns5jwZdNzvFVtSUccj32E18CfdG0+fjxfD+Ys5BnPPTya2ttS8TK9lts+yCfD43DQD
         3dTln/djuGgp7+pblHQ/zLW+1OJcbzW2ZiC8d+o9drSh18CsCPBD9yR7F8WqulWKMKe5
         UrX8Pb3Nq1hgdZHEGfqDPhSo8SfPhBTfO5DVZQLgVlUAjCT+UzIoKDTBnvT6hHfJg/yN
         Cklw==
X-Gm-Message-State: AFuF++muTPSIebEx55NPZ7reBLMY16MK8r0RiXiT8YTbK95bh9beJ557
	zseB484/bT7W8B1+RvsrjJOWvoIsCzhi3J31w2DiCeHXRxHZZxhUeZWRhpzynfaziG7DakrVha2
	ACw9+/1vFQmEuHrhOfcq0PKYg57pRdZhn5avikA35bBOekeO8q+v2+C7ccCM=
X-Gm-Gg: AYBFou3AY6uQE/2+vkmlecpzmXw8qqlkOidH8aAekarzZSGeSbTXJVwNuymSHHbs89Z
	mPNm96Ww3wchbNglkRSIEl6670szsRKvqc6QRbNEO6X4bEGxG6AUw6KmAytcThLqHh2EScDpD8o
	vnGrSBQk4EaH4LFHauWcwL7iQHRlcf5DcTRq8EaX4uDZo34yXg3bJvYQ9NEwFS+FJW+GL43mzzi
	96Aqpdgbjr0kAHYmu//L7AMkiH08eW7IAO+2b0zNXCFdt9yyD9WDFvdO60rgsmyd7UlQXmLJAUl
	HJyJzHKMHRmKZh81Hhz+VdI8NIpZmxn2AvJnVQjUlrglXeeRF3diaAtIMMIQCj1j+lmcyb/IT5H
	pKY11W/1k1k1LfyOLbXPpXJOyLVP1n5lct+b0/kLgHRfwHlbgU6JHftiMy3bHHbRo6FO+hM6y5H
	Uf3U/RoOLCgDI2G54MErskVADsgHOMc7f1wQZuv/t7+JWRFt5Ed0ljK5JajZretBtmoAgO8LlP+
	OnDk5pPSDmy2RApm0VGPtkrQzRbnt0F3MhEtQImEXi3J+SAE6Mka0+NQGZn2IjcprGNaDibylsb
	RhPdKhEgGdATeg==
X-Received: by 2002:a53:cd8b:0:b0:66c:85e3:7f28 with SMTP id
 956f58d0204a3-66fb5b0528cmr1396784d50.48.1788515254686; Fri, 04 Sep 2026
 02:47:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824142435.1757391-1-julius@bairaktaris.de> <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
In-Reply-To: <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Fri, 4 Sep 2026 09:46:57 +0000
X-Gm-Features: AcwNN1WfJPf374lPOcTETem2OemfXBOI9dK2JBvIx8YIXOX50VyF6LOcCbAcmbU
Message-ID: <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

> airtime weight is already used to select when the queues are serviced,
> so why should it be used for the queue depth?

While I used AI to help me write the change, my understanding of it is
that on ath11k the order does not matter. mac80211 fills each station's
queue in the chip until the AQL limit is reached. This results in both
stations always having a full queue, leaving it to the chip to decide
which one to send next. I noticed this because in my tests changing
weights did nothing.

With the change, a station with a higher weight is allowed a deeper
queue in the chip. The chip then simply has more of that station to
send, and in my tests a 4:1 weight gave roughly a 4:1 airtime split.

I don't think this can be fixed in ath11k, since the chip never asks
mac80211 for a specific station and just sends what it is given. So
the only thing we can control is how much is handed over.

Julius

Am Fr., 4. Sept. 2026 um 09:21 Uhr schrieb Johannes Berg
<johannes@sipsolutions.net>:

>
> On Mon, 2026-08-24 at 16:24 +0200, Julius Bairaktaris wrote:
> > The airtime queue limit is the same for every station, so on a driver
> > that pushes a whole scheduling selection into the hardware, every station
> > is allowed the same airtime in flight and the deficit round robin can
> > only decide the order in which they reach that ceiling, not how much of
> > the medium each one gets. Setting NL80211_ATTR_AIRTIME_WEIGHT then has
> > no effect on the airtime a station receives.
> >
> > Measured on an IPQ8074 access point with two stations on one radio, a 1x1
> > VHT80 client and a 2x2 HE160 client, both saturated from the access point
> > at once, BE aql_txq_limit at 500/1000 us, three interleaved runs per
> > weight with the association verified unchanged across every run. Without
> > this change the slow station takes 44.4, 43.9 and 44.0 per cent of the
> > medium at equal weights, 44.0, 43.5 and 44.4 at 1024:256, and 43.1, 43.4
> > and 42.8 at 256:1024. The weight moves the split by less than the spread
> > within one setting.
> >
> > Scale the per-station limit by the station's weight. A station weighted
> > above the default is allowed proportionally more airtime in flight and
> > therefore takes proportionally more of the medium. A network that never
> > sets a weight is unaffected, since every station keeps the default.
> >
> > The same pair then reads 42.1, 43.3 and 42.8 per cent at equal weights,
> > 78.0, 78.9 and 77.2 at 1024:256, and 19.6, 18.3 and 20.0 at 256:1024: a
> > 4:1 weight produces a 3.6:1 airtime ratio and 1:4 produces 4.2:1. It is
> > not free, and over the pair the aggregate is 557 Mbit/s at equal weights,
> > 925 when the faster station is favoured and 337 when the slower one is.
> >
> > The low limit is consulted without reference to the radio total, so the
> > scaled value is bounded by aql_threshold. Without that bound a weight of
> > 65535 grants one station 1.3 seconds of standing airtime on the default
> > low limit, which no total accounts for. The bound reaches the high limit
> > as well, where it changes nothing: that check already requires the radio
> > total to sit below the same threshold.
> >
> > The bound never reduces a limit below the value configured for it, so an
> > access point that raises aql_txq_limit above aql_threshold keeps what it
> > asked for at every weight, and scaling a weight up cannot scale a limit
> > down.
> >
> > That bound is also the ceiling on what a weight can express. At the
> > default low limit of 5000 us it takes effect near a weight of 1229, so
> > ratios beyond roughly five to one do not resolve: a weight of 65535
> > against 256 asks for 256 to 1 and delivers 4.9 to 1.
> >
> > This changes nothing where the limit does not bind. A station whose
> > pending airtime never approaches the limit is not held back by it at
> > either weight, mac80211 holds no backlog to arbitrate, and the share each
> > station gets is decided by the hardware's own scheduling.
>
> I can't really follow that. Do you understand the change?
>
> > +/* The airtime a station may keep in flight scales with its weight. The low
> > + * limit is consulted unconditionally, so the scaled value is bounded by the
> > + * radio-wide threshold rather than by the weight alone, and never below the
> > + * limit that was configured.
> > + */
> > +static u32 ieee80211_aql_sta_limit(struct ieee80211_local *local,
> > +                                struct sta_info *sta, u32 limit)
> > +{
> > +     u32 scaled;
> > +
> > +     if (sta->airtime_weight == IEEE80211_DEFAULT_AIRTIME_WEIGHT)
> > +             return limit;
> > +
> > +     scaled = mult_frac(limit, sta->airtime_weight,
>
> airtime weight is already used to select when the queues are serviced,
> so why should it be used for the queue depth?
>
> johannes
