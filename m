Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50223 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0FRG34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 02:29:56 -0400
Received: by pxi12 with SMTP id 12so315611pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 23:29:55 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 17 Jun 2010 23:29:35 -0700
Message-ID: <AANLkTikS81zsEsVpcCWZk1LYN-VlksDyGSakH5ktGSfw@mail.gmail.com>
Subject: net/wireless/mlme.c:47 could not find BSS to send RX auth
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems the way we keep track of BSSes lets us still throw away a BSS
and yet have us want to try to send an RX auth to one. To get this I
just switched from my 5 GHz HT40 BSS to the 2.4 GHz Legacy BSS on my
AP E3000 AP.

[  374.050256] wlan37: deauthenticating from 68:7f:74:3b:b1:10 by
local choice (reason=3)
[  387.083324] wlan37: deauthenticating from 68:7f:74:3b:b1:0f by
local choice (reason=3)
[  387.276404] wlan37: authenticate with 68:7f:74:3b:b1:0f (try 1)
[  387.278470] wlan37: authenticated
[  387.321692] wlan37: associate with 68:7f:74:3b:b1:0f (try 1)
[  387.325786] wlan37: RX AssocResp from 68:7f:74:3b:b1:0f
(capab=0x411 status=0 aid=2)
[  387.325797] wlan37: associated
[  397.335202] wlan37: deauthenticating from 68:7f:74:3b:b1:0f by
local choice (reason=3)
[  397.937164] ath9k: Two wiphys trying to scan at the same time
[  397.937253] wlan37: deauthenticating from 68:7f:74:3b:b1:0f by
local choice (reason=3)
[  398.128561] wlan37: authenticate with 68:7f:74:3b:b1:0f (try 1)
[  398.130677] wlan37: authenticated
[  398.130685] ------------[ cut here ]------------
[  398.130731] WARNING: at
/home/mcgrof/devel/compat-wireless-2.6/net/wireless/mlme.c:47
cfg80211_send_rx_auth+0x97/0x140 [cfg80211]()
[  398.130738] Hardware name: 7660A14
[  398.130742] Modules linked in: ath9k ath9k_common ath9k_hw cryptd
aes_x86_64 aes_generic binfmt_misc ppdev bridge stp bnep joydev arc4
ecb snd_hda_codec_analog iptable_filter mac80211 pcmcia snd_hda_intel
compat snd_hda_codec snd_hwdep ip_tables snd_pcm_oss snd_mixer_oss ath
x_tables snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer yenta_socket snd_seq_device
rsrc_nonstatic psmouse pcmcia_core serio_raw btusb snd cfg80211
soundcore lp snd_page_alloc thinkpad_acpi heci(C) led_class nvram
parport dm_raid45 xor fbcon tileblit font bitblit softcursor ohci1394
ieee1394 e1000e i915 drm i2c_algo_bit video output intel_agp [last
unloaded: ath9k_hw]
[  398.130864] Pid: 2516, comm: phy2 Tainted: G         C
2.6.31-22-generic #60-Ubuntu
[  398.130869] Call Trace:
[  398.130887]  [<ffffffff8105e6c8>] warn_slowpath_common+0x78/0xb0
[  398.130896]  [<ffffffff8105e70f>] warn_slowpath_null+0xf/0x20
[  398.130922]  [<ffffffffa018b067>] cfg80211_send_rx_auth+0x97/0x140 [cfg80211]
[  398.130959]  [<ffffffffa031eeaa>]
ieee80211_probe_auth_done+0x7a/0xa0 [mac80211]
[  398.130991]  [<ffffffffa03212f8>] ieee80211_work_work+0x268/0x12c0 [mac80211]
[  398.131000]  [<ffffffff8105219b>] ? dequeue_entity+0x1b/0x240
[  398.131011]  [<ffffffff8101066b>] ? __switch_to+0xcb/0x370
[  398.131019]  [<ffffffff8104f075>] ? finish_task_switch+0x65/0x120
[  398.131049]  [<ffffffffa0321090>] ? ieee80211_work_work+0x0/0x12c0 [mac80211]
[  398.131060]  [<ffffffff81073705>] run_workqueue+0x95/0x170
[  398.131069]  [<ffffffff81073884>] worker_thread+0xa4/0x120
[  398.131078]  [<ffffffff81078a30>] ? autoremove_wake_function+0x0/0x40
[  398.131087]  [<ffffffff810737e0>] ? worker_thread+0x0/0x120
[  398.131094]  [<ffffffff81078646>] kthread+0xa6/0xb0
[  398.131102]  [<ffffffff8101316a>] child_rip+0xa/0x20
[  398.131110]  [<ffffffff810785a0>] ? kthread+0x0/0xb0
[  398.131117]  [<ffffffff81013160>] ? child_rip+0x0/0x20
[  398.131123] ---[ end trace 85398eda538cf907 ]---
[  408.545677] lo: Disabled Privacy Extensions
[  410.885532] wlan37: authenticate with 68:7f:74:3b:b1:0f (try 1)
[  410.888150] wlan37: authenticated
