Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62572 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaASIa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 03:30:28 -0500
Received: by mail-ob0-f177.google.com with SMTP id wp18so3979553obc.8
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jan 2014 00:30:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJwHY9X3Rp2NRwXmjfH_-8odysKq9OozpVTr5dE33g4zk0Lg8g@mail.gmail.com>
References: <CAJwHY9U3_8soEfj0hQH3N6zdsDigiwcFx3djVn701C0=sAW-vQ@mail.gmail.com>
	<52DAD949.2090906@gmail.com>
	<CAJwHY9X3Rp2NRwXmjfH_-8odysKq9OozpVTr5dE33g4zk0Lg8g@mail.gmail.com>
Date: Sun, 19 Jan 2014 10:30:27 +0200
Message-ID: <CANUX_P1aKozsAR4xceeJXuwny1+LMEG+_y2RKgTQLSM=VctgDA@mail.gmail.com> (sfid-20140119_093052_071939_8055F924)
Subject: Re: iwlwifi & 7260 issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Adam Stylinski <kungfujesus06@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 18, 2014 at 10:23 PM, Adam Stylinski
<kungfujesus06@gmail.com> wrote:
> Tell me how and I might be able to.  It doesn't drop me into the
> kernel debugger if that's what you mean.  I'm using the stock kernel
> with my distro but if it requires more I'm willing to do it for the
> sake of having a working card.

compile the kernel with CONFIG_IWLWIFI_DEVICE_TRACING and
CONFIG_IWLWIFI_DEBUG set.
Then, compile trace-cmd
(https://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git/)

Finally as root:
  trace-cmd record -e iwlwifi -e iwlwifi_dbg

Run the failing scenario - until you get the warning.

you'll get  a trace.dat file. Compress it and send it to me.

If you can't make it work - please enable CONFIG_IWLWIFI_DEBUG and
load the iwlwifi module with:
debug=0xC0800000 and send the dmesg output / syslog when the WARNING
occurs. This option is less preferred though.

>
> On Sat, Jan 18, 2014 at 2:43 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>
>> On 01/18/2014 08:47 PM, Adam Stylinski wrote:
>>> So does kernel 3.13 address all of these stability issues I've been
>>> having with the 7260 wireless NIC?  The communication between driver
>>> and firmware seems to frequently deadlock.  When I reinitialize the
>>> following stack trace spits out:
>>>
>>> [12152.263634] WARNING: CPU: 2 PID: 199 at
>>> drivers/net/wireless/iwlwifi/mvm/tx.c:684
>>> iwl_mvm_rx_tx_cmd+0x58c/0x5e0 [iwlmvm]()
>>> [12152.263636] Modules linked in: snd_hda_codec_hdmi joydev arc4
>>> snd_hda_codec_realtek x86_pkg_temp_thermal coretemp nls_cp437
>>> kvm_intel iTCO_wdt vfat fat iTCO_vendor_support kvm crct10dif_pclmul
>>> crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
>>> aesni_intel aes_x86_64 lrw gf128mul iwlmvm glue_helper ablk_helper
>>> cryptd microcode mac80211 btusb evdev psmouse serio_raw bluetooth
>>> pcspkr iwlwifi rtsx_pci_ms memstick cfg80211 i915 thermal wmi
>>> intel_agp thinkpad_acpi battery snd_hda_intel nvram tpm_tis ac rfkill
>>> tpm tpm_bios intel_gtt drm_kms_helper snd_hda_codec snd_hwdep e1000e
>>> snd_pcm video drm snd_page_alloc mei_me snd_timer mei snd button
>>> i2c_i801 ptp soundcore i2c_algo_bit shpchp pps_core i2c_core processor
>>> lpc_ich nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 sd_mod
>>> rtsx_pci_sdmmc mmc_core
>>> [12152.263699]  ahci libahci libata scsi_mod ehci_pci ehci_hcd
>>> rtsx_pci xhci_hcd usbcore usb_common
>>> [12152.263709] CPU: 2 PID: 199 Comm: irq/61-iwlwifi Tainted: G
>>> W    3.12.7-2-ARCH #1
>>> [12152.263711] Hardware name: LENOVO 20ALCTO1WW/20ALCTO1WW, BIOS
>>> GIET66WW (2.16 ) 12/02/2013
>>> [12152.263713]  0000000000000009 ffff8800d55e9c38 ffffffff814ec113
>>> 0000000000000000
>>> [12152.263725]  ffff8800d55e9c70 ffffffff81061b8d ffff8800d433c618
>>> ffff8800d41317d0
>>> [12152.263728]  ffff8800d433c668 ffff8800d433c678 ffff8800d41317d8
>>> ffff8800d55e9c80
>>> [12152.263731] Call Trace:
>>> [12152.263738]  [<ffffffff814ec113>] dump_stack+0x54/0x8d
>>> [12152.263743]  [<ffffffff81061b8d>] warn_slowpath_common+0x7d/0xa0
>>> [12152.263746]  [<ffffffff81061c6a>] warn_slowpath_null+0x1a/0x20
>>> [12152.263752]  [<ffffffffa09f9b0c>] iwl_mvm_rx_tx_cmd+0x58c/0x5e0 [iwlmvm]
>>> [12152.263756]  [<ffffffffa09f49fd>] iwl_mvm_rx_dispatch+0x13d/0x160 [iwlmvm]
>>> [12152.263762]  [<ffffffffa07dba08>] iwl_pcie_irq_handler+0xff8/0x12e0 [iwlwifi]
>>> [12152.263767]  [<ffffffff810b69d0>] ? irq_finalize_oneshot.part.29+0xd0/0xd0
>>> [12152.263770]  [<ffffffff810b69f0>] irq_thread_fn+0x20/0x50
>>> [12152.263773]  [<ffffffff810b69d0>] ? irq_finalize_oneshot.part.29+0xd0/0xd0
>>> [12152.263776]  [<ffffffff810b6d2f>] irq_thread+0x11f/0x150
>>> [12152.263780]  [<ffffffff810b6b50>] ? wake_threads_waitq+0x50/0x50
>>> [12152.263783]  [<ffffffff810b6c10>] ? irq_thread_dtor+0xc0/0xc0
>>> [12152.263787]  [<ffffffff81083f60>] kthread+0xc0/0xd0
>>> [12152.263791]  [<ffffffff81083ea0>] ? kthread_create_on_node+0x120/0x120
>>> [12152.263794]  [<ffffffff814fab7c>] ret_from_fork+0x7c/0xb0
>>> [12152.263798]  [<ffffffff81083ea0>] ? kthread_create_on_node+0x120/0x120
>>> [12152.263800] ---[ end trace d95aa1d60ba2d57e ]---
>>>
>>
>> No - we don't address specifically anything like this.
>> This is the first time I see this WARNING with 7260.
>> Do you have the ability to record a tracing?
