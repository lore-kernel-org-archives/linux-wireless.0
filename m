Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 208.36.103.2.ptr.us.xo.net ([208.36.103.2]:56778 "EHLO
	iris.cobite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359AbYBAPfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 10:35:24 -0500
Received: from localhost (iris.cobite.com [127.0.0.1])
	by iris.cobite.com (Postfix) with ESMTP id BCADC53E6A
	for <linux-wireless@vger.kernel.org>; Fri,  1 Feb 2008 10:11:32 -0500 (EST)
Received: from iris.cobite.com ([127.0.0.1])
	by localhost (iris.cobite.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mVsp-Fpm-JyV for <linux-wireless@vger.kernel.org>;
	Fri,  1 Feb 2008 10:11:26 -0500 (EST)
Received: from [208.222.80.105] (208.36.103.2.ptr.us.xo.net [208.36.103.2])
	by iris.cobite.com (Postfix) with ESMTP id 0AEF053E6D
	for <linux-wireless@vger.kernel.org>; Fri,  1 Feb 2008 10:11:26 -0500 (EST)
Subject: repeatable rmmod/ksofitirqd hang with rtl8187
From: David Mansfield <david@cobite.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 01 Feb 2008 10:11:25 -0500
Message-Id: <1201878685.18907.54.camel@gandalf.cobite.com> (sfid-20080201_153554_599048_343FE3C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I'm trying to use the rtl8187 in the Fedora 8 kernel 2.6.23.14-107.fc8
on x86_64 and I'm having a number of problems with reliability.
However, the most obvious problem is that the module cannot be removed.

Attempting to rmmod the rtl8187 causes rmmod and ksoftirqd to go to 100%
every time.

The nvidia driver is loaded, but I can reproduce without it, and will do
so and repost logs if necessary (easily).  Also, I could switch to
another kernel version (non-Fedora) if necessary (harder).

The last message relevant to the removal in the log is:

usbcore: deregistering interface driver rtl8187

I have a sysrq-Tasks dump also, and I'll try to paste the 'relevant'
portions, but if you want something else, let me know:

Jan 30 07:22:08 localhost kernel: rtl8187       S 0000000000000000     0  3080      2
Jan 30 07:22:08 localhost kernel:  ffff8100582d3ee0 0000000000000046 0000000000000000 ffffffff8101bdf7
Jan 30 07:22:08 localhost kernel:  ffff8100622f8820 ffffffff81370660 ffff8100622f8a98 ffffffff81370660
Jan 30 07:22:08 localhost kernel:  ffffffffffffffff ffff81006add7000 0000000000000000 0000000000000000
Jan 30 07:22:08 localhost kernel: Call Trace:
Jan 30 07:22:08 localhost kernel:  [<ffffffff8101bdf7>] lapic_next_event+0x0/0xa
Jan 30 07:22:08 localhost kernel:  [<ffffffff810465f9>] worker_thread+0x0/0xe4
Jan 30 07:22:08 localhost kernel:  [<ffffffff8104669a>] worker_thread+0xa1/0xe4
Jan 30 07:22:08 localhost kernel:  [<ffffffff810493f5>] autoremove_wake_function+0x0/0x2e
Jan 30 07:22:08 localhost kernel:  [<ffffffff810492a0>] kthread+0x47/0x73
Jan 30 07:22:08 localhost kernel:  [<ffffffff8100c9e8>] child_rip+0xa/0x12
Jan 30 07:22:08 localhost kernel:  [<ffffffff810f26fa>] dummy_d_instantiate+0x0/0x1
Jan 30 07:22:08 localhost kernel:  [<ffffffff81049259>] kthread+0x0/0x73
Jan 30 07:22:08 localhost kernel:  [<ffffffff8100c9de>] child_rip+0x0/0x12

Jan 30 07:22:08 localhost kernel: rmmod         R  running task        0  5444   5331

(yes, there is NO call stack listed for rmmod...)

Jan 30 07:22:08 localhost kernel: cpu#0, 2800.262 MHz
Jan 30 07:22:08 localhost kernel:   .nr_running                    : 1
Jan 30 07:22:08 localhost kernel:   .load                          : 3121
Jan 30 07:22:08 localhost kernel:   .ls.delta_fair                 : 2409554145852
Jan 30 07:22:08 localhost kernel:   .ls.delta_exec                 : 1870680954585
Jan 30 07:22:08 localhost kernel:   .nr_switches                   : 5248144
Jan 30 07:22:08 localhost kernel:   .nr_load_updates               : 1871123
Jan 30 07:22:08 localhost kernel:   .nr_uninterruptible            : 4593
Jan 30 07:22:08 localhost kernel:   .jiffies                       : 4321958165
Jan 30 07:22:08 localhost kernel:   .next_balance                  : 4321958387
Jan 30 07:22:08 localhost kernel:   .curr->pid                     : 4
Jan 30 07:22:08 localhost kernel:   .clock                         : 1870843827954
Jan 30 07:22:08 localhost kernel:   .idle_clock                    : 0
Jan 30 07:22:08 localhost kernel:   .prev_clock_raw                : 10156683955881
Jan 30 07:22:08 localhost kernel:   .clock_warps                   : 0
Jan 30 07:22:08 localhost kernel:   .clock_overflows               : 5843715
Jan 30 07:22:08 localhost kernel:   .clock_deep_idle_events        : 0
Jan 30 07:22:08 localhost kernel:   .clock_max_delta               : 999848
Jan 30 07:22:08 localhost kernel:   .cpu_load[0]                   : 3121
Jan 30 07:22:08 localhost kernel:   .cpu_load[1]                   : 3121
Jan 30 07:22:08 localhost kernel:   .cpu_load[2]                   : 3121
Jan 30 07:22:08 localhost kernel:   .cpu_load[3]                   : 3121
Jan 30 07:22:08 localhost kernel:   .cpu_load[4]                   : 3121
Jan 30 07:22:08 localhost kernel: cfs_rq
Jan 30 07:22:08 localhost kernel:   .fair_clock                    : 730253466918
Jan 30 07:22:08 localhost kernel:   .exec_clock                    : 449856607964
Jan 30 07:22:08 localhost kernel:   .wait_runtime                  : -39097530
Jan 30 07:22:08 localhost kernel:   .wait_runtime_overruns         : 667096
Jan 30 07:22:08 localhost kernel:   .wait_runtime_underruns        : 116653
Jan 30 07:22:08 localhost kernel:   .sleeper_bonus                 : 3819331
Jan 30 07:22:08 localhost kernel:   .wait_runtime_rq_sum           : -39097530
Jan 30 07:22:08 localhost kernel: 
Jan 30 07:22:08 localhost kernel: runnable tasks:
Jan 30 07:22:08 localhost kernel:             task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
Jan 30 07:22:08 localhost kernel: ------------------------------------------------------------------------------------------------------------------------------------------------------------------
Jan 30 07:22:08 localhost kernel: R    ksoftirqd/0     4    730266294816      12827898     -39097530    113821   115     94706931241    493479775956   1771180094381           81609             858
Jan 30 07:22:08 localhost kernel: 
Jan 30 07:22:08 localhost kernel: cpu#1, 2800.262 MHz
Jan 30 07:22:08 localhost kernel:   .nr_running                    : 2
Jan 30 07:22:08 localhost kernel:   .load                          : 2048
Jan 30 07:22:08 localhost kernel:   .ls.delta_fair                 : 2449895038018
Jan 30 07:22:08 localhost kernel:   .ls.delta_exec                 : 1815567039057
Jan 30 07:22:08 localhost kernel:   .nr_switches                   : 8682134
Jan 30 07:22:08 localhost kernel:   .nr_load_updates               : 1815833
Jan 30 07:22:08 localhost kernel:   .nr_uninterruptible            : -4593
Jan 30 07:22:08 localhost kernel:   .jiffies                       : 4321958165
Jan 30 07:22:08 localhost kernel:   .next_balance                  : 4321958156
Jan 30 07:22:08 localhost kernel:   .curr->pid                     : 5444
Jan 30 07:22:08 localhost kernel:   .clock                         : 1815564248632
Jan 30 07:22:08 localhost kernel:   .idle_clock                    : 0
Jan 30 07:22:08 localhost kernel:   .prev_clock_raw                : 10156680908921
Jan 30 07:22:08 localhost kernel:   .clock_warps                   : 0
Jan 30 07:22:08 localhost kernel:   .clock_overflows               : 7745757
Jan 30 07:22:08 localhost kernel:   .clock_deep_idle_events        : 0
Jan 30 07:22:08 localhost kernel:   .clock_max_delta               : 999845
Jan 30 07:22:08 localhost kernel:   .cpu_load[0]                   : 2048
Jan 30 07:22:08 localhost kernel:   .cpu_load[1]                   : 1536
Jan 30 07:22:08 localhost kernel:   .cpu_load[2]                   : 1280
Jan 30 07:22:08 localhost kernel:   .cpu_load[3]                   : 1152
Jan 30 07:22:08 localhost kernel:   .cpu_load[4]                   : 1088
Jan 30 07:22:08 localhost kernel: 
Jan 30 07:22:08 localhost kernel: cfs_rq
Jan 30 07:22:08 localhost kernel:   .fair_clock                    : 1076180297717
Jan 30 07:22:08 localhost kernel:   .exec_clock                    : 718056819036
Jan 30 07:22:08 localhost kernel:   .wait_runtime                  : 0
Jan 30 07:22:08 localhost kernel:   .wait_runtime_overruns         : 681220
Jan 30 07:22:08 localhost kernel:   .wait_runtime_underruns        : 8611457
Jan 30 07:22:08 localhost kernel:   .sleeper_bonus                 : 3936098
Jan 30 07:22:08 localhost kernel:   .wait_runtime_rq_sum           : 0
Jan 30 07:22:08 localhost kernel: 
Jan 30 07:22:08 localhost kernel: runnable tasks:
Jan 30 07:22:08 localhost kernel:             task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
Jan 30 07:22:08 localhost kernel: ------------------------------------------------------------------------------------------------------------------------------------------------------------------
Jan 30 07:22:08 localhost kernel:           rklogd  2140   1076140201263     -40096454      40000000       306   120        16714625      1164181473   1800696827984              34               0
Jan 30 07:22:08 localhost kernel: R          rmmod  5444   1076220297717      40000000     -40000000      6021   120     84558667512     -1817731300           37707               0         8536283
Jan 30 07:22:08 localhost kernel: 



