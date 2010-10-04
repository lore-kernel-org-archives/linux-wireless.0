Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59582 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab0JDSvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:51:52 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o94Ippub008335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 11:51:51 -0700
Message-ID: <4CAA2247.50402@candelatech.com>
Date: Mon, 04 Oct 2010 11:51:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just in case this seems familiar to anyone...

IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/ieee80211/phy0/index
Modules linked in: michael_mic aes_i586 aes_generic 8021q garp stp llc macvlan pktgen fuse nfs lockd fscache nfs_acl ]

Pid: 16563, comm: parse-iwconfig. Not tainted 2.6.36-rc6-wl+ #23 PDSBM/PDSBM
EIP: 0060:[<f8ba74da>] EFLAGS: 00010282 CPU: 0
EIP is at ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
EAX: 00010000 EBX: f30d5a98 ECX: 00000001 EDX: 00000000
ESI: f30d5800 EDI: f30d5800 EBP: f5ed5ef4 ESP: f5ed5ee0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process parse-iwconfig. (pid: 16563, ti=f5ed4000 task=f44ee860 task.ti=f5ed4000)
Stack:
  00000246 00000246 00000000 f30d5800 00000000 f5ed5f08 f8ba7b28 c0a2be80
<0> f2f11090 f5ed5f50 f5ed5f64 c043d5a8 00000000 00000002 00000000 c043d546
<0> f5ed5f50 f5ed5f44 f30d5a44 c0a2cca8 c0a2caa8 c0a2c8a8 c0a2c6a8 f8ba7a90
Call Trace:
  [<f8ba7b28>] ? sta_addba_resp_timer_expired+0x98/0xb4 [mac80211]
  [<c043d5a8>] ? run_timer_softirq+0x14f/0x1e7
  [<c043d546>] ? run_timer_softirq+0xed/0x1e7
  [<f8ba7a90>] ? sta_addba_resp_timer_expired+0x0/0xb4 [mac80211]
  [<c04393f2>] ? __do_softirq+0x86/0x111
  [<c04394b3>] ? do_softirq+0x36/0x5a
  [<c04395ec>] ? irq_exit+0x35/0x69
  [<c0418d1b>] ? smp_apic_timer_interrupt+0x6e/0x7c
  [<c076459f>] ? apic_timer_interrupt+0x2f/0x40
Code: b2 c7 8b 45 ec 8d 93 00 fe ff ff e8 46 23 01 00 58 5a 5b 5e 5f 5d c3 55 89 e5 57 56 53 89 c3 8d b8 68 fd ff ff
EIP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211] SS:ESP 0068:f5ed5ee0
CR2: 00000000000101e0
---[ end trace 4c1f9d6f2b4d6888 ]---



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

