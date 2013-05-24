Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054Ab3EXIrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 04:47:37 -0400
Message-ID: <519F291B.1060905@blackshift.org> (sfid-20130524_104743_835022_14D7A729)
Date: Fri, 24 May 2013 10:47:23 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: skb_under_panic in ath9k
References: <519D405B.2080806@blackshift.org>
In-Reply-To: <519D405B.2080806@blackshift.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2RIIODKTGIGJPLEQNGGAX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2RIIODKTGIGJPLEQNGGAX
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

added ath9k-devel to Cc

On 05/23/2013 12:02 AM, Marc Kleine-Budde wrote:
> Hello,
>=20
> I'm on a kirkwood based armv5 system with an USB attached TP-Link
> TL-WN821N - Atheros AR7010+AR9287, [1]. the wlan is running in AP mode
> with hostapd-1.0. The kernel is v3.8.12 from debian (3.8-1-kirkwood #1
> Debian 3.8.12-1).
>=20
> The system crashes repeatedly after about one week with the following
> oops:
>=20
> [633625.401875] skbuff: skb_under_panic: text:bf501028 len:128 put:8 he=
ad:d2788800 data:d27887fe tail:0xd278887e end:0xd2788f40 dev:wlan1
> [633625.414180] ------------[ cut here ]------------
> [633625.418909] kernel BUG at /build/buildd-linux_3.8.12-1-armel-7F6kBx=
/linux-3.8.12/net/core/skbuff.c:145!
> [633625.428430] Internal error: Oops - BUG: 0 [#1] ARM
> [633625.433322] Modules linked in:
> [...]
> [633625.583170] CPU: 0    Not tainted  (3.8-1-kirkwood #1 Debian 3.8.12=
-1)
> [633625.589821] PC is at skb_push+0x6c/0x84
> [633625.593763] LR is at skb_push+0x6c/0x84
> [633625.597707] pc : [<c0282990>]    lr : [<c0282990>]    psr: 20000013=

> [633625.597707] sp : c04c1d50  ip : 000008f8  fp : df04ea54
> [633625.609404] r10: 00000002  r9 : 00000008  r8 : df00dca8
> [633625.614734] r7 : 00000006  r6 : c04410a0  r5 : d278887e  r4 : d2788=
800
> [633625.621378] r3 : c04d328c  r2 : 20000093  r1 : 00000001  r0 : 00000=
079
> [633625.628015] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Se=
gment kernel
> [633625.635443] Control: 0005317f  Table: 1f224000  DAC: 00000017
> [633625.641295] Process swapper (pid: 0, stack limit =3D 0xc04c01b8)
> [633625.647241] Stack: (0xc04c1d50 to 0xc04c2000)
> [633625.657414] 1d40:                                     00000008 d278=
8800 d27887fe d278887e
> [633625.666101] 1d60: d2788f40 df04e000 df00dc00 df2e0c00 00000078 bf50=
1028 df2e0c00 dfba3120
> [633625.675025] 1d80: d278882a df04e9a0 00000000 bf504110 dfb3ce20 0000=
0201 00000000 00084502
> [633625.683954] 1da0: 00000001 df2e0c00 dfba3120 00000008 00000002 c04c=
1df4 00000000 00000001
> [633625.693553] 1dc0: 0000006a bf5058b0 00000000 c04c1df4 c04c1e30 dfba=
2300 c151ff18 df04e9a0
> [633625.702041] 1de0: c04c1e30 bf37560c 0000000c 00004288 c04c1e2c c151=
ff18 0000006a df2e0c00
> [633625.710540] 1e00: dfba2300 00000000 0000006a df04e462 00000000 0000=
0001 60000013 bf375760
> [633625.718904] 1e20: 00000001 c14c19a0 c14c0460 00000000 c04c1e30 c04c=
1e30 00000000 dfba2300
> [633625.727374] 1e40: df04e460 c151fc00 de5af200 00000002 00000002 dfba=
2300 dfba2308 dfba28a8
> [633625.787263] 1e60: c04c1e7c dfba28ac df2e0c00 bf376d58 c0508ae0 0000=
0000 0000012c 00000080
> [633625.798914] 1e80: 03c66eab c0508ae8 c04d4c68 c04d3494 00000000 0000=
0000 00000006 00000100
> [633625.810249] 1ea0: c052b3a0 00000009 c052b3c0 c0026e2c 00000001 0000=
0018 c04c0000 c0026644
> [633625.818620] 1ec0: c04d8f74 c1484260 1144b25a c04d8f74 00000000 0020=
0000 c04c1f4c 00000013
> [633625.831230] 1ee0: 00000000 fed20200 c04c1f4c 00000000 56251311 c04d=
0420 00000000 c0026a2c
> [633625.842695] 1f00: 00002000 c000f28c c004e27c c0271318 20000013 c000=
df94 c04c1f60 60000013
> [633625.853824] 1f20: 000e32dc 0002404f b5def004 0002404f c04d0698 0000=
0000 00000000 56251311
> [633625.864745] 1f40: c04d0420 00000000 00000003 c04c1f60 c004e27c c027=
1318 20000013 ffffffff
> [633625.875714] 1f60: b5ed22e0 0002404f 0084d405 00000000 00000000 c04d=
0698 00000000 c04d0698
> [633625.886646] 1f80: 00000000 c04d0420 004b8074 c0270e88 c04d0698 0000=
0000 c050918c c0271014
> [633625.898317] 1fa0: c04c0000 c0509b28 c04cc1cc c096f0e0 00004000 c000=
f484 c04c8c20 00000000
> [633625.909787] 1fc0: c04b9650 c0498764 ffffffff ffffffff c0498284 0000=
0000 00000000 c04b9650
> [633625.918159] 1fe0: 00000000 00053175 c04c8048 c04b964c c04cc1c4 0000=
8040 00000000 00000000
> [633625.926557] [<c0282990>] (skb_push+0x6c/0x84) from [<bf501028>] (ht=
c_issue_send.constprop.0+0x28/0x68 [ath9k_htc])
> [633625.937158] [<bf501028>] (htc_issue_send.constprop.0+0x28/0x68 [ath=
9k_htc]) from [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc])
> [633625.949877] [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc=
]) from [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc])
> [633625.961458] [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc]) from =
[<bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211])
> [633625.972695] [<bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211]) fr=
om [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211])
> [633625.983816] [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211]) from [=
<bf376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211])
> [633625.995326] [<bf376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211=
]) from [<c0026e2c>] (tasklet_action+0x84/0xcc)
> [633626.005905] [<c0026e2c>] (tasklet_action+0x84/0xcc) from [<c0026644=
>] (__do_softirq+0xdc/0x204)
> [633626.014750] [<c0026644>] (__do_softirq+0xdc/0x204) from [<c0026a2c>=
] (irq_exit+0x40/0x8c)
> [633626.023103] [<c0026a2c>] (irq_exit+0x40/0x8c) from [<c000f28c>] (ha=
ndle_IRQ+0x64/0x84)
> [633626.031193] [<c000f28c>] (handle_IRQ+0x64/0x84) from [<c000df94>] (=
__irq_svc+0x34/0x78)
> [633626.039412] [<c000df94>] (__irq_svc+0x34/0x78) from [<c0271318>] (c=
puidle_wrap_enter+0x54/0x9c)
> [633626.048331] [<c0271318>] (cpuidle_wrap_enter+0x54/0x9c) from [<c027=
0e88>] (cpuidle_enter_state+0x14/0x68)
> [633626.058162] [<c0270e88>] (cpuidle_enter_state+0x14/0x68) from [<c02=
71014>] (cpuidle_idle_call+0x138/0x25c)
> [633626.067998] [<c0271014>] (cpuidle_idle_call+0x138/0x25c) from [<c00=
0f484>] (cpu_idle+0x68/0xc8)
> [633626.076852] [<c000f484>] (cpu_idle+0x68/0xc8) from [<c0498764>] (st=
art_kernel+0x2b4/0x30c)
> [633626.146230] Code: e58dc014 e59f1014 e59f0014 eb0308b0 (e7f001f2)
> [633626.152520] ---[ end trace ee5dbceea3381e46 ]---
> [633626.157249] Kernel panic - not syncing: Fatal exception in interrup=
t
>=20
> Has the problem been fixed already? I can update the kernel to a recent=

> version if needed.
>=20
> regards,
> Marc
>=20
> [1] lsusb:
> Bus 001 Device 004: ID 0cf3:7015 Atheros Communications, Inc. TP-Link T=
L-WN821N v3 802.11n [Atheros AR7010+AR9287]


------enig2RIIODKTGIGJPLEQNGGAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRnykgAAoJEF5D1i44JRMa19AP/3NqlSAujp/MZFGGQ32C5D2N
KyhK3zSo0jAfbksi/4WT9Y6OP3a2pPzNf0HqSWW6YA667PcMUXlA3ZjgbDOVPJ4+
160SvacowIQkz5Aga+uu3YIFRrXc0W32wRBnM97nMN55dGI4CfTL3Ni42OIZnkc2
WuJDME8hORBCYw47jkrFYvwB6e4q9AzPSZoOUcEjpiiKnEmP4H1CnNAUNmZHb0VI
5jHJpnceDwC3bn+qlV15ZabEfjZSfW01/3ylEP1hI3eZbAZtXklS/IkpdEtVMq0o
/gX42CWjkkGB5TV2CCv3B5hqIuGSJ8BTlVENxCeH8cqPkoOApgeYdUfbT2ryK1Wu
J/2f1H7vVk4L2Sj2Ic94XBPpHwkWfo1mynqDBhdEkpyrPyTFtNrV5fnvQl5isr7H
q3GPUzFkvJn5cKEk94advaoy2qeD0yuIkCOfrsogakdKb6VlyVa3o15/552XsTWK
EhckIwwuhUiUvpryqEJ1EjvlqFQ8nIj6XM88Nh1u55QTunIzR9TL2VGt8PbIyeKd
gj2vyd0/wt/jYm7Pctgvu9qumFlsYIEDaXAmVy83cz/XdqJ//mg5eh3VGZS4W/NA
s0HxzjKZy7BeiGyy7xCIhgOZmrw/PoPhH2KSQFuOn0SKPBdZIOIUN7Rdux3CK5uy
QGEnWyl8F5Te/e0roA6o
=k7lO
-----END PGP SIGNATURE-----

------enig2RIIODKTGIGJPLEQNGGAX--
