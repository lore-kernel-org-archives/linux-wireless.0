Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37569 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752450Ab1BIPTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:19:43 -0500
Date: Wed, 9 Feb 2011 10:19:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sujith <m.sujith@gmail.com>
cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Martin Schleier <drahemmaps@gmx.net>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change
 endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <19793.64449.344588.240418@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.44L0.1102091017370.2050-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 9 Feb 2011, Sujith wrote:

> > The first two problems are the device's fault, and the third is the 
> > driver's fault.  None of them are the fault of usbcore.
> 
> Indeed, which is why this dirty hack is done in the driver.
> And it was done to fix a similar issue - high CPU usage when scanning.
> 
> But do you have any suggestion for such broken devices ?
> The FW changes the type from Interrupt to Bulk, but can the host
> driver continue to use Interrupt URBs and use the URB_NO_INTERRUPT trick
> that you have mentioned ?

Yes.  And it's not a trick; that is exactly what URB_NO_INTERRUPT was 
intended for.

Alan Stern

