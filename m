Received: from smtpcmd11116.aruba.it (smtpcmd11116.aruba.it [62.149.156.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C892517BB4
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908352; cv=none; b=NMGvwuYcULO1sPoofgOGlwRQOa5OnCvcEhOMBBzIi8cyIxIeK+N1AnIw19T+pYwLa48W3YJHzzXrKeAxk2y+js8GtvybwxraXxri+JpQnpfQZ2qK64j/SHmsQ5ErI5kKlAjzd/i/ecFmB3lY77b6mAC6r1uNCLpAaYxCvVISixA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908352; c=relaxed/simple;
	bh=jap+D/pp38ekJP3nsOoVMSVDIL8hP9W+WsdH2xqIAOg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/+BJP2gJWu737+3Z/MK1Pv2onW35bGwN++boq0ZJAaVMV4SO/oH23xm7VWpMcOXmPYFtc4cm20Fp7HTVfJ+fasutaE+5U5PCNMRXIbpffPBW9rimzQRRWX1L+VwWkfeNBUfHXlSoLXm4VicOYeonNJEml/dnoTxVtRrETvb2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=BykiwJq0; arc=none smtp.client-ip=62.149.156.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="BykiwJq0"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id GfAXxHXfjXXg5GfAXxkrtk; Tue, 13 Oct 2026 18:16:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791908162; bh=jap+D/pp38ekJP3nsOoVMSVDIL8hP9W+WsdH2xqIAOg=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=BykiwJq04IddFwUeFlEyKubNfDXP40F68LWe5uE6u6I3Q/0lpLbEf5fZwz+5j1Kcl
	 7HYFKvoiO14Vb/xx+9G8o1wuhUvYg8xTtCs5ulbnok6BaJCWSnfQ8pNQLf4PaNCjx3
	 xkZjWbe2NYJ2hnsBCmq6xRcUdQVcQVVG9Ajk7ZWYYdCniIOW2d3JxuQKdOZS+dndQk
	 bhcPu7uqWEOi5kuLFe2B7pI4KLIY+OlNnkUOGj5o+4Q2BkFw0t2VS1faTrXRxpxWnI
	 GLP3SPu2g5sL8IQLoLrClZYvc7G9LqbUS6OtcjIEcLFqTR+6sp/ruFDemR0ZyL/48s
	 snKKwPcjwmRoA==
Date: Tue, 13 Oct 2026 18:16:00 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski	
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, =?UTF-8?B?UmFm?=
 =?UTF-8?B?YcWCIE1pxYJlY2tp?=	 <zajec5@gmail.com>, Philipp Zabel
 <p.zabel@pengutronix.de>, Florian Fainelli	
 <florian.fainelli@broadcom.com>, Broadcom internal kernel review list	
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer	
 <tsbogend@alpha.franken.de>, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 0/5] bcma: support the BCM6362 integrated WLAN
 backplane
Message-ID: <20261013181600.58ad8dc3@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <20261013145630.52fdec0d@DELL-MOBILE03.ad.smart.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
	<b7e21fad06d27f88b3c18060b4f4a69149de52eb.camel@sipsolutions.net>
	<20261013145630.52fdec0d@DELL-MOBILE03.ad.smart.it>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfMtQ8kvOdcxXwm64aSVcaWJVEkr5gRIiy7+XRWEzw/KVvMwL0Y3ynpnxIbR2oHIG6GTfmeO97eChlDGn+q59vf2K1qWbCgErT6IvYF8BF3My6nlAabfb
 qV4ZZxAegVPl6mZLrfWbjqnHpI2E+CW7L7d9ga+4lEHx+8xBG8NdPyul8VQL09vtajR3gaZg2s9xT/5Xyju7nNGA/d1SnfESZMLANkOsWW9nG1ppQ7yzpXQA
 QUMFKCau3UDIHMOlotMPpZ0ImldzXzA1ugtk57DtMHRxjPoGfBvvOtIm+4pDVKxmw1EW3spkckqhH9PxH+4+Hw54UvB6Ij6xaHgz1FsWk/b2NN/AyIdiQTal
 +peMkOuCeMHmiZLJQzs7JtyPq8InReS9geQPMlfeBKdO+WA5C88FoSt/95HcHWaOgJ3kVXbw+m1VzxwOcYDCdSk778QJe5DBa6ZmFQ5n8MR2DBsm6OsDmIVk
 ud6QAFcIgZCuVtm7pYOLmIifE0vzVQM5F7RXKhY5It1Dgmbdad0uNsQ4wvAwP4Ouxbh86RkmVKT9Iwg145hLZ5/AT+A92xO5aLy8mUeLRJvsol0i+1aVn+E4
 xkSDbPMa+DjeCz8DUQdyVdzxpXsbHI1ekemHR/2z7jYfG+pN+lMw/+NexEYLczWWl4czDs9L6q3zgKCnk2p0pwcx

On Tue, 13 Oct 2026 14:56:30 +0200
Alessio Ferri <alessio.ferri@mythread.it> wrote:

> On Tue, 13 Oct 2026 14:29:37 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > On Mon, 2026-10-12 at 00:45 +0200, Alessio Ferri wrote: =20
> > >=20
> > > My router is running daily with it, using openwrt kernel 6.12.   =20
> >=20
> > [...]
> >  =20
> > > This was drafted with the help of an LLM and cross built with gcc=20
> > > mips cross compiler and checked with the dev version of sparse.
> > > This time i also ran dt-check-style and it didn't flag anything.
> > >  =20
> >=20
> > So ... are you running it or not? I'm confused.
> >  =20
>=20
> I don't see your source of confusion: i am running it with kernel 6.12
> and it works, but last i checked the current kernel is not version
> 6.12... so i had to rebuild it for the current kernel and i did it
> with help from an LLM. And also i ran the checks for the dt part,
> OpenWRT build system couldn't care less that i didn't even register
> the bindings, but i know bindings maintainer care about it.
>=20
> > Either way, I have no idea what to do with it - I guess Rafa=C5=82 if y=
ou
> > want this picked up then let folks know? But the last patch should
> > probably go through some MIPS trees anyway, so the others might as
> > well go there too, I don't care (and don't really _want_ to be
> > responsible for this obscure corner just because some wifi drivers
> > use it).
> >=20
> > johannes =20
>=20
> The original code is Broadcom's. You can also ask Broadcom directly if
> this is correct/sane for them.

I must say that i was pretty vague in the last statement:
By "code" i really meant "C headers", and by "ask Broadcom directly" i
meant "ping the Broadcom devs already included in the cc if they do not
respond by themselves in a few days".

>=20
> Alessio

