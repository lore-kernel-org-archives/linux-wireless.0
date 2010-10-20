Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab0JTDLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 23:11:53 -0400
Date: Tue, 19 Oct 2010 20:10:07 -0700
From: Greg KH <greg@kroah.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Nohee Ko <noheek@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	linux-wireless@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] staging:brcm80211:brcmfmac:change firmware/config file
	name
Message-ID: <20101020031007.GA8171@kroah.com>
References: <4CBE23F4.4020104@broadcom.com> <20101019233520.GA12510@kroah.com> <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com> <20101020004743.GB31965@kroah.com> <20101020005546.GL10832@broadcom.com> <20101020010320.GA370@kroah.com> <20101020021806.GM10832@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101020021806.GM10832@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 19, 2010 at 07:18:06PM -0700, Henry Ptasinski wrote:
> (Adding linux-wireless for input on firmware naming best practices.)
> 
> On Tue, Oct 19, 2010 at 06:03:20PM -0700, Greg KH wrote:
> > On Tue, Oct 19, 2010 at 05:55:46PM -0700, Henry Ptasinski wrote:
> > > On Tue, Oct 19, 2010 at 05:47:43PM -0700, Greg KH wrote:
> > > > On Tue, Oct 19, 2010 at 04:45:26PM -0700, Nohee Ko wrote:
> > > > > >>
> > > > > Have you made the same changes in the linux-firmware source tree as
> > > > > well?  Without changing it there, this could get messy.
> > > > > <<
> > > > > 
> > > > > No not yet. But we are planning sooner or later.
> > > > 
> > > > Please do it sooner.
> > > > 
> > > > I'll wait for that to happen before committing this patch.
> > > 
> > > There's no specific changes needed in the linux-firmware repo to work with this
> > > driver change.  There is a bugfix version of the firmware that we're getting
> > > ready to send up, which is the motivation for this change, but the change
> > > will work properly with the firmware that's in the repo today.
> > 
> > How, you just renamed the file you look for in the driver, right?
> > 
> > > All this change does is replace the hard-coded full firmware filename used in
> > > the driver with the basename-apiversion construction as documented in
> > > 
> > > 	http://www.linuxwireless.org/en/developers/Documentation/firmware-versioning
> > > 
> > > plus add some info to the README to help users get the firmware properly
> > > installed.
> > > 
> > > Users will need to create the symlinks as described in the README to use these
> > > driver changes.
> > 
> > Yes, so you just broke their working setup, right?
> > 
> > So, please get linux-firmware fixed to add the proper symlinks, and then
> > I can apply the patch, and say "go upgrade your linux-firmware package",
> > which is almost acceptable.
> 
> Ah, I didn't realize we should have the symlinks in the linux-firmware repo.
> We didn't do that for the brcm80211 driver (same instructions to create
> symlinks by hand are in the README for that driver), and nobody pointed it out
> as being an issue.
> 
> But I note that the linux-firmware repo doesn't contain any symlinks, and I'm
> having trouble finding any other driver that's using this approach.  It looks
> like everybody is either just doing some variant of basename-apiversion, or
> hardcoding the complete firmware name (with codeversion) in theer driver.
> 
> Should we just punt on the codeversion portion?  Thoughts?

punt, as no one else has done this :)

thanks,

greg k-h
