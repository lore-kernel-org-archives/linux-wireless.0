Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55678 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0I1SWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 14:22:01 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8SIM1oV022603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 11:22:01 -0700
Message-ID: <4CA23248.7030109@candelatech.com>
Date: Tue, 28 Sep 2010 11:22:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: timer.c BUG
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just hit this on my ath9k system, but it does have my patches applied,
so it could just be my problem:

------------[ cut here ]------------
kernel BUG at /home/greearb/git/linux.wireless-testing/kernel/timer.c:1027!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/net/sta1/flags
Modules linked in: michael_mic ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 ae]

Pid: 23809, comm: kworker/u:0 Not tainted 2.6.36-rc5-wl+ #7 PDSBM/PDSBM
EIP: 0060:[<c043d32b>] EFLAGS: 00010093 CPU: 1
EIP is at cascade+0x40/0x5e
EAX: fffffffe EBX: 00000019 ECX: f7070738 EDX: edc01c68
ESI: edc57b0c EDI: f7070000 EBP: edc57b20 ESP: edc57b08
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:0 (pid: 23809, ti=edc56000 task=f6733ea0 task.ti=edc56000)
Stack:
  edc57b0c c096e7f0 edc01c68 f7070000 00000000 00000001 edc57b6c c043d3ca
<0> edc57b58 edc57b4c 00000000 f7070e28 f7070c28 f7070a28 f7070828 c2602f8c
<0> 00000053 edc57b90 c04392a9 c042007b edc57b58 edc57b58 00000101 00000004
Call Trace:
  [<c043d3ca>] ? run_timer_softirq+0x81/0x1e7
  [<c04392a9>] ? __do_softirq+0x4c/0x111
  [<c042007b>] ? native_load_sp0+0x1c/0x2c
  [<c04392e3>] ? __do_softirq+0x86/0x111
  [<c04393a4>] ? do_softirq+0x36/0x5a
  [<c04394dd>] ? irq_exit+0x35/0x68
  [<c0418c3a>] ? smp_apic_timer_interrupt+0x6e/0x7c
  [<c07633df>] ? apic_timer_interrupt+0x2f/0x40
  [<c0434ffc>] ? vprintk+0x393/0x3b9
  [<f910f41c>] ? ath_txq_update+0xac/0xb6 [ath9k]
  [<c0760adc>] ? printk+0xf/0x13
  [<c06194ed>] ? __dev_printk+0x51/0x5b
  [<c0619643>] ? dev_printk+0x26/0x28
  [<f8c54101>] ? ieee80211_sta_wmm_params+0x1b8/0x233 [mac80211]
  [<c07619a8>] ? mutex_unlock+0x8/0xa
  [<f8c553ae>] ? ieee80211_assoc_success+0x457/0x7e4 [mac80211]
  [<f8c557e2>] ? ieee80211_assoc_done+0xa7/0xf6 [mac80211]
  [<c0456299>] ? trace_hardirqs_on+0xb/0xd
  [<f8c57175>] ? ieee80211_work_work+0x306/0xd36 [mac80211]
  [<c0456299>] ? trace_hardirqs_on+0xb/0xd
  [<c0443c4f>] ? process_one_work+0x1bd/0x2c3
  [<c0443c05>] ? process_one_work+0x173/0x2c3
  [<f8c56e6f>] ? ieee80211_work_work+0x0/0xd36 [mac80211]
  [<c04452fa>] ? worker_thread+0xf7/0x1f7
  [<c0445203>] ? worker_thread+0x0/0x1f7
  [<c0447ccf>] ? kthread+0x62/0x67
  [<c0447c6d>] ? kthread+0x0/0x67
  [<c0403506>] ? kernel_thread_helper+0x6/0x1a
Code: ca 89 75 ec 89 46 04 8b 74 da 04 89 75 f0 89 06 89 0c da 89 4c da 04 8b 55 ec 8b 32 89 4
EIP: [<c043d32b>] cascade+0x40/0x5e SS:ESP 0068:edc57b08

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

