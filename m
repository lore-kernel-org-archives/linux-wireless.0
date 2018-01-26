Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59848 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbeAZSpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 13:45:25 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0B58C40A339
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jan 2018 10:45:23 -0800 (PST)
Subject: Re: ath9k, irq 16: nobody cared, 4.13.16+ kernel
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <fde2f49f-4e8f-63d8-e429-a2f15b09d4ca@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <7af4424f-7ef6-7740-7fb8-cbc075b95ddd@candelatech.com> (sfid-20180126_194537_928034_9EF0425A)
Date: Fri, 26 Jan 2018 10:45:22 -0800
MIME-Version: 1.0
In-Reply-To: <fde2f49f-4e8f-63d8-e429-a2f15b09d4ca@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 10:04 AM, Ben Greear wrote:
> Hello,
>
> I'm testing on a heavily loaded system.  It has 6 ath9k radios, each of which have
> 200 stations on them.  When I try to start some slow-speed UDP traffic on each
> virtual station, I see this splat below.  Is this just expected on a heavily
> loaded system?  Or, any ideas how to make it better (I'll investigate this irqpoll
> thing it suggests...)

Maybe a related question...  The ath9k driver has a napi budget of 512.

I added code and verified that at least sometimes it would take more than
5 jiffies in this handler.

Maybe it is a good idea to have a jiffies timeout breakout as well as a budget
to stop the while loop and exit this handler?

If so, is 5 jiffies a good number do you think?

And, from looking at the IRQ code, it seems that it will re-enable the IRQ
later even if I see the splat below, so the system should recover OK?

Thanks,
Ben


>
> [ 2833.533351] irq 16: nobody cared (try booting with the "irqpoll" option)
> [ 2833.539111] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W  O    4.13.16+ #36
> [ 2833.539112] Hardware name: Iron_Systems,Inc CS-CAD-2U-A02/X10SRL-F, BIOS 2.0b 05/02/2017
> [ 2833.539113] Call Trace:
> [ 2833.539114]  <IRQ>
> [ 2833.539119]  dump_stack+0x63/0x87
> [ 2833.539122]  __report_bad_irq+0x2e/0xc0
> [ 2833.539123]  note_interrupt+0x227/0x270
> [ 2833.539124]  handle_irq_event_percpu+0x40/0x50
> [ 2833.539126]  handle_irq_event+0x34/0x60
> [ 2833.539127]  handle_fasteoi_irq+0x78/0x140
> [ 2833.539128]  handle_irq+0x18/0x30
> [ 2833.539129]  do_IRQ+0x41/0xc0
> [ 2833.539130]  common_interrupt+0x89/0x89
> [ 2833.539133] RIP: 0010:fib_rules_lookup+0x3e/0x1a0
> [ 2833.539134] RSP: 0018:ffff88087fd03828 EFLAGS: 00000283 ORIG_RAX: ffffffffffffffac
> [ 2833.539135] RAX: 0000000000000353 RBX: ffff8807eb10c300 RCX: ffff88087fd03868
> [ 2833.539135] RDX: 0000000000000000 RSI: ffff88087fd038e0 RDI: ffff88085ab55b40
> [ 2833.539136] RBP: ffff88087fd03858 R08: 0000000000000000 R09: 0000000000000001
> [ 2833.539136] R10: ffffffff81efd500 R11: ffff88081ae6ac00 R12: ffff88085ab55b40
> [ 2833.539137] R13: ffff88087fd03868 R14: ffff88085ab55bc0 R15: ffff88087fd038e0
> [ 2833.539139]  ? fib_rules_lookup+0x2a/0x1a0
> [ 2833.539141]  __fib_lookup+0x4f/0x80
> [ 2833.539143]  ip_route_input_rcu+0xa0d/0xc20
> [ 2833.539144]  ip_route_input_noref+0x3e/0x60
> [ 2833.539147]  ? ioapic_ir_ack_level+0x29/0x30
> [ 2833.539147]  ? handle_fasteoi_irq+0xff/0x140
> [ 2833.539149]  arp_process+0x486/0x820
> [ 2833.539150]  ? do_IRQ+0x4a/0xc0
> [ 2833.539151]  ? common_interrupt+0x89/0x89
> [ 2833.539152]  arp_rcv+0x112/0x1b0
> [ 2833.539155]  __netif_receive_skb_core+0x689/0xa90
> [ 2833.539156]  __netif_receive_skb+0x13/0x60
> [ 2833.539156]  ? __netif_receive_skb+0x13/0x60
> [ 2833.539158]  netif_receive_skb_internal+0x1c6/0x440
> [ 2833.539159]  netif_receive_skb+0x17/0x80
> [ 2833.539178]  ieee80211_deliver_skb+0x165/0x1d0 [mac80211]
> [ 2833.539187]  ieee80211_rx_handlers+0xe50/0x26f0 [mac80211]
> [ 2833.539188]  ? skb_copy_bits+0x5f/0x260
> [ 2833.539189]  ? copy_skb_header+0x12/0x90
> [ 2833.539197]  ieee80211_prepare_and_rx_handle+0x638/0x1130 [mac80211]
> [ 2833.539198]  ? ioapic_ir_ack_level+0x29/0x30
> [ 2833.539206]  ieee80211_rx_napi+0x87d/0xa70 [mac80211]
> [ 2833.539210]  ath_rx_tasklet+0xa99/0x11a0 [ath9k]
> [ 2833.539213]  ath9k_tasklet+0x113/0x2e0 [ath9k]
> [ 2833.539215]  tasklet_action+0x10c/0x120
> [ 2833.539216]  __do_softirq+0xc1/0x2a0
> [ 2833.539217]  irq_exit+0x9b/0xa0
> [ 2833.539218]  do_IRQ+0x4a/0xc0
> [ 2833.539219]  common_interrupt+0x89/0x89
> [ 2833.539221] RIP: 0010:cpuidle_enter_state+0xf8/0x2a0
> [ 2833.539221] RSP: 0018:ffffc900031fbe78 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffac
> [ 2833.539222] RAX: ffff88087fd1c000 RBX: ffff88087fd25f00 RCX: 000000000000001f
> [ 2833.539223] RDX: 0000000000000000 RSI: 0000e691b77ea649 RDI: 0000000000000000
> [ 2833.539223] RBP: ffffc900031fbeb0 R08: ffffc442b282beb1 R09: 00000000000002eb
> [ 2833.539224] R10: 000000000000035c R11: ffff88087fd18ee4 R12: 0000000000000004
> [ 2833.539224] R13: 0000000000000004 R14: 0000000000000004 R15: 00000293855eb8ba
> [ 2833.539225]  </IRQ>
> [ 2833.539226]  ? cpuidle_enter_state+0xd4/0x2a0
> [ 2833.539227]  cpuidle_enter+0x12/0x20
> [ 2833.539229]  call_cpuidle+0x1e/0x40
> [ 2833.539229]  do_idle+0x17f/0x1d0
> [ 2833.539230]  cpu_startup_entry+0x5f/0x70
> [ 2833.539231]  start_secondary+0x14b/0x180
> [ 2833.539233]  secondary_startup_64+0x9f/0x9f
> [ 2833.539233] handlers:
> [ 2833.540606] [<ffffffffa038ddc0>] ath_isr [ath9k]
> [ 2833.544278] Disabling IRQ #16
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
