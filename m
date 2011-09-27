Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40987 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1I0Pf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 11:35:56 -0400
Received: from [192.168.78.76] (glasgow.emobix.co.uk [81.187.12.227])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 3A0F96C0110
	for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 11:35:56 -0400 (EDT)
Message-ID: <4E81ED65.7060703@emobix.co.uk> (sfid-20110927_173600_030811_10BD36D0)
Date: Tue, 27 Sep 2011 16:36:05 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: r8712u driver - on ARM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I'm attempting to get some sense from a Realtek 8191S device on
ARM linux.   Using the latest kernel/drivers (3.0.4) I've had
great success on x86 linux, achieving 94Mbit throughput.

On ARM linux, however, the device is barely working.   I can
bring up the firmware (using the 20110818 firmware package):

usb 1-1: new high speed USB device using musb-hdrc and address 2
usb 1-1: New USB device found, idVendor=0bda, idProduct=8172
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: RTL8191S WLAN Adapter
usb 1-1: Manufacturer: Manufacturer Realtek
usb 1-1: SerialNumber: 00e04c000001
r8712u: DriverVersion: v7_0.20100831
r8712u: register rtl8712_netdev_ops to netdev_ops
r8712u: USB_SPEED_HIGH with 4 endpoints
r8712u: Boot from EFUSE: Autoload OK
r8712u: CustomerID = 0x0000
r8712u: MAC Address from efuse = 00:02:72:a7:12:47

# ifconfig wlan0 up
r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
r8712u: 1 RCR=0x153f00e
r8712u: 2 RCR=0x553f00e

I then attempt some basic operations such as an SSID scan.
At this point, I occasionally get a result, but more often than not,
I get no results at all.    There are 7 access points around me, so
it's surprising to get nothing.

Attempting to forcibly connect to anything is also fruitless.

My host is a TI DaVinci DM8168 (OMAP3+toys).   The USB host is not
fantastic, but has been thrashed heavily with other devices and seems
to be reliable in those cases.

I'd appreciate any input and guidance as to what may be the issue here.
There doesn't appear to be a great deal of debug info to be enabled in
the driver, so I'm not sure what more I can add at this point to aid
with resolving the problem.  I fear some long days of pain trying to
track down differences in operation for this device between ARM and x86.

Could I ask if anyone can actually confirm (or deny) this particular
driver/chipset works with an ARM host?

Very many thanks,

Ian.

