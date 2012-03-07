Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2CGIQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 03:16:26 -0500
Subject: Re: WARNING: driver-ops.h:10 -- how do I fix this?
From: Johannes Berg <johannes@sipsolutions.net>
To: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <42A9DDDF-0364-49F2-AACE-FBB8B72D573C@watchguard.com>
References: <461155E6-5B2C-48C3-AD1C-4D07B6EECE4B@watchguard.com>
	 (sfid-20120306_014028_944755_47BCD942) <1331022766.3447.4.camel@jlt3.sipsolutions.net>
	 <42A9DDDF-0364-49F2-AACE-FBB8B72D573C@watchguard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 09:16:23 +0100
Message-ID: <1331108183.3519.6.camel@jlt3.sipsolutions.net> (sfid-20120307_091629_704937_EAEF19B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-07 at 01:01 +0000, Bryan Phillippe wrote:

> Feb 13 05:29:48 2012 mybox local0.emerg kernel: [  266.700780] ------------[ cut here ]------------
> Feb 13 05:29:48 2012 mybox local0.err kernel: [  266.705424] Badness at net/mac80211/driver-ops.h:10
...
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705650] NIP [f2bd32b0] ieee80211_bss_info_change_notify+0x11c/0x308 [mac80211]
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705674] LR [f2bd32a4] ieee80211_bss_info_change_notify+0x110/0x308 [mac80211]
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705684] Call Trace:
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705704] [cfa31b30] [f2bd32a4] ieee80211_bss_info_change_notify+0x110/0x308 [mac80211] (unreliable)
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705738] [cfa31b50] [f2bec174] ieee80211_aes_cmac+0x1678/0x4758 [mac80211]
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705775] [cfa31b70] [f2b5ab20] nl80211_init+0x6a8/0x4f94 [cfg80211]
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705799] [cfa31ba0] [f2b10450] compat_vzalloc+0x1a4/0x284 [compat]
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705824] [cfa31be0] [a0334a4c] genl_rcv_msg+0x1f8/0x21c
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705840] [cfa31c30] [a0332ae0] netlink_rcv_skb+0xe0/0x108
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705856] [cfa31c50] [a0334844] genl_rcv+0x24/0x34
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705872] [cfa31c60] [a03325d0] netlink_unicast+0x380/0x3cc
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705888] [cfa31ca0] [a0333160] netlink_sendmsg+0x250/0x398
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705914] [cfa31cf0] [a02f9e28] sock_sendmsg+0x90/0xc8
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705931] [cfa31dc0] [a02fa668] sys_sendmsg+0x234/0x2d8
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705950] [cfa31f10] [a02fc03c] sys_socketcall+0x144/0x258
> Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705973] [cfa31f40] [a0012000] ret_from_syscall+0x0/0x3c

Umm, unfortunately that makes no sense at all and isn't really helpful.

Do you have CONFIG_FRAME_POINTER=y set in your kernel (not compat)?

johannes

