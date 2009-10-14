Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:25481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783AbZJNNQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 09:16:23 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1375757fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 06:14:35 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com
Subject: iwl3945: page allocation failure. order:5, mode:0x8020
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 14 Oct 2009 16:14:32 +0300
Message-ID: <878wfenmmf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

your friendly iwl3945 bug reporter here :)

I updated to latest wireless-testing (tag master-2009-10-13) and I got
a page allocation failure with my Thinkpad X60s. I admit that memory
is tight on my laptop, but it has 2 GB of RAM and everything should
still work IMHO.

I didn't reboot during update, I only did 'modprobe -r iwl3945;
modprobe iwl3945', so there's a small chance that something went wrong
during update. But I still suspect something else is wrong because I
have never seen this error before. 

After a fresh reboot I wasn't able to reproduce the problem. But, if
needed, I can do more testing later on.

Here's the log:

[19938.640246] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kd
[19938.640250] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[19938.640318] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[19938.640339] iwl3945 0000:03:00.0: setting latency timer to 64
[19938.680570] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[19938.680574] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[19938.680718] iwl3945 0000:03:00.0: irq 29 for MSI/MSI-X
[19938.681589] phy0: Selected rate control algorithm 'iwl-3945-rs'
[19945.896395] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[19945.953132] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[19945.953148] wpa_supplicant: page allocation failure. order:5, mode:0x8020
[19945.953156] Pid: 24358, comm: wpa_supplicant Not tainted 2.6.32-rc4-wl #230
[19945.953161] Call Trace:
[19945.953174]  [<c11e43bf>] ? printk+0x14/0x1d
[19945.953184]  [<c10791f1>] __alloc_pages_nodemask+0x405/0x46c
[19945.953195]  [<c10067b6>] dma_generic_alloc_coherent+0x52/0xa8
[19945.953204]  [<c1006764>] ? dma_generic_alloc_coherent+0x0/0xa8
[19945.953217]  [<fbf16348>] iwl_alloc_fw_desc+0x8e/0xa5 [iwl3945]
[19945.953228]  [<fbf16dd9>] iwl3945_mac_start+0x80d/0xee6 [iwl3945]
[19945.953237]  [<c119f67a>] ? nlmsg_notify+0x44/0x7d
[19945.953256]  [<fbe5a137>] ieee80211_open+0x258/0x5ef [mac80211]
[19945.953266]  [<c1191943>] dev_open+0x98/0xd3
[19945.953274]  [<c119104b>] dev_change_flags+0xaa/0x15f
[19945.953282]  [<c11c5407>] devinet_ioctl+0x21f/0x494
[19945.953289]  [<c11c64a2>] inet_ioctl+0x93/0xac
[19945.953297]  [<c1183f3e>] sock_ioctl+0x1cf/0x1f3
[19945.953303]  [<c1183d6f>] ? sock_ioctl+0x0/0x1f3
[19945.953311]  [<c10a51d0>] vfs_ioctl+0x27/0x6e
[19945.953318]  [<c10a5757>] do_vfs_ioctl+0x497/0x4d1
[19945.953327]  [<c101a5e8>] ? do_page_fault+0x24e/0x27b
[19945.953334]  [<c10a57c2>] sys_ioctl+0x31/0x4a
[19945.953342]  [<c1002a48>] sysenter_do_call+0x12/0x26
[19945.953347] Mem-Info:
[19945.953350] DMA per-cpu:
[19945.953355] CPU    0: hi:    0, btch:   1 usd:   0
[19945.953360] CPU    1: hi:    0, btch:   1 usd:   0
[19945.953364] Normal per-cpu:
[19945.953369] CPU    0: hi:  186, btch:  31 usd: 110
[19945.953374] CPU    1: hi:  186, btch:  31 usd: 142
[19945.953379] HighMem per-cpu:
[19945.953383] CPU    0: hi:  186, btch:  31 usd: 168
[19945.953388] CPU    1: hi:  186, btch:  31 usd: 177
[19945.953406] active_anon:48080 inactive_anon:23308 isolated_anon:0
[19945.953409]  active_file:178476 inactive_file:167609 isolated_file:0
[19945.953412]  unevictable:0 dirty:0 writeback:0 unstable:0 buffer:50433
[19945.953415]  free:77571 slab_reclaimable:15276 slab_unreclaimable:2375
[19945.953418]  mapped:12927 shmem:7303 pagetables:486 bounce:0
[19945.953433] DMA free:5608kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:8672kB inactive_file:1156kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15868kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:516kB slab_unreclaimable:12kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[19945.953447] lowmem_reserve[]: 0 865 2007 2007
[19945.953466] Normal free:209020kB min:3728kB low:4660kB high:5592kB active_anon:7936kB inactive_anon:2484kB active_file:289308kB inactive_file:285732kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:604kB shmem:884kB slab_reclaimable:60588kB slab_unreclaimable:9488kB kernel_stack:1624kB pagetables:1944kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[19945.953481] lowmem_reserve[]: 0 0 9135 9135
[19945.953499] HighMem free:95656kB min:512kB low:1740kB high:2972kB active_anon:184384kB inactive_anon:90748kB active_file:415924kB inactive_file:383548kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1169296kB mlocked:0kB dirty:0kB writeback:0kB mapped:51104kB shmem:28328kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[19945.953514] lowmem_reserve[]: 0 0 0 0
[19945.953522] DMA: 274*4kB 270*8kB 85*16kB 21*32kB 5*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5608kB
[19945.953543] Normal: 33875*4kB 7353*8kB 692*16kB 82*32kB 13*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 208980kB
[19945.953565] HighMem: 146*4kB 1710*8kB 2071*16kB 894*32kB 207*64kB 28*128kB 7*256kB 2*512kB 0*1024kB 0*2048kB 0*4096kB = 95656kB
[19945.953587] 353746 total pagecache pages
[19945.953591] 342 pages in swap cache
[19945.953596] Swap cache stats: add 1727, delete 1385, find 772/833
[19945.953600] Free swap  = 2711268kB
[19945.953604] Total swap = 2715640kB
[19945.970901] 521952 pages RAM
[19945.970905] 294626 pages HighMem
[19945.970907] 5269 pages reserved
[19945.970909] 198544 pages shared
[19945.970911] 265857 pages non-shared
[19945.970947] iwl3945 0000:03:00.0: failed to allocate pci memory
[19945.970976] iwl3945 0000:03:00.0: Could not read microcode: -12


-- 
Kalle Valo
