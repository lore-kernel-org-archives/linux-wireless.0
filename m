Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38814 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbZGGQH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:07:29 -0400
Received: by fxm18 with SMTP id 18so5020842fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 09:07:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907071526.n67FQICE002753@barney.it.uc3m.es>
References: <200907071526.n67FQICE002753@barney.it.uc3m.es>
Date: Tue, 7 Jul 2009 17:07:26 +0100
Message-ID: <efe7343f0907070907u42800e51ma3539a82df6ea24d@mail.gmail.com>
Subject: Re: dead RT2501USB ?
From: Luis Correia <luis.f.correia@gmail.com>
To: ptb@cs.bham.ac.uk
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,


On Tue, Jul 7, 2009 at 16:26, Peter Breuer<ptb@inv.it.uc3m.es> wrote:
> Good day
>
> I'm trying to get a 2501 Ralink USB stick working. I've never had any
> success with it in any kernel I've tried.
>
> Right now I have the stick in my athlon 64 bit machine, Linux kernel:
>
>   2.6.30.1,
>
> and a fair bit of debugging compiled. I'd like to tap your
> help on getting it going, or deciding what the matter is.
>
> Firstly: lsusb output:
>
>  Bus 005 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter
>
> (I'll add the verbose output later, but I suspect you're more
> interested in what the driver has to say).
>
>
>
> Loaading the  rt73usb module produces this stack (after a fair old delay
> for the modprobe to come back)
>
> rt73usb                29288  0
> crc_itu_t               2144  1 rt73usb
> rt2x00usb              11360  1 rt73usb
> rt2x00lib              33760  2 rt73usb,rt2x00usb
> led_class               5112  1 rt2x00lib
> input_polldev           4552  1 rt2x00lib
> mac80211              195720  2 rt2x00usb,rt2x00lib
> cfg80211               71000  2 rt2x00lib,mac80211
>
> Dmesg says:
>
>  [ 2108.751153] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -110.
>  [ 2108.782851] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - MAC: 26:e2:39:8d:0d:6d
>  [ 2111.283108] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3000 with error -110.
>  [ 2111.315495] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0000, rev: ffff8800.
>  [ 2111.344071] phy0 -> rt73usb_init_eeprom: Error - Invalid RT chipset detected.
>  [ 2111.365594] phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
>  [ 2111.394416] usbcore: registered new interface driver rt73usb
>
> So it thinks it's not the right chipset. Perhaps I should add an
> identification line somewhere in the code?
>
> Taking the stick out and reinserting it produces better output:
>
>  [ 3047.942955] usb 5-1: USB disconnect, address 2
>  [ 3057.399019] usb 5-1: new high speed USB device using ehci_hcd and address 4
>  [ 3057.691030] usb 5-1: configuration #1 chosen from 1 choice
>  [ 3057.982680] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
>  [ 3057.982687] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
>  [ 3057.982691] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
>  [ 3057.982915] phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
>  [ 3058.026194] phy1: Selected rate control algorithm 'minstrel'
>  [ 3058.057978] Registered led device: rt73usb-phy1::radio
>  [ 3058.108090] Registered led device: rt73usb-phy1::assoc
>  [ 3058.153068] Registered led device: rt73usb-phy1::quality
>  [ 3058.317082] phy1 -> rt2x00lib_request_firmware: Info - Loading
>  firmware file 'rt73.bin'.
>  [ 3058.447020] rt73usb 5-1:1.0: firmware: requesting rt73.bin
>  [ 3058.614883] phy1 -> rt2x00lib_request_firmware: Error - Failed to request Firmware.

You seem to be lacking the rt73.bin firmware file.
Distributions usually ship them or make them available in a package.

But the device may also be wrongly defined and...

>  [ 3059.709337] usbcore: registered new interface driver rt2500usb

could well be a rt2500usb.

Although from the lsusb output, this does really look like a rt73usb chipset:
Bus 005 Device 004: ID 148f:2573 Ralink Technology, Corp. RT2501USB

p.s. if your distro cannot or will not ship this firmware, you can get
the file from Ralink's website and place it where all the other
firmware files are located on your distro (for Fedora is
/lib/firmware):
http://www.ralinktech.com.tw/data/RT71W_Firmware_V1.8.zip


Luis Correia
rt2x00 project admin
