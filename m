Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34004 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZKLWJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 17:09:11 -0500
Received: by fxm21 with SMTP id 21so2786833fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 14:09:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258054304.3899.36.camel@johannes.local>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 12 Nov 2009 23:08:56 +0100
Message-ID: <40101cc30911121408v332192ccxdfccd2b018c2b2ac@mail.gmail.com>
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

# diff -u leak.1 leak.2
--- leak.1      2000-01-01 01:19:56.817434067 +0100
+++ leak.2      2000-01-01 01:20:45.447434308 +0100
@@ -77,10 +77,10 @@
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
 82 in /sys/kernel/slab/kmalloc-1024
@@ -90,21 +90,21 @@
 142 in /sys/kernel/slab/kmalloc-256
 147 in /sys/kernel/slab/idr_layer_cache
 152 in /sys/kernel/slab/proc_inode_cache
-154 in /sys/kernel/slab/filp
+157 in /sys/kernel/slab/filp
 203 in /sys/kernel/slab/anon_vma
 265 in /sys/kernel/slab/shmem_inode_cache
 334 in /sys/kernel/slab/kmalloc-96
 400 in /sys/kernel/slab/kmalloc-32
-460 in /sys/kernel/slab/vm_area_struct
-503 in /sys/kernel/slab/radix_tree_node
+467 in /sys/kernel/slab/vm_area_struct
+507 in /sys/kernel/slab/radix_tree_node
 513 in /sys/kernel/slab/kmalloc-8192
 515 in /sys/kernel/slab/skbuff_head_cache
 546 in /sys/kernel/slab/inode_cache
 767 in /sys/kernel/slab/kmalloc-16
 795 in /sys/kernel/slab/ext4_inode_cache
 1019 in /sys/kernel/slab/kmalloc-8
-2088 in /sys/kernel/slab/buffer_head
+2135 in /sys/kernel/slab/buffer_head
 2916 in /sys/kernel/slab/dentry
 7088 in /sys/kernel/slab/sysfs_dir_cache
-56194 in /sys/kernel/slab/kmalloc-64
-75769 in /sys/kernel/slab/kmemleak_object
+61054 in /sys/kernel/slab/kmalloc-64
+80680 in /sys/kernel/slab/kmemleak_object
