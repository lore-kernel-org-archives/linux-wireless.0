Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYBKMXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:23:10 -0500
Subject: Re: [PATCH 07/13] o11s: support for mesh interfaces in mac80211
	data path
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202517407.7025.32.camel@localhost> (sfid-20080209_003557_233779_885FFF46)
References: <47a78281.03b48c0a.7362.5d39@mx.google.com>
	 (sfid-20080204_212421_865811_21908028)  <1202345620.9965.80.camel@johannes.berg>
	 <1202517407.7025.32.camel@localhost> (sfid-20080209_003557_233779_885FFF46)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4dubbBLWj9ARlT9pplYR"
Date: Mon, 11 Feb 2008 10:30:24 +0100
Message-Id: <1202722224.11481.42.camel@johannes.berg> (sfid-20080211_122314_003671_98A1A3D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4dubbBLWj9ARlT9pplYR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-08 at 16:36 -0800, Luis Carlos Cobo wrote:
> On Thu, 2008-02-07 at 01:53 +0100, Johannes Berg wrote:
> > > +		if (!is_estab_plink(hdr->addr2, rx->dev)) {
> >=20
> > This would get to be something like
> >=20
> > 		if (sta->flags & STA_FLAG_MESH_LINK_ESTABLISHED)
> >=20
> > right?
>=20
> I probably can use just the AUTHORIZED flag.

Hm. The authorized flag basically says that it's possible to
send/receive non-eapol data frames to/from that station. I think you
shouldn't overload it, might not an implementation of secure peer links
need to be able to distinguish between different states? In any case,
adding a new flag is cheap and more self-explanatory imho.

> > I suppose you should be adding sta_info structs for each mesh peer and
> > set the AUTHORIZED flag on them. Is this what you were referring to in
> > the patch description?
>=20
> Right, and adding a pointer to a reduced mesh peer link structure with
> variables only needed for mesh (it would only be allocated for mesh
> interfaces).

Sounds good.

> Btw, I will also fix all the issues I'm not commenting on in this patch
> and the others. Thanks for you patience with me!

Well thanks for doing this work in the first place! :)

johannes

--=-4dubbBLWj9ARlT9pplYR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7AVr6Vg1VMiehFYAQI74g/+N7N7zGe5hHKMCS4vM/xofHfoJV1ZKRYf
pIX3Vitte077jQ5Kugpq8N0cmdxNVt/NMaSPt5UYo/bx6SSp3h9ja6882wVuRye5
NHCiJUCiKEAQf48tBbXTKg7TRcq/stk2PYFoW+1bhgtN2uOvQ+T8/gqgfamrRuZo
KfuX+G2WJgWzq0YAoIS/0IP7t0ChRjeOnR7ptzkEZUbje2rowesJayy2762uh0HW
978QFTWeKjYb294f3KEVocstMkGrIOkMhsDrRnQO1cdQyaauYwpRYOtVZ6sHqw1O
6fEt4WGOvXabx/QSGbqqAVqiyF9J9uMYo5kLyUpIjUIEUWMuKSoJDB17EGkXN6Ir
C35MCJRL7zBXqfSw5J2mYb55/3pb+ty3vEk5PlfIbIggF/VMJtZfuRZu4zNWUxtL
97kXw9vs4TMO2AQP2HII3vB26gAhvBmm9RIJE6dYnziprs74iD34LxYVvsWZUIvU
d/R5G/F3WApF8lfzFArNd69XPOwVZfu7G3PPGPoA75eHjZVlyQrLBckW6mL/y9U6
bb/dADNQfh0XgHonCWW+r3ayzPxn/EQ0oAzphTP2ykGwbtCSU5NFTN17a3Tb2dBb
cR6YVytS74Clugco1T6bjnje9bk7DdTTn+hsErwWEFejLZQgjuVkm8Qcc6IKGl4a
7fZ9pGDjPcU=
=U3vs
-----END PGP SIGNATURE-----

--=-4dubbBLWj9ARlT9pplYR--

