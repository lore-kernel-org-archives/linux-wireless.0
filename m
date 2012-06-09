Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2FIMi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 08:38:56 -0400
Received: by bkcji2 with SMTP id ji2so2457795bkc.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 05:38:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 9 Jun 2012 14:38:54 +0200
Message-ID: <CAA5E3zs-145DmcOVKEPiWj0Dd8OYGhM7ONsywjBJ+yynEW+uvA@mail.gmail.com> (sfid-20120609_143932_399838_647F4AF1)
Subject: ath9k_htc - USB disconnects / Target is unresponsive
From: Loris <lboillet69@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a few STBs (Intel Atom CE41xx) each equipped with a Netgear
WNA1100 USB dongle. The dongle is running in AP mode using ath9k_htc
from compat-wireless 3.3.2-n.

On some of these STBs, I get recurring "USB disconnect/new usb device"
cycles on the port to which the dongle is connected, even though the
STB is *not* physically touched:

hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
ehci_hcd 0000:01:0d.0: GetStatus port:1 status c00100a 6  ACK POWER
sig=se0 PEC CSC
hub 1-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
usb 1-1: USB disconnect, device number 2

Then kernel logs lots of ehci_hcd messages like this:

ehci_hcd 0000:01:0d.0: detected XactErr len 0/64 retry 1
ehci_hcd 0000:01:0d.0: detected XactErr len 0/16384 retry 1

and eventually the dongle gets recognized again, until the
"disconnect/recognized again" cycle happens again (usually it's a
matter of seconds or minutes between each cycle).

A particularly annoying consequence is that after one or more of these
cycles (most often 2 or 3), I get into this situation:

ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
Failed to initialize the device
ath9k_htc: probe of 1-1:1.0 failed with error -22
drivers/usb/core/inode.c: creating file '004'
hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002

And only a hard reboot or plugging out / plugging in the dongle can
get the dongle back to a usable state.

This is exactly like what is described in this thread:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/87802

(FWIW, I also have the exact same behaviour as what is described in
that post of this same thread:
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/87865;
I am also working around this by bringing up the interface as soon as
the modules are loaded.

Now what I am wondering (before further investigating) is if ath9k_htc
(or the device's firmware) is only receiving this USB disconnect event
or if in any way if could have been what triggers it. I have not seen
yet any other device than the wifi dongle showing this issue on the
same STBs.

Any clues?

Thanks,

Loris

Linux 2.6.39 #1 SMP PREEMPT i686 GNU/Linux

usb 1-1: New USB device found, idVendor=0846, idProduct=9030
usb 1-1: New USB device strings: Mfr=16, Product=32, SerialNumber=48
usb 1-1: Product: WNA1100
usb 1-1: Manufacturer: NETGEAR WNA
usb 1-1: SerialNumber: 12345
