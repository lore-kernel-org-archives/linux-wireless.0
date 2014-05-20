Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36421 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaETI1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:27:47 -0400
Message-ID: <1400574452.4474.2.camel@jlt4.sipsolutions.net> (sfid-20140520_102754_352186_4ADCC9FA)
Subject: Re: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still
 being compiled?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 May 2014 10:27:32 +0200
In-Reply-To: <alpine.LFD.2.11.1405200342050.10462@localhost> (sfid-20140520_101149_157876_1874D563)
References: <alpine.LFD.2.11.1405200342050.10462@localhost>
	 (sfid-20140520_101149_157876_1874D563)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 03:49 -0400, Robert P. J. Day wrote:
>   quite possibly a silly question (which has never stopped me before),
> but in perusing the PCIE code in the kernel source, i was looking for
> sample code to demo in a classroom setting and picked on
> drivers/net/wireless/iwlwifi/pcie, which i was *assuming* was
> PCIE-dependent -- specifically, i was going to demo the Advanced-N
> 6235 PCIE wifi card on an intel galileo board.
> 
>   but i thought it was a bit strange that the pcie/ subdirectory there
> doesn't seem to depend on PCIEPORTBUS. as a test, i deselected
> PCIEPORTBUS in a configuration and did a rebuild, and the source in
> the pcie/ directory was recompiled.
> 
>   am i misunderstanding the function of the kernel config variable
> PCIEPORTBUS? i notice that .../iwlwifi/Makefile includes the line:
> 
>   iwlwifi-objs  += pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
> 
> which simply compiles those files with no regard to dependency. can
> someone clarify this? thanks.

The whole driver depends on CONFIG_PCI, maybe it should depend on
something more PCIe specific, but that wasn't easy to sort out, and the
APIs it needs aren't PCIe specific afaict.

johannes


