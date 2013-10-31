Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36574 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3JaQqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:46:04 -0400
Message-ID: <52728931.9090504@candelatech.com> (sfid-20131031_174617_207108_9C1210FA)
Date: Thu, 31 Oct 2013 09:45:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash related to wmi_event_mgt_rx (or ieee80211_rx).
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is yesterday's ath tree, with Michal's ath10k RFT patch series applied,
and a few ath10k patches of my own.  Using modified ath10k firmware that supports
two stations to same AP.  This happened on module reload.


(gdb) l *(ath10k_wmi_event_mgmt_rx+0x246)
0xb501 is in ath10k_wmi_event_mgmt_rx (/mnt/sda/home/greearb/git/linux.ath/drivers/net/wireless/ath/ath10k/wmi.c:959).
954		 * because they can originally come in along with a trailer
955		 */
956		skb_trim(skb, buf_len);
957	
958		ieee80211_rx(ar->hw, skb);
959		return 0;
960	}
961	
962	static int freq_to_idx(struct ath10k *ar, int freq)
963	{

(gdb) l *(ieee80211_rx+0x54f)
0x1ac7a is in ieee80211_rx (/mnt/sda/home/greearb/git/linux.ath/arch/x86/include/asm/bitops.h:329).
324	}
325	
326	static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
327	{
328		return ((1UL << (nr & (BITS_PER_LONG-1))) &
329			(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
330	}
331	
332	static inline int variable_test_bit(long nr, volatile const unsigned long *addr)
333	{

general protection fault: 0000 [#1] PREEMPT SMP
Modules linked in: ath10k_pci(-) ath10k_core nfsv3 nfs_acl nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp s]
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        WC   3.12.0-rc5-wl+ #2
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
task: ffffffff81a14490 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<ffffffffa032ac7a>]  [<ffffffffa032ac7a>] ieee80211_rx+0x54f/0x649 [mac80211]
RSP: 0018:ffff88021fa03b30  EFLAGS: 00010287
RAX: ffff880032c31ad0 RBX: ffff880032c308a0 RCX: 01526201bc0b4003
RDX: 0000000000000003 RSI: ffffffff81a14ba8 RDI: ffffffff81a14ba8
RBP: ffff88021fa03bc0 R08: ffff88020d766401 R09: ffff88020d766418
R10: ffffffff810c1f95 R11: ffff880032c30bd0 R12: ffff880032e11b00
R13: ffff880034324ca0 R14: ffff880032e36464 R15: dead000000100100
FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001a90ae0 CR3: 0000000001a0d000 CR4: 00000000000407f0
Stack:
 ffff88021fa03b68 0000000000000001 00000000ffffffe6 dead000000100100
 ffff8800cc013600 ffff880032c308a0 ffff8800cd658a00 ffff8802120bd668
 0000000000000000 0000001000000000 0000000000000010 0000000000000000
Call Trace:
 <IRQ>
 [<ffffffffa0a01501>] ath10k_wmi_event_mgmt_rx+0x246/0x27e [ath10k_core]
 [<ffffffffa0a0435a>] ath10k_wmi_process_rx+0x6cc/0xa5a [ath10k_core]
 [<ffffffffa09fb07a>] ? ath10k_dbg+0x5c/0x5e [ath10k_core]
 [<ffffffffa09fda39>] ath10k_htc_rx_completion_handler+0x3b4/0x3e8 [ath10k_core]
 [<ffffffffa09fb07a>] ? ath10k_dbg+0x5c/0x5e [ath10k_core]
 [<ffffffffa0a18fe5>] ath10k_pci_process_ce+0x1a2/0x21e [ath10k_pci]
 [<ffffffffa0a190ae>] ath10k_pci_ce_recv_data+0x4d/0x123 [ath10k_pci]
 [<ffffffffa0a1b650>] ath10k_ce_per_engine_service+0x6b/0xab [ath10k_pci]
 [<ffffffffa0a1b6df>] ath10k_ce_per_engine_service_any+0x4f/0x6c [ath10k_pci]
 [<ffffffffa0a1a250>] ath10k_pci_tasklet+0x1e/0x4e [ath10k_pci]
 [<ffffffff810a2bed>] tasklet_action+0x88/0xe8
 [<ffffffff810de341>] ? handle_irq_event+0x47/0x5e
 [<ffffffff810a2eb8>] __do_softirq+0xc9/0x18e
 [<ffffffff81597dbc>] call_softirq+0x1c/0x30
 [<ffffffff8100c0d2>] do_softirq+0x45/0x9b
 [<ffffffff810a30a0>] irq_exit+0x56/0x9b
 [<ffffffff8100bd58>] do_IRQ+0x89/0xa0
 [<ffffffff81591eb2>] common_interrupt+0x72/0x72
 <EOI>
 [<ffffffff81495b80>] ? arch_local_irq_enable+0x8/0xd
 [<ffffffff810efe16>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81495ead>] cpuidle_enter_state+0x51/0xbc
 [<ffffffff81495fe4>] cpuidle_idle_call+0xcc/0x118
 [<ffffffff81011b57>] arch_cpu_idle+0x9/0x21
 [<ffffffff810dda69>] cpu_startup_entry+0xae/0x119
 [<ffffffff8157fedd>] rest_init+0xc1/0xc8
 [<ffffffff8157fe1c>] ? csum_partial_copy_generic+0x16c/0x16c
 [<ffffffff81ae4d5c>] start_kernel+0x3b2/0x3bf
 [<ffffffff81ae47b2>] ? repair_env_string+0x5a/0x5a
 [<ffffffff81ae44b8>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81ae45a4>] x86_64_start_kernel+0xea/0xf7
Code: a8 48 89 45 a0 e9 99 00 00 00 4c 89 e7 e8 13 77 1a e1 e9 fa fd ff ff 48 8b 83 30 12 00 00 45 31 ed 48
RIP  [<ffffffffa032ac7a>] ieee80211_rx+0x54f/0x649 [mac80211]
 RSP <ffff88021fa03b30>
---[ end trace 1385eeb9a1ac09ee ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

