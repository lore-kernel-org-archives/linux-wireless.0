Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60352 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758303AbdJQJqK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 05:46:10 -0400
Date: Tue, 17 Oct 2017 02:44:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Message-ID: <20171017094440.25tpkoeyfm6q2lqw@merlins.org> (sfid-20171017_114620_060264_D12B9ABF)
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
 <1496396575.9478.54.camel@coelho.fi>
 <20170603165950.GC29546@merlins.org>
 <20170816233844.qtigfurckdr44awa@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170816233844.qtigfurckdr44awa@merlins.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was broken in 4.11, still broken in 4.12. This is crippling, I'm not
running linux so that I have to reboot it to reload an intel wireless
driver :-/

I currently have:
-rw-rw-r-- 1 merlin merlin 1745176 Jun 18  2015 /lib/firmware/iwlwifi-8000C-13.ucode
-rw-r--r-- 1 root   root   2345768 Dec  6  2015 /lib/firmware/iwlwifi-8000C-14.ucode
-rw-r--r-- 1 root   root   2351636 Dec  6  2015 /lib/firmware/iwlwifi-8000C-16.ucode
-rw-r--r-- 1 root   root   2390004 Feb 12  2016 /lib/firmware/iwlwifi-8000C-17.ucode
-rw-r--r-- 1 merlin merlin 2382972 Feb 25  2016 /lib/firmware/iwlwifi-8000C-19.ucode
-rw-r--r-- 1 merlin merlin 2227284 Jun  3 09:46 /lib/firmware/iwlwifi-8000C-27.ucode

https://www.intel.com/content/www/us/en/support/articles/000005511/network-and-i-o/wireless-networking.html
still says to install
iwlwifi-8000-ucode-25.30.13.0.tgz
which in turn installs
iwlwifi-8000C-13.ucode
while the driver looks for iwlwifi-8000C-30.ucode iwlwifi-8000C-29.ucode iwlwifi-8000C-28.ucode
before loading iwlwifi-8000C-27.ucode

so, what do I do?

Intel(R) Wireless WiFi driver for Linux
Copyright(c) 2003- 2015 Intel Corporation
iwlwifi 0000:04:00.0: Refused to change power state, currently in D3
Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 22824 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1855 iwl_trans_pcie_grab_nic_access+0xc0/0xd7 [iwlwifi] Modules linked in: iwlwifi(+) cfg80211 msr cmac tun ccm rfcomm ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_ ntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_t boxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_po cuse ecryptfs ppdev parport_pc lp parport uvcvideo btusb videobuf2_vmalloc btrtl hid_generic btbcm videobuf2_memops btintel videobuf2_v4l2 videobuf2_cor ic joydev arc4 rtsx_pci_ms iTCO_wdt memstick iTCO_vendor_support rtsx_pci_sdmmc snd_hda_codec_realtek snd_hda_codec_generic mei_wdt coretemp x86_pkg_temp_t kvm snd_hda_codec snd_hda_core irqbypass crct10dif_pclmul crc32_pclmul snd_hwdep xhci_pci efi_pstore snd_seq ghash_clmulni_intel xhci_hcd intel_cstate nv pi psmouse vgastate intel_rapl_perf efivars i2c_i801 rtsx_pci sg nvram snd_timer fb_ddc usbcore snd mei_me intel_pch_thermal soundcore rfkill tpm_crb hwm ipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel aes_x86_64 input_leds ptp crypto_simd i915 cryptd glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
CPU: 1 PID: 22824 Comm: modprobe Tainted: G        W  OE   4.12.10-amd64-preempt-sysrq-20170406 #1
Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
task: ffff8ba2de876000 task.stack: ffffa0f213c34000
RIP: 0010:iwl_trans_pcie_grab_nic_access+0xc0/0xd7 [iwlwifi]
RSP: 0018:ffffa0f213c37a30 EFLAGS: 00010086
RAX: 000000000000003d RBX: ffff8ba2bd560018 RCX: 0000000000000007
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8ba52144dd60
RBP: ffffa0f213c37a48 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffffa1f34e68 R12: ffff8ba2bd568f20
R13: ffffa0f213c37a68 R14: ffff8ba4fc62e0a0 R15: 0000000000000000
FS:  00007ff1c9816700(0000) GS:ffff8ba521440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056441582aed8 CR3: 00000001b59e8000 CR4: 00000000003406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iwl_trans_pcie_alloc+0x2f2/0x7ac [iwlwifi]
 ? mutex_unlock+0x22/0x34
 iwl_pci_probe+0x21/0x2ce [iwlwifi]
 ? _raw_spin_unlock_irqrestore+0x14/0x24
 ? __pm_runtime_resume+0x4d/0x58
 local_pci_probe+0x3d/0x80
 pci_device_probe+0x10c/0x13b
 driver_probe_device+0x19b/0x3f6
 __driver_attach+0x80/0xdb
 ? driver_probe_device+0x3f6/0x3f6
 bus_for_each_dev+0x5d/0x85
 driver_attach+0x1e/0x20
 bus_add_driver+0xfd/0x239
 driver_register+0x88/0xbf
 ? 0xffffffffc0940000
 __pci_register_driver+0x4c/0x4e
 iwl_pci_register_driver+0x24/0x3b [iwlwifi]
 ? 0xffffffffc0940000
 iwl_drv_init+0x65/0x67 [iwlwifi]
 do_one_initcall+0x9f/0x156
 ? slab_pre_alloc_hook+0x1a/0x44
 ? slab_post_alloc_hook.isra.47+0xe/0x1d
 ? kmem_cache_alloc_trace+0xec/0xfc
 do_init_module+0x5f/0x1f7
 load_module+0x1e53/0x257a
 ? strstarts+0x28/0x28
 SYSC_finit_module+0x8c/0xb9
 ? SYSC_finit_module+0x8c/0xb9
 SyS_finit_module+0xe/0x10
 do_syscall_64+0x6b/0x7d
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7ff1c9384119
RSP: 002b:00007fff00565518 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 00005619e9a47370 RCX: 00007ff1c9384119
RDX: 0000000000000000 RSI: 00005619e8c63246 RDI: 0000000000000004
RBP: 00005619e8c63246 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 00005619e9a49690 R14: 0000000000040000 R15: 0000000000040000
Code: 80 3d b7 98 01 00 00 75 24 48 89 df be 24 00 00 00 c6 05 a6 98 01 00 01 e8 87 37 ff ff 48 c7 c7 6f a1 8b c0 89 c6 e8 1c 54 89 e0 <0f> ff 49 8b 75 00 4c 89 e7 e8 cb 39 e5 e0 31 c0 5b 41 5c 41 5d 
---[ end trace a54fb45ab58794f3 ]---
iwlwifi 0000:04:00.0: pci_enable_msi failed - -22
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
iwlwifi 0000:04:00.0: Falling back to user helper
iwlwifi 0000:04:00.0: capa flags index 3 larger than supported by driver
iwlwifi 0000:04:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm
iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
iwlwifi 0000:04:00.0: Could not load the [0] uCode section
iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled


On Wed, Aug 16, 2017 at 04:38:44PM -0700, Marc MERLIN wrote:
> On Sat, Jun 03, 2017 at 09:59:50AM -0700, Marc MERLIN wrote:
> > On Fri, Jun 02, 2017 at 12:42:55PM +0300, Luca Coelho wrote:
> > > I kernel v4.9, we stopped supporting firmware versions smaller than 22
> > > for the 8260.  But unfortunately I made a mistake in the patch[1] when I
> > > removed support for those firmwares and I used 17, which is the lowest
> > > version for 7260 devices.
> > > 
> > > I have just sent out a patch[2] with a fix for that.
> > > 
> > > You can probably solve your problem by getting the latest firmware we
> > > have released, which is version 27.  You can get it from the linux-
> > > firmware.git repository[3].  Please try that and let us know how it
> > > goes.
> >  
> > Thanks. I think the other problem is that
> > https://wireless.wiki.kernel.org/en/users/drivers/iwlwifihttps://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
> > says to use 'iwlwifi-8000-ucode-16.242414.0.tgz' for 4.3+ kenrels.
> > and strangely says "iwlwifi-8000-ucode-25.30.13.0.tgz" for 4.1+ kernels.
> > 
> > Unless I'm crazy, it didn't have -25 when I looked last time.
> > Is there a way to keep what I thought was the canonical page, up to date?
> > 
> > Firmware 27 seems to work, but I'm getting allocation error/warnings?
> 
> Ok, now I'm getting this error with 4.11.6 when loading the module
> (after having unloaded it while on batteries, to save power):
> 
> Intel(R) Wireless WiFi driver for Linux
> Copyright(c) 2003- 2015 Intel Corporation
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1147 at drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1913 iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
> Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
> Modules linked in: iwlwifi(+) cfg80211 uvcvideo e1000e rndis_host cdc_ether usbnet cmac ccm ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack nf_log_ipv4 nf_log_common xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables rfcomm iptable_filter ip_tables x_tables bnep pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat configs input_polldev loop firewire_sbp2 firewire_core crc_itu_t cuse ecryptfs ppdev parport_pc lp parport hid_generic videobuf2_vmalloc videobuf2_memops btusb videobuf2_v4l2 btrtl videobuf2_core btbcm btintel videodev media
>  usbhid bluetooth hid joydev arc4 snd_hda_codec_realtek snd_hda_codec_generic coretemp snd_hda_intel x86_pkg_temp_thermal intel_powerclamp snd_hda_codec kvm_intel snd_hda_core rtsx_pci_ms iTCO_wdt kvm memstick rtsx_pci_sdmmc iTCO_vendor_support mei_wdt snd_hwdep thinkpad_acpi irqbypass snd_pcm nvram crct10dif_pclmul crc32_pclmul snd_seq ghash_clmulni_intel snd_seq_device intel_cstate efi_pstore intel_rapl_perf snd_timer xhci_pci pcspkr psmouse efivars i2c_i801 xhci_hcd snd rtsx_pci nvidiafb sg usbcore vgastate fb_ddc mei_me intel_pch_thermal soundcore rfkill wmi hwmon battery ac tpm_crb tpm_tis tpm_tis_core tpm sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy
>  async_tx blowfish_x86_64 blowfish_common crc32c_intel bcache aesni_intel i915 ptp aes_x86_64 crypto_simd input_leds cryptd glue_helper serio_raw pps_core shpchp thermal evdev [last unloaded: cfg80211]
> CPU: 3 PID: 1147 Comm: modprobe Tainted: G        W  OE   4.11.6-amd64-preempt-sysrq-20170406 #6
> Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
> Call Trace:
>  dump_stack+0x61/0x7d
>  __warn+0xc2/0xdd
>  warn_slowpath_fmt+0x5a/0x76
>  ? iwl_read32+0x1f/0x7f [iwlwifi]
>  iwl_trans_pcie_grab_nic_access+0xcc/0xe1 [iwlwifi]
>  iwl_trans_pcie_alloc+0x2fb/0x7d4 [iwlwifi]
>  iwl_pci_probe+0x30/0x301 [iwlwifi]
>  ? _raw_spin_unlock_irqrestore+0x14/0x24
>  ? __pm_runtime_resume+0x4d/0x58
>  local_pci_probe+0x3d/0x80
>  pci_device_probe+0xf9/0x13c
>  driver_probe_device+0x19d/0x3f2
>  __driver_attach+0x80/0xdb
>  ? driver_probe_device+0x3f2/0x3f2
>  bus_for_each_dev+0x69/0xa7
>  driver_attach+0x1e/0x20
>  bus_add_driver+0xfd/0x239
>  driver_register+0x88/0xbf
>  ? 0xffffffffc06bf000
>  __pci_register_driver+0x4c/0x4e
>  iwl_pci_register_driver+0x24/0x3b [iwlwifi]
>  ? 0xffffffffc06bf000
>  iwl_drv_init+0x65/0x67 [iwlwifi]
>  do_one_initcall+0x9f/0x160
>  ? slab_pre_alloc_hook+0x1a/0x44
>  ? slab_post_alloc_hook.isra.47+0xe/0x1d
>  ? kmem_cache_alloc_trace+0xec/0xfc
>  do_init_module+0x5f/0x1f7
>  load_module+0x1e6e/0x2595
>  ? strstarts+0x28/0x28
>  ? vfs_read+0xb5/0xdc
>  SYSC_finit_module+0xa2/0xe6
>  ? SYSC_finit_module+0xa2/0xe6
>  SyS_finit_module+0xe/0x10
>  do_syscall_64+0x6b/0x7d
>  entry_SYSCALL64_slow_path+0x25/0x25
> RIP: 0033:0x7f3e447ce119
> RSP: 002b:00007ffec7b402d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 0000564e79be53e0 RCX: 00007f3e447ce119
> RDX: 0000000000000000 RSI: 0000564e79345246 RDI: 0000000000000004
> RBP: 0000564e79345246 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000564e79be7770 R14: 0000000000040000 R15: 0000000000040000
> ---[ end trace 35b5c8836a5906b1 ]---
> iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
> iwlwifi 0000:04:00.0: Falling back to user helper
> iwlwifi 0000:04:00.0: capa flags index 3 larger than supported by driver
> iwlwifi 0000:04:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm
> iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0xFFFC
> iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
> iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
> [drm:intel_pipe_update_end [i915]] *ERROR* Atomic update failure on pipe A (start=90832 end=90833) time 312 us, min 2146, max 2159, scanline start 2120, end 2162
> iwlwifi 0000:04:00.0: Could not load the [0] uCode section
> iwlwifi 0000:04:00.0: Failed to start INIT ucode: -5
> [drm:intel_pipe_update_end [i915]] *ERROR* Atomic update failure on pipe A (start=93049 end=93050) time 335 us, min 2146, max 2159, scanline start 2131, end 2176
> iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
