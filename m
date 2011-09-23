Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46812 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1IWUjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 16:39:01 -0400
Received: by gwb15 with SMTP id 15so4005966gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 13:39:00 -0700 (PDT)
Message-ID: <4E7CEE67.2070906@lwfinger.net> (sfid-20110923_223919_636391_B76706F6)
Date: Fri, 23 Sep 2011 15:39:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	Ivo van Drn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"Bernhard M. Wiedemann" <bernhardout@lsmod.de>
Subject: Bug in rt2800pci on an RT3090
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A bug was sent to me concerning a scheduling-while-atomic-BUG. This happened 
shortly after KDE suspended an eeepc1015PE netbook during system update over 
WLAN. Suspend&resume normally worked allright. The OP is Berhard Wiedemann in 
the Cc list. Inquiries for more info go to him.

The kernel is 3.1-rc5 from the openSUSE Factory repo on a 32-bit system.

The device is:

02:00.0 Network controller [0280]: Ralink corp. RT3090 Wireless 802.11n
1T/1R PCIe [1814:3090]

The dmesg error dump is

[23281.115155] BUG: scheduling while atomic: kworker/u:22/12821/0x00000101
[23281.115166] Modules linked in: loop af_packet tun coretemp microcode 
sha256_generic cbc dm_crypt fuse dm_mod arc4 rt2800pci rt2800lib crc_ccitt 
rt2x00pci rt2x00lib mac80211 snd_hda_codec_realtek cfg80211 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm uvcvideo videodev snd_timer snd eeepc_wmi 
asus_wmi sparse_keymap pci_hotplug rfkill soundcore eeprom_93cx6 snd_page_alloc 
iTCO_wdt sg pcspkr iTCO_vendor_support battery atl1c wmi joydev ac autofs4 i915 
drm_kms_helper drm i2c_algo_bit button video fan thermal processor thermal_sys
[23281.115299] Modules linked in: loop af_packet tun coretemp microcode 
sha256_generic cbc dm_crypt fuse dm_mod arc4 rt2800pci rt2800lib crc_ccitt 
rt2x00pci rt2x00lib mac80211 snd_hda_codec_realtek cfg80211 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm uvcvideo videodev snd_timer snd eeepc_wmi 
asus_wmi sparse_keymap pci_hotplug rfkill soundcore eeprom_93cx6 snd_page_alloc 
iTCO_wdt sg pcspkr iTCO_vendor_support battery atl1c wmi joydev ac autofs4 i915 
drm_kms_helper drm i2c_algo_bit button video fan thermal processor thermal_sys
[23281.115403]
[23281.115412] Pid: 12821, comm: kworker/u:22 Not tainted 3.1.0-rc5-2-desktop #1 
ASUSTeK Computer INC. 1015P/1015PE
[23281.115426] EIP: 0060:[<f7b9c43b>] EFLAGS: 00000282 CPU: 1
[23281.115440] EIP is at rt2x00pci_regbusy_read+0xb/0xd0 [rt2x00pci]
[23281.115447] EAX: f2915160 EBX: f2915160 ECX: f7baa2a0 EDX: 00007010
[23281.115454] ESI: f2915160 EDI: 00007010 EBP: 000000ff ESP: f1db1e2c
[23281.115461]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[23281.115470] Process kworker/u:22 (pid: 12821, ti=f4910000 task=eb86a4b0 
task.ti=f1db0000)
[23281.115477] Stack:
[23281.115482]  00000000 f1db1e60 8e97f4be 001e8480 ffffffff eb86a4e4 f2414f24 
eb86a4b0
[23281.115503]  00000001 f2915160 f29153f0 000000ff f7bce81d 00000018 ff000000 
f1db1e70
[23281.115521]  013020a0 f1db1e84 f2915160 f2915160 fffffdf4 f2914320 f7ba8965 
000000ff
[23281.115541] Call Trace:
[23281.115576]  [<f7bce81d>] rt2800_mcu_request.part.27+0x5d/0xd0 [rt2800lib]
[23281.115612]  [<f7ba8965>] rt2800pci_set_state+0x55/0x90 [rt2800pci]
[23281.115638]  [<f7ba90a5>] rt2800pci_set_device_state+0xd5/0x13b [rt2800pci]
[23281.115670]  [<f7bcdc82>] rt2800_config_ps.isra.19+0x82/0xe0 [rt2800lib]
[23281.115706]  [<f7bbf5c1>] rt2x00lib_config+0xd1/0x280 [rt2x00lib]
[23281.115744]  [<f7bbec56>] rt2x00mac_config+0x36/0x80 [rt2x00lib]
[23281.115789]  [<f8201fb0>] ieee80211_hw_config+0xc0/0x130 [mac80211]
[23281.115830]  [<f820ca7c>] ieee80211_dynamic_ps_enable_work+0x18c/0x280 [mac80211]
[23281.115927]  [<c0262f5e>] process_one_work+0xee/0x400
[23281.115945]  [<c026356e>] worker_thread+0x11e/0x2c0
[23281.115960]  [<c0266d19>] kthread+0x69/0x70
[23281.115976]  [<c070d3e6>] kernel_thread_helper+0x6/0xd
[23281.115987] Code: 81 fa 00 00 00 01 19 c0 f7 d0 05 d1 00 00 00 eb d4 b8 f4 ff 
ff ff eb 8c 90 8d b4 26 00 00 00 00 55 57 89 d7 56 53 89 c3 83 ec 20 <8b> 8b 38 
02 00 00 8b 44 24 38 8b 54 24 34 8b 6c 24 3c 89 44 24
[23281.116133] Call Trace:
[23281.116163]  [<f7bce81d>] rt2800_mcu_request.part.27+0x5d/0xd0 [rt2800lib]
[23281.116196]  [<f7ba8965>] rt2800pci_set_state+0x55/0x90 [rt2800pci]
[23281.116220]  [<f7ba90a5>] rt2800pci_set_device_state+0xd5/0x13b [rt2800pci]
[23281.116249]  [<f7bcdc82>] rt2800_config_ps.isra.19+0x82/0xe0 [rt2800lib]
[23281.116282]  [<f7bbf5c1>] rt2x00lib_config+0xd1/0x280 [rt2x00lib]
[23281.116318]  [<f7bbec56>] rt2x00mac_config+0x36/0x80 [rt2x00lib]
[23281.116360]  [<f8201fb0>] ieee80211_hw_config+0xc0/0x130 [mac80211]
[23281.116397]  [<f820ca7c>] ieee80211_dynamic_ps_enable_work+0x18c/0x280 [mac80211]
[23281.116493]  [<c0262f5e>] process_one_work+0xee/0x400
[23281.116507]  [<c026356e>] worker_thread+0x11e/0x2c0
[23281.116520]  [<c0266d19>] kthread+0x69/0x70
[23281.116534]  [<c070d3e6>] kernel_thread_helper+0x6/0xd
