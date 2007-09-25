Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34693
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbXIYUG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 16:06:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: mac80211: crash while adding interface.
Date: Tue, 25 Sep 2007 22:06:57 +0200
MIME-Version: 1.0
Message-Id: <200709252206.57855.mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following happened when adding an interface through sysfs
on b43, while another one was operating and transmitting data:

[42108.560015] b43-phy4 debug: Current TX power output: 14.25 dBm, Desired TX power output: 14.25 dBm
[42214.690045] b43-phy4 debug: Current TX power output: 14.25 dBm, Desired TX power output: 14.25 dBm
[42262.691175] wmaster0: STA 00:12:17:d4:95:e1 Average rate: 10 (10/1)
[42278.273723] Unable to handle kernel paging request for data at address 0x00000000
[42278.274012] Faulting instruction address: 0xc0332848
[42278.274204] Oops: Kernel access of bad area, sig: 11 [#1]
[42278.274400] PREEMPT PowerMac
[42278.274530] Modules linked in: rc80211_simple b43 ssb zd1211rw_mac80211 appletouch af_packet ecb rng_core mac80211 ohci_hcd pcmcia unix
[42278.275192] NIP: c0332848 LR: e20d410c CTR: c0332800
[42278.275376] REGS: d1257d40 TRAP: 0300   Not tainted  (2.6.23-rc6-wldev)
[42278.275611] MSR: 00001032 <ME,IR,DR>  CR: 24242484  XER: 00000000
[42278.275943] DAR: 00000000, DSISR: 40000000
[42278.276096] TASK = d53f6d50[30638] 'bash' THREAD: d1256000
[42278.276293] GPR00: 00000000 d1257df0 d53f6d50 c14395ec d1257e08 c1439000 c14393bc c143947c 
[42278.276749] GPR08: c143947c 00000000 00009032 d1256000 00000000 100e1258 00000000 00000000 
[42278.277204] GPR16: 100edd98 100e0000 100b0000 100e0000 00000000 00000000 100fae28 00000000 
[42278.277660] GPR24: 00000001 00000002 00000000 c1439000 c0be11a0 df3323a0 c14393a0 00000000 
[42278.278131] NIP [c0332848] skb_dequeue+0x48/0xa0
[42278.278330] LR [e20d410c] ieee80211_if_reinit+0x1c0/0x284 [mac80211]
[42278.278630] Call Trace:
[42278.278727] [d1257df0] [df3323a0] 0xdf3323a0 (unreliable)
[42278.278976] [d1257e00] [e20d410c] ieee80211_if_reinit+0x1c0/0x284 [mac80211]
[42278.279279] [d1257e30] [c033af58] register_netdevice+0x3f0/0x408
[42278.279532] [d1257e50] [e20d3e94] ieee80211_if_add+0x118/0x1d0 [mac80211]
[42278.279827] [d1257e80] [e20d5a6c] ieee80211_add_iface+0x8c/0x9c [mac80211]
[42278.280124] [d1257e90] [c0420608] _store_add_iface+0x70/0x9c
[42278.280366] [d1257eb0] [c021a704] dev_attr_store+0x28/0x40
[42278.280605] [d1257ec0] [c00c09ac] sysfs_write_file+0x13c/0x1c4
[42278.280856] [d1257ef0] [c007c56c] vfs_write+0xc0/0x164
[42278.281079] [d1257f10] [c007cbc4] sys_write+0x4c/0x8c
[42278.281298] [d1257f40] [c00128e4] ret_from_syscall+0x0/0x38
[42278.281540] --- Exception: c01 at 0xfed0c18
[42278.281714]     LR = 0xfe7963c
[42278.281831] Instruction dump:
[42278.281959] 7c000124 542b0024 812b000c 39290001 912b000c 83e30000 38000000 7f9f1800 
[42278.282378] 40be000c 3be00000 48000024 81230008 <817f0000> 3929ffff 91230008 91630000 
[42278.282854] note: bash[30638] exited with preempt_count 1
[42278.284214] BUG: scheduling while atomic: bash/0x10000002/30638
[42278.285519] Call Trace:
[42278.286708] [d1257b80] [c00082a0] show_stack+0x50/0x184 (unreliable)
[42278.288107] [d1257ba0] [c0029d54] __schedule_bug+0x34/0x44
[42278.289443] [d1257bb0] [c04237c8] schedule+0x70/0x3e0
[42278.290765] [d1257be0] [c0029df0] __cond_resched+0x24/0x50
[42278.292080] [d1257bf0] [c0424318] cond_resched+0x40/0x54
[42278.293390] [d1257c00] [c0066c58] unmap_vmas+0x428/0x51c
[42278.294678] [d1257c70] [c006a900] exit_mmap+0x74/0x118
[42278.295951] [d1257ca0] [c002c770] mmput+0x3c/0x100
[42278.297218] [d1257cb0] [c0030a9c] exit_mm+0x10c/0x120
[42278.298516] [d1257cd0] [c0032574] do_exit+0x220/0x8c4
[42278.299788] [d1257d00] [c0010df4] kernel_bad_stack+0x0/0x4c
[42278.301067] [d1257d20] [c00164f4] bad_page_fault+0xb8/0xcc
[42278.302344] [d1257d30] [c0012d80] handle_page_fault+0x7c/0x80
[42278.303643] --- Exception: 300 at skb_dequeue+0x48/0xa0
[42278.304932]     LR = ieee80211_if_reinit+0x1c0/0x284 [mac80211]
[42278.306184] [d1257df0] [df3323a0] 0xdf3323a0 (unreliable)
[42278.307459] [d1257e00] [e20d410c] ieee80211_if_reinit+0x1c0/0x284 [mac80211]
[42278.308816] [d1257e30] [c033af58] register_netdevice+0x3f0/0x408
[42278.310112] [d1257e50] [e20d3e94] ieee80211_if_add+0x118/0x1d0 [mac80211]
[42278.311455] [d1257e80] [e20d5a6c] ieee80211_add_iface+0x8c/0x9c [mac80211]
[42278.312787] [d1257e90] [c0420608] _store_add_iface+0x70/0x9c
[42278.314052] [d1257eb0] [c021a704] dev_attr_store+0x28/0x40
[42278.315289] [d1257ec0] [c00c09ac] sysfs_write_file+0x13c/0x1c4
[42278.316537] [d1257ef0] [c007c56c] vfs_write+0xc0/0x164
[42278.317761] [d1257f10] [c007cbc4] sys_write+0x4c/0x8c
[42278.318996] [d1257f40] [c00128e4] ret_from_syscall+0x0/0x38
[42278.320243] --- Exception: c01 at 0xfed0c18
[42278.321410]     LR = 0xfe7963c
[42289.710017] b43-phy4 debug: Current TX power output: 14.25 dBm, Desired TX power output: 14.25 dBm
[42299.370401] wmaster0: Discarded packet with nonexistent originating device
[42305.370223] wmaster0: Discarded packet with nonexistent originating device
[42312.370226] wmaster0: Discarded packet with nonexistent originating device
