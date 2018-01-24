Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:44934 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbeAXINK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 03:13:10 -0500
Received: by mail-oi0-f67.google.com with SMTP id s11so2263539oih.11
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jan 2018 00:13:10 -0800 (PST)
MIME-Version: 1.0
From: Austin Lund <austin.lund@gmail.com>
Date: Wed, 24 Jan 2018 18:13:09 +1000
Message-ID: <CAHLDD1NUF736Jnr1_CtRPfFZZOMO6bmm5T++5N2LrVtFg9-zxg@mail.gmail.com> (sfid-20180124_091315_158186_2EA6D790)
Subject: Null pointer dereference in iwlwifi when starting ad-hoc network
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Intel Linux Wireless <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get this oops in 4.15rc9 when doing the following:

# iw dev wlp2s0 set type ibss
# ip link set dev wlp2s0 up
# iw dev wlp2s0 ibss join "TEST" 2412

The oops happens after some delay (approx. 5 seconds).

Hardware is:

02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)
pci vendor code 8086:24fd
Subsystem: 8086:0050

Oops message is:

IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Trigger new scan to find an IBSS to join
wlp2s0: Creating new IBSS network, BSSID 3a:94:1d:dd:ab:09
BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
IP: iwl_trans_pcie_txq_enable+0x5e/0x440 [iwlwifi]
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP PTI
Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic btusb btrtl btbcm btintel bluetooth uvcvideo
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core
videodev media ecdh_generic crc16 joydev mousedev arc4 hid_multitouch
msr mei_wdt nouveau iwlmvm i915 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel mac80211 kvm iTCO_wdt
iTCO_vendor_support nls_iso8859_1 nls_cp437 vfat irqbypass
crct10dif_pclmul fat wmi_bmof crc32_pclmul dell_smbios_wmi iwlwifi
dell_wmi dell_rbtn ghash_clmulni_intel dell_wmi_descriptor
intel_wmi_thunderbolt dell_laptop dell_smbios_smm dell_smbios pcbc
dcdbas mxm_wmi dell_smm_hwmon ttm snd_hda_intel i2c_algo_bit
drm_kms_helper snd_hda_codec tpm_crb idma64 cfg80211 aesni_intel
snd_hda_core aes_x86_64 crypto_simd
 drm glue_helper snd_hwdep cryptd intel_cstate snd_pcm intel_rapl_perf
psmouse evdev snd_timer input_leds intel_gtt rfkill led_class mac_hid
agpgart snd rtsx_pci_ms pcspkr mei_me memstick syscopyarea i2c_hid
sysfillrect tpm_tis sysimgblt processor_thermal_device tpm_tis_core
i2c_i801 intel_lpss_pci soundcore mei fb_sys_fops shpchp
intel_pch_thermal thermal intel_lpss intel_soc_dts_iosf hid battery
tpm int3400_thermal ac wmi video acpi_thermal_rel int3403_thermal
intel_hid acpi_pad int340x_thermal_zone sparse_keymap button
sch_fq_codel crypto_user ip_tables x_tables btrfs xor zstd_decompress
zstd_compress xxhash raid6_pq rtsx_pci_sdmmc mmc_core serio_raw atkbd
libps2 crc32c_intel ahci libahci xhci_pci libata nvme xhci_hcd
nvme_core rtsx_pci scsi_mod usbcore usb_common i8042 serio
CPU: 4 PID: 371 Comm: kworker/u16:6 Not tainted 4.15.0-rc9-1-mainline #4
Hardware name: Dell Inc. Precision 5520/0R6JFH, BIOS 1.7.0 12/15/2017
Workqueue: phy0 ieee80211_iface_work [mac80211]
RIP: 0010:iwl_trans_pcie_txq_enable+0x5e/0x440 [iwlwifi]
RSP: 0018:ffffbb4702b4bb90 EFLAGS: 00010246
RAX: 0000000000000bb8 RBX: 00000000000000ff RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000177000000fa0
RBP: 0000000000000000 R08: 0000000000002710 R09: 0000000000000001
R10: 0000000000000000 R11: ffff8f45cb5aacd0 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8f45d7020018
FS:  0000000000000000(0000) GS:ffff8f45fe500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000068 CR3: 00000003f100a005 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iwl_mvm_enable_txq+0x205/0x390 [iwlmvm]
 ? ieee80211_iterate_active_interfaces_atomic+0x2e/0x40 [mac80211]
 ? iwl_mvm_add_mcast_sta+0x159/0x1e0 [iwlmvm]
 iwl_mvm_add_mcast_sta+0x159/0x1e0 [iwlmvm]
 iwl_mvm_start_ap_ibss+0xb4/0x1b0 [iwlmvm]
 __ieee80211_sta_join_ibss+0x340/0x7f0 [mac80211]
 ieee80211_sta_create_ibss+0x8c/0xf0 [mac80211]
 ieee80211_ibss_work+0x3a4/0x5a0 [mac80211]
 ? skb_dequeue+0x52/0x60
 ? ieee80211_iface_work+0xbe/0x340 [mac80211]
 process_one_work+0x1de/0x410
 worker_thread+0x2b/0x3d0
 ? process_one_work+0x410/0x410
 kthread+0x111/0x130
 ? kthread_create_worker_on_cpu+0x70/0x70
 ? do_group_exit+0x3a/0xa0
 ret_from_fork+0x3a/0x50
Code: 4c 8b ac c7 e8 7d 00 00 f0 48 0f ab 87 e8 8d 00 00 73 0d 80 3d
0a 07 03 00 00 0f 84 97 03 00 00 44 89 c7 e8 a5 88 71 e8 4d 85 e4 <49>
89 45 68 0f 84 d6 02 00 00 41 0f b6 04 24 89 44 24 04 41 0f
RIP: iwl_trans_pcie_txq_enable+0x5e/0x440 [iwlwifi] RSP: ffffbb4702b4bb90
CR2: 0000000000000068
---[ end trace 3e02d7f42559c48e ]---

GDB tells me that iwl_trans_pcie_txq_enable+0x5e is in
drivers/net/wireless/intel/iwlwifi/pcie/tx.c:

    txq->wd_timeout = msecs_to_jiffies(wdg_timeout);
