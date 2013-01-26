Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58120 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3AZFvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 00:51:45 -0500
Received: from localhost
	([127.0.0.1] helo=purkki.adurom.net ident=kvalo)
	by purkki.adurom.net with esmtp (Exim 4.72)
	(envelope-from <kvalo@adurom.com>)
	id 1Tyyg4-0003Cx-GH
	for linux-wireless@vger.kernel.org; Sat, 26 Jan 2013 07:51:44 +0200
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb
Date: Sat, 26 Jan 2013 07:51:44 +0200
Message-ID: <87vcakxzin.fsf@purkki.adurom.net> (sfid-20130126_065156_011641_62FC8674)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed this warning in the log just by accident, I haven't had any
problems. I'm running latest wireless-testing (commit 9d9540984a) on
thinkpad x230 with Intel 6205.

[   10.262245] wlan0: authenticate with 00:26:f2:f7:cf:b2
[   10.272891] wlan0: send auth to 00:26:f2:f7:cf:b2 (try 1/3)
[   10.275093] wlan0: authenticated
[   10.278751] wlan0: associate with 00:26:f2:f7:cf:b2 (try 1/3)
[   10.282307] wlan0: RX AssocResp from 00:26:f2:f7:cf:b2 (capab=0x411
status=0 aid=3)
[   10.303014] wlan0: associated
[   10.303062] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   19.806954] EXT4-fs (dm-1): mounted filesystem with ordered data
mode. Opts: errors=remount-ro
[  836.534120] wlan0: deauthenticating from 00:26:f2:f7:cf:b2 by local
choice (reason=3)
[  836.570864] ------------[ cut here ]------------
[  836.570894] WARNING: at net/mac80211/agg-tx.c:685
ieee80211_start_tx_ba_cb+0x1b5/0x240 [mac80211]()
[  836.570896] Hardware name: 2324JB2
[  836.570898] Modules linked in: fuse uvcvideo videobuf2_core videodev
videobuf2_vmalloc videobuf2_memops sha256_generic arc4 dm_crypt dm_mod
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
coretemp snd_seq_midi kvm_intel snd_rawmidi kvm snd_seq_midi_event
snd_seq snd_timer snd_seq_device thinkpad_acpi iwldvm wmi nvram mac80211
snd iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 iwlwifi nf_nat_ipv4
nf_nat nf_conntrack ip_tables rfcomm x_tables cfg80211 microcode
ehci_pci psmouse bnep soundcore ehci_hcd snd_page_alloc bluetooth rfkill
binfmt_misc ext4 mbcache jbd2 sd_mod crc32c_intel ahci libahci
aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul i915 fbcon
tileblit font bitblit softcursor sdhci_pci sdhci drm_kms_helper mmc_core
drm e1000e intel_agp cfbcopyarea i2c_algo_bit intel_gtt agpgart i2c_core
video cfbimgblt cfbfillrect
[  836.570983] Pid: 228, comm: kworker/u:4 Not tainted 3.8.0-rc4-wl #158
[  836.570985] Call Trace:
[  836.570994]  [<ffffffff8103d270>] ? warn_slowpath_common+0x80/0xc0
[  836.571008]  [<ffffffffa043e795>] ?
ieee80211_start_tx_ba_cb+0x1b5/0x240 [mac80211]
[  836.571020]  [<ffffffffa044344a>] ? ieee80211_iface_work+0x23a/0x360
[mac80211]
[  836.571026]  [<ffffffff8105a638>] ? process_one_work+0x128/0x440
[  836.571030]  [<ffffffff8105a400>] ?
cwq_activate_delayed_work+0x50/0xb0
[  836.571041]  [<ffffffffa0443210>] ?
ieee80211_recalc_smps_work+0x20/0x20 [mac80211]
[  836.571046]  [<ffffffff8105c258>] ? worker_thread+0x158/0x3f0
[  836.571050]  [<ffffffff8105c100>] ? manage_workers+0x120/0x120
[  836.571056]  [<ffffffff810614d8>] ? kthread+0xb8/0xc0
[  836.571061]  [<ffffffff81060000>] ? do_schedule_next_timer+0x60/0xf0
[  836.571066]  [<ffffffff81061420>] ? flush_kthread_work+0x130/0x130
[  836.571072]  [<ffffffff81483b1c>] ? ret_from_fork+0x7c/0xb0
[  836.571078]  [<ffffffff81061420>] ? flush_kthread_work+0x130/0x130
[  836.571080] ---[ end trace 47a8f428a09862e9 ]---
[  836.627476] cfg80211: Calling CRDA to update world regulatory domain
[  836.627777] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[  836.744181] cfg80211: World regulatory domain updated:

-- 
Kalle Valo
