Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:55567 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdJaMdS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 08:33:18 -0400
Received: by mail-pg0-f68.google.com with SMTP id 15so14522834pgc.12
        for <linux-wireless@vger.kernel.org>; Tue, 31 Oct 2017 05:33:18 -0700 (PDT)
Date: Tue, 31 Oct 2017 18:02:59 +0530
From: Anil Nair <anilcoll90@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: PROBLEM: Issue with wireless driver after resume from suspend.
Message-ID: <20171031123259.GA3435@gmail.com> (sfid-20171031_133723_043787_28F4D5EA)
References: <20171031065122.GA24662@gmail.com>
 <1509434604.4492.192.camel@coelho.fi>
 <87a807sopr.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a807sopr.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 31, 2017 at 10:31:28AM +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> >> I am having a issue with the wireless driver in my laptop. Attached
> >> information
> >> pertaining to the issue.
> >
> > It would be useful to specify which wireless card you are using.  In
> > this case, the problem seems to be with ath10k.
> 
> For ath10k issues please also CC ath10k list:
> 
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/support
> 
> And please copy the relevant errors from the logs to the email, faster
> that way.

Okay Mentioning only the relevant error lines from the logs,

[  730.953046] wlp3s0: deauthenticating from 74:a2:e6:d8:67:71 by local choice (Reason: 3=DEAUTH_LEAVING)
[  731.061011] ath10k_pci 0000:03:00.0: firmware crashed! (uuid 4dc52092-f261-4606-885f-08947740c27c)
[  731.061019] ath10k_pci 0000:03:00.0: qca6164 hw2.1 target 0x05010000 chip_id 0x003405ff sub 17aa:3545
[  731.061021] ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 1 tracing 1 dfs 0 testmode 0
[  731.061420] ath10k_pci 0000:03:00.0: firmware ver SW_RM.1.1.1-00157-QCARMSWPZ-1 api 5 features ignore-otp,no-4addr-pad crc32 10bf8e08
[  731.061629] ath10k_pci 0000:03:00.0: board_file api 2 bmi_id N/A crc32 ae2e275a
[  731.061632] ath10k_pci 0000:03:00.0: htt-ver 3.1 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
[  731.063645] ath10k_pci 0000:03:00.0: firmware register dump:
[  731.063651] ath10k_pci 0000:03:00.0: [00]: 0x05010000 0x00000000 0x0092E4DC 0xC2A898F7
[  731.063654] ath10k_pci 0000:03:00.0: [04]: 0x0092E4DC 0x00060130 0x00000018 0x0041A760
[  731.063657] ath10k_pci 0000:03:00.0: [08]: 0xC2A898E3 0x00400000 0x00000000 0x000A5C88
[  731.063659] ath10k_pci 0000:03:00.0: [12]: 0x00000009 0x00000000 0x0096C09C 0x0096C0A7
[  731.063662] ath10k_pci 0000:03:00.0: [16]: 0x0096BDBC 0x009287BD 0x00000000 0x009287BD
[  731.063665] ath10k_pci 0000:03:00.0: [20]: 0x4092E4DC 0x0041A710 0x00000000 0x0F000000
[  731.063667] ath10k_pci 0000:03:00.0: [24]: 0x809432A7 0x0041A770 0x0040D400 0xC092E4DC
[  731.063670] ath10k_pci 0000:03:00.0: [28]: 0x80942BC4 0x0041A790 0xC2A898E3 0x00400000
[  731.063672] ath10k_pci 0000:03:00.0: [32]: 0x80947BA7 0x0041A7B0 0x00404D88 0x0040E074
[  731.063675] ath10k_pci 0000:03:00.0: [36]: 0x809BDECC 0x0041A7D0 0x00404D88 0x0040E074
[  731.063677] ath10k_pci 0000:03:00.0: [40]: 0x8099638C 0x0041A7F0 0x00404D88 0x00000000
[  731.063680] ath10k_pci 0000:03:00.0: [44]: 0x80992076 0x0041A810 0x0044FD68 0x0046FFE8
[  731.063682] ath10k_pci 0000:03:00.0: [48]: 0x80996BD3 0x0041A830 0x0044FD68 0x00000000
[  731.063685] ath10k_pci 0000:03:00.0: [52]: 0x800B4405 0x0041A850 0x00422318 0x00005002
[  731.063688] ath10k_pci 0000:03:00.0: [56]: 0x809A6C34 0x0041A8E0 0x0042932C 0x0042CA20
[  731.063690] ath10k_pci 0000:03:00.0: Copy Engine register dump:
[  731.063703] ath10k_pci 0000:03:00.0: [00]: 0x00034400   1   1   3   3
[  731.063716] ath10k_pci 0000:03:00.0: [01]: 0x00034800  27  27 222 223
[  731.063729] ath10k_pci 0000:03:00.0: [02]: 0x00034c00  50  50  49  50
[  731.063742] ath10k_pci 0000:03:00.0: [03]: 0x00035000  12  12  13  12
[  731.063756] ath10k_pci 0000:03:00.0: [04]: 0x00035400 6009 6009 254 190
[  731.063769] ath10k_pci 0000:03:00.0: [05]: 0x00035800   0   0   0   0
[  731.063781] ath10k_pci 0000:03:00.0: [06]: 0x00035c00  10  10  10  10
[  731.063794] ath10k_pci 0000:03:00.0: [07]: 0x00036000   1   1   1   1
[  731.169797] ieee80211 phy0: Hardware restart was requested
[  731.169841] ath10k_pci 0000:03:00.0: failed to delete WMI vdev 1: -108
[  741.570291] PM: Syncing filesystems ... done.
[  741.719245] PM: Preparing system for sleep (mem)
[  741.719766] Freezing user space processes ... 
[  761.724209] Freezing of tasks failed after 20.004 seconds (10 tasks refusing to freeze, wq_busy=0):
[  761.724244] cups-browsed    D    0   989      1 0x00000004
[  761.724250] Call Trace:
[  761.724263]  __schedule+0x3c2/0x8b0
[  761.724268]  ? consume_skb+0x34/0xa0
[  761.724272]  schedule+0x36/0x80
[  761.724276]  schedule_preempt_disabled+0xe/0x10
[  761.724280]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.724286]  __mutex_lock_slowpath+0x13/0x20
[  761.724289]  ? __mutex_lock_slowpath+0x13/0x20
[  761.724293]  mutex_lock+0x2f/0x40
[  761.724297]  rtnetlink_rcv+0x19/0x30
[  761.724302]  netlink_unicast+0x18c/0x240
[  761.724306]  netlink_sendmsg+0x2c5/0x3a0
[  761.724310]  sock_sendmsg+0x38/0x50
[  761.724313]  SYSC_sendto+0x101/0x190
[  761.724321]  ? SYSC_getsockname+0x89/0xe0
[  761.724327]  ? fd_install+0x25/0x30
[  761.724333]  ? sock_map_fd+0x44/0x70
[  761.724337]  SyS_sendto+0xe/0x10
[  761.724342]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.724345] RIP: 0033:0x7f87f22ac4d3
[  761.724348] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  761.724352] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  761.724354] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  761.724355] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  761.724358] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  761.724359] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  761.724369] wpa_supplicant  D    0  1049      1 0x00000004
[  761.724373] Call Trace:
[  761.724377]  __schedule+0x3c2/0x8b0
[  761.724381]  schedule+0x36/0x80
[  761.724386]  schedule_timeout+0x17a/0x360
[  761.724392]  ? call_timer_fn+0x140/0x140
[  761.724398]  msleep+0x2e/0x40
[  761.724402]  ? msleep+0x2e/0x40
[  761.724413]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  761.724434]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  761.724449]  ath10k_halt+0x102/0x160 [ath10k_core]
[  761.724464]  ath10k_stop+0x39/0x80 [ath10k_core]
[  761.724509]  drv_stop+0x33/0xf0 [mac80211]
[  761.724554]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  761.724594]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  761.724599]  ? __rtnl_unlock+0x2a/0x50
[  761.724604]  ? nla_memcpy+0x26/0x50
[  761.724645]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  761.724685]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  761.724722]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  761.724756]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  761.724761]  genl_family_rcv_msg+0x1f5/0x3d0
[  761.724765]  ? __netlink_sendskb+0x3e/0x60
[  761.724771]  genl_rcv_msg+0x4c/0x90
[  761.724775]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  761.724779]  netlink_rcv_skb+0xe7/0x120
[  761.724784]  genl_rcv+0x28/0x40
[  761.724787]  netlink_unicast+0x18c/0x240
[  761.724792]  netlink_sendmsg+0x2c5/0x3a0
[  761.724796]  sock_sendmsg+0x38/0x50
[  761.724800]  ___sys_sendmsg+0x2b6/0x2d0
[  761.724804]  ? netlink_sendmsg+0x133/0x3a0
[  761.724812]  ? kzfree+0x2d/0x40
[  761.724819]  ? dput+0xc7/0x1f0
[  761.724825]  ? mntput+0x24/0x40
[  761.724829]  __sys_sendmsg+0x54/0x90
[  761.724832]  ? __sys_sendmsg+0x54/0x90
[  761.724837]  SyS_sendmsg+0x12/0x20
[  761.724842]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.724845] RIP: 0033:0x7fd5b8652450
[  761.724848] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  761.724851] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  761.724853] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  761.724855] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  761.724857] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  761.724859] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  761.724867] whoopsie        D    0  1169      1 0x00000004
[  761.724871] Call Trace:
[  761.724875]  __schedule+0x3c2/0x8b0
[  761.724881]  ? __wake_up_common+0x73/0x90
[  761.724885]  schedule+0x36/0x80
[  761.724889]  schedule_preempt_disabled+0xe/0x10
[  761.724893]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.724898]  __mutex_lock_slowpath+0x13/0x20
[  761.724902]  ? __mutex_lock_slowpath+0x13/0x20
[  761.724906]  mutex_lock+0x2f/0x40
[  761.724910]  rtnetlink_rcv+0x19/0x30
[  761.724914]  netlink_unicast+0x18c/0x240
[  761.724918]  netlink_sendmsg+0x2c5/0x3a0
[  761.724922]  sock_sendmsg+0x38/0x50
[  761.724925]  SYSC_sendto+0x101/0x190
[  761.724931]  ? security_file_permission+0x9b/0xc0
[  761.724937]  ? vfs_read+0x93/0x130
[  761.724942]  SyS_sendto+0xe/0x10
[  761.724946]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.724949] RIP: 0033:0x7f804d02a3ff
[  761.724951] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.724955] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  761.724957] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  761.724958] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  761.724960] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  761.724962] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  761.724995] gnome-software  D    0  2123   1992 0x00000004
[  761.724999] Call Trace:
[  761.725004]  __schedule+0x3c2/0x8b0
[  761.725009]  schedule+0x36/0x80
[  761.725012]  schedule_preempt_disabled+0xe/0x10
[  761.725016]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725022]  __mutex_lock_slowpath+0x13/0x20
[  761.725025]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725029]  mutex_lock+0x2f/0x40
[  761.725033]  rtnetlink_rcv+0x19/0x30
[  761.725037]  netlink_unicast+0x18c/0x240
[  761.725041]  netlink_sendmsg+0x2c5/0x3a0
[  761.725045]  sock_sendmsg+0x38/0x50
[  761.725048]  SYSC_sendto+0x101/0x190
[  761.725053]  ? security_file_permission+0x9b/0xc0
[  761.725058]  ? vfs_read+0x93/0x130
[  761.725062]  SyS_sendto+0xe/0x10
[  761.725067]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725070] RIP: 0033:0x7f483f67e9ff
[  761.725072] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725076] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  761.725078] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  761.725080] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  761.725082] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  761.725083] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  761.725103] evolution-calen D    0  2487   2464 0x00000004
[  761.725107] Call Trace:
[  761.725112]  __schedule+0x3c2/0x8b0
[  761.725116]  schedule+0x36/0x80
[  761.725120]  schedule_preempt_disabled+0xe/0x10
[  761.725124]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725129]  __mutex_lock_slowpath+0x13/0x20
[  761.725133]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725136]  mutex_lock+0x2f/0x40
[  761.725140]  rtnetlink_rcv+0x19/0x30
[  761.725144]  netlink_unicast+0x18c/0x240
[  761.725148]  netlink_sendmsg+0x2c5/0x3a0
[  761.725152]  sock_sendmsg+0x38/0x50
[  761.725155]  SYSC_sendto+0x101/0x190
[  761.725160]  ? security_file_permission+0x9b/0xc0
[  761.725166]  ? vfs_read+0x93/0x130
[  761.725170]  SyS_sendto+0xe/0x10
[  761.725175]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725177] RIP: 0033:0x7f2764fc19ff
[  761.725179] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725183] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  761.725185] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  761.725187] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  761.725189] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  761.725191] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  761.725197] evolution-calen D    0  2499   2464 0x00000004
[  761.725201] Call Trace:
[  761.725205]  __schedule+0x3c2/0x8b0
[  761.725210]  schedule+0x36/0x80
[  761.725213]  schedule_preempt_disabled+0xe/0x10
[  761.725217]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725222]  __mutex_lock_slowpath+0x13/0x20
[  761.725226]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725229]  mutex_lock+0x2f/0x40
[  761.725233]  rtnetlink_rcv+0x19/0x30
[  761.725237]  netlink_unicast+0x18c/0x240
[  761.725241]  netlink_sendmsg+0x2c5/0x3a0
[  761.725245]  sock_sendmsg+0x38/0x50
[  761.725248]  SYSC_sendto+0x101/0x190
[  761.725253]  ? security_file_permission+0x9b/0xc0
[  761.725258]  ? vfs_read+0x93/0x130
[  761.725262]  SyS_sendto+0xe/0x10
[  761.725267]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725270] RIP: 0033:0x7fb2c6e629ff
[  761.725272] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725275] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  761.725277] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  761.725279] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  761.725281] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  761.725283] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  761.725288] evolution-addre D    0  2519   2497 0x00000004
[  761.725292] Call Trace:
[  761.725296]  __schedule+0x3c2/0x8b0
[  761.725300]  schedule+0x36/0x80
[  761.725304]  schedule_preempt_disabled+0xe/0x10
[  761.725308]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725313]  __mutex_lock_slowpath+0x13/0x20
[  761.725317]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725320]  mutex_lock+0x2f/0x40
[  761.725324]  rtnetlink_rcv+0x19/0x30
[  761.725327]  netlink_unicast+0x18c/0x240
[  761.725332]  netlink_sendmsg+0x2c5/0x3a0
[  761.725336]  sock_sendmsg+0x38/0x50
[  761.725339]  SYSC_sendto+0x101/0x190
[  761.725343]  ? security_file_permission+0x9b/0xc0
[  761.725349]  ? vfs_read+0x93/0x130
[  761.725353]  SyS_sendto+0xe/0x10
[  761.725358]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725360] RIP: 0033:0x7f4a6d1aa9ff
[  761.725362] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725366] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  761.725368] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  761.725370] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  761.725372] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  761.725374] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  761.725384] geoclue         D    0  2681      1 0x00000004
[  761.725387] Call Trace:
[  761.725392]  __schedule+0x3c2/0x8b0
[  761.725395]  ? consume_skb+0x34/0xa0
[  761.725399]  schedule+0x36/0x80
[  761.725403]  schedule_preempt_disabled+0xe/0x10
[  761.725406]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725412]  __mutex_lock_slowpath+0x13/0x20
[  761.725415]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725419]  mutex_lock+0x2f/0x40
[  761.725422]  rtnetlink_rcv+0x19/0x30
[  761.725426]  netlink_unicast+0x18c/0x240
[  761.725430]  netlink_sendmsg+0x2c5/0x3a0
[  761.725434]  sock_sendmsg+0x38/0x50
[  761.725437]  SYSC_sendto+0x101/0x190
[  761.725442]  ? security_file_permission+0x9b/0xc0
[  761.725447]  ? vfs_read+0x93/0x130
[  761.725451]  SyS_sendto+0xe/0x10
[  761.725456]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725458] RIP: 0033:0x7f22fe6c13ff
[  761.725460] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725464] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  761.725466] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  761.725468] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  761.725470] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  761.725472] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  761.725491] deja-dup-monito D    0  2923   1992 0x00000004
[  761.725495] Call Trace:
[  761.725499]  __schedule+0x3c2/0x8b0
[  761.725504]  schedule+0x36/0x80
[  761.725507]  schedule_preempt_disabled+0xe/0x10
[  761.725511]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725516]  __mutex_lock_slowpath+0x13/0x20
[  761.725520]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725523]  mutex_lock+0x2f/0x40
[  761.725527]  rtnetlink_rcv+0x19/0x30
[  761.725531]  netlink_unicast+0x18c/0x240
[  761.725535]  netlink_sendmsg+0x2c5/0x3a0
[  761.725539]  sock_sendmsg+0x38/0x50
[  761.725542]  SYSC_sendto+0x101/0x190
[  761.725546]  ? security_file_permission+0x9b/0xc0
[  761.725552]  ? vfs_read+0x93/0x130
[  761.725556]  SyS_sendto+0xe/0x10
[  761.725561]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725563] RIP: 0033:0x7ff26c2df9ff
[  761.725565] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725569] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  761.725571] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  761.725573] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  761.725575] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  761.725577] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  761.725587] ip              D    0 14444  14443 0x00000004
[  761.725591] Call Trace:
[  761.725595]  __schedule+0x3c2/0x8b0
[  761.725600]  schedule+0x36/0x80
[  761.725603]  schedule_preempt_disabled+0xe/0x10
[  761.725607]  __mutex_lock.isra.2+0x2ae/0x4e0
[  761.725612]  ? current_time+0x38/0x70
[  761.725616]  __mutex_lock_slowpath+0x13/0x20
[  761.725620]  ? __mutex_lock_slowpath+0x13/0x20
[  761.725623]  mutex_lock+0x2f/0x40
[  761.725627]  rtnetlink_rcv+0x19/0x30
[  761.725631]  netlink_unicast+0x18c/0x240
[  761.725635]  netlink_sendmsg+0x2c5/0x3a0
[  761.725639]  sock_sendmsg+0x38/0x50
[  761.725642]  SYSC_sendto+0x101/0x190
[  761.725649]  ? handle_mm_fault+0xcc/0x1c0
[  761.725656]  ? __do_page_fault+0x283/0x4f0
[  761.725660]  SyS_sendto+0xe/0x10
[  761.725665]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  761.725668] RIP: 0033:0x7fb0aae9f39d
[  761.725670] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  761.725673] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  761.725675] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  761.725677] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  761.725679] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  761.725681] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  761.725688] OOM killer enabled.
[  761.725689] Restarting tasks ... done.
[  761.836907] PM: Syncing filesystems ... done.
[  762.064653] PM: Preparing system for sleep (freeze)
[  762.064956] Freezing user space processes ... 
[  782.068576] Freezing of tasks failed after 20.003 seconds (10 tasks refusing to freeze, wq_busy=0):
[  782.068612] cups-browsed    D    0   989      1 0x00000004
[  782.068617] Call Trace:
[  782.068631]  __schedule+0x3c2/0x8b0
[  782.068636]  ? consume_skb+0x34/0xa0
[  782.068640]  schedule+0x36/0x80
[  782.068644]  schedule_preempt_disabled+0xe/0x10
[  782.068648]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.068654]  __mutex_lock_slowpath+0x13/0x20
[  782.068657]  ? __mutex_lock_slowpath+0x13/0x20
[  782.068661]  mutex_lock+0x2f/0x40
[  782.068665]  rtnetlink_rcv+0x19/0x30
[  782.068670]  netlink_unicast+0x18c/0x240
[  782.068674]  netlink_sendmsg+0x2c5/0x3a0
[  782.068678]  sock_sendmsg+0x38/0x50
[  782.068681]  SYSC_sendto+0x101/0x190
[  782.068689]  ? SYSC_getsockname+0x89/0xe0
[  782.068696]  ? fd_install+0x25/0x30
[  782.068701]  ? sock_map_fd+0x44/0x70
[  782.068705]  SyS_sendto+0xe/0x10
[  782.068710]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.068713] RIP: 0033:0x7f87f22ac4d3
[  782.068716] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  782.068720] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  782.068722] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  782.068724] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  782.068726] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  782.068728] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  782.068737] wpa_supplicant  D    0  1049      1 0x00000004
[  782.068741] Call Trace:
[  782.068746]  __schedule+0x3c2/0x8b0
[  782.068750]  schedule+0x36/0x80
[  782.068754]  schedule_timeout+0x17a/0x360
[  782.068761]  ? call_timer_fn+0x140/0x140
[  782.068766]  msleep+0x2e/0x40
[  782.068770]  ? msleep+0x2e/0x40
[  782.068781]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  782.068802]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  782.068817]  ath10k_halt+0x102/0x160 [ath10k_core]
[  782.068832]  ath10k_stop+0x39/0x80 [ath10k_core]
[  782.068875]  drv_stop+0x33/0xf0 [mac80211]
[  782.068918]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  782.068954]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  782.068959]  ? __rtnl_unlock+0x2a/0x50
[  782.068964]  ? nla_memcpy+0x26/0x50
[  782.069003]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  782.069044]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  782.069081]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  782.069114]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  782.069119]  genl_family_rcv_msg+0x1f5/0x3d0
[  782.069124]  ? __netlink_sendskb+0x3e/0x60
[  782.069130]  genl_rcv_msg+0x4c/0x90
[  782.069134]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  782.069137]  netlink_rcv_skb+0xe7/0x120
[  782.069142]  genl_rcv+0x28/0x40
[  782.069146]  netlink_unicast+0x18c/0x240
[  782.069150]  netlink_sendmsg+0x2c5/0x3a0
[  782.069154]  sock_sendmsg+0x38/0x50
[  782.069158]  ___sys_sendmsg+0x2b6/0x2d0
[  782.069162]  ? netlink_sendmsg+0x133/0x3a0
[  782.069170]  ? kzfree+0x2d/0x40
[  782.069176]  ? dput+0xc7/0x1f0
[  782.069182]  ? mntput+0x24/0x40
[  782.069186]  __sys_sendmsg+0x54/0x90
[  782.069189]  ? __sys_sendmsg+0x54/0x90
[  782.069194]  SyS_sendmsg+0x12/0x20
[  782.069200]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069202] RIP: 0033:0x7fd5b8652450
[  782.069205] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  782.069209] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  782.069211] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  782.069212] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  782.069215] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  782.069216] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  782.069224] whoopsie        D    0  1169      1 0x00000004
[  782.069228] Call Trace:
[  782.069233]  __schedule+0x3c2/0x8b0
[  782.069239]  ? __wake_up_common+0x73/0x90
[  782.069242]  schedule+0x36/0x80
[  782.069246]  schedule_preempt_disabled+0xe/0x10
[  782.069250]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069256]  __mutex_lock_slowpath+0x13/0x20
[  782.069259]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069263]  mutex_lock+0x2f/0x40
[  782.069267]  rtnetlink_rcv+0x19/0x30
[  782.069271]  netlink_unicast+0x18c/0x240
[  782.069275]  netlink_sendmsg+0x2c5/0x3a0
[  782.069279]  sock_sendmsg+0x38/0x50
[  782.069282]  SYSC_sendto+0x101/0x190
[  782.069288]  ? security_file_permission+0x9b/0xc0
[  782.069294]  ? vfs_read+0x93/0x130
[  782.069298]  SyS_sendto+0xe/0x10
[  782.069303]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069306] RIP: 0033:0x7f804d02a3ff
[  782.069308] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069312] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  782.069314] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  782.069315] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  782.069317] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  782.069319] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  782.069353] gnome-software  D    0  2123   1992 0x00000004
[  782.069357] Call Trace:
[  782.069362]  __schedule+0x3c2/0x8b0
[  782.069366]  schedule+0x36/0x80
[  782.069370]  schedule_preempt_disabled+0xe/0x10
[  782.069374]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069379]  __mutex_lock_slowpath+0x13/0x20
[  782.069383]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069386]  mutex_lock+0x2f/0x40
[  782.069390]  rtnetlink_rcv+0x19/0x30
[  782.069394]  netlink_unicast+0x18c/0x240
[  782.069398]  netlink_sendmsg+0x2c5/0x3a0
[  782.069402]  sock_sendmsg+0x38/0x50
[  782.069405]  SYSC_sendto+0x101/0x190
[  782.069410]  ? security_file_permission+0x9b/0xc0
[  782.069416]  ? vfs_read+0x93/0x130
[  782.069420]  SyS_sendto+0xe/0x10
[  782.069425]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069427] RIP: 0033:0x7f483f67e9ff
[  782.069429] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069433] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  782.069435] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  782.069437] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  782.069439] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  782.069441] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  782.069460] evolution-calen D    0  2487   2464 0x00000004
[  782.069464] Call Trace:
[  782.069468]  __schedule+0x3c2/0x8b0
[  782.069473]  schedule+0x36/0x80
[  782.069476]  schedule_preempt_disabled+0xe/0x10
[  782.069480]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069486]  __mutex_lock_slowpath+0x13/0x20
[  782.069489]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069492]  mutex_lock+0x2f/0x40
[  782.069496]  rtnetlink_rcv+0x19/0x30
[  782.069500]  netlink_unicast+0x18c/0x240
[  782.069504]  netlink_sendmsg+0x2c5/0x3a0
[  782.069508]  sock_sendmsg+0x38/0x50
[  782.069511]  SYSC_sendto+0x101/0x190
[  782.069516]  ? security_file_permission+0x9b/0xc0
[  782.069521]  ? vfs_read+0x93/0x130
[  782.069525]  SyS_sendto+0xe/0x10
[  782.069530]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069533] RIP: 0033:0x7f2764fc19ff
[  782.069535] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069538] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  782.069540] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  782.069542] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  782.069544] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  782.069546] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  782.069552] evolution-calen D    0  2499   2464 0x00000004
[  782.069556] Call Trace:
[  782.069560]  __schedule+0x3c2/0x8b0
[  782.069565]  schedule+0x36/0x80
[  782.069568]  schedule_preempt_disabled+0xe/0x10
[  782.069572]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069577]  __mutex_lock_slowpath+0x13/0x20
[  782.069581]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069584]  mutex_lock+0x2f/0x40
[  782.069588]  rtnetlink_rcv+0x19/0x30
[  782.069592]  netlink_unicast+0x18c/0x240
[  782.069596]  netlink_sendmsg+0x2c5/0x3a0
[  782.069600]  sock_sendmsg+0x38/0x50
[  782.069603]  SYSC_sendto+0x101/0x190
[  782.069607]  ? security_file_permission+0x9b/0xc0
[  782.069613]  ? vfs_read+0x93/0x130
[  782.069617]  SyS_sendto+0xe/0x10
[  782.069621]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069624] RIP: 0033:0x7fb2c6e629ff
[  782.069626] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069629] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  782.069631] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  782.069633] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  782.069635] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  782.069637] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  782.069642] evolution-addre D    0  2519   2497 0x00000004
[  782.069646] Call Trace:
[  782.069650]  __schedule+0x3c2/0x8b0
[  782.069655]  schedule+0x36/0x80
[  782.069658]  schedule_preempt_disabled+0xe/0x10
[  782.069662]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069667]  __mutex_lock_slowpath+0x13/0x20
[  782.069670]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069674]  mutex_lock+0x2f/0x40
[  782.069678]  rtnetlink_rcv+0x19/0x30
[  782.069681]  netlink_unicast+0x18c/0x240
[  782.069685]  netlink_sendmsg+0x2c5/0x3a0
[  782.069689]  sock_sendmsg+0x38/0x50
[  782.069693]  SYSC_sendto+0x101/0x190
[  782.069697]  ? security_file_permission+0x9b/0xc0
[  782.069702]  ? vfs_read+0x93/0x130
[  782.069706]  SyS_sendto+0xe/0x10
[  782.069711]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069713] RIP: 0033:0x7f4a6d1aa9ff
[  782.069715] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069719] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  782.069721] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  782.069723] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  782.069725] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  782.069727] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  782.069737] geoclue         D    0  2681      1 0x00000004
[  782.069741] Call Trace:
[  782.069745]  __schedule+0x3c2/0x8b0
[  782.069748]  ? consume_skb+0x34/0xa0
[  782.069752]  schedule+0x36/0x80
[  782.069756]  schedule_preempt_disabled+0xe/0x10
[  782.069760]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069765]  __mutex_lock_slowpath+0x13/0x20
[  782.069769]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069772]  mutex_lock+0x2f/0x40
[  782.069776]  rtnetlink_rcv+0x19/0x30
[  782.069780]  netlink_unicast+0x18c/0x240
[  782.069784]  netlink_sendmsg+0x2c5/0x3a0
[  782.069788]  sock_sendmsg+0x38/0x50
[  782.069791]  SYSC_sendto+0x101/0x190
[  782.069795]  ? security_file_permission+0x9b/0xc0
[  782.069801]  ? vfs_read+0x93/0x130
[  782.069805]  SyS_sendto+0xe/0x10
[  782.069810]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069812] RIP: 0033:0x7f22fe6c13ff
[  782.069814] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069818] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  782.069820] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  782.069822] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  782.069824] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  782.069825] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  782.069845] deja-dup-monito D    0  2923   1992 0x00000004
[  782.069848] Call Trace:
[  782.069853]  __schedule+0x3c2/0x8b0
[  782.069857]  schedule+0x36/0x80
[  782.069861]  schedule_preempt_disabled+0xe/0x10
[  782.069864]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069870]  __mutex_lock_slowpath+0x13/0x20
[  782.069873]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069877]  mutex_lock+0x2f/0x40
[  782.069880]  rtnetlink_rcv+0x19/0x30
[  782.069884]  netlink_unicast+0x18c/0x240
[  782.069888]  netlink_sendmsg+0x2c5/0x3a0
[  782.069892]  sock_sendmsg+0x38/0x50
[  782.069895]  SYSC_sendto+0x101/0x190
[  782.069899]  ? security_file_permission+0x9b/0xc0
[  782.069905]  ? vfs_read+0x93/0x130
[  782.069909]  SyS_sendto+0xe/0x10
[  782.069914]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.069916] RIP: 0033:0x7ff26c2df9ff
[  782.069918] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.069922] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  782.069924] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  782.069926] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  782.069928] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  782.069929] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  782.069940] ip              D    0 14444  14443 0x00000004
[  782.069944] Call Trace:
[  782.069948]  __schedule+0x3c2/0x8b0
[  782.069952]  schedule+0x36/0x80
[  782.069956]  schedule_preempt_disabled+0xe/0x10
[  782.069959]  __mutex_lock.isra.2+0x2ae/0x4e0
[  782.069964]  ? current_time+0x38/0x70
[  782.069968]  __mutex_lock_slowpath+0x13/0x20
[  782.069972]  ? __mutex_lock_slowpath+0x13/0x20
[  782.069975]  mutex_lock+0x2f/0x40
[  782.069979]  rtnetlink_rcv+0x19/0x30
[  782.069983]  netlink_unicast+0x18c/0x240
[  782.069987]  netlink_sendmsg+0x2c5/0x3a0
[  782.069991]  sock_sendmsg+0x38/0x50
[  782.069994]  SYSC_sendto+0x101/0x190
[  782.070001]  ? handle_mm_fault+0xcc/0x1c0
[  782.070008]  ? __do_page_fault+0x283/0x4f0
[  782.070012]  SyS_sendto+0xe/0x10
[  782.070017]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  782.070020] RIP: 0033:0x7fb0aae9f39d
[  782.070022] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  782.070025] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  782.070027] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  782.070029] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  782.070031] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  782.070033] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  782.070040] OOM killer enabled.
[  782.070041] Restarting tasks ... done.
[  792.193128] PM: Syncing filesystems ... done.
[  792.382775] PM: Preparing system for sleep (mem)
[  792.383005] Freezing user space processes ... 
[  812.387298] Freezing of tasks failed after 20.004 seconds (11 tasks refusing to freeze, wq_busy=0):
[  812.387331] cups-browsed    D    0   989      1 0x00000004
[  812.387337] Call Trace:
[  812.387350]  __schedule+0x3c2/0x8b0
[  812.387355]  ? consume_skb+0x34/0xa0
[  812.387359]  schedule+0x36/0x80
[  812.387363]  schedule_preempt_disabled+0xe/0x10
[  812.387367]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.387373]  __mutex_lock_slowpath+0x13/0x20
[  812.387376]  ? __mutex_lock_slowpath+0x13/0x20
[  812.387379]  mutex_lock+0x2f/0x40
[  812.387384]  rtnetlink_rcv+0x19/0x30
[  812.387389]  netlink_unicast+0x18c/0x240
[  812.387393]  netlink_sendmsg+0x2c5/0x3a0
[  812.387398]  sock_sendmsg+0x38/0x50
[  812.387401]  SYSC_sendto+0x101/0x190
[  812.387408]  ? SYSC_getsockname+0x89/0xe0
[  812.387415]  ? fd_install+0x25/0x30
[  812.387420]  ? sock_map_fd+0x44/0x70
[  812.387424]  SyS_sendto+0xe/0x10
[  812.387429]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.387433] RIP: 0033:0x7f87f22ac4d3
[  812.387435] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  812.387439] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  812.387442] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  812.387444] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  812.387446] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  812.387448] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  812.387453] NetworkManager  D    0   990      1 0x00000004
[  812.387457] Call Trace:
[  812.387461]  __schedule+0x3c2/0x8b0
[  812.387466]  schedule+0x36/0x80
[  812.387469]  schedule_preempt_disabled+0xe/0x10
[  812.387473]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.387479]  ? ___slab_alloc+0x32b/0x4c0
[  812.387484]  __mutex_lock_slowpath+0x13/0x20
[  812.387487]  ? __mutex_lock_slowpath+0x13/0x20
[  812.387490]  mutex_lock+0x2f/0x40
[  812.387494]  rtnl_lock+0x15/0x20
[  812.387500]  dev_ioctl+0x312/0x530
[  812.387504]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  812.387510]  sock_do_ioctl+0x42/0x50
[  812.387515]  ? sock_do_ioctl+0x42/0x50
[  812.387520]  sock_ioctl+0x1f6/0x2c0
[  812.387524]  ? alloc_file+0x69/0xe0
[  812.387529]  do_vfs_ioctl+0xa1/0x5d0
[  812.387535]  ? sock_alloc_file+0xa6/0x130
[  812.387540]  SyS_ioctl+0x79/0x90
[  812.387545]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.387547] RIP: 0033:0x7f9d454bbf07
[  812.387549] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  812.387553] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  812.387555] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  812.387557] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  812.387559] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  812.387561] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  812.387568] wpa_supplicant  D    0  1049      1 0x00000004
[  812.387571] Call Trace:
[  812.387575]  __schedule+0x3c2/0x8b0
[  812.387579]  schedule+0x36/0x80
[  812.387583]  schedule_timeout+0x17a/0x360
[  812.387590]  ? call_timer_fn+0x140/0x140
[  812.387595]  msleep+0x2e/0x40
[  812.387599]  ? msleep+0x2e/0x40
[  812.387610]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  812.387631]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  812.387646]  ath10k_halt+0x102/0x160 [ath10k_core]
[  812.387660]  ath10k_stop+0x39/0x80 [ath10k_core]
[  812.387704]  drv_stop+0x33/0xf0 [mac80211]
[  812.387746]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  812.387785]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  812.387791]  ? __rtnl_unlock+0x2a/0x50
[  812.387796]  ? nla_memcpy+0x26/0x50
[  812.387836]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  812.387877]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  812.387914]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  812.387948]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  812.387953]  genl_family_rcv_msg+0x1f5/0x3d0
[  812.387957]  ? __netlink_sendskb+0x3e/0x60
[  812.387963]  genl_rcv_msg+0x4c/0x90
[  812.387967]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  812.387971]  netlink_rcv_skb+0xe7/0x120
[  812.387975]  genl_rcv+0x28/0x40
[  812.387979]  netlink_unicast+0x18c/0x240
[  812.387983]  netlink_sendmsg+0x2c5/0x3a0
[  812.387988]  sock_sendmsg+0x38/0x50
[  812.387991]  ___sys_sendmsg+0x2b6/0x2d0
[  812.388022]  ? netlink_sendmsg+0x133/0x3a0
[  812.388030]  ? kzfree+0x2d/0x40
[  812.388036]  ? dput+0xc7/0x1f0
[  812.388042]  ? mntput+0x24/0x40
[  812.388046]  __sys_sendmsg+0x54/0x90
[  812.388050]  ? __sys_sendmsg+0x54/0x90
[  812.388054]  SyS_sendmsg+0x12/0x20
[  812.388060]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388062] RIP: 0033:0x7fd5b8652450
[  812.388065] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  812.388069] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  812.388071] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  812.388073] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  812.388075] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  812.388077] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  812.388085] whoopsie        D    0  1169      1 0x00000004
[  812.388089] Call Trace:
[  812.388094]  __schedule+0x3c2/0x8b0
[  812.388100]  ? __wake_up_common+0x73/0x90
[  812.388104]  schedule+0x36/0x80
[  812.388107]  schedule_preempt_disabled+0xe/0x10
[  812.388111]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388117]  __mutex_lock_slowpath+0x13/0x20
[  812.388120]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388124]  mutex_lock+0x2f/0x40
[  812.388128]  rtnetlink_rcv+0x19/0x30
[  812.388132]  netlink_unicast+0x18c/0x240
[  812.388136]  netlink_sendmsg+0x2c5/0x3a0
[  812.388140]  sock_sendmsg+0x38/0x50
[  812.388143]  SYSC_sendto+0x101/0x190
[  812.388149]  ? security_file_permission+0x9b/0xc0
[  812.388155]  ? vfs_read+0x93/0x130
[  812.388159]  SyS_sendto+0xe/0x10
[  812.388164]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388166] RIP: 0033:0x7f804d02a3ff
[  812.388168] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388172] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  812.388174] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  812.388176] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  812.388178] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  812.388180] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  812.388215] gnome-software  D    0  2123   1992 0x00000004
[  812.388219] Call Trace:
[  812.388223]  __schedule+0x3c2/0x8b0
[  812.388227]  schedule+0x36/0x80
[  812.388231]  schedule_preempt_disabled+0xe/0x10
[  812.388235]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388240]  __mutex_lock_slowpath+0x13/0x20
[  812.388243]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388247]  mutex_lock+0x2f/0x40
[  812.388251]  rtnetlink_rcv+0x19/0x30
[  812.388255]  netlink_unicast+0x18c/0x240
[  812.388259]  netlink_sendmsg+0x2c5/0x3a0
[  812.388263]  sock_sendmsg+0x38/0x50
[  812.388266]  SYSC_sendto+0x101/0x190
[  812.388271]  ? security_file_permission+0x9b/0xc0
[  812.388277]  ? vfs_read+0x93/0x130
[  812.388281]  SyS_sendto+0xe/0x10
[  812.388286]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388288] RIP: 0033:0x7f483f67e9ff
[  812.388290] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388294] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  812.388296] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  812.388298] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  812.388300] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  812.388302] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  812.388322] evolution-calen D    0  2487   2464 0x00000004
[  812.388326] Call Trace:
[  812.388330]  __schedule+0x3c2/0x8b0
[  812.388335]  schedule+0x36/0x80
[  812.388338]  schedule_preempt_disabled+0xe/0x10
[  812.388342]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388348]  __mutex_lock_slowpath+0x13/0x20
[  812.388351]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388355]  mutex_lock+0x2f/0x40
[  812.388359]  rtnetlink_rcv+0x19/0x30
[  812.388362]  netlink_unicast+0x18c/0x240
[  812.388366]  netlink_sendmsg+0x2c5/0x3a0
[  812.388370]  sock_sendmsg+0x38/0x50
[  812.388374]  SYSC_sendto+0x101/0x190
[  812.388378]  ? security_file_permission+0x9b/0xc0
[  812.388384]  ? vfs_read+0x93/0x130
[  812.388388]  SyS_sendto+0xe/0x10
[  812.388392]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388395] RIP: 0033:0x7f2764fc19ff
[  812.388397] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388401] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  812.388403] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  812.388404] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  812.388406] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  812.388408] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  812.388414] evolution-calen D    0  2499   2464 0x00000004
[  812.388418] Call Trace:
[  812.388422]  __schedule+0x3c2/0x8b0
[  812.388427]  schedule+0x36/0x80
[  812.388430]  schedule_preempt_disabled+0xe/0x10
[  812.388434]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388439]  __mutex_lock_slowpath+0x13/0x20
[  812.388443]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388446]  mutex_lock+0x2f/0x40
[  812.388450]  rtnetlink_rcv+0x19/0x30
[  812.388454]  netlink_unicast+0x18c/0x240
[  812.388458]  netlink_sendmsg+0x2c5/0x3a0
[  812.388462]  sock_sendmsg+0x38/0x50
[  812.388465]  SYSC_sendto+0x101/0x190
[  812.388469]  ? security_file_permission+0x9b/0xc0
[  812.388475]  ? vfs_read+0x93/0x130
[  812.388479]  SyS_sendto+0xe/0x10
[  812.388484]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388486] RIP: 0033:0x7fb2c6e629ff
[  812.388488] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388492] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  812.388494] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  812.388496] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  812.388498] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  812.388500] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  812.388504] evolution-addre D    0  2519   2497 0x00000004
[  812.388508] Call Trace:
[  812.388513]  __schedule+0x3c2/0x8b0
[  812.388517]  schedule+0x36/0x80
[  812.388520]  schedule_preempt_disabled+0xe/0x10
[  812.388524]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388529]  __mutex_lock_slowpath+0x13/0x20
[  812.388533]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388536]  mutex_lock+0x2f/0x40
[  812.388540]  rtnetlink_rcv+0x19/0x30
[  812.388544]  netlink_unicast+0x18c/0x240
[  812.388548]  netlink_sendmsg+0x2c5/0x3a0
[  812.388552]  sock_sendmsg+0x38/0x50
[  812.388555]  SYSC_sendto+0x101/0x190
[  812.388560]  ? security_file_permission+0x9b/0xc0
[  812.388565]  ? vfs_read+0x93/0x130
[  812.388570]  SyS_sendto+0xe/0x10
[  812.388574]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388577] RIP: 0033:0x7f4a6d1aa9ff
[  812.388579] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388583] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  812.388584] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  812.388586] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  812.388588] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  812.388590] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  812.388601] geoclue         D    0  2681      1 0x00000004
[  812.388605] Call Trace:
[  812.388609]  __schedule+0x3c2/0x8b0
[  812.388612]  ? consume_skb+0x34/0xa0
[  812.388616]  schedule+0x36/0x80
[  812.388620]  schedule_preempt_disabled+0xe/0x10
[  812.388624]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388629]  __mutex_lock_slowpath+0x13/0x20
[  812.388633]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388636]  mutex_lock+0x2f/0x40
[  812.388640]  rtnetlink_rcv+0x19/0x30
[  812.388643]  netlink_unicast+0x18c/0x240
[  812.388648]  netlink_sendmsg+0x2c5/0x3a0
[  812.388652]  sock_sendmsg+0x38/0x50
[  812.388655]  SYSC_sendto+0x101/0x190
[  812.388659]  ? security_file_permission+0x9b/0xc0
[  812.388665]  ? vfs_read+0x93/0x130
[  812.388669]  SyS_sendto+0xe/0x10
[  812.388673]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388676] RIP: 0033:0x7f22fe6c13ff
[  812.388678] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388682] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  812.388684] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  812.388686] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  812.388687] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  812.388689] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  812.388710] deja-dup-monito D    0  2923   1992 0x00000004
[  812.388713] Call Trace:
[  812.388718]  __schedule+0x3c2/0x8b0
[  812.388722]  schedule+0x36/0x80
[  812.388726]  schedule_preempt_disabled+0xe/0x10
[  812.388730]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388735]  __mutex_lock_slowpath+0x13/0x20
[  812.388739]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388742]  mutex_lock+0x2f/0x40
[  812.388746]  rtnetlink_rcv+0x19/0x30
[  812.388750]  netlink_unicast+0x18c/0x240
[  812.388754]  netlink_sendmsg+0x2c5/0x3a0
[  812.388758]  sock_sendmsg+0x38/0x50
[  812.388761]  SYSC_sendto+0x101/0x190
[  812.388766]  ? security_file_permission+0x9b/0xc0
[  812.388771]  ? vfs_read+0x93/0x130
[  812.388775]  SyS_sendto+0xe/0x10
[  812.388780]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388782] RIP: 0033:0x7ff26c2df9ff
[  812.388784] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388788] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  812.388790] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  812.388792] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  812.388794] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  812.388796] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  812.388806] ip              D    0 14444  14443 0x00000004
[  812.388810] Call Trace:
[  812.388815]  __schedule+0x3c2/0x8b0
[  812.388819]  schedule+0x36/0x80
[  812.388823]  schedule_preempt_disabled+0xe/0x10
[  812.388827]  __mutex_lock.isra.2+0x2ae/0x4e0
[  812.388831]  ? current_time+0x38/0x70
[  812.388835]  __mutex_lock_slowpath+0x13/0x20
[  812.388839]  ? __mutex_lock_slowpath+0x13/0x20
[  812.388842]  mutex_lock+0x2f/0x40
[  812.388846]  rtnetlink_rcv+0x19/0x30
[  812.388850]  netlink_unicast+0x18c/0x240
[  812.388854]  netlink_sendmsg+0x2c5/0x3a0
[  812.388858]  sock_sendmsg+0x38/0x50
[  812.388861]  SYSC_sendto+0x101/0x190
[  812.388868]  ? handle_mm_fault+0xcc/0x1c0
[  812.388875]  ? __do_page_fault+0x283/0x4f0
[  812.388880]  SyS_sendto+0xe/0x10
[  812.388885]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  812.388887] RIP: 0033:0x7fb0aae9f39d
[  812.388889] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  812.388893] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  812.388895] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  812.388897] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  812.388898] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  812.388900] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  812.388908] OOM killer enabled.
[  812.388909] Restarting tasks ... done.
[  812.497026] PM: Syncing filesystems ... done.
[  812.847861] PM: Preparing system for sleep (freeze)
[  812.848274] Freezing user space processes ... 
[  832.858985] Freezing of tasks failed after 20.010 seconds (11 tasks refusing to freeze, wq_busy=0):
[  832.859019] cups-browsed    D    0   989      1 0x00000004
[  832.859025] Call Trace:
[  832.859038]  __schedule+0x3c2/0x8b0
[  832.859043]  ? consume_skb+0x34/0xa0
[  832.859047]  schedule+0x36/0x80
[  832.859051]  schedule_preempt_disabled+0xe/0x10
[  832.859055]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.859061]  __mutex_lock_slowpath+0x13/0x20
[  832.859064]  ? __mutex_lock_slowpath+0x13/0x20
[  832.859068]  mutex_lock+0x2f/0x40
[  832.859072]  rtnetlink_rcv+0x19/0x30
[  832.859077]  netlink_unicast+0x18c/0x240
[  832.859081]  netlink_sendmsg+0x2c5/0x3a0
[  832.859085]  sock_sendmsg+0x38/0x50
[  832.859089]  SYSC_sendto+0x101/0x190
[  832.859096]  ? SYSC_getsockname+0x89/0xe0
[  832.859102]  ? fd_install+0x25/0x30
[  832.859108]  ? sock_map_fd+0x44/0x70
[  832.859112]  SyS_sendto+0xe/0x10
[  832.859117]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.859121] RIP: 0033:0x7f87f22ac4d3
[  832.859123] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  832.859127] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  832.859129] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  832.859131] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  832.859133] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  832.859135] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  832.859141] NetworkManager  D    0   990      1 0x00000004
[  832.859145] Call Trace:
[  832.859149]  __schedule+0x3c2/0x8b0
[  832.859153]  schedule+0x36/0x80
[  832.859157]  schedule_preempt_disabled+0xe/0x10
[  832.859160]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.859166]  ? ___slab_alloc+0x32b/0x4c0
[  832.859171]  __mutex_lock_slowpath+0x13/0x20
[  832.859174]  ? __mutex_lock_slowpath+0x13/0x20
[  832.859177]  mutex_lock+0x2f/0x40
[  832.859181]  rtnl_lock+0x15/0x20
[  832.859187]  dev_ioctl+0x312/0x530
[  832.859191]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  832.859197]  sock_do_ioctl+0x42/0x50
[  832.859202]  ? sock_do_ioctl+0x42/0x50
[  832.859207]  sock_ioctl+0x1f6/0x2c0
[  832.859211]  ? alloc_file+0x69/0xe0
[  832.859216]  do_vfs_ioctl+0xa1/0x5d0
[  832.859222]  ? sock_alloc_file+0xa6/0x130
[  832.859227]  SyS_ioctl+0x79/0x90
[  832.859232]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.859234] RIP: 0033:0x7f9d454bbf07
[  832.859236] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  832.859240] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  832.859242] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  832.859244] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  832.859246] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  832.859248] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  832.859256] wpa_supplicant  D    0  1049      1 0x00000004
[  832.859259] Call Trace:
[  832.859263]  __schedule+0x3c2/0x8b0
[  832.859267]  schedule+0x36/0x80
[  832.859271]  schedule_timeout+0x17a/0x360
[  832.859277]  ? call_timer_fn+0x140/0x140
[  832.859283]  msleep+0x2e/0x40
[  832.859287]  ? msleep+0x2e/0x40
[  832.859297]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  832.859319]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  832.859334]  ath10k_halt+0x102/0x160 [ath10k_core]
[  832.859348]  ath10k_stop+0x39/0x80 [ath10k_core]
[  832.859391]  drv_stop+0x33/0xf0 [mac80211]
[  832.859434]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  832.859470]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  832.859476]  ? __rtnl_unlock+0x2a/0x50
[  832.859481]  ? nla_memcpy+0x26/0x50
[  832.859516]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  832.859552]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  832.859589]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  832.859621]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  832.859625]  genl_family_rcv_msg+0x1f5/0x3d0
[  832.859630]  ? __netlink_sendskb+0x3e/0x60
[  832.859635]  genl_rcv_msg+0x4c/0x90
[  832.859639]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  832.859643]  netlink_rcv_skb+0xe7/0x120
[  832.859648]  genl_rcv+0x28/0x40
[  832.859651]  netlink_unicast+0x18c/0x240
[  832.859655]  netlink_sendmsg+0x2c5/0x3a0
[  832.859660]  sock_sendmsg+0x38/0x50
[  832.859663]  ___sys_sendmsg+0x2b6/0x2d0
[  832.859667]  ? netlink_sendmsg+0x133/0x3a0
[  832.859675]  ? kzfree+0x2d/0x40
[  832.859681]  ? dput+0xc7/0x1f0
[  832.859687]  ? mntput+0x24/0x40
[  832.859691]  __sys_sendmsg+0x54/0x90
[  832.859694]  ? __sys_sendmsg+0x54/0x90
[  832.859699]  SyS_sendmsg+0x12/0x20
[  832.859704]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.859706] RIP: 0033:0x7fd5b8652450
[  832.859708] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  832.859711] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  832.859713] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  832.859715] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  832.859717] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  832.859719] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  832.859726] whoopsie        D    0  1169      1 0x00000004
[  832.859730] Call Trace:
[  832.859734]  __schedule+0x3c2/0x8b0
[  832.859740]  ? __wake_up_common+0x73/0x90
[  832.859744]  schedule+0x36/0x80
[  832.859747]  schedule_preempt_disabled+0xe/0x10
[  832.859751]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.859756]  __mutex_lock_slowpath+0x13/0x20
[  832.859759]  ? __mutex_lock_slowpath+0x13/0x20
[  832.859763]  mutex_lock+0x2f/0x40
[  832.859767]  rtnetlink_rcv+0x19/0x30
[  832.859770]  netlink_unicast+0x18c/0x240
[  832.859774]  netlink_sendmsg+0x2c5/0x3a0
[  832.859778]  sock_sendmsg+0x38/0x50
[  832.859781]  SYSC_sendto+0x101/0x190
[  832.859786]  ? security_file_permission+0x9b/0xc0
[  832.859792]  ? vfs_read+0x93/0x130
[  832.859796]  SyS_sendto+0xe/0x10
[  832.859801]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.859803] RIP: 0033:0x7f804d02a3ff
[  832.859804] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.859808] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  832.859810] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  832.859811] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  832.859813] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  832.859815] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  832.859846] gnome-software  D    0  2123   1992 0x00000004
[  832.859850] Call Trace:
[  832.859854]  __schedule+0x3c2/0x8b0
[  832.859858]  schedule+0x36/0x80
[  832.859861]  schedule_preempt_disabled+0xe/0x10
[  832.859864]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.859870]  __mutex_lock_slowpath+0x13/0x20
[  832.859873]  ? __mutex_lock_slowpath+0x13/0x20
[  832.859876]  mutex_lock+0x2f/0x40
[  832.859880]  rtnetlink_rcv+0x19/0x30
[  832.859883]  netlink_unicast+0x18c/0x240
[  832.859887]  netlink_sendmsg+0x2c5/0x3a0
[  832.859891]  sock_sendmsg+0x38/0x50
[  832.859894]  SYSC_sendto+0x101/0x190
[  832.859898]  ? security_file_permission+0x9b/0xc0
[  832.859903]  ? vfs_read+0x93/0x130
[  832.859907]  SyS_sendto+0xe/0x10
[  832.859912]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.859914] RIP: 0033:0x7f483f67e9ff
[  832.859915] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.859918] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  832.859920] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  832.859921] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  832.859923] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  832.859925] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  832.859943] evolution-calen D    0  2487   2464 0x00000004
[  832.859946] Call Trace:
[  832.859950]  __schedule+0x3c2/0x8b0
[  832.859954]  schedule+0x36/0x80
[  832.859957]  schedule_preempt_disabled+0xe/0x10
[  832.859960]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.859965]  __mutex_lock_slowpath+0x13/0x20
[  832.859969]  ? __mutex_lock_slowpath+0x13/0x20
[  832.859972]  mutex_lock+0x2f/0x40
[  832.859975]  rtnetlink_rcv+0x19/0x30
[  832.859979]  netlink_unicast+0x18c/0x240
[  832.859982]  netlink_sendmsg+0x2c5/0x3a0
[  832.859986]  sock_sendmsg+0x38/0x50
[  832.859989]  SYSC_sendto+0x101/0x190
[  832.859993]  ? security_file_permission+0x9b/0xc0
[  832.860032]  ? vfs_read+0x93/0x130
[  832.860036]  SyS_sendto+0xe/0x10
[  832.860041]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860043] RIP: 0033:0x7f2764fc19ff
[  832.860044] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860047] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  832.860049] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  832.860051] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  832.860052] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  832.860054] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  832.860060] evolution-calen D    0  2499   2464 0x00000004
[  832.860063] Call Trace:
[  832.860067]  __schedule+0x3c2/0x8b0
[  832.860071]  schedule+0x36/0x80
[  832.860074]  schedule_preempt_disabled+0xe/0x10
[  832.860078]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.860083]  __mutex_lock_slowpath+0x13/0x20
[  832.860086]  ? __mutex_lock_slowpath+0x13/0x20
[  832.860089]  mutex_lock+0x2f/0x40
[  832.860093]  rtnetlink_rcv+0x19/0x30
[  832.860096]  netlink_unicast+0x18c/0x240
[  832.860100]  netlink_sendmsg+0x2c5/0x3a0
[  832.860104]  sock_sendmsg+0x38/0x50
[  832.860107]  SYSC_sendto+0x101/0x190
[  832.860111]  ? security_file_permission+0x9b/0xc0
[  832.860116]  ? vfs_read+0x93/0x130
[  832.860120]  SyS_sendto+0xe/0x10
[  832.860124]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860126] RIP: 0033:0x7fb2c6e629ff
[  832.860127] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860131] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  832.860132] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  832.860134] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  832.860136] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  832.860137] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  832.860142] evolution-addre D    0  2519   2497 0x00000004
[  832.860145] Call Trace:
[  832.860149]  __schedule+0x3c2/0x8b0
[  832.860153]  schedule+0x36/0x80
[  832.860156]  schedule_preempt_disabled+0xe/0x10
[  832.860159]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.860164]  __mutex_lock_slowpath+0x13/0x20
[  832.860168]  ? __mutex_lock_slowpath+0x13/0x20
[  832.860171]  mutex_lock+0x2f/0x40
[  832.860174]  rtnetlink_rcv+0x19/0x30
[  832.860178]  netlink_unicast+0x18c/0x240
[  832.860181]  netlink_sendmsg+0x2c5/0x3a0
[  832.860185]  sock_sendmsg+0x38/0x50
[  832.860188]  SYSC_sendto+0x101/0x190
[  832.860192]  ? security_file_permission+0x9b/0xc0
[  832.860197]  ? vfs_read+0x93/0x130
[  832.860201]  SyS_sendto+0xe/0x10
[  832.860205]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860207] RIP: 0033:0x7f4a6d1aa9ff
[  832.860209] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860212] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  832.860213] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  832.860215] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  832.860217] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  832.860219] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  832.860228] geoclue         D    0  2681      1 0x00000004
[  832.860232] Call Trace:
[  832.860235]  __schedule+0x3c2/0x8b0
[  832.860239]  ? consume_skb+0x34/0xa0
[  832.860242]  schedule+0x36/0x80
[  832.860246]  schedule_preempt_disabled+0xe/0x10
[  832.860249]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.860254]  __mutex_lock_slowpath+0x13/0x20
[  832.860257]  ? __mutex_lock_slowpath+0x13/0x20
[  832.860260]  mutex_lock+0x2f/0x40
[  832.860264]  rtnetlink_rcv+0x19/0x30
[  832.860267]  netlink_unicast+0x18c/0x240
[  832.860271]  netlink_sendmsg+0x2c5/0x3a0
[  832.860275]  sock_sendmsg+0x38/0x50
[  832.860278]  SYSC_sendto+0x101/0x190
[  832.860282]  ? security_file_permission+0x9b/0xc0
[  832.860287]  ? vfs_read+0x93/0x130
[  832.860291]  SyS_sendto+0xe/0x10
[  832.860295]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860297] RIP: 0033:0x7f22fe6c13ff
[  832.860298] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860302] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  832.860303] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  832.860305] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  832.860307] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  832.860308] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  832.860328] deja-dup-monito D    0  2923   1992 0x00000004
[  832.860331] Call Trace:
[  832.860335]  __schedule+0x3c2/0x8b0
[  832.860339]  schedule+0x36/0x80
[  832.860342]  schedule_preempt_disabled+0xe/0x10
[  832.860345]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.860350]  __mutex_lock_slowpath+0x13/0x20
[  832.860354]  ? __mutex_lock_slowpath+0x13/0x20
[  832.860357]  mutex_lock+0x2f/0x40
[  832.860361]  rtnetlink_rcv+0x19/0x30
[  832.860364]  netlink_unicast+0x18c/0x240
[  832.860368]  netlink_sendmsg+0x2c5/0x3a0
[  832.860371]  sock_sendmsg+0x38/0x50
[  832.860374]  SYSC_sendto+0x101/0x190
[  832.860378]  ? security_file_permission+0x9b/0xc0
[  832.860383]  ? vfs_read+0x93/0x130
[  832.860387]  SyS_sendto+0xe/0x10
[  832.860391]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860393] RIP: 0033:0x7ff26c2df9ff
[  832.860395] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860398] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  832.860399] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  832.860401] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  832.860403] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  832.860404] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  832.860415] ip              D    0 14444  14443 0x00000004
[  832.860418] Call Trace:
[  832.860422]  __schedule+0x3c2/0x8b0
[  832.860426]  schedule+0x36/0x80
[  832.860429]  schedule_preempt_disabled+0xe/0x10
[  832.860432]  __mutex_lock.isra.2+0x2ae/0x4e0
[  832.860437]  ? current_time+0x38/0x70
[  832.860441]  __mutex_lock_slowpath+0x13/0x20
[  832.860444]  ? __mutex_lock_slowpath+0x13/0x20
[  832.860447]  mutex_lock+0x2f/0x40
[  832.860451]  rtnetlink_rcv+0x19/0x30
[  832.860454]  netlink_unicast+0x18c/0x240
[  832.860458]  netlink_sendmsg+0x2c5/0x3a0
[  832.860462]  sock_sendmsg+0x38/0x50
[  832.860465]  SYSC_sendto+0x101/0x190
[  832.860471]  ? handle_mm_fault+0xcc/0x1c0
[  832.860478]  ? __do_page_fault+0x283/0x4f0
[  832.860482]  SyS_sendto+0xe/0x10
[  832.860487]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  832.860489] RIP: 0033:0x7fb0aae9f39d
[  832.860490] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  832.860493] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  832.860495] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  832.860497] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  832.860498] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  832.860500] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  832.860508] OOM killer enabled.
[  832.860509] Restarting tasks ... done.
[  842.990330] PM: Syncing filesystems ... done.
[  843.140905] PM: Preparing system for sleep (mem)
[  843.141416] Freezing user space processes ... 
[  863.145924] Freezing of tasks failed after 20.004 seconds (12 tasks refusing to freeze, wq_busy=0):
[  863.145959] cups-browsed    D    0   989      1 0x00000004
[  863.145964] Call Trace:
[  863.145978]  __schedule+0x3c2/0x8b0
[  863.145983]  ? consume_skb+0x34/0xa0
[  863.145987]  schedule+0x36/0x80
[  863.145991]  schedule_preempt_disabled+0xe/0x10
[  863.145995]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146000]  __mutex_lock_slowpath+0x13/0x20
[  863.146004]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146007]  mutex_lock+0x2f/0x40
[  863.146012]  rtnetlink_rcv+0x19/0x30
[  863.146017]  netlink_unicast+0x18c/0x240
[  863.146021]  netlink_sendmsg+0x2c5/0x3a0
[  863.146025]  sock_sendmsg+0x38/0x50
[  863.146028]  SYSC_sendto+0x101/0x190
[  863.146036]  ? SYSC_getsockname+0x89/0xe0
[  863.146042]  ? fd_install+0x25/0x30
[  863.146047]  ? sock_map_fd+0x44/0x70
[  863.146051]  SyS_sendto+0xe/0x10
[  863.146057]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146060] RIP: 0033:0x7f87f22ac4d3
[  863.146063] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  863.146067] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  863.146069] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  863.146071] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  863.146073] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  863.146075] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  863.146081] NetworkManager  D    0   990      1 0x00000004
[  863.146085] Call Trace:
[  863.146089]  __schedule+0x3c2/0x8b0
[  863.146093]  schedule+0x36/0x80
[  863.146097]  schedule_preempt_disabled+0xe/0x10
[  863.146100]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146106]  ? ___slab_alloc+0x32b/0x4c0
[  863.146111]  __mutex_lock_slowpath+0x13/0x20
[  863.146114]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146117]  mutex_lock+0x2f/0x40
[  863.146121]  rtnl_lock+0x15/0x20
[  863.146126]  dev_ioctl+0x312/0x530
[  863.146131]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  863.146137]  sock_do_ioctl+0x42/0x50
[  863.146142]  ? sock_do_ioctl+0x42/0x50
[  863.146147]  sock_ioctl+0x1f6/0x2c0
[  863.146151]  ? alloc_file+0x69/0xe0
[  863.146156]  do_vfs_ioctl+0xa1/0x5d0
[  863.146161]  ? sock_alloc_file+0xa6/0x130
[  863.146166]  SyS_ioctl+0x79/0x90
[  863.146171]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146174] RIP: 0033:0x7f9d454bbf07
[  863.146176] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  863.146179] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  863.146181] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  863.146183] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  863.146185] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  863.146187] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  863.146195] wpa_supplicant  D    0  1049      1 0x00000004
[  863.146198] Call Trace:
[  863.146202]  __schedule+0x3c2/0x8b0
[  863.146206]  schedule+0x36/0x80
[  863.146210]  schedule_timeout+0x17a/0x360
[  863.146216]  ? call_timer_fn+0x140/0x140
[  863.146222]  msleep+0x2e/0x40
[  863.146226]  ? msleep+0x2e/0x40
[  863.146236]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  863.146259]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  863.146274]  ath10k_halt+0x102/0x160 [ath10k_core]
[  863.146288]  ath10k_stop+0x39/0x80 [ath10k_core]
[  863.146331]  drv_stop+0x33/0xf0 [mac80211]
[  863.146374]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  863.146410]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  863.146416]  ? __rtnl_unlock+0x2a/0x50
[  863.146421]  ? nla_memcpy+0x26/0x50
[  863.146456]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  863.146492]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  863.146528]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  863.146560]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  863.146564]  genl_family_rcv_msg+0x1f5/0x3d0
[  863.146569]  ? __netlink_sendskb+0x3e/0x60
[  863.146574]  genl_rcv_msg+0x4c/0x90
[  863.146578]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  863.146582]  netlink_rcv_skb+0xe7/0x120
[  863.146587]  genl_rcv+0x28/0x40
[  863.146590]  netlink_unicast+0x18c/0x240
[  863.146594]  netlink_sendmsg+0x2c5/0x3a0
[  863.146599]  sock_sendmsg+0x38/0x50
[  863.146602]  ___sys_sendmsg+0x2b6/0x2d0
[  863.146607]  ? netlink_sendmsg+0x133/0x3a0
[  863.146615]  ? kzfree+0x2d/0x40
[  863.146621]  ? dput+0xc7/0x1f0
[  863.146626]  ? mntput+0x24/0x40
[  863.146630]  __sys_sendmsg+0x54/0x90
[  863.146633]  ? __sys_sendmsg+0x54/0x90
[  863.146638]  SyS_sendmsg+0x12/0x20
[  863.146643]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146646] RIP: 0033:0x7fd5b8652450
[  863.146647] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  863.146651] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  863.146653] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  863.146654] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  863.146657] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  863.146658] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  863.146666] whoopsie        D    0  1169      1 0x00000004
[  863.146669] Call Trace:
[  863.146674]  __schedule+0x3c2/0x8b0
[  863.146679]  ? __wake_up_common+0x73/0x90
[  863.146683]  schedule+0x36/0x80
[  863.146686]  schedule_preempt_disabled+0xe/0x10
[  863.146690]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146695]  __mutex_lock_slowpath+0x13/0x20
[  863.146699]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146702]  mutex_lock+0x2f/0x40
[  863.146706]  rtnetlink_rcv+0x19/0x30
[  863.146709]  netlink_unicast+0x18c/0x240
[  863.146713]  netlink_sendmsg+0x2c5/0x3a0
[  863.146717]  sock_sendmsg+0x38/0x50
[  863.146720]  SYSC_sendto+0x101/0x190
[  863.146725]  ? security_file_permission+0x9b/0xc0
[  863.146731]  ? vfs_read+0x93/0x130
[  863.146736]  SyS_sendto+0xe/0x10
[  863.146740]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146742] RIP: 0033:0x7f804d02a3ff
[  863.146744] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.146747] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  863.146749] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  863.146750] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  863.146752] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  863.146754] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  863.146785] gnome-software  D    0  2123   1992 0x00000004
[  863.146789] Call Trace:
[  863.146793]  __schedule+0x3c2/0x8b0
[  863.146797]  schedule+0x36/0x80
[  863.146800]  schedule_preempt_disabled+0xe/0x10
[  863.146804]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146809]  __mutex_lock_slowpath+0x13/0x20
[  863.146812]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146816]  mutex_lock+0x2f/0x40
[  863.146819]  rtnetlink_rcv+0x19/0x30
[  863.146823]  netlink_unicast+0x18c/0x240
[  863.146826]  netlink_sendmsg+0x2c5/0x3a0
[  863.146830]  sock_sendmsg+0x38/0x50
[  863.146833]  SYSC_sendto+0x101/0x190
[  863.146837]  ? security_file_permission+0x9b/0xc0
[  863.146843]  ? vfs_read+0x93/0x130
[  863.146847]  SyS_sendto+0xe/0x10
[  863.146851]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146853] RIP: 0033:0x7f483f67e9ff
[  863.146855] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.146858] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  863.146859] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  863.146861] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  863.146863] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  863.146865] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  863.146882] evolution-calen D    0  2487   2464 0x00000004
[  863.146885] Call Trace:
[  863.146889]  __schedule+0x3c2/0x8b0
[  863.146893]  schedule+0x36/0x80
[  863.146896]  schedule_preempt_disabled+0xe/0x10
[  863.146900]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146905]  __mutex_lock_slowpath+0x13/0x20
[  863.146908]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146911]  mutex_lock+0x2f/0x40
[  863.146915]  rtnetlink_rcv+0x19/0x30
[  863.146918]  netlink_unicast+0x18c/0x240
[  863.146922]  netlink_sendmsg+0x2c5/0x3a0
[  863.146926]  sock_sendmsg+0x38/0x50
[  863.146929]  SYSC_sendto+0x101/0x190
[  863.146933]  ? security_file_permission+0x9b/0xc0
[  863.146938]  ? vfs_read+0x93/0x130
[  863.146942]  SyS_sendto+0xe/0x10
[  863.146946]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.146948] RIP: 0033:0x7f2764fc19ff
[  863.146950] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.146953] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  863.146954] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  863.146956] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  863.146958] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  863.146959] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  863.146965] evolution-calen D    0  2499   2464 0x00000004
[  863.146968] Call Trace:
[  863.146972]  __schedule+0x3c2/0x8b0
[  863.146976]  schedule+0x36/0x80
[  863.146979]  schedule_preempt_disabled+0xe/0x10
[  863.146982]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.146987]  __mutex_lock_slowpath+0x13/0x20
[  863.146991]  ? __mutex_lock_slowpath+0x13/0x20
[  863.146994]  mutex_lock+0x2f/0x40
[  863.146997]  rtnetlink_rcv+0x19/0x30
[  863.147001]  netlink_unicast+0x18c/0x240
[  863.147004]  netlink_sendmsg+0x2c5/0x3a0
[  863.147008]  sock_sendmsg+0x38/0x50
[  863.147011]  SYSC_sendto+0x101/0x190
[  863.147015]  ? security_file_permission+0x9b/0xc0
[  863.147020]  ? vfs_read+0x93/0x130
[  863.147024]  SyS_sendto+0xe/0x10
[  863.147028]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147030] RIP: 0033:0x7fb2c6e629ff
[  863.147032] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.147035] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  863.147036] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  863.147038] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  863.147040] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  863.147042] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  863.147046] evolution-addre D    0  2519   2497 0x00000004
[  863.147049] Call Trace:
[  863.147053]  __schedule+0x3c2/0x8b0
[  863.147057]  schedule+0x36/0x80
[  863.147060]  schedule_preempt_disabled+0xe/0x10
[  863.147063]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.147068]  __mutex_lock_slowpath+0x13/0x20
[  863.147072]  ? __mutex_lock_slowpath+0x13/0x20
[  863.147075]  mutex_lock+0x2f/0x40
[  863.147079]  rtnetlink_rcv+0x19/0x30
[  863.147082]  netlink_unicast+0x18c/0x240
[  863.147086]  netlink_sendmsg+0x2c5/0x3a0
[  863.147089]  sock_sendmsg+0x38/0x50
[  863.147092]  SYSC_sendto+0x101/0x190
[  863.147096]  ? security_file_permission+0x9b/0xc0
[  863.147101]  ? vfs_read+0x93/0x130
[  863.147105]  SyS_sendto+0xe/0x10
[  863.147109]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147111] RIP: 0033:0x7f4a6d1aa9ff
[  863.147113] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.147116] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  863.147118] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  863.147119] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  863.147121] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  863.147123] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  863.147132] geoclue         D    0  2681      1 0x00000004
[  863.147136] Call Trace:
[  863.147139]  __schedule+0x3c2/0x8b0
[  863.147142]  ? consume_skb+0x34/0xa0
[  863.147146]  schedule+0x36/0x80
[  863.147149]  schedule_preempt_disabled+0xe/0x10
[  863.147153]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.147158]  __mutex_lock_slowpath+0x13/0x20
[  863.147161]  ? __mutex_lock_slowpath+0x13/0x20
[  863.147164]  mutex_lock+0x2f/0x40
[  863.147168]  rtnetlink_rcv+0x19/0x30
[  863.147171]  netlink_unicast+0x18c/0x240
[  863.147175]  netlink_sendmsg+0x2c5/0x3a0
[  863.147179]  sock_sendmsg+0x38/0x50
[  863.147182]  SYSC_sendto+0x101/0x190
[  863.147186]  ? security_file_permission+0x9b/0xc0
[  863.147191]  ? vfs_read+0x93/0x130
[  863.147195]  SyS_sendto+0xe/0x10
[  863.147199]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147201] RIP: 0033:0x7f22fe6c13ff
[  863.147203] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.147206] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  863.147208] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  863.147209] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  863.147211] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  863.147213] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  863.147225] DNS Resolver #3 D    0 14484   1715 0x00000004
[  863.147228] Call Trace:
[  863.147232]  __schedule+0x3c2/0x8b0
[  863.147236]  schedule+0x36/0x80
[  863.147239]  schedule_preempt_disabled+0xe/0x10
[  863.147242]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.147247]  __mutex_lock_slowpath+0x13/0x20
[  863.147251]  ? __mutex_lock_slowpath+0x13/0x20
[  863.147254]  mutex_lock+0x2f/0x40
[  863.147257]  rtnetlink_rcv+0x19/0x30
[  863.147261]  netlink_unicast+0x18c/0x240
[  863.147264]  netlink_sendmsg+0x2c5/0x3a0
[  863.147268]  sock_sendmsg+0x38/0x50
[  863.147271]  SYSC_sendto+0x101/0x190
[  863.147278]  ? SYSC_getsockname+0x89/0xe0
[  863.147283]  ? fd_install+0x25/0x30
[  863.147288]  ? sock_map_fd+0x44/0x70
[  863.147291]  SyS_sendto+0xe/0x10
[  863.147296]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147298] RIP: 0033:0x7fec02b384d3
[  863.147299] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  863.147302] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  863.147304] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  863.147306] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  863.147308] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  863.147309] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  863.147320] deja-dup-monito D    0  2923   1992 0x00000004
[  863.147323] Call Trace:
[  863.147327]  __schedule+0x3c2/0x8b0
[  863.147331]  schedule+0x36/0x80
[  863.147334]  schedule_preempt_disabled+0xe/0x10
[  863.147338]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.147343]  __mutex_lock_slowpath+0x13/0x20
[  863.147346]  ? __mutex_lock_slowpath+0x13/0x20
[  863.147349]  mutex_lock+0x2f/0x40
[  863.147353]  rtnetlink_rcv+0x19/0x30
[  863.147356]  netlink_unicast+0x18c/0x240
[  863.147360]  netlink_sendmsg+0x2c5/0x3a0
[  863.147364]  sock_sendmsg+0x38/0x50
[  863.147367]  SYSC_sendto+0x101/0x190
[  863.147371]  ? security_file_permission+0x9b/0xc0
[  863.147376]  ? vfs_read+0x93/0x130
[  863.147380]  SyS_sendto+0xe/0x10
[  863.147384]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147386] RIP: 0033:0x7ff26c2df9ff
[  863.147388] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.147391] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  863.147392] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  863.147394] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  863.147396] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  863.147398] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  863.147408] ip              D    0 14444  14443 0x00000004
[  863.147411] Call Trace:
[  863.147415]  __schedule+0x3c2/0x8b0
[  863.147419]  schedule+0x36/0x80
[  863.147422]  schedule_preempt_disabled+0xe/0x10
[  863.147425]  __mutex_lock.isra.2+0x2ae/0x4e0
[  863.147429]  ? current_time+0x38/0x70
[  863.147434]  __mutex_lock_slowpath+0x13/0x20
[  863.147437]  ? __mutex_lock_slowpath+0x13/0x20
[  863.147440]  mutex_lock+0x2f/0x40
[  863.147444]  rtnetlink_rcv+0x19/0x30
[  863.147447]  netlink_unicast+0x18c/0x240
[  863.147451]  netlink_sendmsg+0x2c5/0x3a0
[  863.147454]  sock_sendmsg+0x38/0x50
[  863.147457]  SYSC_sendto+0x101/0x190
[  863.147464]  ? handle_mm_fault+0xcc/0x1c0
[  863.147471]  ? __do_page_fault+0x283/0x4f0
[  863.147475]  SyS_sendto+0xe/0x10
[  863.147480]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  863.147482] RIP: 0033:0x7fb0aae9f39d
[  863.147483] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  863.147486] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  863.147488] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  863.147490] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  863.147491] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  863.147493] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  863.147501] OOM killer enabled.
[  863.147502] Restarting tasks ... done.
[  863.257541] PM: Syncing filesystems ... done.
[  863.585655] PM: Preparing system for sleep (freeze)
[  863.585816] Freezing user space processes ... 
[  883.595822] Freezing of tasks failed after 20.009 seconds (12 tasks refusing to freeze, wq_busy=0):
[  883.595856] cups-browsed    D    0   989      1 0x00000004
[  883.595861] Call Trace:
[  883.595874]  __schedule+0x3c2/0x8b0
[  883.595879]  ? consume_skb+0x34/0xa0
[  883.595883]  schedule+0x36/0x80
[  883.595887]  schedule_preempt_disabled+0xe/0x10
[  883.595891]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.595897]  __mutex_lock_slowpath+0x13/0x20
[  883.595900]  ? __mutex_lock_slowpath+0x13/0x20
[  883.595904]  mutex_lock+0x2f/0x40
[  883.595908]  rtnetlink_rcv+0x19/0x30
[  883.595913]  netlink_unicast+0x18c/0x240
[  883.595917]  netlink_sendmsg+0x2c5/0x3a0
[  883.595922]  sock_sendmsg+0x38/0x50
[  883.595925]  SYSC_sendto+0x101/0x190
[  883.595932]  ? SYSC_getsockname+0x89/0xe0
[  883.595939]  ? fd_install+0x25/0x30
[  883.595944]  ? sock_map_fd+0x44/0x70
[  883.595948]  SyS_sendto+0xe/0x10
[  883.595953]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.595957] RIP: 0033:0x7f87f22ac4d3
[  883.595959] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  883.595963] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  883.595965] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  883.595967] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  883.595969] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  883.595971] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  883.595977] NetworkManager  D    0   990      1 0x00000004
[  883.595981] Call Trace:
[  883.595985]  __schedule+0x3c2/0x8b0
[  883.595989]  schedule+0x36/0x80
[  883.595992]  schedule_preempt_disabled+0xe/0x10
[  883.595996]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596024]  ? ___slab_alloc+0x32b/0x4c0
[  883.596029]  __mutex_lock_slowpath+0x13/0x20
[  883.596032]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596035]  mutex_lock+0x2f/0x40
[  883.596039]  rtnl_lock+0x15/0x20
[  883.596045]  dev_ioctl+0x312/0x530
[  883.596049]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  883.596056]  sock_do_ioctl+0x42/0x50
[  883.596061]  ? sock_do_ioctl+0x42/0x50
[  883.596066]  sock_ioctl+0x1f6/0x2c0
[  883.596070]  ? alloc_file+0x69/0xe0
[  883.596075]  do_vfs_ioctl+0xa1/0x5d0
[  883.596080]  ? sock_alloc_file+0xa6/0x130
[  883.596086]  SyS_ioctl+0x79/0x90
[  883.596091]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596093] RIP: 0033:0x7f9d454bbf07
[  883.596095] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  883.596099] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  883.596101] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  883.596103] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  883.596104] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  883.596106] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  883.596115] wpa_supplicant  D    0  1049      1 0x00000004
[  883.596118] Call Trace:
[  883.596122]  __schedule+0x3c2/0x8b0
[  883.596126]  schedule+0x36/0x80
[  883.596130]  schedule_timeout+0x17a/0x360
[  883.596136]  ? call_timer_fn+0x140/0x140
[  883.596141]  msleep+0x2e/0x40
[  883.596146]  ? msleep+0x2e/0x40
[  883.596156]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  883.596177]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  883.596192]  ath10k_halt+0x102/0x160 [ath10k_core]
[  883.596207]  ath10k_stop+0x39/0x80 [ath10k_core]
[  883.596249]  drv_stop+0x33/0xf0 [mac80211]
[  883.596292]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  883.596328]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  883.596334]  ? __rtnl_unlock+0x2a/0x50
[  883.596339]  ? nla_memcpy+0x26/0x50
[  883.596374]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  883.596409]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  883.596446]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  883.596477]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  883.596482]  genl_family_rcv_msg+0x1f5/0x3d0
[  883.596486]  ? __netlink_sendskb+0x3e/0x60
[  883.596492]  genl_rcv_msg+0x4c/0x90
[  883.596496]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  883.596499]  netlink_rcv_skb+0xe7/0x120
[  883.596504]  genl_rcv+0x28/0x40
[  883.596507]  netlink_unicast+0x18c/0x240
[  883.596511]  netlink_sendmsg+0x2c5/0x3a0
[  883.596516]  sock_sendmsg+0x38/0x50
[  883.596519]  ___sys_sendmsg+0x2b6/0x2d0
[  883.596523]  ? netlink_sendmsg+0x133/0x3a0
[  883.596531]  ? kzfree+0x2d/0x40
[  883.596537]  ? dput+0xc7/0x1f0
[  883.596542]  ? mntput+0x24/0x40
[  883.596546]  __sys_sendmsg+0x54/0x90
[  883.596549]  ? __sys_sendmsg+0x54/0x90
[  883.596554]  SyS_sendmsg+0x12/0x20
[  883.596559]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596562] RIP: 0033:0x7fd5b8652450
[  883.596564] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  883.596567] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  883.596569] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  883.596571] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  883.596573] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  883.596574] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  883.596582] whoopsie        D    0  1169      1 0x00000004
[  883.596586] Call Trace:
[  883.596590]  __schedule+0x3c2/0x8b0
[  883.596595]  ? __wake_up_common+0x73/0x90
[  883.596599]  schedule+0x36/0x80
[  883.596603]  schedule_preempt_disabled+0xe/0x10
[  883.596606]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596611]  __mutex_lock_slowpath+0x13/0x20
[  883.596615]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596618]  mutex_lock+0x2f/0x40
[  883.596622]  rtnetlink_rcv+0x19/0x30
[  883.596626]  netlink_unicast+0x18c/0x240
[  883.596630]  netlink_sendmsg+0x2c5/0x3a0
[  883.596634]  sock_sendmsg+0x38/0x50
[  883.596637]  SYSC_sendto+0x101/0x190
[  883.596642]  ? security_file_permission+0x9b/0xc0
[  883.596648]  ? vfs_read+0x93/0x130
[  883.596652]  SyS_sendto+0xe/0x10
[  883.596657]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596659] RIP: 0033:0x7f804d02a3ff
[  883.596660] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.596664] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  883.596665] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  883.596667] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  883.596669] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  883.596671] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  883.596703] gnome-software  D    0  2123   1992 0x00000004
[  883.596707] Call Trace:
[  883.596711]  __schedule+0x3c2/0x8b0
[  883.596715]  schedule+0x36/0x80
[  883.596718]  schedule_preempt_disabled+0xe/0x10
[  883.596721]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596726]  __mutex_lock_slowpath+0x13/0x20
[  883.596730]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596733]  mutex_lock+0x2f/0x40
[  883.596736]  rtnetlink_rcv+0x19/0x30
[  883.596740]  netlink_unicast+0x18c/0x240
[  883.596744]  netlink_sendmsg+0x2c5/0x3a0
[  883.596748]  sock_sendmsg+0x38/0x50
[  883.596751]  SYSC_sendto+0x101/0x190
[  883.596755]  ? security_file_permission+0x9b/0xc0
[  883.596760]  ? vfs_read+0x93/0x130
[  883.596764]  SyS_sendto+0xe/0x10
[  883.596769]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596770] RIP: 0033:0x7f483f67e9ff
[  883.596772] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.596775] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  883.596777] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  883.596778] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  883.596780] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  883.596782] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  883.596800] evolution-calen D    0  2487   2464 0x00000004
[  883.596803] Call Trace:
[  883.596807]  __schedule+0x3c2/0x8b0
[  883.596811]  schedule+0x36/0x80
[  883.596814]  schedule_preempt_disabled+0xe/0x10
[  883.596817]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596823]  __mutex_lock_slowpath+0x13/0x20
[  883.596826]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596829]  mutex_lock+0x2f/0x40
[  883.596833]  rtnetlink_rcv+0x19/0x30
[  883.596836]  netlink_unicast+0x18c/0x240
[  883.596840]  netlink_sendmsg+0x2c5/0x3a0
[  883.596844]  sock_sendmsg+0x38/0x50
[  883.596847]  SYSC_sendto+0x101/0x190
[  883.596850]  ? security_file_permission+0x9b/0xc0
[  883.596856]  ? vfs_read+0x93/0x130
[  883.596860]  SyS_sendto+0xe/0x10
[  883.596864]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596866] RIP: 0033:0x7f2764fc19ff
[  883.596867] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.596870] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  883.596872] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  883.596874] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  883.596875] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  883.596877] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  883.596883] evolution-calen D    0  2499   2464 0x00000004
[  883.596886] Call Trace:
[  883.596889]  __schedule+0x3c2/0x8b0
[  883.596893]  schedule+0x36/0x80
[  883.596896]  schedule_preempt_disabled+0xe/0x10
[  883.596900]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596905]  __mutex_lock_slowpath+0x13/0x20
[  883.596908]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596911]  mutex_lock+0x2f/0x40
[  883.596915]  rtnetlink_rcv+0x19/0x30
[  883.596918]  netlink_unicast+0x18c/0x240
[  883.596922]  netlink_sendmsg+0x2c5/0x3a0
[  883.596926]  sock_sendmsg+0x38/0x50
[  883.596929]  SYSC_sendto+0x101/0x190
[  883.596933]  ? security_file_permission+0x9b/0xc0
[  883.596938]  ? vfs_read+0x93/0x130
[  883.596942]  SyS_sendto+0xe/0x10
[  883.596946]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.596948] RIP: 0033:0x7fb2c6e629ff
[  883.596949] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.596952] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  883.596954] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  883.596956] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  883.596957] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  883.596959] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  883.596964] evolution-addre D    0  2519   2497 0x00000004
[  883.596967] Call Trace:
[  883.596971]  __schedule+0x3c2/0x8b0
[  883.596975]  schedule+0x36/0x80
[  883.596978]  schedule_preempt_disabled+0xe/0x10
[  883.596981]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.596986]  __mutex_lock_slowpath+0x13/0x20
[  883.596989]  ? __mutex_lock_slowpath+0x13/0x20
[  883.596992]  mutex_lock+0x2f/0x40
[  883.596996]  rtnetlink_rcv+0x19/0x30
[  883.596999]  netlink_unicast+0x18c/0x240
[  883.597003]  netlink_sendmsg+0x2c5/0x3a0
[  883.597007]  sock_sendmsg+0x38/0x50
[  883.597010]  SYSC_sendto+0x101/0x190
[  883.597014]  ? security_file_permission+0x9b/0xc0
[  883.597019]  ? vfs_read+0x93/0x130
[  883.597023]  SyS_sendto+0xe/0x10
[  883.597027]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.597029] RIP: 0033:0x7f4a6d1aa9ff
[  883.597030] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.597033] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  883.597035] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  883.597037] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  883.597038] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  883.597040] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  883.597050] geoclue         D    0  2681      1 0x00000004
[  883.597053] Call Trace:
[  883.597056]  __schedule+0x3c2/0x8b0
[  883.597060]  ? consume_skb+0x34/0xa0
[  883.597063]  schedule+0x36/0x80
[  883.597066]  schedule_preempt_disabled+0xe/0x10
[  883.597070]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.597075]  __mutex_lock_slowpath+0x13/0x20
[  883.597078]  ? __mutex_lock_slowpath+0x13/0x20
[  883.597081]  mutex_lock+0x2f/0x40
[  883.597085]  rtnetlink_rcv+0x19/0x30
[  883.597088]  netlink_unicast+0x18c/0x240
[  883.597092]  netlink_sendmsg+0x2c5/0x3a0
[  883.597096]  sock_sendmsg+0x38/0x50
[  883.597099]  SYSC_sendto+0x101/0x190
[  883.597103]  ? security_file_permission+0x9b/0xc0
[  883.597108]  ? vfs_read+0x93/0x130
[  883.597112]  SyS_sendto+0xe/0x10
[  883.597116]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.597118] RIP: 0033:0x7f22fe6c13ff
[  883.597119] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.597122] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  883.597124] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  883.597126] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  883.597127] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  883.597129] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  883.597141] DNS Resolver #3 D    0 14484   1715 0x00000004
[  883.597145] Call Trace:
[  883.597148]  __schedule+0x3c2/0x8b0
[  883.597152]  schedule+0x36/0x80
[  883.597156]  schedule_preempt_disabled+0xe/0x10
[  883.597159]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.597164]  __mutex_lock_slowpath+0x13/0x20
[  883.597167]  ? __mutex_lock_slowpath+0x13/0x20
[  883.597170]  mutex_lock+0x2f/0x40
[  883.597174]  rtnetlink_rcv+0x19/0x30
[  883.597177]  netlink_unicast+0x18c/0x240
[  883.597181]  netlink_sendmsg+0x2c5/0x3a0
[  883.597185]  sock_sendmsg+0x38/0x50
[  883.597187]  SYSC_sendto+0x101/0x190
[  883.597194]  ? SYSC_getsockname+0x89/0xe0
[  883.597200]  ? fd_install+0x25/0x30
[  883.597205]  ? sock_map_fd+0x44/0x70
[  883.597208]  SyS_sendto+0xe/0x10
[  883.597213]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.597214] RIP: 0033:0x7fec02b384d3
[  883.597216] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  883.597219] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  883.597221] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  883.597223] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  883.597224] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  883.597226] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  883.597237] deja-dup-monito D    0  2923   1992 0x00000004
[  883.597240] Call Trace:
[  883.597244]  __schedule+0x3c2/0x8b0
[  883.597248]  schedule+0x36/0x80
[  883.597251]  schedule_preempt_disabled+0xe/0x10
[  883.597255]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.597260]  __mutex_lock_slowpath+0x13/0x20
[  883.597263]  ? __mutex_lock_slowpath+0x13/0x20
[  883.597266]  mutex_lock+0x2f/0x40
[  883.597269]  rtnetlink_rcv+0x19/0x30
[  883.597273]  netlink_unicast+0x18c/0x240
[  883.597277]  netlink_sendmsg+0x2c5/0x3a0
[  883.597280]  sock_sendmsg+0x38/0x50
[  883.597283]  SYSC_sendto+0x101/0x190
[  883.597287]  ? security_file_permission+0x9b/0xc0
[  883.597293]  ? vfs_read+0x93/0x130
[  883.597296]  SyS_sendto+0xe/0x10
[  883.597301]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.597303] RIP: 0033:0x7ff26c2df9ff
[  883.597304] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.597307] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  883.597309] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  883.597311] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  883.597312] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  883.597314] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  883.597324] ip              D    0 14444  14443 0x00000004
[  883.597327] Call Trace:
[  883.597331]  __schedule+0x3c2/0x8b0
[  883.597335]  schedule+0x36/0x80
[  883.597338]  schedule_preempt_disabled+0xe/0x10
[  883.597342]  __mutex_lock.isra.2+0x2ae/0x4e0
[  883.597346]  ? current_time+0x38/0x70
[  883.597350]  __mutex_lock_slowpath+0x13/0x20
[  883.597353]  ? __mutex_lock_slowpath+0x13/0x20
[  883.597356]  mutex_lock+0x2f/0x40
[  883.597360]  rtnetlink_rcv+0x19/0x30
[  883.597363]  netlink_unicast+0x18c/0x240
[  883.597367]  netlink_sendmsg+0x2c5/0x3a0
[  883.597371]  sock_sendmsg+0x38/0x50
[  883.597374]  SYSC_sendto+0x101/0x190
[  883.597380]  ? handle_mm_fault+0xcc/0x1c0
[  883.597387]  ? __do_page_fault+0x283/0x4f0
[  883.597392]  SyS_sendto+0xe/0x10
[  883.597396]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  883.597398] RIP: 0033:0x7fb0aae9f39d
[  883.597399] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  883.597402] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  883.597404] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  883.597406] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  883.597407] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  883.597409] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  883.597417] OOM killer enabled.
[  883.597418] Restarting tasks ... done.
[  893.729302] PM: Syncing filesystems ... done.
[  893.846916] PM: Preparing system for sleep (mem)
[  893.847189] Freezing user space processes ... 
[  913.851684] Freezing of tasks failed after 20.004 seconds (12 tasks refusing to freeze, wq_busy=0):
[  913.851718] cups-browsed    D    0   989      1 0x00000004
[  913.851723] Call Trace:
[  913.851737]  __schedule+0x3c2/0x8b0
[  913.851742]  ? consume_skb+0x34/0xa0
[  913.851746]  schedule+0x36/0x80
[  913.851750]  schedule_preempt_disabled+0xe/0x10
[  913.851754]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.851760]  __mutex_lock_slowpath+0x13/0x20
[  913.851764]  ? __mutex_lock_slowpath+0x13/0x20
[  913.851768]  mutex_lock+0x2f/0x40
[  913.851772]  rtnetlink_rcv+0x19/0x30
[  913.851777]  netlink_unicast+0x18c/0x240
[  913.851781]  netlink_sendmsg+0x2c5/0x3a0
[  913.851785]  sock_sendmsg+0x38/0x50
[  913.851789]  SYSC_sendto+0x101/0x190
[  913.851796]  ? SYSC_getsockname+0x89/0xe0
[  913.851803]  ? fd_install+0x25/0x30
[  913.851808]  ? sock_map_fd+0x44/0x70
[  913.851812]  SyS_sendto+0xe/0x10
[  913.851817]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.851820] RIP: 0033:0x7f87f22ac4d3
[  913.851823] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  913.851827] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  913.851829] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  913.851831] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  913.851833] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  913.851835] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  913.851840] NetworkManager  D    0   990      1 0x00000004
[  913.851844] Call Trace:
[  913.851848]  __schedule+0x3c2/0x8b0
[  913.851853]  schedule+0x36/0x80
[  913.851856]  schedule_preempt_disabled+0xe/0x10
[  913.851860]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.851866]  ? ___slab_alloc+0x32b/0x4c0
[  913.851870]  __mutex_lock_slowpath+0x13/0x20
[  913.851874]  ? __mutex_lock_slowpath+0x13/0x20
[  913.851877]  mutex_lock+0x2f/0x40
[  913.851880]  rtnl_lock+0x15/0x20
[  913.851886]  dev_ioctl+0x312/0x530
[  913.851890]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  913.851897]  sock_do_ioctl+0x42/0x50
[  913.851902]  ? sock_do_ioctl+0x42/0x50
[  913.851907]  sock_ioctl+0x1f6/0x2c0
[  913.851910]  ? alloc_file+0x69/0xe0
[  913.851916]  do_vfs_ioctl+0xa1/0x5d0
[  913.851921]  ? sock_alloc_file+0xa6/0x130
[  913.851926]  SyS_ioctl+0x79/0x90
[  913.851932]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.851934] RIP: 0033:0x7f9d454bbf07
[  913.851936] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  913.851940] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  913.851942] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  913.851944] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  913.851946] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  913.851948] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  913.851955] wpa_supplicant  D    0  1049      1 0x00000004
[  913.851958] Call Trace:
[  913.851962]  __schedule+0x3c2/0x8b0
[  913.851966]  schedule+0x36/0x80
[  913.851971]  schedule_timeout+0x17a/0x360
[  913.851977]  ? call_timer_fn+0x140/0x140
[  913.851982]  msleep+0x2e/0x40
[  913.851986]  ? msleep+0x2e/0x40
[  913.851997]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  913.852056]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  913.852071]  ath10k_halt+0x102/0x160 [ath10k_core]
[  913.852085]  ath10k_stop+0x39/0x80 [ath10k_core]
[  913.852129]  drv_stop+0x33/0xf0 [mac80211]
[  913.852174]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  913.852213]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  913.852219]  ? __rtnl_unlock+0x2a/0x50
[  913.852225]  ? nla_memcpy+0x26/0x50
[  913.852265]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  913.852305]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  913.852342]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  913.852375]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  913.852380]  genl_family_rcv_msg+0x1f5/0x3d0
[  913.852385]  ? __netlink_sendskb+0x3e/0x60
[  913.852391]  genl_rcv_msg+0x4c/0x90
[  913.852395]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  913.852399]  netlink_rcv_skb+0xe7/0x120
[  913.852404]  genl_rcv+0x28/0x40
[  913.852407]  netlink_unicast+0x18c/0x240
[  913.852412]  netlink_sendmsg+0x2c5/0x3a0
[  913.852416]  sock_sendmsg+0x38/0x50
[  913.852419]  ___sys_sendmsg+0x2b6/0x2d0
[  913.852424]  ? netlink_sendmsg+0x133/0x3a0
[  913.852432]  ? kzfree+0x2d/0x40
[  913.852438]  ? dput+0xc7/0x1f0
[  913.852444]  ? mntput+0x24/0x40
[  913.852448]  __sys_sendmsg+0x54/0x90
[  913.852451]  ? __sys_sendmsg+0x54/0x90
[  913.852456]  SyS_sendmsg+0x12/0x20
[  913.852461]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852464] RIP: 0033:0x7fd5b8652450
[  913.852467] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  913.852470] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  913.852473] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  913.852475] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  913.852477] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  913.852479] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  913.852487] whoopsie        D    0  1169      1 0x00000004
[  913.852491] Call Trace:
[  913.852495]  __schedule+0x3c2/0x8b0
[  913.852501]  ? __wake_up_common+0x73/0x90
[  913.852505]  schedule+0x36/0x80
[  913.852509]  schedule_preempt_disabled+0xe/0x10
[  913.852513]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.852518]  __mutex_lock_slowpath+0x13/0x20
[  913.852522]  ? __mutex_lock_slowpath+0x13/0x20
[  913.852525]  mutex_lock+0x2f/0x40
[  913.852529]  rtnetlink_rcv+0x19/0x30
[  913.852533]  netlink_unicast+0x18c/0x240
[  913.852538]  netlink_sendmsg+0x2c5/0x3a0
[  913.852542]  sock_sendmsg+0x38/0x50
[  913.852545]  SYSC_sendto+0x101/0x190
[  913.852550]  ? security_file_permission+0x9b/0xc0
[  913.852556]  ? vfs_read+0x93/0x130
[  913.852561]  SyS_sendto+0xe/0x10
[  913.852566]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852568] RIP: 0033:0x7f804d02a3ff
[  913.852570] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.852574] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  913.852576] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  913.852578] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  913.852580] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  913.852582] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  913.852616] gnome-software  D    0  2123   1992 0x00000004
[  913.852621] Call Trace:
[  913.852625]  __schedule+0x3c2/0x8b0
[  913.852630]  schedule+0x36/0x80
[  913.852633]  schedule_preempt_disabled+0xe/0x10
[  913.852637]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.852642]  __mutex_lock_slowpath+0x13/0x20
[  913.852646]  ? __mutex_lock_slowpath+0x13/0x20
[  913.852649]  mutex_lock+0x2f/0x40
[  913.852653]  rtnetlink_rcv+0x19/0x30
[  913.852657]  netlink_unicast+0x18c/0x240
[  913.852661]  netlink_sendmsg+0x2c5/0x3a0
[  913.852665]  sock_sendmsg+0x38/0x50
[  913.852668]  SYSC_sendto+0x101/0x190
[  913.852673]  ? security_file_permission+0x9b/0xc0
[  913.852679]  ? vfs_read+0x93/0x130
[  913.852683]  SyS_sendto+0xe/0x10
[  913.852688]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852690] RIP: 0033:0x7f483f67e9ff
[  913.852692] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.852696] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  913.852698] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  913.852700] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  913.852702] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  913.852704] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  913.852724] evolution-calen D    0  2487   2464 0x00000004
[  913.852728] Call Trace:
[  913.852732]  __schedule+0x3c2/0x8b0
[  913.852737]  schedule+0x36/0x80
[  913.852741]  schedule_preempt_disabled+0xe/0x10
[  913.852744]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.852750]  __mutex_lock_slowpath+0x13/0x20
[  913.852753]  ? __mutex_lock_slowpath+0x13/0x20
[  913.852757]  mutex_lock+0x2f/0x40
[  913.852761]  rtnetlink_rcv+0x19/0x30
[  913.852764]  netlink_unicast+0x18c/0x240
[  913.852768]  netlink_sendmsg+0x2c5/0x3a0
[  913.852773]  sock_sendmsg+0x38/0x50
[  913.852776]  SYSC_sendto+0x101/0x190
[  913.852780]  ? security_file_permission+0x9b/0xc0
[  913.852786]  ? vfs_read+0x93/0x130
[  913.852790]  SyS_sendto+0xe/0x10
[  913.852795]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852797] RIP: 0033:0x7f2764fc19ff
[  913.852800] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.852803] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  913.852805] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  913.852807] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  913.852809] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  913.852811] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  913.852817] evolution-calen D    0  2499   2464 0x00000004
[  913.852821] Call Trace:
[  913.852825]  __schedule+0x3c2/0x8b0
[  913.852829]  schedule+0x36/0x80
[  913.852833]  schedule_preempt_disabled+0xe/0x10
[  913.852837]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.852842]  __mutex_lock_slowpath+0x13/0x20
[  913.852845]  ? __mutex_lock_slowpath+0x13/0x20
[  913.852849]  mutex_lock+0x2f/0x40
[  913.852853]  rtnetlink_rcv+0x19/0x30
[  913.852857]  netlink_unicast+0x18c/0x240
[  913.852861]  netlink_sendmsg+0x2c5/0x3a0
[  913.852865]  sock_sendmsg+0x38/0x50
[  913.852868]  SYSC_sendto+0x101/0x190
[  913.852872]  ? security_file_permission+0x9b/0xc0
[  913.852878]  ? vfs_read+0x93/0x130
[  913.852882]  SyS_sendto+0xe/0x10
[  913.852886]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852889] RIP: 0033:0x7fb2c6e629ff
[  913.852891] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.852895] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  913.852897] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  913.852898] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  913.852901] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  913.852902] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  913.852907] evolution-addre D    0  2519   2497 0x00000004
[  913.852911] Call Trace:
[  913.852915]  __schedule+0x3c2/0x8b0
[  913.852920]  schedule+0x36/0x80
[  913.852923]  schedule_preempt_disabled+0xe/0x10
[  913.852927]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.852932]  __mutex_lock_slowpath+0x13/0x20
[  913.852936]  ? __mutex_lock_slowpath+0x13/0x20
[  913.852939]  mutex_lock+0x2f/0x40
[  913.852943]  rtnetlink_rcv+0x19/0x30
[  913.852946]  netlink_unicast+0x18c/0x240
[  913.852950]  netlink_sendmsg+0x2c5/0x3a0
[  913.852954]  sock_sendmsg+0x38/0x50
[  913.852958]  SYSC_sendto+0x101/0x190
[  913.852962]  ? security_file_permission+0x9b/0xc0
[  913.852967]  ? vfs_read+0x93/0x130
[  913.852971]  SyS_sendto+0xe/0x10
[  913.852976]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.852979] RIP: 0033:0x7f4a6d1aa9ff
[  913.852981] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.852984] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  913.852986] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  913.852988] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  913.852990] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  913.852992] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  913.853002] geoclue         D    0  2681      1 0x00000004
[  913.853006] Call Trace:
[  913.853010]  __schedule+0x3c2/0x8b0
[  913.853014]  ? consume_skb+0x34/0xa0
[  913.853018]  schedule+0x36/0x80
[  913.853021]  schedule_preempt_disabled+0xe/0x10
[  913.853025]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.853030]  __mutex_lock_slowpath+0x13/0x20
[  913.853034]  ? __mutex_lock_slowpath+0x13/0x20
[  913.853037]  mutex_lock+0x2f/0x40
[  913.853041]  rtnetlink_rcv+0x19/0x30
[  913.853045]  netlink_unicast+0x18c/0x240
[  913.853049]  netlink_sendmsg+0x2c5/0x3a0
[  913.853053]  sock_sendmsg+0x38/0x50
[  913.853056]  SYSC_sendto+0x101/0x190
[  913.853060]  ? security_file_permission+0x9b/0xc0
[  913.853066]  ? vfs_read+0x93/0x130
[  913.853070]  SyS_sendto+0xe/0x10
[  913.853074]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.853077] RIP: 0033:0x7f22fe6c13ff
[  913.853079] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.853083] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  913.853085] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  913.853087] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  913.853089] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  913.853090] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  913.853103] DNS Resolver #3 D    0 14484   1715 0x00000004
[  913.853107] Call Trace:
[  913.853111]  __schedule+0x3c2/0x8b0
[  913.853115]  schedule+0x36/0x80
[  913.853119]  schedule_preempt_disabled+0xe/0x10
[  913.853123]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.853128]  __mutex_lock_slowpath+0x13/0x20
[  913.853131]  ? __mutex_lock_slowpath+0x13/0x20
[  913.853135]  mutex_lock+0x2f/0x40
[  913.853138]  rtnetlink_rcv+0x19/0x30
[  913.853142]  netlink_unicast+0x18c/0x240
[  913.853146]  netlink_sendmsg+0x2c5/0x3a0
[  913.853150]  sock_sendmsg+0x38/0x50
[  913.853153]  SYSC_sendto+0x101/0x190
[  913.853160]  ? SYSC_getsockname+0x89/0xe0
[  913.853166]  ? fd_install+0x25/0x30
[  913.853171]  ? sock_map_fd+0x44/0x70
[  913.853175]  SyS_sendto+0xe/0x10
[  913.853179]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.853182] RIP: 0033:0x7fec02b384d3
[  913.853184] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  913.853188] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  913.853189] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  913.853191] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  913.853193] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  913.853195] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  913.853207] deja-dup-monito D    0  2923   1992 0x00000004
[  913.853210] Call Trace:
[  913.853215]  __schedule+0x3c2/0x8b0
[  913.853219]  schedule+0x36/0x80
[  913.853223]  schedule_preempt_disabled+0xe/0x10
[  913.853226]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.853232]  __mutex_lock_slowpath+0x13/0x20
[  913.853235]  ? __mutex_lock_slowpath+0x13/0x20
[  913.853239]  mutex_lock+0x2f/0x40
[  913.853243]  rtnetlink_rcv+0x19/0x30
[  913.853247]  netlink_unicast+0x18c/0x240
[  913.853250]  netlink_sendmsg+0x2c5/0x3a0
[  913.853255]  sock_sendmsg+0x38/0x50
[  913.853258]  SYSC_sendto+0x101/0x190
[  913.853262]  ? security_file_permission+0x9b/0xc0
[  913.853268]  ? vfs_read+0x93/0x130
[  913.853272]  SyS_sendto+0xe/0x10
[  913.853276]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.853279] RIP: 0033:0x7ff26c2df9ff
[  913.853281] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.853284] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  913.853286] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  913.853288] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  913.853290] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  913.853292] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  913.853303] ip              D    0 14444  14443 0x00000004
[  913.853307] Call Trace:
[  913.853311]  __schedule+0x3c2/0x8b0
[  913.853316]  schedule+0x36/0x80
[  913.853319]  schedule_preempt_disabled+0xe/0x10
[  913.853323]  __mutex_lock.isra.2+0x2ae/0x4e0
[  913.853327]  ? current_time+0x38/0x70
[  913.853331]  __mutex_lock_slowpath+0x13/0x20
[  913.853335]  ? __mutex_lock_slowpath+0x13/0x20
[  913.853338]  mutex_lock+0x2f/0x40
[  913.853342]  rtnetlink_rcv+0x19/0x30
[  913.853346]  netlink_unicast+0x18c/0x240
[  913.853350]  netlink_sendmsg+0x2c5/0x3a0
[  913.853354]  sock_sendmsg+0x38/0x50
[  913.853357]  SYSC_sendto+0x101/0x190
[  913.853364]  ? handle_mm_fault+0xcc/0x1c0
[  913.853371]  ? __do_page_fault+0x283/0x4f0
[  913.853376]  SyS_sendto+0xe/0x10
[  913.853380]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  913.853383] RIP: 0033:0x7fb0aae9f39d
[  913.853385] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  913.853388] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  913.853390] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  913.853392] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  913.853394] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  913.853396] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  913.853404] OOM killer enabled.
[  913.853405] Restarting tasks ... done.
[  913.960078] PM: Syncing filesystems ... done.
[  914.301320] PM: Preparing system for sleep (freeze)
[  914.301650] Freezing user space processes ... 
[  934.305747] Freezing of tasks failed after 20.004 seconds (12 tasks refusing to freeze, wq_busy=0):
[  934.305780] cups-browsed    D    0   989      1 0x00000004
[  934.305786] Call Trace:
[  934.305799]  __schedule+0x3c2/0x8b0
[  934.305804]  ? consume_skb+0x34/0xa0
[  934.305808]  schedule+0x36/0x80
[  934.305812]  schedule_preempt_disabled+0xe/0x10
[  934.305816]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.305821]  __mutex_lock_slowpath+0x13/0x20
[  934.305825]  ? __mutex_lock_slowpath+0x13/0x20
[  934.305828]  mutex_lock+0x2f/0x40
[  934.305833]  rtnetlink_rcv+0x19/0x30
[  934.305837]  netlink_unicast+0x18c/0x240
[  934.305841]  netlink_sendmsg+0x2c5/0x3a0
[  934.305846]  sock_sendmsg+0x38/0x50
[  934.305849]  SYSC_sendto+0x101/0x190
[  934.305857]  ? SYSC_getsockname+0x89/0xe0
[  934.305863]  ? fd_install+0x25/0x30
[  934.305868]  ? sock_map_fd+0x44/0x70
[  934.305872]  SyS_sendto+0xe/0x10
[  934.305877]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.305881] RIP: 0033:0x7f87f22ac4d3
[  934.305884] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  934.305888] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  934.305890] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  934.305892] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  934.305894] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  934.305896] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  934.305901] NetworkManager  D    0   990      1 0x00000004
[  934.305905] Call Trace:
[  934.305909]  __schedule+0x3c2/0x8b0
[  934.305913]  schedule+0x36/0x80
[  934.305917]  schedule_preempt_disabled+0xe/0x10
[  934.305921]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.305927]  ? ___slab_alloc+0x32b/0x4c0
[  934.305931]  __mutex_lock_slowpath+0x13/0x20
[  934.305934]  ? __mutex_lock_slowpath+0x13/0x20
[  934.305937]  mutex_lock+0x2f/0x40
[  934.305941]  rtnl_lock+0x15/0x20
[  934.305947]  dev_ioctl+0x312/0x530
[  934.305951]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  934.305958]  sock_do_ioctl+0x42/0x50
[  934.305963]  ? sock_do_ioctl+0x42/0x50
[  934.305968]  sock_ioctl+0x1f6/0x2c0
[  934.305971]  ? alloc_file+0x69/0xe0
[  934.305977]  do_vfs_ioctl+0xa1/0x5d0
[  934.305982]  ? sock_alloc_file+0xa6/0x130
[  934.305987]  SyS_ioctl+0x79/0x90
[  934.305993]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.305995] RIP: 0033:0x7f9d454bbf07
[  934.305997] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  934.306001] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  934.306003] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  934.306005] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  934.306007] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  934.306008] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  934.306016] wpa_supplicant  D    0  1049      1 0x00000004
[  934.306019] Call Trace:
[  934.306023]  __schedule+0x3c2/0x8b0
[  934.306027]  schedule+0x36/0x80
[  934.306032]  schedule_timeout+0x17a/0x360
[  934.306038]  ? call_timer_fn+0x140/0x140
[  934.306043]  msleep+0x2e/0x40
[  934.306047]  ? msleep+0x2e/0x40
[  934.306057]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  934.306079]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  934.306094]  ath10k_halt+0x102/0x160 [ath10k_core]
[  934.306108]  ath10k_stop+0x39/0x80 [ath10k_core]
[  934.306151]  drv_stop+0x33/0xf0 [mac80211]
[  934.306193]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  934.306230]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  934.306236]  ? __rtnl_unlock+0x2a/0x50
[  934.306240]  ? nla_memcpy+0x26/0x50
[  934.306275]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  934.306310]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  934.306347]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  934.306379]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  934.306383]  genl_family_rcv_msg+0x1f5/0x3d0
[  934.306388]  ? __netlink_sendskb+0x3e/0x60
[  934.306393]  genl_rcv_msg+0x4c/0x90
[  934.306397]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  934.306401]  netlink_rcv_skb+0xe7/0x120
[  934.306406]  genl_rcv+0x28/0x40
[  934.306409]  netlink_unicast+0x18c/0x240
[  934.306414]  netlink_sendmsg+0x2c5/0x3a0
[  934.306418]  sock_sendmsg+0x38/0x50
[  934.306421]  ___sys_sendmsg+0x2b6/0x2d0
[  934.306425]  ? netlink_sendmsg+0x133/0x3a0
[  934.306433]  ? kzfree+0x2d/0x40
[  934.306439]  ? dput+0xc7/0x1f0
[  934.306444]  ? mntput+0x24/0x40
[  934.306448]  __sys_sendmsg+0x54/0x90
[  934.306451]  ? __sys_sendmsg+0x54/0x90
[  934.306456]  SyS_sendmsg+0x12/0x20
[  934.306461]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306463] RIP: 0033:0x7fd5b8652450
[  934.306465] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  934.306469] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  934.306470] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  934.306472] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  934.306474] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  934.306476] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  934.306483] whoopsie        D    0  1169      1 0x00000004
[  934.306486] Call Trace:
[  934.306490]  __schedule+0x3c2/0x8b0
[  934.306496]  ? __wake_up_common+0x73/0x90
[  934.306500]  schedule+0x36/0x80
[  934.306503]  schedule_preempt_disabled+0xe/0x10
[  934.306507]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306512]  __mutex_lock_slowpath+0x13/0x20
[  934.306515]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306519]  mutex_lock+0x2f/0x40
[  934.306523]  rtnetlink_rcv+0x19/0x30
[  934.306526]  netlink_unicast+0x18c/0x240
[  934.306530]  netlink_sendmsg+0x2c5/0x3a0
[  934.306534]  sock_sendmsg+0x38/0x50
[  934.306537]  SYSC_sendto+0x101/0x190
[  934.306542]  ? security_file_permission+0x9b/0xc0
[  934.306548]  ? vfs_read+0x93/0x130
[  934.306552]  SyS_sendto+0xe/0x10
[  934.306557]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306559] RIP: 0033:0x7f804d02a3ff
[  934.306561] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.306564] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  934.306566] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  934.306567] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  934.306569] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  934.306571] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  934.306604] gnome-software  D    0  2123   1992 0x00000004
[  934.306607] Call Trace:
[  934.306612]  __schedule+0x3c2/0x8b0
[  934.306615]  schedule+0x36/0x80
[  934.306619]  schedule_preempt_disabled+0xe/0x10
[  934.306622]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306627]  __mutex_lock_slowpath+0x13/0x20
[  934.306631]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306634]  mutex_lock+0x2f/0x40
[  934.306637]  rtnetlink_rcv+0x19/0x30
[  934.306641]  netlink_unicast+0x18c/0x240
[  934.306645]  netlink_sendmsg+0x2c5/0x3a0
[  934.306649]  sock_sendmsg+0x38/0x50
[  934.306651]  SYSC_sendto+0x101/0x190
[  934.306655]  ? security_file_permission+0x9b/0xc0
[  934.306661]  ? vfs_read+0x93/0x130
[  934.306665]  SyS_sendto+0xe/0x10
[  934.306670]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306672] RIP: 0033:0x7f483f67e9ff
[  934.306673] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.306676] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  934.306678] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  934.306680] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  934.306681] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  934.306683] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  934.306702] evolution-calen D    0  2487   2464 0x00000004
[  934.306705] Call Trace:
[  934.306709]  __schedule+0x3c2/0x8b0
[  934.306713]  schedule+0x36/0x80
[  934.306716]  schedule_preempt_disabled+0xe/0x10
[  934.306719]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306724]  __mutex_lock_slowpath+0x13/0x20
[  934.306728]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306731]  mutex_lock+0x2f/0x40
[  934.306734]  rtnetlink_rcv+0x19/0x30
[  934.306738]  netlink_unicast+0x18c/0x240
[  934.306742]  netlink_sendmsg+0x2c5/0x3a0
[  934.306746]  sock_sendmsg+0x38/0x50
[  934.306748]  SYSC_sendto+0x101/0x190
[  934.306752]  ? security_file_permission+0x9b/0xc0
[  934.306758]  ? vfs_read+0x93/0x130
[  934.306762]  SyS_sendto+0xe/0x10
[  934.306766]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306768] RIP: 0033:0x7f2764fc19ff
[  934.306769] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.306773] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  934.306774] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  934.306776] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  934.306778] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  934.306779] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  934.306785] evolution-calen D    0  2499   2464 0x00000004
[  934.306788] Call Trace:
[  934.306792]  __schedule+0x3c2/0x8b0
[  934.306796]  schedule+0x36/0x80
[  934.306799]  schedule_preempt_disabled+0xe/0x10
[  934.306802]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306807]  __mutex_lock_slowpath+0x13/0x20
[  934.306811]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306814]  mutex_lock+0x2f/0x40
[  934.306817]  rtnetlink_rcv+0x19/0x30
[  934.306821]  netlink_unicast+0x18c/0x240
[  934.306825]  netlink_sendmsg+0x2c5/0x3a0
[  934.306828]  sock_sendmsg+0x38/0x50
[  934.306831]  SYSC_sendto+0x101/0x190
[  934.306835]  ? security_file_permission+0x9b/0xc0
[  934.306840]  ? vfs_read+0x93/0x130
[  934.306844]  SyS_sendto+0xe/0x10
[  934.306849]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306851] RIP: 0033:0x7fb2c6e629ff
[  934.306852] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.306855] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  934.306857] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  934.306859] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  934.306860] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  934.306862] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  934.306866] evolution-addre D    0  2519   2497 0x00000004
[  934.306870] Call Trace:
[  934.306873]  __schedule+0x3c2/0x8b0
[  934.306877]  schedule+0x36/0x80
[  934.306880]  schedule_preempt_disabled+0xe/0x10
[  934.306884]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306889]  __mutex_lock_slowpath+0x13/0x20
[  934.306892]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306895]  mutex_lock+0x2f/0x40
[  934.306899]  rtnetlink_rcv+0x19/0x30
[  934.306902]  netlink_unicast+0x18c/0x240
[  934.306906]  netlink_sendmsg+0x2c5/0x3a0
[  934.306910]  sock_sendmsg+0x38/0x50
[  934.306912]  SYSC_sendto+0x101/0x190
[  934.306916]  ? security_file_permission+0x9b/0xc0
[  934.306922]  ? vfs_read+0x93/0x130
[  934.306925]  SyS_sendto+0xe/0x10
[  934.306930]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.306931] RIP: 0033:0x7f4a6d1aa9ff
[  934.306933] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.306936] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  934.306938] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  934.306939] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  934.306941] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  934.306943] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  934.306952] geoclue         D    0  2681      1 0x00000004
[  934.306955] Call Trace:
[  934.306959]  __schedule+0x3c2/0x8b0
[  934.306962]  ? consume_skb+0x34/0xa0
[  934.306966]  schedule+0x36/0x80
[  934.306969]  schedule_preempt_disabled+0xe/0x10
[  934.306972]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.306977]  __mutex_lock_slowpath+0x13/0x20
[  934.306981]  ? __mutex_lock_slowpath+0x13/0x20
[  934.306984]  mutex_lock+0x2f/0x40
[  934.306987]  rtnetlink_rcv+0x19/0x30
[  934.306991]  netlink_unicast+0x18c/0x240
[  934.306995]  netlink_sendmsg+0x2c5/0x3a0
[  934.306998]  sock_sendmsg+0x38/0x50
[  934.307001]  SYSC_sendto+0x101/0x190
[  934.307005]  ? security_file_permission+0x9b/0xc0
[  934.307010]  ? vfs_read+0x93/0x130
[  934.307014]  SyS_sendto+0xe/0x10
[  934.307018]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.307020] RIP: 0033:0x7f22fe6c13ff
[  934.307022] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.307025] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  934.307027] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  934.307028] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  934.307030] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  934.307032] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  934.307044] DNS Resolver #3 D    0 14484   1715 0x00000004
[  934.307047] Call Trace:
[  934.307051]  __schedule+0x3c2/0x8b0
[  934.307055]  schedule+0x36/0x80
[  934.307058]  schedule_preempt_disabled+0xe/0x10
[  934.307062]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.307067]  __mutex_lock_slowpath+0x13/0x20
[  934.307070]  ? __mutex_lock_slowpath+0x13/0x20
[  934.307073]  mutex_lock+0x2f/0x40
[  934.307077]  rtnetlink_rcv+0x19/0x30
[  934.307080]  netlink_unicast+0x18c/0x240
[  934.307084]  netlink_sendmsg+0x2c5/0x3a0
[  934.307088]  sock_sendmsg+0x38/0x50
[  934.307090]  SYSC_sendto+0x101/0x190
[  934.307098]  ? SYSC_getsockname+0x89/0xe0
[  934.307103]  ? fd_install+0x25/0x30
[  934.307108]  ? sock_map_fd+0x44/0x70
[  934.307112]  SyS_sendto+0xe/0x10
[  934.307116]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.307118] RIP: 0033:0x7fec02b384d3
[  934.307119] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  934.307122] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  934.307124] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  934.307126] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  934.307128] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  934.307129] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  934.307140] deja-dup-monito D    0  2923   1992 0x00000004
[  934.307143] Call Trace:
[  934.307147]  __schedule+0x3c2/0x8b0
[  934.307151]  schedule+0x36/0x80
[  934.307154]  schedule_preempt_disabled+0xe/0x10
[  934.307157]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.307162]  __mutex_lock_slowpath+0x13/0x20
[  934.307166]  ? __mutex_lock_slowpath+0x13/0x20
[  934.307169]  mutex_lock+0x2f/0x40
[  934.307172]  rtnetlink_rcv+0x19/0x30
[  934.307176]  netlink_unicast+0x18c/0x240
[  934.307179]  netlink_sendmsg+0x2c5/0x3a0
[  934.307183]  sock_sendmsg+0x38/0x50
[  934.307186]  SYSC_sendto+0x101/0x190
[  934.307190]  ? security_file_permission+0x9b/0xc0
[  934.307195]  ? vfs_read+0x93/0x130
[  934.307199]  SyS_sendto+0xe/0x10
[  934.307203]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.307205] RIP: 0033:0x7ff26c2df9ff
[  934.307207] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.307210] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  934.307211] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  934.307213] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  934.307215] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  934.307217] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  934.307226] ip              D    0 14444  14443 0x00000004
[  934.307230] Call Trace:
[  934.307233]  __schedule+0x3c2/0x8b0
[  934.307238]  schedule+0x36/0x80
[  934.307241]  schedule_preempt_disabled+0xe/0x10
[  934.307244]  __mutex_lock.isra.2+0x2ae/0x4e0
[  934.307248]  ? current_time+0x38/0x70
[  934.307252]  __mutex_lock_slowpath+0x13/0x20
[  934.307256]  ? __mutex_lock_slowpath+0x13/0x20
[  934.307259]  mutex_lock+0x2f/0x40
[  934.307262]  rtnetlink_rcv+0x19/0x30
[  934.307266]  netlink_unicast+0x18c/0x240
[  934.307269]  netlink_sendmsg+0x2c5/0x3a0
[  934.307273]  sock_sendmsg+0x38/0x50
[  934.307276]  SYSC_sendto+0x101/0x190
[  934.307283]  ? handle_mm_fault+0xcc/0x1c0
[  934.307290]  ? __do_page_fault+0x283/0x4f0
[  934.307294]  SyS_sendto+0xe/0x10
[  934.307298]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  934.307300] RIP: 0033:0x7fb0aae9f39d
[  934.307301] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  934.307304] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  934.307306] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  934.307308] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  934.307310] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  934.307311] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  934.307319] OOM killer enabled.
[  934.307320] Restarting tasks ... done.
[  944.436525] PM: Syncing filesystems ... done.
[  944.572646] PM: Preparing system for sleep (mem)
[  944.573160] Freezing user space processes ... 
[  964.580304] Freezing of tasks failed after 20.007 seconds (12 tasks refusing to freeze, wq_busy=0):
[  964.580338] cups-browsed    D    0   989      1 0x00000004
[  964.580343] Call Trace:
[  964.580356]  __schedule+0x3c2/0x8b0
[  964.580361]  ? consume_skb+0x34/0xa0
[  964.580366]  schedule+0x36/0x80
[  964.580369]  schedule_preempt_disabled+0xe/0x10
[  964.580374]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.580379]  __mutex_lock_slowpath+0x13/0x20
[  964.580383]  ? __mutex_lock_slowpath+0x13/0x20
[  964.580386]  mutex_lock+0x2f/0x40
[  964.580391]  rtnetlink_rcv+0x19/0x30
[  964.580395]  netlink_unicast+0x18c/0x240
[  964.580400]  netlink_sendmsg+0x2c5/0x3a0
[  964.580404]  sock_sendmsg+0x38/0x50
[  964.580407]  SYSC_sendto+0x101/0x190
[  964.580415]  ? SYSC_getsockname+0x89/0xe0
[  964.580421]  ? fd_install+0x25/0x30
[  964.580426]  ? sock_map_fd+0x44/0x70
[  964.580430]  SyS_sendto+0xe/0x10
[  964.580435]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.580439] RIP: 0033:0x7f87f22ac4d3
[  964.580442] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  964.580445] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  964.580447] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  964.580449] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  964.580451] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  964.580453] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  964.580459] NetworkManager  D    0   990      1 0x00000004
[  964.580462] Call Trace:
[  964.580467]  __schedule+0x3c2/0x8b0
[  964.580471]  schedule+0x36/0x80
[  964.580474]  schedule_preempt_disabled+0xe/0x10
[  964.580478]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.580484]  ? ___slab_alloc+0x32b/0x4c0
[  964.580489]  __mutex_lock_slowpath+0x13/0x20
[  964.580492]  ? __mutex_lock_slowpath+0x13/0x20
[  964.580495]  mutex_lock+0x2f/0x40
[  964.580498]  rtnl_lock+0x15/0x20
[  964.580504]  dev_ioctl+0x312/0x530
[  964.580509]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  964.580515]  sock_do_ioctl+0x42/0x50
[  964.580520]  ? sock_do_ioctl+0x42/0x50
[  964.580525]  sock_ioctl+0x1f6/0x2c0
[  964.580529]  ? alloc_file+0x69/0xe0
[  964.580534]  do_vfs_ioctl+0xa1/0x5d0
[  964.580539]  ? sock_alloc_file+0xa6/0x130
[  964.580545]  SyS_ioctl+0x79/0x90
[  964.580550]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.580552] RIP: 0033:0x7f9d454bbf07
[  964.580554] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  964.580558] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  964.580560] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  964.580562] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  964.580563] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  964.580565] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  964.580573] wpa_supplicant  D    0  1049      1 0x00000004
[  964.580576] Call Trace:
[  964.580580]  __schedule+0x3c2/0x8b0
[  964.580584]  schedule+0x36/0x80
[  964.580589]  schedule_timeout+0x17a/0x360
[  964.580595]  ? call_timer_fn+0x140/0x140
[  964.580600]  msleep+0x2e/0x40
[  964.580604]  ? msleep+0x2e/0x40
[  964.580614]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  964.580636]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  964.580652]  ath10k_halt+0x102/0x160 [ath10k_core]
[  964.580668]  ath10k_stop+0x39/0x80 [ath10k_core]
[  964.580712]  drv_stop+0x33/0xf0 [mac80211]
[  964.580757]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  964.580797]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  964.580802]  ? __rtnl_unlock+0x2a/0x50
[  964.580808]  ? nla_memcpy+0x26/0x50
[  964.580848]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  964.580888]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  964.580925]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  964.580958]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  964.580964]  genl_family_rcv_msg+0x1f5/0x3d0
[  964.580968]  ? __netlink_sendskb+0x3e/0x60
[  964.580974]  genl_rcv_msg+0x4c/0x90
[  964.580978]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  964.580982]  netlink_rcv_skb+0xe7/0x120
[  964.580986]  genl_rcv+0x28/0x40
[  964.580990]  netlink_unicast+0x18c/0x240
[  964.580994]  netlink_sendmsg+0x2c5/0x3a0
[  964.580999]  sock_sendmsg+0x38/0x50
[  964.581002]  ___sys_sendmsg+0x2b6/0x2d0
[  964.581007]  ? netlink_sendmsg+0x133/0x3a0
[  964.581014]  ? kzfree+0x2d/0x40
[  964.581020]  ? dput+0xc7/0x1f0
[  964.581026]  ? mntput+0x24/0x40
[  964.581030]  __sys_sendmsg+0x54/0x90
[  964.581033]  ? __sys_sendmsg+0x54/0x90
[  964.581038]  SyS_sendmsg+0x12/0x20
[  964.581044]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581046] RIP: 0033:0x7fd5b8652450
[  964.581049] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  964.581052] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  964.581054] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  964.581056] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  964.581058] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  964.581060] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  964.581068] whoopsie        D    0  1169      1 0x00000004
[  964.581072] Call Trace:
[  964.581076]  __schedule+0x3c2/0x8b0
[  964.581082]  ? __wake_up_common+0x73/0x90
[  964.581086]  schedule+0x36/0x80
[  964.581090]  schedule_preempt_disabled+0xe/0x10
[  964.581093]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581099]  __mutex_lock_slowpath+0x13/0x20
[  964.581103]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581106]  mutex_lock+0x2f/0x40
[  964.581110]  rtnetlink_rcv+0x19/0x30
[  964.581114]  netlink_unicast+0x18c/0x240
[  964.581118]  netlink_sendmsg+0x2c5/0x3a0
[  964.581122]  sock_sendmsg+0x38/0x50
[  964.581125]  SYSC_sendto+0x101/0x190
[  964.581131]  ? security_file_permission+0x9b/0xc0
[  964.581137]  ? vfs_read+0x93/0x130
[  964.581141]  SyS_sendto+0xe/0x10
[  964.581146]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581149] RIP: 0033:0x7f804d02a3ff
[  964.581151] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581154] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  964.581156] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  964.581158] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  964.581160] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  964.581162] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  964.581196] gnome-software  D    0  2123   1992 0x00000004
[  964.581200] Call Trace:
[  964.581205]  __schedule+0x3c2/0x8b0
[  964.581210]  schedule+0x36/0x80
[  964.581213]  schedule_preempt_disabled+0xe/0x10
[  964.581217]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581222]  __mutex_lock_slowpath+0x13/0x20
[  964.581226]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581229]  mutex_lock+0x2f/0x40
[  964.581233]  rtnetlink_rcv+0x19/0x30
[  964.581237]  netlink_unicast+0x18c/0x240
[  964.581241]  netlink_sendmsg+0x2c5/0x3a0
[  964.581245]  sock_sendmsg+0x38/0x50
[  964.581249]  SYSC_sendto+0x101/0x190
[  964.581253]  ? security_file_permission+0x9b/0xc0
[  964.581259]  ? vfs_read+0x93/0x130
[  964.581263]  SyS_sendto+0xe/0x10
[  964.581268]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581270] RIP: 0033:0x7f483f67e9ff
[  964.581272] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581276] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  964.581278] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  964.581280] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  964.581282] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  964.581284] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  964.581303] evolution-calen D    0  2487   2464 0x00000004
[  964.581307] Call Trace:
[  964.581312]  __schedule+0x3c2/0x8b0
[  964.581316]  schedule+0x36/0x80
[  964.581320]  schedule_preempt_disabled+0xe/0x10
[  964.581324]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581329]  __mutex_lock_slowpath+0x13/0x20
[  964.581333]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581336]  mutex_lock+0x2f/0x40
[  964.581340]  rtnetlink_rcv+0x19/0x30
[  964.581343]  netlink_unicast+0x18c/0x240
[  964.581348]  netlink_sendmsg+0x2c5/0x3a0
[  964.581352]  sock_sendmsg+0x38/0x50
[  964.581355]  SYSC_sendto+0x101/0x190
[  964.581359]  ? security_file_permission+0x9b/0xc0
[  964.581365]  ? vfs_read+0x93/0x130
[  964.581369]  SyS_sendto+0xe/0x10
[  964.581374]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581376] RIP: 0033:0x7f2764fc19ff
[  964.581378] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581382] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  964.581384] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  964.581386] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  964.581388] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  964.581390] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  964.581396] evolution-calen D    0  2499   2464 0x00000004
[  964.581400] Call Trace:
[  964.581404]  __schedule+0x3c2/0x8b0
[  964.581408]  schedule+0x36/0x80
[  964.581412]  schedule_preempt_disabled+0xe/0x10
[  964.581415]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581421]  __mutex_lock_slowpath+0x13/0x20
[  964.581424]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581428]  mutex_lock+0x2f/0x40
[  964.581431]  rtnetlink_rcv+0x19/0x30
[  964.581435]  netlink_unicast+0x18c/0x240
[  964.581439]  netlink_sendmsg+0x2c5/0x3a0
[  964.581443]  sock_sendmsg+0x38/0x50
[  964.581447]  SYSC_sendto+0x101/0x190
[  964.581451]  ? security_file_permission+0x9b/0xc0
[  964.581456]  ? vfs_read+0x93/0x130
[  964.581460]  SyS_sendto+0xe/0x10
[  964.581465]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581467] RIP: 0033:0x7fb2c6e629ff
[  964.581469] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581473] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  964.581475] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  964.581477] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  964.581479] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  964.581481] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  964.581486] evolution-addre D    0  2519   2497 0x00000004
[  964.581490] Call Trace:
[  964.581494]  __schedule+0x3c2/0x8b0
[  964.581499]  schedule+0x36/0x80
[  964.581502]  schedule_preempt_disabled+0xe/0x10
[  964.581506]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581511]  __mutex_lock_slowpath+0x13/0x20
[  964.581514]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581518]  mutex_lock+0x2f/0x40
[  964.581522]  rtnetlink_rcv+0x19/0x30
[  964.581526]  netlink_unicast+0x18c/0x240
[  964.581530]  netlink_sendmsg+0x2c5/0x3a0
[  964.581534]  sock_sendmsg+0x38/0x50
[  964.581537]  SYSC_sendto+0x101/0x190
[  964.581541]  ? security_file_permission+0x9b/0xc0
[  964.581547]  ? vfs_read+0x93/0x130
[  964.581551]  SyS_sendto+0xe/0x10
[  964.581555]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581558] RIP: 0033:0x7f4a6d1aa9ff
[  964.581560] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581563] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  964.581565] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  964.581567] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  964.581569] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  964.581571] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  964.581581] geoclue         D    0  2681      1 0x00000004
[  964.581585] Call Trace:
[  964.581589]  __schedule+0x3c2/0x8b0
[  964.581593]  ? consume_skb+0x34/0xa0
[  964.581597]  schedule+0x36/0x80
[  964.581600]  schedule_preempt_disabled+0xe/0x10
[  964.581604]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581609]  __mutex_lock_slowpath+0x13/0x20
[  964.581613]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581616]  mutex_lock+0x2f/0x40
[  964.581620]  rtnetlink_rcv+0x19/0x30
[  964.581624]  netlink_unicast+0x18c/0x240
[  964.581628]  netlink_sendmsg+0x2c5/0x3a0
[  964.581632]  sock_sendmsg+0x38/0x50
[  964.581635]  SYSC_sendto+0x101/0x190
[  964.581640]  ? security_file_permission+0x9b/0xc0
[  964.581645]  ? vfs_read+0x93/0x130
[  964.581649]  SyS_sendto+0xe/0x10
[  964.581654]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581657] RIP: 0033:0x7f22fe6c13ff
[  964.581659] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581662] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  964.581664] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  964.581666] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  964.581668] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  964.581670] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  964.581683] DNS Resolver #3 D    0 14484   1715 0x00000004
[  964.581686] Call Trace:
[  964.581691]  __schedule+0x3c2/0x8b0
[  964.581695]  schedule+0x36/0x80
[  964.581699]  schedule_preempt_disabled+0xe/0x10
[  964.581703]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581708]  __mutex_lock_slowpath+0x13/0x20
[  964.581712]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581715]  mutex_lock+0x2f/0x40
[  964.581719]  rtnetlink_rcv+0x19/0x30
[  964.581723]  netlink_unicast+0x18c/0x240
[  964.581727]  netlink_sendmsg+0x2c5/0x3a0
[  964.581731]  sock_sendmsg+0x38/0x50
[  964.581734]  SYSC_sendto+0x101/0x190
[  964.581741]  ? SYSC_getsockname+0x89/0xe0
[  964.581746]  ? fd_install+0x25/0x30
[  964.581751]  ? sock_map_fd+0x44/0x70
[  964.581755]  SyS_sendto+0xe/0x10
[  964.581760]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581762] RIP: 0033:0x7fec02b384d3
[  964.581764] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  964.581768] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  964.581770] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  964.581772] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  964.581774] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  964.581776] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  964.581787] deja-dup-monito D    0  2923   1992 0x00000004
[  964.581791] Call Trace:
[  964.581795]  __schedule+0x3c2/0x8b0
[  964.581800]  schedule+0x36/0x80
[  964.581803]  schedule_preempt_disabled+0xe/0x10
[  964.581807]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581812]  __mutex_lock_slowpath+0x13/0x20
[  964.581816]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581819]  mutex_lock+0x2f/0x40
[  964.581823]  rtnetlink_rcv+0x19/0x30
[  964.581827]  netlink_unicast+0x18c/0x240
[  964.581831]  netlink_sendmsg+0x2c5/0x3a0
[  964.581835]  sock_sendmsg+0x38/0x50
[  964.581838]  SYSC_sendto+0x101/0x190
[  964.581842]  ? security_file_permission+0x9b/0xc0
[  964.581848]  ? vfs_read+0x93/0x130
[  964.581852]  SyS_sendto+0xe/0x10
[  964.581857]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581859] RIP: 0033:0x7ff26c2df9ff
[  964.581861] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581865] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  964.581867] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  964.581869] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  964.581871] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  964.581872] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  964.581882] ip              D    0 14444  14443 0x00000004
[  964.581886] Call Trace:
[  964.581890]  __schedule+0x3c2/0x8b0
[  964.581895]  schedule+0x36/0x80
[  964.581898]  schedule_preempt_disabled+0xe/0x10
[  964.581902]  __mutex_lock.isra.2+0x2ae/0x4e0
[  964.581906]  ? current_time+0x38/0x70
[  964.581911]  __mutex_lock_slowpath+0x13/0x20
[  964.581914]  ? __mutex_lock_slowpath+0x13/0x20
[  964.581917]  mutex_lock+0x2f/0x40
[  964.581921]  rtnetlink_rcv+0x19/0x30
[  964.581925]  netlink_unicast+0x18c/0x240
[  964.581929]  netlink_sendmsg+0x2c5/0x3a0
[  964.581933]  sock_sendmsg+0x38/0x50
[  964.581936]  SYSC_sendto+0x101/0x190
[  964.581942]  ? handle_mm_fault+0xcc/0x1c0
[  964.581950]  ? __do_page_fault+0x283/0x4f0
[  964.581954]  SyS_sendto+0xe/0x10
[  964.581959]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  964.581961] RIP: 0033:0x7fb0aae9f39d
[  964.581963] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  964.581967] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  964.581969] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  964.581971] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  964.581973] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  964.581975] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  964.581982] OOM killer enabled.
[  964.581983] Restarting tasks ... done.
[  964.692859] PM: Syncing filesystems ... done.
[  964.951747] PM: Preparing system for sleep (freeze)
[  964.951912] Freezing user space processes ... 
[  967.648130] INFO: task kworker/2:1:34 blocked for more than 120 seconds.
[  967.648139]       Not tainted 4.13.5anil-1017 #1
[  967.648142] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648146] kworker/2:1     D    0    34      2 0x00000000
[  967.648161] Workqueue: ipv6_addrconf addrconf_verify_work
[  967.648164] Call Trace:
[  967.648174]  __schedule+0x3c2/0x8b0
[  967.648180]  schedule+0x36/0x80
[  967.648184]  schedule_preempt_disabled+0xe/0x10
[  967.648188]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648196]  ? __switch_to+0x211/0x490
[  967.648201]  __mutex_lock_slowpath+0x13/0x20
[  967.648204]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648208]  mutex_lock+0x2f/0x40
[  967.648212]  rtnl_lock+0x15/0x20
[  967.648217]  addrconf_verify_work+0xe/0x20
[  967.648222]  process_one_work+0x156/0x3f0
[  967.648227]  worker_thread+0x4b/0x410
[  967.648233]  kthread+0x109/0x140
[  967.648237]  ? process_one_work+0x3f0/0x3f0
[  967.648242]  ? kthread_create_on_node+0x70/0x70
[  967.648247]  ret_from_fork+0x25/0x30
[  967.648258] INFO: task kworker/u8:4:183 blocked for more than 120 seconds.
[  967.648262]       Not tainted 4.13.5anil-1017 #1
[  967.648264] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648267] kworker/u8:4    D    0   183      2 0x00000000
[  967.648313] Workqueue: events_power_efficient reg_check_chans_work [cfg80211]
[  967.648316] Call Trace:
[  967.648321]  __schedule+0x3c2/0x8b0
[  967.648326]  ? __switch_to+0x211/0x490
[  967.648330]  schedule+0x36/0x80
[  967.648334]  schedule_preempt_disabled+0xe/0x10
[  967.648338]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648343]  __mutex_lock_slowpath+0x13/0x20
[  967.648346]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648350]  mutex_lock+0x2f/0x40
[  967.648354]  rtnl_lock+0x15/0x20
[  967.648381]  reg_check_chans_work+0x2f/0x350 [cfg80211]
[  967.648385]  ? __schedule+0x3ca/0x8b0
[  967.648389]  process_one_work+0x156/0x3f0
[  967.648394]  worker_thread+0x4b/0x410
[  967.648400]  kthread+0x109/0x140
[  967.648403]  ? process_one_work+0x3f0/0x3f0
[  967.648408]  ? kthread_create_on_node+0x70/0x70
[  967.648413]  ret_from_fork+0x25/0x30
[  967.648418] INFO: task kworker/3:2:185 blocked for more than 120 seconds.
[  967.648421]       Not tainted 4.13.5anil-1017 #1
[  967.648423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648426] kworker/3:2     D    0   185      2 0x00000000
[  967.648472] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[  967.648474] Call Trace:
[  967.648479]  __schedule+0x3c2/0x8b0
[  967.648483]  schedule+0x36/0x80
[  967.648486]  schedule_preempt_disabled+0xe/0x10
[  967.648490]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648495]  ? flush_workqueue+0x1d5/0x400
[  967.648500]  __mutex_lock_slowpath+0x13/0x20
[  967.648503]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648506]  mutex_lock+0x2f/0x40
[  967.648510]  rtnl_lock+0x15/0x20
[  967.648544]  ieee80211_restart_work+0x55/0xd0 [mac80211]
[  967.648549]  process_one_work+0x156/0x3f0
[  967.648554]  worker_thread+0x4b/0x410
[  967.648560]  kthread+0x109/0x140
[  967.648564]  ? process_one_work+0x3f0/0x3f0
[  967.648569]  ? kthread_create_on_node+0x70/0x70
[  967.648575]  ret_from_fork+0x25/0x30
[  967.648590] INFO: task cups-browsed:989 blocked for more than 120 seconds.
[  967.648594]       Not tainted 4.13.5anil-1017 #1
[  967.648596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648600] cups-browsed    D    0   989      1 0x00000004
[  967.648604] Call Trace:
[  967.648608]  __schedule+0x3c2/0x8b0
[  967.648613]  ? consume_skb+0x34/0xa0
[  967.648617]  schedule+0x36/0x80
[  967.648620]  schedule_preempt_disabled+0xe/0x10
[  967.648624]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648630]  __mutex_lock_slowpath+0x13/0x20
[  967.648633]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648637]  mutex_lock+0x2f/0x40
[  967.648641]  rtnetlink_rcv+0x19/0x30
[  967.648646]  netlink_unicast+0x18c/0x240
[  967.648650]  netlink_sendmsg+0x2c5/0x3a0
[  967.648655]  sock_sendmsg+0x38/0x50
[  967.648658]  SYSC_sendto+0x101/0x190
[  967.648666]  ? SYSC_getsockname+0x89/0xe0
[  967.648672]  ? fd_install+0x25/0x30
[  967.648677]  ? sock_map_fd+0x44/0x70
[  967.648681]  SyS_sendto+0xe/0x10
[  967.648686]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.648690] RIP: 0033:0x7f87f22ac4d3
[  967.648692] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  967.648696] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  967.648698] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  967.648700] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  967.648703] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  967.648704] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  967.648710] INFO: task NetworkManager:990 blocked for more than 120 seconds.
[  967.648714]       Not tainted 4.13.5anil-1017 #1
[  967.648717] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648720] NetworkManager  D    0   990      1 0x00000004
[  967.648724] Call Trace:
[  967.648728]  __schedule+0x3c2/0x8b0
[  967.648733]  schedule+0x36/0x80
[  967.648737]  schedule_preempt_disabled+0xe/0x10
[  967.648740]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648747]  ? ___slab_alloc+0x32b/0x4c0
[  967.648751]  __mutex_lock_slowpath+0x13/0x20
[  967.648755]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648758]  mutex_lock+0x2f/0x40
[  967.648762]  rtnl_lock+0x15/0x20
[  967.648768]  dev_ioctl+0x312/0x530
[  967.648772]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  967.648779]  sock_do_ioctl+0x42/0x50
[  967.648784]  ? sock_do_ioctl+0x42/0x50
[  967.648789]  sock_ioctl+0x1f6/0x2c0
[  967.648793]  ? alloc_file+0x69/0xe0
[  967.648799]  do_vfs_ioctl+0xa1/0x5d0
[  967.648805]  ? sock_alloc_file+0xa6/0x130
[  967.648810]  SyS_ioctl+0x79/0x90
[  967.648815]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.648818] RIP: 0033:0x7f9d454bbf07
[  967.648820] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  967.648825] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  967.648827] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  967.648829] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  967.648831] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  967.648833] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  967.648844] INFO: task whoopsie:1169 blocked for more than 120 seconds.
[  967.648848]       Not tainted 4.13.5anil-1017 #1
[  967.648851] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648854] whoopsie        D    0  1169      1 0x00000004
[  967.648858] Call Trace:
[  967.648863]  __schedule+0x3c2/0x8b0
[  967.648868]  ? __wake_up_common+0x73/0x90
[  967.648872]  schedule+0x36/0x80
[  967.648876]  schedule_preempt_disabled+0xe/0x10
[  967.648880]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.648885]  __mutex_lock_slowpath+0x13/0x20
[  967.648889]  ? __mutex_lock_slowpath+0x13/0x20
[  967.648892]  mutex_lock+0x2f/0x40
[  967.648896]  rtnetlink_rcv+0x19/0x30
[  967.648900]  netlink_unicast+0x18c/0x240
[  967.648904]  netlink_sendmsg+0x2c5/0x3a0
[  967.648908]  sock_sendmsg+0x38/0x50
[  967.648911]  SYSC_sendto+0x101/0x190
[  967.648917]  ? security_file_permission+0x9b/0xc0
[  967.648923]  ? vfs_read+0x93/0x130
[  967.648927]  SyS_sendto+0xe/0x10
[  967.648932]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.648935] RIP: 0033:0x7f804d02a3ff
[  967.648937] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  967.648941] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  967.648943] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  967.648944] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  967.648947] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  967.648948] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  967.648977] INFO: task gnome-software:2123 blocked for more than 120 seconds.
[  967.648981]       Not tainted 4.13.5anil-1017 #1
[  967.648983] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.648986] gnome-software  D    0  2123   1992 0x00000004
[  967.648990] Call Trace:
[  967.648995]  __schedule+0x3c2/0x8b0
[  967.648999]  schedule+0x36/0x80
[  967.649003]  schedule_preempt_disabled+0xe/0x10
[  967.649007]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.649012]  __mutex_lock_slowpath+0x13/0x20
[  967.649015]  ? __mutex_lock_slowpath+0x13/0x20
[  967.649018]  mutex_lock+0x2f/0x40
[  967.649022]  rtnetlink_rcv+0x19/0x30
[  967.649026]  netlink_unicast+0x18c/0x240
[  967.649030]  netlink_sendmsg+0x2c5/0x3a0
[  967.649034]  sock_sendmsg+0x38/0x50
[  967.649037]  SYSC_sendto+0x101/0x190
[  967.649041]  ? security_file_permission+0x9b/0xc0
[  967.649047]  ? vfs_read+0x93/0x130
[  967.649051]  SyS_sendto+0xe/0x10
[  967.649056]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.649058] RIP: 0033:0x7f483f67e9ff
[  967.649060] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  967.649064] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  967.649066] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  967.649068] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  967.649070] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  967.649072] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  967.649087] INFO: task evolution-calen:2487 blocked for more than 120 seconds.
[  967.649090]       Not tainted 4.13.5anil-1017 #1
[  967.649092] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.649095] evolution-calen D    0  2487   2464 0x00000004
[  967.649098] Call Trace:
[  967.649102]  __schedule+0x3c2/0x8b0
[  967.649106]  schedule+0x36/0x80
[  967.649110]  schedule_preempt_disabled+0xe/0x10
[  967.649113]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.649118]  __mutex_lock_slowpath+0x13/0x20
[  967.649122]  ? __mutex_lock_slowpath+0x13/0x20
[  967.649125]  mutex_lock+0x2f/0x40
[  967.649128]  rtnetlink_rcv+0x19/0x30
[  967.649132]  netlink_unicast+0x18c/0x240
[  967.649136]  netlink_sendmsg+0x2c5/0x3a0
[  967.649140]  sock_sendmsg+0x38/0x50
[  967.649143]  SYSC_sendto+0x101/0x190
[  967.649147]  ? security_file_permission+0x9b/0xc0
[  967.649153]  ? vfs_read+0x93/0x130
[  967.649156]  SyS_sendto+0xe/0x10
[  967.649161]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.649163] RIP: 0033:0x7f2764fc19ff
[  967.649165] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  967.649168] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  967.649170] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  967.649172] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  967.649173] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  967.649175] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  967.649181] INFO: task evolution-calen:2499 blocked for more than 120 seconds.
[  967.649184]       Not tainted 4.13.5anil-1017 #1
[  967.649186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.649189] evolution-calen D    0  2499   2464 0x00000004
[  967.649191] Call Trace:
[  967.649195]  __schedule+0x3c2/0x8b0
[  967.649199]  schedule+0x36/0x80
[  967.649202]  schedule_preempt_disabled+0xe/0x10
[  967.649206]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.649211]  __mutex_lock_slowpath+0x13/0x20
[  967.649214]  ? __mutex_lock_slowpath+0x13/0x20
[  967.649217]  mutex_lock+0x2f/0x40
[  967.649221]  rtnetlink_rcv+0x19/0x30
[  967.649224]  netlink_unicast+0x18c/0x240
[  967.649228]  netlink_sendmsg+0x2c5/0x3a0
[  967.649232]  sock_sendmsg+0x38/0x50
[  967.649235]  SYSC_sendto+0x101/0x190
[  967.649239]  ? security_file_permission+0x9b/0xc0
[  967.649244]  ? vfs_read+0x93/0x130
[  967.649248]  SyS_sendto+0xe/0x10
[  967.649252]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.649254] RIP: 0033:0x7fb2c6e629ff
[  967.649256] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  967.649259] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  967.649260] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  967.649262] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  967.649264] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  967.649266] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  967.649270] INFO: task evolution-addre:2519 blocked for more than 120 seconds.
[  967.649273]       Not tainted 4.13.5anil-1017 #1
[  967.649275] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  967.649277] evolution-addre D    0  2519   2497 0x00000004
[  967.649280] Call Trace:
[  967.649284]  __schedule+0x3c2/0x8b0
[  967.649288]  schedule+0x36/0x80
[  967.649292]  schedule_preempt_disabled+0xe/0x10
[  967.649295]  __mutex_lock.isra.2+0x2ae/0x4e0
[  967.649300]  __mutex_lock_slowpath+0x13/0x20
[  967.649303]  ? __mutex_lock_slowpath+0x13/0x20
[  967.649307]  mutex_lock+0x2f/0x40
[  967.649310]  rtnetlink_rcv+0x19/0x30
[  967.649313]  netlink_unicast+0x18c/0x240
[  967.649317]  netlink_sendmsg+0x2c5/0x3a0
[  967.649321]  sock_sendmsg+0x38/0x50
[  967.649324]  SYSC_sendto+0x101/0x190
[  967.649328]  ? security_file_permission+0x9b/0xc0
[  967.649333]  ? vfs_read+0x93/0x130
[  967.649337]  SyS_sendto+0xe/0x10
[  967.649341]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  967.649343] RIP: 0033:0x7f4a6d1aa9ff
[  967.649345] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  967.649348] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  967.649349] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  967.649351] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  967.649353] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  967.649355] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  984.956158] Freezing of tasks failed after 20.004 seconds (12 tasks refusing to freeze, wq_busy=0):
[  984.956192] cups-browsed    D    0   989      1 0x00000004
[  984.956198] Call Trace:
[  984.956210]  __schedule+0x3c2/0x8b0
[  984.956215]  ? consume_skb+0x34/0xa0
[  984.956219]  schedule+0x36/0x80
[  984.956223]  schedule_preempt_disabled+0xe/0x10
[  984.956227]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.956232]  __mutex_lock_slowpath+0x13/0x20
[  984.956236]  ? __mutex_lock_slowpath+0x13/0x20
[  984.956239]  mutex_lock+0x2f/0x40
[  984.956244]  rtnetlink_rcv+0x19/0x30
[  984.956248]  netlink_unicast+0x18c/0x240
[  984.956252]  netlink_sendmsg+0x2c5/0x3a0
[  984.956257]  sock_sendmsg+0x38/0x50
[  984.956260]  SYSC_sendto+0x101/0x190
[  984.956268]  ? SYSC_getsockname+0x89/0xe0
[  984.956274]  ? fd_install+0x25/0x30
[  984.956279]  ? sock_map_fd+0x44/0x70
[  984.956283]  SyS_sendto+0xe/0x10
[  984.956288]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.956292] RIP: 0033:0x7f87f22ac4d3
[  984.956295] RSP: 002b:00007ffdac4e3bb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  984.956298] RAX: ffffffffffffffda RBX: 00007ffdac4e4d10 RCX: 00007f87f22ac4d3
[  984.956300] RDX: 0000000000000014 RSI: 00007ffdac4e4c10 RDI: 000000000000000c
[  984.956302] RBP: 00007ffdac4e4d60 R08: 00007ffdac4e4bf0 R09: 000000000000000c
[  984.956304] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000c6dd68
[  984.956306] R13: 0000000000000003 R14: 0000000000c6dc10 R15: 0000000000000000
[  984.956312] NetworkManager  D    0   990      1 0x00000004
[  984.956316] Call Trace:
[  984.956320]  __schedule+0x3c2/0x8b0
[  984.956324]  schedule+0x36/0x80
[  984.956328]  schedule_preempt_disabled+0xe/0x10
[  984.956332]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.956338]  ? ___slab_alloc+0x32b/0x4c0
[  984.956342]  __mutex_lock_slowpath+0x13/0x20
[  984.956345]  ? __mutex_lock_slowpath+0x13/0x20
[  984.956349]  mutex_lock+0x2f/0x40
[  984.956352]  rtnl_lock+0x15/0x20
[  984.956358]  dev_ioctl+0x312/0x530
[  984.956363]  ? kmem_cache_alloc_trace+0xdb/0x1c0
[  984.956369]  sock_do_ioctl+0x42/0x50
[  984.956374]  ? sock_do_ioctl+0x42/0x50
[  984.956379]  sock_ioctl+0x1f6/0x2c0
[  984.956382]  ? alloc_file+0x69/0xe0
[  984.956388]  do_vfs_ioctl+0xa1/0x5d0
[  984.956393]  ? sock_alloc_file+0xa6/0x130
[  984.956398]  SyS_ioctl+0x79/0x90
[  984.956403]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.956406] RIP: 0033:0x7f9d454bbf07
[  984.956408] RSP: 002b:00007ffda4b8bf08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  984.956411] RAX: ffffffffffffffda RBX: 00000000024eab00 RCX: 00007f9d454bbf07
[  984.956413] RDX: 00007ffda4b8bf10 RSI: 0000000000008946 RDI: 0000000000000013
[  984.956415] RBP: 00007ffda4b8c380 R08: 0000000000000001 R09: 0000000000000000
[  984.956417] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
[  984.956419] R13: 00000000024c9de0 R14: 00007ffda4b8c390 R15: 00000000024e3cd0
[  984.956427] wpa_supplicant  D    0  1049      1 0x00000004
[  984.956430] Call Trace:
[  984.956434]  __schedule+0x3c2/0x8b0
[  984.956438]  schedule+0x36/0x80
[  984.956442]  schedule_timeout+0x17a/0x360
[  984.956448]  ? call_timer_fn+0x140/0x140
[  984.956454]  msleep+0x2e/0x40
[  984.956458]  ? msleep+0x2e/0x40
[  984.956468]  ath10k_pci_hif_stop+0x60/0xc0 [ath10k_pci]
[  984.956489]  ath10k_core_stop+0x45/0x70 [ath10k_core]
[  984.956504]  ath10k_halt+0x102/0x160 [ath10k_core]
[  984.956520]  ath10k_stop+0x39/0x80 [ath10k_core]
[  984.956564]  drv_stop+0x33/0xf0 [mac80211]
[  984.956609]  ieee80211_stop_device+0x43/0x50 [mac80211]
[  984.956649]  ieee80211_do_stop+0x4fc/0x840 [mac80211]
[  984.956655]  ? __rtnl_unlock+0x2a/0x50
[  984.956660]  ? nla_memcpy+0x26/0x50
[  984.956700]  ieee80211_sdata_stop+0x1e/0x30 [mac80211]
[  984.956740]  ieee80211_stop_p2p_device+0x12/0x20 [mac80211]
[  984.956777]  cfg80211_stop_p2p_device+0x6c/0x180 [cfg80211]
[  984.956811]  nl80211_stop_p2p_device+0x2e/0x40 [cfg80211]
[  984.956816]  genl_family_rcv_msg+0x1f5/0x3d0
[  984.956820]  ? __netlink_sendskb+0x3e/0x60
[  984.956826]  genl_rcv_msg+0x4c/0x90
[  984.956830]  ? genl_family_rcv_msg+0x3d0/0x3d0
[  984.956834]  netlink_rcv_skb+0xe7/0x120
[  984.956838]  genl_rcv+0x28/0x40
[  984.956842]  netlink_unicast+0x18c/0x240
[  984.956847]  netlink_sendmsg+0x2c5/0x3a0
[  984.956851]  sock_sendmsg+0x38/0x50
[  984.956854]  ___sys_sendmsg+0x2b6/0x2d0
[  984.956859]  ? netlink_sendmsg+0x133/0x3a0
[  984.956866]  ? kzfree+0x2d/0x40
[  984.956872]  ? dput+0xc7/0x1f0
[  984.956878]  ? mntput+0x24/0x40
[  984.956882]  __sys_sendmsg+0x54/0x90
[  984.956886]  ? __sys_sendmsg+0x54/0x90
[  984.956890]  SyS_sendmsg+0x12/0x20
[  984.956896]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.956898] RIP: 0033:0x7fd5b8652450
[  984.956900] RSP: 002b:00007ffef628fb18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  984.956904] RAX: ffffffffffffffda RBX: 00005572d06095e0 RCX: 00007fd5b8652450
[  984.956906] RDX: 0000000000000000 RSI: 00007ffef628fba0 RDI: 0000000000000006
[  984.956908] RBP: 00005572d0608180 R08: 0000000000000000 R09: 00005572d060ac40
[  984.956910] R10: 0000000000001000 R11: 0000000000000246 R12: 00005572d06081a0
[  984.956912] R13: 0000000000000001 R14: 00005572d060a488 R15: 00005572d0609aec
[  984.956919] whoopsie        D    0  1169      1 0x00000004
[  984.956923] Call Trace:
[  984.956928]  __schedule+0x3c2/0x8b0
[  984.956934]  ? __wake_up_common+0x73/0x90
[  984.956938]  schedule+0x36/0x80
[  984.956941]  schedule_preempt_disabled+0xe/0x10
[  984.956945]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.956951]  __mutex_lock_slowpath+0x13/0x20
[  984.956954]  ? __mutex_lock_slowpath+0x13/0x20
[  984.956958]  mutex_lock+0x2f/0x40
[  984.956962]  rtnetlink_rcv+0x19/0x30
[  984.956966]  netlink_unicast+0x18c/0x240
[  984.956970]  netlink_sendmsg+0x2c5/0x3a0
[  984.956974]  sock_sendmsg+0x38/0x50
[  984.956977]  SYSC_sendto+0x101/0x190
[  984.956983]  ? security_file_permission+0x9b/0xc0
[  984.956989]  ? vfs_read+0x93/0x130
[  984.956993]  SyS_sendto+0xe/0x10
[  984.956998]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957000] RIP: 0033:0x7f804d02a3ff
[  984.957002] RSP: 002b:00007fffc050a600 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957006] RAX: ffffffffffffffda RBX: 0000000001ec71d0 RCX: 00007f804d02a3ff
[  984.957008] RDX: 0000000000000014 RSI: 00007fffc050a690 RDI: 0000000000000008
[  984.957010] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  984.957012] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f804d2eaa80
[  984.957014] R13: 00007f8038007120 R14: 0000000000000000 R15: 0000000001e9c2c0
[  984.957047] gnome-software  D    0  2123   1992 0x00000004
[  984.957051] Call Trace:
[  984.957055]  __schedule+0x3c2/0x8b0
[  984.957059]  schedule+0x36/0x80
[  984.957063]  schedule_preempt_disabled+0xe/0x10
[  984.957067]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957072]  __mutex_lock_slowpath+0x13/0x20
[  984.957076]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957079]  mutex_lock+0x2f/0x40
[  984.957083]  rtnetlink_rcv+0x19/0x30
[  984.957087]  netlink_unicast+0x18c/0x240
[  984.957091]  netlink_sendmsg+0x2c5/0x3a0
[  984.957095]  sock_sendmsg+0x38/0x50
[  984.957098]  SYSC_sendto+0x101/0x190
[  984.957103]  ? security_file_permission+0x9b/0xc0
[  984.957109]  ? vfs_read+0x93/0x130
[  984.957113]  SyS_sendto+0xe/0x10
[  984.957118]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957120] RIP: 0033:0x7f483f67e9ff
[  984.957122] RSP: 002b:00007fffd6f44dd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957126] RAX: ffffffffffffffda RBX: 0000000002a57f40 RCX: 00007f483f67e9ff
[  984.957128] RDX: 0000000000000014 RSI: 00007fffd6f44e60 RDI: 000000000000000e
[  984.957130] RBP: 00007fffd6f448e0 R08: 0000000000000000 R09: 0000000000000000
[  984.957132] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000006
[  984.957134] R13: 0000000000dc1960 R14: 0000000000000000 R15: 00007f48429c70da
[  984.957154] evolution-calen D    0  2487   2464 0x00000004
[  984.957158] Call Trace:
[  984.957162]  __schedule+0x3c2/0x8b0
[  984.957167]  schedule+0x36/0x80
[  984.957170]  schedule_preempt_disabled+0xe/0x10
[  984.957174]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957179]  __mutex_lock_slowpath+0x13/0x20
[  984.957183]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957186]  mutex_lock+0x2f/0x40
[  984.957190]  rtnetlink_rcv+0x19/0x30
[  984.957194]  netlink_unicast+0x18c/0x240
[  984.957198]  netlink_sendmsg+0x2c5/0x3a0
[  984.957202]  sock_sendmsg+0x38/0x50
[  984.957205]  SYSC_sendto+0x101/0x190
[  984.957209]  ? security_file_permission+0x9b/0xc0
[  984.957215]  ? vfs_read+0x93/0x130
[  984.957219]  SyS_sendto+0xe/0x10
[  984.957224]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957226] RIP: 0033:0x7f2764fc19ff
[  984.957228] RSP: 002b:00007ffc3f99d1d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957232] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2764fc19ff
[  984.957234] RDX: 0000000000000014 RSI: 00007ffc3f99d260 RDI: 0000000000000009
[  984.957236] RBP: 00007f274401fc00 R08: 0000000000000000 R09: 0000000000000000
[  984.957238] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f274401fc20
[  984.957240] R13: 0000000000000001 R14: 00007ffc3f99c950 R15: 0000000000000000
[  984.957246] evolution-calen D    0  2499   2464 0x00000004
[  984.957249] Call Trace:
[  984.957254]  __schedule+0x3c2/0x8b0
[  984.957258]  schedule+0x36/0x80
[  984.957262]  schedule_preempt_disabled+0xe/0x10
[  984.957265]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957271]  __mutex_lock_slowpath+0x13/0x20
[  984.957274]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957278]  mutex_lock+0x2f/0x40
[  984.957281]  rtnetlink_rcv+0x19/0x30
[  984.957285]  netlink_unicast+0x18c/0x240
[  984.957289]  netlink_sendmsg+0x2c5/0x3a0
[  984.957293]  sock_sendmsg+0x38/0x50
[  984.957296]  SYSC_sendto+0x101/0x190
[  984.957301]  ? security_file_permission+0x9b/0xc0
[  984.957306]  ? vfs_read+0x93/0x130
[  984.957310]  SyS_sendto+0xe/0x10
[  984.957315]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957317] RIP: 0033:0x7fb2c6e629ff
[  984.957320] RSP: 002b:00007ffcf7509210 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957323] RAX: ffffffffffffffda RBX: 00007fb2c6e4cb20 RCX: 00007fb2c6e629ff
[  984.957326] RDX: 0000000000000014 RSI: 00007ffcf75092a0 RDI: 0000000000000009
[  984.957328] RBP: 0000000000000030 R08: 0000000000000000 R09: 0000000000000000
[  984.957330] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fb2a8003c60
[  984.957332] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000003c
[  984.957337] evolution-addre D    0  2519   2497 0x00000004
[  984.957341] Call Trace:
[  984.957345]  __schedule+0x3c2/0x8b0
[  984.957350]  schedule+0x36/0x80
[  984.957353]  schedule_preempt_disabled+0xe/0x10
[  984.957357]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957362]  __mutex_lock_slowpath+0x13/0x20
[  984.957366]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957369]  mutex_lock+0x2f/0x40
[  984.957373]  rtnetlink_rcv+0x19/0x30
[  984.957377]  netlink_unicast+0x18c/0x240
[  984.957381]  netlink_sendmsg+0x2c5/0x3a0
[  984.957385]  sock_sendmsg+0x38/0x50
[  984.957388]  SYSC_sendto+0x101/0x190
[  984.957393]  ? security_file_permission+0x9b/0xc0
[  984.957398]  ? vfs_read+0x93/0x130
[  984.957402]  SyS_sendto+0xe/0x10
[  984.957407]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957409] RIP: 0033:0x7f4a6d1aa9ff
[  984.957411] RSP: 002b:00007ffd455986c0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957415] RAX: ffffffffffffffda RBX: 00007f4a6d194b20 RCX: 00007f4a6d1aa9ff
[  984.957417] RDX: 0000000000000014 RSI: 00007ffd45598750 RDI: 0000000000000009
[  984.957419] RBP: 0000000000000091 R08: 0000000000000000 R09: 0000000000000000
[  984.957421] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f4a6d194b78
[  984.957423] R13: 00007f4a6d194b78 R14: 000000000000270f R15: 00007f4a6d194c78
[  984.957433] geoclue         D    0  2681      1 0x00000004
[  984.957437] Call Trace:
[  984.957441]  __schedule+0x3c2/0x8b0
[  984.957445]  ? consume_skb+0x34/0xa0
[  984.957449]  schedule+0x36/0x80
[  984.957453]  schedule_preempt_disabled+0xe/0x10
[  984.957456]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957462]  __mutex_lock_slowpath+0x13/0x20
[  984.957465]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957469]  mutex_lock+0x2f/0x40
[  984.957472]  rtnetlink_rcv+0x19/0x30
[  984.957476]  netlink_unicast+0x18c/0x240
[  984.957480]  netlink_sendmsg+0x2c5/0x3a0
[  984.957484]  sock_sendmsg+0x38/0x50
[  984.957488]  SYSC_sendto+0x101/0x190
[  984.957492]  ? security_file_permission+0x9b/0xc0
[  984.957498]  ? vfs_read+0x93/0x130
[  984.957501]  SyS_sendto+0xe/0x10
[  984.957506]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957509] RIP: 0033:0x7f22fe6c13ff
[  984.957510] RSP: 002b:00007fff93ef7c70 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957514] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f22fe6c13ff
[  984.957516] RDX: 0000000000000014 RSI: 00007fff93ef7d00 RDI: 0000000000000007
[  984.957518] RBP: 00007fff93ef7c30 R08: 0000000000000000 R09: 0000000000000000
[  984.957520] R10: 0000000000004000 R11: 0000000000000246 R12: 00007f22ec00a670
[  984.957522] R13: 00007fff93ef7cb0 R14: 00007fff93ef7cd0 R15: 0000000000000000
[  984.957535] DNS Resolver #3 D    0 14484   1715 0x00000004
[  984.957539] Call Trace:
[  984.957543]  __schedule+0x3c2/0x8b0
[  984.957547]  schedule+0x36/0x80
[  984.957551]  schedule_preempt_disabled+0xe/0x10
[  984.957555]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957560]  __mutex_lock_slowpath+0x13/0x20
[  984.957564]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957567]  mutex_lock+0x2f/0x40
[  984.957571]  rtnetlink_rcv+0x19/0x30
[  984.957575]  netlink_unicast+0x18c/0x240
[  984.957579]  netlink_sendmsg+0x2c5/0x3a0
[  984.957583]  sock_sendmsg+0x38/0x50
[  984.957586]  SYSC_sendto+0x101/0x190
[  984.957593]  ? SYSC_getsockname+0x89/0xe0
[  984.957599]  ? fd_install+0x25/0x30
[  984.957604]  ? sock_map_fd+0x44/0x70
[  984.957608]  SyS_sendto+0xe/0x10
[  984.957613]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957615] RIP: 0033:0x7fec02b384d3
[  984.957617] RSP: 002b:00007febad1fda50 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[  984.957621] RAX: ffffffffffffffda RBX: 00007febad1ff700 RCX: 00007fec02b384d3
[  984.957623] RDX: 0000000000000014 RSI: 00007febad1feb10 RDI: 000000000000002c
[  984.957625] RBP: 00007febe6ee6690 R08: 00007febad1feaf0 R09: 000000000000000c
[  984.957627] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[  984.957629] R13: 00007febe6ee65ef R14: 0000000000800000 R15: 00007febab477e20
[  984.957640] deja-dup-monito D    0  2923   1992 0x00000004
[  984.957644] Call Trace:
[  984.957649]  __schedule+0x3c2/0x8b0
[  984.957653]  schedule+0x36/0x80
[  984.957657]  schedule_preempt_disabled+0xe/0x10
[  984.957660]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957666]  __mutex_lock_slowpath+0x13/0x20
[  984.957670]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957673]  mutex_lock+0x2f/0x40
[  984.957677]  rtnetlink_rcv+0x19/0x30
[  984.957681]  netlink_unicast+0x18c/0x240
[  984.957685]  netlink_sendmsg+0x2c5/0x3a0
[  984.957689]  sock_sendmsg+0x38/0x50
[  984.957692]  SYSC_sendto+0x101/0x190
[  984.957696]  ? security_file_permission+0x9b/0xc0
[  984.957702]  ? vfs_read+0x93/0x130
[  984.957706]  SyS_sendto+0xe/0x10
[  984.957711]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957713] RIP: 0033:0x7ff26c2df9ff
[  984.957715] RSP: 002b:00007fff507f7630 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957719] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff26c2df9ff
[  984.957721] RDX: 0000000000000014 RSI: 00007fff507f76c0 RDI: 0000000000000008
[  984.957723] RBP: 0000000001461ba0 R08: 0000000000000000 R09: 0000000000000000
[  984.957725] R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
[  984.957727] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fff507f6960
[  984.957737] ip              D    0 14444  14443 0x00000004
[  984.957741] Call Trace:
[  984.957745]  __schedule+0x3c2/0x8b0
[  984.957750]  schedule+0x36/0x80
[  984.957753]  schedule_preempt_disabled+0xe/0x10
[  984.957757]  __mutex_lock.isra.2+0x2ae/0x4e0
[  984.957761]  ? current_time+0x38/0x70
[  984.957766]  __mutex_lock_slowpath+0x13/0x20
[  984.957769]  ? __mutex_lock_slowpath+0x13/0x20
[  984.957773]  mutex_lock+0x2f/0x40
[  984.957777]  rtnetlink_rcv+0x19/0x30
[  984.957780]  netlink_unicast+0x18c/0x240
[  984.957785]  netlink_sendmsg+0x2c5/0x3a0
[  984.957789]  sock_sendmsg+0x38/0x50
[  984.957792]  SYSC_sendto+0x101/0x190
[  984.957798]  ? handle_mm_fault+0xcc/0x1c0
[  984.957806]  ? __do_page_fault+0x283/0x4f0
[  984.957810]  SyS_sendto+0xe/0x10
[  984.957815]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  984.957817] RIP: 0033:0x7fb0aae9f39d
[  984.957819] RSP: 002b:00007fffa92ab0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  984.957822] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb0aae9f39d
[  984.957824] RDX: 0000000000000028 RSI: 00007fffa92ab0d0 RDI: 0000000000000003
[  984.957826] RBP: 000000000155b250 R08: 0000000000000000 R09: 0000000000000000
[  984.957828] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  984.957830] R13: 000000000065a540 R14: 00007fffa92ace62 R15: 00007fffa92ab11c
[  984.957839] OOM killer enabled.
[  984.957840] Restarting tasks ... done.

The lines are repearing. 

> 
> -- 
> Kalle Valo
