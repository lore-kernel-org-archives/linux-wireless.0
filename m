Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38387 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHFGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 01:06:20 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so3593590lbv.12
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 22:06:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Jul 2014 01:06:18 -0400
Message-ID: <CAPoQQ-3gvOXmRAqAwuX_sMa6doDo=05r4OCn+CA_J5D67OU-gA@mail.gmail.com> (sfid-20140708_070624_442670_CA99E844)
Subject: iwlwifi gets into state where it continually fails to associate until
 the driver is re-bound
From: Cody P Schafer <dev@codyps.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel version: 3.15.3 + 1 patch for some btrfs issues. I've also seen
this on 3.15.2.

Hardware:

02:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
[Condor Peak]
        Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi

Logs from the unbind/bind that might have a hint:

[172759.290783] wlp2s0: authentication with c0:8a:de:3a:62:49 timed out
[172821.572691] wlp2s0: authenticate with c0:8a:de:3a:62:49
[172821.583144] wlp2s0: send auth to c0:8a:de:3a:62:49 (try 1/3)
[172822.318448] wlp2s0: send auth to c0:8a:de:3a:62:49 (try 2/3)
[172823.329053] wlp2s0: send auth to c0:8a:de:3a:62:49 (try 3/3)
[172824.309696] wlp2s0: authentication with c0:8a:de:3a:62:49 timed out
[172844.678135] iwlwifi 0000:02:00.0: Error sending REPLY_SCAN_CMD:
enqueue_hcmd failed: -5
[172883.435665] iwlwifi 0000:02:00.0: Error sending REPLY_LEDS_CMD:
enqueue_hcmd failed: -5
[172883.487856] iwlwifi 0000:02:00.0: Error sending REPLY_LEDS_CMD:
enqueue_hcmd failed: -5
[172883.564215] iwlwifi 0000:02:00.0: Error sending REPLY_RXON:
enqueue_hcmd failed: -5
[172883.564221] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-5)
[172883.616306] ------------[ cut here ]------------
[172883.616323] WARNING: CPU: 0 PID: 9317 at
drivers/net/wireless/iwlwifi/pcie/trans.c:1157
iwl_trans_pcie_grab_nic_access+0x2bc/0x2d0 [iwlwifi]()
[172883.616325] Timeout waiting for hardware access (CSR_GP_CNTRL 0x080003d8)
[172883.616327] Modules linked in: fuse tun joydev mousedev ctr ccm
snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic
cachefiles fscache nls_iso8859_1 nls_cp437 vfat fat arc4 iwldvm
mac80211 iwlwifi cfg80211 iTCO_wdt iTCO_vendor_support uas coretemp
intel_powerclamp snd_hda_intel kvm_intel snd_hda_controller
thinkpad_acpi kvm snd_hda_codec snd_hwdep evdev microcode nvram
mac_hid i915 snd_pcm psmouse serio_raw led_class snd_timer pcspkr
i2c_i801 intel_ips snd rfkill soundcore hwmon drm_kms_helper lpc_ich
shpchp thermal ac wmi battery drm e1000e tpm_tis tpm acpi_cpufreq ptp
pps_core video mei_me intel_agp intel_gtt button i2c_algo_bit i2c_core
mei processor btrfs xor raid6_pq xts gf128mul dm_crypt dm_mod sd_mod
crct10dif_generic crc_t10dif crct10dif_common ums_realtek usb_storage
atkbd libps2
[172883.616382]  crc32c_intel ahci libahci libata ehci_pci ehci_hcd
scsi_mod usbcore usb_common i8042 serio
[172883.616391] CPU: 0 PID: 9317 Comm: tee Not tainted 3.15.3-1-ARCH #1
[172883.616393] Hardware name: LENOVO 3249MDU/3249MDU, BIOS 6QET53WW
(1.23 ) 09/15/2010
[172883.616395]  0000000000000000 0000000041ec44e8 ffff8800037479a8
ffffffff81508141
[172883.616398]  ffff8800037479f0 ffff8800037479e0 ffffffff81069afd
ffff880131a49098
[172883.616400]  00000000080003d8 ffff880131a49098 0000000000000000
00000000080003d8
[172883.616403] Call Trace:
[172883.616412]  [<ffffffff81508141>] dump_stack+0x4d/0x6f
[172883.616417]  [<ffffffff81069afd>] warn_slowpath_common+0x7d/0xa0
[172883.616420]  [<ffffffff81069b7c>] warn_slowpath_fmt+0x5c/0x80
[172883.616424]  [<ffffffffa09a963c>]
iwl_trans_pcie_grab_nic_access+0x2bc/0x2d0 [iwlwifi]
[172883.616428]  [<ffffffffa099c579>] iwl_write_prph+0x39/0x80 [iwlwifi]
[172883.616432]  [<ffffffffa09a62b2>] iwl_pcie_tx_stop+0x42/0x130 [iwlwifi]
[172883.616436]  [<ffffffffa09abb50>]
iwl_trans_pcie_stop_device+0x630/0x660 [iwlwifi]
[172883.616441]  [<ffffffffa0a745fa>] iwl_down+0x1aa/0x230 [iwldvm]
[172883.616445]  [<ffffffffa0a7b6da>] iwlagn_mac_stop+0x5a/0xa0 [iwldvm]
[172883.616457]  [<ffffffffa0a0287f>] ieee80211_stop_device+0x4f/0x130
[mac80211]
[172883.616464]  [<ffffffffa09e85aa>] ieee80211_do_stop+0x4aa/0x8a0 [mac80211]
[172883.616468]  [<ffffffff8150d5aa>] ? _raw_spin_unlock_bh+0x1a/0x20
[172883.616472]  [<ffffffff81437aa3>] ? dev_deactivate_many+0x223/0x270
[172883.616479]  [<ffffffffa09e89ba>] ieee80211_stop+0x1a/0x20 [mac80211]
[172883.616483]  [<ffffffff8140ef2d>] __dev_close_many+0x9d/0x100
[172883.616485]  [<ffffffff8140f091>] dev_close_many+0x91/0x140
[172883.616488]  [<ffffffff814119b5>] rollback_registered_many+0x155/0x320
[172883.616491]  [<ffffffff8150aa9d>] ? wait_for_completion+0x1d/0x20
[172883.616494]  [<ffffffff81411c0b>] unregister_netdevice_many+0x1b/0xb0
[172883.616501]  [<ffffffffa09ea4e4>]
ieee80211_remove_interfaces+0x134/0x1d0 [mac80211]
[172883.616507]  [<ffffffffa09d43ab>]
ieee80211_unregister_hw+0x5b/0x120 [mac80211]
[172883.616511]  [<ffffffffa0a7c459>] iwlagn_mac_unregister+0x29/0x40 [iwldvm]
[172883.616514]  [<ffffffffa0a72aab>] iwl_op_mode_dvm_stop+0x3b/0xd0 [iwldvm]
[172883.616518]  [<ffffffffa099de1b>] iwl_drv_stop+0x2b/0x90 [iwlwifi]
[172883.616522]  [<ffffffffa09a18b5>] iwl_pci_remove+0x25/0x30 [iwlwifi]
[172883.616526]  [<ffffffff812ce84b>] pci_device_remove+0x3b/0xc0
[172883.616530]  [<ffffffff813916bf>] __device_release_driver+0x7f/0xf0
[172883.616533]  [<ffffffff81391753>] device_release_driver+0x23/0x30
[172883.616535]  [<ffffffff8139041d>] unbind_store+0xed/0x150
[172883.616538]  [<ffffffff8138f695>] drv_attr_store+0x25/0x40
[172883.616541]  [<ffffffff8122e40a>] sysfs_kf_write+0x3a/0x50
[172883.616544]  [<ffffffff8122d97e>] kernfs_fop_write+0xee/0x180
[172883.616547]  [<ffffffff811b470a>] vfs_write+0xba/0x1e0
[172883.616550]  [<ffffffff811b462c>] ? vfs_read+0x13c/0x160
[172883.616553]  [<ffffffff811b5309>] SyS_write+0x59/0xd0
[172883.616557]  [<ffffffff81515ee9>] system_call_fastpath+0x16/0x1b
[172883.616559] ---[ end trace 397b07cf5b717cc6 ]---
[172888.935094] iwlwifi 0000:02:00.0: Failing on timeout while
stopping DMA channel 0 [0x5a5a5a5a]
[172894.368629] iwlwifi 0000:02:00.0: Failing on timeout while
stopping DMA channel 2 [0x5a5a5a5a]
[172899.814865] iwlwifi 0000:02:00.0: Fw not loaded - dropping CMD: 9c
[172899.894929] iwlwifi 0000:02:00.0: Failing on timeout while
stopping DMA channel 5 [0x5a5a5a5a]
[172905.314775] iwlwifi 0000:02:00.0: Failing on timeout while
stopping DMA channel 7 [0x5a5a5a5a]
[173057.690063] iwlwifi 0000:02:00.0: can't disable ASPM; OS doesn't
have ASPM control
[173057.690232] iwlwifi 0000:02:00.0: irq 43 for MSI/MSI-X
[173057.696886] iwlwifi 0000:02:00.0: loaded firmware version
39.31.5.1 build 35138 op_mode iwldvm
[173057.696907] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[173057.696909] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[173057.696911] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[173057.696913] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Wireless-N 1000 BGN, REV=0x6C
[173057.697009] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[173057.718196] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'

Full dmesg: http://bpaste.net/show/444976/
