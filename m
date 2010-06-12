Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0FLRWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:22:04 -0400
Received: by vws19 with SMTP id 19so772327vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jun 2010 10:22:03 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 12 Jun 2010 10:21:43 -0700
Message-ID: <AANLkTincGwOW94e0qcWJXBlM7NKYpnWCpulYZK9JI1UU@mail.gmail.com>
Subject: Warning on cfg80211 mlme.c
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I left iperf running overnight and 8 of these in the morning.

68:7f:74:3b:b1:0f is a E3000 AP but on 2.4 GHz I have it running in legacy mode.
68:7f:74:3b:b1:10 would be its 5 GHz radio but its not listed below.

[16684.356665] wlan32: authenticate with 68:7f:74:3b:b1:0f (try 1)
[16684.365649] wlan32: authenticated
[16684.365714] ------------[ cut here ]------------
[16684.365751] WARNING: at
/home/mcgrof/tmp/compat-wireless-2010-06-12-pc/net/wireless/mlme.c:47
cfg80211_send_rx_auth+0x97/0x140 [cfg80211]()
[16684.365758] Hardware name: 7660A14
[16684.365762] Modules linked in: ath9k mac80211 compat ath9k_common
ath9k_hw ath cfg80211 cryptd aes_x86_64 aes_generic arc4 ecb ufs qnx4
hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs
binfmt_misc ppdev joydev snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss pcmcia bridge
snd_pcm stp snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq iptable_filter snd_timer ip_tables
snd_seq_device yenta_socket rsrc_nonstatic psmouse x_tables
pcmcia_core serio_raw snd soundcore snd_page_alloc heci(C)
thinkpad_acpi led_class lp nvram parport dm_raid45 xor fbcon tileblit
font bitblit softcursor i915 drm i2c_algo_bit ohci1394 ieee1394 e1000e
video output intel_agp [last unloaded: cfg80211]
[16684.365911] Pid: 22513, comm: phy0 Tainted: G         C
2.6.31-22-generic #60-Ubuntu
[16684.365917] Call Trace:
[16684.365937]  [<ffffffff8105e6c8>] warn_slowpath_common+0x78/0xb0
[16684.365941]  [<ffffffff8105e70f>] warn_slowpath_null+0xf/0x20
[16684.365951]  [<ffffffffa0567f57>] cfg80211_send_rx_auth+0x97/0x140 [cfg80211]
[16684.365968]  [<ffffffffa05e8fda>]
ieee80211_probe_auth_done+0x7a/0xa0 [mac80211]
[16684.365980]  [<ffffffffa05eb558>] ieee80211_work_work+0x2d8/0x1260 [mac80211]
[16684.365985]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
[16684.365990]  [<ffffffff81431b72>] ? skb_dequeue+0x62/0x80
[16684.365995]  [<ffffffff8152cbb9>] ? mutex_lock+0x19/0x50
[16684.366006]  [<ffffffffa05e9a93>] ? ieee80211_sta_work+0x3a3/0x680 [mac80211]
[16684.366018]  [<ffffffffa05eb280>] ? ieee80211_work_work+0x0/0x1260 [mac80211]
[16684.366023]  [<ffffffff81073705>] run_workqueue+0x95/0x170
[16684.366027]  [<ffffffff81073884>] worker_thread+0xa4/0x120
[16684.366031]  [<ffffffff81078a30>] ? autoremove_wake_function+0x0/0x40
[16684.366034]  [<ffffffff810737e0>] ? worker_thread+0x0/0x120
[16684.366037]  [<ffffffff81078646>] kthread+0xa6/0xb0
[16684.366041]  [<ffffffff8101316a>] child_rip+0xa/0x20
[16684.366044]  [<ffffffff810785a0>] ? kthread+0x0/0xb0
[16684.366047]  [<ffffffff81013160>] ? child_rip+0x0/0x20
[16684.366049] ---[ end trace 30217dfe73b4cc91 ]---
[16697.171455] wlan32: authenticate with 68:7f:74:3b:b1:0f (try 1)
[16697.174468] wlan32: authenticated
[16697.186935] wlan32: associate with 68:7f:74:3b:b1:0f (try 1)
[16697.380098] wlan32: associate with 68:7f:74:3b:b1:0f (try 2)
[16697.383324] wlan32: RX AssocResp from 68:7f:74:3b:b1:0f
(capab=0x411 status=0 aid=1)
[16697.383333] wlan32: associated
