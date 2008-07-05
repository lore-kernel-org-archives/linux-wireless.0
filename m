Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYGETh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 15:37:27 -0400
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error
	in	adhoc/master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807052137.59412.IvDoorn@gmail.com> (sfid-20080705_213128_827852_921377F3)
References: <200807051511.57995.IvDoorn@gmail.com>
	 <200807052126.16913.IvDoorn@gmail.com>
	 <1215285776.6848.21.camel@johannes.berg>
	 <200807052137.59412.IvDoorn@gmail.com>
	 (sfid-20080705_213128_827852_921377F3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t/8x4GohT/agGFo936By"
Date: Sat, 05 Jul 2008 21:37:09 +0200
Message-Id: <1215286630.6848.24.camel@johannes.berg> (sfid-20080705_213730_267938_B9102F48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t/8x4GohT/agGFo936By
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> That problem is only in rt2400pci and rt2500pci who raise the beacon inte=
rrupt,
> all other drivers have the template and auto sequence numbers.

Ok.

> But no sequence numbers for the beacons, I think that will definately cau=
se
> problems for those 2 drivers.
>=20
> But the function ieee80211_include_sequence() is being called from within=
 the
> ieee80211_beacon_get() function. Only for the Mesh it doesn't seem to be =
called.

Well it's not called from where the IBSS beacon is set either, and the
IBSS beacon isn't generated every time anyway. So I'm confused now. Do
rt2{4,5}00pci not support IBSS?

johannes

--=-t/8x4GohT/agGFo936By
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIb81iAAoJEKVg1VMiehFYoz0QAK8n/coXkBwP8X+tCbtitkt/
7bLNNBhm4TJ8mJYXedyi5txloZwOgwRKxgjcfpR4vMpx2A84WWnc/ihzE/d8DBly
BRf9TqM2SKimbgNmkjZURkQdplXUS7ts0z2sRbgquug5XTX+X3mU1CQaehSl6MHg
LMtQFu6233A44097puZvNZvBoTQryWtO+OvW46+JMbb1x+WOWiePslKn+/44rzyk
IaepkL1qUjFxwudiZoA9hJPePogFsuNPrkS0EjtWC+B7azuq/0J/A8ytibhrxiBP
aJgCOF+cVhqwCwmy9fSYNPb4ki0sqGgLrsY1homBI7oeinhgbPEyET/cgOznXBLe
bLTh2O7RaQQSIvmTgR+O00rvDosHiyDNF4IETWGW2D/Y7W59nEoMm8jRkQC3OA6Q
3HBHQMdHerc6cck13v2AHGweTfo4k55EJklpeIvzs/UPpNrEd1EkEfzguyUi8IWI
7GAOs8fw6k5H9O2cMbFKbuSXSv+AZqtNZweGGAl0z6so16R+Zk+98mi4sMhlYZp6
mTu6KUZkkWdhf3Ji6vUE6PcZ8wYp50fxvzRR43Csq1ZtAe4nXcdA5qn0bOaQKsWW
mXU3HU9/sGVTOV+qwGWnO5l9D3fRYS8cEA7kDwnLFl+T6Rc88G9OxqG40aaqsbgw
/Egf2VyiSNk9pSHB6N5g
=33t8
-----END PGP SIGNATURE-----

--=-t/8x4GohT/agGFo936By--

