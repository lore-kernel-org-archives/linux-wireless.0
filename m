Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36578 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbFQJDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:03:53 -0400
Received: by wicnd19 with SMTP id nd19so21817946wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 02:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21889.14109.54454.563245@gargle.gargle.HOWL>
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
	<21889.11726.101648.552280@gargle.gargle.HOWL>
	<55812FB5.1070005@openwrt.org>
	<21889.14109.54454.563245@gargle.gargle.HOWL>
Date: Wed, 17 Jun 2015 11:03:52 +0200
Message-ID: <CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com> (sfid-20150617_110400_717229_F8C08F36)
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 June 2015 at 11:00, Sujith Manoharan <sujith@msujith.org> wrote:
> Felix Fietkau wrote:
>> mac80211 calculates the filter per hw, not per channel context or per
>> vif. Setting it for the current channel context only would mean it might
>> be applied to the wrong context. This patch fixes that issue.
>> I agree that it might be a useful optimization to selectively apply
>> filters per channel context, but mac80211 does not provide an API to do
>> that right now.
>
> But wpa_s already takes care of this requirement ? This is what I see
> when running p2p_find:
>
> wlan0: Starting radio work 'p2p-listen'@0x17c2500 after 0.000040 second wait
> nl80211: Enable Probe Request reporting nl_preq=0x17c2560
> nl80211: Register frame type=0x40 (WLAN_FC_STYPE_PROBE_REQ) nl_handle=0x17c2560 match=
> nl80211: Remain-on-channel cookie 0x351 for freq=2437 MHz duration=204
> nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for wlan0
> nl80211: Remain-on-channel event (cancel=0 freq=2437 channel_type=0 duration=204 cookie=0x351 (match))
> wlan0: Event REMAIN_ON_CHANNEL (20) received
>
> And in the driver:
>
> ath: phy1: Starting RoC period
> ath: phy1: Channel definition created: 2437 MHz
> ath: phy1: Assigned next_chan to 2437 MHz
> ath: phy1: Offchannel duration for chan 2437 MHz : 112825
> ath: phy1: Set HW RX filter: 0x687
> ath: phy1: ath_chanctx_set_next: current: 2412 MHz, next: 2437 MHz
>
> So, the filter for probe requests appears to be set correctly ?
>
This is what I have with use_chanctx=1

un 17 06:57:54 dell6430 kernel: [53297.748030] ath: phy0: RoC request
on vif: 2c:d0:5a:d3:f1:e9, type: 0 duration: 204
Jun 17 06:57:54 dell6430 kernel: [53297.748030] ath: phy0: Starting RoC period
Jun 17 06:57:54 dell6430 kernel: [53297.748031] ath: phy0: Channel
definition created: 2437 MHz
Jun 17 06:57:54 dell6430 kernel: [53297.748032] ath: phy0: Assigned
next_chan to 2437 MHz
Jun 17 06:57:54 dell6430 kernel: [53297.748033] ath: phy0: Offchannel
duration for chan 2437 MHz : 209170
Jun 17 06:57:54 dell6430 kernel: [53297.748038]  [<ffffffffc0a3e641>]
ieee80211_configure_filter+0x141/0x290 [mac80211]
Jun 17 06:57:54 dell6430 kernel: [53297.748043]  [<ffffffffc0a3e7a5>]
ieee80211_reconfig_filter+0x15/0x20 [mac80211]
Jun 17 06:57:54 dell6430 kernel: [53297.748045]  [<ffffffff81090cdf>]
process_one_work+0x14f/0x420
Jun 17 06:57:54 dell6430 kernel: [53297.748046]  [<ffffffff81091498>]
worker_thread+0x118/0x530
Jun 17 06:57:54 dell6430 kernel: [53297.748048]  [<ffffffff81091380>]
? rescuer_thread+0x3d0/0x3d0
Jun 17 06:57:54 dell6430 kernel: [53297.748049]  [<ffffffff81096a02>]
kthread+0xd2/0xf0
Jun 17 06:57:54 dell6430 kernel: [53297.748051]  [<ffffffff81096930>]
? kthread_create_on_node+0x180/0x180
Jun 17 06:57:54 dell6430 kernel: [53297.748053]  [<ffffffff817c7662>]
ret_from_fork+0x42/0x70
Jun 17 06:57:54 dell6430 kernel: [53297.748054]  [<ffffffff81096930>]
? kthread_create_on_node+0x180/0x180
Jun 17 06:57:54 dell6430 kernel: [53297.748055] ---[ end trace
cd36a6099a6f1ca0 ]---
Jun 17 06:57:54 dell6430 kernel: [53297.748056] xxx ath_calcrxfilter
filter: 0x687

Jun 17 06:57:54 dell6430 kernel: [53297.748060] ath: phy0: Set HW RX
filter: 0x687
Jun 17 06:57:54 dell6430 kernel: [53297.748062] ath: phy0:
ath_chanctx_set_next: current: 2412 MHz, next: 2437 MHz
Jun 17 06:57:54 dell6430 kernel: [53297.748062] ath: phy0: Stopping
current chanctx: 2412
Jun 17 06:57:54 dell6430 kernel: [53297.748065] ath: phy0: Flush timeout: 200
Jun 17 06:57:54 dell6430 kernel: [53297.748076] ath: phy0:
ath_chanctx_set_next: Set channel 2437 MHz
Jun 17 06:57:54 dell6430 kernel: [53297.748077] ath: phy0: Set
channel: 2437 MHz width: 0
Jun 17 06:57:54 dell6430 kernel: [53297.748211] ath: phy0: Reset to
2437 MHz, HT40: 0 fastcc: 0
Jun 17 06:57:54 dell6430 kernel: [53297.753144] ------------[ cut here
]------------
Jun 17 06:57:54 dell6430 kernel: [53297.753147] WARNING: CPU: 3 PID:
6140 at drivers/net/wireless/ath/ath9k/recv.c:380
ath_calcrxfilter+0x33/0x1c0 [ath9k]()
Jun 17 06:57:54 dell6430 kernel: [53297.753147] Modules linked in:
iwlmvm(E) iwlwifi(E) ath10k_pci(OE) ath10k_core(OE) ath9k(OE)
ath9k_common(OE) ath9k_hw(OE) ath(E) mac80211(OE) cfg80211(OE) ctr(E)
ccm(E) arc4(E) ftdi_sio(E) usbserial(E) cmac(E) dm_crypt(E)
dell_wmi(E) sparse_keymap(E) dell_laptop(E) dcdbas(E) i8k(E)
intel_rapl(E) iosf_mbi(E) x86_pkg_temp_thermal(E) intel_powerclamp(E)
coretemp(E) rfcomm(E) kvm_intel(E) bnep(E) kvm(E) crct10dif_pclmul(E)
crc32_pclmul(E) uvcvideo(E) ghash_clmulni_intel(E) aesni_intel(E)
videobuf2_vmalloc(E) aes_x86_64(E) videobuf2_memops(E) lrw(E)
gf128mul(E) glue_helper(E) videobuf2_core(E) ablk_helper(E) cryptd(E)
v4l2_common(E) videodev(E) snd_hda_codec_idt(E)
snd_hda_codec_generic(E) media(E) joydev(E) serio_raw(E) ath3k(E)
btusb(E) btbcm(E) btintel(E) snd_hda_intel(E) snd_hda_controller(E)
bluetooth(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) snd_pcm(E)
snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E) dell_smo8800(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) lpc_ich(E) snd(E) mei_me(E)
soundcore(E) shpchp(E) mac_hid(E) mei(E) binfmt_misc(E) parport_pc(E)
ppdev(E) lp(E) parport(E) nouveau(E) e1000e(E) i915(E) mxm_wmi(E)
ttm(E) i2c_algo_bit(E) drm_kms_helper(E) ptp(E) ahci(E) sdhci_pci(E)
psmouse(E) libahci(E) drm(E) sdhci(E) pps_core(E) wmi(E) video(E)
[last unloaded: cfg80211]
Jun 17 06:57:54 dell6430 kernel: [53297.753177] CPU: 3 PID: 6140 Comm:
kworker/u16:1 Tainted: G        W  OE
4.1.0-rc1master-2015-05-14-00-wl-ath+ #21
Jun 17 06:57:54 dell6430 kernel: [53297.753178] Hardware name: Dell
Inc. Latitude E6430/0H3MT5, BIOS A13 09/02/2013
Jun 17 06:57:54 dell6430 kernel: [53297.753181] Workqueue: phy0
ath_chanctx_work [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753186]  ffffffffc0799150
ffff8801fe767b48 ffffffff817bf491 0000000000008a34
Jun 17 06:57:54 dell6430 kernel: [53297.753188]  0000000000000000
ffff8801fe767b88 ffffffff8107746a ffff8801fe767b68
Jun 17 06:57:54 dell6430 kernel: [53297.753189]  ffff8800ca000018
ffff8800a26893e0 ffff8800a268b960 ffff8800ca000018
Jun 17 06:57:54 dell6430 kernel: [53297.753190] Call Trace:
Jun 17 06:57:54 dell6430 kernel: [53297.753192]  [<ffffffff817bf491>]
dump_stack+0x45/0x57
Jun 17 06:57:54 dell6430 kernel: [53297.753194]  [<ffffffff8107746a>]
warn_slowpath_common+0x8a/0xc0
Jun 17 06:57:54 dell6430 kernel: [53297.753195]  [<ffffffff8107755a>]
warn_slowpath_null+0x1a/0x20
Jun 17 06:57:54 dell6430 kernel: [53297.753197]  [<ffffffffc0781de3>]
ath_calcrxfilter+0x33/0x1c0 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753199]  [<ffffffffc0781f8a>]
ath_opmode_init+0x1a/0x50 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753212]  [<ffffffffc07820d1>]
ath_startrecv+0x111/0x140 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753217]  [<ffffffffc077fec3>]
ath_complete_reset+0x33/0x150 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753219]  [<ffffffffc0780138>]
ath_reset_internal+0x158/0x280 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753222]  [<ffffffffc07802a1>]
ath_reset+0x41/0x60 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753224]  [<ffffffffc078a497>]
ath_set_channel+0x187/0x360 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753226]  [<ffffffffc078cb03>]
ath_chanctx_set_next+0x533/0x670 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753229]  [<ffffffffc077e882>]
? ath9k_configure_filter+0xb2/0xc0 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753234]  [<ffffffffc0a3e641>]
? ieee80211_configure_filter+0x141/0x290 [mac80211]
Jun 17 06:57:54 dell6430 kernel: [53297.753238]  [<ffffffff8108e5cd>]
? pwq_activate_delayed_work+0x3d/0x90
Jun 17 06:57:54 dell6430 kernel: [53297.753241]  [<ffffffffc078cc6d>]
ath_chanctx_work+0x2d/0x40 [ath9k]
Jun 17 06:57:54 dell6430 kernel: [53297.753242]  [<ffffffff81090cdf>]
process_one_work+0x14f/0x420
Jun 17 06:57:54 dell6430 kernel: [53297.753244]  [<ffffffff81091498>]
worker_thread+0x118/0x530
Jun 17 06:57:54 dell6430 kernel: [53297.753247]  [<ffffffff81091380>]
? rescuer_thread+0x3d0/0x3d0
Jun 17 06:57:54 dell6430 kernel: [53297.753248]  [<ffffffff81096a02>]
kthread+0xd2/0xf0
Jun 17 06:57:54 dell6430 kernel: [53297.753251]  [<ffffffff81096930>]
? kthread_create_on_node+0x180/0x180
Jun 17 06:57:54 dell6430 kernel: [53297.753253]  [<ffffffff817c7662>]
ret_from_fork+0x42/0x70
Jun 17 06:57:54 dell6430 kernel: [53297.753255]  [<ffffffff81096930>]
? kthread_create_on_node+0x180/0x180
Jun 17 06:57:54 dell6430 kernel: [53297.753256] ---[ end trace
cd36a6099a6f1ca1 ]---
Jun 17 06:57:54 dell6430 kernel: [53297.753256] xxx ath_calcrxfilter
filter: 0x207

0x000000080 is for probe_req

BR
Janusz
