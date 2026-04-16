Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C368227B347;
	Thu, 16 Apr 2026 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776357388; cv=none; b=aoID+gibhWjRyt0Ovpumb+sXINAy36rP6YsFJHk/uXcjMBFP+gSFSL2QZX26tuTR6IZ6v4ypAhwkGb+qgGA6fmyOwfQxXrVpdNPE/XfJ5G8CzVgu4cMlsEj8BgtoSoZax7VAFNN+TI12cLl7PYvj84cCI54gFcK3q4ZR9IoBs7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776357388; c=relaxed/simple;
	bh=NwSe9ylGEtiuwc2Q7rAubMcDRuY43fTcr4wNmBAwdo8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enuyjpq4j28YAvvw5SHZ9XoQY/PAE4NaLIoK5T/sZGzjJxQz3sS70war9hNyBfd2Ji4smzgczV+q0l7ZC4aS0Xx68pWbZmKMeH8uSjzyQMHxJvUHU8DN15FfZJwRF7NEWCw9ToBjUNKp35vPov/JL/GjshUsTKM1yDDiq1rOdIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=CfJRUuzR; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="CfJRUuzR"
Date: Thu, 16 Apr 2026 18:31:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1776357379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ipNuGZ81J1vY7nz3iiCuJyXey/PAzkfHRI0oapcyXmQ=;
	b=CfJRUuzRl3qf+VbSFyZMbXfFYcA1dfyzwYhpyoqEliiaLssxRlucRSgLrKbQ9CtIoR/Nsf
	LO1HPGYRvDK4J9+ZAV6j6kRNflE1AD84zdsGIADWmXZRKCF757Aos1WVmL+0i3BA6ah2eu
	r5Q6VJQ4altkpjbFVbT5Et3vb6VK/b0nPFJO9unhmno/GTpfUYBtMLl1BACkku9RFLhe05
	+dytShRJh6n5mFBwSHTniV60PfIMqxxeO9apHYn6gtrNkdc2Fx4bnwZzVpk25qVgI1alQ2
	sq2EDf0mI6dx2k33SZTMBe3pJ2Ilw150dYK64NTX0JYGnzavkfyfq2DZ6zVScQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Tristan Madani <tristmd@gmail.com>, Johannes Berg
 <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
 b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] wifi: b43: fix infinite loop from invalid
 hardware DMA RX slot
Message-ID: <20260416183100.154ca989@barney>
In-Reply-To: <CAOiHx=nuUvf31J5khj4e4Kzv2wK4++TeZevXu3Z53qB66RagdQ@mail.gmail.com>
References: <20260415222425.1544638-1-tristmd@gmail.com>
	<20260415222425.1544638-2-tristmd@gmail.com>
	<CAOiHx=nuUvf31J5khj4e4Kzv2wK4++TeZevXu3Z53qB66RagdQ@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XcuoM4WBcXaryJQ/pBrWOW/";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/XcuoM4WBcXaryJQ/pBrWOW/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Apr 2026 08:34:00 +0200
Jonas Gorski <jonas.gorski@gmail.com> wrote:

> > diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wire=
less/broadcom/b43/dma.c
> > index XXXXXXX..XXXXXXX 100644
> > --- a/drivers/net/wireless/broadcom/b43/dma.c
> > +++ b/drivers/net/wireless/broadcom/b43/dma.c
> > @@ -1693,7 +1693,10 @@ void b43_dma_rx(struct b43_dmaring *ring)
> >         B43_WARN_ON(ring->tx);
> >         current_slot =3D ops->get_current_rxslot(ring);
> > -       B43_WARN_ON(!(current_slot >=3D 0 && current_slot < ring->nr_sl=
ots));
> > +       if (!(current_slot >=3D 0 && current_slot < ring->nr_slots)) {
> > +               B43_WARN_ON(1);
> > +               return;
> > +       } =20
>=20
> B43_WARN_ON() returns the condition's result, so you can shorten this to
>=20
> if (B43_WARN_ON(!(current_slot >=3D 0 && current_slot < ring->nr_slots)))
>         return;


Acked-by: Michael B=C3=BCsch <m@bues.ch>

Please also check the b43legacy driver. It may contain exactly the same cod=
e.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/XcuoM4WBcXaryJQ/pBrWOW/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmnhDsQACgkQ9TK+HZCN
iw6mJA//Xnlm9AkM3Gk9OrGU02FsfwgrjG7JgULGL0H13Cua7z1s0YhDERMyxjmm
J6ridsu0twsw3IYW0ptzi/drM8cGLWTFdx3BANQFFUOOt06hSVU3h4wfgOCU5r7S
QuZUo6d33KB68mwX09Iw2TYBei3XEnafX5JuIS9u7mqffAuYLs4nyL2ulmQYoCfR
I47dOBdzpjH4kKGsrcJL0NWzilVp4uy8K+y41DhI/EYxHBn9HQYGKHMgxXIzj47L
mAMMiMQ0eiHer9OXyn8QJmXx4vz85dwMl7BRaVTf39j41SF4sO8jU+2R04xZQmCO
KgcmWCbtiu8CPBK9QMhBD2YmH8ng5DZGSuuE2GKVxl9orGKN4ONKWhayeaP8J8Yp
PRQLWd64GdzguWEYFIlmUYM6jniat6KXdPXZnbPEp6m+XjTM4ARrceXklf69Cndd
npYLD0hNpb2ZrzP6URMkaQv3IdtEdu7z8KdI42GiYcSj1qv7Q/uGLIAoilyB62cx
JgPrP3bgQ1u8T21eUrlxFqOsgz6pLrsCl/Rac8hiuFFxL0mcjgL1BSBv5w1E5a0w
VGR+NxRNLAqdcTv8WfyVyonc9rFBBxf82WmTRpeasPcn4VxRpM1SpgBev8lbJDoI
f1LNiiLH5I3qr9JDqJElxaJk5Ivwd1M3igAvGVzrOzCEP6O0D74=
=VKY1
-----END PGP SIGNATURE-----

--Sig_/XcuoM4WBcXaryJQ/pBrWOW/--
