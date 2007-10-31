Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbXJaMTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 08:19:14 -0400
Subject: Re: ilog2 overkill in ieee80211_get_hdrlen?
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710311514.48896.bruno@thinktube.com> (sfid-20071031_061457_971015_857A735E)
References: <200710311514.48896.bruno@thinktube.com>
	 (sfid-20071031_061457_971015_857A735E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c7XfH5gMDkJ1fWNIr9Nm"
Date: Wed, 31 Oct 2007 13:20:35 +0100
Message-Id: <1193833235.12078.22.camel@johannes.berg> (sfid-20071031_121917_580478_F1F3A437)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c7XfH5gMDkJ1fWNIr9Nm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> in 'net/mac80211/util.c', in ieee80211_get_hdrlen (line 175), a function =
ilog2=20
> is used to determine the number of bits to shift for=20
> IEEE80211_STYPE_QOS_DATA. isn't that a bit of an overkill when we could j=
ust=20
> do >> 6? i mean IEEE80211_STYPE_QOS_DATA isn't going to change after all.=
..

Yeah but ilog2() evaluates to a constant here so it doesn't matter, and
I think this is more readable.

> if (fc & IEEE80211_STYPE_QOS_DATA)
> 	hdrlen +=3D 2;
>=20
> would be a bit more readable.

It used to be that but that's a branch and the generated code is better
the other way.

johannes

--=-c7XfH5gMDkJ1fWNIr9Nm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyhzEqVg1VMiehFYAQLOww//byaMIbf2KuBZcDiM2SLnJEpIioeyqzMF
JY3CD4m0jgHRrrJ5eqmopZnuG9cQ7eHgfiaWVjcXQ5TnCuCRL0KKBNWLD9U4E6QK
wyxJB5VWShUnBXjiQL6Uv89H+l1455QSXVtdoQgWJcHN1M1ZHyAsTM+7CLkgfZcT
4zbPLR68XWjUiphLx4GZdn0/4/7C8kjB8ITH2PXzriZCe2eF70gqOROi/est22Ao
ZrNopskKS0MWM1oPPOUYArzFwpfnWNlwdL8ZPHEoVrSX+EX3wTe2sQoPKpSQY4jX
0xfayiO7h0+o9Ksiti/9nH1/9I362DpmKCzSx/RMg9F16OkksZOmF80sCdJAdcuq
AsrMJGbTqMGB7cKuyCMvYDOv79sYUukeDegPoH3N+L1WpvnZ4oxnNdHD/qTykSms
Vz/cAzNEPRwDVRIxLSml63IznaJ1zdYf1mTXzDSRrHUPqzlk2jyNZnLMJoA2JKXy
6+qTDm8vNOx5Y+6yIBFTOgoG4a9IrfZ1se2eLB5gYe+egzOpPbSBh0/c8Hc1TmHp
3Shn4XBFCX/DyAUzRTgRsFQNnhNjrMH1d1r8GE7sTl4c3nPVkMOtTiJwwRM3NnGc
/HsIJZ9JuBdWL4ztWRv9cJi9vwiY78+SOcKCiBOCQqhNQI7tCkhUDnwBo+m8VZij
Jhh3OZwrbYc=
=STwz
-----END PGP SIGNATURE-----

--=-c7XfH5gMDkJ1fWNIr9Nm--

