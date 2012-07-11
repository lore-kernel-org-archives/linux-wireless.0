Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2GKOSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 10:18:52 -0400
Message-ID: <1342016326.4464.4.camel@jlt3.sipsolutions.net> (sfid-20120711_161857_195080_A478B4C3)
Subject: Re: warning in iwlwifi on monitor mode in 3.5.0-rc6-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 11 Jul 2012 16:18:46 +0200
In-Reply-To: <CAD2nsn2Yya-Xi5k55WZVHg6PU5ahRnKqzOPHit8BRNzgSE1vuQ@mail.gmail.com> (sfid-20120711_160556_704769_2EBEB24C)
References: <CAD2nsn2Yya-Xi5k55WZVHg6PU5ahRnKqzOPHit8BRNzgSE1vuQ@mail.gmail.com>
	 (sfid-20120711_160556_704769_2EBEB24C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This isn't really related to iwlwifi...

Looks like this might be due to Michal's changes, maybe the monitor
callback is coming too early?

johannes


On Wed, 2012-07-11 at 19:35 +0530, Mohammed Shafi wrote:
> Hi all,
> 
> i got this warning in bringing up monitor mode with iwlwifi  in 3.5.0-rc6-wl
> 
> [ 4788.914848] iwlwifi 0000:03:00.0: Try to add interface when device not ready
> [ 4788.914851] ------------[ cut here ]------------
> [ 4788.914870] WARNING: at
> /home/shafi/new-wireless-testing/wireless-testing/net/mac80211/iface.c:357
> ieee80211_add_virtual_monitor+0x192/0x2b0 [mac80211]()
> [ 4788.914872] Hardware name: 64756D6
> [ 4788.914874] Modules linked in: iwldvm iwlwifi ath9k(O) mac80211(O)
> ath9k_common(O) ath9k_hw(O) ath(O) cfg80211(O) binfmt_misc rfcomm
> bridge stp llc bnep snd_hda_codec_conexant arc4 snd_hda_intel
> snd_hda_codec i915 fbcon tileblit font bitblit snd_hwdep softcursor
> snd_pcm_oss snd_mixer_oss snd_pcm drm_kms_helper snd_seq_dummy drm
> coretemp thinkpad_acpi snd_seq_oss kvm pcmcia snd_seq_midi joydev
> snd_rawmidi ath3k snd_seq_midi_event uvcvideo btusb snd_seq intel_agp
> i2c_algo_bit videobuf2_core intel_gtt hid_generic bluetooth snd_timer
> yenta_socket videodev pcmcia_rsrc psmouse snd_seq_device agpgart
> usbhid pcmcia_core hid videobuf2_vmalloc videobuf2_memops lpc_ich snd
> microcode tpm_tis snd_page_alloc serio_raw soundcore tpm lp video
> nvram parport tpm_bios ahci libahci e1000e [last unloaded: cfg80211]
> [ 4788.914967] Pid: 7486, comm: ifconfig Tainted: G           O 3.5.0-rc6-wl #25
> [ 4788.914969] Call Trace:
> [ 4788.914976]  [<c0136322>] warn_slowpath_common+0x72/0xa0
> [ 4788.914991]  [<f98164b2>] ?
> ieee80211_add_virtual_monitor+0x192/0x2b0 [mac80211]
> [ 4788.915005]  [<f98164b2>] ?
> ieee80211_add_virtual_monitor+0x192/0x2b0 [mac80211]
> [ 4788.915008]  [<c0136372>] warn_slowpath_null+0x22/0x30
> [ 4788.915022]  [<f98164b2>] ieee80211_add_virtual_monitor+0x192/0x2b0
> [mac80211]
> [ 4788.915027]  [<c06bb3c6>] ? printk+0x4d/0x4f
> [ 4788.915041]  [<f98185ea>] ieee80211_set_monitor_enabled+0x1a/0x50 [mac80211]
> [ 4788.915050]  [<f8fa5688>] cfg80211_update_iface_num+0x108/0x270 [cfg80211]
> [ 4788.915058]  [<f8fa5dee>] cfg80211_netdev_notifier_call+0x5fe/0x640
> [cfg80211]
> [ 4788.915062]  [<c0690142>] ? packet_notifier+0x1c2/0x2b0
> [ 4788.915066]  [<c0690156>] ? packet_notifier+0x1d6/0x2b0
> [ 4788.915070]  [<c06c2982>] notifier_call_chain+0x42/0xf0
> [ 4788.915075]  [<c0162d4f>] raw_notifier_call_chain+0x1f/0x30
> [ 4788.915080]  [<c05b156c>] call_netdevice_notifiers+0x2c/0x60
> [ 4788.915085]  [<c019738b>] ? trace_hardirqs_on+0xb/0x10
> [ 4788.915088]  [<c05b209c>] __dev_open+0x5c/0xf0
> [ 4788.915091]  [<c06bee35>] ? _raw_spin_unlock_bh+0x35/0x40
> [ 4788.915095]  [<c05b0e29>] __dev_change_flags+0x109/0x170
> [ 4788.915098]  [<c05b2003>] dev_change_flags+0x23/0x60
> [ 4788.915102]  [<c061cf10>] devinet_ioctl+0x6a0/0x770
> [ 4788.915106]  [<c061f725>] inet_ioctl+0x95/0xb0
> [ 4788.915109]  [<c059d2b0>] sock_ioctl+0x70/0x270
> [ 4788.915113]  [<c059d240>] ? sock_fasync+0xc0/0xc0
> [ 4788.915117]  [<c02656a6>] do_vfs_ioctl+0x86/0x5a0
> [ 4788.915121]  [<c016197b>] ? up_read+0x1b/0x30
> [ 4788.915124]  [<c06c2714>] ? do_page_fault+0x244/0x470
> [ 4788.915128]  [<c0255c75>] ? fget_light+0x355/0x410
> [ 4788.915131]  [<c0163314>] ? __put_cred+0x34/0x50
> [ 4788.915135]  [<c0265c37>] sys_ioctl+0x77/0x80
> [ 4788.915139]  [<c06c65e3>] sysenter_do_call+0x12/0x38
> [ 4788.915141] ---[ end trace 2b26c2a43fea3613 ]---
> [ 4788.915146] ------------[ cut here ]------------
> [ 4788.915160] WARNING: at
> /home/shafi/new-wireless-testing/wireless-testing/net/mac80211/cfg.c:2993
> ieee80211_set_monitor_enabled+0x4c/0x50 [mac80211]()
> [ 4788.915161] Hardware name: 64756D6
> [ 4788.915163] Modules linked in: iwldvm iwlwifi ath9k(O) mac80211(O)
> ath9k_common(O) ath9k_hw(O) ath(O) cfg80211(O) binfmt_misc rfcomm
> bridge stp llc bnep snd_hda_codec_conexant arc4 snd_hda_intel
> snd_hda_codec i915 fbcon tileblit font bitblit snd_hwdep softcursor
> snd_pcm_oss snd_mixer_oss snd_pcm drm_kms_helper snd_seq_dummy drm
> coretemp thinkpad_acpi snd_seq_oss kvm pcmcia snd_seq_midi joydev
> snd_rawmidi ath3k snd_seq_midi_event uvcvideo btusb snd_seq intel_agp
> i2c_algo_bit videobuf2_core intel_gtt hid_generic bluetooth snd_timer
> yenta_socket videodev pcmcia_rsrc psmouse snd_seq_device agpgart
> usbhid pcmcia_core hid videobuf2_vmalloc videobuf2_memops lpc_ich snd
> microcode tpm_tis snd_page_alloc serio_raw soundcore tpm lp video
> nvram parport tpm_bios ahci libahci e1000e [last unloaded: cfg80211]
> [ 4788.915231] Pid: 7486, comm: ifconfig Tainted: G        W  O 3.5.0-rc6-wl #25
> [ 4788.915233] Call Trace:
> [ 4788.915237]  [<c0136322>] warn_slowpath_common+0x72/0xa0
> [ 4788.915251]  [<f981861c>] ? ieee80211_set_monitor_enabled+0x4c/0x50
> [mac80211]
> [ 4788.915265]  [<f981861c>] ? ieee80211_set_monitor_enabled+0x4c/0x50
> [mac80211]
> [ 4788.915268]  [<c0136372>] warn_slowpath_null+0x22/0x30
> [ 4788.915282]  [<f981861c>] ieee80211_set_monitor_enabled+0x4c/0x50 [mac80211]
> [ 4788.915289]  [<f8fa5688>] cfg80211_update_iface_num+0x108/0x270 [cfg80211]
> [ 4788.915296]  [<f8fa5dee>] cfg80211_netdev_notifier_call+0x5fe/0x640
> [cfg80211]
> [ 4788.915299]  [<c0690142>] ? packet_notifier+0x1c2/0x2b0
> [ 4788.915303]  [<c0690156>] ? packet_notifier+0x1d6/0x2b0
> [ 4788.915307]  [<c06c2982>] notifier_call_chain+0x42/0xf0
> [ 4788.915311]  [<c0162d4f>] raw_notifier_call_chain+0x1f/0x30
> [ 4788.915314]  [<c05b156c>] call_netdevice_notifiers+0x2c/0x60
> [ 4788.915317]  [<c019738b>] ? trace_hardirqs_on+0xb/0x10
> [ 4788.915321]  [<c05b209c>] __dev_open+0x5c/0xf0
> [ 4788.915324]  [<c06bee35>] ? _raw_spin_unlock_bh+0x35/0x40
> [ 4788.915327]  [<c05b0e29>] __dev_change_flags+0x109/0x170
> [ 4788.915331]  [<c05b2003>] dev_change_flags+0x23/0x60
> [ 4788.915334]  [<c061cf10>] devinet_ioctl+0x6a0/0x770
> [ 4788.915338]  [<c061f725>] inet_ioctl+0x95/0xb0
> [ 4788.915341]  [<c059d2b0>] sock_ioctl+0x70/0x270
> [ 4788.915344]  [<c059d240>] ? sock_fasync+0xc0/0xc0
> [ 4788.915347]  [<c02656a6>] do_vfs_ioctl+0x86/0x5a0
> [ 4788.915350]  [<c016197b>] ? up_read+0x1b/0x30
> [ 4788.915353]  [<c06c2714>] ? do_page_fault+0x244/0x470
> [ 4788.915357]  [<c0255c75>] ? fget_light+0x355/0x410
> [ 4788.915360]  [<c0163314>] ? __put_cred+0x34/0x50
> [ 4788.915363]  [<c0265c37>] sys_ioctl+0x77/0x80
> [ 4788.915367]  [<c06c65e3>] sysenter_do_call+0x12/0x38
> [ 4788.915368] ---[ end trace 2b26c2a43fea3614 ]---
> [ 4788.915371]
> 
> 


