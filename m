Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZDVPVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 11:21:51 -0400
Subject: ar9170 lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: chunkeey <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DzgcsbNRqenJXbeCD2Z6"
Date: Wed, 22 Apr 2009 17:21:15 +0200
Message-Id: <1240413675.5198.0.camel@johannes.local> (sfid-20090422_172210_312240_0A2EED3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DzgcsbNRqenJXbeCD2Z6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Got this -- don't think it's related to my patches.

[  255.700902] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  255.700907] [ INFO: possible circular locking dependency detected ]
[  255.700911] 2.6.30-rc2-wl-21724-g42dd251-dirty #5
[  255.700913] -------------------------------------------------------
[  255.700917] khubd/1305 is trying to acquire lock:
[  255.700920]  (&(&ar->tx_status_janitor)->work){+.+...}, at: [<ffffffff80=
259600>] wait_on_work+0x0/0x140
[  255.700931]=20
[  255.700932] but task is already holding lock:
[  255.700934]  (&ar->mutex){+.+...}, at: [<ffffffffa03412d8>] ar9170_op_st=
op+0x38/0xb0 [ar9170usb]
[  255.700945]=20
[  255.700946] which lock already depends on the new lock.
[  255.700947]=20
[  255.700949]=20
[  255.700950] the existing dependency chain (in reverse order) is:
[  255.700953]=20
[  255.700954] -> #1 (&ar->mutex){+.+...}:
[  255.700959]        [<ffffffff80272615>] check_prev_add+0x365/0x720
[  255.700965]        [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
[  255.700969]        [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
[  255.700974]        [<ffffffff80273b90>] lock_acquire+0x110/0x150
[  255.700978]        [<ffffffff805c2c3b>] mutex_lock_nested+0x6b/0x3e0
[  255.700985]        [<ffffffffa03427c9>] ar9170_tx_status_janitor+0x39/0x=
e0 [ar9170usb]
[  255.700992]        [<ffffffff80258b05>] run_workqueue+0x165/0x2a0
[  255.700996]        [<ffffffff80258cef>] worker_thread+0xaf/0x130
[  255.701000]        [<ffffffff8025d8f6>] kthread+0x56/0x90
[  255.701005]        [<ffffffff8020c6ba>] child_rip+0xa/0x20
[  255.701011]        [<ffffffffffffffff>] 0xffffffffffffffff
[  255.701033]=20
[  255.701034] -> #0 (&(&ar->tx_status_janitor)->work){+.+...}:
[  255.701039]        [<ffffffff80272312>] check_prev_add+0x62/0x720
[  255.701044]        [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
[  255.701049]        [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
[  255.701053]        [<ffffffff80273b90>] lock_acquire+0x110/0x150
[  255.701058]        [<ffffffff8025964b>] wait_on_work+0x4b/0x140
[  255.701062]        [<ffffffff80259784>] __cancel_work_timer+0x44/0x100
[  255.701067]        [<ffffffff8025984d>] cancel_delayed_work_sync+0xd/0x1=
0
[  255.701071]        [<ffffffffa03412e4>] ar9170_op_stop+0x44/0xb0 [ar9170=
usb]
[  255.701079]        [<ffffffffa0206178>] ieee80211_stop+0x2e8/0x690 [mac8=
0211]
[  255.701098]        [<ffffffff80504374>] dev_close+0x84/0xd0
[  255.701103]        [<ffffffff80504405>] rollback_registered+0x45/0x140
[  255.701108]        [<ffffffff8050451d>] unregister_netdevice+0x1d/0x60
[  255.701112]        [<ffffffffa02058f7>] ieee80211_remove_interfaces+0x77=
/0xc0 [mac80211]
[  255.701129]        [<ffffffffa01f70d2>] ieee80211_unregister_hw+0x42/0x1=
00 [mac80211]
[  255.701145]        [<ffffffffa0340399>] ar9170_unregister+0x29/0x40 [ar9=
170usb]
[  255.701153]        [<ffffffffa033fbc2>] ar9170_usb_disconnect+0x32/0x80 =
[ar9170usb]
[  255.701160]        [<ffffffffa0019c65>] usb_unbind_interface+0x65/0x170 =
[usbcore]
[  255.701179]        [<ffffffff80492a32>] __device_release_driver+0x72/0xc=
0
[  255.701185]        [<ffffffff80492b78>] device_release_driver+0x28/0x40
[  255.701189]        [<ffffffff80491e60>] bus_remove_device+0xb0/0xf0
[  255.701194]        [<ffffffff80490028>] device_del+0x138/0x1d0
[  255.701200]        [<ffffffffa0016565>] usb_disable_device+0xb5/0x140 [u=
sbcore]
[  255.701217]        [<ffffffffa001169b>] usb_disconnect+0xbb/0x130 [usbco=
re]
[  255.701234]        [<ffffffffa0011e1e>] hub_port_connect_change+0x1be/0x=
a20 [usbcore]
[  255.701250]        [<ffffffffa00128d3>] hub_events+0x253/0x690 [usbcore]
[  255.701267]        [<ffffffffa0012d4d>] hub_thread+0x3d/0x180 [usbcore]
[  255.701283]        [<ffffffff8025d8f6>] kthread+0x56/0x90
[  255.701288]        [<ffffffff8020c6ba>] child_rip+0xa/0x20
[  255.701293]        [<ffffffffffffffff>] 0xffffffffffffffff
[  255.701298]=20
[  255.701299] other info that might help us debug this:
[  255.701300]=20
[  255.701303] 2 locks held by khubd/1305:
[  255.701306]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8050e9b2>] rtnl_lo=
ck+0x12/0x20
[  255.701315]  #1:  (&ar->mutex){+.+...}, at: [<ffffffffa03412d8>] ar9170_=
op_stop+0x38/0xb0 [ar9170usb]
[  255.701326]=20
[  255.701327] stack backtrace:
[  255.701331] Pid: 1305, comm: khubd Tainted: G        W  2.6.30-rc2-wl-21=
724-g42dd251-dirty #5
[  255.701334] Call Trace:
[  255.701340]  [<ffffffff80271cb0>] print_circular_bug_tail+0xe0/0xf0
[  255.701346]  [<ffffffff80272312>] check_prev_add+0x62/0x720
[  255.701351]  [<ffffffff8020e518>] ? dump_trace+0x128/0x300
[  255.701357]  [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
[  255.701362]  [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
[  255.701368]  [<ffffffff80273b90>] lock_acquire+0x110/0x150
[  255.701373]  [<ffffffff80259600>] ? wait_on_work+0x0/0x140
[  255.701378]  [<ffffffff8025964b>] wait_on_work+0x4b/0x140
[  255.701383]  [<ffffffff80259600>] ? wait_on_work+0x0/0x140
[  255.701389]  [<ffffffff8026ecaa>] ? get_lock_stats+0x2a/0x60
[  255.701394]  [<ffffffff80270ce8>] ? mark_held_locks+0x68/0x90
[  255.701400]  [<ffffffff805c2f1d>] ? mutex_lock_nested+0x34d/0x3e0
[  255.701406]  [<ffffffff80271065>] ? trace_hardirqs_on_caller+0x165/0x1c0
[  255.701412]  [<ffffffff805c2eb0>] ? mutex_lock_nested+0x2e0/0x3e0
[  255.701420]  [<ffffffffa03412d8>] ? ar9170_op_stop+0x38/0xb0 [ar9170usb]
[  255.701425]  [<ffffffff80259970>] ? flush_workqueue+0x0/0xc0
[  255.701431]  [<ffffffff80259784>] __cancel_work_timer+0x44/0x100
[  255.701436]  [<ffffffff8025984d>] cancel_delayed_work_sync+0xd/0x10
[  255.701444]  [<ffffffffa03412e4>] ar9170_op_stop+0x44/0xb0 [ar9170usb]
[  255.701462]  [<ffffffffa0206178>] ieee80211_stop+0x2e8/0x690 [mac80211]
[  255.701480]  [<ffffffffa0205f11>] ? ieee80211_stop+0x81/0x690 [mac80211]
[  255.701487]  [<ffffffff80504374>] dev_close+0x84/0xd0
[  255.701492]  [<ffffffff80504405>] rollback_registered+0x45/0x140
[  255.701497]  [<ffffffff8050451d>] unregister_netdevice+0x1d/0x60
[  255.701514]  [<ffffffffa02058f7>] ieee80211_remove_interfaces+0x77/0xc0 =
[mac80211]
[  255.701532]  [<ffffffffa01f70d2>] ieee80211_unregister_hw+0x42/0x100 [ma=
c80211]
[  255.701540]  [<ffffffffa0340399>] ar9170_unregister+0x29/0x40 [ar9170usb=
]
[  255.701548]  [<ffffffffa033fbc2>] ar9170_usb_disconnect+0x32/0x80 [ar917=
0usb]
[  255.701567]  [<ffffffffa0019c65>] usb_unbind_interface+0x65/0x170 [usbco=
re]
[  255.701574]  [<ffffffff80492a32>] __device_release_driver+0x72/0xc0
[  255.701579]  [<ffffffff80492b78>] device_release_driver+0x28/0x40
[  255.701585]  [<ffffffff80491e60>] bus_remove_device+0xb0/0xf0
[  255.701591]  [<ffffffff80490028>] device_del+0x138/0x1d0
[  255.701608]  [<ffffffffa0016565>] usb_disable_device+0xb5/0x140 [usbcore=
]
[  255.701627]  [<ffffffffa001169b>] usb_disconnect+0xbb/0x130 [usbcore]
[  255.701645]  [<ffffffffa0011e1e>] hub_port_connect_change+0x1be/0xa20 [u=
sbcore]
[  255.701652]  [<ffffffff802d761c>] ? kfree+0x11c/0x1b0
[  255.701658]  [<ffffffff80271065>] ? trace_hardirqs_on_caller+0x165/0x1c0
[  255.701663]  [<ffffffff802710cd>] ? trace_hardirqs_on+0xd/0x10
[  255.701681]  [<ffffffffa001000a>] ? usb_ep0_reinit+0x1a/0x50 [usbcore]
[  255.701700]  [<ffffffffa0017302>] ? usb_control_msg+0x172/0x1a0 [usbcore=
]
[  255.701718]  [<ffffffffa00128d3>] hub_events+0x253/0x690 [usbcore]
[  255.701736]  [<ffffffffa0012d4d>] hub_thread+0x3d/0x180 [usbcore]
[  255.701742]  [<ffffffff8025ddf0>] ? autoremove_wake_function+0x0/0x40
[  255.701760]  [<ffffffffa0012d10>] ? hub_thread+0x0/0x180 [usbcore]
[  255.701766]  [<ffffffff8025d8f6>] kthread+0x56/0x90
[  255.701772]  [<ffffffff8020c6ba>] child_rip+0xa/0x20
[  255.701777]  [<ffffffff8020c080>] ? restore_args+0x0/0x30
[  255.701783]  [<ffffffff8025d8a0>] ? kthread+0x0/0x90
[  255.701788]  [<ffffffff8020c6b0>] ? child_rip+0x0/0x20


--=-DzgcsbNRqenJXbeCD2Z6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7zXmAAoJEKVg1VMiehFYrPwQAL0wa9YjFL1O/Lj6AL9UMq0y
fRpb2EeRj/ZyT+3TQi/h3i3Qd1iVSh/xW+/n7g9rhfaPGQ9349KsJRE9NfdgiICy
aXyYfEfr1R5j5Nx1jnVREiYCf04p91bTIsju9nJ6Er5m8WG3ahiiYN9go001XhFV
V7ogUbq9PaGsCm6pIaxd/fhH/Oli0cipSeLizGBaXNaHPXYdL5pYWAkMXLpyxCtU
3gFrq3yMJ1slg7EshSQwsbwyfRuScMSxtbO+QVCelli9AKIcCumJlwQirya7Hk92
MSY0gY4JNrsBNZJqFzwjvi3Rp8zGQahc+vUSjP2GzvRDEMTtFjaJMxfwTypq+95y
17P+m/RhehbFYrb6NxkDUJwXJuaYigRw118ek/lPg1csrVqb78yTn5egvt3DpXve
WsFkPG8iyCVvqHxtfit7dl+GOIWMhXStlVrXlObDyuM+N9Ptye/6f+mrEt2HkR86
Mv07Wowut+fDxCpfjp6yXGONm7/9jZkLcMdqvlQuJE2W6c8cMzm1kG1jxXgn0Hkj
cxmLXRy2kxb235SphQc4QICfngAxSLlES/DQphR1FMnVh5bdvDGZuHwrdrnVha/D
D9QTA9Y6ygn6AN2bprvqd+rsEJQosoZoY8bwlNU3u1UfBbDtkcQCWl1UyCMKn0F/
oQEmxv8t0U65zfANR6XC
=5GBV
-----END PGP SIGNATURE-----

--=-DzgcsbNRqenJXbeCD2Z6--

