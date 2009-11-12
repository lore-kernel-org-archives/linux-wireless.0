Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59662 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZKLWSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:18:53 -0500
Received: by fxm21 with SMTP id 21so2796363fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:18:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258054304.3899.36.camel@johannes.local>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 23:18:38 +0100
Message-ID: <40101cc30911121418h4109d62bv763bed2036446901@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 8:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-11-12 at 20:18 +0100, Matteo Croce wrote:
>
>> # echo scan >/sys/kernel/debug/kmemleak ; cat
>> /sys/kernel/debug/kmemleak
>> kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>> unreferenced object 0xc5cfea80 (size 192):
>>   comm "softirq", pid 0, jiffies 14191
>>   backtrace:
>>     [<ffffffff>] 0xffffffff
>
> that's kinda useless, can you run
>
> for slab in /sys/kernel/slab/* ; do echo $(cat $slab/objects) in $slab ; done|sort -n
>
> and tell us which one increases most?
>
> johannes
>

kmalloc-64 is definitely getting fat

root@alix:~/leak# diff -u leak.1 leak.3
--- leak.1      2000-01-01 01:19:56.817434067 +0100
+++ leak.3      2000-01-01 01:29:48.917438188 +0100
@@ -55,56 +55,56 @@
 21 in /sys/kernel/slab/sigqueue
 22 in /sys/kernel/slab/files_cache
 24 in /sys/kernel/slab/sock_inode_cache
+25 in /sys/kernel/slab/bio-0
 25 in /sys/kernel/slab/ext4_alloc_context
 25 in /sys/kernel/slab/scsi_sense_cache
 26 in /sys/kernel/slab/cfq_queue
-27 in /sys/kernel/slab/bio-0
 28 in /sys/kernel/slab/file_lock_cache
 30 in /sys/kernel/slab/cfq_io_context
 30 in /sys/kernel/slab/kmalloc-2048
 33 in /sys/kernel/slab/task_xstate
 36 in /sys/kernel/slab/ext4_prealloc_space
-36 in /sys/kernel/slab/sighand_cache
 37 in /sys/kernel/slab/signal_cache
 39 in /sys/kernel/slab/inotify_inode_mark_entry
 39 in /sys/kernel/slab/jbd2_journal_head
 42 in /sys/kernel/slab/fib6_nodes
 42 in /sys/kernel/slab/fs_cache
 42 in /sys/kernel/slab/inet_peer_cache
+42 in /sys/kernel/slab/sighand_cache
 42 in /sys/kernel/slab/task_struct
 42 in /sys/kernel/slab/uid_cache
 46 in /sys/kernel/slab/blkdev_ioc
 51 in /sys/kernel/slab/ext4_free_block_extents
 51 in /sys/kernel/slab/ip_fib_hash
 51 in /sys/kernel/slab/sd_ext_cdb
-64 in /sys/kernel/slab/cred_jar
 64 in /sys/kernel/slab/jbd2_journal_handle
 64 in /sys/kernel/slab/jbd2_revoke_record
 64 in /sys/kernel/slab/pid
+65 in /sys/kernel/slab/cred_jar
 68 in /sys/kernel/slab/kmalloc-128
 73 in /sys/kernel/slab/jbd2_revoke_table
-82 in /sys/kernel/slab/kmalloc-1024
+81 in /sys/kernel/slab/kmalloc-1024
 87 in /sys/kernel/slab/kmalloc-512
 102 in /sys/kernel/slab/kmalloc-192
 128 in /sys/kernel/slab/kmemleak_scan_area
 142 in /sys/kernel/slab/kmalloc-256
 147 in /sys/kernel/slab/idr_layer_cache
 152 in /sys/kernel/slab/proc_inode_cache
-154 in /sys/kernel/slab/filp
+161 in /sys/kernel/slab/filp
 203 in /sys/kernel/slab/anon_vma
 265 in /sys/kernel/slab/shmem_inode_cache
 334 in /sys/kernel/slab/kmalloc-96
 400 in /sys/kernel/slab/kmalloc-32
-460 in /sys/kernel/slab/vm_area_struct
-503 in /sys/kernel/slab/radix_tree_node
+453 in /sys/kernel/slab/vm_area_struct
 513 in /sys/kernel/slab/kmalloc-8192
-515 in /sys/kernel/slab/skbuff_head_cache
+513 in /sys/kernel/slab/skbuff_head_cache
+517 in /sys/kernel/slab/radix_tree_node
 546 in /sys/kernel/slab/inode_cache
 767 in /sys/kernel/slab/kmalloc-16
-795 in /sys/kernel/slab/ext4_inode_cache
+825 in /sys/kernel/slab/ext4_inode_cache
 1019 in /sys/kernel/slab/kmalloc-8
-2088 in /sys/kernel/slab/buffer_head
-2916 in /sys/kernel/slab/dentry
+2225 in /sys/kernel/slab/buffer_head
+2967 in /sys/kernel/slab/dentry
 7088 in /sys/kernel/slab/sysfs_dir_cache
-56194 in /sys/kernel/slab/kmalloc-64
-75769 in /sys/kernel/slab/kmemleak_object
+113649 in /sys/kernel/slab/kmalloc-64
+133459 in /sys/kernel/slab/kmemleak_object
