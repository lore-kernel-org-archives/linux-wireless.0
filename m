Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:56899 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZA1A2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 19:28:09 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2903619yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 16:28:08 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 27 Jan 2009 19:28:07 -0500
Message-ID: <c4d76b3b0901271628q7710a272xdcf487ee5779f154@mail.gmail.com> (sfid-20090128_012814_710002_E143841B)
Subject: at76_usb fails to load firmware on Linksys WUSB11
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A change is preventing my old Linksys WUSB11 from loading its
firmware.  It was working in 2.6.28.

Below are two dmesg snippets.  The first is the 2.6.29-rc2-wl failure
to load and the second is the successful 2.6.28 era.  Notice that the
firmware reported in 2.6.28 is different from the one that the kernel
attempts to load.

I believe the WUSB11 actually has firmware stored in flash on the
device.  Linksys downloads for WUSB11 v1 include a firmware update for
WUSB11 v. 1 which I believe the device to be.  No explicit version is
reported.

Tested on wireless-testing master-2009-01-26.

Jason

2.6.29-rc2-wl

[  121.704098] usb 5-1: new full speed USB device using uhci_hcd and address 2
[  121.857426] usb 5-1: configuration #1 chosen from 1 choice
[  121.950007] at76_usb: module is from the staging directory, the
quality is unknown, you have been warned.
[  121.957247] Atmel at76x USB Wireless LAN Driver 0.17 loading
[  121.957304] usb 5-1: firmware: requesting atmel_at76c503-i3861.bin
[  121.984135] usb 5-1: using firmware atmel_at76c503-i3861.bin
(version 0.90.0-44)
[  121.987186] usb 5-1: downloading internal fw failed with -22
[  121.987204] at76_usb 5-1:1.0: error -22 downloading internal firmware
[  121.987223] at76_usb: probe of 5-1:1.0 failed with error -22
[  121.987270] usbcore: registered new interface driver at76_usb

2.6.28:

Jan 12 20:47:35 rainbow kernel: [  509.084123] usb 4-2: new full speed
USB device using uhci_hcd and address 2
Jan 12 20:47:35 rainbow kernel: [  509.233741] usb 4-2: configuration
#1 chosen from 1 choice
Jan 12 20:47:35 rainbow kernel: [  509.360214] at76_usb: module is
from the staging directory, the quality is unknown, you have been
warned.
Jan 12 20:47:35 rainbow kernel: [  509.367532] Atmel at76x USB
Wireless LAN Driver 0.17 loading
Jan 12 20:47:35 rainbow kernel: [  509.367587] usb 4-2: firmware:
requesting atmel_at76c503-i3861.bin
Jan 12 20:47:35 rainbow kernel: [  509.399173] usb 4-2: using firmware
atmel_at76c503-i3861.bin (version 0.90.0-44)
Jan 12 20:47:35 rainbow kernel: [  509.403102] wlan1: USB 4-2:1.0, MAC
00:06:25:00:6a:7a, firmware 0.90.0-2
Jan 12 20:47:35 rainbow kernel: [  509.403108] wlan1: regulatory
domain 0x10: FCC (USA)
Jan 12 20:47:35 rainbow kernel: [  509.403579] usbcore: registered new
interface driver at76_usb
