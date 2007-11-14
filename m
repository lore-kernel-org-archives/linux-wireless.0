Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:57360 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbXKNQLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:11:14 -0500
Date: Wed, 14 Nov 2007 10:59:58 -0500
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Henning Rogge <rogge@fgan.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Virtual wireless network card for mac80211
Message-ID: <20071114155957.GB25925@drd1813.lan> (sfid-20071114_161119_183006_7F949B0B)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <200711141316.50393.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
In-Reply-To: <200711141316.50393.rogge@fgan.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2007 at 01:16:50PM +0100, Henning Rogge wrote:
> Hello,
>=20
> I'm looking for a way to simulate a ieee802.11 card on a linux system. Is=
=20
> there an equivalent for tun/tap for the mac80211 layer, so I can just sen=
d=20
> the communication with a wireless device back to userspace (and data from=
=20
> userspace into the wireless stack) ?

Depending what you're trying to do, I did patches for tuntap that went
in a year or two ago that allow you to set the link type and write
radiotap/80211 frames.  Kismet-newcore (it's in branches in svn if you
care) uses this to replicate mangled frames back out to other userspace
programs.

http://svn.kismetwireless.net/code/branch/kismet-newcore/dumpfile_tuntap.cc

If you want something that actually responds to iw* ioctls, etc, then
this probably isn't what you want however.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"A baby seal walks into a club..."

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHOxt917KIInOLvbERAkn6AKCPH5yXGXHpLuDxP1CM6hzW5pNStwCfVZkS
BTU4GBO7oZxEDEGd5SDy/rg=
=gkfK
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
