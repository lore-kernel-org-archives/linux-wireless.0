Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62138 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0LGEJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 23:09:41 -0500
Received: by pwj3 with SMTP id 3so2044739pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 20:09:40 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19709.45926.38551.25130@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 09:39:10 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
	<19704.23185.565826.890275@gargle.gargle.HOWL>
	<AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Just curious, if you revert this patch and apply the ones I just
> posted, does it fix it, or is this patch required either way?

Well, I don't see this patch in -testing, -next-2.6 or -2.6.
Maybe Linville overlooked this patch.

Applying 4/5 and 5/5 from your series seems to fix the issue though.
I am able to suspend/resume without hiccups with UB95.

But, I think this is purely an ath9k issue, mac80211 is probably right in
assuming that only devices that have been issued ~IEEE80211_CONF_IDLE
would have their radios enabled anyway.

ath9k doesn't differentiate between init/start and enables the radio
(setting it to AWAKE mode) in the initialization sequence.
Why should mac80211 issue a CONF_IDLE notification when the device
was never powered up .. ?

But maybe I am wrong and confused.
Anyway, your patches fix the problem.

I did see this warning once while testing, but I couldn't reproduce it again.

WARNING: at /home/sujith/dev/wireless-testing/net/mac80211/iface.c:1267 __ieee80211_recalc_idle+0x22c/0x310 [mac80211]()
Hardware name: 7661GN4
Modules linked in: arc4 ecb ath9k_htc(-) ath9k_common ath9k_hw ath mac80211
cfg80211 ext2 mct_u232 usbserial snd_hda_codec_analog i915 snd_hda_intel snd_hda_codec snd_pcm_oss snd_pcm dd
[  154.022734] Pid: 3110, comm: rmmod Tainted: G        W   2.6.37-rc4-wl #11
[  154.022736] Call Trace:
[<ffffffff81057e9a>] warn_slowpath_common+0x7a/0xb0
[<ffffffff81057ee5>] warn_slowpath_null+0x15/0x20
[<ffffffffa05d4d3c>] __ieee80211_recalc_idle+0x22c/0x310 [mac80211]
[<ffffffffa05d4e5a>] ieee80211_recalc_idle_check+0x3a/0x70 [mac80211]
[<ffffffffa05d639e>] ieee80211_recalc_idle_force+0xe/0x10 [mac80211]
[<ffffffffa05e5ad0>] ieee80211_stop_device+0xa0/0x160 [mac80211]
[<ffffffffa05d510f>] ieee80211_do_stop+0x27f/0x610 [mac80211]
[<ffffffff8130e217>] ? dev_deactivate+0x1d7/0x200
[<ffffffffa05d54b5>] ieee80211_stop+0x15/0x20 [mac80211]
[<ffffffff812f1b46>] __dev_close+0x56/0x90
[<ffffffff812f1b9a>] dev_close+0x1a/0x50
[<ffffffff812f1f0a>] rollback_registered_many+0x6a/0x250
[<ffffffff812f2106>] unregister_netdevice_many+0x16/0x80
[<ffffffffa05d4ad4>] ieee80211_remove_interfaces+0xb4/0xf0 [mac80211]
[<ffffffffa05c10be>] ieee80211_unregister_hw+0x4e/0x110 [mac80211]
[<ffffffffa028d113>] ath9k_htc_disconnect_device+0x43/0x90 [ath9k_htc]
[<ffffffffa0284a62>] ath9k_htc_hw_deinit+0x12/0x20 [ath9k_htc]
[<ffffffffa02864bf>] ath9k_hif_usb_disconnect+0x4f/0x140 [ath9k_htc]
[<ffffffffa03e70cb>] usb_unbind_interface+0x5b/0x1a0 [usbcore]
[<ffffffff812ae400>] __device_release_driver+0x70/0xe0
[<ffffffff812aeb28>] driver_detach+0xc8/0xd0
[<ffffffff812ae278>] bus_remove_driver+0x88/0xe0
[<ffffffff812aebba>] driver_unregister+0x5a/0x90
[<ffffffffa03e61ba>] usb_deregister+0xba/0xd0 [usbcore]
[<ffffffffa0286970>] ath9k_hif_usb_exit+0x10/0x20 [ath9k_htc]
[<ffffffffa028d595>] ath9k_htc_exit+0x9/0x1e [ath9k_htc]
[<ffffffff8109d226>] sys_delete_module+0x196/0x290
[<ffffffff813a8bb9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff8100bf52>] system_call_fastpath+0x16/0x1b

Sujith
