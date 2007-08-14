Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbXHOKly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:41:54 -0400
Subject: warnings in iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fqaaUF19d+vTTEZqJOAV"
Date: Wed, 15 Aug 2007 01:10:51 +0200
Message-Id: <1187133051.31200.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fqaaUF19d+vTTEZqJOAV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

  CC [M]  drivers/net/wireless/iwl-base-3945.o
drivers/net/wireless/iwl-base.c: In function =E2=80=98iwl_handle_data_packe=
t_monitor=E2=80=99:
drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in expressi=
on
drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in expressi=
on
  CC [M]  drivers/net/wireless/iwl-3945.o
  CC [M]  drivers/net/wireless/iwl-3945-rs.o
  CC [M]  drivers/net/wireless/iwl-base-4965.o
drivers/net/wireless/iwl-base.c:2169: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2170: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2171: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2172: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2173: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2179: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2181: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2183: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2185: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c:2186: warning: large integer implicitly tru=
ncated to unsigned type
drivers/net/wireless/iwl-base.c: In function =E2=80=98iwl_handle_data_packe=
t_monitor=E2=80=99:
drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in expressi=
on
drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in expressi=
on


I suspect most of them are caused by endianness bugs.
This for example:

	le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;

looks totally bogus unless you somehow do macro magic to define the
RX_RES_PHY...MASK in little endian...

Maybe it's time for you to get a cross compiler or better yet buy a
big-endian machine and actually test things on that? :)

johannes

--=-fqaaUF19d+vTTEZqJOAV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwjZ7/ETPhpq3jKURAt5uAJ0fpqL6Wf2aRIUxs7rxsx1wIPg24ACfS1oH
fRrqVq0Rjdfn7F39/ByVryQ=
=tX3v
-----END PGP SIGNATURE-----

--=-fqaaUF19d+vTTEZqJOAV--

