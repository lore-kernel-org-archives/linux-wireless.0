Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbXCFNKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 08:10:34 -0500
Subject: zd1211rw problems
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HIA6u0iGBuSKUBcpTnnc"
Date: Tue, 06 Mar 2007 02:01:46 +0100
Message-Id: <1173142906.15891.71.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HIA6u0iGBuSKUBcpTnnc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've been testing zd1211rw (not the mac80211 version) a bit on my
powermac because I wanted to test AP mode for bcm43xx and use my zd1211
device as a client... Thing is, I have a few problems with it already...

For one, I get lots of warnings like this (when running in monitor mode)

[ 3354.472204] drivers/net/wireless/zd1211rw/zd_chip.c:1467 ASSERT r >=3D 0=
 VIOLATED!
[ 3354.472212] Call Trace:
[ 3354.472222] [C000000001BCF6D0] [C00000000000F330] .show_stack+0x68/0x1b0=
 (unreliable)
[ 3354.472247] [C000000001BCF770] [D000000000444F04] .zd_rx_qual_percent+0x=
164/0x200 [zd1211rw]
[ 3354.472281] [C000000001BCF7F0] [D0000000004470CC] .do_rx+0x198/0x5c0 [zd=
1211rw]
[ 3354.472307] [C000000001BCF8D0] [C000000000049978] .tasklet_action+0xd0/0=
x188
[ 3354.472323] [C000000001BCF970] [C0000000000495C4] .__do_softirq+0xa8/0x1=
64

Secondly, also in monitor mode, I see a huge number of invalid packets.
I can't believe there's that much noise here, and even then I shouldn't
be seeing these packets. And I mean a HUGE number, in just 10 seconds I
captured around 3700 packets! I'm pretty sure that the CRC and/or PLCP
check isn't enabled since I'm seeing things like

Beacon frame,SN=3D2219,FN=3D0,BI=3D100, SSID: "p\025Echel"

while the AP is actually named "puschel" (don't ask me, just someone in
my vicinity). I hope it doesn't happen in a normal (managed) mode.

johannes

--=-HIA6u0iGBuSKUBcpTnnc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7L16/ETPhpq3jKURArg7AJ9ogLlimHoRPsAhGSI4/VCz5Ur0oQCbBjgo
XnyONrCQc4uQKzlZwMfit1g=
=Dmhj
-----END PGP SIGNATURE-----

--=-HIA6u0iGBuSKUBcpTnnc--

