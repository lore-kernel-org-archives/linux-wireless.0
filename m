Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47576 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1EMUG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 16:06:29 -0400
Received: by iyb14 with SMTP id 14so2364531iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 13:06:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 May 2011 00:06:29 +0400
Message-ID: <BANLkTi=9MWn8EWKD0-nFawNnfyEyMDT9sQ@mail.gmail.com> (sfid-20110513_220633_024101_4A0CFA55)
Subject: [Regression] Kernel panic with ath9k
From: cyberGn0m <cy6ergn0m@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody

I've just build compat-wireless-2011-05-11 and facing kernel painc
with ath9k driver with kernel 2.6.33-7. Here is kernel backtrace


May 13 02:43:53 cgmachine kernel: Call Trace:
May 13 02:43:53 cgmachine kernel: <IRQ> [<ffffffff810e45b3>]
__alloc_pages_nodemask+0x573/0x6c0
May 13 02:43:53 cgmachine kernel: [<ffffffff81113dfb>]
alloc_pages_current+0x7b/0xe0
 May 13 02:43:53 cgmachine kernel: [<ffffffff8111b527>] new_slab+0x2f7/0x310
May 13 02:43:53 cgmachine kernel: [<ffffffff8111d6de>] __slab_alloc+0x1be/0x460
May 13 02:43:53 cgmachine kernel: [<ffffffffa021e039>] ?
ath_rxbuf_alloc+0x39/0xc0 [ath]
 May 13 02:43:53 cgmachine kernel: [<ffffffff8111f3fd>]
__kmalloc_node_track_caller+0xbd/0x190
May 13 02:43:53 cgmachine kernel: [<ffffffffa021e039>] ?
ath_rxbuf_alloc+0x39/0xc0 [ath]
May 13 02:43:53 cgmachine kernel: [<ffffffff813055f0>] __alloc_skb+0x80/0x190
 May 13 02:43:53 cgmachine kernel: [<ffffffffa021e039>]
ath_rxbuf_alloc+0x39/0xc0 [ath]
May 13 02:43:53 cgmachine kernel: [<ffffffffa0e92d28>]
ath_rx_tasklet+0x2b8/0x680 [ath9k]
May 13 02:43:53 cgmachine kernel: [<ffffffff81203c00>] ?
swiotlb_map_page+0x0/0xf0
 May 13 02:43:53 cgmachine kernel: [<ffffffffa0e91149>]
ath9k_tasklet+0xf9/0x130 [ath9k]
May 13 02:43:53 cgmachine kernel: [<ffffffff8105ceb5>] tasklet_action+0xd5/0xe0
May 13 02:43:53 cgmachine kernel: [<ffffffffa0e8f76f>] ?
ath_isr+0x12f/0x190 [ath9k]
 May 13 02:43:53 cgmachine kernel: [<ffffffff8105e3c9>] __do_softirq+0xb9/0x1f0
May 13 02:43:53 cgmachine kernel: [<ffffffff8100af5c>] call_softirq+0x1c/0x30
May 13 02:43:53 cgmachine kernel: [<ffffffff8100cc25>] do_softirq+0x65/0xa0
 May 13 02:43:53 cgmachine kernel: [<ffffffff8105e265>] irq_exit+0x85/0x90
May 13 02:43:53 cgmachine kernel: [<ffffffff8100c175>] do_IRQ+0x75/0xf0
May 13 02:43:53 cgmachine kernel: [<ffffffff813ba613>] ret_from_intr+0x0/0x11
 May 13 02:43:53 cgmachine kernel: <EOI> [<ffffffffa008183c>] ?
acpi_idle_enter_simple+0x117/0x14b [processor]
May 13 02:43:53 cgmachine kernel: [<ffffffffa0081835>] ?
acpi_idle_enter_simple+0x110/0x14b [processor]
 May 13 02:43:53 cgmachine kernel: [<ffffffff812f21a7>]
cpuidle_idle_call+0xa7/0x140
May 13 02:43:53 cgmachine kernel: [<ffffffff81008e23>] cpu_idle+0xb3/0x110
May 13 02:43:53 cgmachine kernel: [<ffffffff813b239f>]
start_secondary+0x1f3/0x236


Then I've build compat-wireless-2010-06-05 and it works fine so it's regression.

 -- CG
