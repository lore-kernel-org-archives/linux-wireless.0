Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:41298 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbYDCOlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 10:41:31 -0400
Received: by rn-out-0910.google.com with SMTP id e24so2070784rng.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 07:41:29 -0700 (PDT)
Message-ID: <a44ae5cd0804030741jc9c7aebx21a7635e827b190f@mail.gmail.com> (sfid-20080403_154138_679216_55BDB49E)
Date: Thu, 3 Apr 2008 10:41:28 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: 2.6.25-rc8-mm1 -- INFO: possible circular locking dependency detected (while using iw to debug a wireless issue)
Cc: "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>,
	"Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After collecting the wireshark log, I found this in my messages log:

Apr  3 09:22:12 whirligig kernel: [ 3987.336200]
=======================================================
Apr  3 09:22:12 whirligig kernel: [ 3987.336215] [ INFO: possible
circular locking dependency detected ]
Apr  3 09:22:12 whirligig kernel: [ 3987.336222] 2.6.25-rc8-mm1 #15
Apr  3 09:22:12 whirligig kernel: [ 3987.336227]
-------------------------------------------------------
Apr  3 09:22:12 whirligig kernel: [ 3987.336233] iw/9417 is trying to
acquire lock:
Apr  3 09:22:12 whirligig kernel: [ 3987.336630]  (genl_mutex){--..},
at: [ctrl_dumpfamily+0x37/0xda] ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.336654]
Apr  3 09:22:12 whirligig kernel: [ 3987.336656] but task is already
holding lock:
Apr  3 09:22:12 whirligig kernel: [ 3987.336661]
(nlk->cb_mutex){--..}, at: [netlink_dump+0x39/0x22e]
netlink_dump+0x39/0x22e
Apr  3 09:22:12 whirligig kernel: [ 3987.336682]
Apr  3 09:22:12 whirligig kernel: [ 3987.336684] which lock already
depends on the new lock.
Apr  3 09:22:12 whirligig kernel: [ 3987.336687]
Apr  3 09:22:12 whirligig kernel: [ 3987.336693]
Apr  3 09:22:12 whirligig kernel: [ 3987.336695] the existing
dependency chain (in reverse order) is:
Apr  3 09:22:12 whirligig kernel: [ 3987.336703]
Apr  3 09:22:12 whirligig kernel: [ 3987.336704] -> #1 (nlk->cb_mutex){--..}:
Apr  3 09:22:12 whirligig kernel: [ 3987.336717]
[__lock_acquire+0xa02/0xbaf] __lock_acquire+0xa02/0xbaf
Apr  3 09:22:12 whirligig kernel: [ 3987.336746]
[lock_acquire+0x76/0x9d] lock_acquire+0x76/0x9d
Apr  3 09:22:12 whirligig kernel: [ 3987.336772]
[snd_mixer_oss:mutex_lock_nested+0xd5/0x67b]
mutex_lock_nested+0xd5/0x274
Apr  3 09:22:12 whirligig kernel: [ 3987.336796]
[netlink_dump_start+0xbd/0x15a] netlink_dump_start+0xbd/0x15a
Apr  3 09:22:12 whirligig kernel: [ 3987.336821]
[genl_rcv_msg+0x9d/0x13a] genl_rcv_msg+0x9d/0x13a
Apr  3 09:22:12 whirligig kernel: [ 3987.336846]
[netlink_rcv_skb+0x30/0x75] netlink_rcv_skb+0x30/0x75
Apr  3 09:22:12 whirligig kernel: [ 3987.336874]
[genl_rcv+0x1e/0x2e] genl_rcv+0x1e/0x2e
Apr  3 09:22:12 whirligig kernel: [ 3987.336899]
[cfg80211:netlink_unicast+0x1c1/0x1867] netlink_unicast+0x1c1/0x293
Apr  3 09:22:12 whirligig kernel: [ 3987.336925]
[netlink_sendmsg+0x21f/0x22c] netlink_sendmsg+0x21f/0x22c
Apr  3 09:22:12 whirligig kernel: [ 3987.336950]
[sock_sendmsg+0xca/0xe1] sock_sendmsg+0xca/0xe1
Apr  3 09:22:12 whirligig kernel: [ 3987.336977]
[sys_sendmsg+0x14d/0x1a8] sys_sendmsg+0x14d/0x1a8
Apr  3 09:22:12 whirligig kernel: [ 3987.337003]
[sys_socketcall+0x163/0x17e] sys_socketcall+0x163/0x17e
Apr  3 09:22:12 whirligig kernel: [ 3987.337028]
[sysenter_past_esp+0x6d/0xc5] sysenter_past_esp+0x6d/0xc5
Apr  3 09:22:12 whirligig kernel: [ 3987.337057]        [<ffffffff>] 0xffffffff
Apr  3 09:22:12 whirligig kernel: [ 3987.337264]
Apr  3 09:22:12 whirligig kernel: [ 3987.337266] -> #0 (genl_mutex){--..}:
Apr  3 09:22:12 whirligig kernel: [ 3987.337280]
[__lock_acquire+0x929/0xbaf] __lock_acquire+0x929/0xbaf
Apr  3 09:22:12 whirligig kernel: [ 3987.337305]
[lock_acquire+0x76/0x9d] lock_acquire+0x76/0x9d
Apr  3 09:22:12 whirligig kernel: [ 3987.337332]
[snd_mixer_oss:mutex_lock_nested+0xd5/0x67b]
mutex_lock_nested+0xd5/0x274
Apr  3 09:22:12 whirligig kernel: [ 3987.337358]
[ctrl_dumpfamily+0x37/0xda] ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.337384]
[netlink_dump+0x51/0x22e] netlink_dump+0x51/0x22e
Apr  3 09:22:12 whirligig kernel: [ 3987.337409]
[netlink_recvmsg+0x156/0x203] netlink_recvmsg+0x156/0x203
Apr  3 09:22:12 whirligig kernel: [ 3987.337435]
[sock_recvmsg+0xd1/0xe9] sock_recvmsg+0xd1/0xe9
Apr  3 09:22:12 whirligig kernel: [ 3987.337460]
[sys_recvmsg+0xf2/0x17f] sys_recvmsg+0xf2/0x17f
Apr  3 09:22:12 whirligig kernel: [ 3987.337485]
[sys_socketcall+0x16f/0x17e] sys_socketcall+0x16f/0x17e
Apr  3 09:22:12 whirligig kernel: [ 3987.337511]
[sysenter_past_esp+0x6d/0xc5] sysenter_past_esp+0x6d/0xc5
Apr  3 09:22:12 whirligig kernel: [ 3987.337537]        [<ffffffff>] 0xffffffff
Apr  3 09:22:12 whirligig kernel: [ 3987.337567]
Apr  3 09:22:12 whirligig kernel: [ 3987.337569] other info that might
help us debug this:
Apr  3 09:22:12 whirligig kernel: [ 3987.337572]
Apr  3 09:22:12 whirligig kernel: [ 3987.337579] 1 lock held by iw/9417:
Apr  3 09:22:12 whirligig kernel: [ 3987.337585]  #0:
(nlk->cb_mutex){--..}, at: [netlink_dump+0x39/0x22e]
netlink_dump+0x39/0x22e
Apr  3 09:22:12 whirligig kernel: [ 3987.337609]
Apr  3 09:22:12 whirligig kernel: [ 3987.337611] stack backtrace:
Apr  3 09:22:12 whirligig kernel: [ 3987.337620] Pid: 9417, comm: iw
Not tainted 2.6.25-rc8-mm1 #15
Apr  3 09:22:12 whirligig kernel: [ 3987.337631]
[print_circular_bug_tail+0x5b/0x66] print_circular_bug_tail+0x5b/0x66
Apr  3 09:22:12 whirligig kernel: [ 3987.337649]
[print_circular_bug_header+0xa5/0xb0] ?
print_circular_bug_header+0xa5/0xb0
Apr  3 09:22:12 whirligig kernel: [ 3987.337673]
[__lock_acquire+0x929/0xbaf] __lock_acquire+0x929/0xbaf
Apr  3 09:22:12 whirligig kernel: [ 3987.337701]
[lock_acquire+0x76/0x9d] lock_acquire+0x76/0x9d
Apr  3 09:22:12 whirligig kernel: [ 3987.337718]
[ctrl_dumpfamily+0x37/0xda] ? ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.337737]
[snd_mixer_oss:mutex_lock_nested+0xd5/0x67b]
mutex_lock_nested+0xd5/0x274
Apr  3 09:22:12 whirligig kernel: [ 3987.337750]
[ctrl_dumpfamily+0x37/0xda] ? ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.337767]
[ctrl_dumpfamily+0x37/0xda] ? ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.337788]
[ctrl_dumpfamily+0x37/0xda] ctrl_dumpfamily+0x37/0xda
Apr  3 09:22:12 whirligig kernel: [ 3987.337807]
[netlink_dump+0x51/0x22e] netlink_dump+0x51/0x22e
Apr  3 09:22:12 whirligig kernel: [ 3987.337820]
[mac80211:kfree_skb+0x40/0x45] ? kfree_skb+0x40/0x45
Apr  3 09:22:12 whirligig kernel: [ 3987.337839]
[netlink_recvmsg+0x156/0x203] netlink_recvmsg+0x156/0x203
Apr  3 09:22:12 whirligig kernel: [ 3987.337860]
[sock_sendmsg+0xca/0xe1] ? sock_sendmsg+0xca/0xe1
Apr  3 09:22:12 whirligig kernel: [ 3987.337880]
[sock_recvmsg+0xd1/0xe9] sock_recvmsg+0xd1/0xe9
Apr  3 09:22:12 whirligig kernel: [ 3987.337903]  [<c01313d9>] ?
autoremove_wake_function+0x0/0x30
Apr  3 09:22:12 whirligig kernel: [ 3987.337939]
[snd_pcm_oss:copy_from_user+0x3b/0x236] ? copy_from_user+0x3b/0x5e
Apr  3 09:22:12 whirligig kernel: [ 3987.337959]
[verify_iovec+0x40/0x70] ? verify_iovec+0x40/0x70
Apr  3 09:22:12 whirligig kernel: [ 3987.337979]
[sys_recvmsg+0xf2/0x17f] sys_recvmsg+0xf2/0x17f
Apr  3 09:22:12 whirligig kernel: [ 3987.337997]
[snd_hda_intel:_spin_unlock_irqrestore+0x56/0x6c] ?
_spin_unlock_irqrestore+0x56/0x6c
Apr  3 09:22:12 whirligig kernel: [ 3987.338021]
[paravirt_get_lazy_mode+0xe/0x1b] ? paravirt_get_lazy_mode+0xe/0x1b
Apr  3 09:22:12 whirligig kernel: [ 3987.338040]
[crypto_algapi:kunmap_atomic+0x9e/0x2e8e] ? kunmap_atomic+0x9e/0xbb
Apr  3 09:22:12 whirligig kernel: [ 3987.338061]
[handle_mm_fault+0x7aa/0x7bb] ? handle_mm_fault+0x7aa/0x7bb
Apr  3 09:22:12 whirligig kernel: [ 3987.338100]
[sys_socketcall+0x16f/0x17e] sys_socketcall+0x16f/0x17e
Apr  3 09:22:12 whirligig kernel: [ 3987.338116]
[processor:trace_hardirqs_on+0xf0/0x5d38] ?
trace_hardirqs_on+0xf0/0x12c
Apr  3 09:22:12 whirligig kernel: [ 3987.338138]
[sysenter_past_esp+0x6d/0xc5] sysenter_past_esp+0x6d/0xc5
Apr  3 09:22:12 whirligig kernel: [ 3987.338163]  =======================
