Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56035 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967886Ab3HIONx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 10:13:53 -0400
Date: Fri, 9 Aug 2013 10:13:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Christian Lamparter <chunkeey@googlemail.com>
cc: Oleksij Rempel <linux@rempel-privat.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <201308090006.07690.chunkeey@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.1308091011130.1405-100000@iolanthe.rowland.org> (sfid-20130809_161357_910222_672D1993)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Aug 2013, Christian Lamparter wrote:

> > After loading firmware, a reset generally is necessary.  Some devices 
> > will do it themselves; others require you to call usb_reset_device().
> 
> This makes things complicated. Because, as far as I remember,
> usb_reset_device() will cause the current driver to be unbound
> unless its called during .probe, right?

If the driver defines pre_reset and post_reset methods, it won't get 
unbound during a reset.

> You see, ath9k_htc loads its firmware asynchronously in ".probe"
> (ath9k_htc's .probe routine finishes before the firmware is
> retrieved via the firmware loader helper... so part of the
> firmware download is done in a firmware_complete callback
> on a workqueue). 
> 
> So, if we call usb_reset_device there and the driver is unbound
> and later rebound. the next ath9k_htc .probe will start again and
> again and again not knowing that it is already initialized 
> (and we have a loop).
> 
> 
> This could be solved, if the devices changes the usb-id again 
> when a proper "wifi" ath9k_htc firmware was downloaded. So, the
> driver would know that it doesn't have to download and reset
> the device... But we need a "free" USB-ID for that.

What about a "get firmware version" sort of thing?  There really should 
be a way for the driver to tell whether the firmware has already been 
updated.

Alan Stern

