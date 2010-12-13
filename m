Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56805.mail.re3.yahoo.com ([66.196.97.79]:30612 "HELO
	web56805.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757584Ab0LMNQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 08:16:39 -0500
Message-ID: <599567.31181.qm@web56805.mail.re3.yahoo.com>
Date: Mon, 13 Dec 2010 05:16:37 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, js@sig21.net,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <AANLkTi=fp3yiFYKBjkMvis4TAdMAc27J-0d=n2VhQMUB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> It should be possible, but what are the exact problems that
> you encounter?
> Is there a difference between going from rt3070sta to
> rt2800usb and vice versa?
> (Please note that the rt2x00 project doesn't maintain the
> rt3070sta
> driver in the staging directory).
Thanks for replying.

I hope these sets of patches ameliorate all of the unplugging and rmmod'ing for the rt2800usb/rt3070.

And yes, I know the rt2x00 project does not cover staging drivers, actually the staging driver adopted by Ubuntu (and others) is in fact rt2870sta and not the rt3070sta (from Ralink), but they both do not allow switching between them and rt2800usb. 
On my system, when rt3070sta is loaded first and then subsequently rmmod'ed to modprobe the rt2800usb the following error occurs:  

[14775.401131] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (300 mBi, 2000 mBm)
[14775.413682] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[14775.418857] Registered led device: rt2800usb-phy0::radio
[14775.421376] Registered led device: rt2800usb-phy0::assoc
[14775.423420] Registered led device: rt2800usb-phy0::quality
[14775.426517] usbcore: registered new interface driver rt2800usb
[14775.449012] udev[4470]: renamed network interface wlan0 to wlan2
[14776.031493] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3240 with error -71.
[14776.605073] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x7014 with error -71.
[14777.173373] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x701c with error -71.
[14777.748941] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x01 failed for offset 0x0000 with error -71.
[14777.748956] phy0 -> rt2800usb_write_firmware: Error - Failed to write Firmware to device.
[14778.307770] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -71.
[14778.876970] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -71.

then the system freezes, partially, meaning for example I cannot issue simple "ifconfig" - this command as well as other commands are inactive. To unlock the system, thus command prompt and so on I have to unplug the device, then dmesg basically is flooding with errors.

LOG:
[15254.800224] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6640 with error -71.
[15255.365301] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x1e48 with error -71.
[15255.939468] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6b24 with error -71.
[15256.507077] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6648 with error -71.
[15257.078835] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x1e50 with error -71.
[15257.650201] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6b28 with error -71.
[15258.216303] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6650 with error -71.
[15258.782110] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x1e58 with error -71.
[15259.131561] usb 5-2.6: USB disconnect, address 6
[15259.131791] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x6b2c with error -19.
[15259.151361] phy0 -> rt2800_wait_bbp_ready: Error - BBP register access failed, aborting.
[15259.151379] phy0 -> rt2800usb_set_device_state: Error - Device failed to enter state 4 (-5).

Now trying vice versa rt2800usb --> rt3070sta:
Interestingly, when rt2800usb is first loaded and then rmmod'ed without unplugging followed by loading of the rt3070sta takes about a minute or so, but the rt3070sta becomes operational. But not always. A repeat of the procedure partially froze the system again. 

Tried with both staging rt2870sta and manually compiled rt3070sta - the result is the same, total or partial system failure, forcing me to plug/unplug the USB chip.

Walter


      
