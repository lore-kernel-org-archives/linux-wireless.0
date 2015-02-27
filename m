Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:42498 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbbB0QLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 11:11:39 -0500
Received: by mail-qa0-f45.google.com with SMTP id j7so13380994qaq.4
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2015 08:11:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+uMeVct4LSHw9HsxFm1DCdEPDr81_SpkHFeyQptd2eR1+1XSg@mail.gmail.com>
References: <CA+uMeVeu0y892+HPCNK5zbuk48WTawaue9p5j690D9n77yzw1w@mail.gmail.com>
 <CA+uMeVct4LSHw9HsxFm1DCdEPDr81_SpkHFeyQptd2eR1+1XSg@mail.gmail.com>
From: =?UTF-8?B?0JHQvtGA0LjRgdC70LDQsiDQodGK0LHQtdCy?=
	<borislavsabev@gmail.com>
Date: Fri, 27 Feb 2015 18:11:07 +0200
Message-ID: <CA+uMeVcwpfOfQ=TnQA5omYga5Qu1bynNYz1gAQbcR4VqpFcXXg@mail.gmail.com> (sfid-20150227_171142_538428_5980AB84)
Subject: Re: Intel Wireless 7260 - Possible bug within iwlwifi
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, we have 4 Dell Laptops with an Intel Wireless 7260 but we are
experiencing problems with the iwlwifi firmware.

The problem is that If our WiFi goes down (or we need to restart the
router) after the router is back up the connection could not be
established again.

In the dmesg line: "[  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit
toggled to disable radio."      is produced when we try to stop/start
the adapter via its hardware button or the button in NetworkManager.

Hope this helps to solve the issue for everyone.
Again I have 4 machines with this issue so I can also test different
stuff on Debian 8 Jessie & Ubuntu 14.04!

Thanks,
    Borislav.


================
This seems connected:
================
http://askubuntu.com/questions/489157/intel-wireless-7260-card-doesnt-connect-to-wifi-sometimes

================
Output of lspci:
================
02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)

================
Relevant section of dmesg:
================
[  115.810330] cfg80211: Calling CRDA to update world regulatory domain
[  115.812404] cfg80211: World regulatory domain updated:
[  115.812407] cfg80211:  DFS Master region: unset
[  115.812408] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[  115.812410] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[  115.812411] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[  115.812412] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(N/A, 2000 mBm), (N/A)
[  115.812414] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  115.812415] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  115.812416] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2000 mBm), (0 s)
[  115.812417] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[  115.812418] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
[  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[  167.863793] ------------[ cut here ]------------
[  167.863804] WARNING: CPU: 0 PID: 557 at /build/linux-y7bjb0/linux-3.
16.7-ckt4/net/wireless/core.c:949
cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]()
[  167.863805] Modules linked in: ctr ccm bnep ecb btusb bluetooth
6lowpan_iphc snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core v4l2_common videodev media joydev arc4
hid_generic usbhid hid iwlmvm mac80211 snd_hda_codec_realtek
snd_hda_codec_generic iwlwifi sdhci_pci sdhci mmc_core cfg80211
iTCO_wdt iTCO_vendor_support pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) uinput vboxdrv(O) dell_wmi sparse_keymap nfsd
auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc dell_laptop
rfkill dcdbas x86_pkg_temp_thermal intel_powerclamp intel_rapl
coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
nls_utf8 nls_cp437 pcspkr efi_pstore psmouse evdev serio_raw vfat
efivars fat fuse i2c_i801 sg ehci_pci
[  167.863835]  lpc_ich i915 shpchp mfd_core ehci_hcd wmi battery
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep dell_smo8800
snd_pcm e1000e drm_kms_helper xhci_hcd snd_timer drm snd i2c_algo_bit
mei_me usbcore i2c_core soundcore ptp mei video pps_core usb_common
processor ac button parport_pc ppdev lp parport autofs4 ext4 crc16
mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ahci crct10dif_pclmul
crct10dif_common libahci libata scsi_mod thermal thermal_sys
[  167.863858] CPU: 0 PID: 557 Comm: NetworkManager Tainted: G
  O  3.16.0-4-amd64 #1 Debian 3.16.7-ckt4-3
[  167.863859] Hardware name: Dell Inc. Latitude E5540/0C1C28, BIOS
A06 05/01/2014
[  167.863860]  0000000000000009 ffffffff815096a7 0000000000000000
ffffffff810676f7
[  167.863861]  ffff88040d0328d0 ffff88040cb90260 ffff88040d032000
0000000000000002
[  167.863863]  ffff88040cb90000 ffffffffa07b13b1 ffffffff818b9080
ffffffff814c87d0
[  167.863865] Call Trace:
[  167.863869]  [<ffffffff815096a7>] ? dump_stack+0x41/0x51
[  167.863873]  [<ffffffff810676f7>] ? warn_slowpath_common+0x77/0x90
[  167.863877]  [<ffffffffa07b13b1>] ?
cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]
[  167.863880]  [<ffffffff814c87d0>] ? fib6_walk_continue+0x1c0/0x1c0
[  167.863884]  [<ffffffff81415bdb>] ? __dev_remove_pack+0x3b/0xa0
[  167.863887]  [<ffffffff814f24bc>] ? __unregister_prot_hook+0xcc/0xd0
[  167.863890]  [<ffffffff8108bf4c>] ? notifier_call_chain+0x4c/0x70
[  167.863893]  [<ffffffff814168ed>] ? dev_close_many+0xcd/0x120
[  167.863896]  [<ffffffff814186cf>] ? dev_close.part.73+0x2f/0x50
[  167.863898]  [<ffffffff81418703>] ? dev_close+0x13/0x20
[  167.863903]  [<ffffffffa07b0825>] ?
cfg80211_shutdown_all_interfaces+0x45/0xb0 [cfg80211]
[  167.863908]  [<ffffffffa07b08f5>] ?
cfg80211_rfkill_set_block+0x25/0x30 [cfg80211]
[  167.863913]  [<ffffffffa056ca3d>] ? rfkill_set_block+0x8d/0x150 [rfkill]
[  167.863916]  [<ffffffffa056cdba>] ? rfkill_fop_write+0xca/0x170 [rfkill]
[  167.863921]  [<ffffffff811a7b72>] ? vfs_write+0xb2/0x1f0
[  167.863924]  [<ffffffff811a86b2>] ? SyS_write+0x42/0xa0
[  167.863927]  [<ffffffff8150f76d>] ? system_call_fast_compare_end+0x10/0x15
[  167.863929] ---[ end trace ce519672f5a2fc56 ]---
[  167.863931] ------------[ cut here ]------------
[  167.863938] WARNING: CPU: 0 PID: 557 at
/build/linux-y7bjb0/linux-3.16.7-ckt4/net/mac80211/driver-ops.h:12
ieee80211_request_sched_scan_stop+0x15d/0x170 [mac80211]()
[  167.863940] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
[  167.863940] Modules linked in: ctr ccm bnep ecb btusb bluetooth
6lowpan_iphc snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core v4l2_common videodev media joydev arc4
hid_generic usbhid hid iwlmvm mac80211 snd_hda_codec_realtek
snd_hda_codec_generic iwlwifi sdhci_pci sdhci mmc_core cfg80211
iTCO_wdt iTCO_vendor_support pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) uinput vboxdrv(O) dell_wmi sparse_keymap nfsd
auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc dell_laptop
rfkill dcdbas x86_pkg_temp_thermal intel_powerclamp intel_rapl
coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
nls_utf8 nls_cp437 pcspkr efi_pstore psmouse evdev serio_raw vfat
efivars fat fuse i2c_i801 sg ehci_pci
[  167.863964]  lpc_ich i915 shpchp mfd_core ehci_hcd wmi battery
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep dell_smo8800
snd_pcm e1000e drm_kms_helper xhci_hcd snd_timer drm snd i2c_algo_bit
mei_me usbcore i2c_core soundcore ptp mei video pps_core usb_common
processor ac button parport_pc ppdev lp parport autofs4 ext4 crc16
mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ahci crct10dif_pclmul
crct10dif_common libahci libata scsi_mod thermal thermal_sys
[  167.863983] CPU: 0 PID: 557 Comm: NetworkManager Tainted: G
W  O  3.16.0-4-amd64 #1 Debian 3.16.7-ckt4-3
[  167.863984] Hardware name: Dell Inc. Latitude E5540/0C1C28, BIOS
A06 05/01/2014
[  167.863985]  0000000000000009 ffffffff815096a7 ffff880409e5fce8
ffffffff810676f7
[  167.863987]  0000000000000000 ffff880409e5fd38 ffff88040cb913b8
00000000fffffffb
[  167.863989]  ffff88040d0328c0 ffffffff8106775c ffffffffa09a83e8
ffff880400000028
[  167.863991] Call Trace:
[  167.863994]  [<ffffffff815096a7>] ? dump_stack+0x41/0x51
[  167.863997]  [<ffffffff810676f7>] ? warn_slowpath_common+0x77/0x90
[  167.863999]  [<ffffffff8106775c>] ? warn_slowpath_fmt+0x4c/0x50
[  167.864005]  [<ffffffffa07b13b1>] ?
cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]
[  167.864007]  [<ffffffff81506eb5>] ? printk+0x54/0x56
[  167.864022]  [<ffffffffa095bded>] ?
ieee80211_request_sched_scan_stop+0x15d/0x170 [mac80211]
[  167.864028]  [<ffffffffa07ba465>] ?
__cfg80211_stop_sched_scan+0x55/0x130 [cfg80211]
[  167.864032]  [<ffffffffa07b13bb>] ?
cfg80211_netdev_notifier_call+0x56b/0x620 [cfg80211]
[  167.864034]  [<ffffffff814c87d0>] ? fib6_walk_continue+0x1c0/0x1c0
[  167.864037]  [<ffffffff81415bdb>] ? __dev_remove_pack+0x3b/0xa0
[  167.864039]  [<ffffffff814f24bc>] ? __unregister_prot_hook+0xcc/0xd0
[  167.864041]  [<ffffffff8108bf4c>] ? notifier_call_chain+0x4c/0x70
[  167.864043]  [<ffffffff814168ed>] ? dev_close_many+0xcd/0x120
[  167.864046]  [<ffffffff814186cf>] ? dev_close.part.73+0x2f/0x50
[  167.864048]  [<ffffffff81418703>] ? dev_close+0x13/0x20
[  167.864052]  [<ffffffffa07b0825>] ?
cfg80211_shutdown_all_interfaces+0x45/0xb0 [cfg80211]
[  167.864056]  [<ffffffffa07b08f5>] ?
cfg80211_rfkill_set_block+0x25/0x30 [cfg80211]
[  167.864059]  [<ffffffffa056ca3d>] ? rfkill_set_block+0x8d/0x150 [rfkill]
[  167.864062]  [<ffffffffa056cdba>] ? rfkill_fop_write+0xca/0x170 [rfkill]
[  167.864065]  [<ffffffff811a7b72>] ? vfs_write+0xb2/0x1f0
[  167.864067]  [<ffffffff811a86b2>] ? SyS_write+0x42/0xa0
[  167.864069]  [<ffffffff8150f76d>] ? system_call_fast_compare_end+0x10/0x15
[  167.864071] ---[ end trace ce519672f5a2fc57 ]---
[  169.717212] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
[  169.717642] iwlwifi 0000:02:00.0: L1 Disabled - LTR Enabled
[  169.717793] iwlwifi 0000:02:00.0: L1 Disabled - LTR Enabled
[  169.728776] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready

On Fri, Feb 27, 2015 at 6:07 PM, Борислав Събев <borislavsabev@gmail.com> wrote:
>
> Hello, we have 4 Dell Laptops with an Intel Wireless 7260 but we are experiencing problems with the iwlwifi firmware.
>
> The problem is that If our WiFi goes down (or we need to restart the router) after the router is back up the connection could not be established again.
>
> In the dmesg line: "[  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio."      is produced when we try to stop/start the adapter via its hardware button or the button in NetworkManager.
>
> Hope this helps to solve the issue for everyone.
>
> This seems connected:
> http://askubuntu.com/questions/489157/intel-wireless-7260-card-doesnt-connect-to-wifi-sometimes
>
> Output of lspci:
> 02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)
>
> Relevant section of dmesg:
> [  115.810330] cfg80211: Calling CRDA to update world regulatory domain
> [  115.812404] cfg80211: World regulatory domain updated:
> [  115.812407] cfg80211:  DFS Master region: unset
> [  115.812408] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [  115.812410] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [  115.812411] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [  115.812412] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [  115.812414] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> [  115.812415] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> [  115.812416] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [  115.812417] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [  115.812418] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
> [  167.863793] ------------[ cut here ]------------
> [  167.863804] WARNING: CPU: 0 PID: 557 at /build/linux-y7bjb0/linux-3.16.7-ckt4/net/wireless/core.c:949 cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]()
> [  167.863805] Modules linked in: ctr ccm bnep ecb btusb bluetooth 6lowpan_iphc snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media joydev arc4 hid_generic usbhid hid iwlmvm mac80211 snd_hda_codec_realtek snd_hda_codec_generic iwlwifi sdhci_pci sdhci mmc_core cfg80211 iTCO_wdt iTCO_vendor_support pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) uinput vboxdrv(O) dell_wmi sparse_keymap nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc dell_laptop rfkill dcdbas x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd nls_utf8 nls_cp437 pcspkr efi_pstore psmouse evdev serio_raw vfat efivars fat fuse i2c_i801 sg ehci_pci
> [  167.863835]  lpc_ich i915 shpchp mfd_core ehci_hcd wmi battery snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep dell_smo8800 snd_pcm e1000e drm_kms_helper xhci_hcd snd_timer drm snd i2c_algo_bit mei_me usbcore i2c_core soundcore ptp mei video pps_core usb_common processor ac button parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ahci crct10dif_pclmul crct10dif_common libahci libata scsi_mod thermal thermal_sys
> [  167.863858] CPU: 0 PID: 557 Comm: NetworkManager Tainted: G           O  3.16.0-4-amd64 #1 Debian 3.16.7-ckt4-3
> [  167.863859] Hardware name: Dell Inc. Latitude E5540/0C1C28, BIOS A06 05/01/2014
> [  167.863860]  0000000000000009 ffffffff815096a7 0000000000000000 ffffffff810676f7
> [  167.863861]  ffff88040d0328d0 ffff88040cb90260 ffff88040d032000 0000000000000002
> [  167.863863]  ffff88040cb90000 ffffffffa07b13b1 ffffffff818b9080 ffffffff814c87d0
> [  167.863865] Call Trace:
> [  167.863869]  [<ffffffff815096a7>] ? dump_stack+0x41/0x51
> [  167.863873]  [<ffffffff810676f7>] ? warn_slowpath_common+0x77/0x90
> [  167.863877]  [<ffffffffa07b13b1>] ? cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]
> [  167.863880]  [<ffffffff814c87d0>] ? fib6_walk_continue+0x1c0/0x1c0
> [  167.863884]  [<ffffffff81415bdb>] ? __dev_remove_pack+0x3b/0xa0
> [  167.863887]  [<ffffffff814f24bc>] ? __unregister_prot_hook+0xcc/0xd0
> [  167.863890]  [<ffffffff8108bf4c>] ? notifier_call_chain+0x4c/0x70
> [  167.863893]  [<ffffffff814168ed>] ? dev_close_many+0xcd/0x120
> [  167.863896]  [<ffffffff814186cf>] ? dev_close.part.73+0x2f/0x50
> [  167.863898]  [<ffffffff81418703>] ? dev_close+0x13/0x20
> [  167.863903]  [<ffffffffa07b0825>] ? cfg80211_shutdown_all_interfaces+0x45/0xb0 [cfg80211]
> [  167.863908]  [<ffffffffa07b08f5>] ? cfg80211_rfkill_set_block+0x25/0x30 [cfg80211]
> [  167.863913]  [<ffffffffa056ca3d>] ? rfkill_set_block+0x8d/0x150 [rfkill]
> [  167.863916]  [<ffffffffa056cdba>] ? rfkill_fop_write+0xca/0x170 [rfkill]
> [  167.863921]  [<ffffffff811a7b72>] ? vfs_write+0xb2/0x1f0
> [  167.863924]  [<ffffffff811a86b2>] ? SyS_write+0x42/0xa0
> [  167.863927]  [<ffffffff8150f76d>] ? system_call_fast_compare_end+0x10/0x15
> [  167.863929] ---[ end trace ce519672f5a2fc56 ]---
> [  167.863931] ------------[ cut here ]------------
> [  167.863938] WARNING: CPU: 0 PID: 557 at /build/linux-y7bjb0/linux-3.16.7-ckt4/net/mac80211/driver-ops.h:12 ieee80211_request_sched_scan_stop+0x15d/0x170 [mac80211]()
> [  167.863940] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
> [  167.863940] Modules linked in: ctr ccm bnep ecb btusb bluetooth 6lowpan_iphc snd_hda_codec_hdmi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media joydev arc4 hid_generic usbhid hid iwlmvm mac80211 snd_hda_codec_realtek snd_hda_codec_generic iwlwifi sdhci_pci sdhci mmc_core cfg80211 iTCO_wdt iTCO_vendor_support pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) uinput vboxdrv(O) dell_wmi sparse_keymap nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc dell_laptop rfkill dcdbas x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd nls_utf8 nls_cp437 pcspkr efi_pstore psmouse evdev serio_raw vfat efivars fat fuse i2c_i801 sg ehci_pci
> [  167.863964]  lpc_ich i915 shpchp mfd_core ehci_hcd wmi battery snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep dell_smo8800 snd_pcm e1000e drm_kms_helper xhci_hcd snd_timer drm snd i2c_algo_bit mei_me usbcore i2c_core soundcore ptp mei video pps_core usb_common processor ac button parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ahci crct10dif_pclmul crct10dif_common libahci libata scsi_mod thermal thermal_sys
> [  167.863983] CPU: 0 PID: 557 Comm: NetworkManager Tainted: G        W  O  3.16.0-4-amd64 #1 Debian 3.16.7-ckt4-3
> [  167.863984] Hardware name: Dell Inc. Latitude E5540/0C1C28, BIOS A06 05/01/2014
> [  167.863985]  0000000000000009 ffffffff815096a7 ffff880409e5fce8 ffffffff810676f7
> [  167.863987]  0000000000000000 ffff880409e5fd38 ffff88040cb913b8 00000000fffffffb
> [  167.863989]  ffff88040d0328c0 ffffffff8106775c ffffffffa09a83e8 ffff880400000028
> [  167.863991] Call Trace:
> [  167.863994]  [<ffffffff815096a7>] ? dump_stack+0x41/0x51
> [  167.863997]  [<ffffffff810676f7>] ? warn_slowpath_common+0x77/0x90
> [  167.863999]  [<ffffffff8106775c>] ? warn_slowpath_fmt+0x4c/0x50
> [  167.864005]  [<ffffffffa07b13b1>] ? cfg80211_netdev_notifier_call+0x561/0x620 [cfg80211]
> [  167.864007]  [<ffffffff81506eb5>] ? printk+0x54/0x56
> [  167.864022]  [<ffffffffa095bded>] ? ieee80211_request_sched_scan_stop+0x15d/0x170 [mac80211]
> [  167.864028]  [<ffffffffa07ba465>] ? __cfg80211_stop_sched_scan+0x55/0x130 [cfg80211]
> [  167.864032]  [<ffffffffa07b13bb>] ? cfg80211_netdev_notifier_call+0x56b/0x620 [cfg80211]
> [  167.864034]  [<ffffffff814c87d0>] ? fib6_walk_continue+0x1c0/0x1c0
> [  167.864037]  [<ffffffff81415bdb>] ? __dev_remove_pack+0x3b/0xa0
> [  167.864039]  [<ffffffff814f24bc>] ? __unregister_prot_hook+0xcc/0xd0
> [  167.864041]  [<ffffffff8108bf4c>] ? notifier_call_chain+0x4c/0x70
> [  167.864043]  [<ffffffff814168ed>] ? dev_close_many+0xcd/0x120
> [  167.864046]  [<ffffffff814186cf>] ? dev_close.part.73+0x2f/0x50
> [  167.864048]  [<ffffffff81418703>] ? dev_close+0x13/0x20
> [  167.864052]  [<ffffffffa07b0825>] ? cfg80211_shutdown_all_interfaces+0x45/0xb0 [cfg80211]
> [  167.864056]  [<ffffffffa07b08f5>] ? cfg80211_rfkill_set_block+0x25/0x30 [cfg80211]
> [  167.864059]  [<ffffffffa056ca3d>] ? rfkill_set_block+0x8d/0x150 [rfkill]
> [  167.864062]  [<ffffffffa056cdba>] ? rfkill_fop_write+0xca/0x170 [rfkill]
> [  167.864065]  [<ffffffff811a7b72>] ? vfs_write+0xb2/0x1f0
> [  167.864067]  [<ffffffff811a86b2>] ? SyS_write+0x42/0xa0
> [  167.864069]  [<ffffffff8150f76d>] ? system_call_fast_compare_end+0x10/0x15
> [  167.864071] ---[ end trace ce519672f5a2fc57 ]---
> [  169.717212] iwlwifi 0000:02:00.0: RF_KILL bit toggled to enable radio.
> [  169.717642] iwlwifi 0000:02:00.0: L1 Disabled - LTR Enabled
> [  169.717793] iwlwifi 0000:02:00.0: L1 Disabled - LTR Enabled
> [  169.728776] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready




--
  Best Regards,
Borislav Sabev.
