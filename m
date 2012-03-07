Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:48603 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031691Ab2CGBB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 20:01:59 -0500
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: driver-ops.h:10 -- how do I fix this?
Date: Wed, 7 Mar 2012 01:01:57 +0000
Message-ID: <42A9DDDF-0364-49F2-AACE-FBB8B72D573C@watchguard.com> (sfid-20120307_020214_401052_70E39319)
References: <461155E6-5B2C-48C3-AD1C-4D07B6EECE4B@watchguard.com>
 (sfid-20120306_014028_944755_47BCD942)
 <1331022766.3447.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331022766.3447.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 6, 2012, at 12:32 AM, Johannes Berg wrote:

> On Tue, 2012-03-06 at 00:40 +0000, Bryan Phillippe wrote:
>> on compat-wireless-2012-02-06 as well as compat-wireless-3.3-rc1-2, I see this:
>> 
>> WARNING: at ath9k/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_notify+0x150/0x18c [mac80211]()
>> 
>> any time I change from one band to another.  How do I fix this?
> 
> Post the full warning and then we can see if we can figure it out.
> 
> johannes

Hi Johannes,

Here are some examples:

Feb 13 05:29:48 2012 mybox local0.emerg kernel: [  266.700780] ------------[ cut here ]------------
Feb 13 05:29:48 2012 mybox local0.err kernel: [  266.705424] Badness at net/mac80211/driver-ops.h:10
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705439] NIP: f2bd32b0 LR: f2bd32a4 CTR: a03fde5c
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705453] REGS: cfa31a80 TRAP: 0700   Tainted: P             (2.6.35.12)
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705463] MSR: 00029000 <EE,ME,CE>  CR: 28022422  XER: 00000000
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705489] TASK = c850dbc0[1727] 'hostapd' THREAD: cfa30000 CPU: 1
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705501] GPR00: 00000001 cfa31b30 c850dbc0 00000000 00000002 cfa31b78 d3bf2254 cfa31bbc
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705529] GPR08: c844bc10 00000000 00000000 a03fde5c 28022428 100773cc 00000000 10005060
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705557] GPR16: 100700e8 1004bb3c 00000000 00000000 00000000 00000000 cfa31dec 00000024
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705585] GPR24: 00000000 00000004 00000014 cfa31ba8 cdf307e0 cdc4ca80 00000002 cde75360
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705650] NIP [f2bd32b0] ieee80211_bss_info_change_notify+0x11c/0x308 [mac80211]
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705674] LR [f2bd32a4] ieee80211_bss_info_change_notify+0x110/0x308 [mac80211]
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705684] Call Trace:
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705704] [cfa31b30] [f2bd32a4] ieee80211_bss_info_change_notify+0x110/0x308 [mac80211] (unreliable)
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705738] [cfa31b50] [f2bec174] ieee80211_aes_cmac+0x1678/0x4758 [mac80211]
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705775] [cfa31b70] [f2b5ab20] nl80211_init+0x6a8/0x4f94 [cfg80211]
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705799] [cfa31ba0] [f2b10450] compat_vzalloc+0x1a4/0x284 [compat]
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705824] [cfa31be0] [a0334a4c] genl_rcv_msg+0x1f8/0x21c
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705840] [cfa31c30] [a0332ae0] netlink_rcv_skb+0xe0/0x108
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705856] [cfa31c50] [a0334844] genl_rcv+0x24/0x34
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705872] [cfa31c60] [a03325d0] netlink_unicast+0x380/0x3cc
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705888] [cfa31ca0] [a0333160] netlink_sendmsg+0x250/0x398
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705914] [cfa31cf0] [a02f9e28] sock_sendmsg+0x90/0xc8
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705931] [cfa31dc0] [a02fa668] sys_sendmsg+0x234/0x2d8
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705950] [cfa31f10] [a02fc03c] sys_socketcall+0x144/0x258
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.705973] [cfa31f40] [a0012000] ret_from_syscall+0x0/0x3c
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.706090] --- Exception: c01 at 0xfd16088
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.706095]     LR = 0xffd7d28
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.706102] Instruction dump:
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.706113] 419e00c0 0fe00000 48000018 39200000 912304a8 4bffff88 38000000 981f04b3
Feb 13 05:29:48 2012 mybox local0.warn kernel: [  266.706143] 48033c29 801f01cc 68000020 5400dffe <0f000000> 813d0054 80090020 2f800000
Feb 13 05:29:48 2012 mybox local0.emerg kernel: [  266.707407] ------------[ cut here ]------------


--
-bp

