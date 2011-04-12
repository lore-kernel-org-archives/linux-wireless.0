Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab1DLPif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 11:38:35 -0400
Received: by bwz15 with SMTP id 15so5465410bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 08:38:33 -0700 (PDT)
Message-ID: <4DA471DC.7080308@gmail.com>
Date: Tue, 12 Apr 2011 19:38:04 +0400
From: Igor Plyatov <plyatov@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rt2800usb: page allocation failure
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear developers,

My machine is ARM:
root@gms:~# uname -a
Linux gms 2.6.39-rc3 #71 PREEMPT Tue Apr 12 14:04:49 MSD 2011 armv5tejl 
unknown

This machine have 64MB RAM and no processes which eat too much memory:
root@gms:~# ps
   PID USER       VSZ STAT COMMAND
     1 root      1624 S    init [5]
     2 root         0 SW   [kthreadd]
     3 root         0 SW   [ksoftirqd/0]
     4 root         0 SW   [kworker/0:0]
     5 root         0 SW   [kworker/u:0]
     6 root         0 SW<  [khelper]
     7 root         0 DW   [kworker/u:1]
    10 root         0 SW<  [netns]
   134 root         0 SW   [sync_supers]
   136 root         0 SW   [bdi-default]
   138 root         0 SW<  [kblockd]
   144 root         0 SW<  [ata_sff]
   155 root         0 SW   [khubd]
   171 root         0 SW<  [cfg80211]
   254 root         0 SW<  [rpciod]
   260 root         0 DW   [kswapd0]
   261 root         0 SW   [fsnotify_mark]
   262 root         0 SW<  [nfsiod]
   263 root         0 SW<  [crypto]
   849 root         0 SW   [mtdblock0]
   854 root         0 SW   [mtdblock1]
   859 root         0 SW   [mtdblock2]
   864 root         0 SW   [mtdblock3]
   869 root         0 SW   [mtdblock4]
   874 root         0 SW   [mtdblock5]
   879 root         0 SW   [mtdblock6]
   884 root         0 SW   [mtdblock7]
   889 root         0 SW   [mtdblock8]
   930 root         0 SW   [w1_bus_master1]
   948 root         0 DW   [kworker/u:2]
   977 root         0 SW   [scsi_eh_0]
   978 root         0 SW   [usb-storage]
   997 root      1988 S <  /sbin/udevd -d
  1511 root         0 SW   [flush-mtd-unmap]
  1528 root         0 SWN  [jffs2_gcd_mtd7]
  1581 root         0 SWN  [jffs2_gcd_mtd8]
  1659 root      1984 S <  /sbin/udevd -d
  1661 root      1984 S <  /sbin/udevd -d
  1663 root         0 SW   [kworker/0:2]
  1666 root      3628 S    /usr/sbin/wpa_supplicant -B -P 
/var/run/wpa_supplican
  1732 root         0 SW   [kworker/u:3]
  1776 root      1860 S    dhcpcd wlan1
  1806 messageb  3328 S    /usr/bin/dbus-daemon --system
  1816 root      4168 S    /usr/sbin/sshd
  1821 root      1800 S    /usr/sbin/cron
  1827 root      1676 S    /usr/sbin/ifplugd -i eth0 -fwI -u0 -d10
  1831 root      3444 S    /usr/bin/ntpd -p /var/run/ntp.pid -g
  1836 root      5320 S    /usr/sbin/syslog-ng --process-mode background 
--pidfi
  1842 root      2376 S    login -- root
  1843 root      3056 S    -sh
  1847 root      2876 D    dd if /dev/zero of /media/net/testfile
  1848 root         0 SW   [flush-0:17]
  1849 root      4296 R    sshd: root@pts/0
  1853 root      3056 S    -sh
  1869 root      3056 R    ps

The USB Wi-Fi adapter is "Qcom LR802UKN3" based on the RT3070 chipset.

I use NFS share to transmit a lot of data through Wi-FI for testing:

root@gms:~# mount -t nfs -o nolock,tcp 
192.168.1.10:/home/plyatov/development/nfs /media/net

root@gms:~# dd if=/dev/zero of=/media/net/testfile

Then similar errors appeared after some time (~hour):

kworker/u:1: page allocation failure. order:1, mode:0x20
Backtrace:
[<c002a720>] (dump_backtrace+0x0/0x10c) from [<c033fcc0>] 
(dump_stack+0x18/0x1c)
  r7:c3830000 r6:00000030 r5:00000020 r4:00000000
[<c033fca8>] (dump_stack+0x0/0x1c) from [<c007b33c>] 
(__alloc_pages_nodemask+0x58c/0x5f0)
[<c007adb0>] (__alloc_pages_nodemask+0x0/0x5f0) from [<c00a09c0>] 
(cache_alloc_refill+0x2e4/0x5e0)
[<c00a06dc>] (cache_alloc_refill+0x0/0x5e0) from [<c00a0d50>] 
(__kmalloc+0x94/0xd4)
[<c00a0cbc>] (__kmalloc+0x0/0xd4) from [<c0278348>] (__alloc_skb+0x54/0xec)
  r7:00000020 r6:00000f60 r5:c33e6aa0 r4:c380dce0
[<c02782f4>] (__alloc_skb+0x0/0xec) from [<c0279470>] 
(dev_alloc_skb+0x20/0x44)
  r8:c30d9050 r7:c3852da0 r6:00000f14 r5:c3831f18 r4:0000000c
[<c0279450>] (dev_alloc_skb+0x0/0x44) from [<c0226698>] 
(rt2x00queue_alloc_rxskb+0x4c/0xc4)
[<c022664c>] (rt2x00queue_alloc_rxskb+0x0/0xc4) from [<c0223480>] 
(rt2x00lib_rxdone+0x44/0x298)
  r8:c39d8600 r7:c3852da0 r6:c30d9050 r5:c3831f18 r4:c3852da0
[<c022343c>] (rt2x00lib_rxdone+0x0/0x298) from [<c0227eb8>] 
(rt2x00usb_work_rxdone+0x54/0x74)
[<c0227e64>] (rt2x00usb_work_rxdone+0x0/0x74) from [<c004c910>] 
(process_one_work+0x27c/0x3f8)
  r5:c3826c60 r4:c38530bc
[<c004c694>] (process_one_work+0x0/0x3f8) from [<c004d148>] 
(worker_thread+0x244/0x480)
[<c004cf04>] (worker_thread+0x0/0x480) from [<c00532e4>] (kthread+0x88/0x90)
[<c005325c>] (kthread+0x0/0x90) from [<c003bdac>] (do_exit+0x0/0x6dc)
  r7:00000013 r6:c003bdac r5:c005325c r4:c382bee0
Mem-info:
Normal per-cpu:
CPU    0: hi:   18, btch:   3 usd:  16
active_anon:719 inactive_anon:8 isolated_anon:0
  active_file:6090 inactive_file:6132 isolated_file:0
  unevictable:0 dirty:0 writeback:784 unstable:1439
  free:431 slab_reclaimable:288 slab_unreclaimable:1120
  mapped:167 shmem:54 pagetables:66 bounce:0
Normal free:1724kB min:1016kB low:1268kB high:1524kB active_anon:2876kB 
inactive_anon:32kB active_file:24360kB inactive_file:24528kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:65024kB 
mlocked:0kB dirty:0kB writeback:3136kB mapped:668kB shmem:216kB 
slab_reclaimable:1152kB slab_unreclaimable:4480kB kernel_stack:432kB 
pagetables:264kB unstable:5756kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 403*4kB 2*8kB 2*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1724kB
12276 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
16384 pages of RAM
552 free pages
1218 reserved pages
1408 slab pages
3841 pages shared
0 pages swap cached
kworker/u:1: page allocation failure. order:1, mode:0x20
Backtrace:
[<c002a720>] (dump_backtrace+0x0/0x10c) from [<c033fcc0>] 
(dump_stack+0x18/0x1c)
  r7:c3830000 r6:00000030 r5:00000020 r4:00000000
[<c033fca8>] (dump_stack+0x0/0x1c) from [<c007b33c>] 
(__alloc_pages_nodemask+0x58c/0x5f0)
[<c007adb0>] (__alloc_pages_nodemask+0x0/0x5f0) from [<c00a09c0>] 
(cache_alloc_refill+0x2e4/0x5e0)
[<c00a06dc>] (cache_alloc_refill+0x0/0x5e0) from [<c00a0d50>] 
(__kmalloc+0x94/0xd4)
[<c00a0cbc>] (__kmalloc+0x0/0xd4) from [<c0278348>] (__alloc_skb+0x54/0xec)
  r7:00000020 r6:00000f60 r5:c33e6aa0 r4:c380dce0
[<c02782f4>] (__alloc_skb+0x0/0xec) from [<c0279470>] 
(dev_alloc_skb+0x20/0x44)
  r8:c30d9064 r7:c3852da0 r6:00000f14 r5:c3831f18 r4:0000000c
[<c0279450>] (dev_alloc_skb+0x0/0x44) from [<c0226698>] 
(rt2x00queue_alloc_rxskb+0x4c/0xc4)
[<c022664c>] (rt2x00queue_alloc_rxskb+0x0/0xc4) from [<c0223480>] 
(rt2x00lib_rxdone+0x44/0x298)
  r8:c39d8600 r7:c3852da0 r6:c30d9064 r5:c3831f18 r4:c3852da0
[<c022343c>] (rt2x00lib_rxdone+0x0/0x298) from [<c0227eb8>] 
(rt2x00usb_work_rxdone+0x54/0x74)
[<c0227e64>] (rt2x00usb_work_rxdone+0x0/0x74) from [<c004c910>] 
(process_one_work+0x27c/0x3f8)
  r5:c3826c60 r4:c38530bc
[<c004c694>] (process_one_work+0x0/0x3f8) from [<c004d148>] 
(worker_thread+0x244/0x480)
[<c004cf04>] (worker_thread+0x0/0x480) from [<c00532e4>] (kthread+0x88/0x90)
[<c005325c>] (kthread+0x0/0x90) from [<c003bdac>] (do_exit+0x0/0x6dc)
  r7:00000013 r6:c003bdac r5:c005325c r4:c382bee0
Mem-info:
Normal per-cpu:
CPU    0: hi:   18, btch:   3 usd:   1
active_anon:719 inactive_anon:8 isolated_anon:0
  active_file:6080 inactive_file:6109 isolated_file:33
  unevictable:0 dirty:0 writeback:784 unstable:1439
  free:419 slab_reclaimable:288 slab_unreclaimable:1122
  mapped:167 shmem:54 pagetables:66 bounce:0
Normal free:1676kB min:1016kB low:1268kB high:1524kB active_anon:2876kB 
inactive_anon:32kB active_file:24320kB inactive_file:24436kB 
unevictable:0kB isolated(anon):0kB isolated(file):132kB present:65024kB 
mlocked:0kB dirty:0kB writeback:3136kB mapped:668kB shmem:216kB 
slab_reclaimable:1152kB slab_unreclaimable:4488kB kernel_stack:432kB 
pagetables:264kB unstable:5756kB bounce:0kB writeback_tmp:0kB 
pages_scanned:33 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 391*4kB 2*8kB 2*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1676kB
12278 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
16384 pages of RAM
528 free pages
1218 reserved pages
1410 slab pages
3877 pages shared
0 pages swap cached
kworker/u:0: page allocation failure. order:1, mode:0x20
Backtrace:
[<c002a720>] (dump_backtrace+0x0/0x10c) from [<c033fcc0>] 
(dump_stack+0x18/0x1c)
  r7:c382a000 r6:00000030 r5:00000020 r4:00000000
[<c033fca8>] (dump_stack+0x0/0x1c) from [<c007b33c>] 
(__alloc_pages_nodemask+0x58c/0x5f0)
[<c007adb0>] (__alloc_pages_nodemask+0x0/0x5f0) from [<c00a09c0>] 
(cache_alloc_refill+0x2e4/0x5e0)
[<c00a06dc>] (cache_alloc_refill+0x0/0x5e0) from [<c00a0d50>] 
(__kmalloc+0x94/0xd4)
[<c00a0cbc>] (__kmalloc+0x0/0xd4) from [<c0278348>] (__alloc_skb+0x54/0xec)
  r7:00000020 r6:00000f60 r5:c33e6780 r4:c380dce0
[<c02782f4>] (__alloc_skb+0x0/0xec) from [<c0279470>] 
(dev_alloc_skb+0x20/0x44)
  r8:c30d9320 r7:c3852da0 r6:00000f14 r5:c382bf18 r4:0000000c
[<c0279450>] (dev_alloc_skb+0x0/0x44) from [<c0226698>] 
(rt2x00queue_alloc_rxskb+0x4c/0xc4)
[<c022664c>] (rt2x00queue_alloc_rxskb+0x0/0xc4) from [<c0223480>] 
(rt2x00lib_rxdone+0x44/0x298)
  r8:c39d8600 r7:c3852da0 r6:c30d9320 r5:c382bf18 r4:c3852da0
[<c022343c>] (rt2x00lib_rxdone+0x0/0x298) from [<c0227eb8>] 
(rt2x00usb_work_rxdone+0x54/0x74)
[<c0227e64>] (rt2x00usb_work_rxdone+0x0/0x74) from [<c004c910>] 
(process_one_work+0x27c/0x3f8)
  r5:c3826fa0 r4:c38530bc
[<c004c694>] (process_one_work+0x0/0x3f8) from [<c004d148>] 
(worker_thread+0x244/0x480)
[<c004cf04>] (worker_thread+0x0/0x480) from [<c00532e4>] (kthread+0x88/0x90)
[<c005325c>] (kthread+0x0/0x90) from [<c003bdac>] (do_exit+0x0/0x6dc)
  r7:00000013 r6:c003bdac r5:c005325c r4:c381df00
Mem-info:
Normal per-cpu:
CPU    0: hi:   18, btch:   3 usd:  15
active_anon:720 inactive_anon:9 isolated_anon:0
  active_file:6112 inactive_file:6131 isolated_file:0
  unevictable:0 dirty:0 writeback:784 unstable:1439
  free:407 slab_reclaimable:288 slab_unreclaimable:1122
  mapped:158 shmem:56 pagetables:66 bounce:0
Normal free:1628kB min:1016kB low:1268kB high:1524kB active_anon:2880kB 
inactive_anon:36kB active_file:24448kB inactive_file:24524kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:65024kB 
mlocked:0kB dirty:0kB writeback:3136kB mapped:632kB shmem:224kB 
slab_reclaimable:1152kB slab_unreclaimable:4488kB kernel_stack:432kB 
pagetables:264kB unstable:5756kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 379*4kB 2*8kB 2*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 1628kB
12299 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
16384 pages of RAM
527 free pages
1218 reserved pages
1410 slab pages
3796 pages shared
0 pages swap cached

This problem tested with WEP security in 802.11bg mode with "Zyxel 
P660HTW2" AP and 802.11bgn mode with "TP-Link TL-WR1043ND" AP.

Does somebody can fix this, or recommend how to fix?

Best regards!
--
Igor Plyatov
