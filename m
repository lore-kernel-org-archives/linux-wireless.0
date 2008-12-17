Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYLQVcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 16:32:24 -0500
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
In-Reply-To: <20081217202943.GB3516@tuxdriver.com>
References: <200812161307.07193.helmut.schaa@gmail.com>
	 <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com>
	 <20081217202943.GB3516@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 16:31:25 -0500
Message-Id: <1229549485.26406.12.camel@localhost.localdomain> (sfid-20081217_223228_510362_2087909C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 15:29 -0500, John W. Linville wrote:
> On Wed, Dec 17, 2008 at 12:10:11PM -0800, mohamed salim abbas wrote:
> > the interrupt moved from pci_probe to mac_start for power saving. once
> > the interface is up the driver will read some register to know rfkill
> > status, if the interface in down the driver don't care to keep track
> > of rfkill switch. I wonder what the purpose of changing this behavior?
> 
> I think it still isn't settled in everyone's minds whether rfkill
> only matters if the device is "up" or if it is something that
> e.g. NetworkManager might want to monitor as a clue to bring the
> device up or down in response to rfkill changes.

The question is:  does NetworkManager just always keep the device 'up'
irregardless of whether it's supposed to be associated with anything
just so we can get rfkill events?

We have to keep ethernet devices up because some don't report carrier
status unless they are up (when the PHY is powered on).  Yeah, that
consumes a trivial amount of power.  But lots better to get
notifications of ethernet carrier events dynamically than having to
either (a) poll the carrier by IFF_UP every 5 seconds or (b) not getting
carrier events at all.

I guess I'll treat rfkill the same as ethernet carrier.  If we cannot
rely on rfkill notifications when the device is down (we already can't,
since iwl3945 simply can't do it) then I guess we just have to keep the
wifi device up all the time, even when it's rfkilled, and set the tx
power off when wireless is supposed to be disabled.

It is simply a hard requirement to be able to get rfkill events when the
switch gets flipped, irrespective of whether some blocks of the silicon
are still powered or not (which I assume is the motivation for
completely unloading the firmware in the first place).  We're not going
to special-case a certain chips in NetworkManager; if there are quirks
for devices, those quirks need to live in the driver, not worked around
in userspace.

Dan


