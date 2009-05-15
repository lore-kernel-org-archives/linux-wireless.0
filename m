Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:38999 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752630AbZEOG7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 02:59:11 -0400
Received: from [134.61.45.154] (45-154.eduroam.RWTH-Aachen.DE [134.61.45.154])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.unitix.de (Postfix) with ESMTP id 240B013EA0
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 08:39:51 +0200 (CEST)
Message-ID: <4A0D0E36.3010304@nets.rwth-aachen.de>
Date: Fri, 15 May 2009 08:39:50 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 2.6.29.3: iwlwifi WARNING
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

                                       
Hi,

I'm using ubuntu jaunty with 2.6.29.3 mainline build:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.29.3/

And from time to time get this:

[98439.060208] ------------[ cut here ]------------
[98439.060217] WARNING: at
/home/kernel-ppa/mainline/build/drivers/net/wireless/iwlwifi/iwl-sta.c:728
iwl_set_tkip_dynamic_key_info+0xc0/0xd0 [iwlcore]()
[98439.060224] Hardware name: 20552PG
[98439.060228] no space for new kewModules linked in: nls_iso8859_1
nls_cp437 vfat fat usb_storage binfmt_misc i915 drm i2c_algo_bit ppdev
bnep ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_
REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel
kvm sbp2 lp parport snd_hda_codec_conexant joydev snd_hda_intel
snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi snd_rawmidi sn
d_seq_midi_event arc4 ecb snd_seq snd_timer snd_seq_device iwlagn
iwlcore snd mac80211 soundcore thinkpad_acpi pcmcia sdhci_pci sdhci
psmouse iTCO_wdt video intel_agp agpgart snd_page_alloc pcspkr nvram
yenta_socket rsrc_nonstatic pcmcia
_core ricoh_mmc led_class iTCO_vendor_support serio_raw btusb output
cfg80211 sha256_generic aes_i586 aes_generic cbc ohci1394 ieee1394
e1000e dm_crypt
[98439.060372] Pid: 10, comm: events/0 Not tainted
2.6.29-02062903-generic #02062903
[98439.060377] Call Trace:
[98439.060394]  [<c013a636>] warn_slowpath+0x86/0xa0
[98439.060409]  [<c04f7938>] ? _spin_lock+0x8/0x10
[98439.060418]  [<c01e967c>] ? inotify_d_instantiate+0x3c/0x50
[98439.060427]  [<c028879c>] ? security_d_instantiate+0x1c/0x20
[98439.060436]  [<c01cebf8>] ? d_instantiate+0x38/0x40
[98439.060444]  [<c01cf3c7>] ? dput+0x67/0xd0
[98439.060453]  [<c01220f8>] ? default_spin_lock_flags+0x8/0x10
[98439.060460]  [<c04f78e2>] ? _spin_lock_irqsave+0x32/0x50
[98439.060489]  [<f80ea900>] iwl_set_tkip_dynamic_key_info+0xc0/0xd0
[iwlcore]
[98439.060523]  [<f80eac5f>] iwl_set_dynamic_key+0x5f/0x80 [iwlcore]
[98439.060546]  [<f81a5793>] iwl_mac_set_key+0xf3/0x120 [iwlagn]
[98439.060565]  [<f81a56a0>] ? iwl_mac_set_key+0x0/0x120 [iwlagn]
[98439.060606]  [<f8097fd3>] ieee80211_key_enable_hw_accel+0x53/0xc0
[mac80211]
[98439.060622]  [<c027a9fc>] ? debugfs_remove+0x4c/0x60
[98439.060665]  [<f8098168>] __ieee80211_key_todo+0xe8/0x130 [mac80211]
[98439.060674]  [<c04f6044>] ? schedule+0x2f4/0x570
[98439.060681]  [<c04f69eb>] ? mutex_lock+0xb/0x20
[98439.060727]  [<f80982cd>] ieee80211_key_todo+0xd/0x20 [mac80211]
[98439.060767]  [<f8098368>] key_todo+0x8/0x10 [mac80211]
[98439.060775]  [<c014b344>] run_workqueue+0xd4/0x170
[98439.060815]  [<f8098360>] ? key_todo+0x0/0x10 [mac80211]
[98439.060824]  [<c014bd28>] worker_thread+0x88/0xe0
[98439.060832]  [<c014ede0>] ? autoremove_wake_function+0x0/0x40
[98439.060840]  [<c014bca0>] ? worker_thread+0x0/0xe0
[98439.060846]  [<c014ea72>] kthread+0x42/0x70
[98439.060852]  [<c014ea30>] ? kthread+0x0/0x70
[98439.060860]  [<c0103da7>] kernel_thread_helper+0x7/0x10
[98439.060865] ---[ end trace 3b8aa73681896774 ]---
[102020.364126] iwlagn: Removing wrong key 1 0x410b
[102020.364274] ------------[ cut here ]------------

and then this very same message spams my dmesg.
Computer is a Lenovo T500 with Core2Duo.

Best regards,
Arnd
