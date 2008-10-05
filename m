Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752190AbYJEGRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 02:17:43 -0400
Date: Sat, 4 Oct 2008 23:16:03 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081005061603.GB28533@kroah.com> (sfid-20081005_081747_203662_A998164E)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y713y48r.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 08:56:20AM +0300, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> > In my quest to suck drivers into drivers/staging/ I noticed that the
> > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > kernels.
> 
> Yes, that's the original at76_usb driver which has it's own 802.11
> stack. Pavel Rosking was the maintainer of that driver. Based on the
> feedback in linux-wireless I then started porting the driver to use
> mac80211. 
> 
> (Maybe I should have renamed the port to something else than at76_usb
> because having two different drivers with the same name creates
> confusion.)
> 
> > So I was wondering what the status of this driver is, and if I
> > could/should add it to drivers/staging/?
> 
> The original at76_usb is working quite well, but it's unacceptable for
> the mainline because we cannot have two 802.11 stacks in kernel.

I understand this, but for the issue of the drivers/staging/ tree, it's
ok for us to have as many 802.11 stacks in the kernel as we can cram in
there :)

See my previous posts on lkml for details on the staging tree if you
have questions about it.

So for now, if no one really screams, I'll put Pavel's driver into the
drivers/staging/ tree so that users can use their devices.  When your
driver is merged, we can merely delete this driver instead.

Sound good?

> > And, did you merge the USB DFU code into the driver itself?
> 
> Yes, someone implemented it in driver.
> 
> > Having that kind of functionality in the USB core is fine with me if
> > you want me to add that portion there, no reason it needs to be
> > burried in individual drivers.
> 
> USB DFU is a standard? So it seems:
> 
> http://wiki.openmoko.org/wiki/USB_DFU
> 
> Heh, I didn't know this. I though it was some Atmel proprietary
> interface :)

Oh yeah, I wrote portions of that spec, oh so long ago :)

> I might be interested in getting DFU into USB core, because I would
> like to learn more about USB. But first I need to get at76_usb stable.

Fair enough, patches are always welcome.

thanks,

greg k-h
