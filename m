Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbXF0OGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 10:06:20 -0400
Subject: Re: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706271448.58087.mb@bu3sch.de>
References: <1182848382.3830.5.camel@johannes.berg>
	 <200706261617.45713.mb@bu3sch.de> <1182937106.4769.10.camel@johannes.berg>
	 <200706271448.58087.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jkSsxkrDq7AEbud+9cUZ"
Date: Wed, 27 Jun 2007 16:06:24 +0200
Message-Id: <1182953184.4769.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jkSsxkrDq7AEbud+9cUZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 14:48 +0200, Michael Buesch wrote:
> On Wednesday 27 June 2007 11:38:26 Johannes Berg wrote:
> > On Tue, 2007-06-26 at 16:17 +0200, Michael Buesch wrote:
> >=20
> > > That's a known bug.
> > > See the FIXME at stop_core() where we stop the mac80211-queues.
> > > mac80211 needs to be fixed to fix this. ;)
> > > We need a function to stop and flush the TX queues from
> > > _outside_ of the TX handlers.
> >=20
> > Are you sure it's the same bug? I don't think we get into
>=20
> Pretty, yeah. I'm probably going to solve this bug elsewhere.
> Need to think about it.
>=20
> > ieee80211_if_shutdown from bcm43xx itself.
>=20
> bcm43xx causes it only imlicitely. Calling ieee80211_stop_queues()
> (from outside of the TX path) will result in a deadlock in the
> qdisc handler, which will result in a complete system freeze on UP.
> So bcm43xx won't show up in the call-trace.

Hmm.
The thing here is:
Jun 26 09:05:56 johannes kernel: [22894.397724] wpa_supplican D 0FCE04A8   =
  0  9032      1 (NOTLB)
Jun 26 09:05:56 johannes kernel: [22894.397733] Call Trace:
Jun 26 09:05:56 johannes kernel: [22894.397738] [dd7b7c00] [c0300210] __mut=
ex_lock_slowpath+0x128/0x1d4 (unreliable)
Jun 26 09:05:56 johannes kernel: [22894.397750] [dd7b7cc0] [c0009434] __swi=
tch_to+0x44/0x98
Jun 26 09:05:56 johannes kernel: [22894.397761] [dd7b7ce0] [c02fe940] sched=
ule+0x340/0x6cc
Jun 26 09:05:56 johannes kernel: [22894.397771] [dd7b7d40] [c02ff2e8] wait_=
for_completion+0xf4/0x138
Jun 26 09:05:56 johannes kernel: [22894.397781] [dd7b7d80] [c004073c] flush=
_cpu_workqueue+0xb8/0xe4
Jun 26 09:05:56 johannes kernel: [22894.397792] [dd7b7db0] [f24876c4] ieee8=
0211_stop+0x1b4/0x2a8 [mac80211]
Jun 26 09:05:56 johannes kernel: [22894.397825] [dd7b7de0] [c025b158] dev_c=
lose+0xa4/0xd8
Jun 26 09:05:56 johannes kernel: [22894.397835] [dd7b7df0] [c025a01c] dev_c=
hange_flags+0x64/0x168
Jun 26 09:05:56 johannes kernel: [22894.397844] [dd7b7e10] [c02ab1cc] devin=
et_ioctl+0x5d0/0x760
Jun 26 09:05:56 johannes kernel: [22894.397861] [dd7b7e80] [c02ab94c] inet_=
ioctl+0x98/0xbc
Jun 26 09:05:56 johannes kernel: [22894.397871] [dd7b7e90] [c024c6bc] sock_=
ioctl+0xd8/0x290
Jun 26 09:05:56 johannes kernel: [22894.397881] [dd7b7eb0] [c00a083c] do_io=
ctl+0x40/0x100
Jun 26 09:05:56 johannes kernel: [22894.397891] [dd7b7ed0] [c00a0c14] vfs_i=
octl+0x318/0x4f0
Jun 26 09:05:56 johannes kernel: [22894.397901] [dd7b7f10] [c00a0e2c] sys_i=
octl+0x40/0x74
Jun 26 09:05:56 johannes kernel: [22894.397911] [dd7b7f40] [c00116f8] ret_f=
rom_syscall+0x0/0x38
Jun 26 09:05:56 johannes kernel: [22894.397921] --- Exception: c01 at 0xfce=
04a8
Jun 26 09:05:56 johannes kernel: [22894.397931]     LR =3D 0xfce0440

and

Jun 26 09:06:50 johannes kernel: [22948.985461] bcm43xx_mac80 D 00000000   =
  0   806      2 (L-TLB)
Jun 26 09:06:50 johannes kernel: [22948.985470] Call Trace:
Jun 26 09:06:50 johannes kernel: [22948.985474] [eac87c70] [00009032] 0x903=
2 (unreliable)
Jun 26 09:06:50 johannes kernel: [22948.985484] [eac87d30] [c0009434] __swi=
tch_to+0x44/0x98
Jun 26 09:06:50 johannes kernel: [22948.985494] [eac87d50] [c02fe940] sched=
ule+0x340/0x6cc
Jun 26 09:06:50 johannes kernel: [22948.985504] [eac87db0] [c0300184] __mut=
ex_lock_slowpath+0x9c/0x1d4
Jun 26 09:06:50 johannes kernel: [22948.985515] [eac87e00] [c02660f4] rtnl_=
lock+0x18/0x28
Jun 26 09:06:50 johannes kernel: [22948.985529] [eac87e10] [f2496714] ieee8=
0211_sta_config_auth+0x44/0x2c4 [mac80211]
Jun 26 09:06:50 johannes kernel: [22948.985589] [eac87e60] [f2497e30] ieee8=
0211_sta_work+0xb90/0x1354 [mac80211]
Jun 26 09:06:50 johannes kernel: [22948.985614] [eac87f60] [c0040444] run_w=
orkqueue+0xf4/0x1c8
Jun 26 09:06:50 johannes kernel: [22948.985625] [eac87f90] [c0040b14] worke=
r_thread+0x9c/0x120
Jun 26 09:06:50 johannes kernel: [22948.985635] [eac87fd0] [c0044f78] kthre=
ad+0x48/0x84
Jun 26 09:06:50 johannes kernel: [22948.985646] [eac87ff0] [c00125f4] kerne=
l_thread+0x44/0x60

I'm not convinced this is the same thing, the deadlock here is simply
that something running on the workqueue is trying to rtnl_lock() while
flushing the workqueue is done under rtnl.

johannes


--=-jkSsxkrDq7AEbud+9cUZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgm7g/ETPhpq3jKURAgpfAJ9spnVwKo42B+Tf2r5fwsxDuTKaBQCfYfBy
MI8W2m1RjV6GEj/r4JujCg0=
=q6zG
-----END PGP SIGNATURE-----

--=-jkSsxkrDq7AEbud+9cUZ--

