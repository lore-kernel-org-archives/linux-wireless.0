Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZA1OvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 09:51:04 -0500
Subject: Re: [PATCH] cfg80211: add get reg command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090128144455.GE6174@tesla>
References: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com>
	 <1233137841.3936.2.camel@johannes.local>  <20090128144455.GE6174@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T2gjDnAs6BulXP7H8/rk"
Date: Wed, 28 Jan 2009 15:50:34 +0100
Message-Id: <1233154234.4071.26.camel@johannes.local> (sfid-20090128_155109_427369_86BF6984)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T2gjDnAs6BulXP7H8/rk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 06:44 -0800, Luis R. Rodriguez wrote:
> On Wed, Jan 28, 2009 at 02:17:21AM -0800, Johannes Berg wrote:
> > On Tue, 2009-01-27 at 18:52 -0800, Luis R. Rodriguez wrote:
> >=20
> > > +	mutex_lock(&cfg80211_drv_mutex);
> > > +	regd =3D reg_get_current_rd();
> > > +	mutex_unlock(&cfg80211_drv_mutex);
> > > +
> > > +	if (!regd)
> > > +		goto out;
> >=20
> > Any reason you need to copy and can't just build the whole thing under
> > lock?
>=20
> Glad you asked, we can lock the entire call or we can do the above to
> copy. I picked a copy to not let a regular user (get reg can be called
> by anyone) abuse the lock as cfg80211_drv_mutex is used in a lot of place=
s,
> I guess its silly but other's input on this is appreciated as well. Not s=
ure
> if the copy was the best choice.

I don't really see much difference between locking to create a copy and
locking to create a copy in a different format, do you? Except to create
a copy needs to allocate memory which could take even longer.

johannes

--=-T2gjDnAs6BulXP7H8/rk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgHC4AAoJEKVg1VMiehFY+J0P/jBaUe6bPl7oVQe4jQy+VXLo
WFHqfO0T31mSj3TqrwSj6rvtWSUv0NZm0yu8CPCo817ytTU91juvQjelns4faaCo
bIj+M96YhfiF3zX71UnHW9osxN7lFC+PLLLrCoNtYyw9EKQ9BePlFaseQu/lnBAy
jKjVntW/y62MKREdc6+qFx1pU2Dx3X5jwSrRLrGWVZiIP5b71lxew/ybBV5ROz3G
KC5BPAPSyYrrhqqcMTt34SnPwnoWTAUv56ljYaNxd3f2ymBwo5nfZu/QT3zHyLtC
0HMUkaW6bU/bZDG8gD++Xn/Zu7ZGim8GcrgA0NH4IN1Dg4gacsMOtIOdURrEGGvO
uEDeiYbPP4AO5OCKLIPnmX9UbqaDGuUot5aWsRpBUJjQ3XExK8Ylvf9Zu8TteuQ1
44J1tjSjYxf4VjnHG9IJwaKt3Dz7z+CjCvLhpaDRHxTWhapEUioLi36JGL+3LuI2
tgZGVrOzLUv/YsuI9aBkBH8L6ChrS8Dei6ZajWi+9QhNAPCoQBQpg3EUVI265ZD2
P11JXitl60tBslS4spzeYdbNGdXST7/vsf4Sl8QpWJAUjBws4O8ohl784/H/D62B
2ynobWXUbQ6sJZ5vOy2QAc02TV6RDMgbyKqdUwz4KOlMbXYLCMC4+iYTQLm0Flzr
1OROita8w3AUKmMR0bUC
=dxT2
-----END PGP SIGNATURE-----

--=-T2gjDnAs6BulXP7H8/rk--

