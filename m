Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52112 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0FYQ2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 12:28:17 -0400
Received: by gwaa18 with SMTP id a18so1404533gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 09:28:16 -0700 (PDT)
Message-ID: <4C24D926.7010806@gmail.com>
Date: Fri, 25 Jun 2010 12:28:22 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
References: <4C198EF0.5080807@gmail.com>	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com> <1277401731.25793.2391.camel@rchatre-DESK>
In-Reply-To: <1277401731.25793.2391.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> On Thu, 2010-06-24 at 10:30 -0700, Richard Farina wrote:
>   
>> There were two compat-wireless releases for 2.6.35_rc2 because Luis had 
>> asked me to test and then he changed it for the official release.  I'll 
>> use the official 2.6.35_rc2 release for the current testing so if there 
>> are any patches you wish to toss my way please base them on that.  The 
>> other option is you tell me what to do, I can run any kernel, any git 
>> snapshot, whatever you say.  Like I said, all I have to do is download 
>> something or transfer something large so it is pretty easily 
>> reproducible here so I'll test whatever you like.
>>     
>
>
> Could you please try out this patch? It is based on the latest linux-2.6
> so should apply cleanly to your latest 2.6.35 stable compat.
>
>   
I've added this patch to my system.  I'm about 5GB into a download right 
now and here are the issues. First, and relatively quickly this line 
showed up in dmesg:
[ 1589.605470] CE: hpet increased min_delta_ns to 7500 nsec

I've been carefully monitoring my system and I have loads of RAM spare.
Things have been much smoother but the system still freezes up for a few 
seconds at a time. Mind you, this is an improvement as the freezes are 
slightly less frequent and before the patch the freezes were hitting the 
120s hangcheck timer in the kernel and now they last like 20-60 seconds.

I finally managed to trigger the oops again but it does seem that it 
took much longer this time. Pasted at the bottom. (please note the 
timestamps included are accurate to show the time difference bettween 
the hpet warning and the oops).

What else can I do to provide useful information? Or do you just want to 
update the thresholds again?

Thanks,
Rick Farina

PS> The patch does look at bit odd as you change RX_LOW_WATERMARK while 
at the same time removing one of the places that uses it.  I'm sure that 
is on purpose just seems odd to me as I don't understand.

[ 4705.404568] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 14 free buffers remaining.
[ 4705.404586] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.404589] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.404591] Call Trace:
[ 4705.404593]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.404614]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.404622]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.404628]  [<ffffffffa0500cc6>] iwl_rx_handle+0x4a6/0x4c2 [iwlagn]
[ 4705.404632]  [<ffffffff8103156c>] ? __wake_up_common+0x49/0x7f
[ 4705.404639]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.404644]  [<ffffffff8170ab2f>] ? _raw_spin_unlock_irq+0x26/0x28
[ 4705.404650]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[ 4705.404653]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.404657]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[ 4705.404660]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.404664]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.404666]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.404669]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.404672]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.404675]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.404677]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.404684]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.404689]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.404692]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.404696]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.404700]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.404704]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.404707]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.404710]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.404712] Mem-Info:
[ 4705.404714] DMA per-cpu:
[ 4705.404716] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.404718] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.404719] DMA32 per-cpu:
[ 4705.404721] CPU    0: hi:  186, btch:  31 usd: 160
[ 4705.404723] CPU    1: hi:  186, btch:  31 usd: 154
[ 4705.404724] Normal per-cpu:
[ 4705.404726] CPU    0: hi:  186, btch:  31 usd: 145
[ 4705.404728] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.404732] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.404733]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.404734]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.404735]  free:6788 slab_reclaimable:9432 slab_unreclaimable:12868
[ 4705.404736]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.404742] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.404747] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.404755] DMA32 free:10748kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26600kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.404761] lowmem_reserve[]: 0 0 1010 1010
[ 4705.404768] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24864kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.404774] lowmem_reserve[]: 0 0 0 0
[ 4705.404777] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.404785] DMA32: 2440*4kB 78*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10832kB
[ 4705.404792] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.404800] 461661 total pagecache pages
[ 4705.404801] 0 pages in swap cache
[ 4705.404803] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.404804] Free swap  = 4200992kB
[ 4705.404806] Total swap = 4200992kB
[ 4705.419628] 1048560 pages RAM
[ 4705.419630] 83243 pages reserved
[ 4705.419632] 626146 pages shared
[ 4705.419633] 399708 pages non-shared
[ 4705.419637] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 5 free buffers remaining.
[ 4705.419690] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.419694] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.419696] Call Trace:
[ 4705.419698]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.419717]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.419722]  [<ffffffff810bebf8>] ? discard_slab+0x31/0x33
[ 4705.419727]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.419735]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.419742]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.419747]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.419753]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.419757]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.419761]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.419765]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.419769]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.419773]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.419776]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.419779]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.419784]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.419786]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.419794]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.419799]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.419803]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.419807]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.419811]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.419816]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.419820]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.419823]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.419825] Mem-Info:
[ 4705.419827] DMA per-cpu:
[ 4705.419830] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.419832] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.419833] DMA32 per-cpu:
[ 4705.419835] CPU    0: hi:  186, btch:  31 usd: 160
[ 4705.419838] CPU    1: hi:  186, btch:  31 usd: 155
[ 4705.419839] Normal per-cpu:
[ 4705.419841] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.419844] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.419848] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.419849]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.419850]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.419851]  free:6788 slab_reclaimable:9432 slab_unreclaimable:12851
[ 4705.419852]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.419859] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.419864] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.419874] DMA32 free:10748kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26600kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.419880] lowmem_reserve[]: 0 0 1010 1010
[ 4705.419890] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.419896] lowmem_reserve[]: 0 0 0 0
[ 4705.419901] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.419914] DMA32: 2440*4kB 78*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10832kB
[ 4705.419926] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.419939] 461661 total pagecache pages
[ 4705.419941] 0 pages in swap cache
[ 4705.419943] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.419945] Free swap  = 4200992kB
[ 4705.419946] Total swap = 4200992kB
[ 4705.435226] 1048560 pages RAM
[ 4705.435229] 83243 pages reserved
[ 4705.435230] 626151 pages shared
[ 4705.435232] 399702 pages non-shared
[ 4705.435235] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 1 free buffers remaining.
[ 4705.435289] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.435293] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.435295] Call Trace:
[ 4705.435297]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.435318]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.435331]  [<ffffffffa04cf5bb>] ? iwl_rx_statistics+0x2f5/0x325 
[iwlcore]
[ 4705.435336]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.435343]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.435349]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.435354]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.435360]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.435363]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.435367]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.435370]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.435374]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.435377]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.435379]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.435382]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.435387]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.435389]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.435396]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.435401]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.435405]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.435409]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.435414]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.435418]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.435422]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.435425]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.435426] Mem-Info:
[ 4705.435428] DMA per-cpu:
[ 4705.435430] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.435432] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.435433] DMA32 per-cpu:
[ 4705.435435] CPU    0: hi:  186, btch:  31 usd: 159
[ 4705.435437] CPU    1: hi:  186, btch:  31 usd: 150
[ 4705.435438] Normal per-cpu:
[ 4705.435440] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.435442] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.435447] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.435448]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.435449]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.435450]  free:6788 slab_reclaimable:9432 slab_unreclaimable:12851
[ 4705.435451]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.435457] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.435462] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.435470] DMA32 free:10748kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26600kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.435476] lowmem_reserve[]: 0 0 1010 1010
[ 4705.435484] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.435489] lowmem_reserve[]: 0 0 0 0
[ 4705.435492] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.435501] DMA32: 2440*4kB 81*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10856kB
[ 4705.435509] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.435517] 461661 total pagecache pages
[ 4705.435519] 0 pages in swap cache
[ 4705.435521] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.435522] Free swap  = 4200992kB
[ 4705.435523] Total swap = 4200992kB
[ 4705.450608] 1048560 pages RAM
[ 4705.450610] 83243 pages reserved
[ 4705.450611] 626155 pages shared
[ 4705.450612] 399697 pages non-shared
[ 4705.450616] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 5 free buffers remaining.
[ 4705.450675] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.450679] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.450681] Call Trace:
[ 4705.450683]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.450703]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.450709]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.450716]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.450722]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.450726]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.450733]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.450736]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.450740]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.450743]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.450747]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.450750]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.450753]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.450755]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.450761]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.450762]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.450770]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.450775]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.450780]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.450783]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.450789]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.450793]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.450797]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.450800]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.450801] Mem-Info:
[ 4705.450803] DMA per-cpu:
[ 4705.450805] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.450807] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.450808] DMA32 per-cpu:
[ 4705.450810] CPU    0: hi:  186, btch:  31 usd: 155
[ 4705.450812] CPU    1: hi:  186, btch:  31 usd: 148
[ 4705.450813] Normal per-cpu:
[ 4705.450815] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.450817] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.450821] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.450822]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.450823]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.450824]  free:6788 slab_reclaimable:9432 slab_unreclaimable:12851
[ 4705.450825]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.450831] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.450835] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.450843] DMA32 free:10748kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26600kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.450848] lowmem_reserve[]: 0 0 1010 1010
[ 4705.450855] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.450860] lowmem_reserve[]: 0 0 0 0
[ 4705.450863] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.450871] DMA32: 2440*4kB 85*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10888kB
[ 4705.450878] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.450885] 461661 total pagecache pages
[ 4705.450887] 0 pages in swap cache
[ 4705.450888] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.450890] Free swap  = 4200992kB
[ 4705.450891] Total swap = 4200992kB
[ 4705.465982] 1048560 pages RAM
[ 4705.465984] 83243 pages reserved
[ 4705.465986] 626159 pages shared
[ 4705.465987] 399693 pages non-shared
[ 4705.465990] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 4 free buffers remaining.
[ 4705.466048] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.466052] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.466054] Call Trace:
[ 4705.466056]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.466076]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.466080]  [<ffffffff810513ca>] ? queue_work+0x4b/0x55
[ 4705.466085]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.466092]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.466098]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.466103]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.466109]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.466112]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.466116]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.466119]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.466123]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.466126]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.466128]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.466131]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.466137]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.466139]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.466146]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.466150]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.466154]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.466158]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.466163]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.466168]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.466171]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.466174]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.466176] Mem-Info:
[ 4705.466178] DMA per-cpu:
[ 4705.466179] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.466181] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.466183] DMA32 per-cpu:
[ 4705.466184] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.466186] CPU    1: hi:  186, btch:  31 usd: 147
[ 4705.466188] Normal per-cpu:
[ 4705.466190] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.466192] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.466196] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.466197]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.466198]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.466199]  free:6813 slab_reclaimable:9432 slab_unreclaimable:12851
[ 4705.466200]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.466206] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.466211] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.466219] DMA32 free:10848kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26600kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.466225] lowmem_reserve[]: 0 0 1010 1010
[ 4705.466233] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.466238] lowmem_reserve[]: 0 0 0 0
[ 4705.466241] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.466250] DMA32: 2440*4kB 89*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10920kB
[ 4705.466258] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.466266] 461661 total pagecache pages
[ 4705.466268] 0 pages in swap cache
[ 4705.466270] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.466271] Free swap  = 4200992kB
[ 4705.466272] Total swap = 4200992kB
[ 4705.481398] 1048560 pages RAM
[ 4705.481400] 83243 pages reserved
[ 4705.481402] 626163 pages shared
[ 4705.481403] 399690 pages non-shared
[ 4705.481458] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.481462] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.481464] Call Trace:
[ 4705.481465]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.481483]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.481488]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.481495]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.481501]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.481506]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.481512]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.481515]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.481519]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.481522]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.481526]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.481529]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.481531]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.481534]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.481539]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.481540]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.481547]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.481551]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.481555]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.481559]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.481563]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.481567]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.481570]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.481573]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.481575] Mem-Info:
[ 4705.481577] DMA per-cpu:
[ 4705.481578] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.481580] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.481582] DMA32 per-cpu:
[ 4705.481584] CPU    0: hi:  186, btch:  31 usd: 146
[ 4705.481585] CPU    1: hi:  186, btch:  31 usd: 144
[ 4705.481587] Normal per-cpu:
[ 4705.481589] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.481591] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.481595] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.481596]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.481597]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.481598]  free:6813 slab_reclaimable:9432 slab_unreclaimable:12876
[ 4705.481599]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.481605] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.481610] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.481618] DMA32 free:10848kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26700kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.481624] lowmem_reserve[]: 0 0 1010 1010
[ 4705.481632] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.481637] lowmem_reserve[]: 0 0 0 0
[ 4705.481640] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.481649] DMA32: 2440*4kB 93*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10952kB
[ 4705.481657] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.481665] 461661 total pagecache pages
[ 4705.481666] 0 pages in swap cache
[ 4705.481668] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.481670] Free swap  = 4200992kB
[ 4705.481671] Total swap = 4200992kB
[ 4705.497155] 1048560 pages RAM
[ 4705.497157] 83243 pages reserved
[ 4705.497158] 626163 pages shared
[ 4705.497160] 399687 pages non-shared
[ 4705.497211] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.497215] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.497217] Call Trace:
[ 4705.497219]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.497238]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.497243]  [<ffffffff810513ca>] ? queue_work+0x4b/0x55
[ 4705.497248]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.497256]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.497262]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.497267]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.497274]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.497277]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.497282]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.497285]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.497289]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.497293]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.497296]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.497299]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.497304]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.497306]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.497314]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.497319]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.497323]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.497327]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.497331]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.497336]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.497340]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.497344]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.497346] Mem-Info:
[ 4705.497348] DMA per-cpu:
[ 4705.497350] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.497352] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.497354] DMA32 per-cpu:
[ 4705.497356] CPU    0: hi:  186, btch:  31 usd: 173
[ 4705.497358] CPU    1: hi:  186, btch:  31 usd: 145
[ 4705.497360] Normal per-cpu:
[ 4705.497361] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.497364] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.497368] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.497369]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.497370]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.497371]  free:6813 slab_reclaimable:9432 slab_unreclaimable:12876
[ 4705.497372]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.497379] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.497384] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.497394] DMA32 free:10848kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26700kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.497400] lowmem_reserve[]: 0 0 1010 1010
[ 4705.497410] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.497416] lowmem_reserve[]: 0 0 0 0
[ 4705.497421] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.497433] DMA32: 2451*4kB 76*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10860kB
[ 4705.497446] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.497459] 461661 total pagecache pages
[ 4705.497461] 0 pages in swap cache
[ 4705.497463] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.497465] Free swap  = 4200992kB
[ 4705.497467] Total swap = 4200992kB
[ 4705.513089] 1048560 pages RAM
[ 4705.513091] 83243 pages reserved
[ 4705.513092] 626165 pages shared
[ 4705.513094] 399682 pages non-shared
[ 4705.513153] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.513157] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.513159] Call Trace:
[ 4705.513161]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.513182]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.513187]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.513194]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.513201]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.513206]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.513213]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.513216]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.513221]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.513225]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.513229]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.513232]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.513236]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.513239]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.513244]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.513246]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.513254]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.513259]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.513263]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.513267]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.513271]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.513276]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.513280]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.513283]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.513286] Mem-Info:
[ 4705.513287] DMA per-cpu:
[ 4705.513289] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.513291] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.513293] DMA32 per-cpu:
[ 4705.513295] CPU    0: hi:  186, btch:  31 usd: 169
[ 4705.513298] CPU    1: hi:  186, btch:  31 usd: 142
[ 4705.513299] Normal per-cpu:
[ 4705.513301] CPU    0: hi:  186, btch:  31 usd: 151
[ 4705.513303] CPU    1: hi:  186, btch:  31 usd: 185
[ 4705.513308] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.513309]  active_file:153488 inactive_file:295800 isolated_file:210
[ 4705.513310]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.513311]  free:6813 slab_reclaimable:9432 slab_unreclaimable:12876
[ 4705.513312]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.513319] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.513324] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.513334] DMA32 free:10848kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909448kB unevictable:0kB isolated(anon):0kB 
isolated(file):576kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26700kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.513340] lowmem_reserve[]: 0 0 1010 1010
[ 4705.513350] Normal free:760kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273692kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.513356] lowmem_reserve[]: 0 0 0 0
[ 4705.513361] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.513374] DMA32: 2451*4kB 80*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10892kB
[ 4705.513386] Normal: 76*4kB 11*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 760kB
[ 4705.513399] 461661 total pagecache pages
[ 4705.513401] 0 pages in swap cache
[ 4705.513403] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.513405] Free swap  = 4200992kB
[ 4705.513406] Total swap = 4200992kB
[ 4705.528482] 1048560 pages RAM
[ 4705.528484] 83243 pages reserved
[ 4705.528485] 626172 pages shared
[ 4705.528487] 399630 pages non-shared
[ 4705.528586] swapper: page allocation failure. order:1, mode:0x4020
[ 4705.528590] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[ 4705.528591] Call Trace:
[ 4705.528593]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[ 4705.528611]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[ 4705.528617]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[ 4705.528624]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[ 4705.528630]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[ 4705.528635]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[ 4705.528641]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[ 4705.528644]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[ 4705.528649]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[ 4705.528652]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[ 4705.528655]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[ 4705.528658]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[ 4705.528661]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[ 4705.528664]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[ 4705.528668]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[ 4705.528670]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[ 4705.528678]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[ 4705.528682]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[ 4705.528685]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[ 4705.528688]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[ 4705.528693]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[ 4705.528699]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[ 4705.528703]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[ 4705.528706]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[ 4705.528708] Mem-Info:
[ 4705.528709] DMA per-cpu:
[ 4705.528711] CPU    0: hi:    0, btch:   1 usd:   0
[ 4705.528714] CPU    1: hi:    0, btch:   1 usd:   0
[ 4705.528715] DMA32 per-cpu:
[ 4705.528717] CPU    0: hi:  186, btch:  31 usd: 164
[ 4705.528719] CPU    1: hi:  186, btch:  31 usd: 154
[ 4705.528720] Normal per-cpu:
[ 4705.528721] CPU    0: hi:  186, btch:  31 usd: 148
[ 4705.528723] CPU    1: hi:  186, btch:  31 usd: 179
[ 4705.528728] active_anon:341531 inactive_anon:114822 isolated_anon:0
[ 4705.528729]  active_file:153488 inactive_file:295736 isolated_file:245
[ 4705.528730]  unevictable:23 dirty:14035 writeback:28555 unstable:33013
[ 4705.528731]  free:6808 slab_reclaimable:9432 slab_unreclaimable:12876
[ 4705.528732]  mapped:37668 shmem:12218 pagetables:3822 bounce:0
[ 4705.528737] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:120kB inactive_file:60kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.528741] lowmem_reserve[]: 0 2900 3910 3910
[ 4705.528749] DMA32 free:10848kB min:5924kB low:7404kB high:8884kB 
active_anon:1238044kB inactive_anon:323152kB active_file:347988kB 
inactive_file:909272kB unevictable:0kB isolated(anon):0kB 
isolated(file):716kB present:2970488kB mlocked:0kB dirty:45440kB 
writeback:92884kB mapped:8036kB shmem:14132kB slab_reclaimable:15944kB 
slab_unreclaimable:26700kB kernel_stack:104kB pagetables:3688kB 
unstable:101736kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.528754] lowmem_reserve[]: 0 0 1010 1010
[ 4705.528761] Normal free:740kB min:2060kB low:2572kB high:3088kB 
active_anon:128080kB inactive_anon:136136kB active_file:265844kB 
inactive_file:273612kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:10700kB 
writeback:21336kB mapped:142636kB shmem:34740kB slab_reclaimable:21784kB 
slab_unreclaimable:24796kB kernel_stack:2160kB pagetables:11600kB 
unstable:30316kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[ 4705.528766] lowmem_reserve[]: 0 0 0 0
[ 4705.528769] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[ 4705.528778] DMA32: 2451*4kB 88*8kB 0*16kB 0*32kB 1*64kB 1*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10956kB
[ 4705.528785] Normal: 93*4kB 0*8kB 17*16kB 3*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 740kB
[ 4705.528792] 461599 total pagecache pages
[ 4705.528793] 0 pages in swap cache
[ 4705.528795] Swap cache stats: add 0, delete 0, find 0/0
[ 4705.528796] Free swap  = 4200992kB
[ 4705.528798] Total swap = 4200992kB
[ 4705.544019] 1048560 pages RAM
[ 4705.544021] 83243 pages reserved
[ 4705.544023] 626171 pages shared
[ 4705.544024] 399657 pages non-shared

> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 0f292a2..028db74 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -613,7 +613,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  		}
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
> -		if (rxq->free_count > RX_LOW_WATERMARK)
> +		if (rxq->free_count > 8)
>  			gfp_mask |= __GFP_NOWARN;
>  
>  		if (priv->hw_params.rx_page_order > 0)
> diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
> index 113c366..396a16c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-fh.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
> @@ -426,7 +426,7 @@
>   * RX related structures and functions
>   */
>  #define RX_FREE_BUFFERS 64
> -#define RX_LOW_WATERMARK 8
> +#define RX_LOW_WATERMARK 64
>  
>  /* Size of one Rx buffer in host DRAM */
>  #define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
>
>
>
>   

