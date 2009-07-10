Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:47033 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751048AbZGJRua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 13:50:30 -0400
From: David Brownell <david-b@pacbell.net>
To: Ian Lynagh <igloo@earth.li>
Subject: Re: PROBLEM: USB wlan device stops working; ehci "kernel BUG"
Date: Fri, 10 Jul 2009 10:43:49 -0700
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
References: <20090710143253.GA4133@matrix.chaos.earth.li>
In-Reply-To: <20090710143253.GA4133@matrix.chaos.earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907101043.49869.david-b@pacbell.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 July 2009, Ian Lynagh wrote:
> [582730.178212] kernel BUG at .../drivers/usb/host/ehci-mem.c:74!

Note that this is a *SECONDARY* failure ... the endpoint hardware
is still in use, but it should have been shut down already.  So
the interesting question is:  what was the *PRIMARY* failure?

So I'd suggest that the WLAN device driver has at least three bugs:

 1 The error logging should use dev_err() etc so that it shows which
   USB device it came from; "phy0 -> rt2x00usb_vendor_request" etc
   just leaves us guessing.

 2 The first one, which prevented it from working and caused
   all the syslog spam that wasn't triggered by seeming bugs
   in userspace code (those "derefnull" and "divbyzero" utils,
   also "ghc"); presumably the PHY code is at least one issue.
   Maybe it's just mis-handling something at high speed...

 3 The driver's likely doing *something wrong* in disconnect().
   Maybe returning while a control message is outstanding; that
   might cause the above BUG(), ISTR there was a hole of that
   shape in the USB stack a few years ago.

I'm skeptical that the BUG() above would trigger without a driver
first misbehaving.  This is not a common BUG(); something else
made it happen.  My guess is #3 above.  The first two seem very
apparent just from looking at the syslog data provided.

- Dave
