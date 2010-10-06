Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58236 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0JFR2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 13:28:50 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o96HSoKu014896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Oct 2010 10:28:50 -0700
Message-ID: <4CACB1D1.7090900@candelatech.com>
Date: Wed, 06 Oct 2010 10:28:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash in cfg80211_unlink_bss
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This test scenario has  72 stations on ath5k trying to connect to a cisco AP
that supposedly only supports 63 stations.

The 72 STA were created without ssid's configured, then we re-configured all
72 'at once' to give them the proper SSID (ifdown, ifup, iwconfig to set values).

The system crashed and rebooted.

Kernel is wireless-testing as of later yesterday, with a few additional
patches mostly dealing with counters in /proc/net/wireless and some lockdep
fixes pulled in from lkml etc.

We have seen this before, but this is the first good stacktrace we got.

Likely we can reproduce this if extra information is needed.


------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/lib/list_debug.c:48 list_del+0x24/0xab()
Hardware name: PDSM4+
list_del corruption, next is LIST_POISON1 (00100100)
Modules linked in: xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_ipra]
Pid: 27077, comm: kworker/u:1 Not tainted 2.6.36-rc6-wl+ #6
Call Trace:
  [<c04345cb>] warn_slowpath_common+0x65/0x7a
  [<c058f3c8>] ? list_del+0x24/0xab
  [<c0434644>] warn_slowpath_fmt+0x26/0x2a
  [<c058f3c8>] list_del+0x24/0xab
  [<fac52fed>] cfg80211_unlink_bss+0x4e/0x7d [cfg80211]
  [<fb8aa464>] ieee80211_work_work+0x562/0xcfa [mac80211]
  [<c0443cea>] ? process_one_work+0x145/0x295
  [<c0443d34>] process_one_work+0x18f/0x295
  [<c0443cea>] ? process_one_work+0x145/0x295
  [<fb8a9f02>] ? ieee80211_work_work+0x0/0xcfa [mac80211]
  [<c044535d>] worker_thread+0xf9/0x1b8
  [<c0445264>] ? worker_thread+0x0/0x1b8
  [<c0447ca7>] kthread+0x62/0x67
  [<c0447c45>] ? kthread+0x0/0x67
  [<c0403506>] kernel_thread_helper+0x6/0x1a
---[ end trace 378943e5dc829f28 ]---
BUG: unable to handle kernel paging request at 00200200
IP: [<c058f3f8>] list_del+0x54/0xab
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.2/0000:03:01.0/ieee80211/phy0/macaddress
Modules linked in: xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_ipra]


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

