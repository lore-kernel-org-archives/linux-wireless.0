Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34736 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0AVUOz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 15:14:55 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYPu6-0007oA-FH
	for linux-wireless@vger.kernel.org; Fri, 22 Jan 2010 21:14:50 +0100
Received: from p4FF0DD95.dip.t-dialin.net ([79.240.221.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 21:14:50 +0100
Received: from Markus_Baier by p4FF0DD95.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 21:14:50 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Starting hostapd causes kernel panic
Date: Fri, 22 Jan 2010 20:14:36 +0000 (UTC)
Message-ID: <loom.20100122T205326-794@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the latest git pull from wireless-testing
master-2010-01-14 to master-2010-01-19
the start of hostapd causes kernel panic.

Tested with wireless-testing master-2010-01-19
and hostapd 0.6.9 / 0.7.0


---------------------------------------------

BUG: unable to handle kernel NULL pointer dereference at 00000193
IP: [<c126afc9>] invoke_tx_handlers+0x909/0xf40
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /sys/devices/virtual/net/br0/bridge/topology_change_detected
Modules linked in: rt61pci crc_itu_t rt2x00pci rt2x00lib eeprom_93cx6

Pid: 4411, comm: hostapd Not tainted 2.6.33-rc4-wl-47289-gd602bbd #27 CN700-8237/
EIP: 0060:[<c126afc9>] EFLAGS: 00210246 CPU: 0
EIP is at invoke_tx_handlers+0x909/0xf40
EAX: 00000040 EBX: 00000000 ECX: f6dfc000 EDX: 00000000
ESI: f6c03c00 EDI: f6c07c2c EBP: f6c07c00 ESP: f6c07b34
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process hostapd (pid: 4411, ti=f6c06000 task=f7bb4000 task.ti=f6c06000)
Stack:
 c108763f 00000000 00000200 0000000a 00000304 f6c07e44 c1088368 0098966f
<0> b7a55af2 0000002d 00000000 f6c07bd0 f6c03c00 f6c0805e f6c07f60 f6c07e2c
<0> 00000000 f6c03c20 000000c0 0098966f f6c07e6c f6c07e70 f6c07e74 f6c07e60
Call Trace:
 [<c108763f>] ? poll_freewait+0x3f/0xa0
 [<c1088368>] ? do_select+0x608/0x680
 [<c1269ee5>] ? ieee80211_tx_prepare+0x105/0x310
 [<c1088860>] ? __pollwait+0x0/0xd0
 [<c126b7b3>] ? ieee80211_tx+0x53/0x180
 [<c11cc278>] ? skb_release_data+0x68/0xa0
 [<c11cc398>] ? pskb_expand_head+0xe8/0x170
 [<c126b96c>] ? ieee80211_xmit+0x8c/0x180
 [<c126bb44>] ? ieee80211_monitor_start_xmit+0x94/0xc0
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
Code: 3d a0 00 00 00 0f 84 1d 05 00 00 3d c0 00 00 00 0f 84 12 05 00 00 3d d0
00 00 00 0f 84 e6 04 00 00 90 c7 47 10 00 00 00 00 31 db <0f> b6 93 93 01 00
00 f6 c2 10 0f 84 e0 f8 ff ff 8b 8d 68 ff ff
EIP: [<c126afc9>] invoke_tx_handlers+0x909/0xf40 SS:ESP 0068:f6c07b34
CR2: 0000000000000193
---[ end trace bc184f73743b5879 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 4411, comm: hostapd Tainted: G      D    2.6.33-rc4-wl-47289-gd602bbd #27
Call Trace:
 [<c1277d45>] ? printk+0x18/0x1b
 [<c1277c7e>] panic+0x43/0xf2
 [<c10054ee>] oops_end+0x7e/0x90
 [<c101a8ae>] no_context+0xbe/0x150
 [<c101a98f>] __bad_area_nosemaphore+0x4f/0x180
 [<c101f056>] ? update_curr+0x116/0x160
 [<c1020787>] ? dequeue_entity+0x17/0x1b0
 [<c1020ff0>] ? dequeue_task_fair+0x30/0x80
 [<c101aad2>] bad_area_nosemaphore+0x12/0x20
 [<c101aeb4>] do_page_fault+0x254/0x2f0
 [<c101ac60>] ? do_page_fault+0x0/0x2f0
 [<c12799f6>] error_code+0x5e/0x64
 [<c101ac60>] ? do_page_fault+0x0/0x2f0
 [<c126afc9>] ? invoke_tx_handlers+0x909/0xf40
 [<c108763f>] ? poll_freewait+0x3f/0xa0
 [<c1088368>] ? do_select+0x608/0x680
 [<c1269ee5>] ? ieee80211_tx_prepare+0x105/0x310
 [<c1088860>] ? __pollwait+0x0/0xd0
 [<c126b7b3>] ieee80211_tx+0x53/0x180
 [<c11cc278>] ? skb_release_data+0x68/0xa0
 [<c11cc398>] ? pskb_expand_head+0xe8/0x170
 [<c126b96c>] ieee80211_xmit+0x8c/0x180
 [<c126bb44>] ieee80211_monitor_start_xmit+0x94/0xc0
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


