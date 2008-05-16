Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33192 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbYEPV2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:28:12 -0400
Message-ID: <482DFC63.7050908@lwfinger.net> (sfid-20080516_232819_154745_789BEFA2)
Date: Fri, 16 May 2008 16:28:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: NULL pointer in mac80211:ieee80211_associate
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this report is new. If it is a duplicate, I apologize for any noise. 
My kernel is from wireless-testing. A 'uname -r' commands yields 
2.6.26-rc2-wl-07884-g5d3790d-dirty. It is "dirty" due to some trial patches 
in the b43 driver that should not have any effect on this oops. The computer 
is running the x86_64 version of openSUSE 10.3, and I have not seen this oops 
before.

The system was last booted at 18:02 on May 15. Until 10:10:58, everything 
seemed normal. Then a reason 3 deauthentication arrived, and the following 
ensued:

May 16 10:10:58 larrylap kernel: eth1: deauthenticate(reason=3)
May 16 10:10:58 larrylap kernel: eth1: RX deauthentication from 
00:1a:70:46:ba:b1 (reason=15)
May 16 10:10:58 larrylap kernel: eth1: deauthenticated
May 16 10:10:58 larrylap avahi-daemon[3042]: Withdrawing address record for 
192.168.1.122 on eth1.
May 16 10:10:58 larrylap avahi-daemon[3042]: Leaving mDNS multicast
  group on interface eth1.IPv4 with address 192.168.1.122.
May 16 10:10:58 larrylap avahi-daemon[3042]: Interface eth1.IPv4 no longer 
relevant for mDNS.
May 16 10:10:59 larrylap kernel: eth1: authenticate with AP 00:1a:70:46:ba:b1
May 16 10:10:59 larrylap kernel: eth1: RX authentication from 
00:1a:70:46:ba:b1 (alg=0 transaction=2 status=0)
May 16 10:10:59 larrylap kernel: eth1: authenticated
May 16 10:10:59 larrylap kernel: eth1: associate with AP 00:1a:70:46:ba:b1
May 16 10:10:59 larrylap kernel: BUG: unable to handle kernel NULL pointer 
dereference at 00000000000000c0
May 16 10:10:59 larrylap kernel: IP: [<ffffffffa0159eb1>] 
:mac80211:ieee80211_associate+0x2ba/0x53e
May 16 10:10:59 larrylap kernel: PGD b8258067 PUD b8259067 PMD 0
May 16 10:10:59 larrylap kernel: Oops: 0000 [1] SMP
May 16 10:10:59 larrylap kernel: CPU 0
May 16 10:10:59 larrylap kernel: Modules linked in: af_packet snd_pcm_oss 
snd_mixer_oss snd_seq snd_seq_device sunrpc rfki
ll_input cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 
fuse loop dm_mod snd_hda_intel snd_pcm sr_mo
d snd_timer snd soundcore k8temp hwmon cdrom snd_page_alloc forcedeth 
serio_raw ac battery sg arc4 ecb crypto_blkcipher bu
tton b43 firmware_class ssb rfkill mac80211 joydev cfg80211 led_class 
input_polldev ohci_hcd ehci_hcd sd_mod usbcore edd e
xt3 mbcache jbd fan ahci pata_amd libata scsi_mod dock thermal processor
May 16 10:10:59 larrylap kernel: Pid: 1684, comm: b43 Not tainted 
2.6.26-rc2-wl-07884-g5d3790d-dirty #3
May 16 10:10:59 larrylap kernel: RIP: 0010:[<ffffffffa0159eb1>] 
[<ffffffffa0159eb1>] :mac80211:ieee80211_associate+0x2ba/
0x53e
May 16 10:10:59 larrylap kernel: RSP: 0018:ffff8100b9fdbb50  EFLAGS: 00010246
May 16 10:10:59 larrylap kernel: RAX: 0000000000000000 RBX: ffff8100b96ef410 
RCX: 0000000000000000
May 16 10:10:59 larrylap kernel: RDX: ffff810037b88000 RSI: 0000000000000000 
RDI: ffff8100b96ef42e
May 16 10:10:59 larrylap kernel: RBP: 0000000000000000 R08: 0000000000000000 
R09: ffff8100b8ee7780
May 16 10:10:59 larrylap kernel: R10: ffff8100b8a3e480 R11: ffff8100b8a3e480 
R12: ffff810037b88b90
May 16 10:10:59 larrylap kernel: R13: ffff8100b8ee7780 R14: ffff8100b96ef42c 
R15: ffffffffa01bbb70
May 16 10:10:59 larrylap kernel: FS:  00007fab6fcac700(0000) 
GS:ffffffff8054e000(0000) knlGS:00000000f6398b10
May 16 10:10:59 larrylap kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
May 16 10:10:59 larrylap kernel: CR2: 00000000000000c0 CR3: 00000000b8257000 
CR4: 00000000000006e0
May 16 10:10:59 larrylap kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
May 16 10:10:59 larrylap kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
May 16 10:10:59 larrylap kernel: Process b43 (pid: 1684, threadinfo 
ffff8100b9fda000, task ffff8100b871e780)
May 16 10:10:59 larrylap kernel: Stack:  ffffffff8028c3d0 ffff810037b88000 
ffffffff8028bdc1 0000000037b88be0
May 16 10:10:59 larrylap kernel:  ffff810037b88c24 0000000000000000 
30373a61313a3030 623a61623a36343a
May 16 10:10:59 larrylap kernel:  ffff8100bb6b0031 ffff8100b9fdbd20 
ffff8100b878a034 0000000000000002
May 16 10:10:59 larrylap kernel: Call Trace:
May 16 10:10:59 larrylap kernel:  [<ffffffff8028c3d0>] kfree+0x1d6/0x1e5
May 16 10:10:59 larrylap kernel:  [<ffffffff8028bdc1>] 
kmem_cache_free+0x19b/0x1aa
May 16 10:10:59 larrylap kernel:  [<ffffffffa015a816>] 
:mac80211:ieee80211_sta_rx_queued_mgmt+0x54b/0xf0b
May 16 10:10:59 larrylap kernel:  [<ffffffffa0162376>] 
:mac80211:ieee80211_master_start_xmit+0x3af/0x3cc
May 16 10:10:59 larrylap kernel:  [<ffffffff802377ef>] 
local_bh_enable_ip+0xd0/0xd7
May 16 10:10:59 larrylap kernel:  [<ffffffff8024e48c>] mark_held_locks+0x58/0x72
May 16 10:10:59 larrylap kernel:  [<ffffffff803f8fb7>] 
_spin_unlock_irqrestore+0x3f/0x46
May 16 10:10:59 larrylap kernel:  [<ffffffff8024e61c>] 
trace_hardirqs_on+0xef/0x113
May 16 10:10:59 larrylap kernel:  [<ffffffffa015b912>] 
:mac80211:ieee80211_sta_work+0xb6/0x738
May 16 10:10:59 larrylap kernel:  [<ffffffff803f8e94>] _spin_unlock_irq+0x24/0x27
May 16 10:10:59 larrylap kernel:  [<ffffffff8024e61c>] 
trace_hardirqs_on+0xef/0x113
May 16 10:10:59 larrylap kernel:  [<ffffffffa015b85c>] 
:mac80211:ieee80211_sta_work+0x0/0x738
May 16 10:10:59 larrylap kernel:  [<ffffffff8024162b>] run_workqueue+0xe3/0x1ec
May 16 10:10:59 larrylap kernel:  [<ffffffff80242115>] worker_thread+0xdc/0xeb
May 16 10:10:59 larrylap kernel:  [<ffffffff80244b67>] 
autoremove_wake_function+0x0/0x2e
May 16 10:10:59 larrylap kernel:  [<ffffffff80242039>] worker_thread+0x0/0xeb
May 16 10:10:59 larrylap kernel:  [<ffffffff80244a4b>] kthread+0x47/0x74
May 16 10:10:59 larrylap kernel:  [<ffffffff803f8921>] 
trace_hardirqs_on_thunk+0x35/0x3a
May 16 10:10:59 larrylap kernel:  [<ffffffff8020ccf8>] child_rip+0xa/0x12
May 16 10:10:59 larrylap kernel:  [<ffffffff8020c40f>] restore_args+0x0/0x30
May 16 10:10:59 larrylap kernel:  [<ffffffff802448c2>] kthreadd+0x17f/0x1a4
May 16 10:10:59 larrylap kernel:  [<ffffffff80244a04>] kthread+0x0/0x74
May 16 10:10:59 larrylap kernel:  [<ffffffff8020ccee>] child_rip+0x0/0x12
May 16 10:10:59 larrylap kernel:
May 16 10:10:59 larrylap kernel:
May 16 10:10:59 larrylap kernel: Code: 00 49 89 c6 49 8b 84 24 b8 00 00 00 49 
8d 7e 02 fc 41 88 46 01 49 8b 8c 24 b8 00 00 00 48 8b 74 24 20 f3 a4 31 f6 48 
8b 4c 24 28 <4c> 8b 89 c0 00 00 00 48 c7 44 24 10 00 00 00 00 eb 4a 48 8b 5c
May 16 10:10:59 larrylap kernel: RIP  [<ffffffffa0159eb1>] 
:mac80211:ieee80211_associate+0x2ba/0x53e
May 16 10:10:59 larrylap kernel: RIP  [<ffffffffa0159eb1>] 
:mac80211:ieee80211_associate+0x2ba/0x53e
May 16 10:10:59 larrylap kernel:  RSP <ffff8100b9fdbb50>
May 16 10:10:59 larrylap kernel: CR2: 00000000000000c0
May 16 10:10:59 larrylap kernel: ---[ end trace 0010c8900b24b09d ]---

Please let me know if you need additional information.

Larry
