Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcFTVxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 17:53:46 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: WARNING at include/net/fq_impl.h:22 fq_flow_dequeue+0xed/0x140
 [mac80211]
Date: Mon, 20 Jun 2016 21:53:30 +0000
Message-ID: <878txzo7c6.fsf@kamboji.qca.qualcomm.com> (sfid-20160620_235349_455304_5DC34039)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I updated to latest wireless-testing (wt-2016-06-20) and noticed that my
syslog has thousands of warnings like this:

[  237.335805] ------------[ cut here ]------------
[  237.335852] WARNING: CPU: 3 PID: 1921 at include/net/fq_impl.h:22 fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.335855] Modules linked in: ath10k_pci(E-) ath10k_core(E) ath(E) mac80211(E) cfg80211(E) arc4 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core coretemp snd_hwdep snd_pcm joydev input_leds serio_raw snd_seq_midi btusb btintel snd_r
[  237.335913] CPU: 3 PID: 1921 Comm: rmmod Tainted: G        W   E   4.7.0-rc4-wt-ath+ #1377
[  237.335916] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[  237.335918]  00200286 00200286 eff85dac c14151e2 f901574e 00000000 eff85de0 c1081075
[  237.335928]  c1ab91f0 00000003 00000781 f901574e 00000016 f8fbabad f8fbabad 00000016
[  237.335938]  eb24ff60 00000000 ef3886c0 eff85df4 c10810ba 00000009 00000000 00000000
[  237.335948] Call Trace:
[  237.335953]  [<c14151e2>] dump_stack+0x76/0xb4
[  237.335957]  [<c1081075>] __warn+0xe5/0x100
[  237.336002]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336046]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336053]  [<c10810ba>] warn_slowpath_null+0x2a/0x30
[  237.336095]  [<f8fbabad>] fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336137]  [<f8fbc67a>] fq_flow_reset.constprop.56+0x2a/0x90 [mac80211]
[  237.336180]  [<f8fbc79a>] fq_reset.constprop.59+0x2a/0x50 [mac80211]
[  237.336222]  [<f8fc04e8>] ieee80211_txq_teardown_flows+0x38/0x40 [mac80211]
[  237.336258]  [<f8f7c1a4>] ieee80211_unregister_hw+0xe4/0x120 [mac80211]
[  237.336275]  [<f933f536>] ath10k_mac_unregister+0x16/0x50 [ath10k_core]
[  237.336292]  [<f934592d>] ath10k_core_unregister+0x3d/0x90 [ath10k_core]
[  237.336301]  [<f85f8836>] ath10k_pci_remove+0x36/0xa0 [ath10k_pci]
[  237.336307]  [<c1470388>] pci_device_remove+0x38/0xb0
[  237.336314]  [<c1572e8b>] __device_release_driver+0x7b/0x110
[  237.336321]  [<c1573117>] driver_detach+0x97/0xa0
[  237.336327]  [<c1571f7f>] bus_remove_driver+0x4f/0xc0
[  237.336333]  [<c1573d0a>] driver_unregister+0x2a/0x60
[  237.336339]  [<c146f3a8>] pci_unregister_driver+0x18/0x70
[  237.336347]  [<f85f9c8e>] ath10k_pci_exit+0xd/0x37f [ath10k_pci]
[  237.336354]  [<c1122fd8>] SyS_delete_module+0xf8/0x170
[  237.336361]  [<c11e66c9>] ? __might_fault+0x49/0xa0
[  237.336367]  [<c11e6713>] ? __might_fault+0x93/0xa0
[  237.336373]  [<c1003886>] do_fast_syscall_32+0xa6/0x1d0
[  237.336379]  [<c1871dbc>] sysenter_past_esp+0x45/0x74
[  237.336384] ---[ end trace 6fc65ff0beec502c ]---
[  237.336388] ------------[ cut here ]------------
[  237.336431] WARNING: CPU: 3 PID: 1921 at include/net/fq_impl.h:22 fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336435] Modules linked in: ath10k_pci(E-) ath10k_core(E) ath(E) mac80211(E) cfg80211(E) arc4 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core coretemp snd_hwdep snd_pcm joydev input_leds serio_raw snd_seq_midi btusb btintel snd_r
[  237.336537] CPU: 3 PID: 1921 Comm: rmmod Tainted: G        W   E   4.7.0-rc4-wt-ath+ #1377
[  237.336542] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[  237.336546]  00200286 00200286 eff85dac c14151e2 f901574e 00000000 eff85de0 c1081075
[  237.336563]  c1ab91f0 00000003 00000781 f901574e 00000016 f8fbabad f8fbabad 00000016
[  237.336573]  eb24ffb0 00000000 ef3886c0 eff85df4 c10810ba 00000009 00000000 00000000
[  237.336581] Call Trace:
[  237.336586]  [<c14151e2>] dump_stack+0x76/0xb4
[  237.336590]  [<c1081075>] __warn+0xe5/0x100
[  237.336634]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336678]  [<f8fbabad>] ? fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336682]  [<c10810ba>] warn_slowpath_null+0x2a/0x30
[  237.336726]  [<f8fbabad>] fq_flow_dequeue+0xed/0x140 [mac80211]
[  237.336770]  [<f8fbc67a>] fq_flow_reset.constprop.56+0x2a/0x90 [mac80211]
[  237.336814]  [<f8fbc79a>] fq_reset.constprop.59+0x2a/0x50 [mac80211]
[  237.336857]  [<f8fc04e8>] ieee80211_txq_teardown_flows+0x38/0x40 [mac80211]
[  237.336895]  [<f8f7c1a4>] ieee80211_unregister_hw+0xe4/0x120 [mac80211]
[  237.336912]  [<f933f536>] ath10k_mac_unregister+0x16/0x50 [ath10k_core]
[  237.336928]  [<f934592d>] ath10k_core_unregister+0x3d/0x90 [ath10k_core]
[  237.336934]  [<f85f8836>] ath10k_pci_remove+0x36/0xa0 [ath10k_pci]
[  237.336939]  [<c1470388>] pci_device_remove+0x38/0xb0
[  237.336944]  [<c1572e8b>] __device_release_driver+0x7b/0x110
[  237.336948]  [<c1573117>] driver_detach+0x97/0xa0
[  237.336952]  [<c1571f7f>] bus_remove_driver+0x4f/0xc0
[  237.336957]  [<c1573d0a>] driver_unregister+0x2a/0x60
[  237.336960]  [<c146f3a8>] pci_unregister_driver+0x18/0x70
[  237.336966]  [<f85f9c8e>] ath10k_pci_exit+0xd/0x37f [ath10k_pci]
[  237.336970]  [<c1122fd8>] SyS_delete_module+0xf8/0x170
[  237.336974]  [<c11e66c9>] ? __might_fault+0x49/0xa0
[  237.336980]  [<c11e6713>] ? __might_fault+0x93/0xa0
[  237.336986]  [<c1003886>] do_fast_syscall_32+0xa6/0x1d0
[  237.336992]  [<c1871dbc>] sysenter_past_esp+0x45/0x74
[  237.336997] ---[ end trace 6fc65ff0beec502d ]---

-- 
Kalle Valo