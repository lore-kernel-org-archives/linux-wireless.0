Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19999 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759941AbYBNXgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 18:36:03 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: sending ARP triggers BUG
Date: Thu, 14 Feb 2008 15:34:29 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com> (sfid-20080214_233616_475030_0973B7CC)
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Johannes Berg" <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently started seeing the BUG below. ieee80211_subif_start_xmit
calls pskb_expand_head, but this function BUGs because the skb is
shared. So far I have only seen this with arp messages ... I don't know
the significance of this fact.

------------[ cut here ]------------
kernel BUG at .../net/core/skbuff.c:643!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: iwl3945 rfcomm l2cap bluetooth ipv6 acpi_cpufreq
cpufreq_powersave cpufe
Pid: 0, comm: swapper Not tainted (2.6.24 #3)
EIP: 0060:[<c024ef05>] EFLAGS: 00010202 CPU: 1
EIP is at pskb_expand_head+0x23/0x140
EAX: dba19d50 EBX: daa72bb8 ECX: 0000000c EDX: dba19cd0
ESI: 0000000c EDI: dba19cd2 EBP: da473d04 ESP: da473ce8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=da472000 task=da46a000 task.ti=da472000)
Stack: 00000025 d74ee000 da473d04 000000d3 00000006 0000000c dba19cd2
da473d84
       dca9360e 00000020 c0143622 da46a57c d797f000 daa72bb8 dba19ce0
dba19cf4
       c037f108 da46a000 00000002 da46a050 0000001a 00000000 d9bb82a0
08000002
Call Trace:
 [<c01050bc>] show_trace_log_lvl+0x1a/0x2f
 [<c010516c>] show_stack_log_lvl+0x9b/0xa3
 [<c0105218>] show_registers+0xa4/0x1d9
 [<c010546e>] die+0x121/0x202
 [<c02b7458>] do_trap+0x8a/0xa3
 [<c010580e>] do_invalid_op+0x88/0x92
 [<c02b722a>] error_code+0x72/0x78
 [<dca9360e>] ieee80211_subif_start_xmit+0x330/0x56e [mac80211]
 [<c02540e7>] dev_hard_start_xmit+0x24e/0x2b3
 [<c02627d9>] __qdisc_run+0x74/0x16b
 [<c025643e>] dev_queue_xmit+0x19f/0x2e5
 [<c028f1f1>] arp_xmit+0x4b/0x51
 [<c028fc08>] arp_send+0x45/0x4c
 [<c02904c6>] arp_solicit+0x196/0x1aa
 [<c025babb>] neigh_timer_handler+0x267/0x2a8
 [<c012d1b0>] run_timer_softirq+0x142/0x1a4
 [<c0129bd1>] __do_softirq+0x78/0xed
 [<c0129c7f>] do_softirq+0x39/0x55
 [<c0129e32>] irq_exit+0x45/0x83
 [<c0115edf>] smp_apic_timer_interrupt+0x77/0x84
 [<c0104b6f>] apic_timer_interrupt+0x33/0x38
 [<c010259c>] cpu_idle+0x9e/0xd3
 [<c0114c82>] start_secondary+0x165/0x16c
 [<00000000>] 0x0
 =======================
Code: f1 f4 f1 ff 5b 5e 5d c3 55 89 e5 57 56 53 89 c3 83 ec 10 83 bb a0
00 00 00 01 89 55
EIP: [<c024ef05>] pskb_expand_head+0x23/0x140 SS:ESP 0068:da473ce8
Kernel panic - not syncing: Fatal exception in interrupt
