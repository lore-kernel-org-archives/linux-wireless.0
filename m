Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYDCKJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:09:51 -0400
Subject: iwlwifi/rfkill cause iwlwifi problem and slab corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WWkt+dCoRhE/rQVJcqUn"
Date: Wed, 02 Apr 2008 16:19:36 +0200
Message-Id: <1207145976.3957.7.camel@johannes.berg> (sfid-20080403_110957_444971_D0310253)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WWkt+dCoRhE/rQVJcqUn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

When I tried to rmmod iwl4965, iwlcore and mac80211, I got:

[  176.440255] iwl4965: No space for Tx
[  176.440262] iwl4965: Error sending REPLY_CARD_STATE_CMD: enqueue_hcmd fa=
iled: -28

I cannot explain this.

Also, later, this happened came out of the kernel:

[  173.589186] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  173.589209] BUG kmalloc-2048: Poison overwritten
[  173.589216] ------------------------------------------------------------=
-----------------
[  173.589219]=20
[  173.589231] INFO: 0xc000000118fc8b23-0xc000000118fc8b23. First byte 0x6a=
 instead of 0x6b
[  173.589240] INFO: Allocated in .rfkill_allocate+0x40/0xf4 [rfkill] age=
=3D2367858 cpu=3D2 pid=3D1125
[  173.589273] INFO: Freed in .rfkill_release+0x24/0x4c [rfkill] age=3D5096=
91 cpu=3D0 pid=3D6294
[  173.589290] INFO: Slab 0xc000000008c61b00 used=3D14 fp=3D0xc000000118fc8=
848 flags=3D0x40c3
[  173.589297] INFO: Object 0xc000000118fc8848 @offset=3D2120 fp=3D0x000000=
0000000000
[  173.589300]=20
[  173.589305] Bytes b4 0xc000000118fc8838:  00 00 00 00 ff fb 93 eb 5a 5a =
5a 5a 5a 5a 5a 5a ....XX.XZZZZZZZZ
[  173.589433]   Object 0xc000000118fc8848:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.589561]   Object 0xc000000118fc8858:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.589689]   Object 0xc000000118fc8868:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.589818]   Object 0xc000000118fc8878:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.589949]   Object 0xc000000118fc8888:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.590072]   Object 0xc000000118fc8898:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.590133]   Object 0xc000000118fc88a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.590133]   Object 0xc000000118fc88b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  173.590133]  Redzone 0xc000000118fc9048:  bb bb bb bb bb bb bb bb       =
                  XXXXXXXX       =20
[  173.590133]  Padding 0xc000000118fc9088:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ
[  173.590133] Call Trace:
[  173.590133] [c000000115c3f290] [c00000000000fa0c] .show_stack+0x78/0x1b0=
 (unreliable)
[  173.590133] [c000000115c3f350] [c0000000003e154c] .dump_stack+0x20/0x34
[  173.590133] [c000000115c3f3d0] [c0000000000d6aa0] .print_trailer+0x1a4/0=
x1d0
[  173.590133] [c000000115c3f470] [c0000000000d6bd8] .check_bytes_and_repor=
t+0x10c/0x17c
[  173.590133] [c000000115c3f530] [c0000000000d6da8] .check_object+0xfc/0x2=
6c=20
[  173.590133] [c000000115c3f5e0] [c0000000000d8ddc] .__slab_alloc+0x600/0x=
744  =20
[  173.590133] [c000000115c3f6b0] [c0000000000d8fc0] .kmem_cache_alloc+0xa0=
/0x12c
[  173.590133] [c000000115c3f760] [c000000000348a10] .__scm_send+0xd8/0x330
[  173.590133] [c000000115c3f820] [c0000000003ca484] .unix_stream_sendmsg+0=
xd8/0x46c
[  173.590133] [c000000115c3f950] [c00000000033baac] .sock_sendmsg+0xc4/0xf=
c=20
[  173.590133] [c000000115c3fb50] [c00000000033bce0] .sys_sendmsg+0x1fc/0x2=
94
[  173.590133] [c000000115c3fd80] [c000000000361ddc] .compat_sys_socketcall=
+0x1f4/0x238
[  173.590133] [c000000115c3fe30] [c000000000007754] syscall_exit+0x0/0x40
[  173.590133] FIX kmalloc-2048: Restoring 0xc000000118fc8b23-0xc000000118f=
c8b23=3D0x6b
[  173.590133]=20
[  173.590133] FIX kmalloc-2048: Marking all objects used

And, uh, don't ask me why my time seems to be going backwards.

johannes

--=-WWkt+dCoRhE/rQVJcqUn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/OV96Vg1VMiehFYAQIcsRAAg2og4URYyjsKUtZtQQLjzY1njwM7thfF
Z2rXwinkEnFv2w8AYhk8KLlFEnEVw6Tp5yjL3saGSF2GuPHiyUWY3yG5wNgzKEog
14rxo22gpii2rtCykOR+H7GjwooZumZqkFep7J5CS6z5ulEILlLBQMIE6m7auwMa
t10j8dqP9kWAp+R2pWhmjPDTlKYQUTrr94Fa1nTITZpsCAVLhNS9LptyfIGQYYj6
Gh08AmOC1u0q3iXf4Gxox58pjPNAMS+/5vqgV4HRcHDMYrkzUA0zn9KpPEGO4JRg
KQWJoCmDEDstsSdljdRMx7Zitrdr/tlwGBzksP655ehyKSQJ7k22ER35PmZYy0e7
v2TDkhJJlYceAddg63ys9cEH8y39ziGDHEzsdRw8tKuSA0R6ar0kksh+Wq8qHMCY
FXejHClKcyxijrojqXWlZHMSEpjSkl/XUuX6INAfkGPDYoJjQeicyQCM+YO1en/S
amb8pNRIjzUhEcK0VbCdwd9yx+CcZs97R+Sw9v3136ucmn3HXCl1ZwPVIJhQ/yLF
Ri1ZugjgUmE6yruTNogaivkLQPmo1Q4bAvK2E4+EvwJ5Kzv46sFil3vrfCSocneZ
NNWXCsiElKna0P/aMmccg0q7OV89Dyhb1CMrPca4tlN7WTtrLytOlwJrDjmesCBR
Rp7FJsaN3Pw=
=Wg03
-----END PGP SIGNATURE-----

--=-WWkt+dCoRhE/rQVJcqUn--

