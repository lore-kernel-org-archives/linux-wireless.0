Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58046 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYLAP7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:59:17 -0500
Subject: Re: iwlwifi - rfkill only works if the interface is up
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <200812011634.37644.helmut.schaa@gmail.com>
References: <200812011311.17346.helmut.schaa@gmail.com>
	 <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
	 <1228145453.31158.140.camel@violet.holtmann.net>
	 <200812011634.37644.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:59:11 +0100
Message-Id: <1228147151.31158.142.camel@violet.holtmann.net> (sfid-20081201_165921_181471_4E2273E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

> > > > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> > > > makes much sense. I mean, the user space cannot rely on the rfkill state
> > > > unless an appropriate interface is up. As the device is able to report the
> > > > killswitch state without firmware being loaded the following approach could
> > > > be feasible:
> > > > - iwl_pci_probe enables the device and enables the interrupts
> > > > - iwl_mac_start just loads the firmware
> > > > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
> > > 
> > > In 3495  rfkill interrupt is not available and rfkill state is
> > > delivered only when firmware is loaded, therefore this is not
> > > possible to bring device down and also expect rfill switch event.
> > > There were few threads about this subject.
> > > In 4965 and 5000 this will work
> > 
> > do we unregister the rfkill switch when bringing the adapter down.
> 
> No.
> 
> > If not, then we might should do that. I don't see a point in exposing a
> > rfkill switch if we can't do anything with it.
> 
> Either that, or make the rfkill usable even when the interface is down.

if the hardware/firmware doesn't allow us to do so, we have no real
option. I think that nobody thought about this use case so far. I am not
sure if we should unregister it or just fix rfkill to add an invalid
state. It is also possible to tie rfkill with ifup/ifdown.

Regards

Marcel


