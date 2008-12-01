Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33554 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLAVQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 16:16:16 -0500
Date: Mon, 1 Dec 2008 16:12:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: iwlwifi - rfkill only works if the interface is up
Message-ID: <20081201211231.GC3479@tuxdriver.com> (sfid-20081201_221629_318332_A88DCE77)
References: <200812011311.17346.helmut.schaa@gmail.com> <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com> <1228145453.31158.140.camel@violet.holtmann.net> <200812011634.37644.helmut.schaa@gmail.com> <1228147151.31158.142.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228147151.31158.142.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 04:59:11PM +0100, Marcel Holtmann wrote:
> Hi Helmut,
> 
> > > > > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> > > > > makes much sense. I mean, the user space cannot rely on the rfkill state
> > > > > unless an appropriate interface is up. As the device is able to report the
> > > > > killswitch state without firmware being loaded the following approach could
> > > > > be feasible:
> > > > > - iwl_pci_probe enables the device and enables the interrupts
> > > > > - iwl_mac_start just loads the firmware
> > > > > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
> > > > 
> > > > In 3495  rfkill interrupt is not available and rfkill state is
> > > > delivered only when firmware is loaded, therefore this is not
> > > > possible to bring device down and also expect rfill switch event.
> > > > There were few threads about this subject.
> > > > In 4965 and 5000 this will work
> > > 
> > > do we unregister the rfkill switch when bringing the adapter down.
> > 
> > No.
> > 
> > > If not, then we might should do that. I don't see a point in exposing a
> > > rfkill switch if we can't do anything with it.

I think this is a good suggestion.

> > Either that, or make the rfkill usable even when the interface is down.
> 
> if the hardware/firmware doesn't allow us to do so, we have no real
> option. I think that nobody thought about this use case so far. I am not
> sure if we should unregister it or just fix rfkill to add an invalid
> state. It is also possible to tie rfkill with ifup/ifdown.

I don't see much point in an invalid state -- just deregister as you
suggested above.

FWIW, I'm not sure what the point of checking rfkill state would be if the
adapter is down anyway.  Hmmm...maybe management of the rfkill LED?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
