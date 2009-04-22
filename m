Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZDVUQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 16:16:32 -0400
Subject: powersaving when interface is up but not associated
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8GBKLmzuVSDfQKM1D85x"
Date: Wed, 22 Apr 2009 22:15:56 +0200
Message-Id: <1240431356.30082.18.camel@johannes.local> (sfid-20090422_221645_304467_070F1B61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8GBKLmzuVSDfQKM1D85x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

Just had this idea -- when our networking interfaces are UP, but not
actually doing anything, the RF chains consume power. This is, often,
the default state, since you'll have your wifi on due to NM wanting to
find APs, but not associated, for example when on the road. Sure, you
can manually turn it off, but...

However, it doesn't seem necessary. When we are not associated to an AP,
and there are no extra interfaces in mac80211 active like monitor
interfaces, it seems that we could very well turn off the radio while
not scanning. It would be entirely trivial for mac80211 to do this,
probably a 20 line patch or so (need some bookkeeping about why radio is
disabled so it's not just four lines).

Thoughts?

johannes

--=-8GBKLmzuVSDfQKM1D85x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ73r6AAoJEKVg1VMiehFY4fMP/3sfTi2lvwiiPCFtit7WQldX
pGxc60OBTnDQMMTPUtNQe3La2NxVZP5Q54C3aj+R9R7hNMxVKqTmEI4+5um5bhB5
M6fP0IW2kYogCJaSXKx52eSHKfy9UuUIZjJsFuhHUq6ehh1GbkjFxJ3c2AoHPU3s
OczAs1JjYUjgCxadL4u9aMKBY5RhEMbt/x/iZvVUusblq1IFmT/srDp8760CNpdN
v0SQGo2lz9MHNC9E9XLNAC/dwaag2y7G7+/qWx5TrX6la1/q5zgjzh91V2APGVv8
Hv4TbxJnysi54nuFDGVnUvJmqDI4bvaXDFn8DYAThbLL8HH75z+lnKHCbbf58z2v
uoSmtCHkAKT2CZuuq/KemhS0ojSSZOtlkNAjbGirgXSTfLh8O/xXQihD/okVna9R
b1TLcTrYslthH8vWp6kQQYthzd1zjIBPIYlxM9RTIi87k41taSUp95hbaTVC1awI
+lfY8b23I22Xkc89t8C5UombXaGpbSVhANZMXvl1pYHbNjftnkSw4vNUeH8Ag3fX
nSSnRU6NBeWPQLKg862sNe8Ziw20Ms2zFZGirhbro3AW4vQVEGtCPsNCK2+z4uME
YwKA0NCKhOxw7g3eS8rafe9tx0/WN2D53+eAhKAwKgsNx8bdlJmzpoPNb7itMi5c
vDPOn6MCSuPyoLkaqC3x
=k2bY
-----END PGP SIGNATURE-----

--=-8GBKLmzuVSDfQKM1D85x--

