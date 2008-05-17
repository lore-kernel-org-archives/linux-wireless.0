Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYEQQ5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 12:57:20 -0400
Subject: Re: NULL pointer in mac80211:ieee80211_associate
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080517185038.6w1m4n5n6s88ckgw@imap.suse.de>
References: <482DFC63.7050908@lwfinger.net>
	 <1210974434.6381.60.camel@johannes.berg> <482E1344.7080808@lwfinger.net>
	 (sfid-20080517_010547_496161_3AD36B80) <1210979397.3827.4.camel@johannes.berg>
	 <20080517185038.6w1m4n5n6s88ckgw@imap.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xW6v0B11vxc1MVsbf8rI"
Date: Sat, 17 May 2008 18:56:56 +0200
Message-Id: <1211043416.6252.14.camel@johannes.berg> (sfid-20080517_185725_511277_5CD1B573)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xW6v0B11vxc1MVsbf8rI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-17 at 18:50 +0200, Helmut Schaa wrote:
> Am Sa 17 Mai 2008 01:09:57 CEST schrieb Johannes Berg =20
> <johannes@sipsolutions.net>:
>=20
> >> > Can you try to find out what code this corresponds to?
> >>
> >>  From objdump with line numbers, it occurs at "for (i =3D 0; i <
> >> bss->supp_rates_len; i++) {" in ieee80211_compatible_rates, which I th=
ink is
> >> entered from ieee80211_send_assoc. It seems that bss is NULL. For test=
ing, I
> >> have placed a WARN_ON(!bss) statement just before the for loop.
> >
> > That looks plausible. Helmut, any ideas how to avoid this? Skip the
> > compatible rates test completely and use all rates in this situation?
>=20
> Yes, that's most likely the best solution for it. If we do not have a =20
> bss at this point we cannot adjust the rates anyway. Should I prepare =20
> a patch?

Please do, thanks.

johannes

--=-xW6v0B11vxc1MVsbf8rI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC8OVqVg1VMiehFYAQJW+hAAnXC8rjw2FvJY0L93zNxUOnZe6kBQl3Xd
AKIPQR8/p7TVsVxO1+/ty/d8bwwfcmm6D5dgHhn7p3K2XV8VCKfYRO3cnAv1IKnG
+AirDjKDatx7eHFcFiEDk5+9kidq/Pr/CejLTo+OzIn6X3X188T1Ok7T+/IotdHB
kJw0PQOOngBgdzulzoSD79mghk/ZR8urBVu84ngs8GBZjtWjc0nd297lxliuHGqw
mf3e3P7FP5TS2R8EWyuecs4EtbWnA9kRlfdrcuGM/KpkG4oVrIMsGJv6ZfaXUw62
9UVcKuZNYkPI4/7a2E3uJIPM4ulp27dU9G35lEURXIJ69b+NhmaP8yUFrT2G+f9x
ekAu5d1PHYMBceQREaWHZ1EDNe0g3UbGjtqko/9jfbuquev+7r8VTys7riXrkFF0
DDu/wzl6gIua5C+2m5anDO8e6L4gb54IVKIjXvuCcrKUMpQc+007LiRLbxMliC4q
7uNiOZ4lsVd/WnAd+eR+kL52aXqYaqNIfLdOPclOD4rf/lxNes4vto1AIJfYq/io
j1Q1MFxothsfjrBQQq5i8guv3OoBiIgbEGloHEPneLI7Wrjy9lISVtllVFwDALOu
pHr0m3h47bznju+kES3TVRuFDOn+Ni5+t5rRVs384aW4h8Dxc1PrxWPsu95rlG7A
F5GTWFdZUOY=
=rlmU
-----END PGP SIGNATURE-----

--=-xW6v0B11vxc1MVsbf8rI--

