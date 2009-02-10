Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBJQO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 11:14:27 -0500
Subject: lock inversion with regulatory code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vCFAqBhwXvHTCASOA7NA"
Date: Tue, 10 Feb 2009 17:13:53 +0100
Message-Id: <1234282434.4229.9.camel@johannes.local> (sfid-20090210_171432_215414_565547CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vCFAqBhwXvHTCASOA7NA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm getting this lockdep report -- the problem is that zd1211 calls
regulatory_hint within the rtnl (because it's within ieee80211_open),
but all cfg80211 locking so far has been the other way around.

Not sure how to fix it, here are a couple of possibilities:
 (1) invert all cfg80211 locking, i.e. do rtnl_lock() around everything
     in each nl80211 handler
 (2) defer regulatory hints and treat them outside of the context of
     regulatory_hint() (use schedule_work or so)
 (3) disallow doing regulatory hints from _open()


[  463.861339] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  463.870606] [ INFO: possible circular locking dependency detected ]
[  463.870606] 2.6.29-rc4-wl-13559-g0416c58-dirty #40
[  463.870606] -------------------------------------------------------
[  463.870606] iw/4598 is trying to acquire lock:
[  463.870606]  (rtnl_mutex){--..}, at: [<ffffffff805013e2>] rtnl_lock+0x12=
/0x20
[  463.870606]=20
[  463.870606] but task is already holding lock:
[  463.870606]  (&drv->mtx){--..}, at: [<ffffffffa0352991>] cfg80211_get_de=
v_from_ifindex+0x61/0xa0 [cfg80211]
[  463.870606]=20
[  463.870606] which lock already depends on the new lock.
[  463.870606]=20
[  463.870606]=20
[  463.870606] the existing dependency chain (in reverse order) is:
[  463.870606]=20
[  463.870606] -> #2 (&drv->mtx){--..}:
[  463.870606]        [<ffffffff80273e47>] check_prev_add+0x3b7/0x770
[  463.870606]        [<ffffffff80274806>] validate_chain+0x606/0x6c0
[  463.870606]        [<ffffffff80274cff>] __lock_acquire+0x43f/0xa10
[  463.870606]        [<ffffffff80275361>] lock_acquire+0x91/0xc0
[  463.870606]        [<ffffffff805b431c>] mutex_lock_nested+0xec/0x380
[  463.870606]        [<ffffffffa0352991>] cfg80211_get_dev_from_ifindex+0x=
61/0xa0 [cfg80211]
[  463.870606]        [<ffffffffa0358dd5>] nl80211_dump_station+0xd5/0x1c0 =
[cfg80211]
[  463.870606]        [<ffffffff80510c74>] netlink_dump+0x64/0x1f0
[  463.870606]        [<ffffffff80511b65>] netlink_dump_start+0x175/0x1a0
[  463.870606]        [<ffffffff80514868>] genl_rcv_msg+0x118/0x1f0
[  463.870606]        [<ffffffff80513529>] netlink_rcv_skb+0x89/0xb0
[  463.870606]        [<ffffffff80514739>] genl_rcv+0x29/0x40
[  463.870606]        [<ffffffff80512f54>] netlink_unicast+0x2d4/0x2f0
[  463.870606]        [<ffffffff80513153>] netlink_sendmsg+0x1e3/0x2e0
[  463.870606]        [<ffffffff804e4a4f>] sock_sendmsg+0xdf/0x110
[  463.870606]        [<ffffffff804e4c09>] sys_sendmsg+0x189/0x320
[  463.870606]        [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[  463.870606]        [<ffffffffffffffff>] 0xffffffffffffffff
[  463.870606]=20
[  463.870606] -> #1 (cfg80211_drv_mutex){--..}:
[  463.870606]        [<ffffffff80273e47>] check_prev_add+0x3b7/0x770
[  463.870606]        [<ffffffff80274806>] validate_chain+0x606/0x6c0
[  463.870606]        [<ffffffff80274cff>] __lock_acquire+0x43f/0xa10
[  463.870606]        [<ffffffff80275361>] lock_acquire+0x91/0xc0
[  463.870606]        [<ffffffff805b431c>] mutex_lock_nested+0xec/0x380
[  463.870606]        [<ffffffffa0354ba0>] regulatory_hint+0x20/0x80 [cfg80=
211]
[  463.870606]        [<ffffffffa03ab1c0>] zd_mac_init_hw+0x100/0x110 [zd12=
11rw]
[  463.870606]        [<ffffffffa03ad4dd>] zd_usb_init_hw+0x5d/0xa0 [zd1211=
rw]
[  463.870606]        [<ffffffffa03aa50b>] zd_op_start+0x2b/0x110 [zd1211rw=
]
[  463.870606]        [<ffffffffa0373657>] ieee80211_open+0x307/0x8e0 [mac8=
0211]
[  463.870606]        [<ffffffff804f7292>] dev_open+0x92/0xf0
[  463.870606]        [<ffffffff804f6b9d>] dev_change_flags+0x9d/0x1e0
[  463.870606]        [<ffffffff805000cb>] do_setlink+0x2db/0x470
[  463.870606]        [<ffffffff80501aa4>] rtnl_newlink+0x434/0x4f0
[  463.870606]        [<ffffffff805015bd>] rtnetlink_rcv_msg+0x18d/0x240
[  463.870606]        [<ffffffff80513529>] netlink_rcv_skb+0x89/0xb0
[  463.870606]        [<ffffffff80501419>] rtnetlink_rcv+0x29/0x40
[  463.870606]        [<ffffffff80512f54>] netlink_unicast+0x2d4/0x2f0
[  463.870606]        [<ffffffff80513153>] netlink_sendmsg+0x1e3/0x2e0
[  463.870606]        [<ffffffff804e4a4f>] sock_sendmsg+0xdf/0x110
[  463.870606]        [<ffffffff804e4c09>] sys_sendmsg+0x189/0x320
[  463.870606]        [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[  463.870606]        [<ffffffffffffffff>] 0xffffffffffffffff
[  463.870606]=20
[  463.870606] -> #0 (rtnl_mutex){--..}:
[  463.870606]        [<ffffffff80273ae7>] check_prev_add+0x57/0x770
[  463.870606]        [<ffffffff80274806>] validate_chain+0x606/0x6c0
[  463.870606]        [<ffffffff80274cff>] __lock_acquire+0x43f/0xa10
[  463.870606]        [<ffffffff80275361>] lock_acquire+0x91/0xc0
[  463.870606]        [<ffffffff805b431c>] mutex_lock_nested+0xec/0x380
[  463.870606]        [<ffffffff805013e2>] rtnl_lock+0x12/0x20
[  463.870606]        [<ffffffffa0358e06>] nl80211_dump_station+0x106/0x1c0=
 [cfg80211]
[  463.870606]        [<ffffffff80510c74>] netlink_dump+0x64/0x1f0
[  463.870606]        [<ffffffff80511b65>] netlink_dump_start+0x175/0x1a0
[  463.870606]        [<ffffffff80514868>] genl_rcv_msg+0x118/0x1f0
[  463.870606]        [<ffffffff80513529>] netlink_rcv_skb+0x89/0xb0
[  463.870606]        [<ffffffff80514739>] genl_rcv+0x29/0x40
[  463.870606]        [<ffffffff80512f54>] netlink_unicast+0x2d4/0x2f0
[  463.870606]        [<ffffffff80513153>] netlink_sendmsg+0x1e3/0x2e0
[  463.870606]        [<ffffffff804e4a4f>] sock_sendmsg+0xdf/0x110
[  463.870606]        [<ffffffff804e4c09>] sys_sendmsg+0x189/0x320
[  463.870606]        [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[  463.870606]        [<ffffffffffffffff>] 0xffffffffffffffff
[  463.870606]=20
[  463.870606] other info that might help us debug this:
[  463.870606]=20
[  463.870606] 2 locks held by iw/4598:
[  463.870606]  #0:  (genl_mutex){--..}, at: [<ffffffff80510c5b>] netlink_d=
ump+0x4b/0x1f0
[  463.870606]  #1:  (&drv->mtx){--..}, at: [<ffffffffa0352991>] cfg80211_g=
et_dev_from_ifindex+0x61/0xa0 [cfg80211]
[  463.870606]=20
[  463.870606] stack backtrace:
[  463.870606] Pid: 4598, comm: iw Not tainted 2.6.29-rc4-wl-13559-g0416c58=
-dirty #40
[  463.870606] Call Trace:
[  463.870606]  [<ffffffff80273590>] print_circular_bug_tail+0xe0/0xf0
[  463.870606]  [<ffffffff80273ae7>] check_prev_add+0x57/0x770
[  463.870606]  [<ffffffff80274806>] validate_chain+0x606/0x6c0
[  463.870606]  [<ffffffff80274cff>] __lock_acquire+0x43f/0xa10
[  463.870606]  [<ffffffff80275361>] lock_acquire+0x91/0xc0
[  463.870606]  [<ffffffff805013e2>] ? rtnl_lock+0x12/0x20
[  463.870606]  [<ffffffff805b431c>] mutex_lock_nested+0xec/0x380
[  463.870606]  [<ffffffff805013e2>] ? rtnl_lock+0x12/0x20
[  463.870606]  [<ffffffff805013e2>] ? rtnl_lock+0x12/0x20
[  463.870606]  [<ffffffff805013e2>] rtnl_lock+0x12/0x20
[  463.870606]  [<ffffffffa0358e06>] nl80211_dump_station+0x106/0x1c0 [cfg8=
0211]
[  463.870606]  [<ffffffff80510c5b>] ? netlink_dump+0x4b/0x1f0
[  463.870606]  [<ffffffff80510c74>] netlink_dump+0x64/0x1f0
[  463.870606]  [<ffffffff80511b65>] netlink_dump_start+0x175/0x1a0
[  463.870606]  [<ffffffff80514868>] genl_rcv_msg+0x118/0x1f0
[  463.870606]  [<ffffffff8051472a>] ? genl_rcv+0x1a/0x40
[  463.870606]  [<ffffffff8051472a>] ? genl_rcv+0x1a/0x40
[  463.870606]  [<ffffffff80514750>] ? genl_rcv_msg+0x0/0x1f0
[  463.870606]  [<ffffffff80513529>] netlink_rcv_skb+0x89/0xb0
[  463.870606]  [<ffffffff80514739>] genl_rcv+0x29/0x40
[  463.870606]  [<ffffffff80512f54>] netlink_unicast+0x2d4/0x2f0
[  463.870606]  [<ffffffff804ed68e>] ? __alloc_skb+0x6e/0x140
[  463.870606]  [<ffffffff80513153>] netlink_sendmsg+0x1e3/0x2e0
[  463.870606]  [<ffffffff804e4a4f>] sock_sendmsg+0xdf/0x110
[  463.870606]  [<ffffffff80276083>] ? __lock_release+0x93/0x1c0
[  463.870606]  [<ffffffff8025f7b0>] ? autoremove_wake_function+0x0/0x40
[  463.870606]  [<ffffffff8026fe34>] ? get_lock_stats+0x34/0x70
[  463.870606]  [<ffffffff803f5444>] ? __up_read+0x84/0xb0
[  463.870606]  [<ffffffff805b6065>] ? _spin_unlock_irqrestore+0x65/0x80
[  463.870606]  [<ffffffff80272f82>] ? trace_hardirqs_on_caller+0x182/0x1e0
[  463.870606]  [<ffffffff804e3a8b>] ? move_addr_to_kernel+0x2b/0x40
[  463.870606]  [<ffffffff804eeb5f>] ? verify_iovec+0x3f/0xe0
[  463.870606]  [<ffffffff804e4c09>] sys_sendmsg+0x189/0x320
[  463.870606]  [<ffffffff802ebe60>] ? __d_free+0x40/0x60
[  463.870606]  [<ffffffff802f404a>] ? mntput_no_expire+0x2a/0x170
[  463.870606]  [<ffffffff802ebf27>] ? d_kill+0x47/0x60
[  463.870606]  [<ffffffff805b6e13>] ? error_sti+0x5/0x6
[  463.870606]  [<ffffffff80272f82>] ? trace_hardirqs_on_caller+0x182/0x1e0
[  463.870606]  [<ffffffff805b5a0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  463.870606]  [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b


--=-vCFAqBhwXvHTCASOA7NA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkae+AAoJEKVg1VMiehFYMMwQAI+jaJFYNAavOoWh6qkOmgOA
MUhMhWXXE92YihfVjRAM0DbjuK7k5p4eHpDT5mvena0AuIIaB/fwXK4EjfO41j7Q
Pk6apIcW+5ShcBeov7MKtU4RnZny2gESddP2YK6Usg7ZJu0FatMsPmob+oSXkpnR
4UTy2KFO6SaO34C/NIzfocprfYrQDEptJg6uNCtrXUnShHCdp/tWpk77C9qelDLo
zl5VG6V8OxJKeLlhB9MeSCa6awcQP2EBsksgeMsbycHOxMkgZggU6qO+SShLq69p
1q9YgScwVpwE+lIYgTYfUm8cP0/P2POuKdaZLySlK2mbfIWEjcwDKs4aJmBR4N8P
iuhBRjis/N1UyXrxqwDn/swLWZPve1b2Qdx/KBmlkuST6xzEhVpAxpe9lTGsYcKp
KZSj2r/hvtlsg0c6cj9q5gCdNbFDS7XqOoJbnORVl3pIRWGEnpvC5E49m/yi4QDi
X9cixKCxznaMmZWrI4b1YrquLWBl34R3jw1C9VcpevdErcJuDGvFUUB0kg9jJZfB
/f+ZmYeud9ly+QiRNE4alq+NMsRrrss3SysgM7yVVfAUIUxK/2fsWScJ0xBRcs/3
meL3lTFP5nPy/YfMra5zyNudWhKCSwV2kixIy82V52MLfEGXpGUKD5s3zY2+8wC6
/tSgjGzw7eQHwbittEby
=tBpB
-----END PGP SIGNATURE-----

--=-vCFAqBhwXvHTCASOA7NA--

