Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galaxy.systems.pipex.net ([62.241.162.31]:43598 "EHLO
	galaxy.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbXHHWzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:55:11 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Kernel BUG when using ad-hoc mode in rt2x00
Date: Wed, 8 Aug 2007 23:24:17 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	Ivo van Doorn <ivdoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708082324.17186.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been seeing crashes when attempting to run an RT73 based device in ad-hoc 
mode (I'm using the rt2x00 git tree). I recently managed to capture the 
console output when it crashes and it all seems to point more to mac80211 
than the rt2x00 driver so I thought I'd ask here.

a) If anyone can see anything obvious wrong in the trace
b) If anyone has recently tested ad-hoc mode with another driver and can 
confirm it works.

The sequence of events that leads to the crash is
iwconfig wlan1 mode ad-hoc
ifconfig wlan1 192.168.0.230
iwconfig wlan1 channel 11
iwconfig wlan1 essid test

then attempt a scan from another device. 

My guess is that the lockdep warning is caused by trying to lock something in 
which the actual lock object has become corrupted hence it shortly afterwards 
deadlocks.

[ 7053.830623] INFO: trying to register non-static key.
[ 7053.835989] the code is fine but needs lockdep annotation.
[ 7053.841919] turning off the locking correctness validator.
[ 7053.847832]  [<c01470f3>] __lock_acquire+0x573/0x1020
[ 7053.853332]  [<c01465f7>] trace_hardirqs_on+0xb7/0x160
[ 7053.858920]  [<c01473a5>] __lock_acquire+0x825/0x1020
[ 7053.864420]  [<c0147c00>] lock_acquire+0x60/0x80
[ 7053.869450]  [<c02c882c>] skb_queue_tail+0x1c/0x50
[ 7053.874664]  [<c03432c8>] _spin_lock_irqsave+0x38/0x50
[ 7053.880226]  [<c02c882c>] skb_queue_tail+0x1c/0x50
[ 7053.885379]  [<c02c882c>] skb_queue_tail+0x1c/0x50
[ 7053.890543]  [<e0ac536f>] ieee80211_tx_h_ps_buf+0xaf/0x270 [mac80211]
[ 7053.897543]  [<e0ad15c5>] sta_info_get+0x55/0x60 [mac80211]
[ 7053.903601]  [<e0ad15c5>] sta_info_get+0x55/0x60 [mac80211]
[ 7053.909662]  [<e0ac8325>] ieee80211_master_start_xmit+0x2b5/0x600 
[mac80211]
[ 7053.917346]  [<c02ced0b>] dev_hard_start_xmit+0x1fb/0x2d0
[ 7053.923189]  [<c02dfba3>] __qdisc_run+0x53/0x1c0
[ 7053.928221]  [<c02dfbcd>] __qdisc_run+0x7d/0x1c0
[ 7053.933226]  [<c02d0f62>] dev_queue_xmit+0x2e2/0x330
[ 7053.938595]  [<e0ad8101>] ieee80211_sta_scan_work+0x201/0x240 [mac80211]
[ 7053.945878]  [<e0ad7f00>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 7053.952962]  [<c01465f7>] trace_hardirqs_on+0xb7/0x160
[ 7053.958521]  [<c0138b6e>] run_workqueue+0xe/0x150
[ 7053.963620]  [<e0ad7f00>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 7053.970711]  [<c0138c1f>] run_workqueue+0xbf/0x150
[ 7053.975904]  [<c0139610>] worker_thread+0x0/0x100
[ 7053.981018]  [<c01396b0>] worker_thread+0xa0/0x100
[ 7053.986174]  [<c013c600>] autoremove_wake_function+0x0/0x50
[ 7053.992212]  [<c0139610>] worker_thread+0x0/0x100
[ 7053.997298]  [<c013c382>] kthread+0x42/0x70
[ 7054.001799]  [<c013c340>] kthread+0x0/0x70
[ 7054.006235]  [<c0105537>] kernel_thread_helper+0x7/0x10
[ 7054.011925]  =======================
[ 7059.169014] BUG: NMI Watchdog detected LOCKUP on CPU0, eip c022ba50, 
registers:
[ 7059.176941] Modules linked in: rfcomm l2cap binfmt_misc cpufreq_powersave 
cpufreq_stats cpufreq_userspace cpufreq_ondemand cpufreq_conservative 
freq_table video output battery container sbs fan button thermal processor 
dock ac bluetooth sg ipv6 nfs lockd sd_mod sunrpc asb100 hwmon_vid af_packet 
lp rt2500usb arc4 ecb blkcipher rc80211_simple usb_storage rt73usb scsi_mod 
rt2x00usb rt2x00lib input_polldev crc_itu_t libusual mac80211 snd_ens1371 
gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm_oss 
snd_mixer_oss snd_pcm snd_timer tsdev i2c_viapro snd 8139too i2c_core 
ehci_hcd uhci_hcd via_agp serio_raw via_ircc soundcore snd_page_alloc shpchp 
8139cp irda agpgart mii usbcore crc_ccitt parport_pc parport pci_hotplug 
evdev psmouse floppy pcspkr
[ 7059.250390] CPU:    0
[ 7059.250391] EIP:    0060:[<c022ba50>]    Not tainted VLI
[ 7059.250392] EFLAGS: 00000046   (2.6.23-rc1 #6)
[ 7059.263355] EIP is at __delay+0x0/0x10
[ 7059.267415] eax: 00000001   ebx: dbb0591c   ecx: 17e8625e   edx: 65e66186
[ 7059.274755] esi: 0e6cdab6   edi: 00000000   ebp: 6b8abb30   esp: dba03d94
[ 7059.282066] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[ 7059.288351] Process rt73usb (pid: 2160, ti=dba02000 task=dfde2630 
task.ti=dba02000)
[ 7059.296435] Stack: c022e478 dfde2c1c 00000046 dbb0592c dbb0591c cc617c28 
00000001 6b8abb30 
[ 7059.305694]        00000000 dbb0591c 00000296 dbb0591c cc617c28 c03432cf 
00000000 00000002 
[ 7059.314912]        c02c882c dbb05910 d2503b40 c02c882c 00000000 dba03e5c 
00000001 e0ac536f 
[ 7059.324030] Call Trace:
[ 7059.326872]  [<c022e478>] _raw_spin_lock+0xb8/0x150
[ 7059.332164]  [<c03432cf>] _spin_lock_irqsave+0x3f/0x50
[ 7059.337747]  [<c02c882c>] skb_queue_tail+0x1c/0x50
[ 7059.342898]  [<c02c882c>] skb_queue_tail+0x1c/0x50
[ 7059.348062]  [<e0ac536f>] ieee80211_tx_h_ps_buf+0xaf/0x270 [mac80211]
[ 7059.355059]  [<e0ad15c5>] sta_info_get+0x55/0x60 [mac80211]
[ 7059.361120]  [<e0ad15c5>] sta_info_get+0x55/0x60 [mac80211]
[ 7059.367182]  [<e0ac8325>] ieee80211_master_start_xmit+0x2b5/0x600 
[mac80211]
[ 7059.374865]  [<c02ced0b>] dev_hard_start_xmit+0x1fb/0x2d0
[ 7059.380674]  [<c02dfba3>] __qdisc_run+0x53/0x1c0
[ 7059.385651]  [<c02dfbcd>] __qdisc_run+0x7d/0x1c0
[ 7059.390651]  [<c02d0f62>] dev_queue_xmit+0x2e2/0x330
[ 7059.396052]  [<e0ad8101>] ieee80211_sta_scan_work+0x201/0x240 [mac80211]
[ 7059.403333]  [<e0ad7f00>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 7059.410431]  [<c01465f7>] trace_hardirqs_on+0xb7/0x160
[ 7059.415985]  [<c0138b6e>] run_workqueue+0xe/0x150
[ 7059.421090]  [<e0ad7f00>] ieee80211_sta_scan_work+0x0/0x240 [mac80211]
[ 7059.428169]  [<c0138c1f>] run_workqueue+0xbf/0x150
[ 7059.433389]  [<c0139610>] worker_thread+0x0/0x100
[ 7059.438511]  [<c01396b0>] worker_thread+0xa0/0x100
[ 7059.443727]  [<c013c600>] autoremove_wake_function+0x0/0x50
[ 7059.449758]  [<c0139610>] worker_thread+0x0/0x100
[ 7059.454882]  [<c013c382>] kthread+0x42/0x70
[ 7059.459412]  [<c013c340>] kthread+0x0/0x70
[ 7059.463850]  [<c0105537>] kernel_thread_helper+0x7/0x10
[ 7059.469544]  =======================
[ 7059.473412] Code: c0 80 ba 22 c0 c3 90 8d 74 26 00 81 3d e4 8e 42 c0 80 ba 
22 c0 89 c1 b8 ff ff ff ff 74 02 f3 c3 0f 31 89 01 31 c0 c3 8d 74 26 00 <ff> 
15 e4 8e 42 c0 f3 c3 90 8d b4 26 00 00 00 00 64 8b 15 08 40 
