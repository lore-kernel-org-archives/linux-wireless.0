Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45690 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab0GCG0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jul 2010 02:26:15 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o636QEWM027215
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 2 Jul 2010 23:26:14 -0700
Message-ID: <4C2ED806.9000105@candelatech.com>
Date: Fri, 02 Jul 2010 23:26:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k doesn't clean up virtual wifis on rmmod, and crashes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems to me that in 2.6.34, there is no code to clean up
virtual wiphys in ath9k on rmmod.  Also, ath9k mailing list
is returning error about mis-configured DNS server.

This is with un-modified ath9k driver and is repeatable
every time on my system (crash is often different, but
it always crashes very quickly).

[root@atom ~]# echo add=5 > /debug/ath9k/phy1/wiphy
-bash: /debug/ath9k/phy1/wiphy: No such file or directory
[root@atom ~]# echo add=5 > /debug/ath9k/phy0/wiphy
Jul  2 23:22:19 atom kernel: phy1: Selected rate control algorithm 'ath9k_rate_control'
[root@atom ~]# Jul  2 23:22:19 atom kernel: ADDRCONF(NETDEV_UP): wlan1: link is not ready
rmmod ath9k
Jul  2 23:22:24 atom kernel: ath9k 0000:05:00.0: PCI INT A disabled
Jul  2 23:22:24 atom kernel: ath9k: Driver unloaded
[root@atom ~]# BUG: spinlock bad magic on CPU#1, iw/2877
  lock: f8a476c0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 2877, comm: iw Not tainted 2.6.34 #7
Call Trace:
  [<c0730e34>] ? printk+0xf/0x13
  [<c05710d6>] spin_bug+0x7b/0x86
  [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
  [<c0571171>] do_raw_spin_lock+0x1e/0x125
  [<c042f91e>] ? scheduler_tick+0xd6/0x1c9
  [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
  [<c0732a6d>] _raw_spin_lock_irqsave+0x1b/0x20
  [<c0440b59>] __queue_work+0x12/0x2f
  [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
  [<c0440ba4>] delayed_work_timer_fn+0x2e/0x30

I'm new to hacking on this driver..but would love to test
patches, and if someone wants to suggest a good point in
the code to remove the virtual phys, I'll make the attempt.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
