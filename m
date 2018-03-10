Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56715 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeCJGJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 01:09:47 -0500
Date: Fri, 9 Mar 2018 22:09:39 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com,
        linuxwifi@intel.com
Message-ID: <20180310060939.v4nborjsb7b3kxae@merlins.org> (sfid-20180310_071028_602112_683340AE)
References: <20180305062244.oqacoz4y2qiei2tf@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180305062244.oqacoz4y2qiei2tf@merlins.org>
Subject: Re: iwlwifi still randomly fails to restore from S3 sleep (4.15.6
 now): 0010:iwl_trans_pcie_grab_nic_access+0xc3/0xd8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any suggestions or other place/list I should report this bug?

Thanks,
Marc

On Sun, Mar 04, 2018 at 10:22:44PM -0800, Marc MERLIN wrote:
> Howdy,
> 
> Info on my card:
> [   14.583443] iwlwifi 0000:04:00.0: runtime IRQ mapping not provided by arch
> [   14.583755] pcieport 0000:00:1c.2: enabling bus mastering
> [   14.583838] iwlwifi 0000:04:00.0: enabling device (0000 -> 0002)
> [   14.587289] iwlwifi 0000:04:00.0: enabling bus mastering
> [   14.598229] iwlwifi 0000:04:00.0: loaded firmware version 34.0.1 op_mode iwlmvm
> [   14.637531] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> [   14.735797] iwlwifi 0000:04:00.0: base HW address: a4:34:d9:a2:90:d1
> 
> Restoring from sleep and reloading the driver fails:
> [57868.115706] xhci_hcd 0000:00:14.0: Cannot set link state.
> [57868.115719] usb usb2-port1: cannot disable (err = -32)
> [57868.923024] Intel(R) Wireless WiFi driver for Linux
> [57868.923028] Copyright(c) 2003- 2015 Intel Corporation
> [57868.939749] pcieport 0000:00:1c.2: Intel SPT PCH root port ACS workaround enabled
> [57868.939769] iwlwifi 0000:04:00.0: runtime IRQ mapping not provided by arch
> [57868.981713] iwlwifi 0000:04:00.0: iwlwifi transaction failed, dumping registers
> [57868.981717] iwlwifi 0000:04:00.0: iwlwifi device config registers:
> [57868.981748] iwlwifi 0000:04:00.0: 00000000: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
> [57868.981750] iwlwifi 0000:04:00.0: 00000020: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
> [57868.981751] iwlwifi 0000:04:00.0: iwlwifi device memory mapped registers:
> [57868.981763] iwlwifi 0000:04:00.0: 00000000: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
> [57868.981764] iwlwifi 0000:04:00.0: 00000020: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
> [57868.982071] iwlwifi 0000:04:00.0: iwlwifi parent port (0000:00:1c.2) config registers:
> [57868.982084] iwlwifi 0000:00:1c.2: 00000000: a1128086 00100007 060400f1 00810000 00000000 00000000 00040400 200000f0
> [57868.982085] iwlwifi 0000:00:1c.2: 00000020: e4d0e4d0 0001fff1 00000000 00000000 00000000 00000040 00000000 000003ff
> [57868.982087] iwlwifi 0000:04:00.0: iwlwifi root port (0000:00:1c.2) AER cap structure:
> [57868.982095] iwlwifi 0000:00:1c.2: 00000000: 14010001 00000000 00000000 00060011 00000000 00002000 00000000 00000000
> [57868.982097] iwlwifi 0000:00:1c.2: 00000020: 00000000 00000000 00000000 00000000 00000000 00000000
> [57868.982098] ------------[ cut here ]------------
> [57868.982099] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
> [57868.982141] WARNING: CPU: 7 PID: 11305 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1973 iwl_trans_pcie_grab_nic_access+0xc3/0xd8 [iwlwifi]
> [57868.982142] Modules linked in: iwlwifi(+) cfg80211 ccm ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables rfcomm bnep pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat bbswitch(OE) configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport btusb uvcvideo hid_generic btrtl btbcm videobuf2_vmalloc btintel videobuf2_memops videobuf2_v4l2 videobuf2_core bluetooth videodev usbhid media hid ecdh_generic
> [57868.982170]  joydev arc4 coretemp x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel rtsx_pci_ms ghash_clmulni_intel iTCO_wdt memstick rtsx_pci_sdmmc iTCO_vendor_support intel_cstate intel_wmi_thunderbolt wmi_bmof snd_hda_codec snd_hda_core thinkpad_acpi snd_hwdep intel_rapl_perf nvram snd_pcm efi_pstore snd_seq snd_seq_device psmouse xhci_pci snd_timer xhci_hcd pcspkr snd efivars nvidiafb soundcore rtsx_pci i2c_i801 rfkill hwmon ac usbcore battery vgastate fb_ddc sg mei_me intel_pch_thermal wmi sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64
> [57868.982197]  blowfish_common bcache crc32c_intel aesni_intel i915 aes_x86_64 crypto_simd input_leds cryptd ptp glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
> [57868.982205] CPU: 7 PID: 11305 Comm: modprobe Tainted: G        W  OE    4.15.6-amd64-preempt-sysrq-20171018 #3
> [57868.982206] Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET95W (2.21 ) 12/13/2017
> [57868.982216] RIP: 0010:iwl_trans_pcie_grab_nic_access+0xc3/0xd8 [iwlwifi]
> [57868.982217] RSP: 0018:ffffa07e149d7ac0 EFLAGS: 00010096
> [57868.982218] RAX: 0000000000000000 RBX: ffff8b0497ff0018 RCX: 0000000000000007
> [57868.982219] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8b0d0f5d6610
> [57868.982220] RBP: ffff8b0497ff8f00 R08: 0000000000000002 R09: 0000000000000000
> [57868.982221] R10: 00000000000000e2 R11: ffffffffaf7c6d67 R12: ffffa07e149d7ae8
> [57868.982221] R13: ffff8b0cea6820a0 R14: 0000000000000024 R15: ffffffffc06c7540
> [57868.982223] FS:  00007f9273dd4540(0000) GS:ffff8b0d0f5c0000(0000) knlGS:0000000000000000
> [57868.982224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [57868.982225] CR2: 00007ffceaa348b8 CR3: 000000018a48e001 CR4: 00000000003606e0
> [57868.982226] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [57868.982227] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [57868.982227] Call Trace:
> [57868.982239]  iwl_trans_pcie_alloc+0x34d/0x892 [iwlwifi]
> [57868.982243]  ? __kernfs_new_node+0xa7/0x110
> [57868.982252]  iwl_pci_probe+0x18/0x162 [iwlwifi]
> [57868.982255]  local_pci_probe+0x39/0x7a
> [57868.982257]  pci_device_probe+0x114/0x180
> [57868.982260]  driver_probe_device+0x1c1/0x421
> [57868.982262]  __driver_attach+0x7b/0xd6
> [57868.982264]  ? driver_probe_device+0x421/0x421
> [57868.982266]  bus_for_each_dev+0x64/0x9f
> [57868.982268]  bus_add_driver+0xf7/0x229
> [57868.982269]  driver_register+0x82/0xb4
> [57868.982271]  ? 0xffffffffc056b000
> [57868.982279]  iwl_pci_register_driver+0x20/0x36 [iwlwifi]
> [57868.982281]  ? 0xffffffffc056b000
> [57868.982283]  do_one_initcall+0x99/0x149
> [57868.982284]  ? ___cache_free+0x1f4/0x24f
> [57868.982286]  ? slab_pre_alloc_hook+0x15/0x3c
> [57868.982287]  ? slab_post_alloc_hook.isra.44+0xa/0x1a
> [57868.982288]  ? kmem_cache_alloc_trace+0xde/0xed
> [57868.982290]  do_init_module+0x5b/0x205
> [57868.982292]  load_module+0x1e0b/0x252e
> [57868.982294]  ? trace_event_get_offsets_module_free+0x2b/0x2b
> [57868.982296]  ? vfs_read+0xaa/0xcf
> [57868.982299]  ? SYSC_finit_module+0x94/0xda
> [57868.982300]  SYSC_finit_module+0x94/0xda
> [57868.982302]  do_syscall_64+0x72/0x81
> [57868.982305]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [57868.982306] RIP: 0033:0x7f9273930e19
> [57868.982307] RSP: 002b:00007ffceaa379b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000139
> [57868.982309] RAX: ffffffffffffffda RBX: 000055f65eb7bcf0 RCX: 00007f9273930e19
> [57868.982309] RDX: 0000000000000000 RSI: 000055f65d873246 RDI: 0000000000000003
> [57868.982310] RBP: 000055f65d873246 R08: 0000000000000000 R09: 0000000000000000
> [57868.982311] R10: 0000000000000003 R11: 0000000000000206 R12: 0000000000000000
> [57868.982312] R13: 000055f65eb7be20 R14: 0000000000040000 R15: 0000000000040000
> [57868.982314] Code: 80 3d 56 7e 02 00 00 75 24 48 89 df be 24 00 00 00 c6 05 45 7e 02 00 01 e8 cb 3a ff ff 48 c7 c7 58 72 6b c0 89 c6 e8 24 42 9c ed <0f> 0b 49 8b 34 24 48 89 ef e8 0c d4 0c ee 31 c0 5b 5d 41 5c c3 
> [57868.982333] ---[ end trace 83d180dfcc39c343 ]---
> [57868.987265] iwlwifi 0000:04:00.0: loaded firmware version 34.0.1 op_mode iwlmvm
> [57869.010920] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
> [57869.698820] iwlwifi 0000:04:00.0: Could not load the [0] uCode section
> [57869.698828] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
> [57871.595681] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
