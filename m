Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45289 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185AbaEZHiQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:38:16 -0400
Message-ID: <1401089883.4431.1.camel@dubbel> (sfid-20140526_093819_563605_8EB685B8)
From: Luca Coelho <luca@coelho.fi>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Mon, 26 May 2014 10:38:03 +0300
In-Reply-To: <1401021341-26402-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1401021341-26402-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: fix virtual monitor interface addition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-25 at 15:35 +0300, Emmanuel Grumbach wrote:
> Since the commit below, cfg80211_chandef_dfs_required()
> will warn if it gets a an NL80211_IFTYPE_UNSPECIFIED iftype
> as explicitely written in the commit log.
> When an virtual monitor interface is added, its type is set
> in ieee80211_sub_if_data.vif.type, but not in
> ieee80211_sub_if_data.wdev.iftype which is passed to
> cfg80211_chandef_dfs_required() hence resulting in the
> following warning:
> 
> WARNING: CPU: 1 PID: 21265 at net/wireless/chan.c:376 cfg80211_chandef_dfs_required+0xbc/0x130 [cfg80211]()
> Modules linked in: iwlmvm(O) mac80211(O) iwlwifi(O) cfg80211(O) compat(O) arc4 rfcomm bnep intel_powerclamp coretemp kvm_intel i915 kvm snd_hda_codec_hdmi snd_hda_codec_idt crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_codec aesni_intel joydev aes_x86_64 glue_helper lrw uvcvideo gf128mul ablk_helper cryptd i2c_algo_bit snd_hwdep drm_kms_helper videobuf2_vmalloc snd_pcm dell_wmi sparse_keymap videobuf2_memops videobuf2_core videodev dell_laptop btusb drm dcdbas bluetooth snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq psmouse snd_timer serio_raw snd_seq_device microcode snd wmi soundcore intel_ips lpc_ich video parport_pc ppdev lp parport e1000e firewire_ohci firewire_core ahci libahci crc_itu_t sdhci_pci ptp sdhci pps_core [last unloaded: compat]
> CPU: 1 PID: 21265 Comm: ifconfig Tainted: G        W  O 3.13.11+ #12
> Hardware name: Dell Inc. Latitude E6410/0667CC, BIOS A01 03/05/2010
>  0000000000000009 ffff88008f5fdb08 ffffffff817d4219 ffff88008f5fdb50
>  ffff88008f5fdb40 ffffffff8106f57d 0000000000000000 0000000000000000
>  ffff880081062fb8 ffff8800810604e0 0000000000000001 ffff88008f5fdba0
> Call Trace:
>  [<ffffffff817d4219>] dump_stack+0x4d/0x66
>  [<ffffffff8106f57d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff8106f5ec>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffffa04ea4ec>] cfg80211_chandef_dfs_required+0xbc/0x130 [cfg80211]
>  [<ffffffffa06b1024>] ieee80211_vif_use_channel+0x94/0x500 [mac80211]
>  [<ffffffffa0684e57>] ? ieee80211_add_virtual_monitor+0x197/0x5c0 [mac80211]
>  [<ffffffffa0684e6b>] ieee80211_add_virtual_monitor+0x1ab/0x5c0 [mac80211]
>  [<ffffffffa0686ae5>] ieee80211_do_open+0xe75/0x1580 [mac80211]
>  [<ffffffffa0687259>] ieee80211_open+0x69/0x70 [mac80211]
> [snip]
> 
> Fixes: 00ec75fc5a64 ("cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_required()")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---

Thanks, Emmanuel! I knew I had a reason for treating the "UNSPECIFIED"
iftype differently, but now it's all fixed in a proper way
(hopefully). :)

Acked-by: Luciano Coelho <luciano.coelho@intel.com>

--
Luca.

