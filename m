Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0HAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 03:00:38 -0400
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <20081026220030.GA20964@Chamillionaire.breakpoint.cc>
References: <4902DEBB.3050205@hotmail.com>
	 <1224926241.6695.1.camel@johannes.berg>
	 <20081025112526.GB12252@Chamillionaire.breakpoint.cc>
	 <1224936311.3410.0.camel@johannes.berg>
	 <20081026220030.GA20964@Chamillionaire.breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RTVrSFJiCpVum+MymDuW"
Date: Mon, 27 Oct 2008 08:00:34 +0100
Message-Id: <1225090834.3746.9.camel@johannes.berg> (sfid-20081027_080042_393693_BB42AD3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RTVrSFJiCpVum+MymDuW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-26 at 23:00 +0100, Sebastian Andrzej Siewior wrote:

> On my x86_64 box the address of the buffer pointer right after the add
> of ZD_PLCP_HEADER_SIZE is:
> [   28.462273] buffer: ffff88003e310005
>=20
> so it looks to me like it was perfectly aligned before the add. Is it
> possible that it is not a new bug and we need a get_unaligend helper
> here?

Possible, yeah, maybe before we only saw problems with the IP alignment
and somehow this shows up now. Not sure. Anyway, if that fixes it,
obviously we want such a patch :)

johannes

--=-RTVrSFJiCpVum+MymDuW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBWcPAAoJEKVg1VMiehFY+HkP/RIdEsQiEv+AAmXi87ITkV8z
jowzd7VlY41+Mjm/0tVC1P48XXjQCNJSIeF5htTxAe9HYebilmSsZfv8naw0qmJ9
ChHOX4lmfGODfx1qOXHTAhsXfndJKPoz4bYskPc3P8cO8ou226OeUi/1aVGuHU0I
QSSqsWRh2gmUwsGOcn/BojHfeipRY60H9i6tVME4ssRCEnbIfm6JephVa4J1oPmu
0Ie79w69L39SOn8pshw8ELsMU2mV+FbR5ol2RZfbzFMEQjNPBfPGDa9B3mvglbl0
pjZG6DKo9nuFIkNpfbwOhaC1zxE44Qb/M2lJkqN4x4efC2viv/vQEV40wk09Bess
dWfHMHGCURt+7Mp8pitvOy978lOtfXXnlPybivbbgXpwSs1EW5JIOnk7pOhXpubx
ZFtWNgQ2mfkvKHcfTLdUaQ2w1GK3PhXd+haKZPIRF1d8wOPiykzbCMA+ZVdr7AWe
nKJHS64BuCstG6AfKjmZPcn0WjHTX7bMrGkIH17dZf9SX4UYinX1iCNCcjytW3Yf
GqridvElTSrCf0Bq+/350vgl/zMlB6HgZmjhBM29QwlEmw9rs5Uv8U3lP+F2MIHw
exj4/7OV9jS+ptipiFKmmyEDFdniHe0oEAwAY+zkLJXJJSd9MKEc094P4+cjtF9P
SqqmtXuBh3hJYE75p44z
=mC1F
-----END PGP SIGNATURE-----

--=-RTVrSFJiCpVum+MymDuW--

