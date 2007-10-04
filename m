Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXJDIZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 04:25:41 -0400
Received: from [131.234.198.4]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IdM1Z-0008EC-AW
	for linux-wireless@vger.kernel.org; Thu, 04 Oct 2007 09:25:37 +0100
Subject: [NOTE] driver caveat
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fb9Wi82eRiq6rc8OSH4x"
Date: Thu, 04 Oct 2007 08:50:34 +0200
Message-Id: <1191480634.9898.30.camel@johannes.berg> (sfid-20071004_092549_429001_BADF696D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fb9Wi82eRiq6rc8OSH4x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just a quick note because I ran into it:

[29106.600017] wlan0: No ProbeResp from current AP 00:15:f2:3d:63:97 -
assume out of range
[29106.600030] phy0: Removed STA 00:15:f2:3d:63:97
[29106.720011] mac80211-phy0: failed to remove key (0,
00:15:f2:3d:63:97) from hardware (-19)


This happened during resume, mac80211 was up already but the driver had
not resumed the device yet, so b43 thankfully detected that and didn't
try to access the hardware and returned -ENODEV from set_key().

If you've been experiencing bad behaviour with suspend this may be the
cause, instead of working around in the driver I suggest you implement
proper suspend/resume hooks in mac80211 for drivers to call ;)

johannes

--=-fb9Wi82eRiq6rc8OSH4x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwSNOaVg1VMiehFYAQLA9xAAlmlujEM7GlBdrUgy8fKyiTgCk0ncr+DM
Vp7FMeILfH3ABTJWN5bl/NcqnnRMp6Ae7QUvMj9fQU3d1HIrPw4wEfCxBVmWJrmK
Zi31k3pxE+EU4aLUyyRv8pT3j854amk6Aq/V8ZIn3GEZZNcj44Iw725xsbGnhLKc
HJdU2otol3QyL/uYZQPR5V1KJzN32QuRY5vnJzFc4B/HbmtL52fapAxyvYgurb8X
Lw2Ho+rGzidZisXEMp/9IxvC3AEU4MM4WU6YwLaDFeXD+yW6FrHOP8SMDCkPZ5pI
+YVqp+d5ONvI8EhtaOy+7kzxJ5uo6Qe6H2u8qLY+aQD86D7pd8TadbcdTVzJqAWp
gPT2p7GL15weHzF1z796yALhakJ2F06f3JKWssd9XiDloB6SI3iIrvLwBff8rrre
RGp7FeQTnLmL2GThF2ghbHqLT68/HFyRFCeseJ/dT4fKiJZLVTh3NPZ45QE/MV0O
cMX+hC+EUH7N1+xo8ITXdJmG1zAktZ17N2PNdl4z14TiIQNBJKt6IniclZShK/fd
AEV2xpD9w3Lay2rW9eoKWkahMZ9VmGWuM+TnzuJZhH6KlAmyPSF1Pmmfh+ryHqHN
LJtraTUQlU5g9YPk99W4VTlgWmgbHkZ1bnSKJaiQeH7u6lTY1cXqAFHDjDSV2wxk
hahVY0CpiMY=
=OLGx
-----END PGP SIGNATURE-----

--=-fb9Wi82eRiq6rc8OSH4x--

