Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637Ab3CGRq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 12:46:28 -0500
Date: Thu, 7 Mar 2013 11:46:23 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130307174623.GC24233@thinkpad-t410> (sfid-20130307_184634_449211_2BA7060B)
References: <Pine.LNX.4.44L0.1302251516240.1184-100000@iolanthe.rowland.org>
 <201302260030.58332.chunkeey@googlemail.com>
 <20130226165021.GA19077@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130226165021.GA19077@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:50:21AM -0600, Seth Forshee wrote:
> On Tue, Feb 26, 2013 at 12:30:58AM +0100, Christian Lamparter wrote:
> > On Monday, February 25, 2013 09:19:03 PM Alan Stern wrote:
> > > On Mon, 25 Feb 2013, Seth Forshee wrote:
> > > > > > >ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
> > > > > > >
> > > > > > > [... long period where the device receives commands on EP4 and sends
> > > > > > > wifi data to the host via EP2 - so it is working!]
> > > > > > >
> > > > > > >ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
> > > > > > >ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
> > > > > > >ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion
> > > 
> > > > > Which kernel version are you testing under?  Can you please recompile
> > > > > with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
> > > > > send me dmesg?  I should be able to see if there's an unhandled pending
> > > > > event on the xHCI rings if the data URB stalls for longer than say, a
> > > > > minute.
> > > > 
> > > > I'll do this.
> > > 
> > > Bear in mind that the usbmon trace shows the URB stalling for 2 - 3
> > > seconds.  There may have been other examples that went on for longer,
> > > but probably nothing anywhere near as long as a minute.
> > > 
> > ---
> > This should open up the window for as long as we want it. 
> > The driver will now queue, but not deliver any frames to
> > the device when there are unfinished urbs.
> 
> Here's dmesg with USB debug with the patch. I let it run for at least 5
> minutes after the connection stalled.
> 
> http://people.canonical.com/~sforshee/dmesg-carl9170-usb-debug2.txt

Hi Sarah,

Just wondering if you've had a chance to take a look at this yet.

Thanks,
Seth
