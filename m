Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:33482 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2LNJjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 04:39:03 -0500
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id A760834022D
	for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 09:28:50 +0000 (GMT)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9LS0AogCSkax for <linux-wireless@vger.kernel.org>;
	Fri, 14 Dec 2012 09:28:50 +0000 (GMT)
Received: from eds-macbook-pro.nippynetworks.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id E1FCA340235
	for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 09:28:47 +0000 (GMT)
Message-ID: <50CAF150.8050404@wildgooses.com> (sfid-20121214_103910_086965_9DDE456E)
Date: Fri, 14 Dec 2012 09:28:48 +0000
From: Ed W <lists@wildgooses.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with USB RT2870 (especially with a hub)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I'm using a high power 2W ralink 2870 based card on kernel 3.2.24

After "some time", usually more frequently than daily I will get some 
kind of USB event and the device starts giving the error messages shown 
below. However, curiously I can trigger this to happen more frequently 
if I connect various high power devices to the bus, eg 3G dongles, or if 
I put the ralink on an unpowered hub (double trouble if I connect a 3G 
card to the unpowered hub also). Using the external hub I can usually 
trigger this event within 10-15 minutes or less.

The rt2870 is connected to a PC Engines Alix 2D13 board, which may or 
may not have the highest power USB output... Certainly given that 
putting it and other things on an unpowered hub increases the frequency 
of the event suggests that there might be some kind of bus reset or 
similar going on from time to time?

Unplugging the USB cable and replugging gets everything going again for 
a while.

Can anyone advise on how I might debug this further and more 
specifically how I might look to fix the driver so that it can survive 
these events, eg resetting itself or whatever?

Thanks for your thoughts

Ed W


[ 1366.773220] usb 1-2.1.2: new high-speed USB device number 10 using 
ehci_hcd
[ 1366.886905] usb 1-2.1.2: New USB device found, idVendor=148f, 
idProduct=3070
[ 1366.886936] usb 1-2.1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 1366.886961] usb 1-2.1.2: Product: 802.11 n WLAN
[ 1366.886980] usb 1-2.1.2: Manufacturer: Ralink
[ 1366.886999] usb 1-2.1.2: SerialNumber: 1.0
[ 1366.959255] usb 1-2.1.2: reset high-speed USB device number 10 using 
ehci_hcd
[ 1367.089973] ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
[ 1367.090232] Registered led device: rt2800usb-phy3::radio
[ 1367.090232] Registered led device: rt2800usb-phy3::assoc
[ 1367.090232] Registered led device: rt2800usb-phy3::quality
[ 1368.102806] ADDRCONF(NETDEV_UP): wlan1: link is not ready
...
[15341.418076] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x06 failed for offset 0x101c with error -110.
[15391.728468] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x1004 with error -110.
[15442.072138] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x06 failed for offset 0x1004 with error -110.
[15492.303784] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0438 with error -110.
[15542.584686] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0438 with error -110.
... repeats ...
[21722.478820] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0500 with error -110.
[21772.803669] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0500 with error -110.
[21823.128895] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0500 with error -110.
[21823.129032] phy3 -> rt2x00usb_regbusy_read: Error - Indirect register 
access failed: offset=0x00000500, value=0xceeff264
[21873.378671] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0500 with error -110.
[21923.660712] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 
0x07 failed for offset 0x0500 with error -110.


The "usb_regbusy_read" is occasional and the "value" varies
