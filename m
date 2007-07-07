Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbXGGV20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 17:28:26 -0400
Subject: Re: Errors when firmware is missing
From: Dan Williams <dcbw@redhat.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200707072037.44582.mb@bu3sch.de>
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
	 <468FD6B2.6000408@lwfinger.net>  <200707072037.44582.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 17:33:08 -0400
Message-Id: <1183843988.16396.0.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-07-07 at 20:37 +0200, Michael Buesch wrote:
> On Saturday 07 July 2007 20:08:50 Larry Finger wrote:
> > Jon Smirl wrote:
> > > I have a new Broadcom 4318 adapter (which has exactly the same issues
> > > with promiscuous mode). I didn't have the right firmware down for it
> > > and I received this error message when I did "ifconfig wlan up"
> > > SIOCSIFFLAGS: No such file or directory.  This is not the most user
> > > friendly error message, but I did receive a log entry.
> > 
> > If the firmware did not load correctly, the bcm43xx driver logs appropriate messages. This error 
> > would have been encountered and logged when the interface was brought up. Is that what you meant 
> > when you say that you received a log entry? The ifconfig error message is output by the user code, 
> > and is not controlled by any driver.
> 
> Well it is. It's -ENOENT, which we return in the driver.
> I'd like to return, -ENOFIRMWARE, but there's no such error.
> So I selected the most sane error code (to me), which says
> file not found...

This should be what all drivers do; if, when setting IFF_UP, the device
can't find firmware, it should return -ENOENT, which is the return code
from request_firmware() when it fails to find the firmware.  Thus,
userspace can detect that firmware is missing and attempt to
intelligently inform the user.

Dan


