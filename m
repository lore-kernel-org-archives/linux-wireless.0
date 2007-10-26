Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXJZKjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:39:25 -0400
Subject: Re: [patch 6/9] nl80211/cfg80211: station handling
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890710250846h5ae85efaqfb5b7b5d0d82e932@mail.gmail.com> (sfid-20071025_164609_452587_977402E4)
References: <20071025093618.440937000@sipsolutions.net>
	 <20071025093716.685606000@sipsolutions.net>
	 <43e72e890710250846h5ae85efaqfb5b7b5d0d82e932@mail.gmail.com>
	 (sfid-20071025_164609_452587_977402E4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uiuaAa5n+T0ulSBQJyUz"
Date: Fri, 26 Oct 2007 12:40:38 +0200
Message-Id: <1193395238.4406.47.camel@johannes.berg> (sfid-20071026_113937_394718_4ABF3CF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uiuaAa5n+T0ulSBQJyUz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> > +static int get_vlan(struct nlattr *vlanattr,
> > +                   struct cfg80211_registered_device *rdev,
> > +                   struct net_device **vlan)
> > +{
> > +       if (vlanattr) {
> > +               *vlan =3D dev_get_by_index(&init_net, nla_get_u32(vlana=
ttr));
> > +               if (!*vlan)
> > +                       return -ENODEV;
>=20
>=20
> > +               if (!(*vlan)->ieee80211_ptr)
> > +                       return -EINVAL;
>=20
> Check #1 for (!(*vlan)->ieee80211_ptr)
>=20
> > +               if (!(*vlan)->ieee80211_ptr)
> > +                       return -EINVAL;
>=20
> Check #2 for (!(*vlan)->ieee80211_ptr). Double check.

Hah. I think the latter was meant to be ->wiphy but that shouldn't be
necessary.

> > +       err =3D get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &para=
ms.vlan);
> > +       if (err)
> > +               goto out;
>=20
> This is minor, but how about doing the check of
> info->attrs[NL80211_ATTR_STA_VLAN] outside of get_vlan to make it
> clear here we're setting it to 0 if not found?

Dunno. That makes the error path more complicated, no? I guess that then
I'd rather do an *vlan =3D NULL assignment in get_vlan() to make it
crystal clear.

johannes

--=-uiuaAa5n+T0ulSBQJyUz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyHEJaVg1VMiehFYAQIT0w//T5CTfPngW/BrWYO//NgGBCXbJvgKIK1i
G5uVH9q0uPCHvMaOSQBwe5Im5TqKL5nZnDNyXmWsVNrEQsTQ8knkqxqJ+dFUZqgs
VyAj6mYJeydUgZ7cQAb0QeOxRqQQ+lDkU81t6goxQj7FiJTRIpoypN/dNgYsdE9H
EhQBavx0xsurOeWUx4xACY2YsdNUwKsB+jLrB8Z1y7EqX55nbY3shMCZXPSzxA7g
EyJCHJIgndvZfAWuq/xZCT5VwtAGrHnLMBt0Lp5lOWy/o6MUBaZhjej/gR2qHXeu
LyFu19uzdCs4tOOCkGePj4quqXGujWEy7k5W3t7c50TCFZxa/99fApOtC91AKqhJ
vlrB5KJMjaWmQ/Z4UzJmcOzBIqVtKlxc5NlxOqg9Ob/6QGf7Xf4M6KM5YxZK+U2w
rAtHsBjubfDC5L/RK+wqp0ALXQXFU/7hMCI53fQS8ks3ncUmebiQ3zG4zeJTDqlM
JIY21mZbcFk1dxP/pTgIA4t9jynHDk/2ERyVuy05/F4sZOaLwN0Fys7NkDI0uhTl
My5GgKAPzs2zhG/heozirLP5VD6IZjEDWqag6D0z32RSJ1SQI7KiJlmLsh89fiOJ
UYmwFvaA9Ej16kygtL1EptZpvTn8cjTB5wUTWBkYwn8RHYySpioGfJ5W2+QKYHLA
9XtgZ/dk7yA=
=rsoQ
-----END PGP SIGNATURE-----

--=-uiuaAa5n+T0ulSBQJyUz--

