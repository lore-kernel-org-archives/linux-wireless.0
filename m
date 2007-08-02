Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717AbXHCJhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:37:08 -0400
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with  assoc work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708011253.06569.mb@bu3sch.de>
References: <200708011253.06569.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FIFOlbyloZmscLKaXxb2"
Date: Fri, 03 Aug 2007 00:02:07 +0200
Message-Id: <1186092127.4647.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FIFOlbyloZmscLKaXxb2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Adding to my previous mail, this fix is not enough. As you can see
below, it is never safe to call flush_scheduled_work() under rtnl
because some other things running *from* the global events workqueue
acquire the rtnl and hence it we could deadlock against them.

I think the fix would be to use cancel_delayed_work_sync() here instead
of a combination of cancel_delayed_work() and flush_workqueue().

[  130.612315] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  130.612331] [ INFO: possible circular locking dependency detected ]
[  130.612338] 2.6.23-rc1-g05ff0970-dirty #244
[  130.612343] -------------------------------------------------------
[  130.612350] iwconfig/4443 is trying to acquire lock:
[  130.612356]  (events){--..}, at: [<c00000000006170c>] .flush_workqueue+0=
x44/0xf0
[  130.612384]=20
[  130.612385] but task is already holding lock:
[  130.612391]  (rtnl_mutex){--..}, at: [<c0000000003b99c0>] .mutex_lock+0x=
3c/0x58
[  130.612414]=20
[  130.612415] which lock already depends on the new lock.
[  130.612418]=20
[  130.612423]=20
[  130.612424] the existing dependency chain (in reverse order) is:
[  130.612430]=20
[  130.612432] -> #2 (rtnl_mutex){--..}:
[  130.612445]        [<c000000000073e58>] .__lock_acquire+0xce8/0xf20
[  130.612472]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  130.612498]        [<c0000000003b96cc>] .__mutex_lock_slowpath+0x138/0x3=
f0
[  130.612526]        [<c0000000003b99c0>] .mutex_lock+0x3c/0x58
[  130.612553]        [<c00000000033b85c>] .rtnl_lock+0x28/0x44
[  130.612582]        [<c00000000033d8ac>] .linkwatch_event+0x20/0x6c
[  130.612609]        [<c000000000060720>] .run_workqueue+0x16c/0x290
[  130.612636]        [<c000000000061d2c>] .worker_thread+0x13c/0x16c
[  130.612664]        [<c000000000066b98>] .kthread+0x84/0xd4
[  130.612690]        [<c000000000022734>] .kernel_thread+0x4c/0x68
[  130.612721]=20
[  130.612723] -> #1 ((linkwatch_work).work){--..}:
[  130.612737]        [<c000000000073e58>] .__lock_acquire+0xce8/0xf20
[  130.612774]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  130.612801]        [<c000000000060700>] .run_workqueue+0x14c/0x290
[  130.612821]        [<c000000000061d2c>] .worker_thread+0x13c/0x16c
[  130.612886]        [<c000000000066b98>] .kthread+0x84/0xd4
[  130.612961]        [<c000000000022734>] .kernel_thread+0x4c/0x68
[  130.613038]=20
[  130.613040] -> #0 (events){--..}:
[  130.613074]        [<c000000000073d50>] .__lock_acquire+0xbe0/0xf20
[  130.613149]        [<c000000000074160>] .lock_acquire+0xd0/0x11c
[  130.613224]        [<c00000000006173c>] .flush_workqueue+0x74/0xf0
[  130.613303]        [<c0000000000617e0>] .flush_scheduled_work+0x28/0x40
[  130.613377]        [<d0000000004c8dd4>] .ieee80211softmac_wx_set_essid+0=
x168/0x234 [ieee80211softmac]
[  130.613473]        [<c0000000003b5a8c>] .ioctl_standard_call+0x298/0x3bc
[  130.613553]        [<c0000000003b5d38>] .wext_handle_ioctl+0x188/0x4b4
[  130.613625]        [<c000000000330d54>] .dev_ioctl+0x584/0x5e0
[  130.613697]        [<c000000000320514>] .sock_ioctl+0x2fc/0x33c
[  130.613751]        [<c0000000000d9568>] .do_ioctl+0x5c/0xf8
[  130.613827]        [<c0000000000d9a5c>] .vfs_ioctl+0x458/0x490
[  130.613905]        [<c0000000000d9af0>] .sys_ioctl+0x5c/0xa4
[  130.613982]        [<c000000000110d88>] .do_wireless_ioctl+0x1d0/0x224
[  130.614059]        [<c00000000010c5ec>] .compat_sys_ioctl+0x3e0/0x470
[  130.614137]        [<c0000000000086d0>] syscall_exit+0x0/0x40
[  130.614217]=20
[  130.614219] other info that might help us debug this:
[  130.614221]=20
[  130.614232] 1 lock held by iwconfig/4443:
[  130.614242]  #0:  (rtnl_mutex){--..}, at: [<c0000000003b99c0>] .mutex_lo=
ck+0x3c/0x58
[  130.614295]=20
[  130.614297] stack backtrace:
[  130.614307] Call Trace:
[  130.614318] [c00000010c58f0e0] [c00000000000f2e4] .show_stack+0x78/0x1a4=
 (unreliable)
[  130.614358] [c00000010c58f190] [c00000000000f430] .dump_stack+0x20/0x34
[  130.614388] [c00000010c58f210] [c00000000007141c] .print_circular_bug_ta=
il+0x88/0xac
[  130.614421] [c00000010c58f2e0] [c000000000073d50] .__lock_acquire+0xbe0/=
0xf20
[  130.614450] [c00000010c58f3d0] [c000000000074160] .lock_acquire+0xd0/0x1=
1c
[  130.614478] [c00000010c58f490] [c00000000006173c] .flush_workqueue+0x74/=
0xf0
[  130.614505] [c00000010c58f530] [c0000000000617e0] .flush_scheduled_work+=
0x28/0x40
[  130.614533] [c00000010c58f5b0] [d0000000004c8dd4] .ieee80211softmac_wx_s=
et_essid+0x168/0x234 [ieee80211softmac]
[  130.614573] [c00000010c58f680] [c0000000003b5a8c] .ioctl_standard_call+0=
x298/0x3bc
[  130.614606] [c00000010c58f790] [c0000000003b5d38] .wext_handle_ioctl+0x1=
88/0x4b4
[  130.614640] [c00000010c58f870] [c000000000330d54] .dev_ioctl+0x584/0x5e0
[  130.614669] [c00000010c58f990] [c000000000320514] .sock_ioctl+0x2fc/0x33=
c
[  130.614695] [c00000010c58fa40] [c0000000000d9568] .do_ioctl+0x5c/0xf8
[  130.614722] [c00000010c58fae0] [c0000000000d9a5c] .vfs_ioctl+0x458/0x490
[  130.614752] [c00000010c58fb90] [c0000000000d9af0] .sys_ioctl+0x5c/0xa4
[  130.614782] [c00000010c58fc50] [c000000000110d88] .do_wireless_ioctl+0x1=
d0/0x224
[  130.614811] [c00000010c58fd30] [c00000000010c5ec] .compat_sys_ioctl+0x3e=
0/0x470
[  130.614840] [c00000010c58fe30] [c0000000000086d0] syscall_exit+0x0/0x40


--=-FIFOlbyloZmscLKaXxb2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGslRf/ETPhpq3jKURAh0GAJ9Coz3yZ6OQlPiplOHt8WlQxOX3vgCfS30L
cABgMAbXewsfqbEl8VPyjfo=
=xR6N
-----END PGP SIGNATURE-----

--=-FIFOlbyloZmscLKaXxb2--

