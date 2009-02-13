Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZBMVY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:24:29 -0500
Subject: Re: [PATCH 5/6] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902131021j6289a817m67c9ad22ab958a1d@mail.gmail.com> (sfid-20090213_192843_031278_8BB98976)
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234523055.4219.15.camel@johannes.local>
	 <43e72e890902131021j6289a817m67c9ad22ab958a1d@mail.gmail.com>
	 (sfid-20090213_192843_031278_8BB98976)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6TIRVBYWAo0g6K8UBkbt"
Date: Fri, 13 Feb 2009 22:24:24 +0100
Message-Id: <1234560264.4219.33.camel@johannes.local> (sfid-20090213_222432_998019_84F1468C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6TIRVBYWAo0g6K8UBkbt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 10:21 -0800, Luis R. Rodriguez wrote:
> On Fri, Feb 13, 2009 at 3:04 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
> >>
> >> +       if (wiphy_idx_valid(last_request->wiphy_idx))
> >> +               request_wiphy =3D wiphy_idx_to_wiphy(last_request->wip=
hy_idx);
> >
> > All this seems pointless, wiphy_idx_to_wiphy will just return NULL if
> > the index isn't valid. This is in a number of places, and it's not like
> > it being invalid will be happening often so we'd have to optimise for
> > it.
>=20
> The check can be removed if the WARNING is removed on
> wiphy_idx_to_wiphy(). I left it as I figured it'd be good to leave the
> warning, your call.

Dunno, I think no warning is probably better if more than half the
callers would have to check first... Also, the warning seems like it
could spuriously trigger if a wiphy is removed?

One other thing I noticed - why is there a conditional assert on the
mutex? Shouldn't it always be locked?

johannes

--=-6TIRVBYWAo0g6K8UBkbt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJleUGAAoJEKVg1VMiehFYxRsP/1ylyP9DtMBEsMaHVNM/GM0M
sAcxfewa9VHeYieUzt3Ey63yuBD2re7xnba0L4IZLzye0e+BbnEHy9QUuNd/FUh0
TIhjBeVLbuQKtUkZ+jv5LvaSomy1tq/J/4cQnJSdXb7khE5yvtQ6eHx0tJpDvKds
8A05Qo5s2w4tkRJCwqf+qbCBd2Kr/GlGhoCWsalPiYVXyLs6AjR3CToKAH2IStfS
lDqGjPraJZJuRMA9lQhrWP+6WT/EXnrGgXb2Flmy5OfP/IXa04lCmSPqI684ImYZ
0snVzTfRw/nejner4joXbfZQoHZlH/mDkPD+7l4oGkBqe9O7nylQ33C+HIGEoDo6
M3HoY8Gi1gO3pqlGEYSv4BxA+Hg1lE1scTwgIaW+ctVK4sfcN4XS+4a/EQvGGETW
9XY3eMWkrWIkE5pE8TK8Hvj+FhPVNQq7R2n4lC9kIrBiJ8ZeKDHDHqbOEVvq6qqH
X8Rs3TgsMmJ0wvgluGHbrxZzHS/Ma/WGnyFU6F9xuYPD+vFpAodqFC1AUWOC5RBP
FTyo2furFm9rZC3VGx34UC3UPf/JSuepquFkmxAAvlOgUf35ikPpB1NZS5RW1HPi
deZAyjpmqe+22TqPcZJBwDJzGLln0Qri1rpNDxxxoldnR8oCIP4Ag5r7Mwwr5aiU
0uYsgts7D9HUN/qcwP5E
=y07C
-----END PGP SIGNATURE-----

--=-6TIRVBYWAo0g6K8UBkbt--

