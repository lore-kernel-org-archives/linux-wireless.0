Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966776AbcCPN63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 09:58:29 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8xxxu 4.4.5(from f23): I get a panic adding a new device to the driver
References: <56E89DD2.7000000@gmail.com>
Date: Wed, 16 Mar 2016 09:58:28 -0400
In-Reply-To: <56E89DD2.7000000@gmail.com> (Xose Vazquez Perez's message of
	"Wed, 16 Mar 2016 00:42:10 +0100")
Message-ID: <wrfjfuvqr0cb.fsf@redhat.com> (sfid-20160316_145835_300234_CCA4E2A8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> Hi,
>
> If I do:
> # echo "0bda 8176" > /sys/bus/usb/drivers/rtl8xxxu/new_id

Hi Xose,

Yes please don't do that. The rtl8xxxu driver relies on the .driver_info
field in struct use_device_id to carry information for the different
types of devices. If you hot add a device like above, the driver will
fail because that field now contains a NULL pointer.

I should probably add a check for it in the probe function, but it will
simply be there to spit out a warning that it doesn't work to hot add a
device like this.

If you build it with CONFIG_RTL8XXXU_UNTESTED the 0bda:8176 should be
included in the device list.

Cheers,
Jes


>
> I get:
> ---dmesg---
> usbcore: registered new interface driver rtl8xxxu
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa054bbf0>] rtl8xxxu_probe+0x810/0x22a0 [rtl8xxxu]
> PGD 0
> Oops: 0000 [#1] SMP
> Modules linked in: rtl8xxxu ccm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_pcm_oss snd_mixer_oss arc4 intel_rapl iosf_mbi x86_pkg_temp_thermal coretemp kvm_intel kvm ath9k ath9k_common ath9k_hw
> irqbypass ath crct10dif_pclmul i915 crc32_pclmul crc32c_intel iTCO_wdt iTCO_vendor_support mac80211 snd_hda_codec_realtek cfg80211 snd_hda_codec_generic snd_usb_audio i2c_i801 snd_hda_intel
> snd_hda_codec snd_hda_core snd_usbmidi_lib snd_rawmidi snd_hwdep snd_seq ses video i2c_algo_bit snd_seq_device drm_kms_helper enclosure lpc_ich drm snd_pcm rfkill snd_timer mei_me snd mei soundcore
> shpchp tpm_tis tpm binfmt_misc hid_logitech_hidpp hid_logitech_dj serio_raw r8169 mii fjes uas usb_storage [last unloaded: rtlwifi]
> CPU: 0 PID: 1233 Comm: bash Not tainted 4.4.5-300.fc23.x86_64 #1
> Hardware name: Hewlett-Packard p6-2004es/2ABF, BIOS 7.16 03/23/2012
> task: ffff88022d340000 ti: ffff8800b5c10000 task.ti: ffff8800b5c10000
> RIP: 0010:[<ffffffffa054bbf0>] [<ffffffffa054bbf0>] rtl8xxxu_probe+0x810/0x22a0 [rtl8xxxu]
> RSP: 0018:ffff8800b5c13bc0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 000000000000006a RCX: 0000000000005a32
> RDX: 0000000000005a31 RSI: 0000000000000000 RDI: ffff8802346bb4c0
> RBP: ffff8800b5c13c70 R08: 000000000001a1e0 R09: ffffffff81586bbb
> R10: ffffea0002d65380 R11: 0000000000000000 R12: 00000000000000bf
> R13: 00000000000000ff R14: ffff8802346bb4c0 R15: 00000000000000be
> FS: 00007fe567227700(0000) GS:ffff88023f400000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000b5d9a000 CR4: 00000000000406f0
> Stack:
> ffff88022d340000 ffff8800b5c13be8 ffffffff812abf5a 00000000ffffffea
> 0000000000000000 ffff8800b5c13c18 0000000084b2960b ffff880232cfa090
> ffff8802346ba700 ffff880233631400 ffff8802346bb53e 0000006300000246
> Call Trace:
> [<ffffffff812abf5a>] ? kernfs_activate+0x7a/0xe0
> [<ffffffff8158b03d>] usb_probe_interface+0x1bd/0x300
> [<ffffffff814ef252>] driver_probe_device+0x222/0x490
> [<ffffffff814ef544>] __driver_attach+0x84/0x90
> [<ffffffff814ef4c0>] ? driver_probe_device+0x490/0x490
> [<ffffffff814ecd2c>] bus_for_each_dev+0x6c/0xc0
> [<ffffffff814eea0e>] driver_attach+0x1e/0x20
> [<ffffffff8158a33b>] usb_store_new_id+0xeb/0x1c0
> [<ffffffff8158a432>] new_id_store+0x22/0x30
> [<ffffffff814eca85>] drv_attr_store+0x25/0x30
> [<ffffffff812ada77>] sysfs_kf_write+0x37/0x40
> [<ffffffff812ad03d>] kernfs_fop_write+0x11d/0x170
> [<ffffffff8122dbb7>] __vfs_write+0x37/0x110
> [<ffffffff8124b3b3>] ? __fd_install+0x33/0xe0
> [<ffffffff810ec982>] ? percpu_down_read+0x12/0x50
> [<ffffffff8122e2c9>] vfs_write+0xa9/0x1a0
> [<ffffffff8122ef85>] SyS_write+0x55/0xc0
> [<ffffffff817a052e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Code: 44 89 f0 4d 89 fe 41 89 c7 66 41 81 ff ff 01 0f 86 6f ff ff ff 31 d2 be cf 00 00 00 4c 89 f7 e8 07 a5 ff ff 49 8b 46 10 4c 89 f7 <ff> 10 85 c0 41 89 c0 0f 85 89 03 00 00 49 8b 46 08 48 c7 c1 5b
> RIP [<ffffffffa054bbf0>] rtl8xxxu_probe+0x810/0x22a0 [rtl8xxxu]
> RSP <ffff8800b5c13bc0>
> CR2: 0000000000000000
> ---[ end trace 0675ed7e0a2d84ed ]---
>
> --rtl8192cu dmesg--
> rtl8192cu: Chip version 0x10
> rtl8192cu: MAC address: 00:e0:4c:07:dd:45
> rtl8192cu: Board Type 0
> rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
> rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
> ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
> usbcore: registered new interface driver rtl8192cu
> --end--
>
> --lsusb-v--
> Bus 002 Device 004: ID 0bda:8176 Realtek Semiconductor Corp. RTL8188CUS 802.11n WLAN Adapter
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0bda Realtek Semiconductor Corp.
>   idProduct          0x8176 RTL8188CUS 802.11n WLAN Adapter
>   bcdDevice            2.00
>   iManufacturer           1 Realtek
>   iProduct                2 802.11n WLAN Adapter
>   iSerial                 3 00e04c000001
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           46
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
> --end--
>
> Thanks.
