Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45833 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZHSUro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 16:47:44 -0400
Received: by fxm17 with SMTP id 17so96227fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 13:47:44 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Aug 2009 22:47:44 +0200
Message-ID: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
Subject: WARNING: at net/mac80211/mlme.c:2292
From: Fabio Comolli <fabio.comolli@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.
I see the following warning on an eeePC 900 (AR5001) running
2.6.31-rc6 after a suspend/resume cycle:

[  292.377941] ------------[ cut here ]------------
[  292.377976] WARNING: at net/mac80211/mlme.c:2292
ieee80211_sta_work+0x89/0xc39 [mac80211]()
[  292.377981] Hardware name: 900
[  292.377984] Modules linked in: arc4 ecb snd_hda_codec_realtek ath5k
snd_hda_intel snd_hda_codec mac80211 snd_pcm_oss snd_mixer_oss
usb_storage ath snd_hwdep battery snd_pcm snd_timer ac cfg80211 snd
soundcore snd_page_alloc thermal button processor uhci_hcd ehci_hcd
[  292.378327] Pid: 866, comm: phy0 Tainted: G   M       2.6.31-rc6-eee #8
[  292.378331] Call Trace:
[  292.378345]  [<c101d13a>] ? warn_slowpath_common+0x5d/0x70
[  292.378354]  [<c101d158>] ? warn_slowpath_null+0xb/0xd
[  292.378379]  [<f87e8ab0>] ? ieee80211_sta_work+0x89/0xc39 [mac80211]
[  292.378398]  [<f8872784>] ? ath5k_hw_reset+0xfdd/0xff1 [ath5k]
[  292.378417]  [<f886b94c>] ? ath5k_hw_set_imr+0x14d/0x156 [ath5k]
[  292.378433]  [<f8873c52>] ? ath5k_beacon_config+0x16c/0x173 [ath5k]
[  292.378449]  [<f8873f85>] ? ath5k_txq_cleanup+0x19b/0x1b5 [ath5k]
[  292.378457]  [<c10199da>] ? __wake_up+0x1d/0x3d
[  292.378466]  [<c102a529>] ? insert_work+0x8f/0x96
[  292.378473]  [<c102a777>] ? queue_work_on+0x24/0x2b
[  292.378480]  [<c102a7a5>] ? queue_work+0x1a/0x39
[  292.378506]  [<f87e64dc>] ?
ieee80211_mlme_notify_scan_completed+0x40/0x66 [mac80211]
[  292.378532]  [<f87e3caa>] ? ieee80211_scan_completed+0x2ef/0x2fc [mac80211]
[  292.378539]  [<c102aaad>] ? worker_thread+0x15c/0x1fd
[  292.378564]  [<f87e8a27>] ? ieee80211_sta_work+0x0/0xc39 [mac80211]
[  292.378572]  [<c102d8e0>] ? autoremove_wake_function+0x0/0x29
[  292.378579]  [<c102a951>] ? worker_thread+0x0/0x1fd
[  292.378586]  [<c102d67f>] ? kthread+0x68/0x6d
[  292.378592]  [<c102d617>] ? kthread+0x0/0x6d
[  292.378600]  [<c1002fb3>] ? kernel_thread_helper+0x7/0x10
[  292.378605] ---[ end trace 7349ad9bfff515b3 ]---

A very similar warning is also seen with compat-wireless pulled 9 days ago:

Aug 10 20:08:35 archeee kernel: [ 1440.840885] ------------[ cut here
]------------
Aug 10 20:08:35 archeee kernel: [ 1440.840932] WARNING: at
/home/fcomolli/SRC/src/compat-wireless-2.6.31-rc4/net/mac80211/mlme.c:2292
ieee80211_sta_work+0x97/0xd30 [mac80211]()
Aug 10 20:08:35 archeee kernel: [ 1440.840939] Hardware name: 900
Aug 10 20:08:35 archeee kernel: [ 1440.840942] Modules linked in:
uvcvideo videodev v4l1_compat arc4 ecb ath5k mac80211 ath cfg80211
Aug 10 20:08:35 archeee kernel: [ 1440.840961] Pid: 3218, comm: phy3
Tainted: G   M    W  2.6.31-rc5 #1
Aug 10 20:08:35 archeee kernel: [ 1440.840966] Call Trace:
Aug 10 20:08:35 archeee kernel: [ 1440.840978]  [<c1024359>]
warn_slowpath_common+0x65/0x7c
Aug 10 20:08:35 archeee kernel: [ 1440.841015]  [<f848b2af>] ?
ieee80211_sta_work+0x97/0xd30 [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841023]  [<c102437d>]
warn_slowpath_null+0xd/0x10
Aug 10 20:08:35 archeee kernel: [ 1440.841058]  [<f848b2af>]
ieee80211_sta_work+0x97/0xd30 [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841069]  [<c101f49b>] ?
__wake_up+0x2f/0x56
Aug 10 20:08:35 archeee kernel: [ 1440.841076]  [<c101f4a9>] ?
__wake_up+0x3d/0x56
Aug 10 20:08:35 archeee kernel: [ 1440.841086]  [<c1032410>] ?
insert_work+0x96/0x9f
Aug 10 20:08:35 archeee kernel: [ 1440.841095]  [<c103266f>] ?
__queue_work+0x32/0x49
Aug 10 20:08:35 archeee kernel: [ 1440.841103]  [<c10326ad>] ?
queue_work_on+0x27/0x2f
Aug 10 20:08:35 archeee kernel: [ 1440.841109]  [<c1032e3b>] ?
queue_work+0x2d/0x45
Aug 10 20:08:35 archeee kernel: [ 1440.841150]  [<f849a9ac>] ?
ieee80211_mesh_notify_scan_completed+0x4d/0x64 [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841185]  [<f84860ce>] ?
ieee80211_scan_completed+0x327/0x32f [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841220]  [<f84861d5>] ?
ieee80211_scan_work+0xb5/0x171 [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841229]  [<c1032981>]
worker_thread+0x15d/0x204
Aug 10 20:08:35 archeee kernel: [ 1440.841265]  [<f848b218>] ?
ieee80211_sta_work+0x0/0xd30 [mac80211]
Aug 10 20:08:35 archeee kernel: [ 1440.841274]  [<c1035b23>] ?
autoremove_wake_function+0x0/0x2f
Aug 10 20:08:35 archeee kernel: [ 1440.841282]  [<c1032824>] ?
worker_thread+0x0/0x204
Aug 10 20:08:35 archeee kernel: [ 1440.841289]  [<c10358b7>] kthread+0x63/0x68
Aug 10 20:08:35 archeee kernel: [ 1440.841296]  [<c1035854>] ? kthread+0x0/0x68
Aug 10 20:08:35 archeee kernel: [ 1440.841305]  [<c10030b3>]
kernel_thread_helper+0x7/0x10
Aug 10 20:08:35 archeee kernel: [ 1440.841310] ---[ end trace
bc8f70f38f66567f ]---


The effect is that after the warning the interface is unusable until
disabled and reenabled with the rfkill switch.
The warning is new in the 31-rc series but the effect was present in
previous versions (at least it probably happened with the 29.x series
- I skipped the 30.x kernels).

The bug is quite easy to reproduce.

Regards,
Fabio
