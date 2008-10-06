Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751559AbYJFSpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:45:33 -0400
Date: Mon, 6 Oct 2008 11:35:20 -0700
From: Greg KH <greg@kroah.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081006183520.GA17647@kroah.com> (sfid-20081006_204537_249054_C5455445)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 11:23:13AM -0400, Dan Williams wrote:
> On Sat, 2008-10-04 at 23:16 -0700, Greg KH wrote:
> > On Sun, Oct 05, 2008 at 08:56:20AM +0300, Kalle Valo wrote:
> > > Greg KH <greg@kroah.com> writes:
> > > > In my quest to suck drivers into drivers/staging/ I noticed that the
> > > > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > > > kernels.
> > > 
> > > Yes, that's the original at76_usb driver which has it's own 802.11
> > > stack. Pavel Rosking was the maintainer of that driver. Based on the
> > > feedback in linux-wireless I then started porting the driver to use
> > > mac80211. 
> > > 
> > > (Maybe I should have renamed the port to something else than at76_usb
> > > because having two different drivers with the same name creates
> > > confusion.)
> > > 
> > > > So I was wondering what the status of this driver is, and if I
> > > > could/should add it to drivers/staging/?
> > > 
> > > The original at76_usb is working quite well, but it's unacceptable for
> > > the mainline because we cannot have two 802.11 stacks in kernel.
> > 
> > I understand this, but for the issue of the drivers/staging/ tree, it's
> > ok for us to have as many 802.11 stacks in the kernel as we can cram in
> > there :)
> 
> Well, you have to ask yourself then, what's the point of putting that
> driver with it's own 802.11 stack into staging when it's never going to
> go into the mainline kernel until it uses mac80211?

Because at least 2 distros currently ship their kernels with it (Fedora
and Ubuntu), and people have that hardware today and want to use it with
Linux.

> Doesn't that direct effort away from porting the driver to mac80211,
> giving legitimacy to code that will never, ever get upstream until
> it's substantially rewritten anyway?  Ideally we put Kalle's 802.11
> port in staging and then people can actually move things forward.
> 
> Same thing for linux-wlan-ng really; if people just keep fixing bugs and
> keep improving p80211 without porting it to the standard kernel wireless
> bits, what's the point of having it in staging?

Users using their hardware with Linux today.

I'll gladly drop it from drivers/staging when the "real" version hits
mainline, until then, it should stay in staging, as that is the whole
point of it.

thanks,

greg k-h
