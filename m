Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63505 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab2DYUCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 16:02:05 -0400
Received: by bkuw12 with SMTP id w12so405062bku.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 13:02:03 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Stephen P <srpape@gmail.com>
Subject: Re: AR9170 documentation for a driver port?
Date: Wed, 25 Apr 2012 22:01:50 +0200
Cc: linux-wireless@vger.kernel.org
References: <CADdUxCwt35GQU2j-a4AvvJVS=h93sgBqg09CZNxTivRfbYsqzg@mail.gmail.com>
In-Reply-To: <CADdUxCwt35GQU2j-a4AvvJVS=h93sgBqg09CZNxTivRfbYsqzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204252201.50803.chunkeey@googlemail.com> (sfid-20120425_220210_744695_419F4BC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 25, 2012 09:29:52 PM Stephen P wrote:
> I've looked through carl9170 briefly, but is there anywhere I can find
> an explanation of the USB protocol and documentation about the chipset?
In the headers:
eeprom.h - eeprom layout (i.e.: calibration, gain, ...)
fwcmd.h  - firmware commands (read/write register, set channel, set key, ...)
fwdesc.h - definitions about the firmware descriptor
		 (at first, that's probably not very important)
hw.h     - hardware register file (mostly the MAC registers)
phy.h	- hardware register file (PHY registers)
wlan.h	- definition of the tx and rx headers (and tails)

other than that, there's still the original ar9170 (less complex,
but different firmware) and of course the original vendor driver:
otus. 

So much for carl9170. If you want documents about the chip then
you have to ask a Qualcomm rep.

> Essentially I just want to put the device into monitor mode, be able
> to change channels, etc. Any information would be appreciated.
Actually, you could just capture what the driver does to setup the device
[the userspace usbmon tools can help there] and simply replay the commands.
But if you want, you can of course port the code from phy.c, mac.c into
java and start from there. Good luck!

Regards,
	Chr
