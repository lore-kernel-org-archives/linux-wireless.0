Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42804 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbYDNM2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 08:28:36 -0400
Subject: Re: Latest compat-wireless build fails
From: Pavel Roskin <proski@gnu.org>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080414085918.5116823b@peterson.fenrir.org.uk>
References: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
	 <20080412104207.478f9f14@fangio.fenrir.org.uk>
	 <1208138233.5319.36.camel@dv>
	 <20080414085918.5116823b@peterson.fenrir.org.uk>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 08:28:33 -0400
Message-Id: <1208176113.522.4.camel@dv> (sfid-20080414_132856_244470_426D8528)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 08:59 +0100, Brian Morrison wrote:

> > blink_set is defined in include/linux/led.h in the wireless-testing
> > kernel.  I assume it's missing in the kernel you are using.
> > 
> 
> Looks like it isn't, so possibly there needs to be a way of providing
> missing headers for kernels without their own complete set. Not sure
> how
> that might be done.

I'm leaving it to Luis.  Most drivers do something with the LEDs, but
only rt2x00 uses the new interface.  Either CONFIG_RT2500PCI_LEDS and 
CONFIG_RT2500USB_LEDS should be explicitly disabled (I guess they are
enabled in your kernel), or the drivers should be patched, or the latest
LED code should be backported to the older kernels.

-- 
Regards,
Pavel Roskin
