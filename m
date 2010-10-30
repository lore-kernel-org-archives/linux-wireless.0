Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51670 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0J3Lbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 07:31:44 -0400
Received: by bwz11 with SMTP id 11so3264690bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 04:31:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: benjmeier@bluewin.ch
Subject: Re: USB Setup failed (-32)
Date: Sat, 30 Oct 2010 13:31:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <13216803.15461288428531150.JavaMail.webmail@bluewin.ch>
In-Reply-To: <13216803.15461288428531150.JavaMail.webmail@bluewin.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010301331.36591.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 October 2010 10:48:51 benjmeier@bluewin.ch wrote:
> Hello,
> 
> I have a Olimex SAM9-L9260-Board (http://www.olimex.com/dev/sam9-L9260.html), which has an ARM-Processor.
Odd looking thing. The specs says its "USB 2.0", but it does
not support HIGH SPEED, just the USB 1.x FAST SPEED.

> I used many devices on this hardware, mostly over usb
> (UMTS-Modems, Sticks...). Everything worked. I saw that
> i can use the ar9170usb-driver for wireless, so i bought
> a Netgear WN111v2 (http://linuxwireless.org/en/users/Drivers/ar9170).
Actually, AR9170 is nearly EOL, if you're planning to get new gear
then you should stick to ath_htc compatible device.
currently there are lots of cheap AR9271 chips, but in the future
we can except more powerful AR701x/AR9018 solutions too.

> usb 1-1.3: new full speed USB device using at91_ohci and address 3
again, "ohci" and "full speed", whereas on your PC it's more like:
usb x-y: new high speed USB device using ehci_hcd and address z

> usb 1-1.3: firmware: requesting ar9170.fw
> usb 1-1.3: USB setup failed (-32).
> 
> I searched everywhere the errormessage with the errorcode -32, but i didnt find 
> a meaning.
well, -32 is -EPIPE and Documentation/usb/error-codes.txt tells you
that you either hit:

-EPIPE          The pipe type specified in the URB doesn't match the
                endpoint's actual type.
or:

-EPIPE (**)             Endpoint stalled.  For non-control endpoints,
                        reset this status with usb_clear_halt().

(**) This is also one of several codes that different kinds of host
controller use to indicate a transfer has failed because of device
disconnect.  In the interval before the hub driver starts disconnect
processing, devices may receive such fault reports for every request.

my "money" is on the first, because back in March Valentin Longchamp
fixed a problem which closely matches your issue, see:
"setup correct int pipe type in ar9170_usb_exec_cmd"
(Note, this patch went also to -stable), so the question you
should ask yourself: "Is my kernel really up to date?"

Best regards,
	Christian
