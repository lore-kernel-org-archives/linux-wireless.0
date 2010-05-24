Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.store20.com ([212.7.7.16]:60373 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0EXKeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 06:34:36 -0400
Subject: Oops in iwl3945_request_scan (2.6.34+)
From: Priit Laes <plaes@plaes.org>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 13:28:46 +0300
Message-ID: <1274696926.7803.15.camel@chi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey!

When trying latest upstream Linus's kernel (2.6.34-07097-gf4b87de) I got
following Oops when associating with wireless access point (IIRC, it was
WEP-authenticated).
Although authentication was successful and I was able to ping external
networks, no HTTP-data could be received.

Machine: IBM/Lenovo Thinkpad x60s
Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan]
Network Connection (rev 02)

[snip]
wlan0: authenticate with 00:xx:xx:xx:xx:xx (try 1)
wlan0: authenticated
wlan0: associate with 00:xx:xx:xx:xx:xx (try 1)
wlan0: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
BUG: unable to handle kernel paging request at 0000000000100886
IP: [<ffffffffa000cff0>] iwl3945_request_scan+0x8c5/0xcd6 [iwl3945]
PGD bc115067 PUD bc114067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 0 
Modules linked in: sdhci_pci sdhci mmc_core joydev iwl3945
Pid: 1372, comm: iwl3945 Not tainted 2.6.34-07097-gf4b87de #1 1702M3G/1702M3G
RIP: 0010:[<ffffffffa000cff0>]  [<ffffffffa000cff0>] iwl3945_request_scan+0x8c5/0xcd6 [iwl3945]
RSP: 0018:ffff8800bb311d40  EFLAGS: 00010207
RAX: ffff8800bce40800 RBX: ffff8800bb611380 RCX: 0000000000000057
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800bb611380
RBP: 0000000000100886 R08: 000000000000030e R09: 00000000ffffffff
R10: 0000000010bf1c00 R11: ffff880001a12400 R12: ffff8800bafd38f2
R13: 0000000000000000 R14: 0000000000000058 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000100886 CR3: 00000000bc112000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process iwl3945 (pid: 1372, threadinfo ffff8800bb310000, task ffff8800baeae120)
Stack:
 ffff8800baeae120 0000000000000000 ffff880000000000 ffff880000000000
<0> ffff8800bb311da0 ffffffff8104e5eb 0000000001a12400 0021000000000000
<0> ffff8800be66ad01 ffff8800baeaeb60 0000000000000000 ff00000000000000
Call Trace:
 [<ffffffff8104e5eb>] ? finish_task_switch+0x3d/0xb5
 [<ffffffff812a9a7d>] ? iwl_bg_start_internal_scan+0x0/0x2b5
 [<ffffffff812a9d14>] ? iwl_bg_start_internal_scan+0x297/0x2b5
 [<ffffffff81064413>] ? worker_thread+0x13d/0x1c2
 [<ffffffff8106789b>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff810642d6>] ? worker_thread+0x0/0x1c2
 [<ffffffff810674e1>] ? kthread+0x75/0x7d
 [<ffffffff81022c54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106746c>] ? kthread+0x0/0x7d
 [<ffffffff81022c50>] ? kernel_thread_helper+0x0/0x10
Code: 4c 24 60 48 89 4c 24 70 41 0f b7 c6 41 8d 4e ff 89 44 24 7c 66 89 8c 24 86 00 00 00 e9 3c 02 00 00 48 63 54 24 38 48 8b 6c d0 38 <44> 39 7d 00 0f 85 24 02 00 00 66 8b 55 06 44 89 fe 41 88 54 24 
RIP  [<ffffffffa000cff0>] iwl3945_request_scan+0x8c5/0xcd6 [iwl3945]
 RSP <ffff8800bb311d40>
CR2: 0000000000100886
---[ end trace ac44e894bb32101c ]---
wlan0: no IPv6 routers present
[/snip]
