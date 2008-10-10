Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYJJJPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:15:03 -0400
Subject: ath9k rate control API abuse
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6SAYOCln2mk1HZOuvIdv"
Date: Fri, 10 Oct 2008 11:10:34 +0200
Message-Id: <1223629834.3930.67.camel@johannes.berg> (sfid-20081010_111517_036937_322F0165)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6SAYOCln2mk1HZOuvIdv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I decided to review ath9k as well wrt. the RC algorithm (Intel stuff
coming later). It doesn't exactly have the same deficiencies as the
Intel drivers, but it's still very very very fragile.

For example, you can make it crash with a double-free like this:

# iwconfig wlan0 frag 300

[  206.647389] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  206.647791] BUG kmalloc-96: Object already free
[  206.648006] ------------------------------------------------------------=
-----------------
[  206.648009]=20
[  206.648504] INFO: Allocated in .ath_get_rate+0xa8/0x9d0 [ath9k] age=3D0 =
cpu=3D1 pid=3D4447
[  206.648893] INFO: Freed in .ath_tx_status+0x368/0x3b4 [ath9k] age=3D0 cp=
u=3D0 pid=3D0
[  206.649238] INFO: Slab 0xc00000001c5f49c0 objects=3D24 used=3D10 fp=3D0x=
c00000020fe1a9d8 flags=3D0x00c3
[  206.649643] INFO: Object 0xc00000020fe1a9d8 @offset=3D2520 fp=3D0xc00000=
020fe1aa80
[  206.649646]=20
[  206.650052] Bytes b4 0xc00000020fe1a9c8:  00 00 00 00 ff fd f3 45 5a 5a =
5a 5a 5a 5a 5a 5a ....=EF=BF=BD=EF=BF=BD=EF=BF=BDEZZZZZZZZ
[  206.650693]   Object 0xc00000020fe1a9d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  206.651333]   Object 0xc00000020fe1a9e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  206.651972]   Object 0xc00000020fe1a9f8:  3c 13 f2 77 00 00 00 8f 00 2a =
00 00 00 01 00 28 <.=EF=BF=BDw.....*.....(
[  206.652612]   Object 0xc00000020fe1aa08:  26 80 27 26 80 00 00 00 00 00 =
00 00 00 00 00 00 &.'&............
[  206.653252]   Object 0xc00000020fe1aa18:  2a 80 26 27 80 80 80 80 80 80 =
80 80 00 00 00 01 *.&'............
[  206.653892]   Object 0xc00000020fe1aa28:  00 00 00 00 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b a5 ....kkkkkkkkkkk=EF=BF=BD
[  206.654531]  Redzone 0xc00000020fe1aa38:  bb bb bb bb bb bb bb bb       =
                  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD       =20
[  206.655169]  Padding 0xc00000020fe1aa78:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ       =20
[  206.655806] Call Trace:
[  206.655930] [c00000000080b050] [c00000000000f880] .show_stack+0x6c/0x174=
 (unreliable)
[  206.656326] [c00000000080b100] [c0000000000e7880] .print_trailer+0x150/0=
x178
[  206.656672] [c00000000080b1a0] [c0000000000e909c] .__slab_free+0x3b0/0x4=
c4
[  206.657009] [c00000000080b260] [c0000000000eab30] .kfree+0x150/0x1b0
[  206.657344] [c00000000080b310] [d00000000017eda8] .ath_tx_status+0x368/0=
x3b4 [ath9k]
[  206.657760] [c00000000080b400] [d0000000001b9370] .ieee80211_tx_status+0=
x240/0x5e8 [mac80211]
[  206.658192] [c00000000080b4c0] [d0000000001767f0] .ath_tx_complete+0xfc/=
0x148 [ath9k]
[  206.658593] [c00000000080b570] [d000000000178ec8] .ath_tx_complete_buf+0=
xf4/0x168 [ath9k]
[  206.659010] [c00000000080b630] [d00000000017c4a8] .ath_tx_tasklet+0x4d4/=
0x5dc [ath9k]
[  206.659413] [c00000000080b750] [d000000000181394] .ath9k_tasklet+0x8c/0x=
bc [ath9k]
[  206.659783] [c00000000080b7e0] [c0000000000551dc] .tasklet_action+0x14c/=
0x244
[  206.660132] [c00000000080b890] [c0000000000560cc] .__do_softirq+0xd8/0x1=
c4
[  206.660469] [c00000000080b940] [c00000000000c2b8] .do_softirq+0x5c/0xb8
[  206.660794] [c00000000080b9c0] [c000000000055b08] .irq_exit+0x74/0xe0
[  206.661112] [c00000000080ba40] [c00000000000c41c] .do_IRQ+0x108/0x14c
[  206.661430] [c00000000080bad0] [c000000000004794] hardware_interrupt_ent=
ry+0x1c/0x20
[  206.661810] --- Exception: 501 at .cpu_idle+0x118/0x200
[  206.661812]     LR =3D .cpu_idle+0x118/0x200
[  206.662252] [c00000000080bdc0] [c000000000011ec8] .cpu_idle+0xd0/0x200 (=
unreliable)
[  206.662640] [c00000000080be60] [c0000000003ee8d4] .rest_init+0x8c/0xa4
[  206.662964] [c00000000080bee0] [c000000000587bc0] .start_kernel+0x4a0/0x=
4c8
[  206.663305] [c00000000080bf90] [c000000000007568] .start_here_common+0x3=
c/0x54
[  206.663657] FIX kmalloc-96: Object at 0xc00000020fe1a9d8 not freed

FAIL.

This tries to free the ath_tx_info_priv which you've copied into the tx
info at rate control time, that's not intended, and it got duplicated to
each fragment. Oops. You're lucky it doesn't normally oops, a small
change to struct ieee80211_tx_info could make it oops all the time. Say
changing the positions of control.vif and control.key.

johannes

--=-6SAYOCln2mk1HZOuvIdv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7xwHAAoJEKVg1VMiehFYr54P/1tilXR4fRWFOKqs+bgla29h
l2fUQUSHb+G2yUarzPlkPv0jFalTfV3rDvQCN0Fzwr3oKR4n8oZgdWFSX0Px6Pad
uM00fauaUSw4lZnbxxsefmQZOIUMQlVRStR8cz2RsWFgEKAgaJ624ORjPSjptWNn
4LJ7nQP2jDuDwq2K5JT1WSJUSPQMVQwQO2ain7n3uwmSChNiGhK5vQ1VQByMMYAj
wzInNNmsJmqOoKR81M9YfJ6xyQieCrh+l8VKUxs7Krs+NNEOWEGksFFhJEsB3134
3C+xLhLvino+NZZxxFiMMONNXVZ2gDo5E+w+8/H5SBa9mfNTzxLX0YDFT1JpQEhu
gSQaGW68O1j0o4nDfyhCDnDTzo/VKeJzGAQmDeOW4nRYVPY8mlTywwcgKt+NVwsj
UHQH9yWOOC69uehhyI/KZoVr+2xckhIlWD2nDUlQbzpHNh1kCLS9sLrUbw7uLX81
fD8rcpYKZUGkoh0z1IE1YVYPKjlxR6xB+FIUolAUiBiaPyFZeIBP7x5sB25cDu0i
kN+Y94IA2j72j8x2kiXYXkXvRiGGzMgMBENlkl8PO956Qt2jCZQwIVu5vM8c9OYa
+4ZYHtyofQUhGS9Elur4aa7I3pIMS2MLpfJn30/uGQ8HD+ZSLKKqjSNzb9TOruJT
l3Pe4JIPfo+Dr6AX6yl5
=K4fb
-----END PGP SIGNATURE-----

--=-6SAYOCln2mk1HZOuvIdv--

