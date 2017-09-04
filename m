Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753219AbdIDHem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 03:34:42 -0400
Message-ID: <1504510477.5400.23.camel@coelho.fi> (sfid-20170904_093446_049083_9D45FD3F)
From: Luca Coelho <luca@coelho.fi>
To: Carl Myers <cmyers@cmyers.org>, linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Date: Mon, 04 Sep 2017 10:34:37 +0300
In-Reply-To: <20170903191552.GE7829@cmyers.org>
References: <20170903191552.GE7829@cmyers.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Bug Report for iwlwifi kernel module
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Carl,

On Sun, 2017-09-03 at 12:15 -0700, Carl Myers wrote:
> Greetings all,
> 
> Apologies if any of this is wrong, this is my first attempt to report a bug in
> the linux kernel =)
> 
> I got here by running the get_maintainer script on the iwlwifi directory of a
> linux kernel checkout.
> 
> I am running debian stock kernel 4.8.15, and using the built in iwlwifi
> driver
> 
> $⮀ uname -a
> Linux powerhouse 4.8.0-2-amd64 #1 SMP Debian 4.8.15-2 (2017-01-04) x86_64 GNU/Linux
> $⮀ dpkg -l | grep iwlwifi
> ii  firmware-iwlwifi                      20160110-1~bpo8+1                 all          Binary firmware for Intel Wireless cards
> 
> I am on a slightly  older firmware and kernel due to the currently-outstanding bug:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=849330
> 
> This is the newest combination of kernel/firmware I've been able to make work.
> 
> Here is the lspci -v output for my wifi:
> 03:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
>         Subsystem: Intel Corporation Wireless 8260
>         Flags: bus master, fast devsel, latency 0, IRQ 136
>         Memory at df200000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: <access denied>
>         Kernel driver in use: iwlwifi
>         Kernel modules: iwlwifi

First of all, what makes you think this is a bug in the iwlwifi driver
module?


> Recently, while testing a 2nd panda wifi card (trying to make a hotspot and use
> the iwl card as a gateway device), I got a kernel panic.  Here is the relevant
> excerpt from kern.log:
> 
> Sep  3 11:37:49 powerhouse kernel: [21394.510512] ------------[ cut here ]------------
> Sep  3 11:37:49 powerhouse kernel: [21394.510514] kernel BUG at /build/linux-zDY19G/linux-4.8.15/kernel/module.c:890!
> Sep  3 11:37:49 powerhouse kernel: [21394.510515] invalid opcode: 0000 [#1] SMP
> Sep  3 11:37:49 powerhouse kernel: [21394.510516] Modules linked in: iwlmvm iwlwifi ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp hid_generic rt2800usb rt2x00usb rt2800lib rt2x00lib crc_ccitt ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp overlay iptable_filter appletalk ax25 ipx p8023 p8022 psnap llc bnep snd_hda_codec_hdmi arc4 binfmt_misc nls_ascii nls_cp437 vfat fat mac80211 snd_hda_codec_realtek intel_rapl x86_pkg_temp_thermal mxm_wmi intel_powerclamp coretemp snd_hda_codec_generic kvm_intel kvm efi_pstore irqbypass snd_hda_intel intel_cstate snd_hda_codec uvcvideo videobuf2_vmalloc rtsx_pci_ms videobuf2_memops snd_hda_core videobuf2_v4l2 iTCO_wdt videobuf2_core snd_hwdep intel_uncore videodev joydev btusb intel_rapl_perf evdev media btrtl cfg80211 serio_raw pcspkr efivars memstick iTCO_vendor_support snd_pcm snd_timer mei_me hci_uart snd mei soundcore btbcm btqca btintel bluetooth rfkill wmi video intel_lpss_acpi intel_lpss shpchp battery acpi_pad ac tpm_tis button tpm_tis_core tpm nvidia_drm(POE) drm_kms_helper drm nvidia_modeset(POE) nvidia(POE) parport_pc ppdev lp parport efivarfs ip_tables x_tables autofs4 ext4 crc16 jbd2 crc32c_generic fscrypto ecb mbcache algif_skcipher af_alg dm_crypt dm_mod hid_logitech_hidpp hid_logitech_dj usbhid rtsx_pci_sdmmc mmc_core crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ahci libahci aes_x86_64 lrw gf128mul glue_helper xhci_pci ablk_helper cryptd libata xhci_hcd psmouse usbcore nvme scsi_mod i2c_i801 nvme_core i2c_smbus rtsx_pci r8169 mii mfd_core usb_common thermal i2c_hid hid fjes [last unloaded: iwlwifi]
> Sep  3 11:37:49 powerhouse kernel: [21394.510561] CPU: 4 PID: 8122 Comm: rmmod Tainted: P  R        OE   4.8.0-2-amd64 #1 Debian 4.8.15-2
> Sep  3 11:37:49 powerhouse kernel: [21394.510562] Hardware name: System76, Inc. Oryx Pro/Oryx Pro, BIOS 1.05.09RSA1 11/16/2015
> Sep  3 11:37:49 powerhouse kernel: [21394.510563] task: ffff8dec4a3e0000 task.stack: ffff8decf4cd4000
> Sep  3 11:37:49 powerhouse kernel: [21394.510564] RIP: 0010:[<ffffffffbccf98b9>]  [<ffffffffbccf98b9>] SyS_delete_module+0x259/0x260
> Sep  3 11:37:49 powerhouse kernel: [21394.510568] RSP: 0018:ffff8decf4cd7ef0  EFLAGS: 00010297
> Sep  3 11:37:49 powerhouse kernel: [21394.510569] RAX: 00000000ffffffff RBX: ffffffffc1aa71c0 RCX: 0000000000000005
> Sep  3 11:37:49 powerhouse kernel: [21394.510570] RDX: ffffffffc1aa74a0 RSI: ffffffffc1aa74c8 RDI: ffffffffc1aa71d8
> Sep  3 11:37:49 powerhouse kernel: [21394.510571] RBP: 000055fb472021f0 R08: 0000000000000000 R09: 000000000000006d
> Sep  3 11:37:49 powerhouse kernel: [21394.510572] R10: 000055fb472011c0 R11: 8080808080808080 R12: 0000000000000a00
> Sep  3 11:37:49 powerhouse kernel: [21394.510572] R13: 0000000000000a00 R14: 00007fff6cd8d4f8 R15: 0000000000000000
> Sep  3 11:37:49 powerhouse kernel: [21394.510573] FS:  00007f498ef22700(0000) GS:ffff8ded76500000(0000) knlGS:0000000000000000
> Sep  3 11:37:49 powerhouse kernel: [21394.510574] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Sep  3 11:37:49 powerhouse kernel: [21394.510575] CR2: 00007f498eacf801 CR3: 0000000fa99d0000 CR4: 00000000003406e0
> Sep  3 11:37:49 powerhouse kernel: [21394.510576] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Sep  3 11:37:49 powerhouse kernel: [21394.510576] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Sep  3 11:37:49 powerhouse kernel: [21394.510577] Stack:
> Sep  3 11:37:49 powerhouse kernel: [21394.510578]  00006d766d6c7769 0000000000000002 ffff8decf4cd4000 ffffffffbcc03290
> Sep  3 11:37:49 powerhouse kernel: [21394.510579]  ffff8decf4cd7f58 ffff8decf4cd4000 0000000000000050 00000000520cd409
> Sep  3 11:37:49 powerhouse kernel: [21394.510581]  00007fff6cd8d338 000055fb472021f0 00007fff6cd8d508 00007fff6cd8ebbb
> Sep  3 11:37:49 powerhouse kernel: [21394.510582] Call Trace:
> Sep  3 11:37:49 powerhouse kernel: [21394.510586]  [<ffffffffbcc03290>] ? exit_to_usermode_loop+0xa0/0xc0
> Sep  3 11:37:49 powerhouse kernel: [21394.510588]  [<ffffffffbd1e8cb6>] ? system_call_fast_compare_end+0xc/0x96
> Sep  3 11:37:49 powerhouse kernel: [21394.510588] Code: fe ff ff 41 f7 c4 00 02 00 00 48 c7 c5 f0 ff ff ff 0f 84 5c fe ff ff be 01 00 00 00 bf 03 00 00 00 e8 0c b3 f7 ff e9 b7 fe ff ff <0f> 0b e8 90 b4 f7 ff 0f 1f 44 00 00 31 c0 c3 0f 1f 84 00 00 00 
> Sep  3 11:37:49 powerhouse kernel: [21394.510605] RIP  [<ffffffffbccf98b9>] SyS_delete_module+0x259/0x260
> Sep  3 11:37:49 powerhouse kernel: [21394.510607]  RSP <ffff8decf4cd7ef0>
> Sep  3 11:37:49 powerhouse kernel: [21394.510608] ---[ end trace 5b24b93b49e857eb ]---
> Sep  3 11:37:49 powerhouse kernel: [21409.372738] ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -110
> Sep  3 11:38:05 powerhouse kernel: [21425.406196] INFO: rcu_sched detected stalls on CPUs/tasks:
> Sep  3 11:38:20 powerhouse kernel: [21425.406201] 	4-...: (0 ticks this GP) idle=02d/140000000000000/0 softirq=277173/277173 fqs=8 
> Sep  3 11:38:20 powerhouse kernel: [21425.406202] 	(detected by 7, t=7721 jiffies, g=246559, c=246558, q=936)
> Sep  3 11:38:20 powerhouse kernel: [21425.406204] Task dump for CPU 4:
> Sep  3 11:38:20 powerhouse kernel: [21425.406206] rmmod           R  running task        0  8122   8121 0x00000008
> Sep  3 11:38:20 powerhouse kernel: [21425.406209]  0000000000000002 ffff8decf4cd7e48 ffffffffbd3df853 0000000000000000
> Sep  3 11:38:20 powerhouse kernel: [21425.406211]  0000000000000000 ffffffffbcccc3d3 0000000000000246 000000000000000b
> Sep  3 11:38:20 powerhouse kernel: [21425.406214]  ffffffffbcc289f8 0000000000000006 ffff8decf4cd7e48 0000000000000004
> Sep  3 11:38:20 powerhouse kernel: [21425.406216] Call Trace:
> Sep  3 11:38:20 powerhouse kernel: [21425.406222]  [<ffffffffbcccc3d3>] ? kmsg_dump+0x93/0xb0
> Sep  3 11:38:20 powerhouse kernel: [21425.406225]  [<ffffffffbcc289f8>] ? oops_end+0x78/0xd0
> Sep  3 11:38:20 powerhouse kernel: [21425.406228]  [<ffffffffbcc26446>] ? do_error_trap+0x86/0x100
> Sep  3 11:38:20 powerhouse kernel: [21425.406976]  [<ffffffffbccf98b9>] ? SyS_delete_module+0x259/0x260
> Sep  3 11:38:20 powerhouse kernel: [21425.406979]  [<ffffffffbcdda242>] ? kmem_cache_alloc+0x122/0x530
> Sep  3 11:38:20 powerhouse kernel: [21425.406982]  [<ffffffffbd1e9a2e>] ? invalid_op+0x1e/0x30
> Sep  3 11:38:20 powerhouse kernel: [21425.407276]  [<ffffffffbccf98b9>] ? SyS_delete_module+0x259/0x260
> Sep  3 11:38:20 powerhouse kernel: [21425.407277] perf: interrupt took too long (8612 > 2500), lowering kernel.perf_event_max_sample_rate to 23000
> Sep  3 11:3Sep  3 11:39:51 powerhouse kernel: [    0.000000] Linux version 4.8.0-2-amd64 (debian-kernel@lists.debian.org) (gcc version 5.4.1 20161202 (Debian 5.4.1-4) ) #1 SMP Debian 4.8.15-2 (2017-01-04)
> Sep  3 11:39:51 powerhouse kernel: [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.8.0-2-amd64 root=/dev/mapper/powerhouse--vg-root ro quiet
> 
> Obviously, I'm not certain the bug is in this kernel module or even has
> anything to do with it, but I thought this was a good place to start.  Advice
> welcome, happy to help however I can, I am a software engineer but not very
> experienced at kernel hacking.

The bug you're seeing is happening in the module removal code[1]. 
Apparently the system is getting a bad value in refcnt and it's becoming
negative, which should never happen.  Have you been trying to force-
remove modules or something like that?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/tree/kernel/module.c?h=linux-4.8.y#n890 

In any case, this doesn't seem like a iwlwifi bug at all.

HTH.

--
Cheers,
Luca.
