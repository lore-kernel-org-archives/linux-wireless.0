Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63958 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab0CJFhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:37:10 -0500
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
From: Pavel Roskin <proski@gnu.org>
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201003060342.19623.malte.gell@gmx.de>
References: <201003040835.29387.malte.gell@gmx.de>
	 <1267827995.3068.33.camel@mj>  <201003060342.19623.malte.gell@gmx.de>
Content-Type: text/plain
Date: Wed, 10 Mar 2010 00:37:08 -0500
Message-Id: <1268199428.17677.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-06 at 03:42 +0100, Malte Gell wrote:
> Pavel Roskin <proski@gnu.org> wrote
> 
> > On Thu, 2010-03-04 at 08:35 +0100, Malte Gell wrote:
> > > Hello,
> > >
> > > I just upgraded from Kernel 2.6.32 to 2.6.33 and the ar9170 driver
> > > suddenly says "firmware file not found". 
>  
> Ok, this is what the kernel says:
> 
>  <6>[   12.020028] usb 1-3: firmware: requesting ar9170.fw
> <3>[   72.050094] usb 1-3: ar9170.fw firmware file not found, trying old 
> firmware...
> <6>[   72.066421] usb 1-3: firmware: requesting ar9170-1.fw
> <3>[  132.080085] usb 1-3: file with init values not found.
> <4>[  132.096535] ar9170usb: probe of 1-3:1.0 failed with error -2
> <6>[  132.113558] usbcore: registered new interface driver ar9170usb
> 
> I have the same firmware in /lib/firmware I use with 2.6.32 and it is actually a 
> Fritz WLAN N stick...

Oh, I see.  I misunderstood you.  When you mentioned that you get the
message "firmware file not found", I thought you were getting that
message without the firmware name.  Indeed, the driver can print it
under some rare circumstances, but it's not the case here.

I should have asked you for the exact kernel log output before delving
into the sources and trying to guess what is happening.  That serves me
a lesson.

So you have a case of the firmware not loading at all.  I'm pretty sure
the problem lies outside the driver, and likely outside the kernel.

-- 
Regards,
Pavel Roskin
