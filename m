Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYEGLJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 07:09:22 -0400
Subject: b43 doing tx-status reports with NULL frames?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WdwDl0m0905QicEGGMN2"
Date: Wed, 07 May 2008 13:08:31 +0200
Message-Id: <1210158511.5642.1.camel@johannes.berg> (sfid-20080507_130829_350699_C46C1724)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WdwDl0m0905QicEGGMN2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is odd:

[  847.811157] ------------[ cut here ]------------
[  847.811168] Badness at drivers/net/wireless/b43/dma.c:1380
[  847.811174] NIP: f2530de4 LR: f2530dc8 CTR: f252ff70
[  847.811182] REGS: d191bb20 TRAP: 0700   Not tainted  (2.6.25-wl-06933-g0=
bacadf-dirty)
[  847.811188] MSR: 00021032 <ME,IR,DR>  CR: 48242484  XER: 00000000
[  847.811205] TASK =3D d1918000[5078] 'wpa_supplicant' THREAD: d191a000
[  847.811211] GPR00: 00000001 d191bbd0 d1918000 edb89248 00000208 d191bbd8=
 00000000 000003cc=20
[  847.811230] GPR08: 00000001 00000000 00010004 edb89200 48242488 10083d28=
 100e0000 100876e9=20
[  847.811249] GPR16: 100876d9 100876b1 22042442 0000008a 00000002 1006071c=
 ed88703c 00000000=20
[  847.811268] GPR24: d191bbd8 f2537d24 ee513120 d191bc28 00000001 0000029e=
 00000041 ed887000=20
[  847.811288] NIP [f2530de4] b43_dma_handle_txstatus+0xd4/0x2e8 [b43]
[  847.811336] LR [f2530dc8] b43_dma_handle_txstatus+0xb8/0x2e8 [b43]
[  847.811354] Call Trace:
[  847.811358] [d191bbd0] [f2530d74] b43_dma_handle_txstatus+0x64/0x2e8 [b4=
3] (unreliable)
[  847.811381] [d191bc10] [f252bb70] b43_handle_txstatus+0x8c/0xd4 [b43]
[  847.811400] [d191bc20] [f25221d4] b43_interrupt_tasklet+0x1c0/0x638 [b43=
]
[  847.811420] [d191bc80] [c0034fb8] tasklet_action+0x74/0xec
[  847.811438] [d191bca0] [c00358c4] __do_softirq+0x8c/0xfc
[  847.811449] [d191bcd0] [c0006e40] do_softirq+0x58/0x5c
[  847.811464] [d191bce0] [c0035618] local_bh_enable+0xa8/0xac
[  847.811475] [d191bcf0] [c027b518] dev_queue_xmit+0xe8/0x3cc
[  847.811490] [d191bd10] [f26cd30c] packet_sendmsg+0x22c/0x268 [af_packet]
[  847.811510] [d191bd50] [c026bb3c] sock_sendmsg+0xac/0xe4
[  847.811525] [d191be30] [c026bed0] sys_sendto+0xbc/0xec
[  847.811536] [d191bf00] [c026ca20] sys_socketcall+0x12c/0x1dc
[  847.811547] [d191bf40] [c00124cc] ret_from_syscall+0x0/0x38
[  847.811564] --- Exception: c01 at 0xfcaf97c
[  847.811593]     LR =3D 0x10052ca8
[  847.811598] Instruction dump:
[  847.811604] 7fe3fb78 7fc4f378 7f05c378 7c0903a6 4e800421 80610008 880300=
08 81230000=20
[  847.811624] 2f800000 419e0118 7d200034 5400d97e <0f000000> 38630010 7f64=
db78 4bffac09=20


That WARN_ON is:

        if (WARN_ON(!skb))
                return;

This was with dma overflow injection and a few patches, but nothing
relevant inside b43.

johannes

--=-WdwDl0m0905QicEGGMN2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCGNrqVg1VMiehFYAQKkORAAwDdgngV9RNQIQGVo6JbC0lzumiWCUXu9
SPn+L7uNhNNOl9OjMILzEU4hrimhUXJjKt0rtZL4PQHm73tFRqN3UUWX9P2MByUd
/DBV1CsypluJGmk8giRXR1fFXAZ1J/Qtpn40CexDvIaEvMnl/wM1Gly3zPn4N4Zz
XVDlV6bN88OqtL+is+Rd5Vmi0VQdEjwcLO4lI5Lb7ayXbxPOkx6Q8yM5iPDrZ42E
2FD1+4jNCkmsrhT0Oq3s+nyqmLIbCCbFB3es1y88NMcYjIiYLlzOLoZAReXwmBy4
ONiQqkWx4tokYMhL60VBP8OS7O2B5OULoBcAJ0VA/0+1/+vVY71AQspg2mRRur+Q
nl6IPbZyDlkeyecxQ/0+7FzAPjCSGwhZZwMsTmlxKLNaoD+30WFfucuWlzwHddKY
9glh9h8TMWLtfRiOGCLQVxOcCdlwuq/7VxzCKAdDTn7F+TkA7xOLQxZFq3+vvAJn
f3ttOipwm23N3cuW8XrjrFe7FkE/cYcZtfpKmWykYqtaw5X0FbJ+k5++wEsXjyN5
5NgO7H9cZ/MAoQokffsYQ7ysb1EOmLouXFLEFRrbXm6Y+u80uncYjufgFSkrTZyy
lVcCR59h2K+J4cRnaEyiwrfX0yeli38g831q8b4c5UrDoswpDasDFDQsH0Gaw5EG
LkoxOZ0Cd9c=
=kZjc
-----END PGP SIGNATURE-----

--=-WdwDl0m0905QicEGGMN2--

