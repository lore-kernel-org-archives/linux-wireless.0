Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYJFUNQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:13:16 -0400
Subject: Re: at76_usb driver status
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081006183520.GA17647@kroah.com>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com>
	 <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
	 <20081006183520.GA17647@kroah.com>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 16:12:20 -0400
Message-Id: <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081006_221320_392191_1110A772)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-06 at 11:35 -0700, Greg KH wrote:
> On Mon, Oct 06, 2008 at 11:23:13AM -0400, Dan Williams wrote:
> > On Sat, 2008-10-04 at 23:16 -0700, Greg KH wrote:
> > > On Sun, Oct 05, 2008 at 08:56:20AM +0300, Kalle Valo wrote:
> > > > Greg KH <greg@kroah.com> writes:
> > > > > In my quest to suck drivers into drivers/staging/ I noticed that the
> > > > > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > > > > kernels.
> > > > 
> > > > Yes, that's the original at76_usb driver which has it's own 802.11
> > > > stack. Pavel Rosking was the maintainer of that driver. Based on the
> > > > feedback in linux-wireless I then started porting the driver to use
> > > > mac80211. 
> > > > 
> > > > (Maybe I should have renamed the port to something else than at76_usb
> > > > because having two different drivers with the same name creates
> > > > confusion.)
> > > > 
> > > > > So I was wondering what the status of this driver is, and if I
> > > > > could/should add it to drivers/staging/?
> > > > 
> > > > The original at76_usb is working quite well, but it's unacceptable for
> > > > the mainline because we cannot have two 802.11 stacks in kernel.
> > > 
> > > I understand this, but for the issue of the drivers/staging/ tree, it's
> > > ok for us to have as many 802.11 stacks in the kernel as we can cram in
> > > there :)
> > 
> > Well, you have to ask yourself then, what's the point of putting that
> > driver with it's own 802.11 stack into staging when it's never going to
> > go into the mainline kernel until it uses mac80211?
> 
> Because at least 2 distros currently ship their kernels with it (Fedora
> and Ubuntu), and people have that hardware today and want to use it with
> Linux.
> 
> > Doesn't that direct effort away from porting the driver to mac80211,
> > giving legitimacy to code that will never, ever get upstream until
> > it's substantially rewritten anyway?  Ideally we put Kalle's 802.11
> > port in staging and then people can actually move things forward.
> > 
> > Same thing for linux-wlan-ng really; if people just keep fixing bugs and
> > keep improving p80211 without porting it to the standard kernel wireless
> > bits, what's the point of having it in staging?
> 
> Users using their hardware with Linux today.
> 
> I'll gladly drop it from drivers/staging when the "real" version hits
> mainline, until then, it should stay in staging, as that is the whole
> point of it.

It does nobody any good if (a) the drivers are _never_ going to go
upstream, and (b) if the drivers aren't going to get any attention in
their current form because of (a).

I don't care if the driver allows peoples hardware to work; I want a
driver that makes peoples hardware work _well_.  Out of tree drivers
that are never going upstream will not work well.

Dan

