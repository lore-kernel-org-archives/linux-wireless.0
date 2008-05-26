Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail9.dslextreme.com ([66.51.199.94]:50119 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750714AbYEZEsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 00:48:37 -0400
Message-ID: <483A3F91.6020403@gawab.com> (sfid-20080526_064843_213626_BF386244)
Date: Sun, 25 May 2008 21:41:53 -0700
From: Justin Madru <jdm64@gawab.com>
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been getting kernel crashes at random when a video file just starts 
to play (using VLC).
As soon as the first frame shows, the system locks up hard (sometimes 
not even alt+sysrq+b works).

Just recently, when it crashed it was able to print an oops to the 
syslog. The weird thing is that it says that it's a bug in mac80211? But 
I only have the crash the instant a video file starts to play. (I have 
an Intel 3945 wireles, and Intel i945 graphic card)

BUG: unable to handle kernel NULL pointer dereference at 00000090
IP: [<f89e721f>] :mac80211:ieee80211_associate+0x24f/0x610
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: i915 acpi_cpufreq cpufreq_powersave cpufreq_stats 
cpufreq_userspace cpufreq_conservative container sbs sbshc ext3 jbd 
mbcache arc4 ecb crypto_blkcipher rtc dcdbas cryptomgr crypto_algapi 
psmouse evdev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm iwl3945 
mac80211 snd_timer crc32 snd_page_alloc video backlight output ac button 
battery intel_agp reiserfs sr_mod cdrom sg ata_piix ehci_hcd uhci_hcd 
usbcore thermal processor fan

Pid: 1899, comm: iwl3945 Not tainted (2.6.26-rc3-git #1)
EIP: 0060:[<f89e721f>] EFLAGS: 00010246 CPU: 1
EIP is at ieee80211_associate+0x24f/0x610 [mac80211]
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f7b85e38
ESI: f7b85e84 EDI: ecc7122e EBP: f7bbdd34 ESP: f7bbdcc0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process iwl3945 (pid: 1899, ti=f7bbd000 task=f718d390 task.ti=f7bbd000)
Stack: f7b85e84 00000000 f7bbdd14 00000202 f7b85e38 f7b85800 f7f65f00 
00000018
       f7bbdcfa 00000000 00000421 00000003 00000006 00000052 f7bbdd0c 
ecc7122c
       f71593a4 00000000 f7bbde15 f7bbdd3c c0295679 303a3030 33623a66 
3a31613a
Call Trace:
 [_format_mac_addr+0x79/0x90] ? _format_mac_addr+0x79/0x90
 [sched_debug_show+0x9c6/0xcb0] ? sched_debug_show+0x9c6/0xcb0
 [<f89e7610>] ? ieee80211_auth_completed+0x30/0x40 [mac80211]
 [<f89e7a73>] ? ieee80211_rx_mgmt_auth+0x303/0x4b0 [mac80211]
 [hrtimer_start+0xc2/0x150] ? hrtimer_start+0xc2/0x150
 [hrtick_set+0x85/0x100] ? hrtick_set+0x85/0x100
 [jbd:schedule+0x364/0x8c0] ? schedule+0x364/0x870
 [<f89e7da7>] ? ieee80211_sta_rx_queued_mgmt+0x187/0xcb0 [mac80211]
 [ext3:preempt_schedule+0x33/0x100] ? preempt_schedule+0x33/0x50
 [mac80211:dev_queue_xmit+0xa6/0x1f20] ? dev_queue_xmit+0xa6/0x330
 [mac80211:_spin_unlock_bh+0x18/0xb0] ? _spin_unlock_bh+0x18/0x20
 [<f89e33b7>] ? ieee80211_rx_bss_get+0xa7/0xc0 [mac80211]
 [mac80211:skb_dequeue+0x4d/0x360] ? skb_dequeue+0x4d/0x70
 [<f89e960f>] ? ieee80211_sta_work+0x8f/0x760 [mac80211]
 [hrtick_set+0xa7/0x100] ? hrtick_set+0xa7/0x100
 [jbd:schedule+0x364/0x8c0] ? schedule+0x364/0x870
 [run_workqueue+0x80/0x120] ? run_workqueue+0x80/0x120
 [<f89e9580>] ? ieee80211_sta_work+0x0/0x760 [mac80211]
 [worker_thread+0x88/0xe0] ? worker_thread+0x88/0xe0
 [<c013ba80>] ? autoremove_wake_function+0x0/0x40
 [worker_thread+0x0/0xe0] ? worker_thread+0x0/0xe0
 [kthread+0x42/0x70] ? kthread+0x42/0x70
 [kthread+0x0/0x70] ? kthread+0x0/0x70
 [kernel_thread_helper+0x7/0x18] ? kernel_thread_helper+0x7/0x18
 =======================
Code: c6 00 00 8b 55 9c 8b 4d c8 8b 42 70 88 41 01 8b 42 70 8b 7d c8 89 
c1 c1 e9 02 83 c7 02 f3 a5 89 c1 83 e1 03 74 02 f3 a4 8b 5d d0 <8b> 9b 
90 00 00 00 85 db 89 5d d8 0f 84 6d 03 00 00 8b 7d cc 8b
EIP: [<f89e721f>] ieee80211_associate+0x24f/0x610 [mac80211] SS:ESP 
0068:f7bbdcc0
---[ end trace 7afccad6600bfa21 ]---

Justin Madru

