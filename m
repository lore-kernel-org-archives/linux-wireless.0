Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63560 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3BBXRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 18:17:08 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so5281502obc.13
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2013 15:17:07 -0800 (PST)
Message-ID: <510D9E71.2080300@lwfinger.net> (sfid-20130203_001718_948823_7307AD73)
Date: Sat, 02 Feb 2013 17:17:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Memory leak in cfg80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

A recent change to cfg80211 has resulted in kmemleak reporting a new leak:

unreferenced object 0xffff8800b24cba80 (size 192):
   comm "kworker/1:0", pid 13, jiffies 4294899104 (age 5432.336s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 00 00 55 53 00 00 d0 a6 24 00 40 b8 25 00  ....US....$.@.%.
   backtrace:
     [<ffffffff81444cf1>] kmemleak_alloc+0x21/0x50
     [<ffffffff81147770>] __kmalloc+0x130/0x2c0
     [<ffffffffa02b93e3>] reg_copy_regd+0x23/0xa0 [cfg80211]
     [<ffffffffa02ba5e2>] reg_todo+0x3d2/0x5a0 [cfg80211]
     [<ffffffff81063cdd>] process_one_work+0x19d/0x6f0
     [<ffffffff81064605>] worker_thread+0x155/0x400
     [<ffffffff81069b56>] kthread+0xd6/0xe0
     [<ffffffff8145ba7c>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff

The traceback points back to the call at line 353 of net/wireless/reg.c where 
the regd space is allocated.

I verified that the memory is still allocated after unloading cfg80211. This is 
not a false report from kmemleak.

Thanks,

Larry



