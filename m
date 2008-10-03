Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYJCIFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 04:05:08 -0400
Subject: Re: Regulatory Framework & rt2x00.
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <48E52D07.8050900@kpnplanet.nl> (sfid-20081002_222035_260539_19D08D89)
References: <48E52D07.8050900@kpnplanet.nl>
	 (sfid-20081002_222035_260539_19D08D89)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EaWOZ/UkFGr6FJIfOE4M"
Date: Fri, 03 Oct 2008 10:05:04 +0200
Message-Id: <1223021104.24551.61.camel@johannes.berg> (sfid-20081003_100518_451352_7A74CF95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EaWOZ/UkFGr6FJIfOE4M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 22:20 +0200, Gertjan van Wingerde wrote:

> The problem I'm facing is that many of the Ralink devices have 2 region=20
> settings in their EEPROM, one for 802.11a networks, and one for=20
> 802.11[bgn] networks. So far I have only seen devices where these two=20
> settings contain the same region indication, but I don't know whether=20
> this is the case for all devices.
>=20
> At this point in time I use the regulatory_hint function at driver=20
> start-up time to communicate the region setting that matches the=20
> configured band, but that would (probably) not hold up when the user=20
> reconfigures the mode.

I think you basically have two choices depending on whether you have a
country code in the eeprom or not.

If you have a country code, I suggest you just use either one.

As far as I know, though, you don't have country codes. So if there's a
valid code in the EEPROM you probably should use the regdomain struct
hint rather than the alpha2 hint and build a regdomain that contains
both 2.4 and 5 GHz channels based on the two region values you have.

johannes

--=-EaWOZ/UkFGr6FJIfOE4M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5dIsAAoJEKVg1VMiehFYm+EQAIH+czvvOm2gotDIp5k4hVmi
dp9LahKiY04BSCFSLqNQny2p3v1e+rhdvEeJaqHr/hm6JHGR7dhLeDjSHDZUreZa
1GWdPjyJFhgK0nPnmEbw7dXcWM6bq3Svplnofxp0xEKS7QPecPKNmPUa5k/4RJ3S
gak5DcMezuRC6Ckh7XqNtZWXN5HSd7u+KxwZOh/Kxoy85x1ILB+CbC0C2PtVZeLG
dURdKuZLaV31fE5AEZSOVxYlxWzyNQw//2p2K7KncKohkCLfpngR7/uLtxPmrS+n
XC6tj0/RsaTq6a3LEcGCq9XFqCXYWIv64PfxXayL8MbzSe8OaTRZ1W8RN14J0QZu
Wc4UCe8yzJGPX2/FxbGCxHugPFo7TiCrZonBjC6FVC9A2qNfH+LD096CxJpHkaku
fo2v76Yu8KgmsjJY0x7UuACYvpbXsodL7I0Nu+JvH/YIJFLfx9xrcBiyU7SlJMhE
U+qKCn7WRhmdV7QcM2xT5H0q9bBAkzjyXwhLnv5t6DQ1gHkO8CpJlT/xxea22G/f
4Mq78UjJUc9jEb/chVu8TPckd1A27EKsqIYvgcNyTcR/CX0KMACA/Ac1dvJIoW9K
qJ/JW8JXDscPdtF7em272KN4E0I4FHDbKNHEhRCnQTCN9h3NvJr193qogB/DuEL+
OBwkzYhv+QGORLEmo6kc
=NsyK
-----END PGP SIGNATURE-----

--=-EaWOZ/UkFGr6FJIfOE4M--

