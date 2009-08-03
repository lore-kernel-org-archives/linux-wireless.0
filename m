Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZHCIor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 04:44:47 -0400
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A7612F8.80802@gmx.de>
References: <4A759341.1090006@gmx.de>  <4A7612F8.80802@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c5ej9Ucl7GhwTqWEW1HD"
Date: Mon, 03 Aug 2009 10:44:44 +0200
Message-Id: <1249289084.2007.54.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c5ej9Ucl7GhwTqWEW1HD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-03 at 00:28 +0200, Joerg Albert wrote:
> On 08/02/2009 03:23 PM, Joerg Albert wrote:
> > After
> >     ifconfig wlan1 down
> >     iwconfig wlan1 mode managed essid huhu
> >     ifconfig wlan1 up
> >     ifconfig wlan1 down
> >     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
> >=20
> > ar9170 crashes (see below for the syslog).
> >=20
> > It seems like ar9170_op_bss_info_changed() is called with ar->vif =3D=
=3D NULL
> > (i.e. ((struct ar9170 *)hw->priv)->vif =3D=3D NULL), while parameter vi=
f !=3D=20
> > NULL and
> > changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED) is non-zero=
.
> > ar->vif is passed unchecked to ieee80211_beacon_get().
> >=20
> > Is this something ar9170 is supposed to handle or a bug in=20
> > cfg80211/mac80211?
> > Is a driver's *bss_info_changed proc called while the netdev is closed?
>=20
> It looks like ar->vif is set to NULL by ar9170_remove_interface() and the=
 one call
> of ar9170_op_bss_info_changed() when ad-hoc is configured has changed=3D=
=3DBSS_CHANGED_BEACON_ENABLED
> with bss_info->enable_beacon =3D=3D 0.
> So it's a bug in the ar9170. I'll try to post a patch.

No, it's a bug in cfg80211 :)

johannes

--=-c5ej9Ucl7GhwTqWEW1HD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdqN5AAoJEODzc/N7+Qma8kcP/1ORp7+dycXXzU9twpi7Il1P
gz9OMhZA+3NBLcGtSkQN1p4t4GF3IdaguNNi/90sZeJTh6M/TQeAdpCTVHTc8K4z
t1ELhJsgLXW3ix8OTZzKxAVjNk+YJ6SSIfVRRJCSo3Z3maqn7QpfPQ8XXbQCUiRv
CWFeWWgfWnGCm2Y2XT6mGbKdfyu9zAajqWNRkidUNxbcqg9BZJJM+alIMjG30Usd
iMO+7BRRo+xfVHo39091vwcopYGCtizzpjy1Cj61oq9Tb1yKVBjIdpg/sjm1hx+J
GU+VaWFDsDWQ5wyf9A45vc/t8OErgg0twvHMaIFeBVDopGm7BAyrx1V23f6p7HN2
9fDQloV1RxyrTcLGWinmBknqxbTc7fSJeX4nA9SiL+LJ+On4/8AyZQ57/kujbfdN
IU+b17ch16Z0HL2ZFDjJpn8LDCyuP4zrA5npHACVRJ5KuMWUygNSORCmQ6151KzX
+JzIpRfQ3XqNOmWucTQJnEfeaFr4yp7qKoQ2wrU63bAg8i3mVE0kQM5JsgUfce7U
Vmhnz46kjsw6yY9yBKT21AMVorogeVvBam0EHiyG1uNon+ldC62caTOZ/uE8DbvM
GgoJE9Y55fWPaJ94+MM8lOz5R5C3CRoH3Ah5eUmcxEWygaU+FVAzgCahWj79XRsq
EdszvlHq5xGM/hIfeAos
=bbcL
-----END PGP SIGNATURE-----

--=-c5ej9Ucl7GhwTqWEW1HD--

