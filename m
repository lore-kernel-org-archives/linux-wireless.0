Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbZEOKvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 06:51:09 -0400
Subject: ar9170 deadlock report
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jylmLJDRajTJQD02hKsx"
Date: Fri, 15 May 2009 12:50:42 +0200
Message-Id: <1242384642.5799.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jylmLJDRajTJQD02hKsx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[  328.121951] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  328.122169] [ INFO: possible circular locking dependency detected ]
[  328.122339] 2.6.30-rc5-wl-23310-ge0995c7-dirty #54
[  328.122468] -------------------------------------------------------
[  328.122636] pm-hibernate/7289 is trying to acquire lock:
[  328.122779]  (&(&ar->tx_status_janitor)->work){+.+...}, at: [<c000000000=
07eb14>] .wait_on_work+0x3c/0x194
[  328.123058]=20
[  328.123059] but task is already holding lock:
[  328.123216]  (&ar->mutex){+.+...}, at: [<d0000000015c29a4>] .ar9170_op_s=
top+0x60/0x120 [ar9170usb]
[  328.123482]=20
[  328.123482] which lock already depends on the new lock.
[  328.123484]=20
[  328.123702]=20
[  328.123703] the existing dependency chain (in reverse order) is:
[  328.123903]=20
[  328.123904] -> #1 (&ar->mutex){+.+...}:
[  328.124066]        [<c00000000009ee40>] .check_prev_add+0x3d4/0x5f8
[  328.124242]        [<c00000000009f7b0>] .validate_chain+0x74c/0x930
[  328.128871]        [<c0000000000a01a0>] .__lock_acquire+0x80c/0x8f4
[  328.133531]        [<c0000000000a03d4>] .lock_acquire+0x14c/0x19c
[  328.138139]        [<c0000000004cb0f0>] .mutex_lock_nested+0xa8/0x504
[  328.142769]        [<d0000000015c414c>] .ar9170_tx_status_janitor+0x58/0=
x114 [ar9170usb]


[  328.156599] -> #0 (&(&ar->tx_status_janitor)->work){+.+...}:
[  328.156604]        [<c00000000009eb2c>] .check_prev_add+0xc0/0x5f8
[  328.156609]        [<c00000000009f7b0>] .validate_chain+0x74c/0x930
[  328.156614]        [<c0000000000a01a0>] .__lock_acquire+0x80c/0x8f4
[  328.156618]        [<c0000000000a03d4>] .lock_acquire+0x14c/0x19c
[  328.156623]        [<c00000000007eb54>] .wait_on_work+0x7c/0x194
[  328.156627]        [<c00000000007ed50>] .__cancel_work_timer+0xe4/0x164
[  328.156632]        [<c00000000007ee00>] .cancel_delayed_work_sync+0x30/0=
x48
[  328.156636]        [<d0000000015c29b0>] .ar9170_op_stop+0x6c/0x120 [ar91=
70usb]

Don't cancel a work under a lock that it needs!

johannes

--=-jylmLJDRajTJQD02hKsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDUj+AAoJEODzc/N7+Qmanm4QAKixdjCDYoTweL1B9pr8eKVP
ihmY3xtuugZXNDkYnRpjPdEP8LvNh6CgpM7S3dg0ACu5W9lYhSPnpw22NZzQMIKm
qgNC4hqvsYHpLd9SIexeU+y+yhvEMzPhh2X63Vyy3jloIjBTf3VWNneZpvOz1wQK
tbcp6fQbio55zm5CVUDz2pWLnSqQEj8D4J+aCag3uUDPKbj7Q6YsmRJc8eEdx+eH
MwAeyVKR4TlRcdwUGHkViD1X/ffVZUYC+A0tOuipqHW9PI54foa8iyJxDMXLgG35
VSGPDXW0UVP0JWzFj4G+FK8Wqptkw7drOdaU+7oQjH0R9ivtC/LSZaHyQ9CpLbHG
Zs/8f4FnwbN2/p7tm4sFW4Gc2JpytQ2Amicq/6n1TFCCvGurmIM9+APK/RRv1Xyy
dbbqaf/IWjlYiIJAbBPAfmzfSF8fDMst6HmYuYjHuV90j5NCba1AzsBlpbC57dhj
g2QuH4ey5Xv5SzAntj2RdrwwTH0qMWYKqZE/RYMwAQmLbcYjiutKEXvRi6qz9F1d
F7XfQEFHZmXAEJcH+T1kMo5fkJ8+ZVyWO8FpkaQRi9Dr0K4lcNEUDvQV8e95+bme
+h6LhWgDumcRCTSsB7C6ilRGHHy3xPPVRchGBRuNjMJHjPjj6V0b+UOJAiFaA4A7
kAffSsCSStumZ8FI4awM
=aP6t
-----END PGP SIGNATURE-----

--=-jylmLJDRajTJQD02hKsx--

