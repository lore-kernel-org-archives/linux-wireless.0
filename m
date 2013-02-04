Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56673 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3BDTbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 14:31:31 -0500
Received: by mail-oa0-f43.google.com with SMTP id l10so6987584oag.30
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 11:31:29 -0800 (PST)
Message-ID: <51100C8E.6040502@lwfinger.net> (sfid-20130204_203135_182820_45DC56B5)
Date: Mon, 04 Feb 2013 13:31:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@do-not-panic.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory leak in cfg80211
References: <510D9E71.2080300@lwfinger.net>  (sfid-20130203_001709_849515_E1CDB041) <1359998652.17993.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359998652.17993.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

You got it right. I got two tracebacks as follows:

[   22.147978] cfg80211: wiphy->regd changed at line 1459: old           (null), 
new: ffff8800b1e25a80
[   22.147982] Pid: 292, comm: kworker/1:1 Not tainted 3.8.0-rc6-wl+ #96
[   22.147985] Call Trace:
[   22.148032]  [<ffffffffa03c6623>] reg_todo+0x403/0x5e0 [cfg80211]
[   22.148088]  [<ffffffff81063cdd>] process_one_work+0x19d/0x6f0
[   22.148098]  [<ffffffff81063c70>] ? process_one_work+0x130/0x6f0
[   22.148103]  [<ffffffff810ba840>] ? cgroup_path+0x170/0x170
[   22.148120]  [<ffffffffa03c6220>] ? regdom_changes+0x50/0x50 [cfg80211]
[   22.148128]  [<ffffffff81064605>] worker_thread+0x155/0x400
[   22.148134]  [<ffffffff810a568d>] ? trace_hardirqs_on+0xd/0x10
[   22.148139]  [<ffffffff810644b0>] ? rescuer_thread+0x240/0x240
[   22.148144]  [<ffffffff81069b56>] kthread+0xd6/0xe0
[   22.148150]  [<ffffffff8145acab>] ? _raw_spin_unlock_irq+0x2b/0x50
[   22.148155]  [<ffffffff81069a80>] ? __init_kthread_worker+0x70/0x70
[   22.148160]  [<ffffffff8145ba7c>] ret_from_fork+0x7c/0xb0
[   22.148164]  [<ffffffff81069a80>] ? __init_kthread_worker+0x70/0x70
[   22.148169] cfg80211: Calling CRDA for country: CN


[   22.161223] cfg80211: request_wiphy->regd changed at line 2199: old 
ffff8800b1e25a80, new: ffff8800b61c66c0
[   22.161230] Pid: 2377, comm: crda Not tainted 3.8.0-rc6-wl+ #96
[   22.161233] Call Trace:
[   22.161275]  [<ffffffffa03c76fc>] set_regdom+0x6dc/0x750 [cfg80211]
[   22.161293]  [<ffffffffa03d1f56>] nl80211_set_reg+0x236/0x2a0 [cfg80211]
[   22.161302]  [<ffffffff813d2e24>] genl_rcv_msg+0x274/0x2b0
[   22.161306]  [<ffffffff813d2bb0>] ? genl_rcv+0x30/0x30
[   22.161311]  [<ffffffff813d20b9>] netlink_rcv_skb+0xa9/0xc0
[   22.161315]  [<ffffffff813d2ba0>] genl_rcv+0x20/0x30
[   22.161319]  [<ffffffff813d1a0b>] netlink_unicast+0x19b/0x220
[   22.161324]  [<ffffffff813d1e76>] netlink_sendmsg+0x336/0x3b0
[   22.161329]  [<ffffffff81390b17>] sock_sendmsg+0x87/0xa0
[   22.161335]  [<ffffffff81127aa7>] ? might_fault+0x57/0xb0
[   22.161340]  [<ffffffff81390fcc>] __sys_sendmsg+0x37c/0x390
[   22.161345]  [<ffffffff8106f9be>] ? up_read+0x1e/0x40
[   22.161350]  [<ffffffff81033b3c>] ? __do_page_fault+0x1fc/0x500
[   22.161356]  [<ffffffff8116f1aa>] ? fget_light+0x3da/0x4d0
[   22.161359]  [<ffffffff81393f08>] ? sys_getsockname+0xb8/0xc0
[   22.161363]  [<ffffffff813944e4>] sys_sendmsg+0x44/0x80
[   22.161368]  [<ffffffff8145bb29>] system_call_fastpath+0x16/0x1b

The second one replaced a non-NULL pointer, and kmemleak confirms that it is the 
leaked block.

larrylap:~ # cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8800b1e25a80 (size 192):
   comm "kworker/1:1", pid 292, jiffies 4294897832 (age 3645.856s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 00 00 55 53 00 00 d0 a6 24 00 40 b8 25 00  ....US....$.@.%.
   backtrace:
     [<ffffffff81444cf1>] kmemleak_alloc+0x21/0x50
     [<ffffffff81147770>] __kmalloc+0x130/0x2c0
     [<ffffffffa03c5473>] reg_copy_regd+0x23/0xa0 [cfg80211]
     [<ffffffffa03c65f2>] reg_todo+0x3d2/0x5e0 [cfg80211]
     [<ffffffff81063cdd>] process_one_work+0x19d/0x6f0
     [<ffffffff81064605>] worker_thread+0x155/0x400
     [<ffffffff81069b56>] kthread+0xd6/0xe0
     [<ffffffff8145ba7c>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff
larrylap:~ #

This leak seems to occur because I am loading cfg80211 with the regdom set to 
"US"; however, the driver is forcing "CN". That is my penalty for buying the 
adapter on Ebay; however, I think my setting should override that of the driver, 
which might be a separate bug. I'm OK as long as there are no FCC inspectors in 
my neighborhood to see that I am sending out probes on channels 12 and 13.

I am only vaguely familiar with the rcu routines. Is it sufficient to do the 
simple kfree() before the rcu_assign_pointer() call, or is it necessary to make 
an rcu_lock() call as well? If a simple kfree() is all that is needed, then the 
following patch should be OK. If is is, I'll do some testing and do a proper 
submission later:

Index: wireless-testing-new/net/wireless/reg.c
===================================================================
--- wireless-testing-new.orig/net/wireless/reg.c
+++ wireless-testing-new/net/wireless/reg.c
@@ -2189,10 +2189,12 @@ static int __set_regdom(const struct iee
                  * However if a driver requested this specific regulatory
                  * domain we keep it for its private use
                  */
-               if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER)
+               if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
+                       kfree(request_wiphy->regd);
                         rcu_assign_pointer(request_wiphy->regd, rd);
-               else
+               } else {
                         kfree(rd);
+               }

                 rd = NULL;

Larry

