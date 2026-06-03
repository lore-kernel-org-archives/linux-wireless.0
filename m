Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1305D3AC0FA;
	Wed,  3 Jun 2026 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780502771; cv=none; b=AQVouf7CJSDa4SeM9098eixqQBkOgpCFiJ8IscThzicQyqvswf7j8XPim/zLpPfivjEi4+8t8IYFe92wFmlePAQxHapTT4TDs39BpfWjoS/Cbul6Eyh8u7ZOHlOKXiidDAdu8kJjc76Yq/UYZA0j2Z1Lp0XBLGnPynZzODm+Ct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780502771; c=relaxed/simple;
	bh=o+VHwJshp/4g4QPqIYPVm1Z0Wc1eNwBIFQwc1W+uTm8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5bCOlhGMG+ob5H3W3aYkqTIx8ecgoFinO3huYX0sj11EvP1jDbqkPkYaNlwHxrv1ZaqikzzFxy8mLHBu0nSO9mgAOgV7np8oKhvhBpnbRedjOhmqvbpftfwItKLmszOc2Xz3WrOI62PV2hhn5opn+afX0ixaKcu9mo58+xYnCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=LdRqLtvB; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="LdRqLtvB"
Date: Wed, 3 Jun 2026 17:56:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1780502222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zrNSRM1Z4CEXimJhWlKdTHX8Qi2VKmaYmJepC+k/Uh8=;
	b=LdRqLtvBCwu7MaAyQ4Y+4digiuhV8Mss/XeLrk8/j4X0oDmXjjWYklrdknUGNwT1SBOrQY
	OvHj3EoQcEWDM758+GoVX/4seeTGR47vvR0ojtnyOY5xjlsQio+X0fIOqfTKnSIDOeE0w1
	ciyd/lMGXziERPaf/ZXjKsgrfkxh0SOQ+fKvRpavQjMJlt76HpQLLV6VeF1iq+letpA27m
	9vOaKpoA83WXqMN8gvsC6oXM/me0IVLuTODofhtEhghAuv6L7+b2MgjB/hXfrM3kXE2doX
	bNMu1OQOkW4DmDpI0smlN5IERvQ6fVHPLaDVac06EcWddv+DeYcTMj8+p4SIQQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jeeva Anandh <anandhjeeva215@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43legacy: remove redundant mask bit set
Message-ID: <20260603175622.3816e48d@barney>
In-Reply-To: <20260603125331.6310-1-anandhjeeva215@gmail.com>
References: <20260603125331.6310-1-anandhjeeva215@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DwH1_DYjyQLfw_tQzHJPZ2i";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/DwH1_DYjyQLfw_tQzHJPZ2i
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jun 2026 12:53:31 +0000
Jeeva Anandh <anandhjeeva215@gmail.com> wrote:

> mask is initialized to 0x0000001F, which already contains
> the 0x0010 bit. Therefore the conditional OR operation is
> redundant and can be removed.
>=20
> Signed-off-by: Jeeva Anandh <anandhjeeva215@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43legacy/main.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net=
/wireless/broadcom/b43legacy/main.c
> index 6b3e0b2bbca7..d32bffa6f009 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -1904,8 +1904,6 @@ static int b43legacy_gpio_init(struct b43legacy_wld=
ev *dev)
>  		mask |=3D 0x0200;
>  		set |=3D 0x0200;
>  	}
> -	if (dev->dev->id.revision >=3D 2)
> -		mask  |=3D 0x0010; /* FIXME: This is redundant. */
> =20
>  #ifdef CONFIG_SSB_DRIVER_PCICORE
>  	pcidev =3D bus->pcicore.dev;

No, please don't just remove these things.
There is a FIXME in the comment, because the author already noticed that th=
is
was strange and that there probably is an unknown reason for this.
Just removing this FIXME without clarifying the underlying reason
does not improve the code quality.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/DwH1_DYjyQLfw_tQzHJPZ2i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmogTqYACgkQ9TK+HZCN
iw4rIw/7BmJ/cX5IldAqIHP1+YokL2qpD0dZ5HPwnGDcMV0ftM0+akuzV2xtxQPW
jr31qZOMDOOlEJ0QivrsGKDpWI4iBKNYKygOfnztdHYCfjIesuz9Mx8zNroNog9A
3LlNyAmAk9xghW0dd0ehu71rGvshY3UATCZXxcyIhqNhsmODck5RWSfdYaUCI+s/
R/ns6t/A1cVgm6NqeSgWyEnUYtXXIiWrGL59O34pbxwIK6XsQ2n4p9XBqV5q56eu
bnISEdgaGSUUilfW1jHMIIvBA1OAr/ZMpp/MISWr04AnUQtpHKFQDUl+OoHpaBJj
J9rONGQdHV4LTJpOQyvS6ujIlEvdR8EtSxc3fKa9btjGMS1uoJJrqIAi9brrNfR7
myPzTjArQJFLVtplGLKdDwRvIYGIQ0HP8sD5+MRzL1Nnc1v6UQacmSwK+llMW8EM
O5Y/gk+S9lYRaVcjKtn5S0N82a4+gPWkVZ8oL0siGOJCCNMLQk2dW0xBS4BQiw2T
BUt6yzV+NTk9iqSyqkWGhY2ZNg/BvC/2M7Iyogy/f4W3/03JgoZH3tbKId93+1wB
eL2gyqfFezjuVuKMnUTS75ygkdEC9ea2octVN5OtTYcvKWlyJQORE/Uv2LJHKdpl
f3eSBLhlz2g0c96cXyw2HfWqOsYNnl8vEddu5x5VgBE2yr4DuG4=
=m2BT
-----END PGP SIGNATURE-----

--Sig_/DwH1_DYjyQLfw_tQzHJPZ2i--
