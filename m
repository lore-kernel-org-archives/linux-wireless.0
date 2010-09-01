Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53637 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0IAXqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 19:46:08 -0400
Received: by iwn5 with SMTP id 5so7180015iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Sep 2010 16:46:06 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Sep 2010 16:45:46 -0700
Message-ID: <AANLkTiko4XRM=xQWHy2H5WUMbYBzRE+NfUeqS20S2D_S@mail.gmail.com>
Subject: WARNING: at net/mac80211/tx.c:653 ieee80211_tx_h_rate_ctrl+0x460
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just hit this

        /*
         * Lets not bother rate control if we're associated and cannot
         * talk to the sta. This should not happen.
         */
        if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
                 (sta_flags & WLAN_STA_ASSOC) &&
                 !rate_usable_index_exists(sband, &tx->sta->sta),
                 "%s: Dropped data frame as no usable bitrate found while "
                 "scanning and associated. Target station: "
                 "%pM on %d GHz band\n",
                 tx->sdata->name, hdr->addr1,
                 tx->channel->band ? 5 : 2))
                return TX_DROP;

Reproduced when doing a loop on a bg scan (while associated).

Sep  1 16:42:26 tux kernel: [  722.406139] phy0: device no longer idle - working
Sep  1 16:42:26 tux kernel: [  722.444648] wlan39: authenticate with
00:24:6c:04:b8:59 (try 1)
Sep  1 16:42:26 tux kernel: [  722.444713] wlan39: deauthenticating
from 00:24:6c:04:b8:59 by local choice (reason=3)
Sep  1 16:42:26 tux kernel: [  722.444736] phy0: device now idle
Sep  1 16:42:26 tux kernel: [  722.476768] phy0: device no longer idle - working
Sep  1 16:42:27 tux kernel: [  722.657764] wlan39: authenticate with
00:24:6c:04:b8:51 (try 1)
Sep  1 16:42:27 tux kernel: [  722.664863] wlan39: authenticated
Sep  1 16:42:27 tux kernel: [  722.665011] wlan39: associate with
00:24:6c:04:b8:51 (try 1)
Sep  1 16:42:27 tux kernel: [  722.669223] wlan39: RX AssocResp from
00:24:6c:04:b8:51 (capab=0x431 status=0 aid=2)
Sep  1 16:42:27 tux kernel: [  722.669229] wlan39: associated
Sep  1 16:42:27 tux kernel: [  722.669252] phy0: Allocated STA 00:24:6c:04:b8:51
Sep  1 16:42:27 tux kernel: [  722.669342] phy0: Inserted STA 00:24:6c:04:b8:51
Sep  1 16:42:27 tux kernel: [  722.814609] phy0: WMM queue=2 aci=0
acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
Sep  1 16:42:27 tux kernel: [  722.814629] phy0: WMM queue=3 aci=1
acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
Sep  1 16:42:27 tux kernel: [  722.814641] phy0: WMM queue=1 aci=2
acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
Sep  1 16:42:27 tux kernel: [  722.814652] phy0: WMM queue=0 aci=3
acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
Sep  1 16:42:27 tux kernel: [  722.875453] Rx A-MPDU request on tid 0 result 0
Sep  1 16:42:27 tux kernel: [  723.471429] Open BA session requested
for 00:24:6c:04:b8:51 tid 0
Sep  1 16:42:27 tux kernel: [  723.471497] activated addBA response
timer on tid 0
Sep  1 16:42:27 tux kernel: [  723.473561] switched off addBA timer for tid 0
Sep  1 16:42:27 tux kernel: [  723.473563] Aggregation is on for tid 0
Sep  1 16:42:38 tux kernel: [  733.538967] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:38 tux kernel: [  733.640014] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:38 tux kernel: [  733.750159] WARNING: at
net/mac80211/tx.c:653 ieee80211_tx_h_rate_ctrl+0x460/0x4e0
[mac80211]()
Sep  1 16:42:38 tux kernel: [  733.750166] Hardware name: 6460DWU
Sep  1 16:42:38 tux kernel: [  733.750172] wlan39: Dropped data frame
as no usable bitrate found while scanning and associated. Target
station: 00:24:6c:04:b8:51 on 5 GHz band
Sep  1 16:42:38 tux kernel: [  733.750178] Modules linked in: rfcomm
sco snd_hda_codec_analog binfmt_misc bridge stp bnep ppdev l2cap
joydev snd_hda_intel nouveau snd_hda_codec ath9k mac80211 snd_hwdep
snd_pcm thinkpad_acpi snd_seq_midi ath9k_common snd_rawmidi ath9k_hw
snd_seq_midi_event snd_seq ttm pcmcia drm_kms_helper snd_timer
snd_seq_device ath drm tpm_tis snd btusb nvram tpm cfg80211 bluetooth
tpm_bios yenta_socket i2c_algo_bit pcmcia_rsrc video psmouse
pcmcia_core serio_raw output lp soundcore snd_page_alloc intel_agp
parport ohci1394 ahci e1000e ieee1394 libahci
Sep  1 16:42:38 tux kernel: [  733.750282] Pid: 2830, comm:
kworker/u:0 Not tainted 2.6.36-rc3-wl+ #240
Sep  1 16:42:38 tux kernel: [  733.750288] Call Trace:
Sep  1 16:42:38 tux kernel: [  733.750305]  [<ffffffff8105fdbf>]
warn_slowpath_common+0x7f/0xc0
Sep  1 16:42:38 tux kernel: [  733.750313]  [<ffffffff8105feb6>]
warn_slowpath_fmt+0x46/0x50
Sep  1 16:42:38 tux kernel: [  733.750324]  [<ffffffff81036c99>] ?
default_spin_lock_flags+0x9/0x10
Sep  1 16:42:38 tux kernel: [  733.750355]  [<ffffffffa0349870>]
ieee80211_tx_h_rate_ctrl+0x460/0x4e0 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750387]  [<ffffffffa0349c90>]
invoke_tx_handlers+0x100/0x140 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750418]  [<ffffffffa0349d55>]
ieee80211_tx+0x85/0x240 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750428]  [<ffffffff8147c970>] ?
skb_release_data+0xd0/0xe0
Sep  1 16:42:38 tux kernel: [  733.750436]  [<ffffffff8147e7fd>] ?
pskb_expand_head+0x10d/0x1a0
Sep  1 16:42:38 tux kernel: [  733.750468]  [<ffffffffa0349fc2>]
ieee80211_xmit+0xb2/0x1c0 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750499]  [<ffffffffa0338050>] ?
ieee80211_dynamic_ps_enable_work+0x0/0xb0 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750530]  [<ffffffffa034a124>]
ieee80211_tx_skb+0x54/0x70 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750560]  [<ffffffffa033802b>]
ieee80211_send_nullfunc+0x4b/0x70 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750589]  [<ffffffffa03380fd>]
ieee80211_dynamic_ps_enable_work+0xad/0xb0 [mac80211]
Sep  1 16:42:38 tux kernel: [  733.750599]  [<ffffffff81079fa3>]
process_one_work+0x123/0x440
Sep  1 16:42:38 tux kernel: [  733.750608]  [<ffffffff8107c4d0>]
worker_thread+0x170/0x400
Sep  1 16:42:38 tux kernel: [  733.750617]  [<ffffffff8107c360>] ?
worker_thread+0x0/0x400
Sep  1 16:42:38 tux kernel: [  733.750625]  [<ffffffff810808f6>]
kthread+0x96/0xa0
Sep  1 16:42:38 tux kernel: [  733.750634]  [<ffffffff8100be64>]
kernel_thread_helper+0x4/0x10
Sep  1 16:42:38 tux kernel: [  733.750643]  [<ffffffff81080860>] ?
kthread+0x0/0xa0
Sep  1 16:42:38 tux kernel: [  733.750650]  [<ffffffff8100be60>] ?
kernel_thread_helper+0x0/0x10
Sep  1 16:42:38 tux kernel: [  733.750656] ---[ end trace 68c1772848be0f83 ]---
Sep  1 16:42:44 tux kernel: [  740.210023] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:44 tux kernel: [  740.210028] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:44 tux kernel: [  740.210031] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:44 tux kernel: [  740.210033] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:44 tux kernel: [  740.210035] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:45 tux kernel: [  741.520015] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:45 tux kernel: [  741.520019] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:45 tux kernel: [  741.520022] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:45 tux kernel: [  741.520024] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:45 tux kernel: [  741.520026] phy0: release an RX reorder
frame due to timeout on earlier frames
Sep  1 16:42:52 tux kernel: [  748.040093] net_ratelimit: 10 callbacks
suppressed
Sep  1 16:42:52 tux kernel: [  748.040097] wlan39: detected beacon
loss from AP - sending probe request
Sep  1 16:42:55 tux kernel: [  751.050050] wlan39: detected beacon
loss from AP - sending probe request
