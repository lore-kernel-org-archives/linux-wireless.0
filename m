Return-path: <wireless-bounces@tuxdriver.com>
Received: from annwn14.rutgers.edu (smtp.rutgers.edu [128.6.72.243])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V1D4O8001807	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 20:13:29 -0500
Date: Tue, 30 Jan 2007 20:12:19 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: Re: SIOCGIWRANGE and dscape
In-reply-to: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
Sender: wireless-bounces@tuxdriver.com
To: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <200701302012.23302.flamingice@sourmilk.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============1334398120=="
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============1334398120==
Content-Type: multipart/signed; boundary="nextPart1860735.jKj8MEjEr6";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1860735.jKj8MEjEr6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 January 2007 19:36, Jon Smirl wrote:
> Looking in ieee80211_ioctl.c the implementation is in
> ieee80211_ioctl_giwrange().
>
> I can work on this, but how should it be done? There is no callout
> from the stack to the drivers for this IOCTL. It also doesn't make
> sense that each driver have the code to build the entire channel
> lists. But you do need to know whether the driver is b/g or a/b/g. How
> does the driver indicate which channel domain it is in, Japan/US/EU?
>
=46ixing up giwrange is currently on my d80211 blockers todo list since it =
is=20
part of fixing wireless statistics reporting in d80211. Helper functions fo=
r=20
filling the channel lists is also somewhere on the todo list, though it isn=
't=20
on the blocker list. The driver currently has no way to indicate what=20
regulatory domain the hardware has stored in eeprom, and d80211 just assume=
s=20
=46CC. (after all, d80211 isn't merge ready yet ;) Yes, basic driver regula=
tory=20
domain support is on my blocker todo list.

Listing rates and channels in giwrange should be easy - find the current mo=
de,=20
and iterate through the list of channels and rates in there. Ignore any=20
channels which are not enabled. Count up all the enabled channels and stick=
=20
it in num_channels and num_frequency. I could probably just copy the code=20
from the adm8211 (wireless-2.6 version) giwrange handler and modify it to=20
traverse lists instead of arrays. Feel free to hack and submit a patch thou=
gh=20
=2D it's not like I don't have enough things on my todo list. :)

=2DMichael Wu

--nextPart1860735.jKj8MEjEr6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFv+z3T3Oqt9AH4aERAkOcAJ4sr5gUotFBC2CZveC2NEdXHwg/xACg17P6
dtdTS46y7+Uc8t7om098bsA=
=RXD0
-----END PGP SIGNATURE-----

--nextPart1860735.jKj8MEjEr6--

--===============1334398120==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1334398120==--
