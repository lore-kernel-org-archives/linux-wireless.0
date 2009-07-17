Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:43487 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933909AbZGQBTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 21:19:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so679976and.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 18:19:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 21:19:19 -0400
Message-ID: <9e4733910907161819r4202b06fib34027bba1b672d2@mail.gmail.com>
Subject: missing piece for starting device on embedded system
From: Jon Smirl <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I must be missing a piece of the necessary environment to get wireless
started...
This is an embedded environment that has not had wireless previously.

When I plug my rt73 adapter in:

usb 1-2: USB disconnect, address 6
usb 1-2: new full speed USB device using ppc-of-ohci and address 7
usb 1-2: configuration #1 chosen from 1 choice
phy3 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy3 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy3 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
phy3 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002,
rev: 0002573a.
phy3: Selected rate control algorithm 'minstrel'

-----------

UDEV  [1247788838.265890] add      /class/net/wmaster0 (net)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/net/wmaster0
SUBSYSTEM=net
INTERFACE=wmaster0
IFINDEX=9
SEQNUM=594

UDEV  [1247788838.268243] add      /class/net/wlan0 (net)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/net/wlan0
SUBSYSTEM=net
INTERFACE=wlan0
IFINDEX=10
SEQNUM=595
MATCHADDR=00:18:f3:2f:0a:de
MATCHIFTYPE=1
COMMENT=USB device 0x:0x (rt73usb)

----------

But I never get a request_firmware event. This seems to be because the
adapter 's start() function is never called.

I'm missing some piece of the system - a kernel module or some part of
user space.
Can someone give me a clue on how to debug this?

I though it was missing crda but adding that didn't fix it.

-- 
Jon Smirl
jonsmirl@gmail.com
