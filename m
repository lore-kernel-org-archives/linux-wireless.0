Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbXC1JLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:39 -0400
Subject: BUG in bcm43xx/mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>, Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tP86D55+gETIMsHKn2fq"
Date: Tue, 27 Mar 2007 17:33:38 +0200
Message-Id: <1175009618.5710.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tP86D55+gETIMsHKn2fq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I just rmmod'ed bcm43xx-mac80211, rc80211_simple and mac80211 all at
once while wpa supplicant was running...

[17285.438218] BUG: sleeping function called from invalid context at kernel=
/mutex.c:86
[17285.438226] in_atomic():1, irqs_disabled():0
[17285.438231] Call Trace:
[17285.438236] [EF7DDC70] [C0008D6C] show_stack+0x3c/0x194 (unreliable)
[17285.438256] [EF7DDCA0] [C0025C00] __might_sleep+0xd4/0xe8
[17285.438273] [EF7DDCB0] [C02CF1C8] mutex_lock+0x24/0x3c
[17285.438289] [EF7DDCD0] [F2750960] bcm43xx_dev_set_key+0xe8/0x3e8 [bcm43x=
x_mac80211]
[17285.438331] [EF7DDD10] [F2722004] sta_info_free+0xe4/0x1a4 [mac80211]
[17285.438385] [EF7DDD50] [F2722140] sta_info_flush+0x7c/0xb4 [mac80211]
[17285.438407] [EF7DDD70] [F272B538] ieee80211_if_reinit+0x130/0x2dc [mac80=
211]
[17285.438432] [EF7DDDA0] [C02366E0] unregister_netdevice+0x120/0x268
[17285.438446] [EF7DDDC0] [F272AE2C] __ieee80211_if_del+0x30/0x44 [mac80211=
]
[17285.438469] [EF7DDDE0] [F2719F1C] ieee80211_unregister_hw+0x78/0x264 [ma=
c80211]
[17285.438491] [EF7DDE10] [F274FF44] bcm43xx_remove+0xa4/0xb0 [bcm43xx_mac8=
0211]
[17285.438510] [EF7DDE30] [F222B6A4] ssb_device_remove+0x38/0x58 [ssb]
[17285.438548] [EF7DDE40] [C01D53A8] __device_release_driver+0x88/0xc8
[17285.438561] [EF7DDE50] [C01D5B68] driver_detach+0x110/0x140
[17285.438570] [EF7DDE70] [C01D4E3C] bus_remove_driver+0x8c/0xc8
[17285.438580] [EF7DDE90] [C01D5BF0] driver_unregister+0x18/0x34
[17285.438589] [EF7DDEB0] [F222B0F8] ssb_driver_unregister+0x14/0x24 [ssb]
[17285.438604] [EF7DDEC0] [F2766530] bcm43xx_exit+0x18/0x3678 [bcm43xx_mac8=
0211]
[17285.438623] [EF7DDED0] [C004CAC0] sys_delete_module+0x1ac/0x210
[17285.438633] [EF7DDF40] [C0010BD8] ret_from_syscall+0x0/0x38
[17285.438646] --- Exception: c01 at 0xff6afd8
[17285.438661]     LR =3D 0x10001214


--=-tP86D55+gETIMsHKn2fq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCTlR/ETPhpq3jKURAom2AKCgiWNnt2cnmPESjHpG0uqtccyeZACfZOPY
9Ln+75mWthIKOaRqsQ6xIEQ=
=t0/z
-----END PGP SIGNATURE-----

--=-tP86D55+gETIMsHKn2fq--

