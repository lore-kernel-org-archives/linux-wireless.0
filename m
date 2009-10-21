Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZJUB1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 21:27:42 -0400
Subject: Re: question: "possible recursive locking detected" with cfg80211
 + monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910201236.25871.hs4233@mail.mn-solutions.de>
References: <200910201236.25871.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pGHVlin3y6AZns83ksAg"
Date: Wed, 21 Oct 2009 10:21:46 +0900
Message-Id: <1256088106.4475.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pGHVlin3y6AZns83ksAg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 12:36 +0200, Holger Schurig wrote:
> Hi !
>=20
> I'm about to add monitor mode to my cfg80211 code. I wanted to
> keep as much of the monitor mode code from libertas that I could,
> mainly
>=20
> * priv->rtap_net_dev
> * lbs_rtap_XXX() in main.c
> * process_rxed_802_11_packet() in rx.c.
>=20
>=20
> So my code is quite simply currently:
>=20
> static struct cfg80211_ops lbs_cfg80211_ops =3D {
> 	// ...
>         .change_virtual_intf =3D lbs_change_intf,
> };
>=20
> static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
>         enum nl80211_iftype type, u32 *flags,
>         struct vif_params *params)
> {
>         struct lbs_private *priv =3D wiphy_priv(wiphy);
>         int ret =3D 0;
>=20
>         lbs_deb_enter(LBS_DEB_CFG80211);
>=20
>         switch(type) {
>         case NL80211_IFTYPE_MONITOR:
>                 ret =3D lbs_enable_monitor_mode(priv, type =3D=3D NL80211=
_IFTYPE_MONITOR);
>                 if (!priv->rtap_net_dev)
>                         lbs_add_rtap(priv);

check what that calls -- probably register_netdev vs.
register_netdevice.

johannes

--=-pGHVlin3y6AZns83ksAg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3mInAAoJEODzc/N7+QmaoTMP+QHYaTC3CVaKk9V0u3GW/a1c
s8SoWbLcR1zm1uKox0V1RcMO9v91FNB3hVStHR57xczMEFoZFeToUP8mpcLvHckG
/7ON2+rFC0wUHjV0mf4rU9xWasLrWvzyOuzZ7OLknh82RzNsBvqcRBh2oDXieWwp
PjpJUctzTENfbfzp7KBlzKNMCf9poxT0pJT6t2mEbZDWSdKIhxS7fc4D4ehcMeyd
xsbxbtBfPZSiNhUnI8sG2nJ5DBe/13n1HCQH00I6HjPnpHWCRlVYwhwvzjoJlvBs
MuQcjcmlUNGo8UkonHuFgZWzJrGpfF1uVy+1fsXy+YKxGNiQk9kXvGIiGu4+YTsM
4HsEKYESoXtHq8TjbQbmCdpx0DIcZvfZxJJ/k8aDcwcVynTu64EQ2hJBl3urK37v
r8bM4DPvWq4y9ID7dsYgvlhAHLG7/lBDW6qT6YYeCgaddW6IXjqxhjOGnWAqOuqw
lGqGq6v/lFYknXoX11weJMqbeUF6VCLzPI919Ab7C4p30E+Pi810pwGCRxEIb64j
/+hDfajcd7MmLN9h5Wb5FW/H1N447jGLa+zzeTF54p5aT9zAN5j/6FkXAoKIDBlZ
4omXoMb484Auw4exDYpzsP3Bbh3nt688k6sKIz5bQ7Lr+XAMeF6beCC7f6YhTTGq
V/Ap+kskDugDKAK34eEC
=P6hM
-----END PGP SIGNATURE-----

--=-pGHVlin3y6AZns83ksAg--

