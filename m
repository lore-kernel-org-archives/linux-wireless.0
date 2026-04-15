Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E7978F3A
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776269240; cv=none; b=JCdXuUu5NT+i+Jd7eyuMVKi5U/cncG/vhIpa192nJw/RfrkFKjtF7YyfIHyETRBg5rmbWvFPKRHsd+fGdojN2CS/oN7CYIEdTZQMwr5PCl0PrQZ/W/44WK1R/B1pVdwX5d2QkukY4FadXSV2ot6DXJVLmZrWd+gTklxc+kDkDZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776269240; c=relaxed/simple;
	bh=J/J/rHcH80SrKxja8htcH+s0y97ceMSk5zZnzhnKpkI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Seexd7y0VUfC7OANp8jsFv4eLkj9kTHIg803U8uCCj3PO486Dt4xBAjpLBDi+yfQ6+IOhFboAGDBWeh+vBjGENf+VSGPzmE1XVBKc6l6+w4L5dF/xrUl03pTKtwwR9KoK3iQIuL7DDsdR2F9ItoBdID+JgjCSNQIXsldQbiaKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=BN5wFWY3; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="BN5wFWY3"
Date: Wed, 15 Apr 2026 17:57:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1776268691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J/J/rHcH80SrKxja8htcH+s0y97ceMSk5zZnzhnKpkI=;
	b=BN5wFWY3B9u47kWoWHKih/s7VQ1i5WIU8pZ6Qpup8hBLQx6+nq7T8QqdRDu8mlVBPYhTOP
	gyb7RwMuvYPlE4Vt4ue745CpKycVYC8lq4n2O8IHH2xPqi73w6Fx7YNfAxL+uRwbNcFXVe
	pTQfaG1fYNVcFq3qsPYDamF4S//GBLmxrYpWfr6/05kuXL6pX4egpwSfXpyBiq2P2dNJKb
	rWs8DhCXx6qy7WXcBW/leVRuyhpBJGYdbeiON39Og+88BHBpns+iHfKxBbMCWm101NNJSS
	1W7BFuoFhP2ABQtFaZAIEyBYpwLhq+mOoMxpOqrXbJ4EyX6RPv9AMYr8xFQuQg==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Joshua Peisach <jpeisach@ubuntu.com>, Johannes Berg
 <johannes@sipsolutions.net>, b43-dev@lists.infradead.org,
 linux-wireless@vger.kernel.org
Subject: Re: Firmware for reverse engineering b43?
Message-ID: <20260415175748.61aa7993@barney>
In-Reply-To: <CAOiHx=n8awRRvArvG8sWqEokojXL6ppFRJ8_SOuGAddDb1D32A@mail.gmail.com>
References: <DHS1BJ5XFYRC.GCF9PXS0OSRI@ubuntu.com>
 <c62a448843f189d78187de18d3fcb955f2779d13.camel@sipsolutions.net>
 <DHSUDVMGW0PS.2LYWKGG1C1135@ubuntu.com>
 <CAOiHx==kVm0OKWRKi4VHSEEr6ZygzrpNiA=zj+zEHT6_rgZ3CQ@mail.gmail.com>
 <DHTPAVC76140.1JLO3HNQARQ9Q@ubuntu.com>
 <CAOiHx=n8awRRvArvG8sWqEokojXL6ppFRJ8_SOuGAddDb1D32A@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lPMAN2dntsU+fJbqlNm7P6y";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/lPMAN2dntsU+fJbqlNm7P6y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Apr 2026 13:54:31 +0200
Jonas Gorski <jonas.gorski@gmail.com> wrote:

> On Wed, Apr 15, 2026 at 1:44=E2=80=AFPM Joshua Peisach <jpeisach@ubuntu.c=
om> wrote:
> > It does appear to be similar - even the current brcm80211. So much so
> > that I sometimes need to think about whether b43 is actually a
> > duplicated driver.
> >
> > Since b43 is in an orphan state, I thought it would be a great place to
> > start for kernel development. 5G doesn't work on that iMac, some of the
> > PHYs, like the AC PHYs appear to be incomplete - it felt reasonable.
> >
> > Because I'm one of those "there's always room for improvement people",
> > I was going to try to improve the driver, filling out TODOs, fixing
> > hardcoded register numbers, etc. But if it's best left alone.. then I
> > guess we can do that.
> >
> > That is, assuming b43 is actually supposed to be a separate driver,
> > because if brcmsmac basically has the same code, then maybe we should
> > focus to centralizing everything? But then there's b43legacy.. hm... =20
>=20
> It is/was intentionally a separate driver: Broadcom didn't want to
> maintain support for obsolete chips (anything SSB, anything older than
> BCM43224), so the decision was to have b43 support all the "legacy"
> chips, while brcm80211 supports everything never. Since they were both
> based on the same driver, they are (more or less) the same
> architecture.
>=20
> But now that Broadcom has essentially abandoned the softmac part of
> brcm80211 since several years, I don't think there would be many
> objections on unifying it with b43.

The hardest part in the b43 development always was not to break already
working stuff. There are many different types and revisions of the hardware
out there. Probably in the order of many dozens of variants.

Please keep in mind that changing code means mostly testing.
Which is hard, if you don't have the hardware variants and basically no
users exist anymore. Just implementing random TODOs and missing pieces
will break things. (e.g. not doing some HW calibration or workaround might
be better than only partially doing it or doing it wrong).

I would personally not touch this thing anymore, except for security fixes =
and such.

But if you want to work on the code, long term, I would welcome that.
We could even arrange that I ship you some hardware.
But keep in mind, it's all almost 20 years old legacy stuff.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/lPMAN2dntsU+fJbqlNm7P6y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmnftXwACgkQ9TK+HZCN
iw74gRAAtog6Qh+8376tiB6lfcrpQCa5Y8kjAKSUuHYWJdoK5d9tDZz2G10FuBCx
IjjGrYd2FRHyhA9RFHe4XpLdcAwNUhUs2Z6cuaYhE0VkasowyfNEhsBEWfOeW/a+
llN4zzD1m/A2tPkylqderJt1Fere/y7glhyNDGeCz761ljQKIRwXed6MYfsbHoc7
GF/FDLizkWcdoPlIgInPeqwzA8kHe541lm5sUaQVNKJshLItFY9OGGAYKvm6zO1i
geSxjctnDcRo9XUYANplQBZ9eB7su7GqNmdVacbNOeiie61bWsMpXapuqDSK95aV
nR2ZvCUysPMUVbZrQW9+p+sknongYrk0kY557zdrTzxaWwRzZeCTbqLZLm3FygPt
JwO1mA4vUYa6mNLbuFo0A0YwmnosX43VXW1FBhNB8uWFUF1QUQbo1jKj5N/KFh5v
jXkfyp4OTSMfde5629q3Q5BSrGydMsp2vqtWq2Ql2yIdWnmayF3ZNbDZt1WgsTRn
dLmJLwuP2pc+o/0tL3VjcNsriqMNmShSX96poPckJhK+ikL7V83pXHRgIYN/XgjD
OUkjT0mZe6qh3hylszcW6028ekH+/NyaYLPtzr0GLVstLmChTxQm9st0bnmkMw7T
cIjVFemphPEq4tpu1Ww3RMwe54uGkKgUygL5Ok9uVk5idxGkN64=
=kr47
-----END PGP SIGNATURE-----

--Sig_/lPMAN2dntsU+fJbqlNm7P6y--
