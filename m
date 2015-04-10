Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54735 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbDJFrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 01:47:48 -0400
Received: from [192.168.110.3] ([77.87.49.20]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0Lv9lm-1ZNvqF27aU-010PlX for
 <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 07:47:45 +0200
Message-ID: <55276400.3020402@gmx.de> (sfid-20150410_074814_032891_A9EE7BE5)
Date: Fri, 10 Apr 2015 07:47:44 +0200
From: Sven-Ola Tuecke <sven-ola@gmx.de>
MIME-Version: 1.0
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
References: <5523273F.4060803@candelatech.com>	<CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>	<CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com>	<552406E4.50600@candelatech.com>	<55241567.3010703@candelatech.com> <21796.40851.132919.363957@gargle.gargle.HOWL>
In-Reply-To: <21796.40851.132919.363957@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="csN0ER4TrUnlOR4mmk2mXfnRBgCVb7t7J"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--csN0ER4TrUnlOR4mmk2mXfnRBgCVb7t7J
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 08.04.2015 um 05:25 schrieb Sujith Manoharan:
> TSF would jump around since the HW would sync with the
> received beacons and this will happen in both IBSS and station
> mode. Hence the limitation, but I think OpenWrt has a one-liner
> to remove this restriction...
TSF in larger IBSS meshes (> 100 nodes) may be jumpy anyway, e.g. it
requires only one (misonfigured / buggy) node to introduce a TSF >
0xffffffff00000000 once. Because all IBSS nodes will take over the
largest TSF unverified from any neighbour, you end up by having TSF
bouncing around 64 bit overflow until you switch off the mesh
completely. We had this situation a couple of years here in Berlin.
Moment, let's have a look:

-> Frame 2: 104 bytes on wire (832 bits), 104 bytes captured (832 bits)
-> Radiotap Header v0, Length 18
-> IEEE 802.11 Beacon frame, Flags: ........
+> IEEE 802.11 wireless LAN management frame
   +> Fixed parameters (12 bytes)
      +> Timestamp: 0x0008004c7ddf6095

Seems the familiar 0xffffffffxxxxxxxx TSF is gone for some reason. In
practise, this does not hurt too much, you get a second downtime every
hour or so on turnaround.

// Sven-Ola



--csN0ER4TrUnlOR4mmk2mXfnRBgCVb7t7J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUnZAAACgkQrxcU0RkD0LLAOwCgy2lg+3qgpHS2gBQfzOs1zrzo
xKkAnRJGwWPI6hvM4MW8iGAXLZzInSPx
=Hnhh
-----END PGP SIGNATURE-----

--csN0ER4TrUnlOR4mmk2mXfnRBgCVb7t7J--
