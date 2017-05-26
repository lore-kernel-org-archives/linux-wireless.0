Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46960 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946757AbdEZDPH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 23:15:07 -0400
Date: Thu, 25 May 2017 19:48:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-wireless@vger.kernel.org
Message-ID: <20170526024826.3qjx7pe3kz44klk3@merlins.org> (sfid-20170526_051525_642258_22956BF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: After upgrading to 4.11.1, wifi driver refuses to load after being
 unloaded once.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Howdy,

First I tried ilw@linux.intel.com which is now dead
Then linuxwifi@intel.com, but no reply.
So I'm trying here next.

Any ideas?
Sadly before that I was on 4.4 due to bugs in the NVME ACPI suspend
support that only got fixed in 4.11, so it's a big jump, my apologies
for that.
That said, I've used this wireless driver for 1.5 years with that
firmware without issues before that (kernel 4.4).


When it works, it loads with
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: loaded firmware version 19.277230.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled


3 different ways it's failing now:
1) CPU: 3 PID: 9349 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)

2) 
iwlwifi 0000:04:00.0: loaded firmware version 19.277230.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: Could not load the [0] uCode section
iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5  <<<< this

3) iwlwifi 0000:04:00.0: Refused to change power state, currently in D3



Long details below:

I noted that https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
says I should use iwlwifi-8000-ucode-16.242414.0.tgz
which only ships iwlwifi-8000C-16.ucode while I have iwlwifi-8000C-19.ucode

Either way, I just had to reboot my system as the only way for the driver
to work again. Once it's loaded, it works, but it's not ok that I have
to reboot to get it working again after a suspend/resume module
load/unload.

Is it a known problem, and is there a fix?

Before the reboot, trying to load the module, gave this:
[0mIntel(R) Wireless WiFi driver for Linux
[0mCopyright(c) 2003- 2015 Intel Corporation
[0m[1m------------[ cut here ]------------[0m
[0m[33mWARNING[0m[1m: CPU: 3 PID: 9349 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi][0m
[0m[1mTimeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)[0m
[0m[33mModules linked in[0m[1m: iwlwifi(+) cfg80211 hfs ntfs msdos jfs reiserfs e1000e msr cmac rpcsec_gss_krb5 nfsv4 dns_resolver ccm ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle rfcomm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport uvcvideo hid_generic videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core[0m
[0m[1m btusb videodev btrtl btbcm btintel media bluetooth usbhid hid joydev arc4 coretemp snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm snd_hda_intel irqbypass snd_hda_codec crct10dif_pclmul crc32_pclmul snd_hda_core iTCO_wdt snd_hwdep rtsx_pci_ms snd_pcm ghash_clmulni_intel efi_pstore mei_wdt memstick rtsx_pci_sdmmc iTCO_vendor_support intel_cstate snd_seq nouveau snd_seq_device mxm_wmi intel_rapl_perf thinkpad_acpi efivars xhci_pci snd_timer psmouse pcspkr ttm nvram xhci_hcd nvidiafb i2c_i801 rtsx_pci vgastate snd sg usbcore fb_ddc soundcore mei_me intel_pch_thermal rfkill hwmon ac battery tpm_crb tpm_tis wmi tpm_tis_core tpm sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log[0m
[0m[33m dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel aes_x86_64 crypto_simd ptp input_leds cryptd i915 glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded[0m[1m: cfg80211][0m
[0m[33mCPU[0m[1m: 3 PID: 9349 Comm: modprobe Tainted: G        W  OE   4.11.1-amd64-preempt-sysrq-20170406 #4[0m
[0m[33mHardware name[0m[1m: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015[0m
[0m[1mCall Trace:[0m
[0m[1m dump_stack+0x61/0x7d[0m
[0m[1m __warn+0xc2/0xdd[0m
[0m[1m warn_slowpath_fmt+0x5a/0x76[0m
[0m[1m ? iwl_read32+0x1f/0x7f [iwlwifi][0m
[0m[1m iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi][0m
[0m[1m iwl_trans_pcie_alloc+0x2fb/0x7d4 [iwlwifi][0m
[0m[1m iwl_pci_probe+0x30/0x301 [iwlwifi][0m
[0m[1m ? _raw_spin_unlock_irqrestore+0x14/0x24[0m
[0m[1m ? __pm_runtime_resume+0x4d/0x58[0m
[0m[1m local_pci_probe+0x3d/0x80[0m
[0m[1m pci_device_probe+0xf9/0x13c[0m
[0m[1m driver_probe_device+0x19d/0x3f2[0m
[0m[1m __driver_attach+0x80/0xdb[0m
[0m[1m ? driver_probe_device+0x3f2/0x3f2[0m
[0m[1m bus_for_each_dev+0x69/0xa7[0m
[0m[1m driver_attach+0x1e/0x20[0m
[0m[1m bus_add_driver+0xfd/0x239[0m
[0m[1m driver_register+0x88/0xbf[0m
[0m[1m ? 0xffffffffc0ade000[0m
[0m[1m __pci_register_driver+0x4c/0x4e[0m
[0m[1m iwl_pci_register_driver+0x24/0x3b [iwlwifi][0m
[0m[1m ? 0xffffffffc0ade000[0m
[0m[1m iwl_drv_init+0x65/0x67 [iwlwifi][0m
[0m[1m do_one_initcall+0x9f/0x160[0m
[0m[1m ? slab_pre_alloc_hook+0x1a/0x44[0m
[0m[1m ? slab_post_alloc_hook.isra.47+0xe/0x1d[0m
[0m[1m ? kmem_cache_alloc_trace+0xec/0xfc[0m
[0m[1m do_init_module+0x5f/0x1f7[0m
[0m[1m load_module+0x1e6e/0x2595[0m
[0m[1m ? strstarts+0x28/0x28[0m
[0m[1m ? vfs_read+0xb5/0xdc[0m
[0m[1m SYSC_finit_module+0xa2/0xe6[0m
[0m[1m ? SYSC_finit_module+0xa2/0xe6[0m
[0m[1m SyS_finit_module+0xe/0x10[0m
[0m[1m do_syscall_64+0x6b/0x7d[0m
[0m[1m entry_SYSCALL64_slow_path+0x25/0x25[0m
[0m[33mRIP[0m[1m: 0033:0x7fb53c159119[0m
[0m[33mRSP[0m[1m: 002b:00007ffc09e768c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139[0m
[0m[33mRAX[0m[1m: ffffffffffffffda RBX: 00005575b423a390 RCX: 00007fb53c159119[0m
[0m[33mRDX[0m[1m: 0000000000000000 RSI: 00005575b3464246 RDI: 0000000000000004[0m
[0m[33mRBP[0m[1m: 00005575b3464246 R08: 0000000000000000 R09: 0000000000000000[0m
[0m[33mR10[0m[1m: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000[0m
[0m[33mR13[0m[1m: 00005575b423c650 R14: 0000000000040000 R15: 0000000000040000[0m
[0m[1m---[ end trace 09ee15383e01988c ]---[0m
[0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
[0m[32m[89427.433471] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.436126] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-27.ucode failed with error -2
[0m[32m[89427.436136] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.437043] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-26.ucode failed with error -2
[0m[32m[89427.437050] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.437832] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-25.ucode failed with error -2
[0m[32m[89427.437841] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.438477] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-24.ucode failed with error -2
[0m[32m[89427.438482] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.439181] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-23.ucode failed with error -2
[0m[32m[89427.439187] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.439928] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-22.ucode failed with error -2
[0m[32m[89427.439936] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.440562] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-21.ucode failed with error -2
[0m[32m[89427.440583] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.441053] [0m[33miwlwifi 0000:04:00.0[0m[1m: Direct firmware load for iwlwifi-8000C-20.ucode failed with error -2
[0m[32m[89427.441058] [0m[33miwlwifi 0000:04:00.0[0m[1m: Falling back to user helper
[0m[32m[89427.448083] [0m[33miwlwifi 0000:04:00.0[0m: loaded firmware version 19.277230.0 op_mode iwlmvm
[0m[33miwlwifi 0000:04:00.0[0m: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
[0m[33miwlwifi 0000:04:00.0[0m: L1 Enabled - LTR Enabled
[0m[33miwlwifi 0000:04:00.0[0m: L1 Enabled - LTR Enabled
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
[0m[33mcma[0m: cma_alloc: alloc failed, req-size: 4 pages, ret: -12
[0m[33miwlwifi 0000:04:00.0[0m[31m: Could not load the [0] uCode section
[0m[33miwlwifi 0000:04:00.0[0m[31m: Failed to start INIT ucode: -5
[0m[33miwlwifi 0000:04:00.0[0m[31m: Failed to run INIT ucode: -5
[0m[33miwlwifi 0000:04:00.0[0m: L1 Enabled - LTR Enabled

Thanks,
Marc

----- End forwarded message -----

----- Forwarded message from Marc MERLIN <marc@merlins.org> -----

Date: Wed, 24 May 2017 12:34:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: linuxwifi@intel.com
Subject: Re: After upgrading to 4.11.1, wifi driver refused to load after being unloaded once.
X-URL: http://marc.merlins.org/
User-Agent: NeoMutt/20160916 (1.7.0)

Now, I'm getting this:
iwlwifi 0000:04:00.0: Refused to change power state, currently in D3
This is bad, I can't reboot every time I come out of sleep just for wifi
to work again.

Is there a workaround? This is bad enough that I'm about to get another
wifi card to plug into USB.


Intel(R) Wireless WiFi driver for Linux
Copyright(c) 2003- 2015 Intel Corporation
iwlwifi 0000:04:00.0: Refused to change power state, currently in D3
------------[ cut here ]------------
WARNING: CPU: 7 PID: 20712 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
Modules linked in: iwlwifi(+) cfg80211 msr cmac uas usb_storage rpcsec_gss_krb5 nfsv4 dns_resolver ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ccm rfcomm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport uvcvideo btusb videobuf2_vmalloc btrtl videobuf2_memops btbcm videobuf2_v4l2 btintel hid_generic videobuf2_core
 videodev bluetooth usbhid media hid joydev arc4 coretemp x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_intel intel_cstate rtsx_pci_ms iTCO_wdt iTCO_vendor_support snd_hda_codec rtsx_pci_sdmmc memstick mei_wdt snd_hda_core nouveau snd_seq snd_hwdep mxm_wmi intel_rapl_perf efi_pstore snd_pcm snd_seq_device xhci_pci pcspkr psmouse thinkpad_acpi efivars xhci_hcd nvram i2c_i801 snd_timer ttm rtsx_pci sg nvidiafb usbcore snd vgastate fb_ddc mei_me intel_pch_thermal soundcore rfkill wmi hwmon battery ac tpm_crb tpm_tis tpm_tis_core tpm sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov
 async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel aes_x86_64 crypto_simd input_leds ptp cryptd i915 glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
CPU: 7 PID: 20712 Comm: modprobe Tainted: G        W  OE   4.11.1-amd64-preempt-sysrq-20170406 #4
Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
Call Trace:
 dump_stack+0x61/0x7d
 __warn+0xc2/0xdd
 warn_slowpath_fmt+0x5a/0x76
 ? iwl_read32+0x1f/0x7f [iwlwifi]
 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
 iwl_trans_pcie_alloc+0x2fb/0x7d4 [iwlwifi]
 iwl_pci_probe+0x30/0x301 [iwlwifi]
 ? _raw_spin_unlock_irqrestore+0x14/0x24
 ? __pm_runtime_resume+0x4d/0x58
 local_pci_probe+0x3d/0x80
 pci_device_probe+0xf9/0x13c
 driver_probe_device+0x19d/0x3f2
 __driver_attach+0x80/0xdb
 ? driver_probe_device+0x3f2/0x3f2
 bus_for_each_dev+0x69/0xa7
 driver_attach+0x1e/0x20
 bus_add_driver+0xfd/0x239
 driver_register+0x88/0xbf
 ? 0xffffffffc088e000
 __pci_register_driver+0x4c/0x4e
 iwl_pci_register_driver+0x24/0x3b [iwlwifi]
 ? 0xffffffffc088e000
 iwl_drv_init+0x65/0x67 [iwlwifi]
 do_one_initcall+0x9f/0x160
 ? slab_pre_alloc_hook+0x1a/0x44
 ? slab_post_alloc_hook.isra.47+0xe/0x1d
 ? kmem_cache_alloc_trace+0xec/0xfc
 do_init_module+0x5f/0x1f7
 load_module+0x1e6e/0x2595
 ? strstarts+0x28/0x28
 ? vfs_read+0xb5/0xdc
 SYSC_finit_module+0xa2/0xe6
 ? SYSC_finit_module+0xa2/0xe6
 SyS_finit_module+0xe/0x10
 do_syscall_64+0x6b/0x7d
 entry_SYSCALL64_slow_path+0x25/0x25



----- Forwarded message from Marc MERLIN <marc@merlins.org> -----

And just in case it helps, another one:
iwlwifi 0000:04:00.0: loaded firmware version 19.277230.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: Could not load the [0] uCode section
iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5

full log:
Intel(R) Wireless WiFi driver for Linux
Copyright(c) 2003- 2015 Intel Corporation
------------[ cut here ]------------
WARNING: CPU: 1 PID: 26389 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
Modules linked in: iwlwifi(+) cfg80211 msr cmac uas usb_storage rpcsec_gss_krb5 nfsv4 dns_resolver ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ccm rfcomm ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport uvcvideo btusb videobuf2_vmalloc btrtl videobuf2_memops btbcm videobuf2_v4l2 btintel hid_generic videobuf2_core
 videodev bluetooth usbhid media hid joydev arc4 coretemp x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_intel intel_cstate rtsx_pci_ms iTCO_wdt iTCO_vendor_support snd_hda_codec rtsx_pci_sdmmc memstick mei_wdt snd_hda_core nouveau snd_seq snd_hwdep mxm_wmi intel_rapl_perf efi_pstore snd_pcm snd_seq_device xhci_pci pcspkr psmouse thinkpad_acpi efivars xhci_hcd nvram i2c_i801 snd_timer ttm rtsx_pci sg nvidiafb usbcore snd vgastate fb_ddc mei_me intel_pch_thermal soundcore rfkill wmi hwmon battery ac tpm_crb tpm_tis tpm_tis_core tpm sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov
 async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel aes_x86_64 crypto_simd input_leds ptp cryptd i915 glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
CPU: 1 PID: 26389 Comm: modprobe Tainted: G        W  OE   4.11.1-amd64-preempt-sysrq-20170406 #4
Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
Call Trace:
 dump_stack+0x61/0x7d
 __warn+0xc2/0xdd
 warn_slowpath_fmt+0x5a/0x76
 ? iwl_read32+0x1f/0x7f [iwlwifi]
 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
 iwl_trans_pcie_alloc+0x2fb/0x7d4 [iwlwifi]
 iwl_pci_probe+0x30/0x301 [iwlwifi]
 ? _raw_spin_unlock_irqrestore+0x14/0x24
 ? __pm_runtime_resume+0x4d/0x58
 local_pci_probe+0x3d/0x80
 pci_device_probe+0xf9/0x13c
 driver_probe_device+0x19d/0x3f2
 __driver_attach+0x80/0xdb
 ? driver_probe_device+0x3f2/0x3f2
 bus_for_each_dev+0x69/0xa7
 driver_attach+0x1e/0x20
 bus_add_driver+0xfd/0x239
 driver_register+0x88/0xbf
 ? 0xffffffffc053a000
 __pci_register_driver+0x4c/0x4e
 iwl_pci_register_driver+0x24/0x3b [iwlwifi]
 ? 0xffffffffc053a000
 iwl_drv_init+0x65/0x67 [iwlwifi]
 do_one_initcall+0x9f/0x160
 ? slab_pre_alloc_hook+0x1a/0x44
 ? slab_post_alloc_hook.isra.47+0xe/0x1d
 ? kmem_cache_alloc_trace+0xec/0xfc
 do_init_module+0x5f/0x1f7
 load_module+0x1e6e/0x2595
 ? strstarts+0x28/0x28
 ? vfs_read+0xb5/0xdc
 SYSC_finit_module+0xa2/0xe6
 ? SYSC_finit_module+0xa2/0xe6
 SyS_finit_module+0xe/0x10
 do_syscall_64+0x6b/0x7d
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f63b112c119
RSP: 002b:00007ffc72003288 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 0000562cda31c390 RCX: 00007f63b112c119
RDX: 0000000000000000 RSI: 0000562cd9ce1246 RDI: 0000000000000004
RBP: 0000562cd9ce1246 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 0000562cda31e650 R14: 0000000000040000 R15: 0000000000040000
---[ end trace b88c5bce363ce978 ]---
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-27.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-26.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-25.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-24.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-23.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-22.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-21.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-20.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: loaded firmware version 19.277230.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: Could not load the [0] uCode section
iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled



----- End forwarded message -----

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
