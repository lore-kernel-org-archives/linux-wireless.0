Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39913 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0JESd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 14:33:59 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o95IXwBB030394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 11:33:59 -0700
Message-ID: <4CAB6F96.6090701@candelatech.com>
Date: Tue, 05 Oct 2010 11:33:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: more crashing goodness with ath9k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with 8 STA configured with WPA.

Memory poisoning, etc is enabled.


Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
(gdb) l *(sta_addba_resp_timer_expired+0x7c)
0x5b38 is in sta_addba_resp_timer_expired (/home/greearb/git/linux.wireless-testing/arch/x86/include/asm/bitops.h:312).
307	}
308	
309	static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
310	{
311		return ((1UL << (nr % BITS_PER_LONG)) &
312			(addr[nr / BITS_PER_LONG])) != 0;
313	}
314	
315	static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
316	{
(gdb)

29 localhost kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Oct  5 11:20:29 localhost kernel: ADDRCONF(NETDEV_UP): sta1: link is not ready
Oct  5 11:20:29 localhost kernel: ADDRCONF(NETDEV_UP): sta2: link is not ready
Oct  5 11:20:30 localhost kernel: ADDRCONF(NETDEV_UP): sta3: link is not ready
Oct  5 11:20:30 localhost kernel: ADDRCONF(NETDEV_UP): sta4: link is not ready
Oct  5 11:20:30 localhost kernel: ieee80211 phy0: device now idle
BUG: unable to handle kernel paging request at 6b6b6bc3
IP: [<f8ce7b14>] sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/net/sta7/flags
Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9]

Pid: 2524, comm: sh Not tainted 2.6.36-rc6-wl+ #5 PDSBM/PDSBM
EIP: 0060:[<f8ce7b14>] EFLAGS: 00010202 CPU: 0
EIP is at sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211]
EAX: 6b6b6b6b EBX: 0000006b ECX: 00000001 EDX: c0946ec4
ESI: f4760ff5 EDI: 0000006b EBP: f3c5be6c ESP: f3c5be60
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process sh (pid: 2524, ti=f3c5a000 task=f4729fe0 task.ti=f3c5a000)
Stack:
  c0a26e80 f67961e0 f3c5beb4 f3c5bec8 c043d57f 00000000 00000002 00000000
<0> c043d51d f3c5beb4 f3c5bea8 f47612a4 c0a27ca8 c0a27aa8 c0a278a8 c0a276a8
<0> f8ce7a98 00000100 f8d093a8 c0bba69c f8d05851 f3c5beb4 f3c5beb4 00000101
Call Trace:
  [<c043d57f>] ? run_timer_softirq+0x14f/0x1e7
  [<c043d51d>] ? run_timer_softirq+0xed/0x1e7
  [<f8ce7a98>] ? sta_addba_resp_timer_expired+0x0/0xb4 [mac80211]
  [<c043945f>] ? __do_softirq+0x86/0x111
  [<c0439520>] ? do_softirq+0x36/0x5a
  [<c0439659>] ? irq_exit+0x35/0x69
  [<c0418d23>] ? smp_apic_timer_interrupt+0x6e/0x7c
  [<c04bfe16>] ? putname+0x25/0x2e
  [<c0760acf>] ? apic_timer_interrupt+0x2f/0x40
  [<c04bfe16>] ? putname+0x25/0x2e
  [<c045007b>] ? do_adjtimex+0x217/0x55e
  [<c04b00d8>] ? pcpu_get_pages_and_bitmap+0x34/0xb6
  [<c04ac881>] ? kmem_cache_free+0xaa/0xb6
  [<c04bfe16>] ? putname+0x25/0x2e
  [<c04bfe16>] ? putname+0x25/0x2e
  [<c04b5ff0>] ? do_sys_open+0xc6/0xd0
  [<c04b603c>] ? sys_open+0x1e/0x26
  [<c0760585>] ? syscall_call+0x7/0xb
Code: 3f d1 76 c7 85 c0 75 16 ba dc 00 00 00 b8 c8 57 d0 f8 c6 05 b8 93 d0 f8 01 e8 c7 dc 76 c7 8d 84 9e f0 01 00 00 8b 00 85 c0 74 07 <8b> 40 58 a8 02 74
EIP: [<f8ce7b14>] sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211] SS:ESP 0068:f3c5be60
CR2: 000000006b6b6bc3



And another, in case it helps.

ieee80211 phy0: device no longer idle - scanning
  [<f8d35b14>] sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/net/sta7/flags
Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9]

Pid: 2506, comm: ip Not tainted 2.6.36-rc6-wl+ #5 PDSBM/PDSBM
EIP: 0060:[<f8d35b14>] EFLAGS: 00010202 CPU: 1
EIP is at sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211]
EAX: 6b6b6b6b EBX: 0000006b ECX: 00000001 EDX: c0946ec4
ESI: f4761825 EDI: 0000006b EBP: f47dfd98 ESP: f47dfd8c
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process ip (pid: 2506, ti=f47de000 task=f475b520 task.ti=f47de000)
Stack:
  f7098000 f45184b0 f47dfde0 f47dfdf4 c043d57f 00000000 00000002 00000000
<0> c043d51d f47dfde0 f47dfdd4 f4761ad4 f7098e28 f7098c28 f7098a28 f7098828
<0> f8d35a98 00000100 f8d573a8 c0bba14c f8d53851 f47dfde0 f47dfde0 00000001
Call Trace:
  [<c043d57f>] ? run_timer_softirq+0x14f/0x1e7
  [<c043d51d>] ? run_timer_softirq+0xed/0x1e7
  [<f8d35a98>] ? sta_addba_resp_timer_expired+0x0/0xb4 [mac80211]
  [<c043945f>] ? __do_softirq+0x86/0x111
  [<c0439520>] ? do_softirq+0x36/0x5a
  [<c0439659>] ? irq_exit+0x35/0x69
  [<c0418d23>] ? smp_apic_timer_interrupt+0x6e/0x7c
  [<c0496873>] ? might_fault+0x47/0x81
  [<c0760acf>] ? apic_timer_interrupt+0x2f/0x40
  [<c0496873>] ? might_fault+0x47/0x81
  [<c049007b>] ? kswapd+0x1a4/0x622
  [<c0457983>] ? lock_release+0x148/0x153
  [<c04968a8>] ? might_fault+0x7c/0x81
  [<c0581843>] ? copy_to_user+0x2f/0x108
  [<c06c14a4>] ? move_addr_to_user+0x5a/0x72
  [<c06c19f8>] ? sys_getsockname+0x59/0x73
  [<c0498e9b>] ? __do_fault+0x379/0x3a5
  [<c04576e9>] ? lock_release_non_nested+0x86/0x1d8
  [<c0496873>] ? might_fault+0x47/0x81
  [<c0496873>] ? might_fault+0x47/0x81
  [<c04968a8>] ? might_fault+0x7c/0x81
  [<c06c1e31>] ? sys_socketcall+0xb4/0x1a5
  [<c0402f1c>] ? sysenter_do_call+0x12/0x38
Code: 3f f1 71 c7 85 c0 75 16 ba dc 00 00 00 b8 c8 37 d5 f8 c6 05 b8 73 d5 f8 01 e8 c7 fc 71 c7 8d 84 9e f0 01 00 00 8b 00 85 c0 74 07 <8b> 40 58 a8 02 74
EIP: [<f8d35b14>] sta_addba_resp_timer_expired+0x7c/0xb4 [mac80211] SS:ESP 0068:f47dfd8c
CR2: 000000006b6b6bc3
---[ end trace 2fd8b34c8648015a ]---
Kernel panic - not syncing: Fatal exception in interrupt

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

