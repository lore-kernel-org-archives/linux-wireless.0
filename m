Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJ2Laq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 07:30:46 -0400
Subject: Re: [2.6.23.1] PCI device locking up the computer when its module
	loads
From: Dan Williams <dcbw@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071029003640.6fe08168.akpm@linux-foundation.org>
References: <511770.44451.qm@web52902.mail.re2.yahoo.com>
	 <20071029003640.6fe08168.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 07:29:25 -0400
Message-Id: <1193657365.19938.17.camel@localhost.localdomain> (sfid-20071029_113051_300665_DB0E0790)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-29 at 00:36 -0700, Andrew Morton wrote:
> On Mon, 22 Oct 2007 13:43:16 +0100 (BST) Chris Rankin <rankincj@yahoo.com> wrote:
> 
> > Hi,
> > 
> > I have a Netgear MA301 PLX wireless networking adapter which wants to use the hostap_plx driver in
> > Linux 2.6.23.1. This very same piece of hardware works fine in an old(!) P120 machine running
> > 2.4.33, but makes the 2.6.23.1 kernel freeze as soon as the pci_enable_device() function is called
> > in prism2_plx_probe. What seems to happen is that IRQ 5 is signalled (the adapter's IRQ, according
> > to lspci), but the handler function hasn't been installed yet and so the kernel disables IRQ 5 and
> > locks up. However, the documentation that I have read implies that calling pci_enable_device()
> > before requesting the IRQ number to install the handler on is "The Right Thing to do", because
> > otherwise the IRQ number might change.
> > 
> > I have tried booting with "acpi=off nolapic" to no effect. The kernel is UP with 4K stacks and
> > PREEMPT.
> > 
> > Can anyone suggest what a suitable fix might be, please? Because I am currently thinking "CLI" and
> > "STI"!
> > 

This same sort of problem was just fixed for iwl4965.  The fix for that
was to disable device interrupts until everything the driver needed
(including interrupt handler) was set up and ready before re-enabling
them, I think.  See the thread "iwl4965 detection problem" and the mail
from Jes Sorensen on 2007-10-26.

The orinoco_plx driver appears to enable interrupts (in
orinoco_plx_hw_init()) after calling request_irq, but there's an
interesting comment in ..._hw_init():

	/* bjoern: We need to tell the card to enable interrupts, in
	   case the serial eprom didn't do this already.  See the
	   PLX9052 data book, p8-1 and 8-24 for reference. */

Perhaps your card's EPROM tells the card to enable interrupts too early?
Not sure how to fix that though.

Dan

