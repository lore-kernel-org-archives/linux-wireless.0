Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXITNuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:50:40 -0400
Subject: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wqfxczl/id/Rl9mtKMRn"
Date: Thu, 20 Sep 2007 14:48:46 +0200
Message-Id: <1190292526.18521.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wqfxczl/id/Rl9mtKMRn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ahrg. So I was complaining about NM not displaying any networks when
that umlaut-network I talked about earlier was present. But all that was
just wrong, the real problem seems to be that NM doesn't work on 64-bit
platforms. Is there any fix for it? It really should be going into a
0.6.5.1 version or something so distributions will ship it.

Same seems to go for wpa_supplicant, Debian is shipping 0.6.0 which only
triggers this in the kernel log:

[  787.877417] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58418) on socket:[14569]
[  787.877763] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58418) on socket:[14569]
[  787.877817] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58418) on socket:[14569]
[  795.264145] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58458) on socket:[14569]
[  795.264243] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58458) on socket:[14569]
[  795.264291] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32=
){t:8b;sz:0} arg(ffb58458) on socket:[14569]

And even the wpa_supplicant git version still seems to parse everything
itself without any 64-bit workarounds as far as I can tell. I keep
building wpa_supplicant for 64-bit just to test... Any chance to finally
get fixes into the stable versions distros are shipping?

Thanks,
johannes

--=-Wqfxczl/id/Rl9mtKMRn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8mwu/ETPhpq3jKURAkkVAKC09n2pquVrw2Ns9PYG5ZOX3rL1wgCdFupQ
T2sVSyyLTzdUxrVq8Clk++U=
=8sk+
-----END PGP SIGNATURE-----

--=-Wqfxczl/id/Rl9mtKMRn--

