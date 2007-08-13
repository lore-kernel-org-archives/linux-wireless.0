Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970149AbXHMIwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:52:18 -0400
Subject: warning in ieee80211 tkip code
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oera1vyB48dytX3+8+l3"
Date: Mon, 13 Aug 2007 08:35:02 +0200
Message-Id: <1186986902.27916.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oera1vyB48dytX3+8+l3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

net/ieee80211/ieee80211_crypt_tkip.c: In function 'michael_mic_hdr':
net/ieee80211/ieee80211_crypt_tkip.c:587: warning: overflow in implicit
constant conversion

The reason is pretty obvious:
hdr[12] =3D qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TID);

where IEEE80211_QCTL_TID is 0xF, so that's made into 0xF00 on BE and
then truncated to 0x00. Not very useful.

This was introduced in this commit:

commit 65b6a2775102cd81e57158ef4b1cb89641f76cfd
Author: Zhu Yi <yi.zhu@intel.com>
Date:   Mon Aug 21 11:32:31 2006 +0800

with the change

-               hdr[12] =3D le16_to_cpu(qoshdr->qos_ctl) & IEEE80211_QCTL_T=
ID;
+               hdr[12] =3D qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TI=
D);

The code before the change looks much saner since you're accessing the
header as bytes...

johannes

--=-oera1vyB48dytX3+8+l3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGv/uW/ETPhpq3jKURAji0AJ0cm/zqeYxRrsL4M1mmIX8yob30YwCgnHI9
HtRUuuKkwkD/gcjCJseLN1k=
=B+mI
-----END PGP SIGNATURE-----

--=-oera1vyB48dytX3+8+l3--

