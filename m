Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZCMKSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:18:53 -0400
Subject: zd1211rw keeps upsetting slab
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: dsd <dsd@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rBItwdSFNcv/ipkMqFWa"
Date: Fri, 13 Mar 2009 11:18:02 +0100
Message-Id: <1236939482.5235.0.camel@johannes.local> (sfid-20090313_111857_507407_64796FCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rBItwdSFNcv/ipkMqFWa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

After I unplug/plug it back in I frequently get:

[  251.409943] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  251.409950] BUG kmalloc-64: Poison overwritten
[  251.409953] ------------------------------------------------------------=
-----------------
[  251.409954]=20
[  251.409958] INFO: 0xffff88006b1ad330-0xffff88006b1ad33f. First byte 0x1 =
instead of 0x6b
[  251.409970] INFO: Allocated in zd_usb_enable_int+0xa5/0x180 [zd1211rw] a=
ge=3D8959 cpu=3D1 pid=3D3528
[  251.409978] INFO: Freed in int_urb_complete+0x92/0x1bc [zd1211rw] age=3D=
3337 cpu=3D0 pid=3D4945
[  251.409982] INFO: Slab 0xffffe20002b82e48 objects=3D30 used=3D29 fp=3D0x=
ffff88006b1ad330 flags=3D0x40000000000000c3
[  251.409985] INFO: Object 0xffff88006b1ad330 @offset=3D816 fp=3D0x(null)
[  251.409986]=20
[  251.409989] Bytes b4 0xffff88006b1ad320:  68 b8 ff ff 00 00 00 00 5a 5a =
5a 5a 5a 5a 5a 5a h=EF=BF=BD=EF=BF=BD=EF=BF=BD....ZZZZZZZZ
[  251.410012]   Object 0xffff88006b1ad330:  01 90 82 96 00 00 80 96 a0 00 =
00 00 ff ff ff 00 ............=EF=BF=BD=EF=BF=BD=EF=BF=BD.
[  251.410034]   Object 0xffff88006b1ad340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  251.410055]   Object 0xffff88006b1ad350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  251.410077]   Object 0xffff88006b1ad360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=EF=BF=BD
[  251.410098]  Redzone 0xffff88006b1ad370:  bb bb bb bb bb bb bb bb       =
                  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD       =20
[  251.410120]  Padding 0xffff88006b1ad3b0:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ       =20
[  251.410142] Pid: 5211, comm: mountnfs Not tainted 2.6.29-rc7-wl-17136-g4=
56d763-dirty #59
[  251.410145] Call Trace:
[  251.410155]  [<ffffffff802d3a26>] print_trailer+0x106/0x160
[  251.410159]  [<ffffffff802d4185>] check_bytes_and_report+0x125/0x180
[  251.410164]  [<ffffffff802d428c>] check_object+0xac/0x270
[  251.410169]  [<ffffffff802f1ff4>] ? alloc_fdtable+0xb4/0x160
[  251.410173]  [<ffffffff802d4ea5>] alloc_debug_processing+0x105/0x1a0
[  251.410177]  [<ffffffff802d62e6>] __slab_alloc+0x96/0x2f0
[  251.410181]  [<ffffffff802f1ff4>] ? alloc_fdtable+0xb4/0x160
[  251.410186]  [<ffffffff802f1ff4>] ? alloc_fdtable+0xb4/0x160
[  251.410190]  [<ffffffff802d7316>] __kmalloc+0x106/0x140
[  251.410194]  [<ffffffff802f1ff4>] alloc_fdtable+0xb4/0x160
[  251.410198]  [<ffffffff802f23df>] dup_fd+0x33f/0x430
[  251.410203]  [<ffffffff80245995>] copy_process+0x905/0xfb0
[  251.410207]  [<ffffffff802460cb>] do_fork+0x8b/0x490
[  251.410213]  [<ffffffff805b6fcb>] ? _spin_unlock_irq+0x2b/0x60
[  251.410218]  [<ffffffff802735c2>] ? trace_hardirqs_on_caller+0x182/0x1e0
[  251.410222]  [<ffffffff8027362d>] ? trace_hardirqs_on+0xd/0x10
[  251.410227]  [<ffffffff8020bd4c>] ? sysret_check+0x27/0x62
[  251.410231]  [<ffffffff8020bd4c>] ? sysret_check+0x27/0x62
[  251.410235]  [<ffffffff80209e63>] sys_clone+0x23/0x30
[  251.410239]  [<ffffffff8020c083>] stub_clone+0x13/0x20
[  251.410243]  [<ffffffff8020bd1b>] ? system_call_fastpath+0x16/0x1b
[  251.410247] FIX kmalloc-64: Restoring 0xffff88006b1ad330-0xffff88006b1ad=
33f=3D0x6b
[  251.410248]=20
[  251.410251] FIX kmalloc-64: Marking all objects used
[  255.500064] wlan1: no IPv6 routers present


--=-rBItwdSFNcv/ipkMqFWa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJujLXAAoJEKVg1VMiehFY0kkP/i3g9z3QRurIlxf8dINWwVjo
a+VYRvjvBtPFAgzH1YdzXWvymIH/lcdnuX6UvIrlWw/v+GT+u0b8mLn5nQzhc7Jk
BuGQQ/xS2N/UiU+Oz7hfQN9aMps6+Ut7XBIYeI7ko1Su0nubgOxB0TUmNLgU/TrJ
Dil1EMys9tO0q9ojyJzyh1PS14VSagsV0Gwl8oPMLI3VDf+fFj9LPxqN7DYfUJRG
ka82HRw+2HcfEnAVIpEcAzaa+7zYl71D6MmrFxTPPcIxzGc3Hv23owbxu3CZDKyJ
eMuw2IVArJO4Xv/vbyiNhsQeb59ffrmYZBRcQ91LRk/k13fyrFfTKE9PMo12T4RV
zAL8LY1WSz9RyWS1U2NSrMwehfzFLngqFLcgK3RkmC/uzrl5+S6gfY1nK7sO+IYl
vUBCsCH7QdqJm+6EjJ5yO55YDr40jGvPj9cGjP69J8xyYwXKted2lEtw0E/WUA4S
W1o3gVIebMVndl6cqUSqhA6y8N8RoYfdBrafvSmCWgW0Nu7NcOgmZzsdPW6rIB8/
HjnrEXJP23V1P/7WSwgFPoZNWrYKA9jZpj+zdlSKxUiM2H/GaJesrVd5Luvp8YFo
1ZgVnuQhybgHGqBx2szEyO+aqU6s/oFo1vE3NBDTdjbkZ2gitBESq0yQZoNLp5cS
YoiEJp3Kp+hAQfVr2UCY
=zxbk
-----END PGP SIGNATURE-----

--=-rBItwdSFNcv/ipkMqFWa--

