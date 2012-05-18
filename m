Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54307 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946775Ab2ERXKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 19:10:06 -0400
Date: Fri, 18 May 2012 16:09:55 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Hansjoerg Lipp <hjlipp@web.de>,
	linux-bluetooth@vger.kernel.org,
	gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [RFC 13/13] USB: Disable hub-initiated LPM for comms devices.
Message-ID: <20120518230955.GA4686@xanatos> (sfid-20120519_011044_352630_C07F37E2)
References: <cover.1337203535.git.sarah.a.sharp@linux.intel.com>
 <3c634afbbe15598cdcbf77bb9393d22ad4bfa373.1337203535.git.sarah.a.sharp@linux.intel.com>
 <4FB53054.9070309@imap.cc>
 <20120517173150.GE4967@xanatos>
 <4FB6CF71.7080307@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB6CF71.7080307@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 19, 2012 at 12:38:41AM +0200, Tilman Schmidt wrote:
> Am 17.05.2012 19:31, schrieb Sarah Sharp:
> > On Thu, May 17, 2012 at 07:07:32PM +0200, Tilman Schmidt wrote:
> >>
> >> I follow the argument for class drivers. But this patch also
> >> modifies drivers for specific existing USB 2.0 only devices
> >> which are unlikely to ever grow USB 3.0 support, such as the
> >> Gigaset ISDN driver:
> >>
> >>>  drivers/isdn/gigaset/bas-gigaset.c            |    1 +
> >>>  drivers/isdn/gigaset/usb-gigaset.c            |    1 +
> > 
> > Is there a particular reason why you think that driver is unlikely to
> > ever get USB 3.0 support?
> 
> Actually, there is. :-)
> - The USB devices driven by this driver aren't built anymore.
> - Their USB interface design is quite, um, idiosyncratic, and it's
>   pretty unlikely that anyone will reuse it. (At least I truly hope
>   no one will.)
> - Their successor models have completely different and incompatible
>   USB interfaces which this driver is unable to handle.

I see!

> >> What is the interest of setting the disable_hub_initiated_lpm
> >> flag for these?
> > 
> > It's partially to lay the foundation for anyone who wants to make a USB
> > 3.0 communications driver in the future.  They're likely to start from
> > some USB 2.0 class driver, and copy a lot of code.  If they notice that
> > flag is set in all the USB communications class drivers, they're likely
> > to set it as well.
> 
> You've got a point there.
> 
> > I'm not quite sure where the best place to provide documentation on the
> > flag is.  I've added the kernel doc comments to the structure, but maybe
> > it needs to be documented somewhere in Documentation/usb/?
> 
> Documentation/usb/power-management.txt would seem like a natural
> place. Although it appears to limit itself to "suspending" in its
> first paragraph, it does have a section "xHCI hardware link PM"
> at the end already, added by Andiry Xu on 2011-09-23.

Ok, I'll send a separate patch to add documentation here, after the 3.5
merge window.  (I just sent the pull request for the USB 3.0 LPM patches
off to Greg.)

> Hmmm, that section seems to suggest that LPM exists for USB2, too.
> Perhaps I should reconsider my attitude towards your patch.

The patchset doesn't change the USB 2.0 LPM behavior at all.  USB 2.0
doesn't have hub initiated LPM, because that would mean changing
existing USB 2.0 hub IP.  Only devices attached directly to the roothub
will be able to do USB 2.0 LPM.  Also, devices have to specifically say
they implement the USB 2.1 LPM extensions, so it's unlikely devices
supported by your driver implement USB 2.0 LPM.

Sarah Sharp
