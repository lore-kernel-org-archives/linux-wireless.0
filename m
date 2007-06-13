Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbXFMPyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 11:54:22 -0400
Subject: Re: [PATCH] cfg80211: use nl80211_* enums
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070613123333.GA3440@charon.n2.diac24.net>
References: <20070611221224.GA10598@charon.n2.diac24.net>
	 <200706122355.36078.flamingice@sourmilk.net>
	 <20070613123333.GA3440@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sKdFPpdsHpDS3JeuWqGD"
Date: Wed, 13 Jun 2007 17:53:52 +0200
Message-Id: <1181750032.29767.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sKdFPpdsHpDS3JeuWqGD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-13 at 14:33 +0200, David Lamparter wrote:

> That's not possible because nl80211_{iftype,phymode} are userspace API.
> If they were defined in cfg80211.h, nl80211.h would need to at least mirr=
or
> them. And since nl80211.h can't include cfg80211.h (since the former is a
> "public" header supposed to go to /usr/include with some linux-headers-*
> package), this way around is the simplest and cleanest solution.
>=20
> Anyway, I don't really think including a header to be a "dependency". You
> can disable the nl80211 implementation and still use the API enum just
> fine. (Note that nl80211.h contains enums, more enums and ONLY enums :)

Good explanation, I was just going to write the same :)
Michael, pulling in nl80211.h is the only sensible thing to do unless
you want to duplicate a bunch of things and translate them in nl80211.c

johannes

--=-sKdFPpdsHpDS3JeuWqGD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcBMQ/ETPhpq3jKURAi70AKC7hq9GFBKRHyc+3FN9dYwVucWS5gCfaWBG
nCyln4lX33kTyPAOInGL1y0=
=TqSs
-----END PGP SIGNATURE-----

--=-sKdFPpdsHpDS3JeuWqGD--

