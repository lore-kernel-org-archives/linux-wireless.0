Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39901 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1AGG7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 01:59:47 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p076xkrS019895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 6 Jan 2011 22:59:46 -0800
Message-ID: <4D26B9E2.8040705@candelatech.com>
Date: Thu, 06 Jan 2011 22:59:46 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel crash on ath9k module unload, wireless-testing-2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had 60 station interfaces configured on ath9k, and unloaded
the modules.  I got this crash.  It may be of interest that 00100100
is the list poison.  This seems to be a rare bug, as I've unloaded modules
around 20 times in the last few days and this is the first time I saw it.

I have seen this in the past (around first of December I think) as well,
so it's not a new bug.

The gdb output for the crash site doesn't give me much in
the way of ideas, but maybe the skb is stale memory and something
else has acquired it and started using it?

(gdb) l *(ieee80211_rx+0xf7)
0x14a40 is in ieee80211_rx (/home/greearb/git/linux.wireless-testing/net/mac80211/rx.c:2887).
2882					goto drop;
2883				rate = &sband->bitrates[status->rate_idx];
2884			}
2885		}
2886	
2887		status->rx_flags = 0;
2888	
2889		/*
2890		 * key references and virtual interfaces are protected using RCU
2891		 * and this requires that we are in a read-side RCU section during
(gdb) l *(ieee80211_rx+0x7ac)
0x150f5 is in ieee80211_rx (/home/greearb/git/linux.wireless-testing/arch/x86/include/asm/processor.h:837).
832	 * It's not worth to care about 3dnow prefetches for the K6
833	 * because they are microcoded there and very slow.
834	 */
835	static inline void prefetch(const void *x)
836	{
837		alternative_input(BASE_PREFETCH,
838				  "prefetchnta (%1)",
839				  X86_FEATURE_XMM,
840				  "r" (x));
841	}
(gdb) l *(ieee80211_rx+0x853)
0x1519c is in ieee80211_process_measurement_req (/home/greearb/git/linux.wireless-testing/net/mac80211/spectmgmt.c:74).
69	}
70	
71	void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
72					       struct ieee80211_mgmt *mgmt,
73					       size_t len)
74	{
75		/*
76		 * Ignoring measurement request is spec violation.
77		 * Mandatory measurements must be reported optional
78		 * measurements might be refused or reported incapable


BUG: unable to handle kernel paging request at 00100100
IP: [<f952b0d1>] ieee80211_rx+0x7ac/0x853 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:1/0:0:1:0/block/sda/sda1/stat
Modules linked in: michael_mic ath5k arc4 ath9k(-) mac80211 ath9k_common ath9k_hw ath cfg80211 8021q g]

Pid: 25780, comm: ip Tainted: G        W   2.6.37-wl+ #62 To be filled by O.E.M./To Be Filled By O.E.M.
EIP: 0060:[<f952b0d1>] EFLAGS: 00010246 CPU: 1
EIP is at ieee80211_rx+0x7ac/0x853 [mac80211]
EAX: 00000001 EBX: de5b35a0 ECX: 00000001 EDX: 78960218
ESI: 00100100 EDI: f58c7e5c EBP: f58c7e6c ESP: f58c7e00
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process ip (pid: 25780, ti=f58c6000 task=a40314e0 task.ti=cfaf6000)
Stack:
  00000002 00000001 00000000 f952aa1c 00000020 f58c7e24 7845a85c f5802a80
  f58c7e44 f95623c0 e13d8c64 b97b40a0 dfa78d00 b97b40aa e00d4f00 e13d8460
  cfebd600 00000000 00000000 00000000 00000010 00000000 00000000 00100100
Call Trace:
  [<f952aa1c>] ? ieee80211_rx+0xf7/0x853 [mac80211]
  [<7845a85c>] ? trace_hardirqs_on_caller+0xeb/0x125
  [<f9553366>] ? ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
  [<f9554ce7>] ? ath_rx_tasklet+0x1318/0x13af [ath9k]
  [<7845a405>] ? mark_lock+0x1e/0x1eb
  [<7845a619>] ? mark_held_locks+0x47/0x5f
  [<7878ebcb>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
  [<7845a85c>] ? trace_hardirqs_on_caller+0xeb/0x125
  [<7845a8a1>] ? trace_hardirqs_on+0xb/0xd
  [<f9552ce1>] ? ath9k_tasklet+0x98/0x12d [ath9k]
  [<7845a85c>] ? trace_hardirqs_on_caller+0xeb/0x125
  [<7843be09>] ? tasklet_action+0x88/0xe3
  [<7843c385>] ? __do_softirq+0x85/0x142
  [<7843c300>] ? __do_softirq+0x0/0x142
  [<7843c300>] ? __do_softirq+0x0/0x142
  <IRQ>
  [<7843c1a7>] ? irq_exit+0x35/0x69
  [<78404245>] ? do_IRQ+0x8e/0xa2
  [<784036ae>] ? common_interrupt+0x2e/0x40
  [<7845007b>] ? pm_qos_update_request+0x4b/0x57
  [<784b6f41>] ? kmem_cache_alloc+0x81/0xa1
  [<784c9aaf>] ? getname+0x1b/0xb8
  [<784c9aaf>] ? getname+0x1b/0xb8
  [<784b586b>] ? slab_pad_check+0x1e/0xf6
  [<784cab08>] ? user_path_at+0x15/0x60
  [<784b53f3>] ? check_valid_pointer+0x1c/0x48
  [<784b5c34>] ? check_object+0x154/0x185
  [<784b6663>] ? free_debug_processing+0x136/0x15b
  [<7845a9b8>] ? debug_check_no_locks_freed+0x115/0x12d
  [<784c4345>] ? vfs_fstatat+0x2f/0x55
  [<7845a8a1>] ? trace_hardirqs_on+0xb/0xd
  [<784c444c>] ? vfs_stat+0x1b/0x1d
  [<784c4462>] ? sys_stat64+0x14/0x28
  [<78478b22>] ? audit_syscall_entry+0x113/0x135
  [<7840a3c3>] ? syscall_trace_enter+0xbb/0xcc
  [<7878ee55>] ? syscall_call+0x7/0xb
Code: ff 8b 55 c4 31 c9 89 5d d4 89 45 d8 8d 45 cc e8 6a ef ff ff 89 f3 8b 06 89 45 f0 8b 37 e8 38 e5
EIP: [<f952b0d1>] ieee80211_rx+0x7ac/0x853 [mac80211] SS:ESP 0068:f58c7e00
CR2: 0000000000100100

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
