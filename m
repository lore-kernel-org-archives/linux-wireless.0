Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56185 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752869Ab3HIRQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 13:16:02 -0400
Date: Fri, 9 Aug 2013 13:16:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oleksij Rempel <linux@rempel-privat.de>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <52051009.9010001@rempel-privat.de>
Message-ID: <Pine.LNX.4.44L0.1308091310560.1405-100000@iolanthe.rowland.org> (sfid-20130809_191608_560611_26FCC4E1)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Aug 2013, Oleksij Rempel wrote:

> Am 09.08.2013 16:52, schrieb Alan Stern:
> > On Fri, 9 Aug 2013, Oleksij Rempel wrote:
> >
> >>> What about a "get firmware version" sort of thing?  There really should
> >>> be a way for the driver to tell whether the firmware has already been
> >>> updated.
> >>
> >> I was not able to find good direct way to check firmware version. If i
> >> would add some new command then i will get option like: if responding FW
> >> is updated; if not, then dead or old.
> >> How about overwriting iProduct field? Let say, if iProduct == ath9k_htc,
> >> then firmware is updated? Is it more or less acceptable method? I need
> >> to ask this because it is really new for me.
> >
> > Changing the iProduct string descriptor would work, because the
> > descriptors_changed() routine doesn't compare the old value of that
> > string with the new value.  (On the other hand, it does compare the
> > iSerialNumber strings.)
> 
> Just to make sure. You mean, i should avoid changing iSerialNumber 
> because host will initiate usb reset and this device will probably not 
> survive it?

Right.  If the device would survive a reset then there would be no 
problem.

BTW, it is common for new firmware to change the bcdDevice value in the 
device descriptor.  That might be easier than changing a string 
descriptor.

> > Is there any way to read the firmware back from the device?  Then you
> > could check directly.
> 
> No, this device is a SoC with usb client interface based on FUSB200 core 
> (If i'm correct, same core as on carl9170 devices). We can't read memory 
> unless FW provide this service.
> At power on, this device will boot from external or internal ROM and 
> load minimal FW. Without it, USB wont work.
> If i read FW code correctly, it should be responsible for suspend and reset.

How do you tell the device to start running the new firmware after it 
is loaded?  Normally this requires some sort of reset.

Is there any way to prevent the device from losing its firmware during 
a USB reset or suspend?

Alan Stern

