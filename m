Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXLPQU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 11:20:28 -0500
Subject: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ojFo9ckH9yDRTE3QmLR/"
Date: Sun, 16 Dec 2007 17:20:19 +0100
Message-Id: <1197822019.4138.2.camel@johannes.berg> (sfid-20071216_162034_993766_A796FCED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ojFo9ckH9yDRTE3QmLR/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just booted into my shiny new #everything and got:

[   40.209739] BUG: sleeping function called from invalid context at kernel=
/rwsem.c:47
[   40.220119] in_atomic():1, irqs_disabled():0
[   40.230514] Call Trace:
[   40.240799] [eec2fc90] [c0009198] show_stack+0x4c/0x1ac (unreliable)
[   40.251247] [eec2fcd0] [c0027a3c] __might_sleep+0xd0/0xf0
[   40.261620] [eec2fce0] [c004c1d0] down_write+0x24/0x64
[   40.271974] [eec2fcf0] [c026347c] led_trigger_register+0xbc/0x118
[   40.282273] [eec2fd10] [f250246c] ieee80211_led_init+0x68/0x160 [mac8021=
1]
[   40.292837] [eec2fd30] [f24eceb0] ieee80211_register_hw+0x200/0x324 [mac=
80211]
[   40.303295] [eec2fd40] [f2523234] b43_probe+0x9a8/0xa04 [b43]
[   40.313766] [eec2fda0] [f20b06e8] ssb_device_probe+0x50/0xac [ssb]
[   40.324152] [eec2fdb0] [c0214518] driver_probe_device+0xb8/0x1e8
[   40.334541] [eec2fdd0] [c021487c] __driver_attach+0xf8/0x124
[   40.344833] [eec2fdf0] [c0213674] bus_for_each_dev+0x58/0x94
[   40.355100] [eec2fe20] [c0214328] driver_attach+0x24/0x34
[   40.365321] [eec2fe30] [c0213af4] bus_add_driver+0x98/0x208
[   40.375513] [eec2fe50] [c0214b44] driver_register+0x58/0xa0
[   40.385771] [eec2fe60] [f20aff58] __ssb_driver_register+0x2c/0x3c [ssb]
[   40.396017] [eec2fe70] [f103e034] b43_init+0x34/0xe8 [b43]
[   40.406253] [eec2fe80] [c00587e4] sys_init_module+0x154/0x176c
[   40.416498] [eec2ff40] [c0012054] ret_from_syscall+0x0/0x38

I haven't found yet where the atomic is entered...

johannes

--=-ojFo9ckH9yDRTE3QmLR/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2VQQqVg1VMiehFYAQJQXw/+ND2curkPRACRiuq8ALH2Zjb5kQuq/lTJ
ewEmyDvYOuAz6qk6umEhlkxgV0kljEo10nz8v8mjmSsOpM7tccDcBJcwIVA6Eg/K
5ykY4zF4FY7/Xeko6Fzq6EexS9yVQ54PhhRPAnCy9kEN2rNXSIJl0U5ruZGkd9y1
HWUIIRp740zvQHj9EC5D0JqU1DxBaJC7XFoQka6mxm+U7hfN/sOHVYr+7ZJQ9q7L
TPDjSRVsjN6A9YjDJMTjN8AU5BuI0XJjLd++824y+GGCZRliC3VtyfCJrnj6rbia
d1iiK5E8wsmT4JN+8dcdr3V1It5w/9WZcO0tc1bxc2v8kP5VDVhbBvxtNvC1YT/K
rzyVRvD9BKocASyJ9Fw1OsMLQG15/z6vU0QXww1yMV8Ol+Mcx23NnzLf01OQMqQh
ST1zW5ju5xSuxOwKJKncEpZ/OqO4kDgeKGzgdFteNo4BEEKet1xj4gueZzgLlj27
vn3uw6W2VAuXz4gKwk4B4Y2pL53nNG4Oy3bDjP5EPqN5NXoMDwHfcGwQGXYADmML
51UMBjAcC6fTzkl9VSt5cBBCN+WJPvFjRlniqucTVvoDBjUOxCsw/4+F2XXlatNa
bQDJ4vUF/fNaxW4U6zktbMU3+4Cp6dN6qly4sju0OZu5pTMN474/wECmAY6a+oEN
VRGqCiT9JmY=
=C1t6
-----END PGP SIGNATURE-----

--=-ojFo9ckH9yDRTE3QmLR/--

