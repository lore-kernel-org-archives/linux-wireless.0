Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63644 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbZJ1ShX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 14:37:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 11:37:28 -0700
Date: Wed, 28 Oct 2009 11:37:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: odd state reached when AP deauths you after assoc
Message-ID: <20091028183726.GA4952@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I ran into this when ath5k with wpa_supplicant with config file with
a wrong password against a Cisco AP. It seems the Cisco AP auths you
and lets you assoc but later it deauths you -- I guess after it
determines you are auth credentials failed. When this happens I get:

mcgrof@tux ~ $ iw dev wlan0 link
Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
Not connected.

The log *after* this is below. I'll try to reproduce again, I can reproduce
all the time.

[  171.905675] wlan0: deauthenticating from 00:0b:85:5b:a6:ec by local choice (reason=3)
[  171.929065] ------------[ cut here ]------------
[  171.929106] WARNING: at net/mac80211/scan.c:267 ieee80211_scan_completed+0x240/0x270 [mac80211]()
[  171.929112] Hardware name: 7660A14
[  171.929117] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit binfmt_misc ppdev bridge stp bnep lp parport snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi ath5k snd_seq_midi_event snd_seq joydev snd_timer snd_seq_device mac80211 ath snd pcmcia soundcore cfg80211 thinkpad_acpi video intel_agp psmouse snd_page_alloc nvram led_class yenta_socket rsrc_nonstatic pcmcia_core output agpgart pcspkr serio_raw btusb iTCO_wdt iTCO_vendor_support ohci1394 ieee1394 e1000e
[  171.929226] Pid: 4022, comm: wpa_supplicant Not tainted 2.6.32-rc5-wl #27
[  171.929231] Call Trace:
[  171.929245]  [<c05a3a23>] ? printk+0x1d/0x22
[  171.929269]  [<f8379040>] ? ieee80211_scan_completed+0x240/0x270 [mac80211]
[  171.929281]  [<c0146121>] warn_slowpath_common+0x71/0xd0
[  171.929306]  [<f8379040>] ? ieee80211_scan_completed+0x240/0x270 [mac80211]
[  171.929316]  [<c014619a>] warn_slowpath_null+0x1a/0x20
[  171.929340]  [<f8379040>] ieee80211_scan_completed+0x240/0x270 [mac80211]
[  171.929363]  [<f83790b9>] ieee80211_scan_cancel+0x49/0x80 [mac80211]
[  171.929388]  [<f83826ca>] ieee80211_stop+0x59a/0x5b0 [mac80211]
[  171.929399]  [<c04e513e>] ? dev_deactivate+0x17e/0x1a0
[  171.929412]  [<c04d34cb>] dev_close+0x6b/0xc0
[  171.929421]  [<c05a6733>] ? _spin_unlock_bh+0x13/0x20
[  171.929430]  [<c04d150f>] ? dev_set_rx_mode+0x2f/0x40
[  171.929438]  [<c04d2d44>] dev_change_flags+0x84/0x1d0
[  171.929448]  [<c05207ea>] devinet_ioctl+0x54a/0x600
[  171.929456]  [<c04d489d>] ? dev_ioctl+0x28d/0x530
[  171.929465]  [<c0521c6a>] inet_ioctl+0x9a/0xc0
[  171.929475]  [<c04c25c8>] sock_ioctl+0x68/0x270
[  171.929483]  [<c04c2560>] ? sock_ioctl+0x0/0x270
[  171.929493]  [<c021bb9d>] vfs_ioctl+0x2d/0x90
[  171.929501]  [<c021bd62>] do_vfs_ioctl+0x72/0x5f0
[  171.929510]  [<c02267bf>] ? mntput_no_expire+0x1f/0xd0
[  171.929520]  [<c020c2ca>] ? __fput+0x17a/0x1f0
[  171.929529]  [<c020c367>] ? fput+0x27/0x30
[  171.929537]  [<c0207aec>] ? filp_close+0x4c/0x80
[  171.929545]  [<c021c34b>] sys_ioctl+0x6b/0x70
[  171.929554]  [<c01030dc>] sysenter_do_call+0x12/0x28
[  171.929560] ---[ end trace d6c0a8110c16e049 ]---
[  171.937047] phy0: device now idle
[  171.938704] ------------[ cut here ]------------
[  171.938733] WARNING: at net/wireless/core.c:619 wdev_cleanup_work+0xbf/0xe0 [cfg80211]()
[  171.938741] Hardware name: 7660A14
[  171.938746] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit binfmt_misc ppdev bridge stp bnep lp parport snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi ath5k snd_seq_midi_event snd_seq joydev snd_timer snd_seq_device mac80211 ath snd pcmcia soundcore cfg80211 thinkpad_acpi video intel_agp psmouse snd_page_alloc nvram led_class yenta_socket rsrc_nonstatic pcmcia_core output agpgart pcspkr serio_raw btusb iTCO_wdt iTCO_vendor_support ohci1394 ieee1394 e1000e
[  171.938873] Pid: 9, comm: events/0 Tainted: G        W  2.6.32-rc5-wl #27
[  171.938880] Call Trace:
[  171.938892]  [<c05a3a23>] ? printk+0x1d/0x22
[  171.938910]  [<f82cd18f>] ? wdev_cleanup_work+0xbf/0xe0 [cfg80211]
[  171.938922]  [<c0146121>] warn_slowpath_common+0x71/0xd0
[  171.938939]  [<f82cd18f>] ? wdev_cleanup_work+0xbf/0xe0 [cfg80211]
[  171.938950]  [<c014619a>] warn_slowpath_null+0x1a/0x20
[  171.938967]  [<f82cd18f>] wdev_cleanup_work+0xbf/0xe0 [cfg80211]
[  171.938981]  [<c01639b4>] worker_thread+0x134/0x200
[  171.938998]  [<f82cd0d0>] ? wdev_cleanup_work+0x0/0xe0 [cfg80211]
[  171.939010]  [<c0168600>] ? autoremove_wake_function+0x0/0x50
[  171.939021]  [<c0163880>] ? worker_thread+0x0/0x200
[  171.939031]  [<c01682b4>] kthread+0x74/0x80
[  171.939041]  [<c0168240>] ? kthread+0x0/0x80
[  171.939051]  [<c0103c47>] kernel_thread_helper+0x7/0x10
[  171.939059] ---[ end trace d6c0a8110c16e04a ]---
[  171.957054] CE: hpet increasing min_delta_ns to 15000 nsec
[  173.591594] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  173.816116] phy0: device no longer idle - scanning
[  177.440103] ------------[ cut here ]------------
[  177.440138] WARNING: at net/wireless/scan.c:88 cfg80211_scan_done+0x4b/0x50 [cfg80211]()
[  177.440145] Hardware name: 7660A14
[  177.440150] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit binfmt_misc ppdev bridge stp bnep lp parport snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi ath5k snd_seq_midi_event snd_seq joydev snd_timer snd_seq_device mac80211 ath snd pcmcia soundcore cfg80211 thinkpad_acpi video intel_agp psmouse snd_page_alloc nvram led_class yenta_socket rsrc_nonstatic pcmcia_core output agpgart pcspkr serio_raw btusb iTCO_wdt iTCO_vendor_support ohci1394 ieee1394 e1000e
[  177.440256] Pid: 1864, comm: phy0 Tainted: G        W  2.6.32-rc5-wl #27
[  177.440262] Call Trace:
[  177.440275]  [<c05a3a23>] ? printk+0x1d/0x22
[  177.440293]  [<f82d17fb>] ? cfg80211_scan_done+0x4b/0x50 [cfg80211]
[  177.440306]  [<c0146121>] warn_slowpath_common+0x71/0xd0
[  177.440322]  [<f82d17fb>] ? cfg80211_scan_done+0x4b/0x50 [cfg80211]
[  177.440332]  [<c014619a>] warn_slowpath_null+0x1a/0x20
[  177.440349]  [<f82d17fb>] cfg80211_scan_done+0x4b/0x50 [cfg80211]
[  177.440374]  [<f8378e54>] ieee80211_scan_completed+0x54/0x270 [mac80211]
[  177.440397]  [<f8379236>] ieee80211_scan_work+0x146/0x4b0 [mac80211]
[  177.440408]  [<c01bb51d>] ? probe_workqueue_execution+0x8d/0xb0
[  177.440420]  [<c01639b4>] worker_thread+0x134/0x200
[  177.440444]  [<f83790f0>] ? ieee80211_scan_work+0x0/0x4b0 [mac80211]
[  177.440454]  [<c0168600>] ? autoremove_wake_function+0x0/0x50
[  177.440463]  [<c0163880>] ? worker_thread+0x0/0x200
[  177.440471]  [<c01682b4>] kthread+0x74/0x80
[  177.440479]  [<c0168240>] ? kthread+0x0/0x80
[  177.440488]  [<c0103c47>] kernel_thread_helper+0x7/0x10
[  177.440494] ---[ end trace d6c0a8110c16e04b ]---
[  177.443939] phy0: device now idle
[  183.714141] phy0: device no longer idle - scanning
[  187.335604] wlan0: direct probe to AP 00:0b:85:5b:a6:ec (try 1)
[  187.338695] wlan0: direct probe responded
[  187.338703] wlan0: authenticate with AP 00:0b:85:5b:a6:ec (try 1)
[  187.340329] wlan0: authenticated
[  187.340635] wlan0: associate with AP 00:0b:85:5b:a6:ec (try 1)
[  187.343385] wlan0: RX AssocResp from 00:0b:85:5b:a6:ec (capab=0x431 status=0 aid=52)
[  187.343392] wlan0: associated
[  187.343401] phy0: Allocated STA 00:0b:85:5b:a6:ec
[  187.344165] phy0: Inserted STA 00:0b:85:5b:a6:ec
[  187.344924] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  187.345770] cfg80211: Calling CRDA for country: US
[  187.352927] cfg80211: Received country IE:
[  187.352935] cfg80211: Regulatory domain: US
[  187.352939] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  187.352947] 	(2402000 KHz - 2477000 KHz @ 40000 KHz), (10000 mBi, 10000 mBm)
[  187.352952] cfg80211: CRDA thinks this should applied:
[  187.352956] cfg80211: Regulatory domain: US
[  187.352960] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  187.352967] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  187.352974] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  187.352980] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  187.352987] 	(5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  187.352994] 	(5651000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  187.353000] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  187.353005] cfg80211: We intersect both of these and get:
[  187.353010] cfg80211: Regulatory domain: 98
[  187.353014] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  187.353020] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  187.353033] cfg80211: Disabling channel 2467 MHz on phy0 due to Country IE
[  187.353038] cfg80211: Disabling channel 2472 MHz on phy0 due to Country IE
[  187.353044] cfg80211: Disabling channel 2484 MHz on phy0 due to Country IE
[  187.353050] cfg80211: Leaving channel 5180 MHz intact on phy0 - no rule found in band on Country IE
[  187.353060] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[  187.353068] cfg80211: Leaving channel 5200 MHz intact on phy0 - no rule found in band on Country IE
[  187.353075] cfg80211: Leaving channel 5220 MHz intact on phy0 - no rule found in band on Country IE
[  187.353083] cfg80211: Leaving channel 5240 MHz intact on phy0 - no rule found in band on Country IE
[  187.353091] cfg80211: Leaving channel 5260 MHz intact on phy0 - no rule found in band on Country IE
[  187.353098] cfg80211: Leaving channel 5280 MHz intact on phy0 - no rule found in band on Country IE
[  187.353106] cfg80211: Leaving channel 5300 MHz intact on phy0 - no rule found in band on Country IE
[  187.353113] cfg80211: Leaving channel 5320 MHz intact on phy0 - no rule found in band on Country IE
[  187.353121] cfg80211: Leaving channel 5500 MHz intact on phy0 - no rule found in band on Country IE
[  187.353129] cfg80211: Leaving channel 5520 MHz intact on phy0 - no rule found in band on Country IE
[  187.353136] cfg80211: Leaving channel 5540 MHz intact on phy0 - no rule found in band on Country IE
[  187.353144] cfg80211: Leaving channel 5560 MHz intact on phy0 - no rule found in band on Country IE
[  187.353151] cfg80211: Leaving channel 5580 MHz intact on phy0 - no rule found in band on Country IE
[  187.353159] cfg80211: Leaving channel 5600 MHz intact on phy0 - no rule found in band on Country IE
[  187.353167] cfg80211: Leaving channel 5620 MHz intact on phy0 - no rule found in band on Country IE
[  187.353175] cfg80211: Leaving channel 5640 MHz intact on phy0 - no rule found in band on Country IE
[  187.353183] cfg80211: Leaving channel 5660 MHz intact on phy0 - no rule found in band on Country IE
[  187.353190] cfg80211: Leaving channel 5680 MHz intact on phy0 - no rule found in band on Country IE
[  187.353198] cfg80211: Leaving channel 5700 MHz intact on phy0 - no rule found in band on Country IE
[  187.353205] cfg80211: Leaving channel 5745 MHz intact on phy0 - no rule found in band on Country IE
[  187.353213] cfg80211: Leaving channel 5765 MHz intact on phy0 - no rule found in band on Country IE
[  187.353221] cfg80211: Leaving channel 5785 MHz intact on phy0 - no rule found in band on Country IE
[  187.353228] cfg80211: Leaving channel 5805 MHz intact on phy0 - no rule found in band on Country IE
[  187.353236] cfg80211: Leaving channel 5825 MHz intact on phy0 - no rule found in band on Country IE
[  187.353253] cfg80211: Current regulatory domain updated by AP to: US
[  187.353258] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  187.353265] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  187.805098] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[  188.804121] wlan0: dropped frame to 00:0b:85:5b:a6:ec (unauthorized port)
[  191.290511] wlan0: deauthenticated from 00:0b:85:5b:a6:ec (Reason: 1)
[  191.290536] phy0: device now idle
[  191.290573] phy0: Removed STA 00:0b:85:5b:a6:ec
[  191.321556] phy0: Destroyed STA 00:0b:85:5b:a6:ec
[  191.421927] phy0: device no longer idle - scanning
[  194.672155] wlan0: direct probe to AP 00:0b:85:5b:a6:e3 (try 1)
[  194.673139] wlan0: direct probe responded
[  194.673146] wlan0: authenticate with AP 00:0b:85:5b:a6:e3 (try 1)
[  194.674160] wlan0: authenticated
[  194.674494] wlan0: associate with AP 00:0b:85:5b:a6:e3 (try 1)
[  194.677426] wlan0: RX AssocResp from 00:0b:85:5b:a6:e3 (capab=0x11 status=0 aid=70)
[  194.677433] wlan0: associated
[  194.677442] phy0: Allocated STA 00:0b:85:5b:a6:e3
[  194.677931] phy0: Inserted STA 00:0b:85:5b:a6:e3
[  196.804059] wlan0: dropped frame to 00:0b:85:5b:a6:e3 (unauthorized port)
[  197.689989] wlan0: deauthenticated from 00:0b:85:5b:a6:e3 (Reason: 1)
[  197.690012] phy0: device now idle
[  197.690047] phy0: Removed STA 00:0b:85:5b:a6:e3
[  197.717474] phy0: Destroyed STA 00:0b:85:5b:a6:e3
[  197.805059] wlan0: no IPv6 routers present
[  197.818000] phy0: device no longer idle - scanning
[  201.079270] phy0: device now idle
[  201.084747] phy0: device no longer idle - in use
[  201.084770] wlan0: direct probe to AP 00:0b:85:5b:a6:ec (try 1)
[  201.089664] wlan0: direct probe responded
[  201.089668] wlan0: authenticate with AP 00:0b:85:5b:a6:ec (try 1)
[  201.092158] wlan0: authenticated
[  201.092452] wlan0: associate with AP 00:0b:85:5b:a6:ec (try 1)
[  201.096074] wlan0: RX AssocResp from 00:0b:85:5b:a6:ec (capab=0x431 status=0 aid=52)
[  201.096081] wlan0: associated
[  201.096090] phy0: Allocated STA 00:0b:85:5b:a6:ec
[  201.096552] phy0: Inserted STA 00:0b:85:5b:a6:ec
[  204.093552] wlan0: deauthenticated from 00:0b:85:5b:a6:ec (Reason: 1)
[  204.093575] phy0: device now idle
[  204.093612] phy0: Removed STA 00:0b:85:5b:a6:ec
[  204.113479] phy0: Destroyed STA 00:0b:85:5b:a6:ec
[  204.214013] phy0: device no longer idle - scanning
[  207.471524] phy0: device now idle
[  207.476732] phy0: device no longer idle - in use
[  207.476756] wlan0: direct probe to AP 00:0b:85:5b:a6:e3 (try 1)
[  207.477684] wlan0: direct probe responded
[  207.477687] wlan0: authenticate with AP 00:0b:85:5b:a6:e3 (try 1)
[  207.479033] wlan0: authenticated
[  207.479171] wlan0: associate with AP 00:0b:85:5b:a6:e3 (try 1)
[  207.480744] wlan0: RX AssocResp from 00:0b:85:5b:a6:e3 (capab=0x11 status=0 aid=72)
[  207.480748] wlan0: associated
[  207.480752] phy0: Allocated STA 00:0b:85:5b:a6:e3
[  207.480965] phy0: Inserted STA 00:0b:85:5b:a6:e3
[  210.489907] wlan0: deauthenticated from 00:0b:85:5b:a6:e3 (Reason: 1)
[  210.489930] phy0: device now idle
[  210.489968] phy0: Removed STA 00:0b:85:5b:a6:e3
[  210.521484] phy0: Destroyed STA 00:0b:85:5b:a6:e3
[  210.621987] phy0: device no longer idle - scanning
[  213.876178] phy0: device now idle
[  213.879982] phy0: device no longer idle - in use
[  213.880004] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 1)
[  214.080136] wlan0: direct probe to AP 00:0b:85:5b:8d:6c (try 2)
[  214.089058] wlan0: direct probe responded
[  214.089066] wlan0: authenticate with AP 00:0b:85:5b:8d:6c (try 1)
[  214.107502] wlan0: authenticated
[  214.107916] wlan0: associate with AP 00:0b:85:5b:8d:6c (try 1)
[  214.122278] wlan0: RX AssocResp from 00:0b:85:5b:8d:6c (capab=0x401 status=17 aid=0)
[  214.122285] wlan0: AP denied association (code=17)

  Luis
