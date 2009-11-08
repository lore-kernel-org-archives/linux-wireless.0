Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:60003 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZKHOmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:42:17 -0500
Message-ID: <4AF6D845.9000600@web.de>
Date: Sun, 08 Nov 2009 15:40:05 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>	 <4AF6CC02.8080204@web.de> <1257688870.29454.52.camel@johannes.local>
In-Reply-To: <1257688870.29454.52.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9FD9F5550BAB7CE27660EC52"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9FD9F5550BAB7CE27660EC52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Sun, 2009-11-08 at 14:47 +0100, Jan Kiszka wrote:
>=20
>>> IMHO AP mode should not be enabled until it's confirmed that power
>>> save mode works properly.
>=20
> Agreed.
>=20
>> How common is the combination of powersaving and mcast in practice?
>=20
> Uh, it's nothing to do with the combination. If you don't support prope=
r
> mcast buffering, any powersaving client will be in big trouble due to
> ARP/NDP etc.
>=20
> Any device that supports powersaving is thus impacted. That ranges from=

> desktops and laptops down to your cellphone.

OK, confirmed with my cellphone: If I enable powersaving, it actually
has troubles replying on arp requests.

I kept it disabled as my previous AP setup (rt2500usb on a special
2.6.21 kernel) used to fail with powersaving as well. So the good news
is that one can perfectly run with such a setup for multiple years, and
I will continue to do so with ar9170 for now - but I also see your point.=


>=20
>> Given that quite a few useful scenarios are blocked right now (unless
>> you know what to patch), I would at least vote for a config option or =
a
>> module parameter. That gives a chance to warn the user about this
>> limitation without locking out people that are no hackers.
>=20
> Given that we want to have everything support powersave on the client
> side, I have to disagree -- supporting something that will be
> troublesome for many clients will just make it look bad.

OK, carrying that patch locally will not kill me. Hmm, is there a way in
the 802.11 to tell a client to not apply powersaving in this cell - just
in case?

And what can be done to resolve this issue for real? Does the legacy
otus driver work fine in this regard? Or are we lacking more information
about the hardware?

Jan


--------------enig9FD9F5550BAB7CE27660EC52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkr22EwACgkQitSsb3rl5xQZYwCgtA1AsCwiZlUIX11FxLKq5MjX
2cUAnjmlRI56VbtDwYrftjHr7tulDdg1
=A/QS
-----END PGP SIGNATURE-----

--------------enig9FD9F5550BAB7CE27660EC52--
