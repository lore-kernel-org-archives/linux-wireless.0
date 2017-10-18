Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:52580 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdJRXJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 19:09:47 -0400
Received: by mail-wr0-f195.google.com with SMTP id k62so6550620wrc.9
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 16:09:46 -0700 (PDT)
Subject: Re: rtlwifi oops
To: James Cameron <quozl@laptop.org>, linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
From: nirinA <nirina.raseliarison@gmail.com>
Message-ID: <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com> (sfid-20171019_010951_987677_0ACD244B)
Date: Thu, 19 Oct 2017 02:18:35 +0300
MIME-Version: 1.0
In-Reply-To: <20171018223320.GB641@us.netrek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

not really a rtlwifi oops then. maybe issue with udev as that also 
disabled the usb mouse.
but i have no problem since. i will report if i will catch it again.

thanks,

--
nirinA

James Cameron wrote:
> On Thu, Oct 19, 2017 at 01:31:43AM +0300, nirinA wrote:
>> hello there,
>> i got the oops below with a rtl8192cu:0bda:8178 and kernel 4.13.6, but
>> cannot reproduce it.
>> i use this device since 4.3 or so without noticing any issue.
>>
>> nirinA
>>
>> [  239.338040] usb 2-1.3: new high-speed USB device number 4 using ehci-pci
>> [  239.417728] usb 2-1.3: New USB device found, idVendor=0bda,
>> idProduct=8178
>> [  239.417730] usb 2-1.3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  239.417731] usb 2-1.3: Product: 802.11n WLAN Adapter
>> [  239.417732] usb 2-1.3: Manufacturer: Realtek
>> [  239.417733] usb 2-1.3: SerialNumber: 00e04c000001
>> [  239.578100] rtl8192cu: Chip version 0x11
>> [  239.678225] usb 2-1-port3: disabled by hub (EMI?), re-enabling...
> Just prior to the oops, your USB hub disabled the port being used by
> the wireless device.
>
> While the response of the driver seems wrong, it is a difficult
> condition to reproduce; one must either force or forge the disabling
> by the hub.
>
>> [  239.678230] usb 2-1.3: USB disconnect, device number 4
>> [  239.679128] rtl_usb: reg 0x30, usbctrl_vendorreq TimeOut!
>> status:0xffffffed value=0x0
>> [  239.679131] rtl_usb: reg 0x32, usbctrl_vendorreq TimeOut!
>> status:0xffffffed value=0x20
>> [  239.679133] rtl_usb: reg 0x33, usbctrl_vendorreq TimeOut!
>> status:0xffffffed value=0x80
>> [  239.679134] rtl_usb: reg 0x30, usbctrl_vendorreq TimeOut!
>> status:0xffffffed value=0x80206f30
>> [  239.700640] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
>> [  239.700648] BUG: unable to handle kernel NULL pointer dereference at
>> (null)
>> [  239.700682] IP: rtl_deinit_core+0x2e/0x90 [rtlwifi]
>> [  239.700693] PGD 1c5d5d067
>> [  239.700694] P4D 1c5d5d067
>> [  239.700701] PUD 1c5d9b067
>> [  239.700708] PMD 0
>>
>> [  239.700727] Oops: 0000 [#1] SMP
>> [  239.700735] Modules linked in: rtl8192cu(+) rtl_usb rtl8192c_common
>> rtlwifi mac80211 cfg80211 rfkill appletalk ipx p8023 p8022 psnap llc nct6775
>> hwmon_vid ipv6 hid_generic usbhid hid coretemp hwmon x86_pkg_temp_thermal
>> intel_powerclamp snd_hda_codec_hdmi snd_hda_codec_realtek
>> snd_hda_codec_generic kvm_intel i915 kvm drm_kms_helper evdev i2c_dev
>> irqbypass syscopyarea sysfillrect sysimgblt r8169 crc32_pclmul serio_raw
>> crc32c_intel mii snd_pcsp fb_sys_fops drm fan thermal button battery 8250
>> 8250_base serial_core mei_me snd_hda_intel mei intel_gtt snd_hda_codec video
>> agpgart ehci_pci ehci_hcd lpc_ich snd_hwdep snd_hda_core snd_pcm
>> i2c_algo_bit snd_timer i2c_i801 i2c_core snd soundcore fuse
>> [  239.700875] CPU: 0 PID: 1174 Comm: udevd Not tainted 4.13.6.20171012 #1
>> [  239.700889] Hardware name: To be filled by O.E.M. To be filled by
>> O.E.M./ONDA H61V Ver:4.01, BIOS 4.6.5 01/07/2013
>> [  239.700909] task: ffff8801c5fbc980 task.stack: ffffc900009a0000
>> [  239.700924] RIP: 0010:rtl_deinit_core+0x2e/0x90 [rtlwifi]
>> [  239.700936] RSP: 0000:ffffc900009a3b40 EFLAGS: 00010207
>> [  239.700947] RAX: 0000000000000282 RBX: ffff8801b9440780 RCX:
>> 00000000ffffffea
>> [  239.700962] RDX: 0000000000000001 RSI: 0000000000000282 RDI:
>> 0000000000000000
>> [  239.700977] RBP: ffff8801b944b070 R08: 0000000000000001 R09:
>> 00000000000002b0
>> [  239.700991] R10: ffffea0008473480 R11: 0000000000000000 R12:
>> ffff8801b9441560
>> [  239.701006] R13: ffff8801b944b880 R14: 0000000000000000 R15:
>> ffff8801b9441560
>> [  239.701021] FS:  00007f3eb636e7c0(0000) GS:ffff88021f200000(0000)
>> knlGS:0000000000000000
>> [  239.701037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  239.701050] CR2: 0000000000000000 CR3: 00000001c5d99000 CR4:
>> 00000000001406f0
>> [  239.701064] Call Trace:
>> [  239.701074]  ? rtl_usb_probe+0x6b6/0xc50 [rtl_usb]
>> [  239.701088]  ? usb_probe_interface+0xe2/0x2a0
>> [  239.701100]  ? driver_probe_device+0x21d/0x2d0
>> [  239.701111]  ? __driver_attach+0x8a/0x90
>> [  239.701121]  ? driver_probe_device+0x2d0/0x2d0
>> [  239.701133]  ? bus_for_each_dev+0x5c/0x90
>> [  239.701143]  ? bus_add_driver+0x196/0x220
>> [  239.701154]  ? driver_register+0x57/0xc0
>> [  239.701165]  ? usb_register_driver+0x7c/0x140
>> [  239.701175]  ? 0xffffffffa064e000
>> [  239.701185]  ? do_one_initcall+0x4b/0x190
>> [  239.701197]  ? kmem_cache_alloc_trace+0xe4/0x1c0
>> [  239.701208]  ? do_init_module+0x22/0x1e1
>> [  239.701219]  ? do_init_module+0x5b/0x1e1
>> [  239.701229]  ? load_module+0x21ff/0x2760
>> [  239.701239]  ? SYSC_finit_module+0x90/0xb0
>> [  239.701249]  ? SYSC_finit_module+0x90/0xb0
>> [  239.701261]  ? entry_SYSCALL_64_fastpath+0x1a/0xa5
>> [  239.701272] Code: 00 00 41 57 31 f6 41 56 41 55 41 54 55 53 48 89 fb e8
>> e7 fe ff ff 4c 8b 7b 48 49 8b bf 10 9b 00 00 49 8d af 10 9b 00 00 48 39 ef
>> <48> 8b 1f 74 44 49 bd 00 01 00 00 00 00 ad de 49 89 de 49 bc 00
>> [  239.701327] RIP: rtl_deinit_core+0x2e/0x90 [rtlwifi] RSP:
>> ffffc900009a3b40
>> [  239.702028] CR2: 0000000000000000
>> [  239.705370] ---[ end trace 6ec9029c0d9c0e13 ]---
>> [  239.706311] udevd[528]: worker [1174] failed while handling
>> '/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0'
>>
