Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:35388 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754849Ab0DSQN4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 12:13:56 -0400
Message-ID: <79507.95340.qm@web56807.mail.re3.yahoo.com>
Date: Mon, 19 Apr 2010 09:13:56 -0700 (PDT)
From: Walter <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Thats odd, in compar-wireless, it already contains the
> lines:
> 
> #ifdef CONFIG_RT2800USB_RT30XX
>     <..snip..>
>     /* Ralink */
>     { USB_DEVICE(0x148f, 0x2070),
> USB_DEVICE_DATA(&rt2800usb_ops) },
>     { USB_DEVICE(0x148f, 0x3070),
> USB_DEVICE_DATA(&rt2800usb_ops) },
>     { USB_DEVICE(0x148f, 0x3071),
> USB_DEVICE_DATA(&rt2800usb_ops) },
>     { USB_DEVICE(0x148f, 0x3072),
> USB_DEVICE_DATA(&rt2800usb_ops) },
>     <..snip..>
> #endif
> 
> So adding the USB ID does not need to be added.
> 
> Ivo

It is odd. I followed exactly the same logic you have, but I'm adamant the module doesn't recognize the VID of card as it is. Lets get factual:

compat-wireless from March 28th. default install (make && make install) here is the output when the rt2800usb is loaded:

[21902.553231] Generic kernel compatibility enabled based on linux-next next-20100113
[21902.596351] cfg80211: Calling CRDA to update world regulatory domain
[21902.695076] usbcore: registered new interface driver rt2800usb
[21902.714019] cfg80211: World regulatory domain updated:
[21902.714026]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[21902.714032]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[21902.714036]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[21902.714041]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[21902.714045]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[21902.714050]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

modinfo rt2800usb |grep 3070 -- returns nothing

as soon as I add the 148f:rt3070 to: 

    /* Ralink */
    { USB_DEVICE(0x148f, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
    { USB_DEVICE(0x148f, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
    { USB_DEVICE(0x148f, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) }, <--- manually added
       /* Samsung */

rt2800usb recognizes the chip and initializes all operations:

[22310.272382] usb 5-2.4: new high speed USB device using ehci_hcd and address 10
[22310.381269] usb 5-2.4: configuration #1 chosen from 1 choice
[22310.416482] phy1: Selected rate control algorithm 'minstrel'
[22310.417403] Registered led device: rt2800usb-phy1::radio
[22310.417456] Registered led device: rt2800usb-phy1::assoc
[22310.417505] Registered led device: rt2800usb-phy1::quality
[22310.479159] udev: renamed network interface wlan0 to wlan2
[22310.483779] rt2800usb 5-2.4:1.0: firmware: requesting rt2870.bin

Now, modinfo rt2800usb |grep 3070 -- shows its OK:

alias:          usb:v148Fp3070d*dc*dsc*dp*ic*isc*ip*


This is a longstanding bug from at least few months or so,  I thought you were experimenting/adjusting the code and I figured it would be temporary, but it has been so long that I thought I had to report this now.

Walter.



      
