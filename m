Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40390 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0FQDEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 23:04:35 -0400
Received: by gwj15 with SMTP id 15so4556970gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 20:04:34 -0700 (PDT)
Message-ID: <4C198EF0.5080807@gmail.com>
Date: Wed, 16 Jun 2010 22:56:48 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The repeated line appears ad infinitum filling my dmesg buffer.  This of 
hangcheck timer seem to trigger with every large file transfer on my 
intel 5100.  What would you like me to do to provide a more useful 
output as this is currently extremely easy to reproduce.  Kernel 2.6.34 
using compat-wireless stable 2.6.35-rc2

Thanks,
Rick Farina

phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
phy0: failed to reallocate TX buffer
net_ratelimit: 22 callbacks suppressed
__alloc_pages_slowpath: 3799 callbacks suppressed
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
 [<ffffffffa04701e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa046fbd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04704f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa0464bb3>] iwl_rx_handle+0x2b8/0x2d1 [iwlagn]
 [<ffffffffa04652c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff81058ca9>] ? __atomic_notifier_call_chain+0x28/0x4c
 [<ffffffff814e822d>] ? acpi_idle_enter_simple+0x150/0x17b
 [<ffffffff814e8223>] ? acpi_idle_enter_simple+0x146/0x17b
 [<ffffffff816407cc>] cpuidle_idle_call+0x8b/0xc3
 [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
 [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff8174a8e1>] rest_init+0xb5/0xba
 [<ffffffff81cc1b5c>] start_kernel+0x3f7/0x402
 [<ffffffff81cc10b6>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff81cc119a>] x86_64_start_kernel+0xe0/0xe7
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 156
CPU    1: hi:  186, btch:  31 usd: 156
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 155
CPU    1: hi:  186, btch:  31 usd: 162
active_anon:324509 inactive_anon:110799 isolated_anon:0
 active_file:223980 inactive_file:241231 isolated_file:270
 unevictable:23 dirty:95383 writeback:565 unstable:41418
 free:7201 slab_reclaimable:8226 slab_unreclaimable:18924
 mapped:32967 shmem:11570 pagetables:3468 bounce:0
DMA free:15636kB min:28kB low:32kB high:40kB active_anon:52kB 
inactive_anon:128kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:11032kB min:5924kB low:7404kB high:8884kB 
active_anon:1148572kB inactive_anon:292840kB active_file:602436kB 
inactive_file:671388kB unevictable:0kB isolated(anon):0kB 
isolated(file):136kB present:2970488kB mlocked:0kB dirty:270116kB 
writeback:1904kB mapped:102852kB shmem:14292kB slab_reclaimable:14856kB 
slab_unreclaimable:46416kB kernel_stack:296kB pagetables:3980kB 
unstable:109116kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2136kB min:2060kB low:2572kB high:3088kB 
active_anon:149412kB inactive_anon:150228kB active_file:293484kB 
inactive_file:293536kB unevictable:92kB isolated(anon):0kB 
isolated(file):944kB present:1034240kB mlocked:0kB dirty:111416kB 
writeback:356kB mapped:29016kB shmem:31988kB slab_reclaimable:18048kB 
slab_unreclaimable:29272kB kernel_stack:1904kB pagetables:9892kB 
unstable:56556kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 3*4kB 1*8kB 2*16kB 2*32kB 3*64kB 0*128kB 2*256kB 1*512kB 2*1024kB 
2*2048kB 2*4096kB = 15668kB
DMA32: 2480*4kB 121*8kB 2*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 11112kB
Normal: 442*4kB 34*8kB 2*16kB 0*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2136kB
477072 total pagecache pages
125 pages in swap cache
Swap cache stats: add 584, delete 459, find 25/46
Free swap  = 4199436kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
612955 pages shared
380169 pages non-shared
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 0 free 
buffers remaining.

