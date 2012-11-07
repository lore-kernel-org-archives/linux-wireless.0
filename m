Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35428 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2KGL3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 06:29:40 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so630307bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2012 03:29:38 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 12:29:38 +0100
Message-ID: <CAKkO-EiJfYeHHvZSAGFApVt+cA1sOQULWWn87b7Vw990cwbtxw@mail.gmail.com> (sfid-20121107_122952_212353_A6EAA0A1)
Subject: PROBLEM: kernel panic in module ath5k
From: Luigi Tarenga <luigi.tarenga@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I have a laptop configured as AP running on centos 6.3 with vanilla
kernel 3.6.6.
I got a system crash and with kdump configured I now have a vmcore to analize.

Unfortunally the kernel that went on panic have debuginfo disabled. I recompiled
the same kernel with debuginfo enabled and all the output I post here is based
on the latter. I say this to explain the warning from crash command:
WARNING: kernel version inconsistency between vmlinux and dumpfile

I post here only the backtrace. If anyone is interested in
investigation I will post
more info. Just let me know what should I extract.

regards
Luigi

--- here the backtrace ---

[root@pack ~]# crash  /boot/vmlinux-3.6.6-v2.bz2
/var/crash/127.0.0.1-2012-11-06-11\:30\:19/vmcore

crash 6.1.0
Copyright (C) 2002-2012  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006, 2010  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005, 2006, 2011, 2012  Fujitsu Limited
Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
Copyright (C) 2005, 2011  NEC Corporation
Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for details.

GNU gdb (GDB) 7.3.1
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu"...

WARNING: kernel version inconsistency between vmlinux and dumpfile

crash: cannot determine thread return address
      KERNEL: /boot/vmlinux-3.6.6-v2.bz2
    DUMPFILE: /var/crash/127.0.0.1-2012-11-06-11:30:19/vmcore  [PARTIAL DUMP]
        CPUS: 2
        DATE: Tue Nov  6 11:30:11 2012
      UPTIME: 00:39:45
LOAD AVERAGE: 0.03, 0.02, 0.05
       TASKS: 72
    NODENAME: pack.this.lan
     RELEASE: 3.6.6-v1
     VERSION: #1 SMP Mon Nov 5 12:42:37 CET 2012
     MACHINE: x86_64  (1695 Mhz)
      MEMORY: 2 GB
       PANIC: ""
         PID: 0
     COMMAND: "swapper/1"
        TASK: ffff88007b0aaf80  (1 of 2)  [THREAD_INFO: ffff88007b0d2000]
         CPU: 1
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 0      TASK: ffff88007b0aaf80  CPU: 1   COMMAND: "swapper/1"
 #0 [ffff88007dd03ae0] machine_kexec at ffffffff8101eaef
 #1 [ffff88007dd03b30] do_kimage_alloc at ffffffff81074f93
 #2 [ffff88007dd03c60] do_general_protection at ffffffff81003984
 #3 [ffff88007dd03c68] rate_control_get_rate at ffffffffa03d26a6 [mac80211]
 #4 [ffff88007dd03d18] __lru_cache_add at ffffffff810a36d0
 #5 [ffff88007dd03d48] skb_copy_and_csum_datagram at ffffffff8120994b
 #6 [ffff88007dd03d88] skb_copy_datagram_iovec at ffffffff81209fc8
 #7 [ffff88007dd03da8] ath5k_txbuf_free_skb at ffffffffa042b2ba [ath5k]
 #8 [ffff88007dd03dc8] ath5k_beacon_update at ffffffffa042beff [ath5k]
 #9 [ffff88007dd03e68] ath5k_beacon_send at ffffffffa042c3cf [ath5k]
#10 [ffff88007dd03e98] ath5k_tasklet_beacon at ffffffffa042c4a9 [ath5k]
#11 [ffff88007dd03eb8] __tasklet_hrtimer_trampoline at ffffffff81034912
#12 [ffff88007dd03ed8] __tasklet_schedule at ffffffff81035000
#13 [ffff88007dd03f00] ack_apic_level at ffffffff8101c0a1
#14 [ffff88007dd03f70] run_ksoftirqd at ffffffff81034e05
#15 [ffff88007dd03f80] fixup_irqs at ffffffff81003e91
--- <IRQ stack> ---
#16 [ffff88007b0d3e28] bad_gs at ffffffff812a50e7
    [exception RIP: poll_idle+20]
    RIP: ffffffff8100afa4  RSP: ffff88007b0d3ed8  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000000000000
    RDX: 0000000000006464  RSI: 0000000000000086  RDI: ffffffff81716a88
    RBP: ffff88007b0d3ed8   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0140000000000000  R12: 00000000ffffffff
    R13: ffff88007b0d3ef4  R14: 0000000000000004  R15: 0000000000011a80
    ORIG_RAX: ffffffffffffff8e  CS: 0010  SS: 0018
#17 [ffff88007b0d3ee0] arch_randomize_brk at ffffffff8100b0b4
#18 [ffff88007b0d3f10] exit_idle at ffffffff8100b296
#19 [ffff88007b0d3f30] __mutex_lock_slowpath at ffffffff8129fa9f
crash>
