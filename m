Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZF3NiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 09:38:00 -0400
Subject: Re: [PATCH 8/8 v3] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090630132547.GB24667@vasanth-laptop>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vdo2QEt/y2U1okt4MLFy"
Date: Tue, 30 Jun 2009 15:37:57 +0200
Message-Id: <1246369077.16643.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vdo2QEt/y2U1okt4MLFy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-30 at 18:55 +0530, Vasanthakumar Thiagarajan wrote:
> On Tue, Jun 30, 2009 at 05:22:53PM +0530, Johannes Berg wrote:
> > The IEEE80211_STA_TKIP_WEP_USED flag is used internally to
> > disable HT when WEP or TKIP are used. Now that cfg80211 is
> > giving us the required information, we can set the flag
> > appropriately again.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> >  net/mac80211/cfg.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >=20
> > --- wireless-testing.orig/net/mac80211/cfg.c    2009-06-30 13:25:43.000=
000000 +0200
> > +++ wireless-testing/net/mac80211/cfg.c 2009-06-30 13:25:45.000000000 +=
0200
> > @@ -1228,7 +1228,7 @@ static int ieee80211_assoc(struct wiphy
> >                            struct cfg80211_assoc_request *req)
> >  {
> >         struct ieee80211_sub_if_data *sdata;
> > -       int ret;
> > +       int ret, i;
> >=20
> >         sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> >=20
> > @@ -1236,6 +1236,19 @@ static int ieee80211_assoc(struct wiphy
> >             !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
> >                 return -ENOLINK; /* not authenticated */
> >=20
> > +       sdata->u.mgd.flags &=3D ~IEEE80211_STA_TKIP_WEP_USED;
> > +
> > +       if (req->crypto.cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
> > +           req->crypto.cipher_group =3D=3D WLAN_CIPHER_SUITE_TKIP ||
> > +           req->crypto.cipher_group =3D=3D WLAN_CIPHER_SUITE_WEP104)
> > +               sdata->u.mgd.flags |=3D IEEE80211_STA_TKIP_WEP_USED;
>=20
> No, we have to disable HT only when WEP/TKIP is used as pairwise,
> not used as group cipher.

I thought it was both, but I guess group doesn't actually matter. OTOH,
this seems to match the standard better (HT STA is not allowed to use
TKIP/WEP)?

johannes

--=-vdo2QEt/y2U1okt4MLFy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKShUyAAoJEODzc/N7+QmaL6IP/3jGn+hZzwIwumM21gew2gPO
6SCx6+jXye5DguqBM4L9cM0/4RxLWJhfoWs9QRL+4RbCATNDilz2UQaak0GrkyDb
386tjgNNJI7Ox1jDU+aCpDuRp25zKR8NWy8UWF3/34VgUivORCICDyq9u47s6T3u
Nv2UHS1+EBa/Qf3qI5VuGF3W7WH9mv0uKZYEEAryWSAAtH8jEicgmOxUBekG/B3+
Xq439yXsNGrQx5mqwKweu63z+oo+aYUp9/UcijtFA9ql9XnneHbg1GDKtrMBQTBN
kNPnlsiw6z2KAviG1CPItpCNORMl0GF3D+rurnxC5jS6LS3RGpcKU+3Az6jR5Y1A
dJCzgUtZ/jypfma9G827wKFQ4XrKV5W9PMn6wmz3pR/ZV8oFrCDrHWd/iaPpnUjJ
zjil/UYYbvvW8a3O4SYBPi/uaj/gg7zfU7rYbZRo/I3002ddbfRarpzZ0KS5vM4c
xV7joY2mzOgD9mvnaZ8J6bHxAwKDubgVhyPwVl4I3ePNjeo1yiqnCjAxi7NCiHaL
1dCoZkrDNojnArpo+bQLxb0x0+w591AI95rjRPxDhWSfQEzELtcwDIniUl1tGfcN
wE72aVXcs5HYIkgsR/Zx0NIaoidNhZZsLyAfl2GGPppgqeHj2wbYslH5QfhFJ/Tw
yflPwEeIZY3bK21xaLmc
=vVx8
-----END PGP SIGNATURE-----

--=-vdo2QEt/y2U1okt4MLFy--

