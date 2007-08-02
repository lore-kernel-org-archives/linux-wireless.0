Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbXHCJgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:36:23 -0400
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with  assoc work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708011253.06569.mb@bu3sch.de>
References: <200708011253.06569.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OnmP5BBWgJXi0cHMn/zX"
Date: Thu, 02 Aug 2007 23:55:23 +0200
Message-Id: <1186091723.4647.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OnmP5BBWgJXi0cHMn/zX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

FYI, my workqueue lockdep patches (in -mm as workqueue-something) say
this about it:

[  361.440737] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  361.440753] [ INFO: possible circular locking dependency detected ]
[  361.440761] 2.6.23-rc1-g05ff0970-dirty #244
[  361.440766] -------------------------------------------------------
[  361.440773] iwconfig/5551 is trying to acquire lock:
[  361.440778]  (events){--..}, at: [<c00000000006170c>] .flush_workqueue+0=
x44/0xf0
[  361.440807]=20
[  361.440808] but task is already holding lock:
[  361.440814]  (&softmac->associnfo.mutex){--..}, at: [<c0000000003b99c0>]=
 .mutex_lock+0x3c/0x58
[  361.440837]=20
[  361.440839] which lock already depends on the new lock.
[  361.440841]=20
[  361.440847]=20
[  361.440848] the existing dependency chain (in reverse order) is:
[  361.440854]=20
[  361.440856] -> #3 (&softmac->associnfo.mutex){--..}:
[  361.440869]        [<c000000000073e58>] .__lock_acquire+0xce8/0xf20
[  361.440896]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  361.440922]        [<c0000000003b96cc>] .__mutex_lock_slowpath+0x138/0x3=
f0
[  361.440950]        [<c0000000003b99c0>] .mutex_lock+0x3c/0x58
[  361.440977]        [<d0000000004c3cb4>] .ieee80211softmac_wx_set_essid+0=
x48/0x204 [ieee80211softmac]
[  361.441019]        [<c0000000003b5a8c>] .ioctl_standard_call+0x298/0x3bc
[  361.441047]        [<c0000000003b5d38>] .wext_handle_ioctl+0x188/0x4b4
[  361.441074]        [<c000000000330d54>] .dev_ioctl+0x584/0x5e0
[  361.441102]        [<c000000000320514>] .sock_ioctl+0x2fc/0x33c
[  361.441130]        [<c0000000000d9568>] .do_ioctl+0x5c/0xf8
[  361.441159]        [<c0000000000d9a5c>] .vfs_ioctl+0x458/0x490
[  361.441186]        [<c0000000000d9af0>] .sys_ioctl+0x5c/0xa4
[  361.441212]        [<c000000000110d88>] .do_wireless_ioctl+0x1d0/0x224
[  361.441241]        [<c00000000010c5ec>] .compat_sys_ioctl+0x3e0/0x470
[  361.441268]        [<c0000000000086d0>] syscall_exit+0x0/0x40
[  361.441296]=20
[  361.441298] -> #2 (rtnl_mutex){--..}:
[  361.441311]        [<c000000000073e58>] .__lock_acquire+0xce8/0xf20
[  361.441337]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  361.441363]        [<c0000000003b96cc>] .__mutex_lock_slowpath+0x138/0x3=
f0
[  361.441392]        [<c0000000003b99c0>] .mutex_lock+0x3c/0x58
[  361.441419]        [<c00000000033b85c>] .rtnl_lock+0x28/0x44
[  361.441446]        [<c00000000033d8ac>] .linkwatch_event+0x20/0x6c
[  361.441474]        [<c000000000060720>] .run_workqueue+0x16c/0x290
[  361.441501]        [<c000000000061d2c>] .worker_thread+0x13c/0x16c
[  361.441528]        [<c000000000066b98>] .kthread+0x84/0xd4
[  361.441554]        [<c000000000022734>] .kernel_thread+0x4c/0x68
[  361.441582]=20
[  361.441584] -> #1 ((linkwatch_work).work){--..}:
[  361.441597]        [<c000000000073e58>] .__lock_acquire+0xce8/0xf20
[  361.441623]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  361.441648]        [<c000000000060700>] .run_workqueue+0x14c/0x290
[  361.441675]        [<c000000000061d2c>] .worker_thread+0x13c/0x16c
[  361.441702]        [<c000000000066b98>] .kthread+0x84/0xd4
[  361.441727]        [<c000000000022734>] .kernel_thread+0x4c/0x68
[  361.441755]=20
[  361.441756] -> #0 (events){--..}:
[  361.441769]        [<c000000000073d50>] .__lock_acquire+0xbe0/0xf20
[  361.441795]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  361.441821]        [<c00000000006173c>] .flush_workqueue+0x74/0xf0
[  361.441859]        [<c0000000000617e0>] .flush_scheduled_work+0x28/0x40
[  361.441888]        [<d0000000004c3dac>] .ieee80211softmac_wx_set_essid+0=
x140/0x204 [ieee80211softmac]
[  361.441924]        [<c0000000003b5a8c>] .ioctl_standard_call+0x298/0x3bc
[  361.442017]        [<c0000000003b5d38>] .wext_handle_ioctl+0x188/0x4b4
[  361.442104]        [<c000000000330d54>] .dev_ioctl+0x584/0x5e0
[  361.442189]        [<c000000000320514>] .sock_ioctl+0x2fc/0x33c
[  361.442260]        [<c0000000000d9568>] .do_ioctl+0x5c/0xf8
[  361.442341]        [<c0000000000d9a5c>] .vfs_ioctl+0x458/0x490
[  361.442416]        [<c0000000000d9af0>] .sys_ioctl+0x5c/0xa4
[  361.442495]        [<c000000000110d88>] .do_wireless_ioctl+0x1d0/0x224
[  361.442577]        [<c00000000010c5ec>] .compat_sys_ioctl+0x3e0/0x470
[  361.442654]        [<c0000000000086d0>] syscall_exit+0x0/0x40
[  361.442737]=20
[  361.442739] other info that might help us debug this:
[  361.442742]=20
[  361.442752] 2 locks held by iwconfig/5551:
[  361.442763]  #0:  (rtnl_mutex){--..}, at: [<c0000000003b99c0>] .mutex_lo=
ck+0x3c/0x58
[  361.442818]  #1:  (&softmac->associnfo.mutex){--..}, at: [<c0000000003b9=
9c0>] .mutex_lock+0x3c/0x58
[  361.442843]=20
[  361.442845] stack backtrace:
[  361.442850] Call Trace:
[  361.442855] [c000000078eab100] [c00000000000f2e4] .show_stack+0x78/0x1a4=
 (unreliable)
[  361.442887] [c000000078eab1b0] [c00000000000f430] .dump_stack+0x20/0x34
[  361.442917] [c000000078eab230] [c00000000007141c] .print_circular_bug_ta=
il+0x88/0xac
[  361.442953] [c000000078eab300] [c000000000073d50] .__lock_acquire+0xbe0/=
0xf20
[  361.442981] [c000000078eab3f0] [c000000000074160] .lock_acquire+0xd0/0x1=
1c
[  361.443009] [c000000078eab4b0] [c00000000006173c] .flush_workqueue+0x74/=
0xf0
[  361.443039] [c000000078eab550] [c0000000000617e0] .flush_scheduled_work+=
0x28/0x40
[  361.443073] [c000000078eab5d0] [d0000000004c3dac] .ieee80211softmac_wx_s=
et_essid+0x140/0x204 [ieee80211softmac]
[  361.443109] [c000000078eab680] [c0000000003b5a8c] .ioctl_standard_call+0=
x298/0x3bc
[  361.443139] [c000000078eab790] [c0000000003b5d38] .wext_handle_ioctl+0x1=
88/0x4b4
[  361.443172] [c000000078eab870] [c000000000330d54] .dev_ioctl+0x584/0x5e0
[  361.443203] [c000000078eab990] [c000000000320514] .sock_ioctl+0x2fc/0x33=
c
[  361.443232] [c000000078eaba40] [c0000000000d9568] .do_ioctl+0x5c/0xf8
[  361.443265] [c000000078eabae0] [c0000000000d9a5c] .vfs_ioctl+0x458/0x490
[  361.443296] [c000000078eabb90] [c0000000000d9af0] .sys_ioctl+0x5c/0xa4
[  361.443330] [c000000078eabc50] [c000000000110d88] .do_wireless_ioctl+0x1=
d0/0x224
[  361.443363] [c000000078eabd30] [c00000000010c5ec] .compat_sys_ioctl+0x3e=
0/0x470
[  361.443396] [c000000078eabe30] [c0000000000086d0] syscall_exit+0x0/0x40

We really need to get lockdep ported to ppc32...

johannes

--=-OnmP5BBWgJXi0cHMn/zX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGslLL/ETPhpq3jKURAtv6AJ0UT9wd9cRGQj3VfscWszJiaHuPFgCeJwQs
c5BJ6OeRuUXkKOhr0MCL94w=
=8tGB
-----END PGP SIGNATURE-----

--=-OnmP5BBWgJXi0cHMn/zX--

