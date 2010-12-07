Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50066 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0LGSrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:47:40 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oB7IldYd000600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Dec 2010 10:47:39 -0800
Message-ID: <4CFE814B.7030203@candelatech.com>
Date: Tue, 07 Dec 2010 10:47:39 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash when deleting lots of VIFS, wireless-testing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this started happening in the last few days.  I see all sorts
of corruptions, often in timers and lists.  I'm using ath9k on these
systems, but not sure that matters.  Might have something to do with
deleting interfaces while scanning.

I'll be digging more..but if anyone has ideas, they are welcome!

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/lib/list_debug.c:30 __list_add+0x6c/0x7f()
Hardware name: PDSBM
list_add corruption. prev->next should be next (78a3c434), but was 6b6b6b6b. (prev=e27c39a4).
Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic fuse macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ar]
Pid: 9567, comm: kworker/u:2 Tainted: P            2.6.37-rc4-wl+ #57
Call Trace:
  [<78436fbd>] warn_slowpath_common+0x77/0x8c
  [<785a5bb1>] ? __list_add+0x6c/0x7f
  [<785a5bb1>] ? __list_add+0x6c/0x7f
  [<7843704e>] warn_slowpath_fmt+0x2e/0x30
  [<785a5bb1>] __list_add+0x6c/0x7f
  [<784402fb>] internal_add_timer+0x8e/0x92
  [<784407c5>] __mod_timer+0xed/0x101
  [<78440d36>] mod_timer+0x70/0x76
  [<f919dd6e>] ieee80211_sta_reset_conn_monitor+0x2e/0x3b [mac80211]
  [<f919a146>] ieee80211_offchannel_return+0xce/0x16e [mac80211]
  [<f919931e>] __ieee80211_scan_completed_finish+0x50/0x93 [mac80211]
  [<f919a066>] ieee80211_scan_work+0x3e5/0x3f7 [mac80211]
  [<78446f63>] ? process_one_work+0x13e/0x2bf
  [<78446fd4>] process_one_work+0x1af/0x2bf
  [<78446f63>] ? process_one_work+0x13e/0x2bf
  [<f9199c81>] ? ieee80211_scan_work+0x0/0x3f7 [mac80211]
  [<78448722>] worker_thread+0xf9/0x1bf
  [<78448629>] ? worker_thread+0x0/0x1bf
  [<7844b252>] kthread+0x62/0x67
  [<7844b1f0>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a
---[ end trace 4a96cef9c907ea7c ]---
start_sw_scan: running-other-vifs: 0  running-station-vifs: 69, associated-stations: 68 scanning current channel: 2437 MHz
BUG: unable to handle kernel paging request at df47b9a4
IP: [<78440843>] try_to_del_timer_sync+0x28/0x65
*pde = 01397067 *pte = 6747b160
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/class
Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic fuse macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ar]

Pid: 38, comm: kworker/u:1 Tainted: P        W   2.6.37-rc4-wl+ #57 PDSBM/PDSBM
EIP: 0060:[<78440843>] EFLAGS: 00010086 CPU: 0
EIP is at try_to_del_timer_sync+0x28/0x65
EAX: 78a3b980 EBX: f2c49944 ECX: df47b9a4 EDX: f4abea24
ESI: 00000000 EDI: 00000286 EBP: f39f7e98 ESP: f39f7e8c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:1 (pid: 38, ti=f39f6000 task=f3a00a70 task.ti=f39f6000)
Stack:
  00000282 f2c49960 f2c49944 f39f7ebc 78440c47 00000000 00000002 00000000
  78440bc0 f2c49540 f4214460 f4214c3c f39f7ed4 f919a35c f4214c34 f4214460
  e26c0240 00000064 f39f7f2c f9199fbb f39f7f68 f39f7f10 00000046 00000000
Call Trace:
  [<78440c47>] ? del_timer_sync+0x87/0x97
  [<78440bc0>] ? del_timer_sync+0x0/0x97
  [<f919a35c>] ? ieee80211_offchannel_stop_station+0x96/0xfa [mac80211]
  [<f9199fbb>] ? ieee80211_scan_work+0x33a/0x3f7 [mac80211]
  [<78446fd4>] ? process_one_work+0x1af/0x2bf
  [<78446f63>] ? process_one_work+0x13e/0x2bf
  [<f9199c81>] ? ieee80211_scan_work+0x0/0x3f7 [mac80211]
  [<78448722>] ? worker_thread+0xf9/0x1bf
  [<78448629>] ? worker_thread+0x0/0x1bf
  [<7844b252>] ? kthread+0x62/0x67
  [<7844b1f0>] ? kthread+0x0/0x67
  [<784036c6>] ? kernel_thread_helper+0x6/0x1a
Code: ff c9 c3 55 89 e5 56 83 ce ff 53 89 c3 83 ec 04 8d 55 f4 e8 68 fe ff ff 39 58 20 74 3c 8b 13 31 f6 85 d2 74 34 8b 4b 04 89 4a 04 <89> 11 8b 53 0
EIP: [<78440843>] try_to_del_timer_sync+0x28/0x65 SS:ESP 0068:f39f7e8c
CR2: 00000000df47b9a4

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

