Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYKXKfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 05:35:22 -0500
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS
	clients (wireless-testing).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com> (sfid-20081124_084441_757639_7088C3E6)
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 (sfid-20081124_084441_757639_7088C3E6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-23tgWeVHO4zSPm0DUYWO"
Date: Mon, 24 Nov 2008 11:35:18 +0100
Message-Id: <1227522918.3599.63.camel@johannes.berg> (sfid-20081124_113544_258307_786A0178)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-23tgWeVHO4zSPm0DUYWO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 09:44 +0200, Rami Rosen wrote:
> This patch enables master mode support in zd1211rw driver and enables
> it to support the PS challenged mode when used in master mode.
>=20
> It adds this functionality in the zd1211rw driver by adding support to
> master mode (NL80211_IFTYPE_AP) in zd_op_add_interface() and in
> zd_mac_alloc_hw() methods
> of drivers/net/wireless/zd_mac.c.
>=20
> In addition, the new boolean member of wiphy struct, ap_ps_challenged,
> is initialized to true in zd_mac_alloc_hw().

This is all fine, but I'm starting to wonder why we're doing this at
all. Have we actually determined that zd1211 cannot buffer mcast/bcast
frames at all? Might it be worth asking around in Zydas/Atheros?

johannes

--=-23tgWeVHO4zSPm0DUYWO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKoNjAAoJEKVg1VMiehFYgN4QALgreKcSGq0024D/11Mq4m5T
/smZfbb+OSgbdgvrink7Sr3FsN1nPhLiGMLRUboyFGFamin5x7xI8nfVda4FLbPi
9HT1kjgE/kuyV547hE/4jM9YjdCubUGpY2CHtmF5fR4TSZ5rbU/N2g23A1jNVP+/
5ZfgOrAp0TSgRoKi2Wjr6/n2QazKzWvYMEtqVFJYaYYto4mu0ujFBcP5n5S/qkOS
4u37n6vLDt+n4zG8cTnaSZL4ECk6VAs+xVUky63ukGfc75n7zOaWsarUXts3uWox
cPbBqH53e4wzA/g4KIu/2VkkUnawFJ0goi0rjNZDFW5P1ra3R9YQHTMIH7qlss2H
s0wre08fG0XAouY4zflUXs+NajI8J3WIT6GM/vrkZAO+TzHTnOa43xlzvHWaYgZ4
Ylol/X1JW+8LE5oH9hhRVODPeQ7eK8L25gP9vbEyiaQ+lJEyHH8GqQHDOq8e+0UI
FL4z8gFBq3EDX1p+qaWRkvQxkKFDoEBc7xLIgFCaJq1+KM7DNcLG5LPIcyvi8lRF
yspPQ1556FqeLje/T9Po3/psceS49vSxFUNLvPLTJOo91R3QpvD7KLA1gHVLECHo
+9sC3/EHNrV5dk+sYPU//NckER1atdYCo2jEgJ46OLc3KeAMFVCEjAot8E45JK7N
MIxo55GP3npB5An9Ivox
=v4CG
-----END PGP SIGNATURE-----

--=-23tgWeVHO4zSPm0DUYWO--

