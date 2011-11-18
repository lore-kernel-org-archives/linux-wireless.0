Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:40616 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab1KRWrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:47:19 -0500
Received: from [0.0.0.0] (august.arndnet.de [62.75.245.222])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.unitix.de (Postfix) with ESMTPSA id CBE4E3E19
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 23:38:35 +0100 (CET)
Message-ID: <4EC6DE6B.3080603@arndnet.de> (sfid-20111118_234723_826039_8BE33D54)
Date: Fri, 18 Nov 2011 23:38:35 +0100
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just got the following WARNING on a 3.2.0-rc2 kernel:

[  191.516877] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra = 30:46:9a:XX:XX:XX tid = 0
[  191.516890] ------------[ cut here ]------------
[  191.516920] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1105 iwl_trans_pcie_tx+0x835/0x890 [iwlwifi]()
[  191.516925] Hardware name: 4384GEG
[  191.516927] Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bnep rfcomm bridge stp llc kvm_intel kvm binfmt_misc joydev dm_crypt snd_hda_codec_hdmi snd_hda_codec_conexant arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi snd_seq_midi snd_rawmidi snd_seq_midi_event qcserial usb_wwan usbserial snd_seq btusb bluetooth snd_timer snd_seq_device iwlwifi psmouse mac80211 intel_ips serio_raw snd cfg80211 snd_page_alloc mei(C) soundcore nvram tpm_tis btrfs zlib_deflate libcrc32c mxm_wmi firewire_ohci ahci firewire_core libahci wmi e1000e sdhci_pci crc_itu_t i915 drm_kms_helper drm sdhci i2c_algo_bit video
[  191.517007] Pid: 2401, comm: kworker/u:17 Tainted: G        WC   3.2.0-rc2aha #3
[  191.517010] Call Trace:
[  191.517013]  <IRQ>  [<ffffffff81062b9f>] warn_slowpath_common+0x7f/0xc0
[  191.517027]  [<ffffffff81062bfa>] warn_slowpath_null+0x1a/0x20
[  191.517042]  [<ffffffffa031ce25>] iwl_trans_pcie_tx+0x835/0x890 [iwlwifi]
[  191.517059]  [<ffffffffa02810b8>] ? ccmp_encrypt_skb.isra.4+0x108/0x230 [mac80211]
[  191.517067]  [<ffffffff8105a500>] ? try_to_wake_up+0x220/0x2a0
[  191.517073]  [<ffffffff810861e6>] ? autoremove_wake_function+0x16/0x40
[  191.517085]  [<ffffffffa03078d7>] ? iwlagn_tx_skb+0xc7/0x7d0 [iwlwifi]
[  191.517096]  [<ffffffffa0307c60>] iwlagn_tx_skb+0x450/0x7d0 [iwlwifi]
[  191.517110]  [<ffffffffa0323a87>] ? iwl_tx_cmd_complete+0x1e7/0x350 [iwlwifi]
[  191.517120]  [<ffffffffa02fe65a>] iwlagn_mac_tx+0x1a/0x30 [iwlwifi]
[  191.517137]  [<ffffffffa0299436>] __ieee80211_tx+0x76/0x230 [mac80211]
[  191.517152]  [<ffffffffa0320e96>] ? iwl_irq_tasklet+0x846/0xe10 [iwlwifi]
[  191.517170]  [<ffffffffa029b44c>] ieee80211_tx+0x8c/0xc0 [mac80211]
[  191.517187]  [<ffffffffa029c32d>] ieee80211_tx_pending+0x7d/0x220 [mac80211]
[  191.517193]  [<ffffffff8106a20d>] ? __do_softirq+0xfd/0x210
[  191.517199]  [<ffffffff81069b78>] tasklet_action+0x78/0x140
[  191.517204]  [<ffffffff8106a1b8>] __do_softirq+0xa8/0x210
[  191.517210]  [<ffffffff8160f2ac>] call_softirq+0x1c/0x30
[  191.517212]  <EOI>  [<ffffffff81015195>] do_softirq+0x65/0xa0
[  191.517222]  [<ffffffff8106a104>] local_bh_enable_ip+0x94/0xa0
[  191.517227]  [<ffffffff81605109>] _raw_spin_unlock_bh+0x19/0x20
[  191.517241]  [<ffffffffa0284899>] ieee80211_agg_tx_operational+0xb9/0xd0 [mac80211]
[  191.517257]  [<ffffffffa028d9c8>] ? ieee80211_iface_work+0xd8/0x350 [mac80211]
[  191.517273]  [<ffffffffa02850ee>] ieee80211_process_addba_resp+0x11e/0x120 [mac80211]
[  191.517289]  [<ffffffffa028dbef>] ieee80211_iface_work+0x2ff/0x350 [mac80211]
[  191.517305]  [<ffffffffa028d8f0>] ? ieee80211_teardown_sdata+0xe0/0xe0 [mac80211]
[  191.517312]  [<ffffffff8108023a>] process_one_work+0x11a/0x480
[  191.517317]  [<ffffffff81080fc4>] worker_thread+0x164/0x370
[  191.517322]  [<ffffffff81080e60>] ? manage_workers.isra.30+0x230/0x230
[  191.517327]  [<ffffffff8108573c>] kthread+0x8c/0xa0
[  191.517332]  [<ffffffff8160f1b4>] kernel_thread_helper+0x4/0x10
[  191.517338]  [<ffffffff810856b0>] ? flush_kthread_worker+0xa0/0xa0
[  191.517343]  [<ffffffff8160f1b0>] ? gs_change+0x13/0x13
[  191.517346] ---[ end trace f5849db7402e7e61 ]---
[  193.817069] iwlwifi 0000:03:00.0: Queue 11 stuck for 2000 ms.
[  193.817075] iwlwifi 0000:03:00.0: Current read_ptr 166 write_ptr 172
[  193.817078] iwlwifi 0000:03:00.0: On demand firmware reload
[  193.817420] ieee80211 phy0: Hardware restart was requested
[  193.817470] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[  193.817596] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1

Best regards,
Arnd
