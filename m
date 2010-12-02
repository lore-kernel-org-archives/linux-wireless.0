Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60701 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab0LBXxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:53:51 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oB2NrmuT014520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 2 Dec 2010 15:53:49 -0800
Message-ID: <4CF8318C.3040407@candelatech.com>
Date: Thu, 02 Dec 2010 15:53:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  Crash in ieee80211_rx on module remove.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a new one.  Happened on 'rmmod ath9k', had maybe 80
STAs configured.

(gdb) l *(ieee80211_rx+0x781)
0x147cb is in ieee80211_rx (/home/greearb/git/linux.wireless-testing/arch/x86/include/asm/processor.h:837).
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
(gdb)


BUG: unable to handle kernel paging request at 00100100
IP: [<f91a87a7>] ieee80211_rx+0x781/0x826 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/ieee80211/wiphy0/index
Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ar]

Pid: 5, comm: kworker/u:0 Tainted: P            2.6.37-rc4-wl+ #54 PDSBM/PDSBM
EIP: 0060:[<f91a87a7>] EFLAGS: 00010246 CPU: 1
EIP is at ieee80211_rx+0x781/0x826 [mac80211]
EAX: 00000000 EBX: 00100100 ECX: e04a98bc EDX: 00000003
ESI: e04aa560 EDI: f50a9e5c EBP: f50a9e6c ESP: f50a9e04
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:0 (pid: 5, ti=f50a8000 task=f506a9c0 task.ti=f507e000)
Stack:
  00000002 00000001 00000000 f91a8124 f8e22025 00000020 f5002e00 e0f68000
  f8f7ae44 f3448c34 dcbf3500 dc898040 dc89804a f4a03700 f3448460 e04a9540
  00000000 00000000 00000000 00000010 00000000 00000000 00100100 dcbf3500
Call Trace:
  [<f91a8124>] ? ieee80211_rx+0xfe/0x826 [mac80211]
  [<f8e22025>] ? ath_rxbuf_alloc+0x25/0x7c [ath]
  [<f8f6cf3e>] ? ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
  [<f8f6e883>] ? ath_rx_tasklet+0x12dd/0x1377 [ath9k]
  [<f8f69a29>] ? ath9k_ioread32+0x25/0x5b [ath9k]
  [<7845a68d>] ? trace_hardirqs_on+0xb/0xd
  [<f8f6c921>] ? ath9k_tasklet+0x98/0x127 [ath9k]
  [<7843bba5>] ? tasklet_action+0x88/0xe3
  [<7843c121>] ? __do_softirq+0x85/0x142
  [<7843c09c>] ? __do_softirq+0x0/0x142
  <IRQ>
  [<7843bf43>] ? irq_exit+0x35/0x69
  [<78404245>] ? do_IRQ+0x8e/0xa2
  [<784036ae>] ? common_interrupt+0x2e/0x40
  [<784b007b>] ? hugetlb_change_protection+0x12b/0x137
  [<784b6a9b>] ? kfree+0xd2/0xde
  [<786ed1b0>] ? skb_release_data+0x89/0x8d
  [<786ed1b0>] ? skb_release_data+0x89/0x8d
  [<786ed1b0>] ? skb_release_data+0x89/0x8d
  [<786ecea6>] ? __kfree_skb+0x12/0x6d
  [<786ecf57>] ? kfree_skb+0x2a/0x2c
  [<f91a1e57>] ? ieee80211_iface_work+0x23a/0x282 [mac80211]
  [<78446fd4>] ? process_one_work+0x1af/0x2bf
  [<78446f63>] ? process_one_work+0x13e/0x2bf
  [<f91a1c1d>] ? ieee80211_iface_work+0x0/0x282 [mac80211]
  [<78448722>] ? worker_thread+0xf9/0x1bf
  [<78448629>] ? worker_thread+0x0/0x1bf
  [<7844b252>] ? kthread+0x62/0x67
  [<7844b1f0>] ? kthread+0x0/0x67
  [<784036c6>] ? kernel_thread_helper+0x6/0x1a
Code: ff 8b 55 c0 31 c9 89 75 d4 89 45 d8 8d 45 cc e8 61 ef ff ff 89 de 8b 03 89 45 f0 8b 1f e8 96 0c 2a 7f 85 c0 74 05 e8 57 d0 ff ff <8b> 03 0f 18 0
EIP: [<f91a87a7>] ieee80211_rx+0x781/0x826 [mac80211] SS:ESP 0068:f50a9e04
CR2: 0000000000100100
---[ end trace d95cac017068c370 ]---
sta32: no IPv6 routers present

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

