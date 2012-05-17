Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761457Ab2EQKHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 06:07:49 -0400
Received: by bkcji2 with SMTP id ji2so1375239bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 03:07:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex Alouit <alexandre.alouit@gmail.com>
Subject: Re: Module Carl9170, firmware won't load properly
Date: Thu, 17 May 2012 12:07:40 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20120517T011514-623@post.gmane.org>
In-Reply-To: <loom.20120517T011514-623@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205171207.40795.chunkeey@googlemail.com> (sfid-20120517_120803_491952_B7F9EF55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, May 17, 2012 01:19:56 AM Alex Alouit wrote:
> Hello, 
> 
> I want to use an Netgear WN111v2 (AR9170 usb wireless) with Vyatta 6.4, 
> I copied the firmware (http://linuxwireless.org/en/users/Drivers/carl9170), 
> (carl9170-1.fw in /usr/local/lib/firmware version 1.9.2 (kernel 3.0.23)) 
> but it seems that the module doesn't load correctly the firmware. 
that's pretty old. you can go with compat-wireless and a more recent firmware.
> 
> usb 1-1: new high speed USB device number 2 using ehci_hcd 
> usb 1-1: New USB device found, idVendor=0846, idProduct=9001 
> usb 1-1: New USB device strings: Mfr=16, Product=32, SerialNumber=48 
> usb 1-1: Product: USB2.0 WLAN 
> usb 1-1: Manufacturer: ATHER 
> usb 1-1: SerialNumber: 12345 
> usb 1-1: reset high speed USB device number 2 using ehci_hcd 
> usbcore: registered new interface driver carl9170 
> usb 1-1: driver   API: 1.9.2 2011-01-22 [1-1] 
> usb 1-1: firmware API: 1.9.2 2010-12-25 
> usb 1-1: firmware upload failed (-110). 
> 
> It's the module or firmware that is buggy? How can I fix this?

-110 is -ETIMEDOUT (The driver hasn't received the "fw booted" event and the
upload timed out). This can be caused by a faulty module, firmware, linux's
usb subsystem, (Virtual Machine, if you run Vyatta in one) and/or hardware.

Regards,
	Christian
