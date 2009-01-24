Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZAXOLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:11:25 -0500
Subject: Re: SIOCSIFFLAGS: Name not unique on network
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40901231457x57625153wad49b4869a1627bd@mail.gmail.com> (sfid-20090123_235736_918517_D9893DD8)
References: <49788E88.5000608@telecom-sudparis.eu>
	 <1232749288.3977.14.camel@johannes.local>
	 <45e8e6c40901231457x57625153wad49b4869a1627bd@mail.gmail.com>
	 (sfid-20090123_235736_918517_D9893DD8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uzuGL6jbZmBj/l8BGJfL"
Date: Sat, 24 Jan 2009 15:11:18 +0100
Message-Id: <1232806278.4036.1.camel@johannes.local> (sfid-20090124_151129_857358_2A51A8E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uzuGL6jbZmBj/l8BGJfL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 14:57 -0800, Andrey Yurovsky wrote:

> That's indeed strange: the iwl3945 (along with the other Intel cards)
> definitely doesn't support mesh but I was able to add an interface as
> well on my Ubuntu box (2.6.27-9).  I think the reason is that iwlwifi
> doesn't explicitly test for interfaces it actually supports:
>=20
> static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
>                                  struct ieee80211_if_init_conf *conf)
> {
>         struct iwl_priv *priv =3D hw->priv;
>         unsigned long flags;
>=20
>         IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
>=20
>         if (priv->vif) {
>                 IWL_DEBUG_MAC80211("leave - vif !=3D NULL\n");
>                 return -EOPNOTSUPP;
>         }

Yes, that was a long-standing bug in those drivers that was really only
fixed when we introduced the cfg80211 supported interfaces thing.

johannes

--=-uzuGL6jbZmBj/l8BGJfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeyGDAAoJEKVg1VMiehFYI9cP/32upbSCBFnkpZBPnj/b4C0z
VxSNaAzwbE/5deGyf39eqRLxy1sTshMX04aDsy594Rnmy9x0oLtJSJkI6b997Y3O
XwcxrO49YB1wBXBFxThlNKggZnN1QSZtXVd3dGCTzV/tASQGy/k2kbgw2hz+EBQ+
AHsiy4XPt46kM1iw/3Y8w8ueWw8jPgvUxeJWb0YKwZ9zi2YlscPpIhpaYtd2pL/F
mRYYM1qDPlzfobAcqV4c08gzUgWCwUGCI+AtCRqh67DzUlj7TeW5jaIolmFHp5Rt
szrUiux+TTQPBK7/hKk65R0lDa4yeWtdcrryNiiQagUEJEkmc+SQveTr/Y3dKSTZ
RcECuyGaUSoIRx0c/E1bsSRMDhpnxecOPj4fKYZ/Z1Okw0yK3ZqR3K3mUYjjsVKl
ed8lPYzbgugv3RsKk8heEZR8zg3AKfYZdN9V6o+/G5nOYRzon3svr9CIWjlIFHIY
lfC5u7AviyF5E/Tl2LEOcNg9DrId6ssova83df1zZECIPyws4CzVpdT3No/LEYfG
pIOA4VWq9BEpSrQLPE0tmTMqNNnmHe5ztjKuhsyNMnIkimsRJFmg9KeUfbzcnpwf
SBkHfqZZH9VhjDmZa0dPIT5GxkktLij4avGTEgZAEO6kg+0JMVGHGJ+TvfqGO0N7
uXZoPslX5yLBoONEv5XC
=drrp
-----END PGP SIGNATURE-----

--=-uzuGL6jbZmBj/l8BGJfL--

