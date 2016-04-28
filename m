Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33643 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbcD1HwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 03:52:16 -0400
Received: by mail-lf0-f68.google.com with SMTP id p64so12981238lfg.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 00:52:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5500469A22567C4BAF673A6E86AFA3A4022D20C814C9@IR-CENTRAL.corp.innerrange.com>
References: <5500469A22567C4BAF673A6E86AFA3A4022D20C813C8@IR-CENTRAL.corp.innerrange.com>
 <20160427052758.GA3583@localhost.localdomain> <5500469A22567C4BAF673A6E86AFA3A4022D20C8140D@IR-CENTRAL.corp.innerrange.com>
 <CAC3a_SAt-ssa0Wx1mtC45_09ysa0PY47vsTXxSpdvWqn1ckMbg@mail.gmail.com> <5500469A22567C4BAF673A6E86AFA3A4022D20C814C9@IR-CENTRAL.corp.innerrange.com>
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Thu, 28 Apr 2016 09:51:54 +0200
Message-ID: <CAC3a_SAqL82zmHwHVE4S2QMaFAU9sRQ89gUArtRTKeqQoectVg@mail.gmail.com> (sfid-20160428_095222_327488_65C6A299)
Subject: Re: rt2800 and BeagleBone Black kernel panic when connecting to
 access point
To: Craig McQueen <craig.mcqueen@innerrange.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2016 at 1:23 AM, Craig McQueen
<craig.mcqueen@innerrange.com> wrote:
> Vishal Thanki wrote:
>> On Wed, Apr 27, 2016 at 7:56 AM, Craig McQueen
>> <craig.mcqueen@innerrange.com> wrote:
>> > Vishal Thanki wrote:
>> >> Hi,
>> >>
>> >> On Wed, Apr 27, 2016 at 02:21:36PM +1000, Craig McQueen wrote:
>> >> > I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based
>> >> > (5392
>> >> chipset). I've been testing it on a BeagleBone Black running an
>> >> Ubuntu 16.04 image (4.4.6 kernel).
>> >> >
>> >> > 1) Install Ubuntu 16.04 on a BeagleBone Black.
>> >> > 2) Add lines to /etc/network/interfaces for the device to connect
>> >> > to a
>> >> WPA2 access point.
>> >> > 3) Plug the rt2800 USB Wi-Fi device into the BeagleBone Black.
>> >> >
>> >> > Apparently when it tries to connect to the access point, I get a kernel
>> panic.
>> >> If I don't configure it (step 2 above) then the kernel panic doesn't happen.
>> >> >
>> >> > I've tested this with two access points: my Android phone acting as
>> >> > a
>> >> hotspot, and a cheap TP-Link TD-W8968.
>> >> >
>> >> > Serial debug console shows:
>> >> > ...
>> >>
>> >> I have seen a similar crash and fixed it as a part of following commit:
>> >>
>> >> 8b4c0009313f3d42e2540e3e1f776097dd0db73d
>> >>
>> >> But it would be helpful if you can get paste the entire kernel log.
>> >> Because in my case, I used to see a USB Disconnect event for the
>> >> rt2800 driver and the crash was caused due to that.
>> >
>> > Okay, see the attached file. I can't see a USB Disconnect event for the
>> rt2800, until the end (line 561, timestamp 222.861630) which is when I
>> unplugged the USB hub.
>> >
>>
>> The attached file seem to report a different kind of crash (soft
>> lockup) while the crash reported in the 1st email of yours is different (NULL
>> pointer dereference).
>> I am not sure about this soft lockup problem though.
>
> Sorry, my mistake, since I was reporting 3 different issues with the rt2800 driver.
>
> How is the following? I do see a line saying USB disconnect at timestamp 661.652499.
>

Yes, this is the exact crash which I used to hit. It is fixed by
following commit in wireless-drivers-next.git

8b4c0009313f3d42e2540e3e1f776097dd0db73d
(rt2x00usb: Use usb anchor to manage URB)

You may want to cherry pick the change and give it a try.

~
Vishal

> craigm@beaglebone-craig:~$ echo 8 | sudo tee /proc/sys/kernel/printk
> 8
>
> [now I plug in the rt2800 device]
>
> [  657.029785] musb-hdrc musb-hdrc.1.auto: VBUS_ERROR in a_wait_bcon (99, VALID), retry #1, port1 00000104
> [  657.536405] usb 1-1: new high-speed USB device number 2 using musb-hdrc
> [  657.688759] usb 1-1: New USB device found, idVendor=2001, idProduct=3c20
> [  657.695929] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  657.703546] usb 1-1: Product: 802.11 n WLAN
> [  657.708027] usb 1-1: Manufacturer: Ralink
> [  657.712330] usb 1-1: SerialNumber: 1.0
> [  659.116390] usb 1-1: reset high-speed USB device number 2 using musb-hdrc
> [  659.261736] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5392, rev 0223 detected
> [  659.285805] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 5372 detected
> [  659.392270] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [  659.427010] usbcore: registered new interface driver rt2800usb
> [  659.527755] rt2800usb 1-1:1.0 wlx9cd64384611d: renamed from wlan0
> [  659.885529] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
> [  659.898385] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
> [  660.060491] IPv6: ADDRCONF(NETDEV_UP): wlx9cd64384611d: link is not ready
> [  661.361740] musb-hdrc musb-hdrc.1.auto: VBUS_ERROR in a_host (91, <VBusValid), retry #1, port1 00000507
> [  661.492518] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1004 with error -110
> [  661.604463] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x1004 with error -110
> [  661.652499] usb 1-1: USB disconnect, device number 2
> [  661.664610] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0500 with error -19
> [  661.705415] ieee80211 ÀáÝ: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -108
> [  661.715004] Unable to handle kernel NULL pointer dereference at virtual address 0000002c
> [  661.723265] pgd = c0004000
> [  661.726028] [0000002c] *pgd=00000000
> [  661.729695] Internal error: Oops: 5 [#1] SMP THUMB2
> [  661.734676] Modules linked in: arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib mac80211 crc_ccitt binfmt_misc cfg80211 rfkill snd_soc_simple_card omap_sham omap_aes usb_f_ecm g_ether usb_f_rndis u_ether libcomposite omap_rng rng_core snd_soc_davinci_mcasp snd_soc_edma snd_soc_omap spi_omap2_mcspi snd_soc_hdmi_codec snd_soc_core snd_pcm_dmaengine snd_pcm snd_timer snd soundcore evdev uio_pdrv_genirq uio tilcdc tda998x
> [  661.772528] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 4.4.6-ti-r15 #1
> [  661.779270] Hardware name: Generic AM33XX (Flattened Device Tree)
> [  661.785482] task: dd8d0d00 ti: dd8e4000 task.ti: dd8e4000
> [  661.790996] PC is at _raw_spin_lock_irqsave+0x14/0x40
> [  661.796235] LR is at rt2x00queue_get_entry+0x1e/0x54 [rt2x00lib]
> [  661.802362] pc : [<c06e2560>]    lr : [<bfa8c99b>]    psr: 800b01b3
> [  661.802362] sp : dd8e5e20  ip : 00000000  fp : dc1dbd80
> [  661.822042] r10: c0b5ba88  r9 : dcda6928  r8 : dcda692c
> [  661.831251] r7 : 00000054  r6 : 0000002c  r5 : 00000000  r4 : 00000002
> [  661.841846] r3 : 00000150  r2 : 0000002c  r1 : 00000001  r0 : 800b0193
> [  661.852429] Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb  Segment none
> [  661.863910] Control: 50c5387d  Table: 9cf24019  DAC: 00000051
> [  661.873715] Process ksoftirqd/0 (pid: 3, stack limit = 0xdd8e4218)
> [  661.883986] Stack: (0xdd8e5e20 to 0xdd8e6000)
> [  661.892443] 5e20: 00000150 00000002 00000000 00000054 ddba6de0 bfab9803 ddba6de0 ddba7144
> [  661.904811] 5e40: dcda6800 00000000 dcda692c bfab9971 00000000 c04fc087 00000000 ddbece80
> [  661.917250] 5e60: dc1dbd80 bfa9c2ff bfa9c2e9 dc1dbd80 000b0113 c04fc1d3 ddf02c38 dc1dbd94
> [  661.929622] 5e80: dcda6924 dd8e5e94 00000000 c04fc2dd 0000000a dd8e5e94 dd8e5e94 dc8ba606
> [  661.941949] 5ea0: dd8e5eb8 dcda6938 00000000 00000000 000f4240 c095df60 c095dfa8 dcda6934
> [  661.954257] 5ec0: 00000018 c0034acf c0b5b098 00000006 c0c29d8c 00000040 dd8e4000 c0b5ba88
> [  661.966568] 5ee0: 00000007 c0034c85 00000000 c06df8db 00000100 dd8e5ee8 c0b5b080 c0c40380
> [  661.978913] 5f00: 0000000a 00016129 c0b5b140 04208040 dd8e4000 dd8e4000 00000000 dd89a9c0
> [  661.991259] 5f20: 00000000 c0b78970 c0b5ba88 ffffe000 00000000 c0034e61 c0034e35 c004a84d
> [  662.003650] 5f40: 00000000 dc8ba606 00000000 dd89aa00 dd89a9c0 c004a791 00000000 00000000
> [  662.016041] 5f60: 00000000 c0047fab 00000001 00000000 dd89a9c0 00000000 00030003 dd8e5f7c
> [  662.028454] 5f80: dd8e5f7c 00000000 00000000 dd8e5f8c dd8e5f8c dc8ba606 ffffffff dd89aa00
> [  662.040848] 5fa0: c0047f01 00000000 00000000 c000ecb5 00000000 00000000 00000000 00000000
> [  662.053271] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  662.065641] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 9ffffefd fffff2de
> [  662.078022] [<c06e2560>] (_raw_spin_lock_irqsave) from [<bfa8c99b>] (rt2x00queue_get_entry+0x1e/0x54 [rt2x00lib])
> [  662.092636] [<bfa8c99b>] (rt2x00queue_get_entry [rt2x00lib]) from [<bfab9803>] (rt2800usb_txstatus_pending+0x1a/0x54 [rt2800usb])
> [  662.112800] [<bfab9803>] (rt2800usb_txstatus_pending [rt2800usb]) from [<bfab9971>] (rt2800usb_tx_sta_fifo_read_completed+0x78/0xe8 [rt2800usb])
> [  662.134536] [<bfab9971>] (rt2800usb_tx_sta_fifo_read_completed [rt2800usb]) from [<bfa9c2ff>] (rt2x00usb_register_read_async_cb+0x16/0x34 [rt2x00usb])
> [  662.156975] [<bfa9c2ff>] (rt2x00usb_register_read_async_cb [rt2x00usb]) from [<c04fc1d3>] (__usb_hcd_giveback_urb+0x4b/0xdc)
> [  662.172846] [<c04fc1d3>] (__usb_hcd_giveback_urb) from [<c04fc2dd>] (usb_giveback_urb_bh+0x79/0xb8)
> [  662.186507] [<c04fc2dd>] (usb_giveback_urb_bh) from [<c0034acf>] (__tasklet_action+0x5b/0xe8)
> [  662.199622] [<c0034acf>] (__tasklet_action) from [<c0034c85>] (__do_softirq+0x85/0x234)
> [  662.212178] [<c0034c85>] (__do_softirq) from [<c0034e61>] (run_ksoftirqd+0x2d/0x40)
> [  662.224369] [<c0034e61>] (run_ksoftirqd) from [<c004a84d>] (smpboot_thread_fn+0xbd/0x124)
> [  662.237125] [<c004a84d>] (smpboot_thread_fn) from [<c0047fab>] (kthread+0xab/0xc0)
> [  662.249299] [<c0047fab>] (kthread) from [<c000ecb5>] (ret_from_fork+0x11/0x1c)
> [  662.261054] Code: 8000 b672 f892 f000 (e852) 3f00
> [  662.277498] ---[ end trace 611c211aed2e4571 ]---
> [  662.286443] Kernel panic - not syncing: Fatal exception in interrupt
> [  662.297072] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
> --
> Craig McQueen
>
