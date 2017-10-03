Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbdJCVeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 17:34:37 -0400
Date: Tue, 3 Oct 2017 16:34:34 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Drake <drake@endlessm.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        linux@endlessm.com
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector
 allocation
Message-ID: <20171003213434.GI25517@bhelgaas-glaptop.roam.corp.google.com> (sfid-20171003_233451_432984_830C32BF)
References: <alpine.DEB.2.20.1709271555430.2027@nanos>
 <20171002085732.4039-1-drake@endlessm.com>
 <alpine.DEB.2.20.1710021540030.2185@nanos>
 <alpine.DEB.2.20.1710021817500.9529@nanos>
 <alpine.DEB.2.20.1710032306170.2278@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.20.1710032306170.2278@nanos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 03, 2017 at 11:07:58PM +0200, Thomas Gleixner wrote:
> On Mon, 2 Oct 2017, Thomas Gleixner wrote:
> > On Mon, 2 Oct 2017, Thomas Gleixner wrote:
> > > On Mon, 2 Oct 2017, Daniel Drake wrote:
> > >   2) The affinity setting of straight MSI interrupts (w/o remapping) on x86
> > >      requires to make the affinity change from the interrupt context of the
> > >      current active vector in order not to lose interrupts or worst case
> > >      getting into a stale state.
> > > 
> > >      That works for single vectors, but trying to move all vectors in one
> > >      go is more or less impossible, as there is no reliable way to
> > >      determine that none of the other vectors is on flight.
> > > 
> > >      There might be some 'workarounds' for that, but I rather avoid that
> > >      unless we get an official documented one from Intel/AMD.
> > 
> > Thinking more about it. That might be actually a non issue for MSI, but we
> > have that modus operandi in the current code and we need to address that
> > first before even thinking about multi MSI support.
> 
> But even if its possible, it's very debatable whether it's worth the effort
> when this driver just can use the legacy INTx.and be done with it.

Daniel said "Legacy interrupts do not work on that module, so MSI
support is required," so I assume he means INTx doesn't work.  Maybe
the driver could poll?  I don't know how much slower that would be,
but at least it would penalize the broken device, not everybody.

Bjorn
