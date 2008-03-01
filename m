Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761434AbYCAAJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 19:09:35 -0500
Subject: Re: FIF_ filter flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802292339.27174.linux@baker-net.org.uk>
References: <200802292339.27174.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dsgd4ahyiELZkSr5yKVG"
Date: Sat, 01 Mar 2008 01:09:21 +0100
Message-Id: <1204330161.3938.55.camel@johannes.berg> (sfid-20080301_001013_086035_B50CB6C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dsgd4ahyiELZkSr5yKVG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> For example rt2x00 devices only have one promiscuous mode that covers tra=
ffic=20
> in the same and other BSSes therefore if either of FIF_PROMISC_IN_BSS or=20
> FIF_OTHER_BSS are set then the driver will set both of them in the return=
ed=20
> flags value.
>=20
> It will also for some devices set the FIF_ALLMULTI flag if mc_count is no=
n=20
> zero.
>=20
> If this behaviour is considered desirable then I'll keep it working when=20
> making the change but if not I'll remove it.

Interesting. I don't think I have an opinion right now. I wanted to be
strict about clearing the flags so that you don't end up with a flag
that we never get traffic for, but I can't imagine any check where you'd
want to know "do I get traffic XY".

How do you keep track of that anyway? Say somebody enables
FIF_PROMISC_IN_BSS and you also set FIF_OTHER_BSS, then when
FIF_PROMISC_IN_BSS is disabled again FIF_OTHER_BSS should be disabled
too but how know that it wasn't set in the meantime? I think that says
that you shouldn't do that...

johannes

--=-dsgd4ahyiELZkSr5yKVG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8iesKVg1VMiehFYAQIkfhAAmbHQNerKm4iesSKkyJNxvhgRNHkptzfA
CSpw9VuTNw6t4yyQD2fCtJ7XzM9oGJipoJvkO2jqJrGc3EOsPgzxk3qHTZdZlPq2
6ZJ34u9Rm1QbDRQ0h/vAwdL+22st92x1Vcs2xsSr4huFUwFMKklxEWiO51m9ICU0
qXc7Wa0NQPPLOESGjujkBH8ZFoifmTYiNondz6qI0+Wobv7fvaoL5w6PAX3thuML
SGx5OH90gPSovoMF4epemsuz8weIAXrnjRtkyulGvkFdOiSD+YpGD3zbIN6WqXJn
NhpheXLqeNu4RUDU7k1xj/gHkwk5BRQD3c598/l9FOivI++scyypAM9XyEwxWQx6
V5XGaCbChEYiQYbqYm7Llizokv60rgLQR4xH/6IeoZkAXT7vsgocx0aKN+p0db/U
CPqhtqVeCT4Q7qV0VsNaR7BCz1hw4Dlwi1qV9kFVDVaFcUU50NUIbyhu+gSxep9Q
GVZdwR48ohjhYEVpX4cvOKHvgQPmdQTFAcjNw5xEaAZbemMvHLOTFdxovZmNNu9z
XNF59a3y6u8Qm2gYrGtMVyT3KyRglOIPvORq1H0J3Pw45bbNLcX4H3pvNhrXAiTr
sQhuXZii+6WiHv9MUuR54o6IEFNSpyZ1GLDIvr8+LR/Ibc3nniEeKXtw2XJEu+6j
JU2JfHAJvS8=
=OL1e
-----END PGP SIGNATURE-----

--=-dsgd4ahyiELZkSr5yKVG--

