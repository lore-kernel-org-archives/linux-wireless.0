Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42143 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab1AGSfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:35:02 -0500
Message-ID: <4D275CCC.90905@candelatech.com>
Date: Fri, 07 Jan 2011 10:34:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294397880.3467.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294397880.3467.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 02:58 AM, Johannes Berg wrote:
> On Thu, 2011-01-06 at 16:46 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Patch is from Eric Dumazet, as described here:
>> https://patchwork.kernel.org/patch/104271/
>>
>> Reported-by: Michael Guntsche<mike@it-loops.com>
>> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> NOTE:  This needs review by ath9k and/or other informed
>> people.
>
> This doesn't make sense. It might help, but it'll probably lead to not
> being able to receive all frames off the air.
>
> If this is an issue, ath9k should do paged RX like iwlwifi.

Ok, I backed this out..but now I'm back to getting buffer allocation
failures (and this is on a system with 2GB RAM).

Seems it's coming from mac80211 instead of ath9k, at least most of
the time (I'm using 60 stations, so it probably needs to make lots of
copies in the rx path).  The traffic I'm generating/receiving is 1024 byte UDP
payloads.

Does this mean I really received a packet that was 3872 bytes long,
or is the skb_copy allocating/copying empty data?

Jan  7 10:00:45 localhost kernel: skbuff alloc of size 3872 failed
Jan  7 10:00:45 localhost kernel: skbuff alloc of size 3872 failed
Jan  7 10:00:45 localhost kernel: __alloc_pages_slowpath: 2886 callbacks suppressed
Jan  7 10:00:45 localhost kernel: kswapd0: page allocation failure. order:2, mode:0x4020
Jan  7 10:00:45 localhost kernel: Pid: 29, comm: kswapd0 Not tainted 2.6.37-wl+ #62
Jan  7 10:00:45 localhost kernel: Call Trace:
Jan  7 10:00:45 localhost kernel: [<7878c822>] ? printk+0x18/0x1e
Jan  7 10:00:45 localhost kernel: [<784938ef>] __alloc_pages_nodemask+0x625/0x668
Jan  7 10:00:45 localhost kernel: [<784b66a5>] alloc_slab_page+0x1d/0x21
Jan  7 10:00:45 localhost kernel: [<784b66fc>] new_slab+0x53/0x144
Jan  7 10:00:45 localhost kernel: [<784b6c05>] __slab_alloc.clone.4+0x133/0x1f9
Jan  7 10:00:45 localhost kernel: [<784b6f3c>] ? kmem_cache_alloc+0x7c/0xa1
Jan  7 10:00:45 localhost kernel: [<786edc0d>] ? skb_copy+0x33/0x87
Jan  7 10:00:45 localhost kernel: [<784b7374>] __kmalloc_track_caller+0xc6/0x115
Jan  7 10:00:45 localhost kernel: [<786edc0d>] ? skb_copy+0x33/0x87
Jan  7 10:00:45 localhost kernel: [<786ed642>] __alloc_skb+0x58/0xf4
Jan  7 10:00:45 localhost kernel: [<786edc0d>] skb_copy+0x33/0x87
Jan  7 10:00:45 localhost kernel: [<fa4c73e2>] ieee80211_prepare_and_rx_handle+0x3be/0x86f [mac80211]
Jan  7 10:00:45 localhost kernel: [<fa4c80ba>] ieee80211_rx+0x795/0x853 [mac80211]
Jan  7 10:00:45 localhost kernel: [<fa4c7a1c>] ? ieee80211_rx+0xf7/0x853 [mac80211]
Jan  7 10:00:45 localhost kernel: [<7845007b>] ? pm_qos_update_request+0x4b/0x57
Jan  7 10:00:45 localhost kernel: [<fa591366>] ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
Jan  7 10:00:45 localhost kernel: [<fa592ce7>] ath_rx_tasklet+0x1318/0x13af [ath9k]
Jan  7 10:00:45 localhost kernel: [<7845a405>] ? mark_lock+0x1e/0x1eb
Jan  7 10:00:45 localhost kernel: [<7845a619>] ? mark_held_locks+0x47/0x5f
Jan  7 10:00:45 localhost kernel: [<7878ebcb>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Jan  7 10:00:45 localhost kernel: [<7845a85c>] ? trace_hardirqs_on_caller+0xeb/0x125
Jan  7 10:00:45 localhost kernel: [<7845a8a1>] ? trace_hardirqs_on+0xb/0xd
Jan  7 10:00:45 localhost kernel: [<fa590ce1>] ath9k_tasklet+0x98/0x12d [ath9k]
Jan  7 10:00:45 localhost kernel: [<7845a85c>] ? trace_hardirqs_on_caller+0xeb/0x125
Jan  7 10:00:45 localhost kernel: [<7843be09>] tasklet_action+0x88/0xe3
Jan  7 10:00:45 localhost kernel: [<7843c385>] __do_softirq+0x85/0x142
Jan  7 10:00:45 localhost kernel: [<7843c300>] ? __do_softirq+0x0/0x142
Jan  7 10:00:45 localhost kernel: [<7843c300>] ? __do_softirq+0x0/0x142
Jan  7 10:00:45 localhost kernel: <IRQ>  [<7843c1a7>] ? irq_exit+0x35/0x69
Jan  7 10:00:45 localhost kernel: [<7841a399>] ? smp_apic_timer_interrupt+0x74/0x81
Jan  7 10:00:45 localhost kernel: [<785976e0>] ? trace_hardirqs_off_thunk+0xc/0x10
Jan  7 10:00:45 localhost kernel: [<7878f39f>] ? apic_timer_interrupt+0x2f/0x40
Jan  7 10:00:45 localhost kernel: [<7845007b>] ? pm_qos_update_request+0x4b/0x57
Jan  7 10:00:45 localhost kernel: [<784b700a>] ? kmem_cache_free+0xa9/0xb5
Jan  7 10:00:45 localhost kernel: [<7852cafa>] ? ext4_destroy_inode+0x91/0x98
Jan  7 10:00:45 localhost kernel: [<7852cafa>] ? ext4_destroy_inode+0x91/0x98
Jan  7 10:00:45 localhost kernel: [<7852cafa>] ? ext4_destroy_inode+0x91/0x98
Jan  7 10:00:45 localhost kernel: [<784d0c1d>] ? percpu_counter_dec+0x19/0x1b
Jan  7 10:00:45 localhost kernel: [<784d12f1>] ? destroy_inode+0x2d/0x3e
Jan  7 10:00:45 localhost kernel: [<784d17f8>] ? dispose_list+0x8d/0x9c
Jan  7 10:00:45 localhost kernel: [<784d1d8d>] ? shrink_icache_memory+0x1d7/0x218
Jan  7 10:00:45 localhost kernel: [<78497560>] ? shrink_slab+0xdc/0x144
Jan  7 10:00:45 localhost kernel: [<78498891>] ? kswapd+0x468/0x66f
Jan  7 10:00:45 localhost kernel: [<7844b776>] ? autoremove_wake_function+0x0/0x34
Jan  7 10:00:45 localhost kernel: [<78498429>] ? kswapd+0x0/0x66f
Jan  7 10:00:45 localhost kernel: [<7844b465>] ? kthread+0x62/0x67
Jan  7 10:00:45 localhost kernel: [<7844b403>] ? kthread+0x0/0x67
Jan  7 10:00:45 localhost kernel: [<784036c6>] ? kernel_thread_helper+0x6/0x1a
Jan  7 10:00:45 localhost kernel: Mem-Info:
Jan  7 10:00:45 localhost kernel: DMA per-cpu:
Jan  7 10:00:45 localhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  7 10:00:45 localhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  7 10:00:45 localhost kernel: Normal per-cpu:
Jan  7 10:00:45 localhost kernel: CPU    0: hi:  186, btch:  31 usd: 165
Jan  7 10:00:45 localhost kernel: CPU    1: hi:  186, btch:  31 usd:  61
Jan  7 10:00:45 localhost kernel: active_anon:48191 inactive_anon:1802 isolated_anon:0
Jan  7 10:00:45 localhost kernel: active_file:16287 inactive_file:29786 isolated_file:0
Jan  7 10:00:45 localhost kernel: unevictable:0 dirty:12 writeback:0 unstable:0
Jan  7 10:00:45 localhost kernel: free:7257 slab_reclaimable:12121 slab_unreclaimable:386040
Jan  7 10:00:45 localhost kernel: mapped:9692 shmem:1985 pagetables:1131 bounce:0
Jan  7 10:00:45 localhost kernel: DMA free:4288kB min:40kB low:48kB high:60kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Jan  7 10:00:45 localhost kernel: lowmem_reserve[]: 0 2007 2007 2007
Jan  7 10:00:45 localhost kernel: Normal free:24740kB min:5712kB low:7140kB high:8568kB active_anon:192764kB inactive_anon:7208kB active_file:65148kB 
inactive_file:119144kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2056128kB mlocked:0kB dirty:48kB writeback:0kB mapped:38768kB shmem:7940kB 
slab_reclaimable:48484kB slab_unreclaimable:1544160kB kernel_stack:6736kB pagetables:4524kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
Jan  7 10:00:45 localhost kernel: lowmem_reserve[]: 0 0 0 0
Jan  7 10:00:45 localhost kernel: DMA: 0*4kB 2*8kB 1*16kB 1*32kB 2*64kB 2*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 4288kB
Jan  7 10:00:45 localhost kernel: Normal: 3067*4kB 1491*8kB 26*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 24740kB
Jan  7 10:00:45 localhost kernel: 48061 total pagecache pages
Jan  7 10:00:45 localhost kernel: 0 pages in swap cache
Jan  7 10:00:45 localhost kernel: Swap cache stats: add 0, delete 0, find 0/0
Jan  7 10:00:45 localhost kernel: Free swap  = 0kB
Jan  7 10:00:45 localhost kernel: Total swap = 0kB
Jan  7 10:00:45 localhost kernel: 522160 pages RAM
Jan  7 10:00:45 localhost kernel: 0 pages HighMem
Jan  7 10:00:45 localhost kernel: 12174 pages reserved
Jan  7 10:00:45 localhost kernel: 78943 pages shared
Jan  7 10:00:45 localhost kernel: 469325 pages non-shared

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
