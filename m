Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60913 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750981AbZGJR7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 13:59:34 -0400
Date: Fri, 10 Jul 2009 13:59:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: David Brownell <david-b@pacbell.net>
cc: Ian Lynagh <igloo@earth.li>, <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>
Subject: Re: PROBLEM: USB wlan device stops working; ehci "kernel BUG"
In-Reply-To: <200907101043.49869.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0907101350000.3149-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 10 Jul 2009, David Brownell wrote:

> On Friday 10 July 2009, Ian Lynagh wrote:
> > [582730.178212] kernel BUG at .../drivers/usb/host/ehci-mem.c:74!
> 
> Note that this is a *SECONDARY* failure ... the endpoint hardware
> is still in use, but it should have been shut down already.  So
> the interesting question is:  what was the *PRIMARY* failure?
> 
> So I'd suggest that the WLAN device driver has at least three bugs:
> 
>  1 The error logging should use dev_err() etc so that it shows which
>    USB device it came from; "phy0 -> rt2x00usb_vendor_request" etc
>    just leaves us guessing.
> 
>  2 The first one, which prevented it from working and caused
>    all the syslog spam that wasn't triggered by seeming bugs
>    in userspace code (those "derefnull" and "divbyzero" utils,
>    also "ghc"); presumably the PHY code is at least one issue.
>    Maybe it's just mis-handling something at high speed...
> 
>  3 The driver's likely doing *something wrong* in disconnect().
>    Maybe returning while a control message is outstanding; that
>    might cause the above BUG(), ISTR there was a hole of that
>    shape in the USB stack a few years ago.
> 
> I'm skeptical that the BUG() above would trigger without a driver
> first misbehaving.  This is not a common BUG(); something else
> made it happen.  My guess is #3 above.  The first two seem very
> apparent just from looking at the syslog data provided.

That BUG normally cannot be triggered by a driver error.  It happened
during module unloading, which means all the devices from the root hub
on down must have been removed and their endpoints flushed and
disabled.  If a QH's list is still nonempty, it must be because some
qTD wasn't properly removed -- probably because of the HC_STATE_HALT
setting.

This particular error path has gotten very little testing.  We 
shouldn't be surprised to see that it's not working quite right.

In this case the primary failure was most likely either a hardware bug
in the SB700 controller or (less likely) a bug in the rt73usb driver,
as noted by other people.

Alan Stern

