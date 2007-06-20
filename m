Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXFTLSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:18:38 -0400
Subject: driver bugs with changed mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YpFdMJiSn4UinAcrjhDv"
Date: Wed, 20 Jun 2007 12:05:38 +0200
Message-Id: <1182333938.3714.53.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YpFdMJiSn4UinAcrjhDv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just looking through some bcm43xx code and noticed that when you
set a different mac address for some interface, then it is stored to
wl->mac_addr but this is only ever used in
bcm43xx_write_mac_bssid_templates and not in bcm43xx_wireless_core_init.

iwlwifi on the other hand completely ignores the mac address after
printing it out.

Also in bcm43xx, when the interface is removed again wl->mac_addr isn't
set to NULL when the interface that the MAC belonged to is deleted, so
that the mac address stays programmed on the card and we continue to ACK
packets for that MAC address.

In zd1211, we start with hwaddr =3D dev->wiphy->perm_addr which isn't
correct either, for a pure monitor mode we want to start with a zero mac
addr to avoid acking packets. Also, zd1211rw will end up having a NULL
hwaddr when a monitor interface is added, most likely segfaulting in
zd_write_mac_addr then.

The NULL mac address will also happen to rtl818x and possibly p54 (at
least when that gets monitor mode support)

Whew. So much for our little mac address audit.

johannes

--=-YpFdMJiSn4UinAcrjhDv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGePvy/ETPhpq3jKURApXpAJ4rdjC6972gHlMBaAW5pmHa1lJE3ACfR3UX
1TSMqNxEW55j//EU+3wRKHQ=
=/6ZH
-----END PGP SIGNATURE-----

--=-YpFdMJiSn4UinAcrjhDv--

