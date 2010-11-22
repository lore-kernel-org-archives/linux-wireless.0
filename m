Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49384 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0KVUSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:18:39 -0500
Message-ID: <4CEAD011.1060209@candelatech.com>
Date: Mon, 22 Nov 2010 12:18:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/3] ath9k: fix recursive locking in the tx flush path
References: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I compiled with these three patches, but it still crashed badly after I started
configuring and/or passing traffic on the 30 STA interfaces.

It is e1000e that first complains, but I still suspect ath9k because
my app was actively creating & configuring the STA interfaces when
this happened.

I can try a different system just in case..might be a day or two though.

The patches don't seem to make anything worse, and at least my
file-system wasn't corrupted this time, so maybe it helped..or
maybe I just got lucky.


PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <63>
   TDT                  <78>
   next_to_use          <78>
   next_to_clean        <63>
buffer_info[next_to_clean]:
   time_stamp           <6b37e6>
   next_to_watch        <66>
   jiffies              <6b48dc>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [ath9k]()
Hardware name: PDSBM
Could not stop RX, we could be confusing the DMA engine when we start RX up
Modules linked in: michael_mic aes_i586 aes_generic 8021q garp stp llc fuse macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ar]
Pid: 18650, comm: kworker/u:1 Not tainted 2.6.37-rc2-wl+ #51
Call Trace:
  [<78436f25>] warn_slowpath_common+0x77/0x8c
  [<f929f14e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<f929f14e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
  [<f929f14e>] ath_stoprecv+0x90/0x9a [ath9k]
  [<f929de42>] ath_radio_disable+0x78/0x140 [ath9k]
  [<7845a5e5>] ? trace_hardirqs_on+0xb/0xd
  [<7843c24b>] ? _local_bh_enable_ip+0x9d/0xa6
  [<7843c25c>] ? local_bh_enable_ip+0x8/0xa
  [<f929e651>] ath9k_config+0x411/0x423 [ath9k]
  [<7845a35d>] ? mark_held_locks+0x47/0x5f
  [<7845a500>] ? trace_hardirqs_on_caller+0x4b/0x125
  [<f9193aaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
  [<f919fa61>] ieee80211_recalc_idle+0x34/0x39 [mac80211]
  [<f919c2c7>] ieee80211_sta_work+0x121/0x16a [mac80211]
  [<f91a0cbd>] ieee80211_iface_work+0x268/0x282 [mac80211]
  [<78446f3c>] process_one_work+0x1af/0x2bf
  [<78446ecb>] ? process_one_work+0x13e/0x2bf
  [<f91a0a55>] ? ieee80211_iface_work+0x0/0x282 [mac80211]
  [<7844868a>] worker_thread+0xf9/0x1bf
  [<78448591>] ? worker_thread+0x0/0x1bf
  [<7844b1ba>] kthread+0x62/0x67
  [<7844b158>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a
---[ end trace f37a1506c7b4957c ]---
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <63>
   TDT                  <78>
   next_to_use          <78>
   next_to_clean        <63>
buffer_info[next_to_clean]:
   time_stamp           <6b37e6>
   next_to_watch        <66>
   jiffies              <6b50ac>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <63>
   TDT                  <78>
   next_to_use          <78>
   next_to_clean        <63>
buffer_info[next_to_clean]:
   time_stamp           <6b37e6>
   next_to_watch        <66>
   jiffies              <6b587c>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <63>
   TDT                  <78>
   next_to_use          <78>
   next_to_clean        <63>
buffer_info[next_to_clean]:
   time_stamp           <6b37e6>
   next_to_watch        <66>
   jiffies              <6b604c>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/net/sched/sch_generic.c:258 dev_watchdog+0xd0/0x124()
Hardware name: PDSBM
NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
Modules linked in: michael_mic aes_i586 aes_generic 8021q garp stp llc fuse macvlan pktgen nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ar]
Pid: 0, comm: swapper Tainted: G        W   2.6.37-rc2-wl+ #51
Call Trace:
  [<78436f25>] warn_slowpath_common+0x77/0x8c
  [<78707759>] ? dev_watchdog+0xd0/0x124
  [<78707759>] ? dev_watchdog+0xd0/0x124
  [<78436fb6>] warn_slowpath_fmt+0x2e/0x30
  [<78707759>] dev_watchdog+0xd0/0x124
  [<784403f8>] ? run_timer_softirq+0xec/0x207
  [<7844046e>] run_timer_softirq+0x162/0x207
  [<784403f8>] ? run_timer_softirq+0xec/0x207
  [<7845a5e5>] ? trace_hardirqs_on+0xb/0xd
  [<78707689>] ? dev_watchdog+0x0/0x124
  [<7843c089>] __do_softirq+0x85/0x142
  [<7843c004>] ? __do_softirq+0x0/0x142
  <IRQ>  [<7843beab>] ? irq_exit+0x35/0x69
  [<7841a2e5>] ? smp_apic_timer_interrupt+0x74/0x81
  [<785972d0>] ? trace_hardirqs_off_thunk+0xc/0x10
  [<7878f2ef>] ? apic_timer_interrupt+0x2f/0x40
  [<7845007b>] ? sched_clock_local+0xc5/0x155
  [<78408a12>] ? mwait_idle+0x59/0x69
  [<78402417>] ? cpu_idle+0x4e/0x6b
  [<78779489>] ? rest_init+0xa1/0xa7
  [<787793e8>] ? rest_init+0x0/0xa7
  [<78992949>] ? start_kernel+0x334/0x33a
  [<7899244f>] ? unknown_bootoption+0x0/0x190
  [<789920e2>] ? i386_start_kernel+0xe2/0xea
---[ end trace f37a1506c7b4957d ]---
e1000e 0000:06:00.0: eth0: Reset adapter


[ similar stuff continues, including ATA errors for the hard-drive ]

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

