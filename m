Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026F8378824
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 09:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513673; cv=none; b=VeOPjk397AfmnQ+1vkr7OwdSv9aaS4VGyVMFmYTEGCs/UTfuxLCtpQP7vYmfwYEwhPzMpyFHsNytl7CcoaadduaCV34r9pGRUSi8qZ9la4LXkH5/sDQziAQ0xe+SXJ3m2iwfmwmRS0XknpuDHQ19RCNnVJ/3DaBMWAWHMxIbpCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513673; c=relaxed/simple;
	bh=OlIc/YNHe6G9UugKmzQtGq1+p2I2gWynmEN5IWb5D80=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y0DdF8q0RumZ54cFIkSBkerOuJ1fokecumZtX/GZcPK8UuCFtu+0E1izuxtsOgONWp0vnInCXfCdOzjp++NjbQ0CVd72XkkBdwweoDfIohjxZoeeX3XjS4Ql8BQcCAzUZ2yOpc+YKKrVUFyXrKsg01GuyzyqGY9dtzE1/RUr7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vZRGApIY; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vZRGApIY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nFQZLJUn+B+J3cdU/jdoXEh4trE1MswWWFMg5QEmsbM=;
	t=1788513672; x=1789723272; b=vZRGApIY1BOYslEfoC8+UyDvsbIjyyaqxugZr9lFx0011oD
	te2yG7eZYSNjOpGLx3Dje6HpoDxd4qD5f5LNJxSntJJhM6Hw8Vhi+1ICxumz3G6L4ZqliFoTPAd2i
	IIcVvdKOMpA1qYsoonJn56AC4sH4+aO+YLB8T9MkCCPwKCsQCpZzQlIAKKrm2IRcqSdrSROu4foik
	8B6QQi1AtT+VGBOxCfjNJL9XlEmHRELJAGgjSLZuuTDcJjXtIlzBitFWOUTOEemTvu//6j3n1rZhH
	jz7kvCCYqOw8QEh5ImdakkUqPj+Br/VzJS+ZavJS6XjwkmxGPSc3FuNIoQv1fSaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2Q6e-00000001IUQ-3PKs;
	Fri, 04 Sep 2026 11:21:09 +0200
Message-ID: <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
From: Johannes Berg <johannes@sipsolutions.net>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Date: Fri, 04 Sep 2026 11:21:08 +0200
In-Reply-To: <20260824142435.1757391-1-julius@bairaktaris.de> (sfid-20260824_162441_875856_9B295991)
References: <20260824142435.1757391-1-julius@bairaktaris.de>
	 (sfid-20260824_162441_875856_9B295991)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-08-24 at 16:24 +0200, Julius Bairaktaris wrote:
> The airtime queue limit is the same for every station, so on a driver
> that pushes a whole scheduling selection into the hardware, every station
> is allowed the same airtime in flight and the deficit round robin can
> only decide the order in which they reach that ceiling, not how much of
> the medium each one gets. Setting NL80211_ATTR_AIRTIME_WEIGHT then has
> no effect on the airtime a station receives.
>=20
> Measured on an IPQ8074 access point with two stations on one radio, a 1x1
> VHT80 client and a 2x2 HE160 client, both saturated from the access point
> at once, BE aql_txq_limit at 500/1000 us, three interleaved runs per
> weight with the association verified unchanged across every run. Without
> this change the slow station takes 44.4, 43.9 and 44.0 per cent of the
> medium at equal weights, 44.0, 43.5 and 44.4 at 1024:256, and 43.1, 43.4
> and 42.8 at 256:1024. The weight moves the split by less than the spread
> within one setting.
>=20
> Scale the per-station limit by the station's weight. A station weighted
> above the default is allowed proportionally more airtime in flight and
> therefore takes proportionally more of the medium. A network that never
> sets a weight is unaffected, since every station keeps the default.
>=20
> The same pair then reads 42.1, 43.3 and 42.8 per cent at equal weights,
> 78.0, 78.9 and 77.2 at 1024:256, and 19.6, 18.3 and 20.0 at 256:1024: a
> 4:1 weight produces a 3.6:1 airtime ratio and 1:4 produces 4.2:1. It is
> not free, and over the pair the aggregate is 557 Mbit/s at equal weights,
> 925 when the faster station is favoured and 337 when the slower one is.
>=20
> The low limit is consulted without reference to the radio total, so the
> scaled value is bounded by aql_threshold. Without that bound a weight of
> 65535 grants one station 1.3 seconds of standing airtime on the default
> low limit, which no total accounts for. The bound reaches the high limit
> as well, where it changes nothing: that check already requires the radio
> total to sit below the same threshold.
>=20
> The bound never reduces a limit below the value configured for it, so an
> access point that raises aql_txq_limit above aql_threshold keeps what it
> asked for at every weight, and scaling a weight up cannot scale a limit
> down.
>=20
> That bound is also the ceiling on what a weight can express. At the
> default low limit of 5000 us it takes effect near a weight of 1229, so
> ratios beyond roughly five to one do not resolve: a weight of 65535
> against 256 asks for 256 to 1 and delivers 4.9 to 1.
>=20
> This changes nothing where the limit does not bind. A station whose
> pending airtime never approaches the limit is not held back by it at
> either weight, mac80211 holds no backlog to arbitrate, and the share each
> station gets is decided by the hardware's own scheduling.

I can't really follow that. Do you understand the change?

> +/* The airtime a station may keep in flight scales with its weight. The =
low
> + * limit is consulted unconditionally, so the scaled value is bounded by=
 the
> + * radio-wide threshold rather than by the weight alone, and never below=
 the
> + * limit that was configured.
> + */
> +static u32 ieee80211_aql_sta_limit(struct ieee80211_local *local,
> +				   struct sta_info *sta, u32 limit)
> +{
> +	u32 scaled;
> +
> +	if (sta->airtime_weight =3D=3D IEEE80211_DEFAULT_AIRTIME_WEIGHT)
> +		return limit;
> +
> +	scaled =3D mult_frac(limit, sta->airtime_weight,

airtime weight is already used to select when the queues are serviced,
so why should it be used for the queue depth?

johannes
