Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:42161 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZBDW03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 17:26:29 -0500
Received: from [192.168.1.102] (151.48.37.158) by cp-out11.libero.it (8.5.016.1)
        id 492C059609812B03 for linux-wireless@vger.kernel.org; Wed, 4 Feb 2009 23:26:27 +0100
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: p54common oops log
Date: Wed, 4 Feb 2009 23:23:51 +0100
MIME-Version: 1.0
Message-Id: <200902042323.52020.rossi.f@inwind.it> (sfid-20090204_232633_157615_52ADB8EC)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have found the following problem with my p54pci wireless card:

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<e07f2106>] p54_assign_address+0xb0/0x25c [p54common]
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/class/net/wlan0/type
Modules linked in: p54pci p54common mac80211

Pid: 4888, comm: phy0 Not tainted (2.6.29-rc3-wl #1) Presario 2701EA 
470020-401    
EIP: 0060:[<e07f2106>] EFLAGS: 00010093 CPU: 0
EIP is at p54_assign_address+0xb0/0x25c [p54common]
EAX: 00000038 EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: 0002027c EDI: 00000000 EBP: ddc0fc58 ESP: ddc0fc18
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process phy0 (pid: 4888, ti=ddc0e000 task=df05cdc0 task.ti=ddc0e000)
Stack:
 00000088 00000038 df013610 df29d3e0 ddc0c160 64000020 ddc0ce6c ddc0ce60
 00000000 00020200 00000282 00000003 000000a0 df29d3e0 ddc0ce60 00000038
 ddc0fc80 e07f235c 00000038 00000000 0000002c 00008001 ddc0c160 ddc0ce60
Call Trace:
 [<e07f235c>] ? p54_alloc_skb+0xaa/0xbc [p54common]
 [<e07f2588>] ? p54_setup_mac+0x2c/0x177 [p54common]
 [<e07f36d8>] ? p54_bss_info_changed+0x73/0xa6 [p54common]
 [<e07f3665>] ? p54_bss_info_changed+0x0/0xa6 [p54common]
 [<e18862b6>] ? ieee80211_bss_info_change_notify+0x41/0x67 [mac80211]
 [<e1890082>] ? ieee80211_rx_mgmt_assoc_resp+0xa70/0xce3 [mac80211]
 [<e1890c10>] ? ieee80211_sta_work+0x91b/0x12f5 [mac80211]
 [<c0117f21>] ? update_curr+0x66/0xbe
 [<c0118be3>] ? task_tick_fair+0x1f/0x51
 [<c0117f21>] ? update_curr+0x66/0xbe
 [<c0117ff0>] ? dequeue_entity+0x50/0x7d
 [<c0118b6b>] ? dequeue_task_fair+0x26/0x30
 [<c01167e3>] ? dequeue_task+0x72/0x81
 [<c012999b>] ? run_workqueue+0x88/0x144
 [<e18902f5>] ? ieee80211_sta_work+0x0/0x12f5 [mac80211]
 [<c012a271>] ? worker_thread+0x71/0xa1
 [<c012cc1b>] ? autoremove_wake_function+0x0/0x3a
 [<c012a200>] ? worker_thread+0x0/0xa1
 [<c012c8ff>] ? kthread+0x36/0x58
 [<c012c8c9>] ? kthread+0x0/0x58
 [<c01035df>] ? kernel_thread_helper+0x7/0x18
Code: 89 75 e4 c7 45 e0 00 00 00 00 31 ff 31 c9 eb 15 39 c7 0f 42 f8 8b 45 c4 
8b 70 04 8b 1b 83 c1 01 3b 4d ec 74 25 8d 43 38 89 45 c4 <8b> 43 38 29 f0 8b 
55 e0 85 d2 75 d9 39 45 f0 77 d4 8b 53 04 89 
EIP: [<e07f2106>] p54_assign_address+0xb0/0x25c [p54common] SS:ESP 
0068:ddc0fc18
---[ end trace 9c3e36b68d59807e ]---
note: phy0[4888] exited with preempt_count 1


I'm using v2.6.29-rc3-12726-gf917b45.

Fabio
