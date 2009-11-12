Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:54764 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZKLW6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:58:49 -0500
Received: by fxm21 with SMTP id 21so2835232fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:58:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40101cc30911121437m695bbb04n71300093c3a6721f@mail.gmail.com>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	 <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	 <20091112154440.GD19349@tux>
	 <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	 <40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	 <1258054304.3899.36.camel@johannes.local>
	 <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
	 <40101cc30911121416o333f32c1h3e26b4cc988c243f@mail.gmail.com>
	 <20091112222831.GC17000@tux>
	 <40101cc30911121437m695bbb04n71300093c3a6721f@mail.gmail.com>
Date: Thu, 12 Nov 2009 23:58:53 +0100
Message-ID: <f74418680911121458l6612ca6ds79ca4ca4fe0bae97@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Luis.Rodriguez@atheros.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Debugging is enabled but i guess it's a kernel module
>
> root@alix:/usr/src/wireless-testing# gdb vmlinux
> GNU gdb (GDB) 7.0-debian
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "i486-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /usr/src/wireless-testing/vmlinux...done.
> (gdb) l *0xccd48e70
> No source file for address 0xccd48e70.
> (gdb)
>

Running the minimal test case module on a 2.6.31.5 standard kernel I
obtained these results:

Cheers.

Lorenzo

23:18:18 up 5 min,  4 users,  load average: 0.11, 0.37, 0.20
             total       used       free     shared    buffers     cached
Mem:       3785552     699684    3085868          0      35404     307544
-/+ buffers/cache:     356736    3428816
Swap:       947824          0     947824


23:19:03 up 5 min,  4 users,  load average: 0.10, 0.33, 0.19
             total       used       free     shared    buffers     cached
Mem:       3785552     702244    3083308          0      35436     307548
-/+ buffers/cache:     359260    3426292
Swap:       947824          0     947824

23:19:46 up 6 min,  4 users,  load average: 0.09, 0.30, 0.18
             total       used       free     shared    buffers     cached
Mem:       3785552     705708    3079844          0      35476     307548
-/+ buffers/cache:     362684    3422868
Swap:       947824          0     947824

23:22:17 up 9 min,  4 users,  load average: 0.00, 0.17, 0.15
             total       used       free     shared    buffers     cached
Mem:       3785552     722036    3063516          0      35884     307560
-/+ buffers/cache:     378592    3406960
Swap:       947824          0     947824

23:34:34 up 21 min,  4 users,  load average: 0.14, 0.09, 0.11
             total       used       free     shared    buffers     cached
Mem:       3785552     809180    2976372          0      39320     325364
-/+ buffers/cache:     444496    3341056
Swap:       947824          0     947824

diff -u a b

@@ -43,15 +43,15 @@
 132 in /sys/kernel/slab/mm_struct
 132 in /sys/kernel/slab/:t-0000896
 146 in /sys/kernel/slab/:at-0000056
+146 in /sys/kernel/slab/:at-0000112
 146 in /sys/kernel/slab/ext4_free_block_extents
+146 in /sys/kernel/slab/jbd2_journal_head
 146 in /sys/kernel/slab/skbuff_fclone_cache
 146 in /sys/kernel/slab/:t-0000448
 150 in /sys/kernel/slab/sighand_cache
 156 in /sys/kernel/slab/:at-0000104
-156 in /sys/kernel/slab/:at-0000112
 156 in /sys/kernel/slab/ext4_prealloc_space
 156 in /sys/kernel/slab/fsnotify_event
-156 in /sys/kernel/slab/jbd2_journal_head
 156 in /sys/kernel/slab/:t-0000104
 170 in /sys/kernel/slab/Acpi-Parse
 170 in /sys/kernel/slab/bip-16
@@ -94,7 +94,7 @@
 420 in /sys/kernel/slab/idr_layer_cache
 420 in /sys/kernel/slab/:t-0000544
 549 in /sys/kernel/slab/kmalloc-8192
-551 in /sys/kernel/slab/:t-0008192
+549 in /sys/kernel/slab/:t-0008192
 623 in /sys/kernel/slab/biovec-256
 623 in /sys/kernel/slab/kmalloc-4096
 623 in /sys/kernel/slab/names_cache
@@ -104,20 +104,20 @@
 772 in /sys/kernel/slab/sgpool-16
 772 in /sys/kernel/slab/:t-0000512
 824 in /sys/kernel/slab/proc_inode_cache
-899 in /sys/kernel/slab/bip-1
-899 in /sys/kernel/slab/cred_jar
-899 in /sys/kernel/slab/eventpoll_epi
-899 in /sys/kernel/slab/kmalloc-128
-899 in /sys/kernel/slab/pid
-899 in /sys/kernel/slab/request_sock_TCP
-899 in /sys/kernel/slab/scsi_sense_cache
-899 in /sys/kernel/slab/:t-0000128
-899 in /sys/kernel/slab/uid_cache
+898 in /sys/kernel/slab/bip-1
+898 in /sys/kernel/slab/cred_jar
+898 in /sys/kernel/slab/eventpoll_epi
+898 in /sys/kernel/slab/kmalloc-128
+898 in /sys/kernel/slab/pid
+898 in /sys/kernel/slab/request_sock_TCP
+898 in /sys/kernel/slab/scsi_sense_cache
+898 in /sys/kernel/slab/:t-0000128
+898 in /sys/kernel/slab/uid_cache
 1405 in /sys/kernel/slab/shmem_inode_cache
-1992 in /sys/kernel/slab/kmalloc-1024
-1994 in /sys/kernel/slab/biovec-64
-1994 in /sys/kernel/slab/:t-0001024
-1995 in /sys/kernel/slab/sgpool-32
+1991 in /sys/kernel/slab/sgpool-32
+1993 in /sys/kernel/slab/biovec-64
+1993 in /sys/kernel/slab/kmalloc-1024
+1993 in /sys/kernel/slab/:t-0001024
 2097 in /sys/kernel/slab/Acpi-Operand
 2097 in /sys/kernel/slab/Acpi-ParseExt
 2097 in /sys/kernel/slab/eventpoll_pwq
@@ -126,15 +126,15 @@
 2294 in /sys/kernel/slab/biovec-1
 2294 in /sys/kernel/slab/kmalloc-16
 2294 in /sys/kernel/slab/:t-0000016
-2565 in /sys/kernel/slab/biovec-4
-2565 in /sys/kernel/slab/fib6_nodes
-2565 in /sys/kernel/slab/fs_cache
-2565 in /sys/kernel/slab/inet_peer_cache
-2565 in /sys/kernel/slab/kmalloc-64
-2565 in /sys/kernel/slab/secpath_cache
-2565 in /sys/kernel/slab/:t-0000064
-2565 in /sys/kernel/slab/xfrm6_tunnel_spi
-2729 in /sys/kernel/slab/anon_vma
+2517 in /sys/kernel/slab/biovec-4
+2517 in /sys/kernel/slab/fib6_nodes
+2517 in /sys/kernel/slab/fs_cache
+2517 in /sys/kernel/slab/inet_peer_cache
+2517 in /sys/kernel/slab/kmalloc-64
+2517 in /sys/kernel/slab/secpath_cache
+2517 in /sys/kernel/slab/:t-0000064
+2517 in /sys/kernel/slab/xfrm6_tunnel_spi
+2776 in /sys/kernel/slab/anon_vma
 2936 in /sys/kernel/slab/Acpi-Namespace
 2936 in /sys/kernel/slab/dnotify_struct
 2936 in /sys/kernel/slab/inotify_event_private_data
@@ -143,40 +143,40 @@
 2936 in /sys/kernel/slab/nv_pte_t
 2936 in /sys/kernel/slab/:t-0000032
 2936 in /sys/kernel/slab/tcp_bind_bucket
-2970 in /sys/kernel/slab/scsi_cmd_cache
-2971 in /sys/kernel/slab/kiocb
-2971 in /sys/kernel/slab/skbuff_head_cache
-2972 in /sys/kernel/slab/arp_cache
-2972 in /sys/kernel/slab/kmalloc-256
-2972 in /sys/kernel/slab/mnt_cache
-2972 in /sys/kernel/slab/sgpool-8
-2973 in /sys/kernel/slab/biovec-16
-2973 in /sys/kernel/slab/ndisc_cache
 2973 in /sys/kernel/slab/:t-0000256
-3086 in /sys/kernel/slab/inode_cache
+2974 in /sys/kernel/slab/kiocb
+2975 in /sys/kernel/slab/biovec-16
+2975 in /sys/kernel/slab/kmalloc-256
+2975 in /sys/kernel/slab/ndisc_cache
+2976 in /sys/kernel/slab/arp_cache
+2976 in /sys/kernel/slab/skbuff_head_cache
+2977 in /sys/kernel/slab/mnt_cache
+2977 in /sys/kernel/slab/scsi_cmd_cache
+2977 in /sys/kernel/slab/sgpool-8
+3084 in /sys/kernel/slab/inode_cache
 3578 in /sys/kernel/slab/kmalloc-8
 3578 in /sys/kernel/slab/:t-0000008
-4808 in /sys/kernel/slab/filp
-4812 in /sys/kernel/slab/bio-0
-4812 in /sys/kernel/slab/bip-4
-4814 in /sys/kernel/slab/request_sock_TCPv6
-4816 in /sys/kernel/slab/kmalloc-192
-4820 in /sys/kernel/slab/:t-0000192
-5963 in /sys/kernel/slab/radix_tree_node
+4786 in /sys/kernel/slab/request_sock_TCPv6
+4793 in /sys/kernel/slab/bip-4
+4793 in /sys/kernel/slab/kmalloc-192
+4793 in /sys/kernel/slab/:t-0000192
+4795 in /sys/kernel/slab/filp
+4796 in /sys/kernel/slab/bio-0
+6040 in /sys/kernel/slab/radix_tree_node
 10173 in /sys/kernel/slab/Acpi-State
 10173 in /sys/kernel/slab/blkdev_ioc
 10173 in /sys/kernel/slab/scsi_tgt_cmd
 10173 in /sys/kernel/slab/sysfs_dir_cache
 10173 in /sys/kernel/slab/:t-0000080
-10796 in /sys/kernel/slab/buffer_head
-11532 in /sys/kernel/slab/vm_area_struct
-11557 in /sys/kernel/slab/cfq_io_context
-11557 in /sys/kernel/slab/cfq_queue
-11557 in /sys/kernel/slab/:t-0000168
-11719 in /sys/kernel/slab/ext4_inode_cache
-27271 in /sys/kernel/slab/:at-0000192
-27271 in /sys/kernel/slab/dentry
-128562 in /sys/kernel/slab/flow_cache
-128562 in /sys/kernel/slab/kmalloc-96
-128604 in /sys/kernel/slab/:t-0000096
-241093 in /sys/kernel/slab/kmemleak_object
+10947 in /sys/kernel/slab/buffer_head
+11315 in /sys/kernel/slab/cfq_io_context
+11315 in /sys/kernel/slab/cfq_queue
+11315 in /sys/kernel/slab/:t-0000168
+11315 in /sys/kernel/slab/vm_area_struct
+11800 in /sys/kernel/slab/ext4_inode_cache
+27442 in /sys/kernel/slab/:at-0000192
+27442 in /sys/kernel/slab/dentry
+155568 in /sys/kernel/slab/flow_cache
+155568 in /sys/kernel/slab/kmalloc-96
+155610 in /sys/kernel/slab/:t-0000096
+268261 in /sys/kernel/slab/kmemleak_object
