Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vpn.innerrange.com.au ([203.122.143.146]:59155 "EHLO
	remote.innerrange.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751376AbcFFG5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 02:57:11 -0400
From: Craig McQueen <craig.mcqueen@innerrange.com>
To: Vishal Thanki <vishalthanki@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 6 Jun 2016 16:56:58 +1000
Subject: RE: rt2800 and BeagleBone Black kernel panic when connecting to
 access point
Message-ID: <5500469A22567C4BAF673A6E86AFA3A4022D2A09640A@IR-CENTRAL.corp.innerrange.com> (sfid-20160606_085715_901294_32B07E66)
References: <5500469A22567C4BAF673A6E86AFA3A4022D20C813C8@IR-CENTRAL.corp.innerrange.com>
 <20160427052758.GA3583@localhost.localdomain>
In-Reply-To: <20160427052758.GA3583@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vishal Thanki wrote on 27 April 2016:
> On Wed, Apr 27, 2016 at 02:21:36PM +1000, Craig McQueen wrote:
> > I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
> chipset). I've been testing it on a BeagleBone Black running an Ubuntu 16.04
> image (4.4.6 kernel).
> >
> > 1) Install Ubuntu 16.04 on a BeagleBone Black.
> > 2) Add lines to /etc/network/interfaces for the device to connect to a
> WPA2 access point.
> > 3) Plug the rt2800 USB Wi-Fi device into the BeagleBone Black.
> >
> > Apparently when it tries to connect to the access point, I get a kernel panic.
> If I don't configure it (step 2 above) then the kernel panic doesn't happen.
> >
> > I've tested this with two access points: my Android phone acting as a
> hotspot, and a cheap TP-Link TD-W8968.
> >
> > Serial debug console shows:
> >
> > [  306.884793] ieee80211 phy0: rt2x00usb_vendor_request: Error -
> > Vendor Request 0x07 failed for offset 0x1004 with error -110 [
> > 306.996804] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor
> > Request 0x06 failed for offset 0x1004 with error -110 [  307.057021]
> > ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07
> > failed for offset 0x0500 with error -19 [  307.102417] Unable to
> > handle kernel NULL pointer dereference at virtual address 0000002c [
> > 307.110768] pgd = ddd34000 [  307.113555] [0000002c] *pgd=00000000 [
> > 307.117257] Internal error: Oops: 5 [#1] SMP THUMB2 [  307.122269]
> > Modules linked in: arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib
> > mac80211 crc_ccitt cfg80211 rfkill snd_soc_simple_card omap_aes
> > omap_sham usb_f_ecm g_ether usb_f_rndis u_ether libcomposite
> omap_rng
> > rng_core snd_soc_davinci_mcasp snd_soc_edma snd_soc_omap
> spi_omap2_mcspi snd_soc_hdmi_codec snd_soc_core snd_pcm_dmaengine
> snd_pcm snd_timer snd soundcore evdev uio_pdrv_genirq uio tilcdc tda998x
> [  307.159448] CPU: 0 PID: 875 Comm: wpa_supplicant Not tainted 4.4.6-ti-r15
> #1 [  307.166672] Hardware name: Generic AM33XX (Flattened Device Tree) [
> 307.172921] task: dcf56180 ti: dd8e6000 task.ti: dd8e6000 [  307.178470] PC is
> at _raw_spin_lock_irqsave+0x14/0x40 [  307.183755] LR is at
> rt2x00queue_get_entry+0x1e/0x54 [rt2x00lib]
> > [  307.189928] pc : [<c06e2560>]    lr : [<bfa9b99b>]    psr: 800b01b3
> > [  307.189928] sp : dd8e79a0  ip : 00000000  fp : dc94f900 [
> > 307.201687] r10: c0b5ba88  r9 : dcda6928  r8 : dcda692c [  307.207042]
> > r7 : 00000054  r6 : 0000002c  r5 : 00000000  r4 : 00000002 [
> > 307.213731] r3 : 00000150  r2 : 0000002c  r1 : 00000001  r0 : 800b0193
> > [  307.220423] Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb
> > Segment none [  307.228007] Control: 50c5387d  Table: 9dd34019  DAC:
> > 00000051 [  307.233896] Process wpa_supplicant (pid: 875, stack limit
> > = 0xdd8e6218) [  307.240675] Stack: (0xdd8e79a0 to 0xdd8e8000) [
> > 307.245159] 79a0: 00000150 00000002 00000000 00000054 ddf26de0
> > bfac8803 ddf26de0 ddf27144 [  307.253559] 79c0: dcda6800 00000000
> > dcda692c bfac8971 00000000 c04fc087 c000a439 dde057c0 [  307.261945]
> > 79e0: dc94f900 bfaab2ff bfaab2e9 dc94f900 000b0113 c04fc1d3 ddcc4038
> > dc94f914 [  307.270331] 7a00: dcda6924 dd8e7a14 00000000 c04fc2dd
> > df925d8c dd8e7a14 dd8e7a14 dc8ba606 [  307.278715] 7a20: df925d80
> > dcda6938 00000000 00000000 000f4240 c095df60 c095dfa8 dcda6934 [
> > 307.287099] 7a40: 00000018 c0034acf c0b5b098 00000006 c0c29d8c
> > 00000040 dd8e6000 dd8e7b90 [  307.295483] 7a60: 00000007 c0034c85
> > 004c4b29 00000000 00000101 dd8e7a68 c0b5b080 c0c40380 [  307.303889]
> > 7a80: 0000000a 000006e1 c0b5b140 00400140 c00856ed 200b0113 ffffe000
> > dddfc2bc [  307.312282] 7aa0: 00000000 00000304 dd8e7b90 ddf0e840
> > 0000000f c0034ea7 000001ff c0034f33 [  307.320666] 7ac0: 0000001e
> > dddfc000 da84ec40 c0628085 dd8e7ca0 dddfc090 60000013 00000000 [
> > 307.329050] 7ae0: da84ec40 dd8e7b90 ddf0e840 00000005 00000000
> > ddf0e840 0000000f c05f11e5 [  307.337437] 7b00: 00000000 00000020
> > 00007ea0 ddf0e840 00000020 c014402d 00000000 00007ea0 [  307.351143]
> > 7b20: 00000000 00000000 00000000 dd8e7e50 dd8e7e4c dd8e7e48
> dd8e7e40
> > dd8e7e44 [  307.364750] 7b40: dd8e7e48 00000000 00000000 00000000
> > 00000000 00000000 024152c0 dd8e7e24 [  307.378341] 7b60: c0b5d930
> > 00000000 dd8e7f74 dd8e7b88 c0b5ba88 dd8e6000 004c4b29 00000000 [
> > 307.391976] 7b80: 00000001 3b9aca00 a6ad6574 00000048 00000000
> > 000000db 00000000 dcf56180 [  307.405640] 7ba0: 00000000 00000000
> > 00000008 ddf0e840 000000db 00000000 dd8e7b90 c01439a1 [  307.419316]
> > 7bc0: dc026784 dc026784 dc026780 ddf4bcc0 000000db 00000000 dd8e7b90
> > c01439a1 [  307.433008] 7be0: dc026204 dc026204 dc026200 ddf4bf00
> > 000000db 00000000 dd8e7b90 c01439a1 [  307.446684] 7c00: dc02612c
> > dc02612c dc026128 ddf4bc00 000000db 00000000 dd8e7b90 c01439a1 [
> > 307.460325] 7c20: dc026984 dc026984 dc026980 dc060cc0 000000db
> > 00000000 dd8e7b90 c01439a1 [  307.473925] 7c40: dc026144 dc026144
> > dc026140 dc0603c0 000000db 00000000 dd8e7b90 c01439a1 [  307.487339]
> > 7c60: ddb1b104 ddb1b104 ddb1b100 dc0609c0 000000db 00000000
> dd8e7b90
> > c01439a1 [  307.500597] 7c80: dde03844 dde03844 dde03840 dc060e40
> > 000000db 00000000 dd8e7b90 c01439a1 [  307.513712] 7ca0: dde037c4
> > dde037c4 dde037c0 ddb7b000 dcf0c480 c0627d0b 00000004 00000002 [
> > 307.526882] 7cc0: ffffffed dc8ba606 dc138f00 ddb7b000 dcf0c300
> > dd8e7d10 dc138f00 dcf0c300 [  307.539972] 7ce0: 00000000 c06281c9
> > dd8e7d10 c06e1163 c0b5ba88 c06e1163 bf99f4cc c062a553 [  307.553056]
> > 7d00: 00000000 c0c25540 000000cc c00583d7 c0629e85 c0629e4d bf99726c
> > bf9a7980 [  307.566185] 7d20: 00000000 dd8e6000 c06ec750 00000000
> > dcd2e8a0 00000000 00000000 dd8e6000 [  307.579343] 7d40: c0b5cb94
> > c0b5ba88 024200ca dc8ba606 dcdadb00 dc138f00 dcf0c300 c05fb77d [
> > 307.592434] 7d60: dd8e7de0 c05fb81f dcf0c300 00000000 dd8e7de0
> > c00f8b8b dfda1340 dfda1460 [  307.605436] 7d80: 00000003 c00f8ccf
> > 00000008 00000000 40000093 c001a411 0009a5fd 9a5fd18f [  307.618349]
> > 7da0: dde007bc 00000000 00000000 c00f451f dfd22794 00000000 00000000
> > dc8ba606 [  307.631178] 7dc0: dfd22794 00000001 da8b0960 c00f451f
> > 00000000 00000000 00000000 7f5e0000 [  307.643956] 7de0: 0000014f
> > 00000000 0014f000 dc8ba606 00000070 00000004 dd8e7e3c c0b5ba88 [
> > 307.656720] 7e00: 0000000f 7fdbf350 7fdbf3d8 dd8e7e3c 7fdbf948
> > c014434d dd8e7f74 00000051 [  307.669494] 7e20: 00000070 dd8e7e3c
> > dd8e7e40 dd8e7e44 dd8e7e48 dd8e7e4c dd8e7e50 00007ea0 [  307.682259]
> > 7e40: 00000000 00000000 00000000 00000000 00000000 ddfb0c74 7f5e0000
> > dde00000 [  307.695032] 7e60: ddcaa000 00000000 00000054 00000061
> > 7f5e0000 ffffe000 00000000 00000070 [  307.707785] 7e80: dde00780
> > dc8ba606 00000000 dd8e7fb0 dcf56180 80000007 7f5e07fc ddfb0c40 [
> > 307.720566] 7ea0: dcd2e720 ddfb0c78 00000054 c06e349b 00000000
> > 00000000 7f6dcad8 c05f2b6d [  307.733379] 7ec0: dd8e7ee0 00000000
> > 00000000 00000000 00000000 000008fc dd8e7f04 c008a4db [  307.746185]
> > 7ee0: 04f2e6a2 00000000 a8e0fcc7 ffffffff ffffffff c0143dfb 00000133
> > 0207683c [  307.759065] 7f00: 8dbe2200 c0b5ba88 dd8e7f74 3b9a9738
> > 00000004 dd8e7f30 7fdbf948 c0143dfb [  307.771961] 7f20: 7f6dcad8
> > 00000004 3b9a9738 c0b5ba88 00000138 02073574 00000004 dc8ba606 [
> > 307.784855] 7f40: 0207683c bed1db24 c0b5ba88 0000000f 7fdbf350
> > 7fdbf3d8 7fdbf948 dd8e7f74 [  307.797776] 7f60: 7f6dcad8 c0144645
> > dd8e7f74 00000107 c000eda4 00000138 02073574 00000004 [  307.810714]
> > 7f80: 000f4233 dc8ba606 bed1db24 7fdbf298 7f6dcad8 0000008e c000eda4
> > dd8e6000 [  307.823633] 7fa0: 00000000 c000ebe1 bed1db24 7fdbf298
> > 0000000f 7fdbf350 7fdbf3d8 7fdbf948 [  307.836538] 7fc0: bed1db24
> > 7fdbf298 7f6dcad8 0000008e 7fdb1568 7fdbf350 7fdbf3d8 7f6dcad8 [
> > 307.849434] 7fe0: 00000000 bed1daf0 7f599bf3 b6cdc548 00000030
> > 0000000f ff76fea7 ffff88ef [  307.862403] [<c06e2560>]
> > (_raw_spin_lock_irqsave) from [<bfa9b99b>]
> > (rt2x00queue_get_entry+0x1e/0x54 [rt2x00lib])
> 
> I have seen a similar crash and fixed it as a part of following commit:
> 
> 8b4c0009313f3d42e2540e3e1f776097dd0db73d
> 
> But it would be helpful if you can get paste the entire kernel log.
> Because in my case, I used to see a USB Disconnect event for the rt2800
> driver and the crash was caused due to that.

I finally got around to trying a build of the kernel with that patch applied. However, it did not fix this problem. The device still causes a kernel crash when it is plugged directly into the USB port without a hub in between.

-- 
Craig McQueen

