Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYDWO7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 10:59:49 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <1208958783.5656.3.camel@localhost.localdomain>
References: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589>
	 (sfid-20080423_114948_059414_17607EB2)  <1208949162.31429.74.camel@johannes.berg>
	 <1208958783.5656.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x+taOVZx2AoaKrL/vBFi"
Date: Wed, 23 Apr 2008 16:59:08 +0200
Message-Id: <1208962748.31429.84.camel@johannes.berg> (sfid-20080423_170035_399635_53E4A243)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x+taOVZx2AoaKrL/vBFi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > +		// make sure no association start before we got a new BSSID
> > > +		ifsta->flags &=3D ~IEEE80211_STA_BSSID_SET;
> >=20
> > I don't think that patch makes sense, after all, userspace could reques=
t
> > to disassociate and afterwards re-request to associate by setting the
> > SSID and not setting the BSSID again, which would lose the fixed BSSID
> > without userspace interaction.
> >=20
> > However, I'm not sure how to fix this.
>=20
> Enhance roaming support in wpa_supplicant I'd expect.  If you set the
> BSSID explicitly, which wpa_supplicant does, then the driver should not
> roam to any other BSSID until userspace sends SIOCSIWAP
> 00:00:00:00:00:00 or sets whatever the 'disabled' flag is.  Such is
> WEXT.
>=20
> I'm not actually sure why wpa_supplicant sets the BSSID explicitly, but
> I also haven't looked into it much.

Lars mentioned that it sets the SSID first and then the BSSID, maybe the
trivial fix would be to make it do that the other way around?

johannes

--=-x+taOVZx2AoaKrL/vBFi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASA9Ou6Vg1VMiehFYAQKXRA/8D5ug1aivRZizJVfXY6SlQ/2Rx6v9mwaK
FoagHWFLdVNGfS03wBdIbuOpdVTT5liTPPcglhnJYLFCpB0ZUXwX67SQJ8VJyZ7B
SWE0K/rZEoZBH+0B2vryF3dBmaj/wktA9oUMZ3LCK3Ff1CLhu8TZMj+6zyQbb1/X
oBpcujetezNGiRiZN6eDVIoyudye5ERb/bn423uQZ6Ex81nnsxh2QMw1wb1pUUMR
kizM70IEet36kM1FiSSeSTa6+uU9oHhZkRz3nMTb5ahFNaT5KyANQ30hY/gTX6Ay
qhC5s9/t0M5rYzlXm4ciOXw+QPNif/2TZ6R/gm2ESZJCJA5wxjUbF8mn33yncwhC
sXhfYTz0g1N2vswJ3xecSyawD7AbWK4JShBGXSWhgJYTa/HqM60Kbzbz29ZdERhq
MqL6VPz4tp07GH1+6bKWs1lhLcbc2wCqbQWy4vIeYfltHV6KRu+gdRyUKaUCgTNy
0NEBTE1ygLuZM8uECvoQj6gFoHx1K764fX989V838Lwfhm7WGquDndmdtky+U6cF
czESYLOYWljBcbXYlU+J4OuYt7pHf0FiEMqlwzC+Jp3/bwoPxl+tfbCTqS/3eDGh
Xb6ECG44Deq35cZ1wzYAZvU5FrbqRuUGO0NUuJxM+O16ZlTLlnBNda1SaJ0XGFwS
rUidMcks/KQ=
=9OyQ
-----END PGP SIGNATURE-----

--=-x+taOVZx2AoaKrL/vBFi--

