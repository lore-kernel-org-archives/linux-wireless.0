Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYHCJbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 05:31:20 -0400
Subject: Re: [PATCH] replace net_device arguments with
	ieee80211_{local,sub_if_data} as appropriate
From: Johannes Berg <johannes@sipsolutions.net>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217721877.14226.12.camel@luna.unix.geek.nz> (sfid-20080803_020445_938315_49AA8B69)
References: <1217721877.14226.12.camel@luna.unix.geek.nz>
	 (sfid-20080803_020445_938315_49AA8B69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f4jAjCAiP+W2ZvoK4u9u"
Date: Sun, 03 Aug 2008 11:31:15 +0200
Message-Id: <1217755875.4721.14.camel@johannes.berg> (sfid-20080803_113124_081540_CF87A54D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f4jAjCAiP+W2ZvoK4u9u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 12:04 +1200, Jasper Bryant-Greene wrote:
> This patch replaces net_device arguments to mac80211 internal functions
> with ieee80211_{local,sub_if_data} as appropriate.
>=20
> It also does the same for many 802.11s mesh functions, and changes the
> mesh path table to be indexed on sub_if_data rather than net_device.
>=20
> If the mesh part needs to be a separate patch let me know, but since
> mesh uses a lot of mac80211 functions which were being converted anyway,
> the changes go hand-in-hand somewhat.
>=20
> This patch probably does not convert all the functions which could be
> converted, but it is a large chunk and followup patches will be
> provided.

Way cool. Unfortunately, your patch seems to be word-wrapped.

> -		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
> +		mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,

I wonder if we can remove rx->dev at some point. Don't worry about it
right now though.

johannes

--=-f4jAjCAiP+W2ZvoK4u9u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlXrgAAoJEKVg1VMiehFYUG8P/2/0XWgYzokrfRzHGH9YNSHn
ymVkdywT0CZ1+yA4YrcukccjoOimQU65KOwV4o9JW5bMrLdK4TJtyxFva3fgrAei
0kw6OtNbVArYkZJSbqUCmZRaSXjhPwO+7ekJ8x8Ph4DFHvQDcxg4gQXvaQu7x2Je
DvI1fYlI85ljshH6IftbByhuf/d0TGB4mrUkdfn+uYmZI0/3sePLaEzJDhxibUR4
2Mphl01kYXzim8flgpR/Pg7JY0JeIzVuJfPmCKXjdmQzNmLsWQp76ju9fMKYxbBB
w62FhInwSfxqhXRUnkBVzdRA9uryIaXRfsF83x3u/eGUKkjfVAUFvH1s63znpnGc
Olx1vC7Nt1Mwp0uUWV0a0Xnw2mjFKVT6U9/v7kdem4VihsxSMBmM7ctPVn4ACQJp
vQglBrjXVBuazOxsB0onPqVfIYLb0BuKPbs9Dprfk9jbewBMBj/J1oP2ydnUbdha
NdYWvmj4IEG5/URtBZhcLVGGWKzQHwBKn1LO+YdL178iacLhiykHY1qvg+qGE/rl
eyIkRaxkAM9m93aUFx0KGfcrCYOGedEe3ywEy2eY3D9fu8T7/ihuvwXLRJA4dmek
zn2/nEaT1DxL5j2TCkov3mImJNuprnQxWDjKBVSw/gpNE7X6VkFndZm7HB4g9vb1
nx2fqZNujVrLx6IoK+Y/
=txx+
-----END PGP SIGNATURE-----

--=-f4jAjCAiP+W2ZvoK4u9u--

