Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbZJNNnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 09:43:13 -0400
Subject: Re: cfg80211 question: impedance mismatch of .connect versus .assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910141136.03288.hs4233@mail.mn-solutions.de>
References: <200910141136.03288.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tvH/v6FAyDpopk8292kq"
Date: Wed, 14 Oct 2009 22:41:58 +0900
Message-Id: <1255527718.4095.292.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tvH/v6FAyDpopk8292kq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-14 at 11:36 +0200, Holger Schurig wrote:
> While playing with .auth/.deauth/.assoc/.disassoc=20
> versus .connect/.disconnect in libertas, I notices two things=20
> that makes things a bit hard for me.

> This makes the "iw connect" command only work if an "iw scan" did=20
> just take place and I provide an BSS on the command line.=20
>=20
> So maybe net/wireless/sme.c should be generalized ?
>=20
>=20
>=20
> BSSID for .deauth/.disassoc vs. .disconnect
> -------------------------------------------
> Both the .deauth and .disassoc get the cfg80211_bss entry to=20
> deauth / disassociate against.
>=20
> .disconnect doesn't get this.

This was intentional, as with ->connect() the driver is supposed to
handle roaming/pre-connect scanning etc. Basically it's mostly for the
case of full-mac drivers that do that in the device firmware.

What you perceive as a "mismatch" is fully intentional, due to the
separation of where roaming is handled.

johannes

--=-tvH/v6FAyDpopk8292kq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK1dUjAAoJEODzc/N7+Qmaab4QAJlb/K6Vt7fyJ3696xRj3tgv
ovKIcm4CglqCF+Pi8IT9rL98Mz8DFg1XheM4pEoUqaWZrMq8N4h9REz7KfIevILN
jcBEwcgxR/fZPQvbVisfheXqN//IG1X7B7TLOFHMjKcY8YM0jpu+h28Kmu4cGtr5
2hdcom+Uxm7yPhnLmCubcPnsKZqGSnAr8sNIldZyX//ucL1gdOXATkK3LOXdmeCc
KZM65g7lfVCYt7VbuZjTZ7xc00hUqFV6Mzookh3afA5dAPNbYZRFcLtR/vs9tKK7
bZxQaUM/AnADZmK5BMWC8JIpwBR8P+D4Zo4rWhXSPZl/MrQ5RsJIXm0sSrLokym1
sQp/DziO1Gn1M2nnMHImCPC26hTxT1tDNOpFMpAFZisJKSeDAFYdUIrXVv+v0fjw
Zs1zqDqDtAdf7ub6+2JPKARJquQQ9uc+TvKb1lco+FORhedg7jaPx2LMsdMhv8Re
7+cI6D35MMyNkDxAJORF9cpoduOdzz/FHI4xs5ZNM3yK1lNF7owXdmb4NvMRKckG
Ir4mwbjRTt/1MBfXYHwSczZKmPvufcUUDp0r5LRbFsEQR/elmPPCuCqBZhTrVzOC
1CG3Vqwcwlu3+60nXM52E+OMVixfSdD0Uth2NLgX/vPiKmR6LLdYt6l2MqWdAOaQ
euxU7S9uf3zn3F213Ir3
=Ah4j
-----END PGP SIGNATURE-----

--=-tvH/v6FAyDpopk8292kq--

