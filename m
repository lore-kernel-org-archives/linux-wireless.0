Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39980 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0F0ROm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 13:14:42 -0400
Received: by vws19 with SMTP id 19so185234vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jun 2010 10:14:41 -0700 (PDT)
Message-ID: <4C278704.5040604@gmail.com>
Date: Sun, 27 Jun 2010 13:14:44 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
References: <4C198EF0.5080807@gmail.com>	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>	 <1277401731.25793.2391.camel@rchatre-DESK>  <4C24D926.7010806@gmail.com> <1277492229.13673.1297.camel@rchatre-DESK>
In-Reply-To: <1277492229.13673.1297.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> On Fri, 2010-06-25 at 09:28 -0700, Richard Farina wrote:
>   
>> reinette chatre wrote:
>>     
>>> On Thu, 2010-06-24 at 10:30 -0700, Richard Farina wrote:
>>>       
>
>   
>> I've added this patch to my system.  I'm about 5GB into a download right
>> now and here are the issues. First, and relatively quickly this line
>> showed up in dmesg:
>> [ 1589.605470] CE: hpet increased min_delta_ns to 7500 nsec
>>     
>
> I googled a bit for this string and found a few mentions where it is
> connected to system hangs. I do not know if you are running into the
> same issue as these people (did not spend much time reading through all
> the bug reports), but I did notice that sometimes the people were able
> to work around the issue by booting with a different clock source (eg.
> clocksource=jiffies) or disabling hpet (eg. hpet=disable). I am very
> unfamiliar with this aspect so if this is giving you issues I'd propose
> you go to lkml or kernel.org bugzilla.
>
>   
>> I've been carefully monitoring my system and I have loads of RAM spare.
>> Things have been much smoother but the system still freezes up for a few
>> seconds at a time. Mind you, this is an improvement as the freezes are
>> slightly less frequent and before the patch the freezes were hitting the
>> 120s hangcheck timer in the kernel and now they last like 20-60 seconds.
>>
>> I finally managed to trigger the oops again but it does seem that it
>> took much longer this time. Pasted at the bottom. (please note the
>> timestamps included are accurate to show the time difference bettween
>> the hpet warning and the oops).
>>     
>
> They seem pretty far apart so may not be related ...
>
>   
>> What else can I do to provide useful information? Or do you just want to
>> update the thresholds again?
>>     
>
> Sure ... let's try that. Patch is below. I also made things less noisy
> when it does fail in atomic.
>
>   
>> Thanks,
>> Rick Farina
>>
>> PS> The patch does look at bit odd as you change RX_LOW_WATERMARK while
>> at the same time removing one of the places that uses it.  I'm sure that
>> is on purpose just seems odd to me as I don't understand.
>>     
>
> That was on purpose. Since I increased the watermark I did not want to
> increase the threshold used to print warnings to the user also. That is
> why I just made that a hard 8 so that if memory allocation fails we will
> only start seeing the dumps when we are down to 8 buffers and not the
> new high watermark.
>
>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++--
>  drivers/net/wireless/iwlwifi/iwl-fh.h      |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 0f292a2..2815ee7 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -613,7 +613,8 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  		}
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
> -		if (rxq->free_count > RX_LOW_WATERMARK)
> +		if ((priority == GFP_ATOMIC) ||
> +		    (rxq->free_count > RX_LOW_WATERMARK / 4))
>  			gfp_mask |= __GFP_NOWARN;
>  
>  		if (priv->hw_params.rx_page_order > 0)
> @@ -627,7 +628,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  					       "order: %d\n",
>  					       priv->hw_params.rx_page_order);
>  
> -			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
> +			if ((rxq->free_count <= RX_LOW_WATERMARK / 4) &&
>  			    net_ratelimit())
>  				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
>  					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
> diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
> index 113c366..431bc58 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-fh.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
> @@ -426,7 +426,7 @@
>   * RX related structures and functions
>   */
>  #define RX_FREE_BUFFERS 64
> -#define RX_LOW_WATERMARK 8
> +#define RX_LOW_WATERMARK 128
>  
>  /* Size of one Rx buffer in host DRAM */
>  #define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
>   
With the new patch it looks like this, happens within a few minutes (3?) 
of a high speed sustained transfer. (trimmed a little because I didn't 
have that much scrollback). Again, still have plenty of RAM.

Thanks,
Rick Farina

evictable:50336kB isolated(anon):0kB isolated(file):128kB 
present:2970488kB mlocked:50336kB dirty:35312kB writeback:93432kB 
mapped:86316kB shmem:17556kB slab_reclaimable:67744kB 
slab_unreclaimable:20304kB kernel_stack:224kB pagetables:4172kB 
unstable:4600kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180257.074486] lowmem_reserve[]: 0 0 1010 1010
[180257.074493] Normal free:1976kB min:2060kB low:2572kB high:3088kB 
active_anon:61492kB inactive_anon:166324kB active_file:316828kB 
inactive_file:319508kB unevictable:92kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:0kB dirty:8524kB 
writeback:48840kB mapped:60748kB shmem:42964kB slab_reclaimable:29560kB 
slab_unreclaimable:22872kB kernel_stack:2024kB pagetables:10856kB 
unstable:4084kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180257.074499] lowmem_reserve[]: 0 0 0 0
[180257.074502] DMA: 3*4kB 2*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15660kB
[180257.074511] DMA32: 3613*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 15516kB
[180257.074519] Normal: 408*4kB 9*8kB 3*16kB 1*32kB 0*64kB 0*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2040kB
[180257.074527] 449853 total pagecache pages
[180257.074529] 760 pages in swap cache
[180257.074531] Swap cache stats: add 25204, delete 24444, find 
4822239/4822528
[180257.074533] Free swap  = 4189356kB
[180257.074534] Total swap = 4200992kB
[180257.090318] 1048560 pages RAM
[180257.090320] 83243 pages reserved
[180257.090322] 734560 pages shared
[180257.090324] 288465 pages non-shared
[180257.090410] swapper: page allocation failure. order:1, mode:0x4020
[180257.090414] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[180257.090416] Call Trace:
[180257.090418]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180257.090437]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180257.090445]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180257.090451]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180257.090455]  [<ffffffff81030c8b>] ? enqueue_task+0x5a/0x65
[180257.090462]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180257.090468]  [<ffffffff8170ab2f>] ? _raw_spin_unlock_irq+0x26/0x28
[180257.090472]  [<ffffffff81049fe0>] ? run_timer_softirq+0x1d5/0x1e4
[180257.090475]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180257.090479]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180257.090483]  [<ffffffff8105fa23>] ? tick_program_event+0x25/0x27
[180257.090487]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180257.090490]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180257.090492]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180257.090496]  [<ffffffff81019d00>] smp_apic_timer_interrupt+0x88/0x96
[180257.090500]  [<ffffffff81003313>] apic_timer_interrupt+0x13/0x20
[180257.090502]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[180257.090509]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[180257.090513]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[180257.090517]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[180257.090520]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180257.090524]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[180257.090529]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[180257.090532]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[180257.090535]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[180257.090537] Mem-Info:
[180257.090539] DMA per-cpu:
[180257.090540] CPU    0: hi:    0, btch:   1 usd:   0
[180257.090542] CPU    1: hi:    0, btch:   1 usd:   0
[180257.090544] DMA32 per-cpu:
[180257.090546] CPU    0: hi:  186, btch:  31 usd:  86
[180257.090548] CPU    1: hi:  186, btch:  31 usd:  71
[180257.090549] Normal per-cpu:
[180257.090551] CPU    0: hi:  186, btch:  31 usd:  40
[180257.090553] CPU    1: hi:  186, btch:  31 usd:  82
[180257.090557] active_anon:309754 inactive_anon:135428 isolated_anon:0
[180257.090558]  active_file:210746 inactive_file:223119 isolated_file:65
[180257.090559]  unevictable:12607 dirty:10959 writeback:35568 unstable:2171
[180257.090560]  free:8276 slab_reclaimable:24326 slab_unreclaimable:10796
[180257.090561]  mapped:36766 shmem:15130 pagetables:3757 bounce:0
[180257.090567] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180257.090572] lowmem_reserve[]: 0 2900 3910 3910
[180257.090580] DMA32 free:15484kB min:5924kB low:7404kB high:8884kB 
active_anon:1177524kB inactive_anon:375388kB active_file:525980kB 
inactive_file:572964kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:35312kB 
writeback:93432kB mapped:86316kB shmem:17556kB slab_reclaimable:67744kB 
slab_unreclaimable:20304kB kernel_stack:224kB pagetables:4172kB 
unstable:4600kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180257.090586] lowmem_reserve[]: 0 0 1010 1010
[180257.090594] Normal free:1976kB min:2060kB low:2572kB high:3088kB 
active_anon:61492kB inactive_anon:166324kB active_file:316828kB 
inactive_file:319508kB unevictable:92kB isolated(anon):0kB 
isolated(file):132kB present:1034240kB mlocked:0kB dirty:8524kB 
writeback:48840kB mapped:60748kB shmem:42964kB slab_reclaimable:29560kB 
slab_unreclaimable:22872kB kernel_stack:2024kB pagetables:10856kB 
unstable:4084kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180257.090599] lowmem_reserve[]: 0 0 0 0
[180257.090602] DMA: 3*4kB 2*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15660kB
[180257.090611] DMA32: 3613*4kB 7*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 15532kB
[180257.090619] Normal: 408*4kB 5*8kB 3*16kB 1*32kB 0*64kB 0*128kB 
1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2008kB
[180257.090627] 449853 total pagecache pages
[180257.090628] 760 pages in swap cache
[180257.090630] Swap cache stats: add 25204, delete 24444, find 
4822239/4822528
[180257.090632] Free swap  = 4189356kB
[180257.090633] Total swap = 4200992kB
[180257.106751] 1048560 pages RAM
[180257.106753] 83243 pages reserved
[180257.106755] 734562 pages shared
[180257.106756] 288468 pages non-shared
[180260.437429] net_ratelimit: 210 callbacks suppressed
[180260.437451] __alloc_pages_slowpath: 75 callbacks suppressed
[180260.437454] kcryptd: page allocation failure. order:1, mode:0x4020
[180260.437457] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180260.437459] Call Trace:
[180260.437460]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180260.437484]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180260.437491]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180260.437498]  [<ffffffffa0500cc6>] iwl_rx_handle+0x4a6/0x4c2 [iwlagn]
[180260.437501]  [<ffffffff81005c85>] ? timer_interrupt+0x19/0x20
[180260.437508]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180260.437512]  [<ffffffff81039cb9>] ? rebalance_domains+0x72/0x149
[180260.437518]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180260.437522]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180260.437525]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180260.437528]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180260.437530]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180260.437533]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180260.437536]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180260.437540]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180260.437542]  <EOI>  [<ffffffff8102a724>] ? enc192+0xcf/0x198
[180260.437548]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180260.437552]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180260.437555]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.437557]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.437561]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180260.437564]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180260.437569]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180260.437572]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180260.437575]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180260.437579]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180260.437583]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180260.437586]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180260.437590]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180260.437593]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180260.437596]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180260.437600]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180260.437603]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180260.437606]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180260.437608] Mem-Info:
[180260.437609] DMA per-cpu:
[180260.437611] CPU    0: hi:    0, btch:   1 usd:   0
[180260.437613] CPU    1: hi:    0, btch:   1 usd:   0
[180260.437615] DMA32 per-cpu:
[180260.437616] CPU    0: hi:  186, btch:  31 usd: 174
[180260.437618] CPU    1: hi:  186, btch:  31 usd: 158
[180260.437620] Normal per-cpu:
[180260.437621] CPU    0: hi:  186, btch:  31 usd: 178
[180260.437623] CPU    1: hi:  186, btch:  31 usd: 114
[180260.437628] active_anon:309980 inactive_anon:135428 isolated_anon:0
[180260.437629]  active_file:210592 inactive_file:221018 isolated_file:98
[180260.437630]  unevictable:12607 dirty:5306 writeback:38922 unstable:3267
[180260.437631]  free:6799 slab_reclaimable:24317 slab_unreclaimable:11523
[180260.437632]  mapped:36765 shmem:13747 pagetables:3768 bounce:0
[180260.437638] DMA free:15648kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.437643] lowmem_reserve[]: 0 2900 3910 3910
[180260.437651] DMA32 free:10104kB min:5924kB low:7404kB high:8884kB 
active_anon:1177984kB inactive_anon:375388kB active_file:525728kB 
inactive_file:569016kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:17344kB 
writeback:104872kB mapped:86316kB shmem:12824kB slab_reclaimable:67740kB 
slab_unreclaimable:22964kB kernel_stack:224kB pagetables:4212kB 
unstable:7960kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.437656] lowmem_reserve[]: 0 0 1010 1010
[180260.437664] Normal free:1444kB min:2060kB low:2572kB high:3088kB 
active_anon:61936kB inactive_anon:166324kB active_file:316464kB 
inactive_file:315052kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:3880kB 
writeback:50816kB mapped:60744kB shmem:42164kB slab_reclaimable:29528kB 
slab_unreclaimable:23120kB kernel_stack:2024kB pagetables:10860kB 
unstable:5108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.437669] lowmem_reserve[]: 0 0 0 0
[180260.437672] DMA: 2*4kB 1*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15648kB
[180260.437681] DMA32: 2268*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 10104kB
[180260.437688] Normal: 265*4kB 5*8kB 2*16kB 1*32kB 3*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1484kB
[180260.437696] 446228 total pagecache pages
[180260.437698] 760 pages in swap cache
[180260.437700] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180260.437701] Free swap  = 4189356kB
[180260.437703] Total swap = 4200992kB
[180260.453744] 1048560 pages RAM
[180260.453746] 83243 pages reserved
[180260.453748] 732540 pages shared
[180260.453749] 290552 pages non-shared
[180260.453754] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 0 free buffers remaining.
[180260.497376] swapper: page allocation failure. order:1, mode:0x4020
[180260.497380] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[180260.497382] Call Trace:
[180260.497384]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180260.497406]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180260.497414]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180260.497420]  [<ffffffffa0500cc6>] iwl_rx_handle+0x4a6/0x4c2 [iwlagn]
[180260.497425]  [<ffffffff8162c7b6>] ? __kfree_skb+0x19/0x7c
[180260.497429]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180260.497433]  [<ffffffff8103183b>] ? sched_slice+0x7c/0x7e
[180260.497439]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180260.497445]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180260.497449]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180260.497453]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180260.497456]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180260.497459]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180260.497462]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180260.497465]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180260.497467]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180260.497472]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180260.497474]  <EOI>  [<ffffffff814f200b>] ? acpi_idle_enter_c1+0xdc/0xf7
[180260.497481]  [<ffffffff814f1fed>] ? acpi_idle_enter_c1+0xbe/0xf7
[180260.497485]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[180260.497489]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[180260.497492]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180260.497497]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[180260.497501]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[180260.497504]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[180260.497507]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[180260.497509] Mem-Info:
[180260.497511] DMA per-cpu:
[180260.497512] CPU    0: hi:    0, btch:   1 usd:   0
[180260.497514] CPU    1: hi:    0, btch:   1 usd:   0
[180260.497516] DMA32 per-cpu:
[180260.497518] CPU    0: hi:  186, btch:  31 usd: 178
[180260.497520] CPU    1: hi:  186, btch:  31 usd: 173
[180260.497521] Normal per-cpu:
[180260.497523] CPU    0: hi:  186, btch:  31 usd: 180
[180260.497524] CPU    1: hi:  186, btch:  31 usd: 146
[180260.497529] active_anon:309980 inactive_anon:135428 isolated_anon:0
[180260.497530]  active_file:210582 inactive_file:220919 isolated_file:98
[180260.497531]  unevictable:12607 dirty:5306 writeback:38141 unstable:3304
[180260.497532]  free:6914 slab_reclaimable:24317 slab_unreclaimable:11473
[180260.497533]  mapped:36765 shmem:13747 pagetables:3768 bounce:0
[180260.497539] DMA free:15648kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.497544] lowmem_reserve[]: 0 2900 3910 3910
[180260.497552] DMA32 free:10392kB min:5924kB low:7404kB high:8884kB 
active_anon:1177984kB inactive_anon:375388kB active_file:525728kB 
inactive_file:568824kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:17344kB 
writeback:102948kB mapped:86316kB shmem:12824kB slab_reclaimable:67740kB 
slab_unreclaimable:22764kB kernel_stack:224kB pagetables:4212kB 
unstable:8108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.497558] lowmem_reserve[]: 0 0 1010 1010
[180260.497565] Normal free:1616kB min:2060kB low:2572kB high:3088kB 
active_anon:61936kB inactive_anon:166324kB active_file:316424kB 
inactive_file:314848kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:3880kB 
writeback:49616kB mapped:60744kB shmem:42164kB slab_reclaimable:29528kB 
slab_unreclaimable:23120kB kernel_stack:2024kB pagetables:10860kB 
unstable:5108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.497571] lowmem_reserve[]: 0 0 0 0
[180260.497574] DMA: 2*4kB 1*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15648kB
[180260.497582] DMA32: 2344*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 
1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 10400kB
[180260.497589] Normal: 320*4kB 0*8kB 1*16kB 0*32kB 3*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1616kB
[180260.497597] 446141 total pagecache pages
[180260.497598] 760 pages in swap cache
[180260.497601] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180260.497602] Free swap  = 4189356kB
[180260.497604] Total swap = 4200992kB
[180260.514797] 1048560 pages RAM
[180260.514799] 83243 pages reserved
[180260.514800] 732516 pages shared
[180260.514801] 290458 pages non-shared
[180260.514805] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 1 free buffers remaining.
[180260.514827] kcryptd: page allocation failure. order:1, mode:0x4020
[180260.514831] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180260.514833] Call Trace:
[180260.514835]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180260.514862]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180260.514867]  [<ffffffff8145daa7>] ? blk_run_queue+0x30/0x35
[180260.514873]  [<ffffffff8147e871>] ? is_swiotlb_buffer+0x2e/0x3b
[180260.514880]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180260.514886]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180260.514890]  [<ffffffff8146abb6>] ? cpumask_next_and+0x2c/0x39
[180260.514894]  [<ffffffff8105bb55>] ? ktime_get_ts+0xad/0xba
[180260.514898]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180260.514904]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180260.514911]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180260.514915]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180260.514919]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180260.514922]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180260.514926]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180260.514929]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180260.514932]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180260.514934]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180260.514939]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180260.514941]  <EOI>  [<ffffffff8102a5a9>] ? aes_enc_blk+0x131/0x1dd
[180260.514948]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180260.514952]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180260.514955]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.514957]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.514960]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180260.514965]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180260.514970]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180260.514974]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180260.514977]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180260.514981]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180260.514985]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180260.514988]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180260.514992]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180260.514995]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180260.514997]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180260.515001]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180260.515004]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180260.515007]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180260.515010] Mem-Info:
[180260.515011] DMA per-cpu:
[180260.515014] CPU    0: hi:    0, btch:   1 usd:   0
[180260.515016] CPU    1: hi:    0, btch:   1 usd:   0
[180260.515018] DMA32 per-cpu:
[180260.515019] CPU    0: hi:  186, btch:  31 usd: 178
[180260.515021] CPU    1: hi:  186, btch:  31 usd: 176
[180260.515023] Normal per-cpu:
[180260.515025] CPU    0: hi:  186, btch:  31 usd: 180
[180260.515026] CPU    1: hi:  186, btch:  31 usd: 167
[180260.515031] active_anon:309980 inactive_anon:135428 isolated_anon:0
[180260.515032]  active_file:210582 inactive_file:220919 isolated_file:98
[180260.515033]  unevictable:12607 dirty:5306 writeback:38141 unstable:3304
[180260.515034]  free:6511 slab_reclaimable:24317 slab_unreclaimable:11473
[180260.515035]  mapped:36765 shmem:13747 pagetables:3768 bounce:0
[180260.515042] DMA free:15648kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.515046] lowmem_reserve[]: 0 2900 3910 3910
[180260.515055] DMA32 free:8904kB min:5924kB low:7404kB high:8884kB 
active_anon:1177984kB inactive_anon:375388kB active_file:525728kB 
inactive_file:568824kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:17344kB 
writeback:102948kB mapped:86316kB shmem:12824kB slab_reclaimable:67740kB 
slab_unreclaimable:22764kB kernel_stack:224kB pagetables:4212kB 
unstable:8108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.515060] lowmem_reserve[]: 0 0 1010 1010
[180260.515068] Normal free:1492kB min:2060kB low:2572kB high:3088kB 
active_anon:61936kB inactive_anon:166324kB active_file:316424kB 
inactive_file:314848kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:3880kB 
writeback:49616kB mapped:60744kB shmem:42164kB slab_reclaimable:29528kB 
slab_unreclaimable:23120kB kernel_stack:2024kB pagetables:10860kB 
unstable:5108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.515074] lowmem_reserve[]: 0 0 0 0
[180260.515077] DMA: 2*4kB 1*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15648kB
[180260.515086] DMA32: 1972*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1*128kB 
1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 8912kB
[180260.515094] Normal: 289*4kB 0*8kB 1*16kB 0*32kB 3*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
[180260.515102] 446141 total pagecache pages
[180260.515104] 760 pages in swap cache
[180260.515106] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180260.515108] Free swap  = 4189356kB
[180260.515109] Total swap = 4200992kB
[180260.531548] 1048560 pages RAM
[180260.531550] 83243 pages reserved
[180260.531551] 732548 pages shared
[180260.531553] 290661 pages non-shared
[180260.531557] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 1 free buffers remaining.
[180260.531629] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 47 free buffers remaining.
[180260.531661] kcryptd: page allocation failure. order:1, mode:0x4020
[180260.531664] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180260.531666] Call Trace:
[180260.531668]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180260.531690]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180260.531697]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180260.531703]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180260.531708]  [<ffffffff8146abb6>] ? cpumask_next_and+0x2c/0x39
[180260.531712]  [<ffffffff8105bb55>] ? ktime_get_ts+0xad/0xba
[180260.531716]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180260.531722]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180260.531729]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180260.531733]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180260.531737]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180260.531740]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180260.531744]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180260.531747]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180260.531750]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180260.531752]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180260.531758]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180260.531760]  <EOI>  [<ffffffff8102a5a9>] ? aes_enc_blk+0x131/0x1dd
[180260.531766]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180260.531771]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180260.531773]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.531776]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180260.531779]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180260.531784]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180260.531790]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180260.531793]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180260.531796]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180260.531801]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180260.531804]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180260.531808]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180260.531811]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180260.531815]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180260.531817]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180260.531821]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180260.531824]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180260.531828]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180260.531829] Mem-Info:
[180260.531831] DMA per-cpu:
[180260.531833] CPU    0: hi:    0, btch:   1 usd:   0
[180260.531835] CPU    1: hi:    0, btch:   1 usd:   0
[180260.531837] DMA32 per-cpu:
[180260.531839] CPU    0: hi:  186, btch:  31 usd: 181
[180260.531841] CPU    1: hi:  186, btch:  31 usd: 176
[180260.531842] Normal per-cpu:
[180260.531844] CPU    0: hi:  186, btch:  31 usd: 181
[180260.531846] CPU    1: hi:  186, btch:  31 usd: 167
[180260.531850] active_anon:309980 inactive_anon:135428 isolated_anon:0
[180260.531851]  active_file:210550 inactive_file:220758 isolated_file:130
[180260.531852]  unevictable:12607 dirty:5306 writeback:38016 unstable:3304
[180260.531853]  free:6745 slab_reclaimable:24317 slab_unreclaimable:11448
[180260.531854]  mapped:36765 shmem:13747 pagetables:3768 bounce:0
[180260.531861] DMA free:15648kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.531865] lowmem_reserve[]: 0 2900 3910 3910
[180260.531873] DMA32 free:9716kB min:5924kB low:7404kB high:8884kB 
active_anon:1177984kB inactive_anon:375388kB active_file:525728kB 
inactive_file:568308kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:17344kB 
writeback:102948kB mapped:86316kB shmem:12824kB slab_reclaimable:67740kB 
slab_unreclaimable:22664kB kernel_stack:224kB pagetables:4212kB 
unstable:8108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180260.531879] lowmem_reserve[]: 0 0 1010 1010
[180260.531887] Normal free:1616kB min:2060kB low:2572kB high:3088kB 
active_anon:61936kB inactive_anon:166324kB active_file:316296kB 
inactive_file:314720kB unevictable:92kB isolated(anon):0kB 
isolated(file):392kB present:1034240kB mlocked:0kB dirty:3880kB 
writeback:49116kB mapped:60744kB shmem:42164kB slab_reclaimable:29528kB 
slab_unreclaimable:23120kB kernel_stack:2024kB pagetables:10860kB 
unstable:5108kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
[180260.531893] lowmem_reserve[]: 0 0 0 0
[180260.531896] DMA: 2*4kB 1*8kB 1*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15648kB
[180260.531905] DMA32: 2175*4kB 4*8kB 1*16kB 1*32kB 1*64kB 1*128kB 
1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 9740kB
[180260.531912] Normal: 320*4kB 0*8kB 1*16kB 0*32kB 3*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1616kB
[180260.531921] 446005 total pagecache pages
[180260.531922] 760 pages in swap cache
[180260.531924] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180260.531926] Free swap  = 4189356kB
[180260.531927] Total swap = 4200992kB
[180260.549317] 1048560 pages RAM
[180260.549319] 83243 pages reserved
[180260.549321] 732388 pages shared
[180260.549322] 290175 pages non-shared
[180261.205061] swapper: page allocation failure. order:1, mode:0x4020
[180261.205065] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[180261.205067] Call Trace:
[180261.205069]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180261.205090]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180261.205097]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180261.205104]  [<ffffffffa0500cc6>] iwl_rx_handle+0x4a6/0x4c2 [iwlagn]
[180261.205108]  [<ffffffff8162c815>] ? __kfree_skb+0x78/0x7c
[180261.205114]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180261.205117]  [<ffffffff8162c01f>] ? skb_dequeue+0x5f/0x6b
[180261.205124]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180261.205128]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180261.205131]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180261.205134]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180261.205137]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180261.205140]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180261.205143]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180261.205147]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180261.205149]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[180261.205156]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[180261.205160]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[180261.205164]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[180261.205167]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180261.205171]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[180261.205176]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[180261.205179]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[180261.205182]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[180261.205184] Mem-Info:
[180261.205185] DMA per-cpu:
[180261.205187] CPU    0: hi:    0, btch:   1 usd:   0
[180261.205189] CPU    1: hi:    0, btch:   1 usd:   0
[180261.205191] DMA32 per-cpu:
[180261.205193] CPU    0: hi:  186, btch:  31 usd:  42
[180261.205195] CPU    1: hi:  186, btch:  31 usd:  41
[180261.205196] Normal per-cpu:
[180261.205198] CPU    0: hi:  186, btch:  31 usd:  12
[180261.205199] CPU    1: hi:  186, btch:  31 usd:  58
[180261.205204] active_anon:314478 inactive_anon:135428 isolated_anon:0
[180261.205205]  active_file:210581 inactive_file:220106 isolated_file:98
[180261.205206]  unevictable:12607 dirty:5450 writeback:34188 unstable:3583
[180261.205207]  free:6738 slab_reclaimable:24306 slab_unreclaimable:10788
[180261.205208]  mapped:36765 shmem:17765 pagetables:3768 bounce:0
[180261.205214] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180261.205219] lowmem_reserve[]: 0 2900 3910 3910
[180261.205227] DMA32 free:9272kB min:5924kB low:7404kB high:8884kB 
active_anon:1190408kB inactive_anon:375388kB active_file:525744kB 
inactive_file:566496kB unevictable:50336kB isolated(anon):0kB 
isolated(file):128kB present:2970488kB mlocked:50336kB dirty:17584kB 
writeback:88892kB mapped:86316kB shmem:23864kB slab_reclaimable:67736kB 
slab_unreclaimable:20088kB kernel_stack:224kB pagetables:4212kB 
unstable:9224kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180261.205233] lowmem_reserve[]: 0 0 1010 1010
[180261.205240] Normal free:2036kB min:2060kB low:2572kB high:3088kB 
active_anon:67504kB inactive_anon:166324kB active_file:316404kB 
inactive_file:313924kB unevictable:92kB isolated(anon):0kB 
isolated(file):264kB present:1034240kB mlocked:0kB dirty:4216kB 
writeback:47860kB mapped:60744kB shmem:47196kB slab_reclaimable:29488kB 
slab_unreclaimable:23056kB kernel_stack:2024kB pagetables:10860kB 
unstable:5108kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180261.205246] lowmem_reserve[]: 0 0 0 0
[180261.205249] DMA: 3*4kB 2*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15644kB
[180261.205257] DMA32: 2041*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 
2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 9372kB
[180261.205264] Normal: 435*4kB 3*8kB 2*16kB 1*32kB 2*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2084kB
[180261.205272] 449361 total pagecache pages
[180261.205274] 760 pages in swap cache
[180261.205276] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180261.205278] Free swap  = 4189356kB
[180261.205279] Total swap = 4200992kB
[180261.221787] 1048560 pages RAM
[180261.221790] 83243 pages reserved
[180261.221791] 736242 pages shared
[180261.221792] 287070 pages non-shared
[180265.320455] swapper: page allocation failure. order:1, mode:0x4020
[180265.320459] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
[180265.320461] Call Trace:
[180265.320463]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180265.320487]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180265.320495]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180265.320501]  [<ffffffffa0500cc6>] iwl_rx_handle+0x4a6/0x4c2 [iwlagn]
[180265.320505]  [<ffffffff81005c85>] ? timer_interrupt+0x19/0x20
[180265.320511]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180265.320518]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180265.320521]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180265.320524]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180265.320527]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180265.320530]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180265.320533]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180265.320535]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180265.320541]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180265.320542]  <EOI>  [<ffffffff814f2453>] ? 
acpi_idle_enter_simple+0x150/0x17b
[180265.320550]  [<ffffffff814f2449>] ? acpi_idle_enter_simple+0x146/0x17b
[180265.320554]  [<ffffffff816035c4>] cpuidle_idle_call+0x8b/0xc3
[180265.320558]  [<ffffffff81001ca7>] cpu_idle+0xa6/0xe7
[180265.320561]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180265.320566]  [<ffffffff816ecbc1>] rest_init+0xb5/0xba
[180265.320571]  [<ffffffff81acbb65>] start_kernel+0x3f2/0x3fd
[180265.320574]  [<ffffffff81acb0b6>] x86_64_start_reservations+0xb3/0xb7
[180265.320577]  [<ffffffff81acb19a>] x86_64_start_kernel+0xe0/0xe7
[180265.320579] Mem-Info:
[180265.320581] DMA per-cpu:
[180265.320583] CPU    0: hi:    0, btch:   1 usd:   0
[180265.320585] CPU    1: hi:    0, btch:   1 usd:   0
[180265.320586] DMA32 per-cpu:
[180265.320588] CPU    0: hi:  186, btch:  31 usd: 173
[180265.320590] CPU    1: hi:  186, btch:  31 usd: 164
[180265.320591] Normal per-cpu:
[180265.320593] CPU    0: hi:  186, btch:  31 usd: 157
[180265.320595] CPU    1: hi:  186, btch:  31 usd: 156
[180265.320599] active_anon:314278 inactive_anon:135428 isolated_anon:0
[180265.320600]  active_file:210404 inactive_file:217497 isolated_file:195
[180265.320601]  unevictable:12607 dirty:151 writeback:36438 unstable:5590
[180265.320602]  free:6837 slab_reclaimable:24305 slab_unreclaimable:12419
[180265.320603]  mapped:36811 shmem:17535 pagetables:3768 bounce:0
[180265.320610] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.320615] lowmem_reserve[]: 0 2900 3910 3910
[180265.320623] DMA32 free:10164kB min:5924kB low:7404kB high:8884kB 
active_anon:1189176kB inactive_anon:375388kB active_file:525308kB 
inactive_file:559316kB unevictable:50336kB isolated(anon):0kB 
isolated(file):384kB present:2970488kB mlocked:50336kB dirty:356kB 
writeback:96060kB mapped:86432kB shmem:22560kB slab_reclaimable:67732kB 
slab_unreclaimable:24920kB kernel_stack:224kB pagetables:4212kB 
unstable:16328kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.320628] lowmem_reserve[]: 0 0 1010 1010
[180265.320636] Normal free:1540kB min:2060kB low:2572kB high:3088kB 
active_anon:67936kB inactive_anon:166324kB active_file:316132kB 
inactive_file:310668kB unevictable:92kB isolated(anon):0kB 
isolated(file):396kB present:1034240kB mlocked:0kB dirty:248kB 
writeback:49692kB mapped:60812kB shmem:47580kB slab_reclaimable:29488kB 
slab_unreclaimable:24748kB kernel_stack:2024kB pagetables:10860kB 
unstable:6032kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.320641] lowmem_reserve[]: 0 0 0 0
[180265.320644] DMA: 3*4kB 1*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15636kB
[180265.320652] DMA32: 2297*4kB 38*8kB 31*16kB 0*32kB 1*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10180kB
[180265.320660] Normal: 303*4kB 27*8kB 3*16kB 2*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1540kB
[180265.320668] 446387 total pagecache pages
[180265.320669] 760 pages in swap cache
[180265.320671] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180265.320673] Free swap  = 4189356kB
[180265.320674] Total swap = 4200992kB
[180265.338273] 1048560 pages RAM
[180265.338276] 83243 pages reserved
[180265.338277] 733543 pages shared
[180265.338279] 287247 pages non-shared
[180265.338306] kcryptd: page allocation failure. order:1, mode:0x4020
[180265.338311] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180265.338313] Call Trace:
[180265.338315]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180265.338341]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180265.338346]  [<ffffffff8146abb6>] ? cpumask_next_and+0x2c/0x39
[180265.338353]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180265.338359]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180265.338364]  [<ffffffff8103b999>] ? check_preempt_wakeup+0x12a/0x197
[180265.338367]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180265.338373]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180265.338380]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180265.338384]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180265.338388]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180265.338391]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180265.338395]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180265.338398]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180265.338401]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180265.338404]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180265.338409]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180265.338410]  <EOI>  [<ffffffff8102af4a>] ? enc128+0x75d/0x80b
[180265.338416]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180265.338421]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180265.338423]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.338426]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.338429]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180265.338433]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180265.338437]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180265.338440]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180265.338444]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180265.338448]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180265.338452]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180265.338455]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180265.338459]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180265.338462]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180265.338464]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180265.338468]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180265.338471]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180265.338474]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180265.338476] Mem-Info:
[180265.338478] DMA per-cpu:
[180265.338480] CPU    0: hi:    0, btch:   1 usd:   0
[180265.338482] CPU    1: hi:    0, btch:   1 usd:   0
[180265.338483] DMA32 per-cpu:
[180265.338485] CPU    0: hi:  186, btch:  31 usd: 174
[180265.338487] CPU    1: hi:  186, btch:  31 usd: 190
[180265.338488] Normal per-cpu:
[180265.338490] CPU    0: hi:  186, btch:  31 usd: 185
[180265.338492] CPU    1: hi:  186, btch:  31 usd: 174
[180265.338496] active_anon:314278 inactive_anon:135428 isolated_anon:0
[180265.338497]  active_file:210404 inactive_file:217497 isolated_file:195
[180265.338498]  unevictable:12607 dirty:151 writeback:36351 unstable:5590
[180265.338499]  free:6496 slab_reclaimable:24305 slab_unreclaimable:12419
[180265.338500]  mapped:36811 shmem:17535 pagetables:3768 bounce:0
[180265.338507] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.338511] lowmem_reserve[]: 0 2900 3910 3910
[180265.338519] DMA32 free:8676kB min:5924kB low:7404kB high:8884kB 
active_anon:1189176kB inactive_anon:375388kB active_file:525308kB 
inactive_file:559316kB unevictable:50336kB isolated(anon):0kB 
isolated(file):384kB present:2970488kB mlocked:50336kB dirty:356kB 
writeback:95912kB mapped:86432kB shmem:22560kB slab_reclaimable:67732kB 
slab_unreclaimable:24920kB kernel_stack:224kB pagetables:4212kB 
unstable:16328kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.338525] lowmem_reserve[]: 0 0 1010 1010
[180265.338532] Normal free:1664kB min:2060kB low:2572kB high:3088kB 
active_anon:67936kB inactive_anon:166324kB active_file:316132kB 
inactive_file:310668kB unevictable:92kB isolated(anon):0kB 
isolated(file):396kB present:1034240kB mlocked:0kB dirty:248kB 
writeback:49492kB mapped:60812kB shmem:47580kB slab_reclaimable:29488kB 
slab_unreclaimable:24748kB kernel_stack:2024kB pagetables:10860kB 
unstable:6032kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.338538] lowmem_reserve[]: 0 0 0 0
[180265.338541] DMA: 3*4kB 1*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15636kB
[180265.338549] DMA32: 2017*4kB 2*8kB 26*16kB 0*32kB 1*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8692kB
[180265.338556] Normal: 346*4kB 21*8kB 3*16kB 2*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1664kB
[180265.338564] 446387 total pagecache pages
[180265.338566] 760 pages in swap cache
[180265.338568] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180265.338570] Free swap  = 4189356kB
[180265.338571] Total swap = 4200992kB
[180265.355304] 1048560 pages RAM
[180265.355306] 83243 pages reserved
[180265.355308] 733478 pages shared
[180265.355309] 287161 pages non-shared
[180265.355392] kcryptd: page allocation failure. order:1, mode:0x4020
[180265.355396] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180265.355398] Call Trace:
[180265.355399]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180265.355418]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180265.355425]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180265.355431]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180265.355436]  [<ffffffff8103b999>] ? check_preempt_wakeup+0x12a/0x197
[180265.355439]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180265.355445]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180265.355451]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180265.355455]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180265.355459]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180265.355462]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180265.355465]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180265.355468]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180265.355471]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180265.355474]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180265.355478]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180265.355480]  <EOI>  [<ffffffff8102af4a>] ? enc128+0x75d/0x80b
[180265.355486]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180265.355490]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180265.355493]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.355496]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.355499]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180265.355503]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180265.355507]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180265.355510]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180265.355514]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180265.355518]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180265.355521]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180265.355524]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180265.355528]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180265.355531]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180265.355534]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180265.355538]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180265.355541]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180265.355544]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180265.355546] Mem-Info:
[180265.355547] DMA per-cpu:
[180265.355549] CPU    0: hi:    0, btch:   1 usd:   0
[180265.355551] CPU    1: hi:    0, btch:   1 usd:   0
[180265.355553] DMA32 per-cpu:
[180265.355554] CPU    0: hi:  186, btch:  31 usd: 181
[180265.355556] CPU    1: hi:  186, btch:  31 usd: 190
[180265.355558] Normal per-cpu:
[180265.355559] CPU    0: hi:  186, btch:  31 usd: 165
[180265.355561] CPU    1: hi:  186, btch:  31 usd: 174
[180265.355566] active_anon:314278 inactive_anon:135428 isolated_anon:0
[180265.355567]  active_file:210405 inactive_file:217304 isolated_file:195
[180265.355568]  unevictable:12607 dirty:151 writeback:36151 unstable:5615
[180265.355569]  free:6849 slab_reclaimable:24305 slab_unreclaimable:12369
[180265.355570]  mapped:36811 shmem:17535 pagetables:3768 bounce:0
[180265.355576] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.355581] lowmem_reserve[]: 0 2900 3910 3910
[180265.355589] DMA32 free:9684kB min:5924kB low:7404kB high:8884kB 
active_anon:1189176kB inactive_anon:375388kB active_file:525308kB 
inactive_file:558804kB unevictable:50336kB isolated(anon):0kB 
isolated(file):384kB present:2970488kB mlocked:50336kB dirty:356kB 
writeback:95912kB mapped:86432kB shmem:22560kB slab_reclaimable:67732kB 
slab_unreclaimable:24720kB kernel_stack:224kB pagetables:4212kB 
unstable:16328kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.355595] lowmem_reserve[]: 0 0 1010 1010
[180265.355602] Normal free:2068kB min:2060kB low:2572kB high:3088kB 
active_anon:67936kB inactive_anon:166324kB active_file:316136kB 
inactive_file:310408kB unevictable:92kB isolated(anon):0kB 
isolated(file):396kB present:1034240kB mlocked:0kB dirty:248kB 
writeback:48692kB mapped:60812kB shmem:47580kB slab_reclaimable:29488kB 
slab_unreclaimable:24748kB kernel_stack:2024kB pagetables:10860kB 
unstable:6132kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.355608] lowmem_reserve[]: 0 0 0 0
[180265.355611] DMA: 3*4kB 1*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15636kB
[180265.355620] DMA32: 2177*4kB 44*8kB 29*16kB 0*32kB 1*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 9716kB
[180265.355628] Normal: 419*4kB 35*8kB 3*16kB 2*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2068kB
[180265.355635] 446164 total pagecache pages
[180265.355637] 760 pages in swap cache
[180265.355639] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180265.355641] Free swap  = 4189356kB
[180265.355642] Total swap = 4200992kB
[180265.372574] 1048560 pages RAM
[180265.372576] 83243 pages reserved
[180265.372577] 733479 pages shared
[180265.372579] 287189 pages non-shared
[180265.372613] kcryptd: page allocation failure. order:1, mode:0x4020
[180265.372616] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180265.372618] Call Trace:
[180265.372619]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180265.372638]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180265.372642]  [<ffffffff810513ca>] ? queue_work+0x4b/0x55
[180265.372649]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180265.372655]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180265.372659]  [<ffffffff8103b999>] ? check_preempt_wakeup+0x12a/0x197
[180265.372662]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180265.372668]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180265.372675]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180265.372678]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180265.372682]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180265.372685]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180265.372688]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180265.372691]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180265.372694]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180265.372697]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180265.372701]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180265.372703]  <EOI>  [<ffffffff8102af4a>] ? enc128+0x75d/0x80b
[180265.372709]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180265.372713]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180265.372716]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.372718]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.372721]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180265.372725]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180265.372730]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180265.372733]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180265.372736]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180265.372740]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180265.372743]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180265.372746]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180265.372750]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180265.372753]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180265.372756]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180265.372760]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180265.372763]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180265.372766]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180265.372768] Mem-Info:
[180265.372769] DMA per-cpu:
[180265.372771] CPU    0: hi:    0, btch:   1 usd:   0
[180265.372773] CPU    1: hi:    0, btch:   1 usd:   0
[180265.372775] DMA32 per-cpu:
[180265.372776] CPU    0: hi:  186, btch:  31 usd: 168
[180265.372778] CPU    1: hi:  186, btch:  31 usd: 190
[180265.372780] Normal per-cpu:
[180265.372781] CPU    0: hi:  186, btch:  31 usd: 157
[180265.372783] CPU    1: hi:  186, btch:  31 usd: 174
[180265.372788] active_anon:314278 inactive_anon:135428 isolated_anon:0
[180265.372789]  active_file:210405 inactive_file:217240 isolated_file:195
[180265.372790]  unevictable:12607 dirty:151 writeback:36114 unstable:5615
[180265.372791]  free:6973 slab_reclaimable:24305 slab_unreclaimable:12369
[180265.372792]  mapped:36811 shmem:17535 pagetables:3768 bounce:0
[180265.372798] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.372803] lowmem_reserve[]: 0 2900 3910 3910
[180265.372811] DMA32 free:10180kB min:5924kB low:7404kB high:8884kB 
active_anon:1189176kB inactive_anon:375388kB active_file:525308kB 
inactive_file:558548kB unevictable:50336kB isolated(anon):0kB 
isolated(file):384kB present:2970488kB mlocked:50336kB dirty:356kB 
writeback:95764kB mapped:86432kB shmem:22560kB slab_reclaimable:67732kB 
slab_unreclaimable:24720kB kernel_stack:224kB pagetables:4212kB 
unstable:16328kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.372817] lowmem_reserve[]: 0 0 1010 1010
[180265.372824] Normal free:2068kB min:2060kB low:2572kB high:3088kB 
active_anon:67936kB inactive_anon:166324kB active_file:316136kB 
inactive_file:310408kB unevictable:92kB isolated(anon):0kB 
isolated(file):396kB present:1034240kB mlocked:0kB dirty:248kB 
writeback:48692kB mapped:60812kB shmem:47580kB slab_reclaimable:29488kB 
slab_unreclaimable:24748kB kernel_stack:2024kB pagetables:10860kB 
unstable:6132kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.372830] lowmem_reserve[]: 0 0 0 0
[180265.372833] DMA: 3*4kB 1*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15636kB
[180265.372841] DMA32: 2275*4kB 59*8kB 29*16kB 0*32kB 1*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10228kB
[180265.372849] Normal: 419*4kB 35*8kB 3*16kB 2*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2068kB
[180265.372858] 446127 total pagecache pages
[180265.372859] 760 pages in swap cache
[180265.372861] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180265.372863] Free swap  = 4189356kB
[180265.372865] Total swap = 4200992kB
[180265.388823] 1048560 pages RAM
[180265.388825] 83243 pages reserved
[180265.388827] 733485 pages shared
[180265.388828] 287077 pages non-shared
[180265.388877] kcryptd: page allocation failure. order:1, mode:0x4020
[180265.388881] Pid: 4943, comm: kcryptd Not tainted 2.6.34-pentoo-r2 #2
[180265.388883] Call Trace:
[180265.388885]  <IRQ>  [<ffffffff810984c0>] 
__alloc_pages_nodemask+0x571/0x5b9
[180265.388907]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
[180265.388914]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23 
[iwlagn]
[180265.388920]  [<ffffffffa0500ca1>] iwl_rx_handle+0x481/0x4c2 [iwlagn]
[180265.388925]  [<ffffffff8103b999>] ? check_preempt_wakeup+0x12a/0x197
[180265.388928]  [<ffffffff8103b557>] ? update_curr+0xbe/0xfa
[180265.388934]  [<ffffffffa0502766>] iwl_irq_tasklet+0xb0e/0xecd [iwlagn]
[180265.388941]  [<ffffffffa050a7ef>] ? iwl_isr_ict+0x8e7/0xa49 [iwlagn]
[180265.388945]  [<ffffffff81044ca0>] tasklet_action+0x6f/0xba
[180265.388949]  [<ffffffff810193dc>] ? lapic_next_event+0x18/0x1c
[180265.388952]  [<ffffffff810456d7>] __do_softirq+0x91/0x11a
[180265.388955]  [<ffffffff8100384c>] call_softirq+0x1c/0x28
[180265.388959]  [<ffffffff8100550b>] do_softirq+0x33/0x68
[180265.388961]  [<ffffffff810453d4>] irq_exit+0x36/0x87
[180265.388964]  [<ffffffff81004bf0>] do_IRQ+0xa7/0xbe
[180265.388969]  [<ffffffff8170af13>] ret_from_intr+0x0/0xa
[180265.388971]  <EOI>  [<ffffffff8102af4a>] ? enc128+0x75d/0x80b
[180265.388977]  [<ffffffff8102bba3>] ? aes_encrypt+0xd/0xf
[180265.388982]  [<ffffffff81445457>] ? crypt+0xbc/0x10f
[180265.388984]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.388987]  [<ffffffff8102bb96>] ? aes_encrypt+0x0/0xf
[180265.388990]  [<ffffffff81445534>] ? encrypt+0x44/0x46
[180265.388995]  [<ffffffff81432ddb>] ? async_encrypt+0x37/0x39
[180265.388999]  [<ffffffff815f5dac>] ? crypt_iv_essiv_gen+0x21/0x25
[180265.389003]  [<ffffffff815f663c>] ? crypt_convert+0x201/0x27a
[180265.389006]  [<ffffffff815f69f8>] ? kcryptd_crypt+0x343/0x361
[180265.389011]  [<ffffffff81050a73>] ? worker_thread+0x15d/0x1f3
[180265.389014]  [<ffffffff815f66b5>] ? kcryptd_crypt+0x0/0x361
[180265.389018]  [<ffffffff810543c1>] ? autoremove_wake_function+0x0/0x34
[180265.389021]  [<ffffffff8170ab58>] ? 
_raw_spin_unlock_irqrestore+0x27/0x29
[180265.389024]  [<ffffffff81050916>] ? worker_thread+0x0/0x1f3
[180265.389027]  [<ffffffff81053fd3>] ? kthread+0x7a/0x82
[180265.389032]  [<ffffffff81003754>] ? kernel_thread_helper+0x4/0x10
[180265.389034]  [<ffffffff81053f59>] ? kthread+0x0/0x82
[180265.389038]  [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
[180265.389039] Mem-Info:
[180265.389041] DMA per-cpu:
[180265.389043] CPU    0: hi:    0, btch:   1 usd:   0
[180265.389045] CPU    1: hi:    0, btch:   1 usd:   0
[180265.389047] DMA32 per-cpu:
[180265.389048] CPU    0: hi:  186, btch:  31 usd: 167
[180265.389050] CPU    1: hi:  186, btch:  31 usd: 190
[180265.389052] Normal per-cpu:
[180265.389053] CPU    0: hi:  186, btch:  31 usd: 158
[180265.389055] CPU    1: hi:  186, btch:  31 usd: 174
[180265.389060] active_anon:314278 inactive_anon:135428 isolated_anon:0
[180265.389061]  active_file:210405 inactive_file:217240 isolated_file:195
[180265.389062]  unevictable:12607 dirty:151 writeback:36040 unstable:5615
[180265.389063]  free:7035 slab_reclaimable:24305 slab_unreclaimable:12369
[180265.389064]  mapped:36811 shmem:17535 pagetables:3768 bounce:0
[180265.389070] DMA free:15644kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:176kB inactive_file:4kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15708kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.389076] lowmem_reserve[]: 0 2900 3910 3910
[180265.389086] DMA32 free:10428kB min:5924kB low:7404kB high:8884kB 
active_anon:1189176kB inactive_anon:375388kB active_file:525308kB 
inactive_file:558548kB unevictable:50336kB isolated(anon):0kB 
isolated(file):384kB present:2970488kB mlocked:50336kB dirty:356kB 
writeback:95468kB mapped:86432kB shmem:22560kB slab_reclaimable:67732kB 
slab_unreclaimable:24720kB kernel_stack:224kB pagetables:4212kB 
unstable:16328kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.389092] lowmem_reserve[]: 0 0 1010 1010
[180265.389102] Normal free:2068kB min:2060kB low:2572kB high:3088kB 
active_anon:67936kB inactive_anon:166324kB active_file:316136kB 
inactive_file:310408kB unevictable:92kB isolated(anon):0kB 
isolated(file):396kB present:1034240kB mlocked:0kB dirty:248kB 
writeback:48692kB mapped:60812kB shmem:47580kB slab_reclaimable:29488kB 
slab_unreclaimable:24748kB kernel_stack:2024kB pagetables:10860kB 
unstable:6132kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
[180265.389107] lowmem_reserve[]: 0 0 0 0
[180265.389112] DMA: 3*4kB 1*8kB 0*16kB 2*32kB 3*64kB 0*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15636kB
[180265.389134] DMA32: 2331*4kB 64*8kB 29*16kB 0*32kB 1*64kB 1*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10492kB
[180265.389146] Normal: 419*4kB 35*8kB 3*16kB 2*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2068kB
[180265.389159] 446127 total pagecache pages
[180265.389161] 760 pages in swap cache
[180265.389163] Swap cache stats: add 25204, delete 24444, find 
4822302/4822591
[180265.389165] Free swap  = 4189356kB
[180265.389167] Total swap = 4200992kB
[180265.405671] 1048560 pages RAM
[180265.405674] 83243 pages reserved
[180265.405675] 733491 pages shared
[180265.405677] 287012 pages non-shared
[180265.460643] net_ratelimit: 30 callbacks suppressed
[180265.460665] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 5 free buffers remaining.
[180265.581141] iwlagn 0000:02:00.0: Failed to alloc_pages with 
GFP_ATOMIC. Only 40 free buffers remaining.

