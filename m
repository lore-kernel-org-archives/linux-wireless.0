Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc2-s49.snt0.hotmail.com ([65.54.61.100]:2785 "EHLO
	snt0-omc2-s49.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757092Ab0JFWW2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 18:22:28 -0400
Message-ID: <SNT113-W950221BC00367925B1831F16E0@phx.gbl>
From: Dale Turner <rx_guy@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: carl9170 Crash
Date: Wed, 6 Oct 2010 19:22:26 -0300
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello again. Still having trouble with carl9170. I'm using compat-wireless from Oct 5 and Fedora 13  (2.6.34.7-56.fc13.i686).

Previously i mentioned poor stability with this driver, now I am getting crashes. After this happens, I have NO usb response whatsoever (other wireless adapters won't work, nor will usb memory sticks, etc).

Below is some more info. Needles to say, I am forced to use my other adapter (uses ath9k_htc).

Any thoughts?? Thanks again.

>From abrt:
Package:        kernel
Latest Crash:    Wed 06 Oct 2010 06:11:54 PM 
Command:        not_applicable
Reason:         WARNING: at kernel/workqueue.c:485 flush_cpu_workqueue+0x29/0x6c()
Comment:        None
Bug Reports:    

from /var/log/messages:
Enterprise kernel: ------------[ cut here ]------------
Oct  6 18:10:19 Enterprise kernel: WARNING: at kernel/workqueue.c:485 flush_cpu_workqueue+0x29/0x6c()
Oct  6 18:10:19 Enterprise kernel: Hardware name: P4i65G
Oct  6 18:10:19 Enterprise kernel: Modules linked in: aes_i586 aes_generic arc4 ecb carl9170 mac80211 ath cfg80211 rfkill compat fuse w83627hf hwmon_vid p4_clockmod ipt_MASQUERADE iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec nvidia(P) ac97_bus snd_seq snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep ppdev iTCO_wdt microcode 8139too parport_pc iTCO_vendor_support snd emu10k1_gp 8139cp qcaux i2c_i801 parport mii gameport soundcore i2c_core usbserial cdc_acm [last unloaded: scsi_wait_scan]
Oct  6 18:10:19 Enterprise kernel: Pid: 2302, comm: phy1 Tainted: P           2.6.34.7-56.fc13.i686 #1
Oct  6 18:10:19 Enterprise kernel: Call Trace:
Oct  6 18:10:19 Enterprise kernel: [<c0438822>] warn_slowpath_common+0x6a/0x81
Oct  6 18:10:19 Enterprise kernel: [<c044a65f>] ? flush_cpu_workqueue+0x29/0x6c
Oct  6 18:10:19 Enterprise kernel: [<c043884b>] warn_slowpath_null+0x12/0x15
Oct  6 18:10:19 Enterprise kernel: [<c044a65f>] flush_cpu_workqueue+0x29/0x6c
Oct  6 18:10:19 Enterprise kernel: [<c043def7>] ? local_bh_enable_ip+0xd/0xf
Oct  6 18:10:19 Enterprise kernel: [<c07906d1>] ? _raw_spin_unlock_bh+0x12/0x14
Oct  6 18:10:19 Enterprise kernel: [<f81f6a4a>] ? carl9170_zap_queues+0x1ff/0x248 [carl9170]
Oct  6 18:10:19 Enterprise kernel: [<c044ac77>] flush_workqueue+0x46/0x64
Oct  6 18:10:19 Enterprise kernel: [<f81c25ca>] ieee80211_restart_hw+0x16/0x67 [mac80211]
Oct  6 18:10:19 Enterprise kernel: [<f81f70f9>] carl9170_restart_work+0xd4/0xe5 [carl9170]
Oct  6 18:10:19 Enterprise kernel: [<c044a431>] worker_thread+0x13f/0x1b7
Oct  6 18:10:19 Enterprise kernel: [<f81f7025>] ? carl9170_restart_work+0x0/0xe5 [carl9170]
Oct  6 18:10:19 Enterprise kernel: [<c044d781>] ? autoremove_wake_function+0x0/0x34
Oct  6 18:10:19 Enterprise kernel: [<c044a2f2>] ? worker_thread+0x0/0x1b7
Oct  6 18:10:19 Enterprise kernel: [<c044d419>] kthread+0x64/0x69
Oct  6 18:10:19 Enterprise kernel: [<c044d3b5>] ? kthread+0x0/0x69
Oct  6 18:10:19 Enterprise kernel: [<c04039be>] kernel_thread_helper+0x6/0x10
Oct  6 18:10:19 Enterprise kernel: ---[ end trace fe040e02b912be6d ]---
Oct  6 18:11:54 Enterprise abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Oct  6 18:11:54 Enterprise abrtd: Directory 'kerneloops-1286399514-1298-1' creation detected
Oct  6 18:11:54 Enterprise abrtd: Crash is in database already (dup of /var/spool/abrt/kerneloops-1286203435-1283-1)
Oct  6 18:11:54 Enterprise abrtd: Deleting crash kerneloops-1286399514-1298-1 (dup of kerneloops-1286203435-1283-1), sending dbus signal
Oct  6 18:13:03 Enterprise kernel: INFO: task phy1:2302 blocked for more than 120 seconds.
Oct  6 18:13:03 Enterprise kernel: "echo 0> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  6 18:13:03 Enterprise kernel: phy1          D 0000017d     0  2302      2 0x00000080
Oct  6 18:13:03 Enterprise kernel: ef8f3e80 00000046 1272a913 0000017d c0a5e000 c0a5e000 c0a5e000 c0a5e000
Oct  6 18:13:03 Enterprise kernel: efe99c2c c0a5e000 c0a5e000 00009390 00000000 f6736200 0000017d efe99980
Oct  6 18:13:03 Enterprise kernel: 00000034 ef8f3f20 7fffffff efe99980 ef8f3ec4 c078f429 c08a1942 c08d50ec
Oct  6 18:13:03 Enterprise kernel: Call Trace:
Oct  6 18:13:03 Enterprise kernel: [<c078f429>] schedule_timeout+0x27/0xb2
Oct  6 18:13:03 Enterprise kernel: [<c078f2d8>] wait_for_common+0xc2/0x10b
Oct  6 18:13:03 Enterprise kernel: [<c04346a1>] ? default_wake_function+0x0/0x12
Oct  6 18:13:03 Enterprise kernel: [<c078f3ac>] wait_for_completion+0x17/0x19
Oct  6 18:13:03 Enterprise kernel: [<c044a699>] flush_cpu_workqueue+0x63/0x6c
Oct  6 18:13:03 Enterprise kernel: [<c044a6f0>] ? wq_barrier_func+0x0/0x12
Oct  6 18:13:03 Enterprise kernel: [<c044ac77>] flush_workqueue+0x46/0x64
Oct  6 18:13:03 Enterprise kernel: [<f81c25ca>] ieee80211_restart_hw+0x16/0x67 [mac80211]
Oct  6 18:13:03 Enterprise kernel: [<f81f70f9>] carl9170_restart_work+0xd4/0xe5 [carl9170]
Oct  6 18:13:03 Enterprise kernel: [<c044a431>] worker_thread+0x13f/0x1b7
Oct  6 18:13:03 Enterprise kernel: [<f81f7025>] ? carl9170_restart_work+0x0/0xe5 [carl9170]
Oct  6 18:13:03 Enterprise kernel: [<c044d781>] ? autoremove_wake_function+0x0/0x34
Oct  6 18:13:03 Enterprise kernel: [<c044a2f2>] ? worker_thread+0x0/0x1b7
Oct  6 18:13:03 Enterprise kernel: [<c044d419>] kthread+0x64/0x69
Oct  6 18:13:03 Enterprise kernel: [<c044d3b5>] ? kthread+0x0/0x69
Oct  6 18:13:03 Enterprise kernel: [<c04039be>] kernel_thread_helper+0x6/0x10
Oct  6 18:15:03 Enterprise kernel: INFO: task phy1:2302 blocked for more than 120 seconds.
Oct  6 18:15:03 Enterprise kernel: "echo 0> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  6 18:15:03 Enterprise kernel: phy1          D 0000017d     0  2302      2 0x00000080
Oct  6 18:15:03 Enterprise kernel: ef8f3e80 00000046 1272a913 0000017d c0a5e000 c0a5e000 c0a5e000 c0a5e000
Oct  6 18:15:03 Enterprise kernel: efe99c2c c0a5e000 c0a5e000 00009390 00000000 f6736200 0000017d efe99980
Oct  6 18:15:03 Enterprise kernel: 00000034 ef8f3f20 7fffffff efe99980 ef8f3ec4 c078f429 c08a1942 c08d50ec
Oct  6 18:15:03 Enterprise kernel: Call Trace:
Oct  6 18:15:03 Enterprise kernel: [<c078f429>] schedule_timeout+0x27/0xb2
Oct  6 18:15:03 Enterprise kernel: [<c078f2d8>] wait_for_common+0xc2/0x10b
Oct  6 18:15:03 Enterprise kernel: [<c04346a1>] ? default_wake_function+0x0/0x12
Oct  6 18:15:03 Enterprise kernel: [<c078f3ac>] wait_for_completion+0x17/0x19
Oct  6 18:15:03 Enterprise kernel: [<c044a699>] flush_cpu_workqueue+0x63/0x6c
Oct  6 18:15:03 Enterprise kernel: [<c044a6f0>] ? wq_barrier_func+0x0/0x12
Oct  6 18:15:03 Enterprise kernel: [<c044ac77>] flush_workqueue+0x46/0x64
Oct  6 18:15:03 Enterprise kernel: [<f81c25ca>] ieee80211_restart_hw+0x16/0x67 [mac80211]
Oct  6 18:15:03 Enterprise kernel: [<f81f70f9>] carl9170_restart_work+0xd4/0xe5 [carl9170]
Oct  6 18:15:03 Enterprise kernel: [<c044a431>] worker_thread+0x13f/0x1b7
Oct  6 18:15:03 Enterprise kernel: [<f81f7025>] ? carl9170_restart_work+0x0/0xe5 [carl9170]
Oct  6 18:15:03 Enterprise kernel: [<c044d781>] ? autoremove_wake_function+0x0/0x34
Oct  6 18:15:03 Enterprise kernel: [<c044a2f2>] ? worker_thread+0x0/0x1b7
Oct  6 18:15:03 Enterprise kernel: [<c044d419>] kthread+0x64/0x69
Oct  6 18:15:03 Enterprise kernel: [<c044d3b5>] ? kthread+0x0/0x69
Oct  6 18:15:03 Enterprise kernel: [<c04039be>] kernel_thread_helper+0x6/0x10
Oct  6 18:16:32 Enterprise abrtd: Getting crash infos...
Oct  6 18:17:03 Enterprise kernel: INFO: task phy1:2302 blocked for more than 120 seconds.
Oct  6 18:17:03 Enterprise kernel: "echo 0> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  6 18:17:03 Enterprise kernel: phy1          D 0000017d     0  2302      2 0x00000080
Oct  6 18:17:03 Enterprise kernel: ef8f3e80 00000046 1272a913 0000017d c0a5e000 c0a5e000 c0a5e000 c0a5e000
Oct  6 18:17:03 Enterprise kernel: efe99c2c c0a5e000 c0a5e000 00009390 00000000 f6736200 0000017d efe99980
Oct  6 18:17:03 Enterprise kernel: 00000034 ef8f3f20 7fffffff efe99980 ef8f3ec4 c078f429 c08a1942 c08d50ec
Oct  6 18:17:03 Enterprise kernel: Call Trace:
Oct  6 18:17:03 Enterprise kernel: [<c078f429>] schedule_timeout+0x27/0xb2
Oct  6 18:17:03 Enterprise kernel: [<c078f2d8>] wait_for_common+0xc2/0x10b
Oct  6 18:17:03 Enterprise kernel: [<c04346a1>] ? default_wake_function+0x0/0x12
Oct  6 18:17:03 Enterprise kernel: [<c078f3ac>] wait_for_completion+0x17/0x19
Oct  6 18:17:03 Enterprise kernel: [<c044a699>] flush_cpu_workqueue+0x63/0x6c
Oct  6 18:17:03 Enterprise kernel: [<c044a6f0>] ? wq_barrier_func+0x0/0x12
Oct  6 18:17:03 Enterprise kernel: [<c044ac77>] flush_workqueue+0x46/0x64
Oct  6 18:17:03 Enterprise kernel: [<f81c25ca>] ieee80211_restart_hw+0x16/0x67 [mac80211]
Oct  6 18:17:03 Enterprise kernel: [<f81f70f9>] carl9170_restart_work+0xd4/0xe5 [carl9170]
Oct  6 18:17:03 Enterprise kernel: [<c044a431>] worker_thread+0x13f/0x1b7
Oct  6 18:17:03 Enterprise kernel: [<f81f7025>] ? carl9170_restart_work+0x0/0xe5 [carl9170]
Oct  6 18:17:03 Enterprise kernel: [<c044d781>] ? autoremove_wake_function+0x0/0x34
Oct  6 18:17:03 Enterprise kernel: [<c044a2f2>] ? worker_thread+0x0/0x1b7
Oct  6 18:17:03 Enterprise kernel: [<c044d419>] kthread+0x64/0x69
Oct  6 18:17:03 Enterprise kernel: [<c044d3b5>] ? kthread+0x0/0x69
Oct  6 18:17:03 Enterprise kernel: [<c04039be>] kernel_thread_helper+0x6/0x10
Oct  6 18:17:06 Enterprise kernel: usb 1-2: USB disconnect, address 8
Oct  6 18:19:03 Enterprise kernel: INFO: task phy1:2302 blocked for more than 120 seconds.
Oct  6 18:19:03 Enterprise kernel: "echo 0> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  6 18:19:03 Enterprise kernel: phy1          D 0000017d     0  2302      2 0x00000080
Oct  6 18:19:03 Enterprise kernel: ef8f3e80 00000046 1272a913 0000017d c0a5e000 c0a5e000 c0a5e000 c0a5e000
Oct  6 18:19:03 Enterprise kernel: efe99c2c c0a5e000 c0a5e000 00009390 00000000 f6736200 0000017d efe99980
Oct  6 18:19:03 Enterprise kernel: 00000034 ef8f3f20 7fffffff efe99980 ef8f3ec4 c078f429 c08a1942 c08d50ec
Oct  6 18:19:03 Enterprise kernel: Call Trace:
Oct  6 18:19:03 Enterprise kernel: [<c078f429>] schedule_timeout+0x27/0xb2
Oct  6 18:19:03 Enterprise kernel: [<c078f2d8>] wait_for_common+0xc2/0x10b
Oct  6 18:19:03 Enterprise kernel: [<c04346a1>] ? default_wake_function+0x0/0x12
Oct  6 18:19:03 Enterprise kernel: [<c078f3ac>] wait_for_completion+0x17/0x19
Oct  6 18:19:03 Enterprise kernel: [<c044a699>] flush_cpu_workqueue+0x63/0x6c
Oct  6 18:19:03 Enterprise kernel: [<c044a6f0>] ? wq_barrier_func+0x0/0x12
Oct  6 18:19:03 Enterprise kernel: [<c044ac77>] flush_workqueue+0x46/0x64
Oct  6 18:19:03 Enterprise kernel: [<f81c25ca>] ieee80211_restart_hw+0x16/0x67 [mac80211]
Oct  6 18:19:03 Enterprise kernel: [<f81f70f9>] carl9170_restart_work+0xd4/0xe5 [carl9170]
Oct  6 18:19:03 Enterprise kernel: [<c044a431>] worker_thread+0x13f/0x1b7
Oct  6 18:19:03 Enterprise kernel: [<f81f7025>] ? carl9170_restart_work+0x0/0xe5 [carl9170]
Oct  6 18:19:03 Enterprise kernel: [<c044d781>] ? autoremove_wake_function+0x0/0x34
Oct  6 18:19:03 Enterprise kernel: [<c044a2f2>] ? worker_thread+0x0/0x1b7
Oct  6 18:19:03 Enterprise kernel: [<c044d419>] kthread+0x64/0x69
Oct  6 18:19:03 Enterprise kernel: [<c044d3b5>] ? kthread+0x0/0x69
Oct  6 18:19:03 Enterprise kernel: [<c04039be>] kernel_thread_helper+0x6/0x10
 		 	   		  