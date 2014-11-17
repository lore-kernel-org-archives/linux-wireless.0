Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41078 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaKQLjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 06:39:31 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5415026wid.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 03:39:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix 11b fragmentation rx
Date: Mon, 17 Nov 2014 12:27:06 +0100
Message-Id: <1416223626-10980-1-git-send-email-michal.kazior@tieto.com> (sfid-20141117_123935_303315_D39D6D6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After fragmentation reassembly was complete code
tried to dereference hdr pointer which pointed to
data of an sk_buff that has been freed.

This fixes possible paging errors and kernel
panics with fragmented rx:

 BUG: unable to handle kernel paging request at ffff880019fd5dc0
 IP: [<ffffffff8188f3a0>] ieee80211_rx_handlers+0x610/0x1f60
 PGD 2f68067 PUD 2f69067 PMD 1fd15067 PTE 8000000019fd5060
 Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
 Modules linked in: ath10k_pci ath10k_core ath
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.17.0-wl-ath+ #536
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 task: ffff88001e752620 ti: ffff88001e774000 task.ti: ffff88001e774000
 RIP: 0010:[<ffffffff8188f3a0>]  [<ffffffff8188f3a0>] ieee80211_rx_handlers+0x610/0x1f60
 RSP: 0018:ffff88001fa83978  EFLAGS: 00010206
 RAX: ffff88001a41a290 RBX: ffff88001fa83b08 RCX: ffff88001fa83b08
 RDX: 0000000000000002 RSI: ffff88001e752e70 RDI: 0000000000000296
 RBP: ffff88001fa83a30 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffff88001fa83a60
 R13: ffff88001fa839b8 R14: ffff880019eb8df8 R15: ffff880019fd5dbc
 FS:  0000000000000000(0000) GS:ffff88001fa80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff880019fd5dc0 CR3: 000000000010c000 CR4: 00000000000006e0
 Stack:
  ffff88001e752620 ffffffff82831b20 ffff88001a41a290 ffff88001fa83b08
  ffff880019fd5dd6 ffff880019eb8e10 ffff88001fa83a60 ffff88001fa839bd
  ffffffff81092bab ffff88001e777f58 ffff88001fa839d8 ffffffff810d0786
 Call Trace:
  <IRQ>
  [<ffffffff81092bab>] ? __lock_acquire+0x41b/0x1af0
  [<ffffffff810d0786>] ? is_module_text_address+0x16/0x30
  [<ffffffff81891138>] ieee80211_prepare_and_rx_handle+0x448/0xa30
  [<ffffffff818917ef>] ? ieee80211_rx+0xcf/0x8d0
  [<ffffffff81891a2d>] ieee80211_rx+0x30d/0x8d0
  [<ffffffff818917ef>] ? ieee80211_rx+0xcf/0x8d0
  [<ffffffffa001d0cc>] ath10k_process_rx+0x23c/0x340 [ath10k_core]
  [<ffffffffa001d217>] ath10k_htt_rx_h_deliver+0x47/0x90 [ath10k_core]
  [<ffffffffa001deee>] ath10k_htt_rx_in_ord_ind+0x67e/0x8f0 [ath10k_core]
  [<ffffffffa001ee7e>] ath10k_htt_txrx_compl_task+0x5de/0x770 [ath10k_core]
  [<ffffffff8109188d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff818e9245>] ? _raw_spin_unlock_bh+0x35/0x40
  [<ffffffffa005c3e8>] ? ath10k_ce_per_engine_service+0x98/0xb0 [ath10k_pci]
  [<ffffffff810565de>] ? tasklet_action+0x4e/0x130
  [<ffffffff81056674>] tasklet_action+0xe4/0x130
  [<ffffffff81056ae6>] __do_softirq+0x126/0x300
  [<ffffffff81056fd5>] irq_exit+0xb5/0xc0
  [<ffffffff818ecaf8>] do_IRQ+0x58/0xf0
  [<ffffffff818eaa72>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff81042086>] ? native_safe_halt+0x6/0x10
  [<ffffffff8100cd19>] default_idle+0x29/0xe0
  [<ffffffff8100d6ff>] arch_cpu_idle+0xf/0x20
  [<ffffffff8108cf7a>] cpu_startup_entry+0x29a/0x390
  [<ffffffff810c2723>] ? clockevents_register_device+0xe3/0x140
  [<ffffffff810346fa>] start_secondary+0x19a/0x200
 Code: 66 25 00 04 66 89 85 78 ff ff ff 0f 85 6e 07 00 00 45 85 d2 0f 85 65 07 00 00 48 8b 43 18 48 85 c0 74 08 48 83 80 f8 03 00 00 01 <41> f6 47 04 01 0f 84 5c 03 00 00 48 8b 43 08 83 80 a4 18 00 00
 RIP  [<ffffffff8188f3a0>] ieee80211_rx_handlers+0x610/0x1f60
  RSP <ffff88001fa83978>
 CR2: ffff880019fd5dc0
 ---[ end trace d48ea0fa78f20b35 ]---
 Kernel panic - not syncing: Fatal exception in interrupt
 Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
 ---[ end Kernel panic - not syncing: Fatal exception in interrupt

 (gdb) l * ieee80211_rx_handlers+0x610
 0xffffffff8188f3a0 is in ieee80211_rx_handlers (/devel/src/linux/net/mac80211/rx.c:1778).
 1773            status->rx_flags |= IEEE80211_RX_FRAGMENTED;
 1774
 1775     out:
 1776            if (rx->sta)
 1777                    rx->sta->rx_packets++;
 1778            if (is_multicast_ether_addr(hdr->addr1))
 1779                    rx->local->dot11MulticastReceivedFrameCount++;
 1780            else
 1781                    ieee80211_led_rx(rx->local);
 1782            return RX_CONTINUE;

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0f4297e..8802547 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1854,6 +1854,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	/* Complete frame has been reassembled - process it now */
 	status = IEEE80211_SKB_RXCB(rx->skb);
 	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
 
  out:
 	if (rx->sta)
-- 
1.8.5.3

