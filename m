Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZIZLjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 07:39:16 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
	 <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v1dFu/rguU3pkeAkMP+1"
Date: Sat, 26 Sep 2009 13:39:14 +0200
Message-Id: <1253965154.5122.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v1dFu/rguU3pkeAkMP+1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 16:54 +0100, Hin-Tak Leung wrote:

> > Can you try this? The last hunk is most important, but the other stuff
> > helps debugging.
>=20
> Great. The extra timeout in wap_spplicant.log is gone, so it is back
> to NM does it all by itself.

Interesting, thanks for the test. I'll go submit the patch.

> Here is the dmesg from this patch on top of everything else so far:
>=20
> wlan2: starting authentication with _id_
> wlan2: deauthenticating from _id_ by local choice (reason=3D3)
> wlan2: starting authentication with _id_
> wlan2: direct probe to AP _id_ (try 1)
> wlan2: direct probe responded
> wlan2: authenticate with AP _id_ (try 1)
> wlan2: authenticated
> wlan2: starting association with _id_
> wlan2: associate with AP _id_ (try 1)
> wlan2: RX AssocResp from _id_ (capab=3D0x431 status=3D0 aid=3D1)
> wlan2: associated
>=20
> There is still the extra deauth at the beginning, but I guess I can
> live with it, it doesn't require user action to deal with (unlike
> without this latest patch) I suppose there might be more tuning before
> commit?=20

I think I'll just remove some of the printks again, but leave the ones
moving. Actually probably better to split it up into a mac80211 and a
cfg80211 patch.

The extra deauth is because cfg80211 already starts the auth with the
BSS before wpa_supplicant set the BSSID, and then when setting the BSSID
it asks for deauth, but before we ever actually did anything... I think
we'll just have to live with that, since it's hard to fix in the layered
design we have now.

>  Otherwise Tested-by:
>=20
> Hmm, slightly side-tracked - was the original poster using NM on top
> on wpa_supplicant, just curious?

You mean Albert? I don't know.

johannes

--=-v1dFu/rguU3pkeAkMP+1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvf1eAAoJEODzc/N7+QmaHkUP/15JyLd9whq7RyzO8VGhy6RL
N/dsUleCftH0e1NT0pBjfSzftgJjepiyEpEQqanG04TAPoqKYGOreiwnX01eyHM8
3KA7pJG/ndDXFoZ5qDR9DNv8UhnSQ74tp/FyVdZjGQ1lj581TK2wIs/rFTVaSsMr
pjqP82FoyTQYLJlVHYAZTxLAj4VNcCgpukud5gL+3Fe7/2f9LYI7BFGcYaFELKT7
U0bQmrlV0QfE7FJVO9fO+vpJc4+ml7+CMrgtI0BAl5yJITV3aA+RbZfwSyeHeQJ7
GznsQJJiTUTP8vUlVSvviuDm13n+deBrG3Pn/B9UxvviGY23uARgRmljeCCCWpQc
UxWu22pNDcpHJBhSr5iGoV4k2pSzDzIs6+tUHFAvrk0p1/N9nWnotIthItImxdxG
0+KPnQOBDCG4xrNFb/8ZGdeYIx+/HlZdrac+ApRKpbvnK6HV0wHrNZ1kP4mGwgXz
9zp9IKnFzrLa/1tTiP5FObprGvcFPL11Qw4vHPVcCFguCu5n6B73pGI/3Ayp6gfl
1H24QfX7OmsdH71xZ6VI2LhWK349ON+n8q7hYAzaKqN6RoY0mZY154wQltULhCu+
qJyBnJvEcO4iYDLtAKPzJlZLjvI/XRUMES9y+7PEmiITVRAgY0tm3eAHZza5dQh2
xULW9zyIInf5UAJfHhhF
=+7er
-----END PGP SIGNATURE-----

--=-v1dFu/rguU3pkeAkMP+1--

