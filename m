Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757776Ab3BYUTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 15:19:05 -0500
Date: Mon, 25 Feb 2013 15:19:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	<linux-wireless@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
In-Reply-To: <20130225194623.GI13296@thinkpad-t410>
Message-ID: <Pine.LNX.4.44L0.1302251516240.1184-100000@iolanthe.rowland.org> (sfid-20130225_211918_527028_4FE223F0)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Feb 2013, Seth Forshee wrote:

> > > >ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
> > > >
> > > > [... long period where the device receives commands on EP4 and sends
> > > > wifi data to the host via EP2 - so it is working!]
> > > >
> > > >ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
> > > >ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
> > > >ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion

> > Which kernel version are you testing under?  Can you please recompile
> > with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
> > send me dmesg?  I should be able to see if there's an unhandled pending
> > event on the xHCI rings if the data URB stalls for longer than say, a
> > minute.
> 
> I'll do this.

Bear in mind that the usbmon trace shows the URB stalling for 2 - 3
seconds.  There may have been other examples that went on for longer,
but probably nothing anywhere near as long as a minute.

Alan Stern

