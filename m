Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:44458 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753756Ab1BFUE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 15:04:57 -0500
Date: Sun, 6 Feb 2011 15:04:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sujith <m.sujith@gmail.com>
cc: Martin Schleier <drahemmaps@gmx.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change
 endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <19790.51491.583675.986658@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.44L0.1102061457400.24963-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 Feb 2011, Sujith wrote:

> Alan Stern wrote:
> > Why do you want to?  Why does changing the endpoint type from interrupt
> > to bulk improve performance?  Yes, the description says that this
> > causes CPU usage to go from 10% to below 1%, but _why_ does it do that?
> > 
> > Maybe the same effect can be achieved simply by changing the interrupt
> > interval instead.
> 
> Well, when the device is plugged in, the USB core recognizes the endpoints
> as interrupt type. Later, in the probe() callback, the FW is uploaded to the
> target and it patches the endpoints' type to bulk. Please correct me if am
> wrong, but I think this mismatch between the host and the target would be
> the cause for the high CPU usage, when the transmission load for that
> endpoint is high.

(Actually, bulk transfers generally cause a higher CPU load than 
interrupt transfers.  But never mind that...)

The problem is that the kernel doesn't know the firmware has been
changed.  The kernel has to be told about this, one way or another.  
Typically the device would disconnect itself from the USB bus briefly,
when starting to run the new firmware.  Or the kernel would be told to
reset the device after the firmware was transferred, after which the
device would start running the new firmware.

Apparently the driver needs to call usb_reset_device() when the
firmware has been transferred.  Following the reset, the kernel will
see that the descriptors have changed and it will reload all of them.  
Then it will know that the endpoint is bulk rather than interrupt.

Alan Stern

