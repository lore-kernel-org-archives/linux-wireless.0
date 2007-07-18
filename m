Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991AbXGRPtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 11:49:06 -0400
Subject: libertas warnings & bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u+FrOf/SwT+MAmsJp02j"
Date: Wed, 18 Jul 2007 16:00:37 +0200
Message-Id: <1184767237.11352.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u+FrOf/SwT+MAmsJp02j
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dan,

As promised a few more warnings from libertas from my ppc64 build.

drivers/net/wireless/libertas/cmd.c: In function =E2=80=98wlan_cmd_802_11_s=
et_wep=E2=80=99:
drivers/net/wireless/libertas/cmd.c:189: warning: large integer implicitly =
truncated to unsigned type
drivers/net/wireless/libertas/cmd.c:195: warning: large integer implicitly =
truncated to unsigned type

The code is:
wep->keytype[i] =3D cpu_to_le16(cmd_type_wep_40_bit);

and it's fairly obvious why it warns: keytype[i] is a u8 so always ends
up 0...

drivers/net/wireless/libertas/debugfs.c: In function =E2=80=98libertas_gets=
cantable=E2=80=99:
drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%08llx=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argume=
nt 4 has type =E2=80=98u64=E2=80=99
drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%08llx=
=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, but argume=
nt 4 has type =E2=80=98u64=E2=80=99

probably just needs a cast to unsigned long long.

johannes

--=-u+FrOf/SwT+MAmsJp02j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGnh0E/ETPhpq3jKURAoPjAKCLodcMy4OIqlFmuZZLsJApWy3k+QCfdvJ6
eamuqE/xWmS6pSKO5gSPxgc=
=PhNN
-----END PGP SIGNATURE-----

--=-u+FrOf/SwT+MAmsJp02j--

