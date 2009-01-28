Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34932 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZA1Cxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 21:53:34 -0500
Received: by ewy14 with SMTP id 14so2532762ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 18:53:32 -0800 (PST)
Message-ID: <497FC8AA.3030406@gmail.com> (sfid-20090128_035336_800219_57C1E290)
Date: Wed, 28 Jan 2009 03:53:30 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Jason Andryuk <jandryuk@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: p54usb and 2.13.24.0 Firmware fail to probe 1st generation 	(ISL3886
 + net2280)
References: <c4d76b3b0901261942v23a84b65jab3cf59215c45307@mail.gmail.com>	 <c4d76b3b0901261944r13baf3d7o4a06f0372c88f087@mail.gmail.com>	 <c4d76b3b0901271610g7868913egc22de8f6577caee7@mail.gmail.com> <c4d76b3b0901271726v7c74e5bfpeb3bdb02e68c271d@mail.gmail.com>
In-Reply-To: <c4d76b3b0901271726v7c74e5bfpeb3bdb02e68c271d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk wrote:
> On Tue, Jan 27, 2009 at 7:10 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
>> With the below patch, -ETIMEDOUT is returned from usb_interrupt_msg in
>> addition to alen != sizeof(__le32)
>>
>> [   53.876103] usb 4-2: new high speed USB device using ehci_hcd and address 2
>> [   54.008792] usb 4-2: configuration #1 chosen from 1 choice
>> [   54.131230] usb 4-2: firmware: requesting isl3886usb
>> [   54.148759] phy1: p54 detected a LM86 firmware
>> [   54.148765] p54: rx_mtu reduced from 3240 to 2392
>> [   54.148770] phy1: FW rev 2.13.24.0 - Softmac protocol 5.9
>> [   54.148775] phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
>> [   56.316196] usb 4-2: (p54usb) err=-110, alen=0, size=4
>> [   56.316311] p54usb: probe of 4-2:1.0 failed with error -110
>> [   56.316356] usbcore: registered new interface driver p54usb

> Increasing the timeout to 9000 still results in -ETIMEDOUT.  Could the
> firmware just be incompatible with the device?

i'm seeing the same w/ another 1st gen device (t-sinus 154data), so likely yes.

[from an older post]
> Tried the newer fw, but it does not seem to like my hw:
> 
> usb 1-1.1: new full speed USB device using uhci_hcd and address 6
> usb 1-1.1: New USB device found, idVendor=0846, idProduct=4200
> usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1.1: configuration #1 chosen from 1 choice
> usb 1-1.1: firmware: requesting isl3886usb
> phy1: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2392
> phy1: FW rev 2.13.24.0 - Softmac protocol 5.9
> phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> p54usb: probe of 1-1.1:1.0 failed with error -110
> 
> Last one working is:
> 
> usb 1-1.1: new full speed USB device using uhci_hcd and address 5
> usb 1-1.1: New USB device found, idVendor=0846, idProduct=4200
> usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1.1: configuration #1 chosen from 1 choice
> usb 1-1.1: firmware: requesting isl3886usb
> phy0: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2392
> phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: hwaddr 00:30:12:34:45:67, MAC:isl3886 RF:Frisbee
> wmaster0 (p54usb): not using net_device_ops yet
> phy0: Selected rate control algorithm 'minstrel'
> wlan0 (p54usb): not using net_device_ops yet
> mon.ap0 (p54usb): not using net_device_ops yet

artur

