Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36156 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbdJUAyz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 20:54:55 -0400
Date: Fri, 20 Oct 2017 17:50:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Message-ID: <20171021005038.mykrmhyrhxhzyztw@merlins.org> (sfid-20171021_025500_578228_65F63815)
References: <20170603165950.GC29546@merlins.org>
 <20170816233844.qtigfurckdr44awa@merlins.org>
 <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
 <1508249157.5497.103.camel@coelho.fi>
 <20171017212319.eranorcigrmgcpyo@merlins.org>
 <1508276099.5497.122.camel@coelho.fi>
 <87infduk4b.fsf@purkki.adurom.net>
 <1508307368.5497.125.camel@coelho.fi>
 <87bml4iy40.fsf@kamboji.qca.qualcomm.com>
 <1508322176.5497.152.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508322176.5497.152.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mmmh, still seem to have a problem when I reload the module

what now?

saruman:~$ grep IWL /boot/config-4.12.10-amd64-preempt-sysrq-20171018 
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set
# CONFIG_IWLWIFI_PCIE_RTPM is not set
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEVICE_TRACING=y


[95473.132319] Intel(R) Wireless WiFi driver for Linux
[95473.132322] Copyright(c) 2003- 2015 Intel Corporation
[95473.169147] iwlwifi 0000:04:00.0: Refused to change power state, currently in D3
[95473.185656] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
[95473.185668] ------------[ cut here ]------------
[95473.185695] WARNING: CPU: 1 PID: 512 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1855 iwl_trans_pcie_grab_nic_access+0xc0/0xd7 [iwlwifi]
[95473.185696] Modules linked in: iwlwifi(+) cfg80211 rndis_host cdc_ether usbnet cmac e1000e msr rfcomm uas usb_storage ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport uvcvideo btusb videobuf2_vmalloc videobuf2_memops btrtl hid_generic videobuf2_v4l2 btbcm videobuf2_core btintel
[95473.185728]  videodev bluetooth media usbhid hid ecdh_generic joydev arc4 coretemp x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic kvm_intel rtsx_pci_ms memstick rtsx_pci_sdmmc iTCO_wdt kvm iTCO_vendor_support mei_wdt irqbypass crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel xhci_pci intel_cstate snd_hda_codec xhci_hcd snd_hda_core efi_pstore intel_rapl_perf pcspkr psmouse snd_seq snd_hwdep thinkpad_acpi snd_pcm snd_seq_device efivars i2c_i801 sg rtsx_pci nvram nvidiafb snd_timer usbcore vgastate fb_ddc snd mei_me intel_pch_thermal soundcore rfkill hwmon battery ac wmi tpm_crb tpm_tis tpm_tis_core tpm sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov
[95473.185759]  async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel input_leds aes_x86_64 crypto_simd ptp cryptd i915 glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
[95473.185770] CPU: 1 PID: 512 Comm: modprobe Tainted: G        W  OE   4.12.10-amd64-preempt-sysrq-20171018 #2
[95473.185771] Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
[95473.185772] task: ffff9c0990188000 task.stack: ffffa815102b4000
[95473.185782] RIP: 0010:iwl_trans_pcie_grab_nic_access+0xc0/0xd7 [iwlwifi]
[95473.185783] RSP: 0018:ffffa815102b7a30 EFLAGS: 00010086
[95473.185784] RAX: 000000000000003d RBX: ffff9c06d2da0018 RCX: 0000000000000007
[95473.185785] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff9c0f6144dd60
[95473.185786] RBP: ffffa815102b7a48 R08: 0000000000000002 R09: 0000000000000000
[95473.185787] R10: 0000000000000000 R11: ffffffffa8f34e67 R12: ffff9c06d2da8f20
[95473.185788] R13: ffffa815102b7a68 R14: ffff9c0f3c62e0a0 R15: 0000000000000000
[95473.185789] FS:  00007fa1d9ede700(0000) GS:ffff9c0f61440000(0000) knlGS:0000000000000000
[95473.185790] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[95473.185792] CR2: 00007fcbb5ecf5dc CR3: 0000000361d10000 CR4: 00000000003406e0
[95473.185793] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[95473.185794] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[95473.185795] Call Trace:
[95473.185804]  iwl_trans_pcie_alloc+0x2f2/0x7ac [iwlwifi]
[95473.185807]  ? mutex_unlock+0x22/0x34
[95473.185817]  iwl_pci_probe+0x21/0x2ce [iwlwifi]
[95473.185820]  ? _raw_spin_unlock_irqrestore+0x14/0x24
[95473.185822]  ? __pm_runtime_resume+0x4d/0x58
[95473.185824]  local_pci_probe+0x3d/0x80
[95473.185827]  pci_device_probe+0x10c/0x13b
[95473.185829]  driver_probe_device+0x19b/0x3f6
[95473.185831]  __driver_attach+0x80/0xdb
[95473.185834]  ? driver_probe_device+0x3f6/0x3f6
[95473.185835]  bus_for_each_dev+0x5d/0x85
[95473.185838]  driver_attach+0x1e/0x20
[95473.185840]  bus_add_driver+0xfd/0x239
[95473.185842]  driver_register+0x88/0xbf
[95473.185844]  ? 0xffffffffc0795000
[95473.185845]  __pci_register_driver+0x4c/0x4e
[95473.185853]  iwl_pci_register_driver+0x24/0x3b [iwlwifi]
[95473.185854]  ? 0xffffffffc0795000
[95473.185862]  iwl_drv_init+0x65/0x67 [iwlwifi]
[95473.185864]  do_one_initcall+0x9f/0x156
[95473.185866]  ? slab_pre_alloc_hook+0x1a/0x44
[95473.185868]  ? slab_post_alloc_hook.isra.47+0xe/0x1d
[95473.185870]  ? kmem_cache_alloc_trace+0xec/0xfc
[95473.185873]  do_init_module+0x5f/0x1f7
[95473.185874]  load_module+0x1e53/0x257a
[95473.185876]  ? strstarts+0x28/0x28
[95473.185879]  SYSC_finit_module+0x8c/0xb9
[95473.185880]  ? SYSC_finit_module+0x8c/0xb9
[95473.185882]  SyS_finit_module+0xe/0x10
[95473.185884]  do_syscall_64+0x6b/0x7d
[95473.185886]  entry_SYSCALL64_slow_path+0x25/0x25
[95473.185887] RIP: 0033:0x7fa1d9a4c119
[95473.185888] RSP: 002b:00007ffde7ac7c38 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[95473.185889] RAX: ffffffffffffffda RBX: 0000560413f35370 RCX: 00007fa1d9a4c119
[95473.185890] RDX: 0000000000000000 RSI: 00005604139b2246 RDI: 0000000000000004
[95473.185891] RBP: 00005604139b2246 R08: 0000000000000000 R09: 0000000000000000
[95473.185892] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
[95473.185893] R13: 0000560413f37690 R14: 0000000000040000 R15: 0000000000040000
[95473.185896] Code: 80 3d 0a 9a 01 00 00 75 24 48 89 df be 24 00 00 00 c6 05 f9 99 01 00 01 e8 da 38 ff ff 48 c7 c7 7a 10 88 c0 89 c6 e8 6f e5 8c e7 <0f> ff 49 8b 75 00 4c 89 e7 e8 1e cb e8 e7 31 c0 5b 41 5c 41 5d 
[95473.185916] ---[ end trace 6b63fed5320656d4 ]---
[95473.185963] iwlwifi 0000:04:00.0: pci_enable_msi failed - -22
[95473.186841] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
[95473.186844] iwlwifi 0000:04:00.0: Falling back to user helper
[95473.187284] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
[95473.187287] iwlwifi 0000:04:00.0: Falling back to user helper
[95473.187629] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
[95473.187632] iwlwifi 0000:04:00.0: Falling back to user helper
[95473.189268] iwlwifi 0000:04:00.0: capa flags index 3 larger than supported by driver
[95473.190270] iwlwifi 0000:04:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm
[95473.929483] e1000e 0000:00:1f.6 eth0: Error reading PHY register
[95473.934735] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
[95473.936779] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95473.936877] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[95474.171371] EXT4-fs (sda1): re-mounted. Opts: stripe=128,data=ordered,commit=600
[95474.824009] e1000e 0000:00:1f.6 eth0: Error reading PHY register
[95474.991769] iwlwifi 0000:04:00.0: Could not load the [0] uCode section
[95474.991809] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
[95475.624341] e1000e 0000:00:1f.6 eth0: Error reading PHY register
[95476.424545] e1000e 0000:00:1f.6 eth0: Error reading PHY register
[95477.223796] e1000e 0000:00:1f.6 eth0: Error reading PHY register
[95477.397905] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[95477.397933] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
