Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38995 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0AVWpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:45:52 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYSGA-0003Om-GG
	for linux-wireless@vger.kernel.org; Fri, 22 Jan 2010 23:45:46 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 23:45:46 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 23:45:46 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: Starting hostapd causes kernel panic
Date: Fri, 22 Jan 2010 22:45:23 +0000 (UTC)
Message-ID: <loom.20100122T233720-487@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org> <1264192127.2593.15.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> Would you compile with CONFIG_MAC80211_NOINLINE (may need to enable
> CONFIG_MAC80211_DEBUG_MENU) and give me the stack trace then? But maybe
> I can reproduce it this way.

Hello Johannes,

thats the trace with the patch applied
and enabled CONFIG_MAC80211_NOINLINE / CONFIG_MAC80211_DEBUG_MENU


----------------------------------------

BUG: unable to handle kernel NULL pointer dereference at 00000193
IP: [<c1269d28>] ieee80211_tx_h_select_key+0x118/0x290
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/0000:02:00.0/
firmware/0000:02:00.0/loading
Modules linked in: rt61pci crc_itu_t rt2x00pci rt2x00lib eeprom_93cx6

Pid: 4413, comm: hostapd Not tainted 2.6.33-rc4-wl-47289-gd602bbd-dirty
#29 CN700-8237/
EIP: 0060:[<c1269d28>] EFLAGS: 00210246 CPU: 0
EIP is at ieee80211_tx_h_select_key+0x118/0x290
EAX: 00000040 EBX: f7b43c2c ECX: 00000000 EDX: 00000000
ESI: f7b50b40 EDI: 0000009d EBP: f7b43bf0 ESP: f7b43bd8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process hostapd (pid: 4413, ti=f7b42000 task=f7939500 task.ti=f7b42000)
Stack:
 f6e2605e 000000c0 f7b50b60 f7b43c2c f7b50b40 00000000 f7b43c00 c126b43d
<0> f7b50b60 f78e81e0 f7b43c58 c126b6a3 c11cc278 f7b50b40 f6e27610 f7b43c38
<0> c11cc398 00e26000 f7b50b60 000000c0 f6e26000 f7b50b40 f78e81e0 f79fcac0
Call Trace:
 [<c126b43d>] ? invoke_tx_handlers+0x5d/0x110
 [<c126b6a3>] ? ieee80211_tx+0x53/0x180
 [<c11cc278>] ? skb_release_data+0x68/0xa0
 [<c11cc398>] ? pskb_expand_head+0xe8/0x170
 [<c126b85c>] ? ieee80211_xmit+0x8c/0x180
 [<c126ba34>] ? ieee80211_monitor_start_xmit+0x94/0xc0
 [<c11d3c0d>] ? dev_hard_start_xmit+0x20d/0x2c0
 [<c11cce89>] ? __alloc_skb+0x49/0x130
 [<c11e297c>] ? sch_direct_xmit+0xec/0x140
 [<c11c860a>] ? sock_alloc_send_pskb+0x17a/0x260
 [<c11e2060>] ? pfifo_fast_enqueue+0x0/0x90
 [<c11d3ebd>] ? dev_queue_xmit+0xdd/0x4a0
 [<c12314c3>] ? packet_sendmsg+0x213/0x250
 [<c11c565f>] ? sock_sendmsg+0xaf/0xe0
 [<c11c5539>] ? sock_recvmsg+0xb9/0xe0
 [<c11ce19c>] ? verify_iovec+0x2c/0xa0
 [<c11c5b31>] ? sys_sendmsg+0x111/0x230
 [<c1056c6f>] ? find_get_page+0x1f/0x70
 [<c1057499>] ? filemap_fault+0x69/0x340
 [<c1056f6d>] ? unlock_page+0x3d/0x40
 [<c1066fe0>] ? __do_fault+0x2a0/0x380
 [<c106804b>] ? handle_mm_fault+0x13b/0x850
 [<c11c6f1c>] ? sys_socketcall+0xdc/0x290
 [<c1078467>] ? filp_close+0x47/0x70
 [<c1002990>] ? sysenter_do_call+0x12/0x26
Code: 08 74 28 83 e1 0c 8b 33 8b 53 0c 75 15 85 d2 74 11 9c 58 fa 8b 52 34 50
9d 80 e6 04 0f 85 d1 00 00 00 c7 43 10 00 00 00 00 31 d2 <f6> 82 93 01 00 00
10 0f 84 6c ff ff ff 8b 4d e8 0f b7 01 a8 0c
EIP: [<c1269d28>] ieee80211_tx_h_select_key+0x118/0x290 SS:ESP 0068:f7b43bd8
CR2: 0000000000000193
---[ end trace 39e7e2685e5534c9 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 4413, comm: hostapd Tainted: G      D    2.6.33-rc4-wl-47289-gd602bbd
-dirty #29
Call Trace:
 [<c1277c35>] ? printk+0x18/0x1b
 [<c1277b6e>] panic+0x43/0xf2
 [<c10054ee>] oops_end+0x7e/0x90
 [<c101a8ae>] no_context+0xbe/0x150
 [<c101a98f>] __bad_area_nosemaphore+0x4f/0x180
 [<c103a01a>] ? __remove_hrtimer+0x2a/0x90
 [<c103a0f1>] ? hrtimer_cancel+0x11/0x20
 [<c1278b3d>] ? schedule_hrtimeout_range+0xad/0x110
 [<c1039f10>] ? hrtimer_wakeup+0x0/0x20
 [<c108763f>] ? poll_freewait+0x3f/0xa0
 [<c101aad2>] bad_area_nosemaphore+0x12/0x20
 [<c101aeb4>] do_page_fault+0x254/0x2f0
 [<c101ac60>] ? do_page_fault+0x0/0x2f0
 [<c12798e6>] error_code+0x5e/0x64
 [<c101ac60>] ? do_page_fault+0x0/0x2f0
 [<c1269d28>] ? ieee80211_tx_h_select_key+0x118/0x290
 [<c126b43d>] invoke_tx_handlers+0x5d/0x110
 [<c126b6a3>] ieee80211_tx+0x53/0x180
 [<c11cc278>] ? skb_release_data+0x68/0xa0
 [<c11cc398>] ? pskb_expand_head+0xe8/0x170
 [<c126b85c>] ieee80211_xmit+0x8c/0x180
 [<c126ba34>] ieee80211_monitor_start_xmit+0x94/0xc0
 [<c11d3c0d>] dev_hard_start_xmit+0x20d/0x2c0
 [<c11cce89>] ? __alloc_skb+0x49/0x130
 [<c11e297c>] sch_direct_xmit+0xec/0x140
 [<c11c860a>] ? sock_alloc_send_pskb+0x17a/0x260
 [<c11e2060>] ? pfifo_fast_enqueue+0x0/0x90
 [<c11d3ebd>] dev_queue_xmit+0xdd/0x4a0
 [<c12314c3>] packet_sendmsg+0x213/0x250
 [<c11c565f>] sock_sendmsg+0xaf/0xe0
 [<c11c5539>] ? sock_recvmsg+0xb9/0xe0
 [<c11ce19c>] ? verify_iovec+0x2c/0xa0
 [<c11c5b31>] sys_sendmsg+0x111/0x230
 [<c1056c6f>] ? find_get_page+0x1f/0x70
 [<c1057499>] ? filemap_fault+0x69/0x340
 [<c1056f6d>] ? unlock_page+0x3d/0x40
 [<c1066fe0>] ? __do_fault+0x2a0/0x380
 [<c106804b>] ? handle_mm_fault+0x13b/0x850
 [<c11c6f1c>] sys_socketcall+0xdc/0x290
 [<c1078467>] ? filp_close+0x47/0x70
 [<c1002990>] sysenter_do_call+0x12/0x26

