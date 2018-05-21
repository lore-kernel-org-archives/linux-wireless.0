Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26150 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbeEUKKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 06:10:14 -0400
From: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>
To: Eric Biggers <ebiggers3@gmail.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Date: Mon, 21 May 2018 10:10:09 +0000
Message-ID: <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com> (sfid-20180521_121018_405485_7247BA5A)
References: <20180519183345.GA701@sol.localdomain>
In-Reply-To: <20180519183345.GA701@sol.localdomain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Can you provide the following information?
1. The *boot* you mentioned is from clean shutdown or from Sx state?
2. Do you know which MCC the driver is trying to update?
I will appreciate if you could reproduce it with trace-cmd  (recording at least iwlwifi , iwlwifi_msg -and iwlwifi_ucode)
Or if you can't,  just send dmesg  but make sure to set iwlwifi.debug in the kernel parameters to 0x4000

Cheers
Dreyfuss
-----Original Message-----
From: Eric Biggers [mailto:ebiggers3@gmail.com] 
Sent: Saturday, May 19, 2018 9:34 PM
To: linuxwifi <linuxwifi@intel.com>; linux-wireless@vger.kernel.org; Dreyfuss, Haim <haim.dreyfuss@intel.com>; Coelho, Luciano <luciano.coelho@intel.com>; Kalle Valo <kvalo@codeaurora.org>
Subject: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()

Hello,

Using v4.17-rc5, on a laptop with an "Intel Corporation Wireless 3165 (rev 79)"
using the iwlwifi driver, I get a NULL pointer dereference immediately after boot.  Apparently, the 'regdb' variable in net/wireless/reg.c is NULL, yet
reg_query_regdb_wmm() is checking for IS_ERR().  It goes away if I revert commit
77e30e10ee28a5 ("iwlwifi: mvm: query regdb for wmm rule if needed").  The symbolized crash report is:

BUG: unable to handle kernel NULL pointer dereference at 000000000000000a PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP PTI
Modules linked in: kvm_intel kvm irqbypass joydev
CPU: 2 PID: 371 Comm: NetworkManager Tainted: G                T 4.17.0-rc5-00140-g0b449a441dac #5
Hardware name: Dell Inc. Inspiron 15-7568/0M5YMV, BIOS 01.00.00 08/07/2015
RIP: 0010:reg_query_regdb_wmm+0x14/0x160 net/wireless/reg.c:919
RSP: 0018:ffffad458102b4f0 EFLAGS: 00010207
RAX: ffff96a8e7b350a0 RBX: ffff96a8e7b35000 RCX: ffff96a8e7b35638
RDX: ffff96a8e14ee408 RSI: 000000000000143c RDI: ffff96a8e7b35018
RBP: 0000000000000005 R08: 0000000000013088 R09: 0000000000000000
R10: 0000000000000004 R11: 000000000000143c R12: ffffffff93ebd7a0
R13: ffff96a8e14ee400 R14: 0000000000000040 R15: 000000000000000e
FS:  00007f29f1311880(0000) GS:ffff96a8f2500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000000a CR3: 0000000260e9c005 CR4: 00000000003606e0 Call Trace:
 iwl_parse_nvm_mcc_info+0x267/0x4e0 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c:962
 iwl_mvm_get_regdomain+0x67/0xb0 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:311
 iwl_mvm_init_mcc+0x6f/0x1f0 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c:783
 iwl_mvm_up+0x79f/0x840 drivers/net/wireless/intel/iwlwifi/mvm/fw.c:1089
 __iwl_mvm_mac_start+0x225/0x290 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:1108
 iwl_mvm_mac_start+0x4e/0x120 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:1141
 ? inetdev_event+0x72/0x4d0 net/ipv4/devinet.c:1533
 drv_start+0x2d/0x50 net/mac80211/driver-ops.c:26
 ieee80211_do_open+0x453/0x880 net/mac80211/iface.c:558
 __dev_open+0xb4/0x130 net/core/dev.c:1392
 __dev_change_flags+0x1a1/0x210 net/core/dev.c:6955  ? call_netdevice_notifiers net/core/dev.c:1752 [inline]  ? __dev_notify_flags+0x56/0xf0 net/core/dev.c:6993
 dev_change_flags+0x1e/0x60 net/core/dev.c:7024  ? nla_put_ifalias+0x2e/0x90 net/core/rtnetlink.c:1459
 do_setlink+0x656/0xd80 net/core/rtnetlink.c:2362  ? new_slab_objects mm/slub.c:2452 [inline]  ? ___slab_alloc+0x48a/0x560 mm/slub.c:2604  ? memset include/linux/string.h:330 [inline]  ? __nla_reserve+0x38/0x50 lib/nlattr.c:437  ? __nla_put+0xc/0x20 lib/nlattr.c:568  ? nla_put+0x2f/0x40 lib/nlattr.c:627  ? nla_put_u8 include/net/netlink.h:780 [inline]  ? rtnl_xdp_fill+0x172/0x1d0 net/core/rtnetlink.c:1379  ? memset include/linux/string.h:330 [inline]  ? __nla_reserve+0x38/0x50 lib/nlattr.c:437  ? memset include/linux/string.h:330 [inline]  ? __nla_reserve+0x38/0x50 lib/nlattr.c:437  ? inet_fill_link_af+0x1c/0x50 net/ipv4/devinet.c:1738  ? rtnl_newlink+0x793/0x930 net/core/rtnetlink.c:2970  ? spin_unlock_irqrestore include/linux/spinlock.h:365 [inline]  ? __wake_up_common_lock+0x84/0xb0 kernel/sched/wait.c:120  ? rtnetlink_rcv_msg+0x121/0x390 net/core/rtnetlink.c:4646  ? fast_dput fs/dcache.c:716 [inline]  ? dput.part.5+0x92/0x120 fs/dcache.c:837  ? __lookup_slow+0x137/0x160 fs/namei.c:1633  ? rtnl_calcit.isra.14+0x110/0x110 net/core/rtnetlink.c:3188  ? netlink_rcv_skb+0x44/0x110 net/netlink/af_netlink.c:2448  ? netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]  ? netlink_unicast+0x18b/0x230 net/netlink/af_netlink.c:1336  ? netlink_sendmsg+0x1f0/0x3b0 net/netlink/af_netlink.c:1901  ? sock_sendmsg_nosec net/socket.c:629 [inline]  ? sock_sendmsg+0x14/0x20 net/socket.c:639  ? ___sys_sendmsg+0x28e/0x2f0 net/socket.c:2117  ? try_to_wake_up+0x26a/0x360 kernel/sched/core.c:2060  ? __check_object_size+0xf9/0x180 mm/usercopy.c:262  ? rcu_read_unlock include/linux/rcupdate.h:687 [inline]  ? __fget+0x67/0xa0 fs/file.c:697  ? __sys_sendmsg+0x52/0xa0 net/socket.c:2155  ? do_syscall_64+0x43/0xd0 arch/x86/entry/common.c:287  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
Code: ff ff 0f 1f 44 00 00 eb ae 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 4c 8b 0d 89 41 fd 00 49 81 f9 00 f0 ff ff 0f 87 12 01 00 00 <45> 0f b7 41 0a 49 89 d2 b8 c3 ff ff ff 49 8d 51 08 66 45 85 c0
RIP: reg_query_regdb_wmm+0x14/0x160 net/wireless/reg.c:919 RSP: ffffad458102b4f0
CR2: 000000000000000a
---[ end trace 0940319c2377625e ]---
