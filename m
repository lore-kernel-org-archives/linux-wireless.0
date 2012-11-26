Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45982 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab2KZRKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:14 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qAQHADWX019929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 09:10:13 -0800
Message-ID: <50B3A275.3010302@candelatech.com> (sfid-20121126_184257_410312_9D3ECF7B)
Date: Mon, 26 Nov 2012 09:10:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Kernel splat from 3.5.7+ (tainted)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This looks like some sort of locking bug...the warning comes from the code
in softirq.c (below). For what it's worth, the tainting module was not in active use.

I should be able to get source code printout for the various addresses
if there is anything of particular interest.


static inline void _local_bh_enable_ip(unsigned long ip)
{
	WARN_ON_ONCE(in_irq() || irqs_disabled());
#ifdef CONFIG_TRACE_IRQFLAGS
	local_irq_disable();
#endif


Nov 21 19:33:17 localhost kernel: WARNING: at /home/greearb/git/linux-3.5.dev.y/kernel/softirq.c:159 _local_bh_enable_ip+0x41/0x9f()
Nov 21 19:33:17 localhost kernel: Hardware name: To be filled by O.E.M.
Nov 21 19:33:17 localhost kernel: Modules linked in: bnep bluetooth fuse 8021q garp stp llc macvlan wanlink(PO) pktgen lockd sunrpc gpio_ich ppdev coretemp 
hwmon kvm snd_hda_codec_realtek microcode serio_raw snd_hda_intel pcspkr snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm i2c_i801 lpc_ich mfd_core ath9k 
ath9k_common ath9k_hw ath mac80211 cfg80211 e1000e snd_page_alloc snd_timer snd soundcore parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper 
drm i2c_core [last unloaded: nf_nat]
Nov 21 19:33:17 localhost kernel: Pid: 5905, comm: kworker/u:0 Tainted: P           O 3.5.7+ #27
Nov 21 19:33:17 localhost kernel: Call Trace:
Nov 21 19:33:17 localhost kernel: <IRQ>  [<ffffffff8105c5cc>] warn_slowpath_common+0x80/0x98
Nov 21 19:33:17 localhost kernel: [<ffffffff8105c5f9>] warn_slowpath_null+0x15/0x17
Nov 21 19:33:17 localhost kernel: [<ffffffff81062dfa>] _local_bh_enable_ip+0x41/0x9f
Nov 21 19:33:17 localhost kernel: [<ffffffff81062e61>] local_bh_enable_ip+0x9/0xb
Nov 21 19:33:17 localhost kernel: [<ffffffff814e31a6>] _raw_spin_unlock_bh+0x1c/0x1e
Nov 21 19:33:17 localhost kernel: [<ffffffff8144fee4>] destroy_conntrack+0xbd/0xfc
Nov 21 19:33:17 localhost kernel: [<ffffffff8144da47>] nf_conntrack_destroy+0x27/0x2e
Nov 21 19:33:17 localhost kernel: [<ffffffff81422934>] skb_release_head_state+0x9a/0xdc
Nov 21 19:33:17 localhost kernel: [<ffffffff81422b77>] __kfree_skb+0x11/0x7d
Nov 21 19:33:17 localhost kernel: [<ffffffff81422c2c>] consume_skb+0x28/0x2a
Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa2f9>] __ieee80211_tx+0x1f9/0x31a [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffff810247b2>] ? smp_apic_timer_interrupt+0x85/0x93
Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa4e0>] ieee80211_tx+0xc6/0xed [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffff81422c00>] ? kfree_skb_partial+0x1d/0x21
Nov 21 19:33:17 localhost kernel: [<ffffffff81422d6b>] ? pskb_expand_head+0x13d/0x1eb
Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa95c>] ieee80211_xmit+0xbe/0xcc [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01fb4ab>] ieee80211_subif_start_xmit+0xae2/0xb00 [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffff81084f17>] ? load_balance+0xc3/0x5ea
Nov 21 19:33:17 localhost kernel: [<ffffffff8142c92e>] dev_hard_start_xmit+0x3e2/0x4d6
Nov 21 19:33:17 localhost kernel: [<ffffffff814435ef>] sch_direct_xmit+0x6d/0x14d
Nov 21 19:33:17 localhost kernel: [<ffffffff814437de>] __qdisc_run+0x10f/0x12b
Nov 21 19:33:17 localhost kernel: [<ffffffff8142940b>] net_tx_action+0xe9/0x11e
Nov 21 19:33:17 localhost kernel: [<ffffffff81062f55>] __do_softirq+0x86/0x12f
Nov 21 19:33:17 localhost kernel: [<ffffffff814e955c>] call_softirq+0x1c/0x30
Nov 21 19:33:17 localhost kernel: <EOI>  [<ffffffff8100bbd9>] do_softirq+0x41/0x7e
Nov 21 19:33:17 localhost kernel: [<ffffffff81062e33>] _local_bh_enable_ip+0x7a/0x9f
Nov 21 19:33:17 localhost kernel: [<ffffffff81062e70>] local_bh_enable+0xd/0xf
Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa9c7>] ieee80211_tx_skb_tid+0x5d/0x5f [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa0200a26>] ieee80211_send_nullfunc+0x5f/0x64 [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e8cba>] ieee80211_offchannel_return+0x9c/0x1d8 [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e794f>] __ieee80211_scan_completed+0x13e/0x179 [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e88ed>] ieee80211_scan_work+0x418/0x42f [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffff814e2495>] ? __schedule+0x51f/0x561
Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
Nov 21 19:33:17 localhost kernel: [<ffffffff8106fcc7>] process_one_work+0x1a6/0x278
Nov 21 19:33:17 localhost kernel: [<ffffffff81071cd3>] worker_thread+0x136/0x255
Nov 21 19:33:17 localhost kernel: [<ffffffff81071b9d>] ? manage_workers+0x191/0x191
Nov 21 19:33:17 localhost kernel: [<ffffffff810755d7>] kthread+0x84/0x8c
Nov 21 19:33:17 localhost kernel: [<ffffffff814e9464>] kernel_thread_helper+0x4/0x10
Nov 21 19:33:17 localhost kernel: [<ffffffff81075553>] ? __init_kthread_worker+0x37/0x37
Nov 21 19:33:17 localhost kernel: [<ffffffff814e9460>] ? gs_change+0x13/0x13
Nov 21 19:33:17 localhost kernel: ---[ end trace f0563900e2e456dc ]---
Nov 21 19:33:17 localhost kernel: IPv6: ADDRCONF(NETDEV_CHANGE): sta197: link becomes ready
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

