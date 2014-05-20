Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:58599 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETJb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 05:31:29 -0400
Date: Tue, 20 May 2014 05:28:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still
 being compiled?
In-Reply-To: <1400574452.4474.2.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.LFD.2.11.1405200526530.12158@localhost> (sfid-20140520_113133_344702_60853011)
References: <alpine.LFD.2.11.1405200342050.10462@localhost>  (sfid-20140520_101149_157876_1874D563) <1400574452.4474.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 May 2014, Johannes Berg wrote:

> On Tue, 2014-05-20 at 03:49 -0400, Robert P. J. Day wrote:
> >   quite possibly a silly question (which has never stopped me before),
> > but in perusing the PCIE code in the kernel source, i was looking for
> > sample code to demo in a classroom setting and picked on
> > drivers/net/wireless/iwlwifi/pcie, which i was *assuming* was
> > PCIE-dependent -- specifically, i was going to demo the Advanced-N
> > 6235 PCIE wifi card on an intel galileo board.
> >
> >   but i thought it was a bit strange that the pcie/ subdirectory there
> > doesn't seem to depend on PCIEPORTBUS. as a test, i deselected
> > PCIEPORTBUS in a configuration and did a rebuild, and the source in
> > the pcie/ directory was recompiled.
> >
> >   am i misunderstanding the function of the kernel config variable
> > PCIEPORTBUS? i notice that .../iwlwifi/Makefile includes the line:
> >
> >   iwlwifi-objs  += pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
> >
> > which simply compiles those files with no regard to dependency. can
> > someone clarify this? thanks.
>
> The whole driver depends on CONFIG_PCI, maybe it should depend on
> something more PCIe specific, but that wasn't easy to sort out, and
> the APIs it needs aren't PCIe specific afaict.

  ok, i'll have to think about that for a few minutes. am i at least
correct in my understanding that, technically, the kernel config
option PCIEPORTBUS is supposed to control whether one wants basic PCIE
support or not?

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
