Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51963 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0FQXfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 19:35:17 -0400
Received: by vws18 with SMTP id 18so59213vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 16:35:15 -0700 (PDT)
Message-ID: <4C1AB12F.8070505@gmail.com>
Date: Thu, 17 Jun 2010 19:35:11 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
References: <4C198EF0.5080807@gmail.com>
In-Reply-To: <4C198EF0.5080807@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My dmesg is absolutely filling with stuff like this. Can someone tell me 
how to provide a more useful bug report?

Thanks,
Rick Farina

Normal free:1700kB min:2060kB low:2572kB high:3088kB 
active_anon:196252kB inactive_anon:269284kB active_file:212608kB 
inactive_file:212512kB unevictable:232kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:140kB dirty:52kB 
writeback:86380kB mapped:45604kB shmem:6688kB slab_reclaimable:17076kB 
slab_unreclaimable:18092kB kernel_stack:1320kB pagetables:4740kB 
unstable:11584kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 1*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15668kB
DMA32: 3923*4kB 3*8kB 21*16kB 20*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 16756kB
Normal: 331*4kB 12*8kB 5*16kB 1*32kB 2*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1660kB
456109 total pagecache pages
210 pages in swap cache
Swap cache stats: add 2576, delete 2366, find 88793/88820
Free swap  = 4191576kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
657041 pages shared
419080 pages non-shared
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cbb3>] iwl_rx_handle+0x2b8/0x2d1 [iwlagn]
 [<ffffffff81059679>] ? sched_clock_cpu+0xc6/0xd4
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff814e822d>] ? acpi_idle_enter_simple+0x150/0x17b
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
CPU    1: hi:  186, btch:  31 usd: 133
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 156
CPU    1: hi:  186, btch:  31 usd: 168
active_anon:310188 inactive_anon:151651 isolated_anon:0
 active_file:221724 inactive_file:221738 isolated_file:98
 unevictable:58 dirty:37 writeback:81998 unstable:9264
 free:8527 slab_reclaimable:8494 slab_unreclaimable:12301
 mapped:40138 shmem:12341 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:16780kB min:5924kB low:7404kB high:8884kB 
active_anon:1044500kB inactive_anon:337320kB active_file:674288kB 
inactive_file:674260kB unevictable:0kB isolated(anon):0kB 
isolated(file):260kB present:2970488kB mlocked:0kB dirty:96kB 
writeback:241672kB mapped:114948kB shmem:42676kB 
slab_reclaimable:16900kB slab_unreclaimable:31144kB kernel_stack:1048kB 
pagetables:10312kB unstable:25412kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:1684kB min:2060kB low:2572kB high:3088kB 
active_anon:196252kB inactive_anon:269284kB active_file:212608kB 
inactive_file:212512kB unevictable:232kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:140kB dirty:52kB 
writeback:86320kB mapped:45604kB shmem:6688kB slab_reclaimable:17076kB 
slab_unreclaimable:18052kB kernel_stack:1320kB pagetables:4740kB 
unstable:11644kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 3923*4kB 5*8kB 24*16kB 18*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 16756kB
Normal: 331*4kB 7*8kB 5*16kB 1*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1684kB
456111 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
656984 pages shared
419095 pages non-shared
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cbb3>] iwl_rx_handle+0x2b8/0x2d1 [iwlagn]
 [<ffffffff81059679>] ? sched_clock_cpu+0xc6/0xd4
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff814e822d>] ? acpi_idle_enter_simple+0x150/0x17b
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
CPU    1: hi:  186, btch:  31 usd: 132
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 156
CPU    1: hi:  186, btch:  31 usd: 168
active_anon:310188 inactive_anon:151651 isolated_anon:0
 active_file:221724 inactive_file:221738 isolated_file:98
 unevictable:58 dirty:37 writeback:81961 unstable:9301
 free:8533 slab_reclaimable:8494 slab_unreclaimable:12329
 mapped:40138 shmem:12341 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:16804kB min:5924kB low:7404kB high:8884kB 
active_anon:1044500kB inactive_anon:337320kB active_file:674288kB 
inactive_file:674260kB unevictable:0kB isolated(anon):0kB 
isolated(file):260kB present:2970488kB mlocked:0kB dirty:96kB 
writeback:241524kB mapped:114948kB shmem:42676kB 
slab_reclaimable:16900kB slab_unreclaimable:31256kB kernel_stack:1048kB 
pagetables:10312kB unstable:25560kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:1684kB min:2060kB low:2572kB high:3088kB 
active_anon:196252kB inactive_anon:269284kB active_file:212608kB 
inactive_file:212512kB unevictable:232kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:140kB dirty:52kB 
writeback:86320kB mapped:45604kB shmem:6688kB slab_reclaimable:17076kB 
slab_unreclaimable:18052kB kernel_stack:1320kB pagetables:4740kB 
unstable:11644kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 3923*4kB 15*8kB 28*16kB 18*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 16900kB
Normal: 331*4kB 23*8kB 5*16kB 1*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1812kB
456111 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
656934 pages shared
419028 pages non-shared
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff814e822d>] ? acpi_idle_enter_simple+0x150/0x17b
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
CPU    1: hi:  186, btch:  31 usd: 132
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 156
CPU    1: hi:  186, btch:  31 usd: 168
active_anon:310188 inactive_anon:151651 isolated_anon:0
 active_file:221724 inactive_file:221738 isolated_file:98
 unevictable:58 dirty:37 writeback:81961 unstable:9301
 free:8533 slab_reclaimable:8494 slab_unreclaimable:12329
 mapped:40138 shmem:12341 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:16804kB min:5924kB low:7404kB high:8884kB 
active_anon:1044500kB inactive_anon:337320kB active_file:674288kB 
inactive_file:674260kB unevictable:0kB isolated(anon):0kB 
isolated(file):260kB present:2970488kB mlocked:0kB dirty:96kB 
writeback:241524kB mapped:114948kB shmem:42676kB 
slab_reclaimable:16900kB slab_unreclaimable:31256kB kernel_stack:1048kB 
pagetables:10312kB unstable:25560kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:1684kB min:2060kB low:2572kB high:3088kB 
active_anon:196252kB inactive_anon:269284kB active_file:212608kB 
inactive_file:212512kB unevictable:232kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:140kB dirty:52kB 
writeback:86320kB mapped:45604kB shmem:6688kB slab_reclaimable:17076kB 
slab_unreclaimable:18052kB kernel_stack:1320kB pagetables:4740kB 
unstable:11644kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 3923*4kB 15*8kB 28*16kB 18*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 16900kB
Normal: 331*4kB 23*8kB 5*16kB 1*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1812kB
456111 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
656934 pages shared
419028 pages non-shared
__alloc_pages_slowpath: 7 callbacks suppressed
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff814e7dec>] ? acpi_idle_enter_c1+0xdc/0xf7
 [<ffffffff814e7dce>] ? acpi_idle_enter_c1+0xbe/0xf7
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
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 156
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 119
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 24*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17620kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654200 pages shared
418328 pages non-shared
net_ratelimit: 35 callbacks suppressed
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 4 free 
buffers remaining.
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cbb3>] iwl_rx_handle+0x2b8/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff814e7dec>] ? acpi_idle_enter_c1+0xdc/0xf7
 [<ffffffff814e7dce>] ? acpi_idle_enter_c1+0xbe/0xf7
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
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 156
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 119
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 25*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17628kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654200 pages shared
418325 pages non-shared
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 4 free 
buffers remaining.
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 152
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 25*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17628kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418327 pages non-shared
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 1 free 
buffers remaining.
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 152
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 27*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17644kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418323 pages non-shared
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 6 free 
buffers remaining.
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 152
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 29*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17660kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418319 pages non-shared
iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 6 free 
buffers remaining.
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 152
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 30*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17668kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418317 pages non-shared
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 152
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 20*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17588kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418337 pages non-shared
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 151
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 23*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17612kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418332 pages non-shared
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffff8105175a>] ? queue_work+0x4b/0x55
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  57
CPU    1: hi:  186, btch:  31 usd: 151
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 23*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17612kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654204 pages shared
418332 pages non-shared
syslog-ng: page allocation failure. order:1, mode:0x4020
Pid: 5830, comm: syslog-ng Not tainted 2.6.34-pentoo #5
Call Trace:
 <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
 [<ffffffffa04881e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
 [<ffffffffa0487bd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
 [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
 [<ffffffffa04884f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
 [<ffffffffa047cb95>] iwl_rx_handle+0x29a/0x2d1 [iwlagn]
 [<ffffffffa047d2c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
 [<ffffffff81044f58>] tasklet_action+0x6f/0xba
 [<ffffffff81045998>] __do_softirq+0x91/0x119
 [<ffffffff8100384c>] call_softirq+0x1c/0x28
 [<ffffffff8100550b>] do_softirq+0x33/0x68
 [<ffffffff81045695>] irq_exit+0x36/0x87
 [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
 [<ffffffff8176c253>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8100330e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8176be39>] ? _raw_spin_unlock_irq+0x10/0x28
 [<ffffffff81037326>] finish_task_switch+0x45/0xae
 [<ffffffff81769e8a>] schedule+0x76f/0x842
 [<ffffffff8176ad50>] schedule_hrtimeout_range+0xeb/0x132
 [<ffffffff81057346>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81057e68>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff810df1b2>] poll_schedule_timeout+0x43/0x5f
 [<ffffffff810df5b8>] do_sys_poll+0x35a/0x3e5
 [<ffffffff810e02d7>] ? __pollwait+0x0/0xc7
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff810e039e>] ? pollwake+0x0/0x52
 [<ffffffff81491fb3>] ? tty_ldisc_deref+0x9/0xb
 [<ffffffff8148c609>] ? tty_write+0x210/0x22c
 [<ffffffff8105c8fe>] ? ktime_get_ts+0xad/0xba
 [<ffffffff810df154>] ? poll_select_set_timeout+0x61/0x7c
 [<ffffffff810df7d7>] sys_poll+0x50/0xba
 [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  55
CPU    1: hi:  186, btch:  31 usd: 151
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  53
CPU    1: hi:  186, btch:  31 usd: 120
active_anon:310769 inactive_anon:151667 isolated_anon:0
 active_file:221427 inactive_file:221406 isolated_file:196
 unevictable:58 dirty:57 writeback:78685 unstable:12577
 free:8938 slab_reclaimable:8493 slab_unreclaimable:12282
 mapped:40115 shmem:12921 pagetables:3763 bounce:0
DMA free:15644kB min:28kB low:32kB high:40kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:180kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2900 3910 3910
DMA32 free:17540kB min:5924kB low:7404kB high:8884kB 
active_anon:1046340kB inactive_anon:337384kB active_file:673368kB 
inactive_file:673268kB unevictable:0kB isolated(anon):0kB 
isolated(file):524kB present:2970488kB mlocked:0kB dirty:152kB 
writeback:231716kB mapped:114856kB shmem:44512kB 
slab_reclaimable:16896kB slab_unreclaimable:31052kB kernel_stack:1048kB 
pagetables:10312kB unstable:35368kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1010 1010
Normal free:2568kB min:2060kB low:2572kB high:3088kB 
active_anon:196736kB inactive_anon:269284kB active_file:212340kB 
inactive_file:212176kB unevictable:232kB isolated(anon):0kB 
isolated(file):260kB present:1034240kB mlocked:140kB dirty:76kB 
writeback:83024kB mapped:45604kB shmem:7172kB slab_reclaimable:17076kB 
slab_unreclaimable:18068kB kernel_stack:1320kB pagetables:4740kB 
unstable:14940kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15644kB
DMA32: 4125*4kB 25*8kB 8*16kB 19*32kB 3*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 17628kB
Normal: 574*4kB 4*8kB 5*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 2568kB
456115 total pagecache pages
224 pages in swap cache
Swap cache stats: add 2592, delete 2368, find 88793/88822
Free swap  = 4191584kB
Total swap = 4200992kB
1048560 pages RAM
83434 pages reserved
654203 pages shared
418328 pages non-shared
net_ratelimit: 4701 callbacks suppressed
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state


Richard Farina wrote:
> The repeated line appears ad infinitum filling my dmesg buffer.  This 
> of hangcheck timer seem to trigger with every large file transfer on 
> my intel 5100.  What would you like me to do to provide a more useful 
> output as this is currently extremely easy to reproduce.  Kernel 
> 2.6.34 using compat-wireless stable 2.6.35-rc2
>
> Thanks,
> Rick Farina
>
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> phy0: failed to reallocate TX buffer
> net_ratelimit: 22 callbacks suppressed
> __alloc_pages_slowpath: 3799 callbacks suppressed
> swapper: page allocation failure. order:1, mode:0x4020
> Pid: 0, comm: swapper Not tainted 2.6.34-pentoo #5
> Call Trace:
> <IRQ>  [<ffffffff8109cb74>] __alloc_pages_nodemask+0x571/0x5b9
> [<ffffffff816732e9>] ? skb_release_data+0xc4/0xc9
> [<ffffffffa04701e4>] iwlagn_rx_allocate+0x98/0x25a [iwlagn]
> [<ffffffffa046fbd3>] ? iwlagn_rx_reply_rx+0x332/0x34d [iwlagn]
> [<ffffffff814739c5>] ? is_swiotlb_buffer+0x2e/0x3b
> [<ffffffffa04704f7>] iwlagn_rx_replenish_now+0x16/0x23 [iwlagn]
> [<ffffffffa0464bb3>] iwl_rx_handle+0x2b8/0x2d1 [iwlagn]
> [<ffffffffa04652c0>] iwl_irq_tasklet+0x2f7/0x412 [iwlagn]
> [<ffffffff81044f58>] tasklet_action+0x6f/0xba
> [<ffffffff81045998>] __do_softirq+0x91/0x119
> [<ffffffff8100384c>] call_softirq+0x1c/0x28
> [<ffffffff8100550b>] do_softirq+0x33/0x68
> [<ffffffff81045695>] irq_exit+0x36/0x87
> [<ffffffff81004bef>] do_IRQ+0xa7/0xbe
> [<ffffffff8176c253>] ret_from_intr+0x0/0xa
> <EOI>  [<ffffffff81058ca9>] ? __atomic_notifier_call_chain+0x28/0x4c
> [<ffffffff814e822d>] ? acpi_idle_enter_simple+0x150/0x17b
> [<ffffffff814e8223>] ? acpi_idle_enter_simple+0x146/0x17b
> [<ffffffff816407cc>] cpuidle_idle_call+0x8b/0xc3
> [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
> [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
> [<ffffffff8174a8e1>] rest_init+0xb5/0xba
> [<ffffffff81cc1b5c>] start_kernel+0x3f7/0x402
> [<ffffffff81cc10b6>] x86_64_start_reservations+0xb3/0xb7
> [<ffffffff81cc119a>] x86_64_start_kernel+0xe0/0xe7
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> CPU    1: hi:    0, btch:   1 usd:   0
> DMA32 per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 156
> CPU    1: hi:  186, btch:  31 usd: 156
> Normal per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 155
> CPU    1: hi:  186, btch:  31 usd: 162
> active_anon:324509 inactive_anon:110799 isolated_anon:0
> active_file:223980 inactive_file:241231 isolated_file:270
> unevictable:23 dirty:95383 writeback:565 unstable:41418
> free:7201 slab_reclaimable:8226 slab_unreclaimable:18924
> mapped:32967 shmem:11570 pagetables:3468 bounce:0
> DMA free:15636kB min:28kB low:32kB high:40kB active_anon:52kB 
> inactive_anon:128kB active_file:0kB inactive_file:0kB unevictable:0kB 
> isolated(anon):0kB isolated(file):0kB present:15708kB mlocked:0kB 
> dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
> slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB 
> bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 2900 3910 3910
> DMA32 free:11032kB min:5924kB low:7404kB high:8884kB 
> active_anon:1148572kB inactive_anon:292840kB active_file:602436kB 
> inactive_file:671388kB unevictable:0kB isolated(anon):0kB 
> isolated(file):136kB present:2970488kB mlocked:0kB dirty:270116kB 
> writeback:1904kB mapped:102852kB shmem:14292kB 
> slab_reclaimable:14856kB slab_unreclaimable:46416kB kernel_stack:296kB 
> pagetables:3980kB unstable:109116kB bounce:0kB writeback_tmp:0kB 
> pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 1010 1010
> Normal free:2136kB min:2060kB low:2572kB high:3088kB 
> active_anon:149412kB inactive_anon:150228kB active_file:293484kB 
> inactive_file:293536kB unevictable:92kB isolated(anon):0kB 
> isolated(file):944kB present:1034240kB mlocked:0kB dirty:111416kB 
> writeback:356kB mapped:29016kB shmem:31988kB slab_reclaimable:18048kB 
> slab_unreclaimable:29272kB kernel_stack:1904kB pagetables:9892kB 
> unstable:56556kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
> all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> DMA: 3*4kB 1*8kB 2*16kB 2*32kB 3*64kB 0*128kB 2*256kB 1*512kB 2*1024kB 
> 2*2048kB 2*4096kB = 15668kB
> DMA32: 2480*4kB 121*8kB 2*16kB 2*32kB 0*64kB 1*128kB 0*256kB 0*512kB 
> 0*1024kB 0*2048kB 0*4096kB = 11112kB
> Normal: 442*4kB 34*8kB 2*16kB 0*32kB 1*64kB 0*128kB 0*256kB 0*512kB 
> 0*1024kB 0*2048kB 0*4096kB = 2136kB
> 477072 total pagecache pages
> 125 pages in swap cache
> Swap cache stats: add 584, delete 459, find 25/46
> Free swap  = 4199436kB
> Total swap = 4200992kB
> 1048560 pages RAM
> 83434 pages reserved
> 612955 pages shared
> 380169 pages non-shared
> iwlagn 0000:02:00.0: Failed to alloc_pages with GFP_ATOMIC. Only 0 
> free buffers remaining.
>
>

