Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37753 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751408AbZFOOh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 10:37:27 -0400
Date: Mon, 15 Jun 2009 10:37:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: linux-pm@lists.linux-foundation.org, <linux-pci@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<ath5k-devel@venema.h4ckr.net>
Subject: Re: [linux-pm] PCI hotplug v.s. suspend
In-Reply-To: <4A3654A4.1070700@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0906151035560.5057-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Jun 2009, Alan Jenkins wrote:

> Alan Stern wrote:
> > On Mon, 15 Jun 2009, Alan Jenkins wrote:
> >
> >   
> >> Hi,
> >>
> >> I triggered a WARNING while hacking on eeepc-laptop's 
> >> rfkill-by-pci-hotplug.  I saw "Trying to free already-free IRQ" in 
> >> ath5k_pci_remove(), because the IRQ was already freed by 
> >> ath5k_pci_suspend().  My changes to eeepc-laptop had allowed the PCI 
> >> device to be removed while suspended.
> >>
> >> Are PCI drivers supposed to handle remove() while suspended?
> >>     
> >
> > Yes.  You found a bug in the driver.  However it's not clear (to me at
> > least) whether the bug is that the IRQ is freed in the suspend method
> > or that there's no check for already-freed in the remove method.  My 
> > guess is the latter.
> >
> > Alan Stern
> >   
> 
> The example in Documentation/power/pci.txt shows free_irq() being called
> in suspend (and request_irq() in resume).  So the problem is in remove().

I'm not sure whether the example is trustworthy.  There was some
discussion quite a while ago regarding whether drivers should free
their IRQs during suspend, but I don't remember what the outcome was.

Alan Stern

