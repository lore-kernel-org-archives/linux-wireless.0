Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbYFONtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 09:49:21 -0400
Subject: Re: [PATCH] mac80211: detect driver tx bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213534025.3803.2.camel@johannes.berg> (sfid-20080615_144745_622030_910244B5)
References: <1213534025.3803.2.camel@johannes.berg>
	 (sfid-20080615_144745_622030_910244B5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BZt9YUjErVpFZGk7q641"
Date: Sun, 15 Jun 2008 15:49:06 +0200
Message-Id: <1213537746.3803.7.camel@johannes.berg> (sfid-20080615_154924_173549_27497FE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BZt9YUjErVpFZGk7q641
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-15 at 14:47 +0200, Johannes Berg wrote:
> When a driver rejects a frame in it's ->tx() callback, it must also
> stop queues, otherwise mac80211 can go into a loop here. Detect this
> situation and abort the loop after five retries, warning about the
> driver bug.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This fixes resume with connected device with b43 for me, the warning
> triggers.

For reference:

[  177.789427] b43-phy0 debug: Resuming...
[  177.816496] ------------[ cut here ]------------
[  177.816663] Badness at net/mac80211/tx.c:1197
[  177.816813] NIP: f24fadfc LR: f24fae18 CTR: c0324458
[  177.816983] REGS: eec27ce0 TRAP: 0700   Not tainted  (2.6.26-rc6-wl-1052=
6-ga0d3022-dirty)
[  177.817248] MSR: 00029032 <EE,ME,IR,DR>  CR: 28000084  XER: 20000000
[  177.817590] TASK =3D ef964e60[1050] 'b43' THREAD: eec26000
[  177.817766] GPR00: 00000001 eec27d90 ef964e60 00000001 00009032 eec27d98=
 00000000 00000001=20
[  177.818200] GPR08: f2548b3c eec2a480 00000000 00000000 00000001 00000000=
 017b7354 017b70c8=20
[  177.818633] GPR16: 41400000 00240e64 00000000 c03e03e0 ffffffff c06315bc=
 eec28000 eec26000=20
[  177.819066] GPR24: eec27d98 00000000 00000420 00000001 eedc18c0 efbd8220=
 efbd8788 00000006=20
[  177.819514] NIP [f24fadfc] ieee80211_master_start_xmit+0x334/0x504 [mac8=
0211]
[  177.819843] LR [f24fae18] ieee80211_master_start_xmit+0x350/0x504 [mac80=
211]
[  177.820984] Call Trace:
[  177.821908] [eec27d90] [f24fae18] ieee80211_master_start_xmit+0x350/0x50=
4 [mac80211] (unreliable)
[  177.823110] [eec27df0] [c027b3f4] dev_hard_start_xmit+0x320/0x3a4
[  177.824184] [eec27e30] [c028e3d4] __qdisc_run+0x248/0x27c
[  177.825238] [eec27e70] [c027b8bc] dev_queue_xmit+0x2e8/0x3b4
[  177.826300] [eec27e90] [f24ecb00] ieee80211_sta_tx+0x74/0x88 [mac80211]
[  177.827414] [eec27eb0] [f24ef200] ieee80211_associated+0x154/0x1e8 [mac8=
0211]
[  177.828541] [eec27ef0] [f24f1054] ieee80211_sta_work+0x57c/0x700 [mac802=
11]
[  177.829662] [eec27f60] [c0043278] run_workqueue+0xc0/0x164
[  177.830723] [eec27f90] [c0043634] worker_thread+0xb0/0x134
[  177.831782] [eec27fd0] [c00479e4] kthread+0x50/0x88
[  177.832824] [eec27ff0] [c0012500] kernel_thread+0x44/0x60
[  177.833889] Instruction dump:
[  177.834855] 7d29d214 80090004 700b0001 408200c0 7c00f028 7c00d878 7c00f1=
2d 40a2fff4=20
[  177.836106] 3bff0001 2f9f0005 7c000026 5400f7fe <0f000000> 2f800000 409e=
00dc 7fa3eb78=20
[  177.966351] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:3=
2:10)
[  178.176634] b43-phy0 debug: Chip initialized
[  178.180244] b43-phy0 debug: 30-bit DMA initialized
[  178.180734] b43-phy0 debug: Wireless interface started
[  178.180744] b43-phy0 debug: Device resumed.


--=-BZt9YUjErVpFZGk7q641
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVR3NAAoJEKVg1VMiehFYg48QAIhHEjE+qtOD0k6dC4Q/qVvy
jFNok5HM5wNPWJTbdudKsxoroF/bvOp8FeFbIJURpWu4AozopqY3IX2d33C6EpNt
NvP/5BOABEDQ81f2xjq6j841U1Rjz+Y1KDJpdZK+M5AxMRXWwuB2o3p468dmDW/G
qfhxcCAgfQZXNp+HCjmJ9w6VaJDOvrUFCKZWiITu+uJm17c4/G9z7xieOE+fScYb
4/uij+a30burRdicUpGvotgDHCt+nE9n2yyuM501XAK0KPbVnjFGLxCOO5KrkeZL
CACIDeiRgt9N5TaY8n8XA/LPiY4bkBVxyJKAMkYq2+z2tTUyi+gCluEBKa7U+ien
PW9CoZxLnuM70JoVMvxcLeuVdX3NNCCh01JuAS4agDd/lAZYc2wzklg/XreKQzOn
SMk12Z5LzMgMWCIV5hU0uTWNlaKQvdZYyl6H/ESRDG7zYHLYDSMmawohySmHy+1F
7r8wlLRLWbsLaRV1Bvxqo/pNGrZTfAHROW9ZjQDIUB9cP9wahvSmCnPOozJ+IPX/
gWa3QWLtyE+Hqux4VovQFpBPZJDWXVmIVmFXh2eYT+fIZEw+7UvEPW2HgfQVqSVN
D7T5GK+xHjhYFQdiuow/g/39zBE0H55VLxpKOlKn1YKjqGS422kz1wISYjATuoey
kOtrrHQdt/bSl2T0AWvi
=G3uu
-----END PGP SIGNATURE-----

--=-BZt9YUjErVpFZGk7q641--

