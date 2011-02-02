Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44127 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BBW3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 17:29:19 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p12MTIlS030517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Feb 2011 14:29:18 -0800
Message-ID: <4D49DABE.7040802@candelatech.com>
Date: Wed, 02 Feb 2011 14:29:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Crash in timer.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had 128 STA vifs on an ath9k system...started deleting all but 16 of them.
I did this twice, and both times, it crashes before finishing deleting
all of them.

This is using latest wireless-testing plus some of my patches
previously posted to this list.


------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux.wireless-testing/kernel/timer.c:1005!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:03:00.0/net/sta111/flags
Modules linked in: cryptd aes_i586 aes_generic 8021q garp stp llc michael_mic macvlan pktgen fuse coretemp hwmon nfs lockd fsc]

Pid: 9998, comm: wpa_supplicant Not tainted 2.6.38-rc3-wl+ #42 To be filled by O.E.M./To Be Filled By O.E.M.
EIP: 0060:[<c0443d87>] EFLAGS: 00210092 CPU: 1
EIP is at cascade+0x45/0x63
EAX: 00060008 EBX: 00000008 ECX: f54d8934 EDX: f123c908
ESI: 00000000 EDI: f54d8000 EBP: f54e9f7c ESP: f54e9f64
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process wpa_supplicant (pid: 9998, ti=f54e8000 task=f17ee720 task.ti=f081e000)
Stack:
  f54e9f68 f1158064 f4a2d664 f54d8000 00000000 00000004 f54e9fd0 c04451dd
  f54e9fbc f54e9fac 00000286 f54d8e2c f54d8c2c f54d8a2c f54d882c f54e9fc8
  c0486a6b 00000003 f17ee720 c043fb2f c043fade f54e9fc8 c0460dec 00000202
Call Trace:
  [<c04451dd>] run_timer_softirq+0x95/0x232
  [<c0486a6b>] ? __rcu_process_callbacks+0x6b/0x26f
  [<c043fb2f>] ? __do_softirq+0x51/0x184
  [<c043fade>] ? __do_softirq+0x0/0x184
  [<c0460dec>] ? trace_hardirqs_on_caller+0xf5/0x12f
  [<c043fb94>] __do_softirq+0xb6/0x184
  [<c043fade>] ? __do_softirq+0x0/0x184
  <IRQ>
  [<c043f976>] ? irq_exit+0x3a/0x6e
  [<c041a713>] ? smp_apic_timer_interrupt+0x73/0x81
  [<c07e2e0f>] ? apic_timer_interrupt+0x2f/0x40
  [<c04f2a5f>] ? dput+0x1/0xde
  [<c04ea6c0>] ? path_put+0x13/0x1d
  [<c047fd0b>] ? audit_free_names+0x45/0x5e
  [<c047feb2>] ? audit_syscall_exit+0x96/0x114
  [<c04031ea>] ? sysexit_audit+0x29/0x4f
Code: ca 89 75 ec 89 46 04 8b 74 da 04 89 75 f0 89 06 89 0c da 89 4c da 04 8b 55 ec 8b 32 89 45 e8 eb 19 8b 42 0c 83 e0 fe 39
EIP: [<c0443d87>] cascade+0x45/0x63 SS:ESP 0068:f54e9f64

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

