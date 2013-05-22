Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab3EVWCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 18:02:17 -0400
Received: from [172.17.34.65] (hardanger.do.blackshift.org [172.17.34.65])
	(using TLSv1 with cipher ECDHE-ECDSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: frogger)
	by bjornoya.do.blackshift.org (Postfix) with ESMTPSA id E90D95E897
	for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 00:02:14 +0200 (CEST)
Message-ID: <519D405B.2080806@blackshift.org> (sfid-20130523_000221_992980_0C1195A8)
Date: Thu, 23 May 2013 00:02:03 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: skb_under_panic in ath9k
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TUJRUIHQTJWHMBUPUGVJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TUJRUIHQTJWHMBUPUGVJ
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

I'm on a kirkwood based armv5 system with an USB attached TP-Link
TL-WN821N - Atheros AR7010+AR9287, [1]. the wlan is running in AP mode
with hostapd-1.0. The kernel is v3.8.12 from debian (3.8-1-kirkwood #1
Debian 3.8.12-1).

The system crashes repeatedly after about one week with the following
oops:

[633625.401875] skbuff: skb_under_panic: text:bf501028 len:128 put:8 head=
:d2788800 data:d27887fe tail:0xd278887e end:0xd2788f40 dev:wlan1
[633625.414180] ------------[ cut here ]------------
[633625.418909] kernel BUG at /build/buildd-linux_3.8.12-1-armel-7F6kBx/l=
inux-3.8.12/net/core/skbuff.c:145!
[633625.428430] Internal error: Oops - BUG: 0 [#1] ARM
[633625.433322] Modules linked in:
[...]
[633625.583170] CPU: 0    Not tainted  (3.8-1-kirkwood #1 Debian 3.8.12-1=
)
[633625.589821] PC is at skb_push+0x6c/0x84
[633625.593763] LR is at skb_push+0x6c/0x84
[633625.597707] pc : [<c0282990>]    lr : [<c0282990>]    psr: 20000013
[633625.597707] sp : c04c1d50  ip : 000008f8  fp : df04ea54
[633625.609404] r10: 00000002  r9 : 00000008  r8 : df00dca8
[633625.614734] r7 : 00000006  r6 : c04410a0  r5 : d278887e  r4 : d278880=
0
[633625.621378] r3 : c04d328c  r2 : 20000093  r1 : 00000001  r0 : 0000007=
9
[633625.628015] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segm=
ent kernel
[633625.635443] Control: 0005317f  Table: 1f224000  DAC: 00000017
[633625.641295] Process swapper (pid: 0, stack limit =3D 0xc04c01b8)
[633625.647241] Stack: (0xc04c1d50 to 0xc04c2000)
[633625.657414] 1d40:                                     00000008 d27888=
00 d27887fe d278887e
[633625.666101] 1d60: d2788f40 df04e000 df00dc00 df2e0c00 00000078 bf5010=
28 df2e0c00 dfba3120
[633625.675025] 1d80: d278882a df04e9a0 00000000 bf504110 dfb3ce20 000002=
01 00000000 00084502
[633625.683954] 1da0: 00000001 df2e0c00 dfba3120 00000008 00000002 c04c1d=
f4 00000000 00000001
[633625.693553] 1dc0: 0000006a bf5058b0 00000000 c04c1df4 c04c1e30 dfba23=
00 c151ff18 df04e9a0
[633625.702041] 1de0: c04c1e30 bf37560c 0000000c 00004288 c04c1e2c c151ff=
18 0000006a df2e0c00
[633625.710540] 1e00: dfba2300 00000000 0000006a df04e462 00000000 000000=
01 60000013 bf375760
[633625.718904] 1e20: 00000001 c14c19a0 c14c0460 00000000 c04c1e30 c04c1e=
30 00000000 dfba2300
[633625.727374] 1e40: df04e460 c151fc00 de5af200 00000002 00000002 dfba23=
00 dfba2308 dfba28a8
[633625.787263] 1e60: c04c1e7c dfba28ac df2e0c00 bf376d58 c0508ae0 000000=
00 0000012c 00000080
[633625.798914] 1e80: 03c66eab c0508ae8 c04d4c68 c04d3494 00000000 000000=
00 00000006 00000100
[633625.810249] 1ea0: c052b3a0 00000009 c052b3c0 c0026e2c 00000001 000000=
18 c04c0000 c0026644
[633625.818620] 1ec0: c04d8f74 c1484260 1144b25a c04d8f74 00000000 002000=
00 c04c1f4c 00000013
[633625.831230] 1ee0: 00000000 fed20200 c04c1f4c 00000000 56251311 c04d04=
20 00000000 c0026a2c
[633625.842695] 1f00: 00002000 c000f28c c004e27c c0271318 20000013 c000df=
94 c04c1f60 60000013
[633625.853824] 1f20: 000e32dc 0002404f b5def004 0002404f c04d0698 000000=
00 00000000 56251311
[633625.864745] 1f40: c04d0420 00000000 00000003 c04c1f60 c004e27c c02713=
18 20000013 ffffffff
[633625.875714] 1f60: b5ed22e0 0002404f 0084d405 00000000 00000000 c04d06=
98 00000000 c04d0698
[633625.886646] 1f80: 00000000 c04d0420 004b8074 c0270e88 c04d0698 000000=
00 c050918c c0271014
[633625.898317] 1fa0: c04c0000 c0509b28 c04cc1cc c096f0e0 00004000 c000f4=
84 c04c8c20 00000000
[633625.909787] 1fc0: c04b9650 c0498764 ffffffff ffffffff c0498284 000000=
00 00000000 c04b9650
[633625.918159] 1fe0: 00000000 00053175 c04c8048 c04b964c c04cc1c4 000080=
40 00000000 00000000
[633625.926557] [<c0282990>] (skb_push+0x6c/0x84) from [<bf501028>] (htc_=
issue_send.constprop.0+0x28/0x68 [ath9k_htc])
[633625.937158] [<bf501028>] (htc_issue_send.constprop.0+0x28/0x68 [ath9k=
_htc]) from [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc])
[633625.949877] [<bf504110>] (ath9k_htc_tx_start+0x290/0x2a4 [ath9k_htc])=
 from [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc])
[633625.961458] [<bf5058b0>] (ath9k_htc_tx+0x98/0xcc [ath9k_htc]) from [<=
bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211])
[633625.972695] [<bf37560c>] (__ieee80211_tx+0x210/0x2a8 [mac80211]) from=
 [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211])
[633625.983816] [<bf375760>] (ieee80211_tx+0xbc/0xc4 [mac80211]) from [<b=
f376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211])
[633625.995326] [<bf376d58>] (ieee80211_tx_pending+0xf0/0x194 [mac80211])=
 from [<c0026e2c>] (tasklet_action+0x84/0xcc)
[633626.005905] [<c0026e2c>] (tasklet_action+0x84/0xcc) from [<c0026644>]=
 (__do_softirq+0xdc/0x204)
[633626.014750] [<c0026644>] (__do_softirq+0xdc/0x204) from [<c0026a2c>] =
(irq_exit+0x40/0x8c)
[633626.023103] [<c0026a2c>] (irq_exit+0x40/0x8c) from [<c000f28c>] (hand=
le_IRQ+0x64/0x84)
[633626.031193] [<c000f28c>] (handle_IRQ+0x64/0x84) from [<c000df94>] (__=
irq_svc+0x34/0x78)
[633626.039412] [<c000df94>] (__irq_svc+0x34/0x78) from [<c0271318>] (cpu=
idle_wrap_enter+0x54/0x9c)
[633626.048331] [<c0271318>] (cpuidle_wrap_enter+0x54/0x9c) from [<c0270e=
88>] (cpuidle_enter_state+0x14/0x68)
[633626.058162] [<c0270e88>] (cpuidle_enter_state+0x14/0x68) from [<c0271=
014>] (cpuidle_idle_call+0x138/0x25c)
[633626.067998] [<c0271014>] (cpuidle_idle_call+0x138/0x25c) from [<c000f=
484>] (cpu_idle+0x68/0xc8)
[633626.076852] [<c000f484>] (cpu_idle+0x68/0xc8) from [<c0498764>] (star=
t_kernel+0x2b4/0x30c)
[633626.146230] Code: e58dc014 e59f1014 e59f0014 eb0308b0 (e7f001f2)
[633626.152520] ---[ end trace ee5dbceea3381e46 ]---
[633626.157249] Kernel panic - not syncing: Fatal exception in interrupt

Has the problem been fixed already? I can update the kernel to a recent
version if needed.

regards,
Marc

[1] lsusb:
Bus 001 Device 004: ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-=
WN821N v3 802.11n [Atheros AR7010+AR9287]


------enig2TUJRUIHQTJWHMBUPUGVJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRnUBiAAoJEF5D1i44JRMa3EAP/RreLozo3IGQLXT+rmQLwIcv
sRK6AtgivMv5orvsizArQYeVrOHhu1aaUlIVvj1HIb0UuAIKgJgSdCGUK8BQV5L2
3o9FmNzVXBUj4IX27zPaG143yxXdg7BAukj6wVbeTdILuvv2ZDpIf7yTossBwnHN
zcc9fCvERNdNfDrWjJGMuoL+RIL33qVMWuWxHG3wxPbF1NKBaF5OQW1aucnTHgKL
dJb5FTMeLz+lIbzpBpy+T2bk4oK6zuMu3TumRG5ORAj+qBIzfPEBBqivt+ikd/AI
pM9ZAYh68CGcU5svM6bTbjbxxhjKYzZ7SKrTv4mjeK5Y0y111QwvPSbTCsOPo9Dt
XkxB7Ad4E5vKysMHQq24jHKoGc9MgtjW9acvMotHOMZT8vBliQapdTrGyhkCM07C
Twcpnax+s7FUkYDZKXXcsnuiJTUx+Cdj1LAK+8mYDN/s4D65eDJungz2E4cU9NtR
h6djyGin4c/Y/mnM6ap347WhVvLUKabEFgO9yGlBEmltCD4CORNUkYWgBYb0exnl
nIGYN58GTwun3aA/zpyMp1y6UaoCtyP+BltaPBga74Hf4w7Dcyn1/I/iilpn9MLv
AhkNKYttsWjls2/V8shUwRp0zkbliVfm3GqSbhNIbKzmHe8ghapxuynP7FR0ycQi
AAL6fQEzk9D51lqHGxeS
=DscG
-----END PGP SIGNATURE-----

------enig2TUJRUIHQTJWHMBUPUGVJ--
