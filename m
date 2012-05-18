Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57408 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2ERQmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 12:42:22 -0400
Received: by wgbdr13 with SMTP id dr13so2954151wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 09:42:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex Alouit <alexandre.alouit@gmail.com>
Subject: Re: Module Carl9170, firmware won't load properly
Date: Fri, 18 May 2012 18:42:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20120517T011514-623@post.gmane.org> <201205171207.40795.chunkeey@googlemail.com> <loom.20120518T173625-20@post.gmane.org>
In-Reply-To: <loom.20120518T173625-20@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201205181842.16358.chunkeey@googlemail.com> (sfid-20120518_184246_525624_81EF32E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 May 2012 17:41:41 Alex Alouit wrote:
> Christian Lamparter <chunkeey@...> writes:
> > > (carl9170-1.fw in /usr/local/lib/firmware version 1.9.2 (kernel 3.0.23)) 
> > > but it seems that the module doesn't load correctly the firmware. 
> > that's pretty old. you can go with compat-wireless and a more recent firmware.
>
> Same things with Debian Wheezy (kernel 3.2.0-2-amd64) 
> with firmware 1.9.4 and 1.9.5.
> They are more recent.
> 
> [57471.355695] usb 1-1: driver   API: 1.9.4 2011-08-15 [1-1]
> [57471.355707] usb 1-1: firmware API: 1.9.5 2012-03-14
> [57471.456617] usb 1-1: firmware upload failed (-110)
> 
> What do you think I should do?
Depends on what are you doing. From the "-110" consistency
it sounds like you are trying to get the device working 
within a VM (mere USB emulation is known not to work,
if you want to use it in a VM you need a dedicated ehci
for that)

If that's not the case, you could check what's going on
on the usb protocol level. For Linux the easiest way
is probably to load the "usbmon" module and monitor the
traffic between the device and the driver.
(If you don't want to deal with the usb log yourself,
you can capture the data and sent the email to me
(without cc'ing the ML).)

Reagards,
	Christian  
