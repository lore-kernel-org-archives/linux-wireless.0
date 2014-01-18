Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:55181 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaARTnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 14:43:08 -0500
Received: by mail-we0-f172.google.com with SMTP id q58so5798647wes.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 11:43:06 -0800 (PST)
Message-ID: <52DAD949.2090906@gmail.com> (sfid-20140118_204323_992893_D4189369)
Date: Sat, 18 Jan 2014 21:43:05 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Adam Stylinski <kungfujesus06@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: iwlwifi & 7260 issues
References: <CAJwHY9U3_8soEfj0hQH3N6zdsDigiwcFx3djVn701C0=sAW-vQ@mail.gmail.com>
In-Reply-To: <CAJwHY9U3_8soEfj0hQH3N6zdsDigiwcFx3djVn701C0=sAW-vQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/18/2014 08:47 PM, Adam Stylinski wrote:
> So does kernel 3.13 address all of these stability issues I've been
> having with the 7260 wireless NIC?  The communication between driver
> and firmware seems to frequently deadlock.  When I reinitialize the
> following stack trace spits out:
> 
> [12152.263634] WARNING: CPU: 2 PID: 199 at
> drivers/net/wireless/iwlwifi/mvm/tx.c:684
> iwl_mvm_rx_tx_cmd+0x58c/0x5e0 [iwlmvm]()
> [12152.263636] Modules linked in: snd_hda_codec_hdmi joydev arc4
> snd_hda_codec_realtek x86_pkg_temp_thermal coretemp nls_cp437
> kvm_intel iTCO_wdt vfat fat iTCO_vendor_support kvm crct10dif_pclmul
> crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
> aesni_intel aes_x86_64 lrw gf128mul iwlmvm glue_helper ablk_helper
> cryptd microcode mac80211 btusb evdev psmouse serio_raw bluetooth
> pcspkr iwlwifi rtsx_pci_ms memstick cfg80211 i915 thermal wmi
> intel_agp thinkpad_acpi battery snd_hda_intel nvram tpm_tis ac rfkill
> tpm tpm_bios intel_gtt drm_kms_helper snd_hda_codec snd_hwdep e1000e
> snd_pcm video drm snd_page_alloc mei_me snd_timer mei snd button
> i2c_i801 ptp soundcore i2c_algo_bit shpchp pps_core i2c_core processor
> lpc_ich nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 sd_mod
> rtsx_pci_sdmmc mmc_core
> [12152.263699]  ahci libahci libata scsi_mod ehci_pci ehci_hcd
> rtsx_pci xhci_hcd usbcore usb_common
> [12152.263709] CPU: 2 PID: 199 Comm: irq/61-iwlwifi Tainted: G
> W    3.12.7-2-ARCH #1
> [12152.263711] Hardware name: LENOVO 20ALCTO1WW/20ALCTO1WW, BIOS
> GIET66WW (2.16 ) 12/02/2013
> [12152.263713]  0000000000000009 ffff8800d55e9c38 ffffffff814ec113
> 0000000000000000
> [12152.263725]  ffff8800d55e9c70 ffffffff81061b8d ffff8800d433c618
> ffff8800d41317d0
> [12152.263728]  ffff8800d433c668 ffff8800d433c678 ffff8800d41317d8
> ffff8800d55e9c80
> [12152.263731] Call Trace:
> [12152.263738]  [<ffffffff814ec113>] dump_stack+0x54/0x8d
> [12152.263743]  [<ffffffff81061b8d>] warn_slowpath_common+0x7d/0xa0
> [12152.263746]  [<ffffffff81061c6a>] warn_slowpath_null+0x1a/0x20
> [12152.263752]  [<ffffffffa09f9b0c>] iwl_mvm_rx_tx_cmd+0x58c/0x5e0 [iwlmvm]
> [12152.263756]  [<ffffffffa09f49fd>] iwl_mvm_rx_dispatch+0x13d/0x160 [iwlmvm]
> [12152.263762]  [<ffffffffa07dba08>] iwl_pcie_irq_handler+0xff8/0x12e0 [iwlwifi]
> [12152.263767]  [<ffffffff810b69d0>] ? irq_finalize_oneshot.part.29+0xd0/0xd0
> [12152.263770]  [<ffffffff810b69f0>] irq_thread_fn+0x20/0x50
> [12152.263773]  [<ffffffff810b69d0>] ? irq_finalize_oneshot.part.29+0xd0/0xd0
> [12152.263776]  [<ffffffff810b6d2f>] irq_thread+0x11f/0x150
> [12152.263780]  [<ffffffff810b6b50>] ? wake_threads_waitq+0x50/0x50
> [12152.263783]  [<ffffffff810b6c10>] ? irq_thread_dtor+0xc0/0xc0
> [12152.263787]  [<ffffffff81083f60>] kthread+0xc0/0xd0
> [12152.263791]  [<ffffffff81083ea0>] ? kthread_create_on_node+0x120/0x120
> [12152.263794]  [<ffffffff814fab7c>] ret_from_fork+0x7c/0xb0
> [12152.263798]  [<ffffffff81083ea0>] ? kthread_create_on_node+0x120/0x120
> [12152.263800] ---[ end trace d95aa1d60ba2d57e ]---
> 

No - we don't address specifically anything like this.
This is the first time I see this WARNING with 7260.
Do you have the ability to record a tracing?
