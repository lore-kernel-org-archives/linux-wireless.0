Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYEPVra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:47:30 -0400
Subject: Re: NULL pointer in mac80211:ieee80211_associate
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <482DFC63.7050908@lwfinger.net>
References: <482DFC63.7050908@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yo3tLkqlzV1DLMUq6/eQ"
Date: Fri, 16 May 2008 23:47:14 +0200
Message-Id: <1210974434.6381.60.camel@johannes.berg> (sfid-20080516_234735_004142_FAB00A7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yo3tLkqlzV1DLMUq6/eQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> I think this report is new. If it is a duplicate, I apologize for any noi=
se.=20

I've definitely not seen it before, thanks.

> The system was last booted at 18:02 on May 15. Until 10:10:58, everything=
=20
> seemed normal. Then a reason 3 deauthentication arrived, and the followin=
g=20
> ensued:

Actually, the deauthentication is what you're sending, see
ieee80211_sta_deauthenticate (in mlme.c). Any idea why it would be sent?
Did you kill wpa_supplicant or something similar?

In any case, we wouldn't expect to get a deauth with reason 15
(WLAN_REASON_4WAY_HANDSHAKE_TIMEOUT) then. Hmm. Maybe that's why
wpa_supplicant was trying to disassociate as well?

Still, we should of course not crash :)

> May 16 10:10:58 larrylap kernel: eth1: deauthenticate(reason=3D3)
> May 16 10:10:58 larrylap kernel: eth1: RX deauthentication from 00:1a:70:=
46:ba:b1 (reason=3D15)
> May 16 10:10:58 larrylap kernel: eth1: deauthenticated
> May 16 10:10:58 larrylap avahi-daemon[3042]: Withdrawing address record f=
or=20
> 192.168.1.122 on eth1.
> May 16 10:10:58 larrylap avahi-daemon[3042]: Leaving mDNS multicast
>   group on interface eth1.IPv4 with address 192.168.1.122.
> May 16 10:10:58 larrylap avahi-daemon[3042]: Interface eth1.IPv4 no longe=
r=20
> relevant for mDNS.
> May 16 10:10:59 larrylap kernel: eth1: authenticate with AP 00:1a:70:46:b=
a:b1
> May 16 10:10:59 larrylap kernel: eth1: RX authentication from=20
> 00:1a:70:46:ba:b1 (alg=3D0 transaction=3D2 status=3D0)
> May 16 10:10:59 larrylap kernel: eth1: authenticated
> May 16 10:10:59 larrylap kernel: eth1: associate with AP 00:1a:70:46:ba:b=
1
> May 16 10:10:59 larrylap kernel: BUG: unable to handle kernel NULL pointe=
r dereference at 00000000000000c0
> May 16 10:10:59 larrylap kernel: IP: [<ffffffffa0159eb1>] :mac80211:ieee8=
0211_associate+0x2ba/0x53e
> May 16 10:10:59 larrylap kernel: PGD b8258067 PUD b8259067 PMD 0
> May 16 10:10:59 larrylap kernel: Oops: 0000 [1] SMP
> May 16 10:10:59 larrylap kernel: CPU 0
> May 16 10:10:59 larrylap kernel: Modules linked in: [...]
> May 16 10:10:59 larrylap kernel: Pid: 1684, comm: b43 Not tainted 2.6.26-=
rc2-wl-07884-g5d3790d-dirty #3
> May 16 10:10:59 larrylap kernel: RIP: 0010:[<ffffffffa0159eb1>] [<fffffff=
fa0159eb1>] :mac80211:ieee80211_associate+0x2ba/0x53e
> May 16 10:10:59 larrylap kernel: RSP: 0018:ffff8100b9fdbb50  EFLAGS: 0001=
0246
> May 16 10:10:59 larrylap kernel: RAX: 0000000000000000 RBX: ffff8100b96ef=
410 RCX: 0000000000000000
> May 16 10:10:59 larrylap kernel: RDX: ffff810037b88000 RSI: 0000000000000=
000 RDI: ffff8100b96ef42e
> May 16 10:10:59 larrylap kernel: RBP: 0000000000000000 R08: 0000000000000=
000 R09: ffff8100b8ee7780
> May 16 10:10:59 larrylap kernel: R10: ffff8100b8a3e480 R11: ffff8100b8a3e=
480 R12: ffff810037b88b90
> May 16 10:10:59 larrylap kernel: R13: ffff8100b8ee7780 R14: ffff8100b96ef=
42c R15: ffffffffa01bbb70
> May 16 10:10:59 larrylap kernel: FS:  00007fab6fcac700(0000) GS:ffffffff8=
054e000(0000) knlGS:00000000f6398b10
> May 16 10:10:59 larrylap kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 0000000=
08005003b
> May 16 10:10:59 larrylap kernel: CR2: 00000000000000c0 CR3: 00000000b8257=
000 CR4: 00000000000006e0
> May 16 10:10:59 larrylap kernel: DR0: 0000000000000000 DR1: 0000000000000=
000 DR2: 0000000000000000
> May 16 10:10:59 larrylap kernel: DR3: 0000000000000000 DR6: 00000000ffff0=
ff0 DR7: 0000000000000400
> May 16 10:10:59 larrylap kernel: Process b43 (pid: 1684, threadinfo ffff8=
100b9fda000, task ffff8100b871e780)
> May 16 10:10:59 larrylap kernel: Stack:  ffffffff8028c3d0 ffff810037b8800=
0 ffffffff8028bdc1 0000000037b88be0
> May 16 10:10:59 larrylap kernel:  ffff810037b88c24 0000000000000000 30373=
a61313a3030 623a61623a36343a
> May 16 10:10:59 larrylap kernel:  ffff8100bb6b0031 ffff8100b9fdbd20 ffff8=
100b878a034 0000000000000002
> May 16 10:10:59 larrylap kernel: Call Trace:
> May 16 10:10:59 larrylap kernel:  [<ffffffff8028c3d0>] kfree+0x1d6/0x1e5
> May 16 10:10:59 larrylap kernel:  [<ffffffff8028bdc1>] kmem_cache_free+0x=
19b/0x1aa
> May 16 10:10:59 larrylap kernel:  [<ffffffffa015a816>] :mac80211:ieee8021=
1_sta_rx_queued_mgmt+0x54b/0xf0b
> May 16 10:10:59 larrylap kernel:  [<ffffffffa0162376>] :mac80211:ieee8021=
1_master_start_xmit+0x3af/0x3cc
> May 16 10:10:59 larrylap kernel:  [<ffffffff802377ef>] local_bh_enable_ip=
+0xd0/0xd7
> May 16 10:10:59 larrylap kernel:  [<ffffffff8024e48c>] mark_held_locks+0x=
58/0x72
> May 16 10:10:59 larrylap kernel:  [<ffffffff803f8fb7>] _spin_unlock_irqre=
store+0x3f/0x46
> May 16 10:10:59 larrylap kernel:  [<ffffffff8024e61c>] trace_hardirqs_on+=
0xef/0x113
> May 16 10:10:59 larrylap kernel:  [<ffffffffa015b912>] :mac80211:ieee8021=
1_sta_work+0xb6/0x738
> May 16 10:10:59 larrylap kernel:  [<ffffffff803f8e94>] _spin_unlock_irq+0=
x24/0x27
> May 16 10:10:59 larrylap kernel:  [<ffffffff8024e61c>] trace_hardirqs_on+=
0xef/0x113
> May 16 10:10:59 larrylap kernel:  [<ffffffffa015b85c>] :mac80211:ieee8021=
1_sta_work+0x0/0x738
> May 16 10:10:59 larrylap kernel:  [<ffffffff8024162b>] run_workqueue+0xe3=
/0x1ec
> May 16 10:10:59 larrylap kernel:  [<ffffffff80242115>] worker_thread+0xdc=
/0xeb
> May 16 10:10:59 larrylap kernel:  [<ffffffff80244b67>] autoremove_wake_fu=
nction+0x0/0x2e
> May 16 10:10:59 larrylap kernel:  [<ffffffff80242039>] worker_thread+0x0/=
0xeb
> May 16 10:10:59 larrylap kernel:  [<ffffffff80244a4b>] kthread+0x47/0x74
> May 16 10:10:59 larrylap kernel:  [<ffffffff803f8921>] trace_hardirqs_on_=
thunk+0x35/0x3a
> May 16 10:10:59 larrylap kernel:  [<ffffffff8020ccf8>] child_rip+0xa/0x12
> May 16 10:10:59 larrylap kernel:  [<ffffffff8020c40f>] restore_args+0x0/0=
x30
> May 16 10:10:59 larrylap kernel:  [<ffffffff802448c2>] kthreadd+0x17f/0x1=
a4
> May 16 10:10:59 larrylap kernel:  [<ffffffff80244a04>] kthread+0x0/0x74
> May 16 10:10:59 larrylap kernel:  [<ffffffff8020ccee>] child_rip+0x0/0x12
> May 16 10:10:59 larrylap kernel:
> May 16 10:10:59 larrylap kernel:
> May 16 10:10:59 larrylap kernel: Code: 00 49 89 c6 49 8b 84 24 b8 00 00 0=
0 49=20
> 8d 7e 02 fc 41 88 46 01 49 8b 8c 24 b8 00 00 00 48 8b 74 24 20 f3 a4 31 f=
6 48=20
> 8b 4c 24 28 <4c> 8b 89 c0 00 00 00 48 c7 44 24 10 00 00 00 00 eb 4a 48 8b=
 5c
> May 16 10:10:59 larrylap kernel: RIP  [<ffffffffa0159eb1>] :mac80211:ieee=
80211_associate+0x2ba/0x53e
> May 16 10:10:59 larrylap kernel: RIP  [<ffffffffa0159eb1>] :mac80211:ieee=
80211_associate+0x2ba/0x53e
> May 16 10:10:59 larrylap kernel:  RSP <ffff8100b9fdbb50>
> May 16 10:10:59 larrylap kernel: CR2: 00000000000000c0
> May 16 10:10:59 larrylap kernel: ---[ end trace 0010c8900b24b09d ]---

I can definitely not place this, though.

Can you try to find out what code this corresponds to?

johannes

--=-yo3tLkqlzV1DLMUq6/eQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC4A4aVg1VMiehFYAQLYsA/+L69D75aoKvlJ6RpTNT7QXqgXecwDbi95
4eWgS4XGT7rXi1s+kq24tYTx6wUSfQYA1SscWhWjgAAcPoejZgVL7QAQlnj8Fy5M
HeKJZgRy8pzETjg8wvt/bOmI+y3hON1BGyKc6D9RFZ1N47euYlEv0do2xTNTSJT6
KzCuVGRfJrkFD+UcpJ9PzWYvmEF+9QxlZ6eC+8HgXuBeyspy4erCWeiNd5RKOjxj
/VP6/u5hqLEnPD2lH4rghh3gEl1cQX5BC8AdgZN1OnwK3wk54BYloZHiA5pSmTUF
jdKOGFmYRwLhZzG3ufNL4Zn3UnCd8+EktpkfESo16fjftwB/tTZWR3r3PkT94MG4
zd23fyOXT8tZ4jnAwes4Q02EoHYI5k8YYL3+7OabjsPKk03KuIAOmOuWmobmUr0m
owC2oeEQpsOfQMAHhUNvhyGZvaUcftFbpaAl288F7v/mijnAxqpTyqAiv7A0eset
CTYdAANkC9wEDac8YTkwNxhmHIfMOktqG6RdfgqDgDJtrN27CMPj/cp4/dj57Wte
TK/bOCK0YRtEtNDwORqrcIYGAAz5oubtMcbtiwtFOSy8jMXt0LY3q/ermR7jzasz
fs1ilpLVp0HSx2Jis/HA8k+hLy1fXSEIT04daLfYmWqZ9mTZx4B5MboDd2dbukyp
8j6i319PLTk=
=P8Sa
-----END PGP SIGNATURE-----

--=-yo3tLkqlzV1DLMUq6/eQ--

