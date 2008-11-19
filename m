Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx7.mail.ru ([194.67.23.27]:10315 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYKSTpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 14:45:40 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] wireless: sysfs was displaying different values for level and noise than procfs
Date: Wed, 19 Nov 2008 22:45:21 +0300
Cc: linux-wireless@vger.kernel.org
References: <200811151831.26403.arvidjaar@mail.ru> <1227122019.2196.14.camel@dv>
In-Reply-To: <1227122019.2196.14.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2551147.YJQcuhAbqm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811192245.29487.arvidjaar@mail.ru> (sfid-20081119_204544_575948_4A7516E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2551147.YJQcuhAbqm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 19 November 2008, Pavel Roskin wrote:
> On Sat, 2008-11-15 at 18:31 +0300, Andrey Borzenkov wrote:
> > Subject: [PATCH] wireless: sysfs was displaying different values for le=
vel and noise than procfs
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > /proc/net/wireless asjusts display of signal and noise level depending =
on
> > whether units are percentage or dBm. Use the same format in sysfs. This
> > makes it easy to know unit - below zero is dBm, above zero is percent.
>=20
> I've seen received power up to 3 dBm.  The AP was using an amplifier
> (it's specialized hardware), and it's possible that the card on the
> station side was exaggerating the signal.  However, the data we report
> should not need any guesswork to be interpreted.  It may be parsed by
> userspace software.
>=20

But positive dBm is not even possible to represnt right now. It is u8 and
is displayed as ((s32)level - 256); so it is *always* negative.

> Receiving 1 mW out of 200 mW is not impossible in some antenna
> configurations even with consumer devices.
>=20
> > Before:
> > {pts/1}% cat /sys/class/net/eth1/wireless/level
> > 203
> > {pts/1}% cat /sys/class/net/eth1/wireless/noise
> > 166
>=20
> > +	return sprintf(buf, format_string, (__s32)iw->field -		\
> > +			((iw->qual.updated & IW_QUAL_DBM) ? 0x100 : 0)); \
>=20
> I think non-dBm data should be shown in a special format: "203/255"
> where 255 is the maximal value, and the dBm data should be shown as
> numbers: "-48".  This way, we encourage use of dBm data by making it
> easier to parse.
>=20

Well, I do not have any strong opinion regarding this; I just noticed
discrepancy between procfs and sysfs for what effectively is the same raw
value.

--nextPart2551147.YJQcuhAbqm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkkbNMACgkQR6LMutpd94yJugCeKQE7k510vdyZzMMdUzDOpiV2
ZKwAoIWNCcme5AUPjGqnNNBr/cK2aNQu
=9Ut9
-----END PGP SIGNATURE-----

--nextPart2551147.YJQcuhAbqm--
