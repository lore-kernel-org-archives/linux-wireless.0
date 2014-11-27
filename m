Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:45556 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbaK0LpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 06:45:24 -0500
Date: Thu, 27 Nov 2014 13:45:20 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
Message-ID: <20141127114520.GA18225@w1.fi> (sfid-20141127_124538_369588_69F92058)
References: <1415802405-10002-1-git-send-email-tomasz.bursztyka@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415802405-10002-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2014 at 04:26:45PM +0200, Tomasz Bursztyka wrote:
> Let the other listeners being notified when a new or del interface
> command has been issued, thus reducing later necessary request to be in
> sync with current context.

This seems to trigger a NULL pointer dereference in
nl80211_send_chandef(). See below for logs. Please also note that it
would have been trivial to find this with automated mac80211_hwsim test
setup described here http://buildbot.w1.fi/hwsim/ before this commit was
applied.. This happens every time, e.g., with ap_vlan_open test case.

 
[    6.271676] ------------[ cut here ]------------
[    6.272032] WARNING: CPU: 1 PID: 590 at net/wireless/nl80211.c:2320 nl80211_send_chandef+0x127/0x130()
[    6.272710] CPU: 1 PID: 590 Comm: hostapd Not tainted 3.17.0+ #380
[    6.273162] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    6.273752]  0000000000000009 ffff88001e083918 ffffffff814e6044 ffffffff8108fbe1
[    6.274346]  0000000000000000 ffff88001e083958 ffffffff81040bbc ffff88001e083968
[    6.274924]  ffff88001e0839e0 ffff88001eb20d00 0000000000000000 ffff88001e2088d0
[    6.275502] Call Trace:
[    6.275690]  [<ffffffff814e6044>] dump_stack+0x4e/0x71
[    6.276069]  [<ffffffff8108fbe1>] ? console_unlock+0x1f1/0x4d0
[    6.276498]  [<ffffffff81040bbc>] warn_slowpath_common+0x7c/0xa0
[    6.276939]  [<ffffffff81040cca>] warn_slowpath_null+0x1a/0x20
[    6.277368]  [<ffffffff813f9677>] nl80211_send_chandef+0x127/0x130
[    6.277821]  [<ffffffff813f9a35>] nl80211_send_iface+0x3b5/0x5e0
[    6.278281]  [<ffffffff813f9ccc>] nl80211_del_interface+0x6c/0x520
[    6.278736]  [<ffffffff8131b9a4>] genl_family_rcv_msg+0x194/0x330
[    6.279183]  [<ffffffff8131bb40>] ? genl_family_rcv_msg+0x330/0x330
[    6.279644]  [<ffffffff8131bbce>] genl_rcv_msg+0x8e/0xd0
[    6.280047]  [<ffffffff8131b081>] netlink_rcv_skb+0xb1/0xc0
[    6.280679]  [<ffffffff8131b7ed>] ? genl_rcv+0x1d/0x40
[    6.281251]  [<ffffffff8131b7fc>] genl_rcv+0x2c/0x40
[    6.281797]  [<ffffffff81319786>] netlink_unicast+0x156/0x230
[    6.282355]  [<ffffffff8131a0e0>] netlink_sendmsg+0x320/0x410
[    6.282870]  [<ffffffff812d6eb9>] sock_sendmsg+0x69/0x90
[    6.283343]  [<ffffffff812e5b66>] ? verify_iovec+0x56/0xe0
[    6.283830]  [<ffffffff812d71a8>] ___sys_sendmsg.part.38+0x2c8/0x2e0
[    6.284373]  [<ffffffff810889e0>] ? __lock_acquire+0x430/0xbd0
[    6.284882]  [<ffffffff81089aa0>] ? lock_release_non_nested+0xa0/0x300
[    6.285425]  [<ffffffff8111b18c>] ? might_fault+0x8c/0xa0
[    6.285898]  [<ffffffff8111b143>] ? might_fault+0x43/0xa0
[    6.286384]  [<ffffffff812d892e>] __sys_sendmsg+0x4e/0x90
[    6.286849]  [<ffffffff812d897e>] SyS_sendmsg+0xe/0x10
[    6.287312]  [<ffffffff814f0be9>] system_call_fastpath+0x12/0x17
[    6.287816] ---[ end trace 144e876be0145ff5 ]---
[    6.288265] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[    6.288937] IP: [<ffffffff813f958a>] nl80211_send_chandef+0x3a/0x130
[    6.289356] PGD 1df2b067 PUD 1df2e067 PMD 0 
[    6.289661] Oops: 0000 [#1] PREEMPT SMP 
[    6.289944] CPU: 1 PID: 590 Comm: hostapd Tainted: G        W      3.17.0+ #380
[    6.290038] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    6.290038] task: ffff88001e1a2040 ti: ffff88001e080000 task.ti: ffff88001e080000
[    6.290038] RIP: 0010:[<ffffffff813f958a>]  [<ffffffff813f958a>] nl80211_send_chandef+0x3a/0x130
[    6.290038] RSP: 0018:ffff88001e083978  EFLAGS: 00010296
[    6.290038] RAX: 0000000000000000 RBX: ffff88001e0839e0 RCX: ffff88001e083984
[    6.290038] RDX: 0000000000000004 RSI: 0000000000000026 RDI: ffff88001eb20d00
[    6.290038] RBP: ffff88001e0839a8 R08: 0000000000000001 R09: 0000000000000001
[    6.290038] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88001eb20d00
[    6.290038] R13: 0000000000000000 R14: ffff88001e2088d0 R15: ffff88001deb0000
[    6.290038] FS:  00007fc7f9aac740(0000) GS:ffff88001fc80000(0000) knlGS:0000000000000000
[    6.290038] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.290038] CR2: 0000000000000004 CR3: 000000001df28000 CR4: 00000000000006a0
[    6.290038] Stack:
[    6.290038]  0000000000000246 0000000000000000 ffff88001e0839a8 0000000000000246
[    6.290038]  ffff88001eb20d00 ffff88001de50014 ffff88001e083a28 ffffffff813f9a35
[    6.290038]  00000000000000d0 ffff88001deb0420 000000030000000c 0000001b00000004
[    6.290038] Call Trace:
[    6.290038]  [<ffffffff813f9a35>] nl80211_send_iface+0x3b5/0x5e0
[    6.290038]  [<ffffffff813f9ccc>] nl80211_del_interface+0x6c/0x520
[    6.290038]  [<ffffffff8131b9a4>] genl_family_rcv_msg+0x194/0x330
[    6.290038]  [<ffffffff8131bb40>] ? genl_family_rcv_msg+0x330/0x330
[    6.290038]  [<ffffffff8131bbce>] genl_rcv_msg+0x8e/0xd0
[    6.290038]  [<ffffffff8131b081>] netlink_rcv_skb+0xb1/0xc0
[    6.290038]  [<ffffffff8131b7ed>] ? genl_rcv+0x1d/0x40
[    6.290038]  [<ffffffff8131b7fc>] genl_rcv+0x2c/0x40
[    6.290038]  [<ffffffff81319786>] netlink_unicast+0x156/0x230
[    6.290038]  [<ffffffff8131a0e0>] netlink_sendmsg+0x320/0x410
[    6.290038]  [<ffffffff812d6eb9>] sock_sendmsg+0x69/0x90
[    6.290038]  [<ffffffff812e5b66>] ? verify_iovec+0x56/0xe0
[    6.290038]  [<ffffffff812d71a8>] ___sys_sendmsg.part.38+0x2c8/0x2e0
[    6.290038]  [<ffffffff810889e0>] ? __lock_acquire+0x430/0xbd0
[    6.290038]  [<ffffffff81089aa0>] ? lock_release_non_nested+0xa0/0x300
[    6.290038]  [<ffffffff8111b18c>] ? might_fault+0x8c/0xa0
[    6.290038]  [<ffffffff8111b143>] ? might_fault+0x43/0xa0
[    6.290038]  [<ffffffff812d892e>] __sys_sendmsg+0x4e/0x90
[    6.290038]  [<ffffffff812d897e>] SyS_sendmsg+0xe/0x10
[    6.290038]  [<ffffffff814f0be9>] system_call_fastpath+0x12/0x17
[    6.290038] Code: 48 89 f7 48 89 f3 48 83 ec 20 e8 12 9a 02 00 84 c0 0f 84 f0 00 00 00 48 8b 03 48 8d 4d dc ba 04 00 00 00 be 26 00 00 00 4c 89 e7 <0f> b7 40 04 89 45 dc e8 5a 7b e0 ff 85 c0 0f 85 ba 00 00 00 8b 
[    6.290038] RIP  [<ffffffff813f958a>] nl80211_send_chandef+0x3a/0x130
[    6.290038]  RSP <ffff88001e083978>
[    6.290038] CR2: 0000000000000004
[    6.307574] ---[ end trace 144e876be0145ff6 ]---
[    6.308157] Kernel panic - not syncing: Fatal exception

-- 
Jouni Malinen                                            PGP id EFC895FA
