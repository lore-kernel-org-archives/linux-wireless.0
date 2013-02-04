Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3BDRXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:23:51 -0500
Message-ID: <1359998652.17993.9.camel@jlt4.sipsolutions.net> (sfid-20130204_182355_007573_DD1A3B45)
Subject: Re: Memory leak in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>, mcgrof@do-not-panic.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Feb 2013 18:24:12 +0100
In-Reply-To: <510D9E71.2080300@lwfinger.net> (sfid-20130203_001709_849515_E1CDB041)
References: <510D9E71.2080300@lwfinger.net>
	 (sfid-20130203_001709_849515_E1CDB041)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

> A recent change to cfg80211 has resulted in kmemleak reporting a new leak:

Curious.

> unreferenced object 0xffff8800b24cba80 (size 192):
>    comm "kworker/1:0", pid 13, jiffies 4294899104 (age 5432.336s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      06 00 00 00 55 53 00 00 d0 a6 24 00 40 b8 25 00  ....US....$.@.%.
>    backtrace:
>      [<ffffffff81444cf1>] kmemleak_alloc+0x21/0x50
>      [<ffffffff81147770>] __kmalloc+0x130/0x2c0
>      [<ffffffffa02b93e3>] reg_copy_regd+0x23/0xa0 [cfg80211]
>      [<ffffffffa02ba5e2>] reg_todo+0x3d2/0x5a0 [cfg80211]
>      [<ffffffff81063cdd>] process_one_work+0x19d/0x6f0
>      [<ffffffff81064605>] worker_thread+0x155/0x400
>      [<ffffffff81069b56>] kthread+0xd6/0xe0
>      [<ffffffff8145ba7c>] ret_from_fork+0x7c/0xb0
>      [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The traceback points back to the call at line 353 of net/wireless/reg.c where 
> the regd space is allocated.

Yeah. The more interesting part (I think) is reg_todo(), which seems it
really is the __regulatory_hint() function, which gets inlined.

Were you able to reproduce this? I don't think I can since my devices
(Intel) don't use wiphy->regd. If you can, maybe you could try to
dump_stack() with the pointer every time wiphy->regd gets assigned, and
also print the old value.

To me, this looks like wiphy->regd gets overwritten without freeing the
old value, but I don't see what recent (since 3.7) change should have
caused this to change behaviour. Luis?

johannes

