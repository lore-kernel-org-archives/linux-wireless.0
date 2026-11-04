Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796277;
	b=q/qKOS2vsVSzo9PVDXiPNaXxVYvIP67+mzHPac7zISvBMEYX/FpXD7Vrr4k+HvQxf0tR
	 wO8kerHd1Ntf77zte7ZdxeusaTRul4GKlFT+C2aIsifZ4zubiiSuEVuOrRjH1Oo02d9M/
	 OdYNEnFccXxYbxU3JdxhstSuDsCQf6L0M486iw8BA2zqIbY3NKeqDcAeQEmq5xM0+Op3t
	 3c1L7s3oilrsTaCRBIQgnoSTZuUNJ/4PYU5MiIHnWZNIWC2HT8zpJL5bEOlIXekmDd/E6
	 vKUj9D8ZVlYOms9E/Pmlmnv7EGKneLfb71EZvKHLQohW1g09FHfs7ni//4kYo9GspAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796277;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-malware-bazaar;
	bh=lJyTUuKIREDvXONMfzq7iwHnID23XEZeYwhO39+eAVc=;
	b=Esfz0IMq1fYll+yblcywJPl0airmWKDAMwogDCBJzzVbZfeUD+HdhTrLEmZeSRavuqbA
	 E9zo8luEbvFBb1y6HDEcSm2iK7DkY/F8UfuNxZQA5lpfgF3e0iPmXmUhAkY8vP5IhtQlT
	 Yqj6sc/P0Snrp4VGDVTqM1bcFhGaQgjwyMBZnMp59IKYU70amhte1uughlXBPuUNcetht
	 QMGcfnO3ag4SbkEQaHDPdbvcpdkAkcVivwclmfHcP06qci8JgO6+N9Cvz8WuLvBiLjfqh
	 wqKKzBmGhIBrbXGOTJS7ro1vGSzzttUeRQQZ0CyPBYADc3uBU+qpoZILxSSyn7NAMVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GKb6KVaA;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98584606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 12:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GKb6KVaA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lJyTUuKIREDvXONMfzq7iwHnID23XEZeYwhO39+eAVc=;
	t=1793796276; x=1795005876; b=GKb6KVaAv6Raydb7rxQlBNM3793hc7sgjJ5nRQv4VEDfP8y
	lSJDcZCc9QCTD0gmuV1UNJvojAphYbAxDpO23eMpvgf5l1ow8kzqVtdQIaZrYPzR9fNP8AE4gIgBu
	X8w/Lhlj/xuIdePOA4Eid6FuW5KUhnRO5ERraFgevwA17mDUGgsv4cX7Z/6bZgiNIrtI0sIfAbsCY
	8ivNINFhApV5h862ytNYnIQkA0wa9ymJDmQb/JbzzEsx2bnMs9JSlWXrRaxr8XNH/AFs7KOcRIqFV
	GVPYxZ5zbjiKle0hU3NBU5A+dzZ8C1IlCklmiZg4BK5p6ikyDQzrgnjksy0it8eg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOaLr-00000005Xdc-17sy;
	Wed, 04 Nov 2026 13:44:27 +0100
Message-ID: <4abefad9689c00bb0343619687581ba7f33b5ded.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory
 before wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Date: Wed, 04 Nov 2026 13:44:26 +0100
In-Reply-To: <5abcac80-3eae-42e6-bf56-7b3e9a232577@oss.qualcomm.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
	 <20261022101836.148512-11-johannes@sipsolutions.net>
	 <d613e20e-16c3-4a39-b9a6-538a8740d2d6@oss.qualcomm.com>
	 <9efc1e507a2c7eaf6ab68ea0be0f5f02178ff4c7.camel@sipsolutions.net>
	 <5abcac80-3eae-42e6-bf56-7b3e9a232577@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-11-04 at 17:18 +0800, Baochen Qiang wrote:
>=20
> I ACKed on the ath11k change, not this ath12k one.

Oops, right, my bad.

> ath11k regdomain handling is slightly different from ath12k, because of w=
hat we won't hit
> the same issue there.

OK.

> > Despite the long commit message I don't really understand the commit yo=
u
> > point to, I guess I'm missing the FW side of things. Also not exactly
>=20
> Yes, there is a race between firmware processing the new hint and host re=
porting the
> regdomain during registration.

Hmm. But during registration now we just get the hint back from
cfg80211, at least after the last patch in this series?

> > sure what you mean by the userspace regdomain hint "during
> > registration", I thought this was self-managed?
>=20
> Yeah, ath11k/ath12k are both self-managed, but still open to userspace re=
gdomain
> configuration like 'iw reg set ...' if necessary CONFIGs are enabled.

Right, OK.

> > But I can also change the patch to do both, cfg80211 won't really care
> > about the second call after the registration, although it might send
> > another notification to userspace and cause quite a bit of work.
>=20
> Understand the concern. The regdomain code in ath driver is currently a b=
it mess, I am
> planning to clean it up someday.

I sort of just want to do the cfg80211 cleanup/fix, so I'm happy to do
whatever you think I should in ath12k - just keep both calls for now?

johannes
