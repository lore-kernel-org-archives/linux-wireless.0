Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXJZKmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:42:17 -0400
Subject: Re: [PATCH] Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to
	dynamic wep network
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <4721C23E.501@gmail.com> (sfid-20071026_113240_433638_78FBCECA)
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>  <4721C23E.501@gmail.com>
	 (sfid-20071026_113240_433638_78FBCECA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-So7jC+YMxhmp4ptxVKRo"
Date: Fri, 26 Oct 2007 12:43:25 +0200
Message-Id: <1193395405.4406.51.camel@johannes.berg> (sfid-20071026_114222_418440_98026EAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-So7jC+YMxhmp4ptxVKRo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> ieee80211_ioctl_siwauth in ieee80211_ioctl.c sets the=20
> key_management_enabled variable if the value passed to the ioctl is not=20
> 0 to true:
> sdata->u.sta.key_management_enabled =3D !!data->value;
> why !!data->value ?  that should be the same as data->value ...

Nope. Think again :) !! normalises to 0/1 rather than 0/!=3D0

> now to wpa_supplicant:
> wpa_driver_wext_keymgmt2wext in driver_wext.c  returns=20
> IW_AUTH_KEY_MGMT_802_1 (which is defined as 1) (when dynamic wep is=20
> used) wpa_driver_wext_set_auth_param than passes the value using=20
> ioctl(drv->ioctl_sock, SIOCSIWAUTH, &iwr) to mac80211.

Are you sure it returns IW_AUTH_KEY_MGMT_802_1(X)? My assumption was
that this is what goes wrong.

> ieee80211_privacy_mismatch checks for
> if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
>         ifsta->key_management_enabled)
>=20
> and returns 0 because ifsta->key_management_enabled  true in this case=20
> !!1 -> 1

Which is fine, privacy_mismatch() returns 0 if there's no "mismatch" and
we should hence proceed with the association.

> so the attached patch should fix it by doing !data->value (which would=20
> result in ifsta->key_management_enabled to be 0 here and therefor=20
> ieee80211_privacy_mismatch won't return 0).

That's bogus, you misunderstood the return value of privacy_mismatch()

johannes

--=-So7jC+YMxhmp4ptxVKRo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyHEzKVg1VMiehFYAQLDDxAArwpg6fLgydATTWQGL5f4JAXA+yT7fH+i
aEb0bBkGFPJkFDbZpfhX1kVWtatYB7wij2jjXMPBlR292dXkLoMHP5qfxSj7TpaX
bLDDE9+E0xgdwCUSIbqRQWReVtjzV1FJ6PAwtCxSwWApaUqYrs/AwqOuB4VRXida
WS3XLPWIEXimXoj55Trt6u2gdQouqPaw1yEJkffVUEaRMfVpRYeYZ+iWhZuM1Dmb
cyQP6jf6Aw46EAXdlNuQJOYu4CW8hHk9Z7LmJB7WRsBHW8VtTVMA283NXKfuKtQX
/tWVVRwGKN4mi5gi5RyMaP9Sc+mn2a9mnauUWLH8Xz7/jfkuJUkefSygBlasoLWB
o37kxXHDVTikoNF8plmZphgCcZWCOz0Sz0GkJ2oW+CMSBTBQKMO/UBK1K9JGJgY/
sQAElDoMIdvhbkv+Zk488dqxRjrkp+wbOYdWGtJxRwxewrvYF3AqH32GREr17Ylw
deztAaljNTYxoFZXxpClZD67V2clZqYtpYMeMOYGqa1Lf14wmbJV7CaU4eVeWfyj
0oAuIKEyXT3ITOfmLthRzPS0Mr5AIRLrPi1w472uIXSH3YobXX45RACgpRoZ5WnQ
C19i01kX0EW82fhfTa0XG3SbowXhi8fTRKCtsKdEZN68j1WuYbhFgNN9rXN0Igld
V5GEUMHrXzI=
=Voc1
-----END PGP SIGNATURE-----

--=-So7jC+YMxhmp4ptxVKRo--

