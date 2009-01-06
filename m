Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33909 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZAFQlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 11:41:10 -0500
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
In-Reply-To: <1231257584.14565.16.camel@localhost.localdomain>
References: <200812161307.07193.helmut.schaa@gmail.com>
	 <20081217202943.GB3516@tuxdriver.com>
	 <1229549485.26406.12.camel@localhost.localdomain>
	 <200901051556.13403.helmut.schaa@gmail.com>
	 <1231257584.14565.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 17:41:07 +0100
Message-Id: <1231260067.5246.7.camel@californication> (sfid-20090106_174117_071723_B16B69D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > > the interrupt moved from pci_probe to mac_start for power saving. once
> > > > > the interface is up the driver will read some register to know rfkill
> > > > > status, if the interface in down the driver don't care to keep track
> > > > > of rfkill switch. I wonder what the purpose of changing this behavior?
> > > > 
> > > > I think it still isn't settled in everyone's minds whether rfkill
> > > > only matters if the device is "up" or if it is something that
> > > > e.g. NetworkManager might want to monitor as a clue to bring the
> > > > device up or down in response to rfkill changes.
> > > 
> > > The question is:  does NetworkManager just always keep the device 'up'
> > > irregardless of whether it's supposed to be associated with anything
> > > just so we can get rfkill events?
> > 
> > Another question is: is it worth to keep the interface up (and thus the
> > firmware loaded) even if the transceiver is killed by a hardware switch?
> > Wouldn't that consume even more power than just listening to rfkill
> > interrupts (or polling the killswitch state in case of 3945) with no
> > firmware loaded.
> > 
> > > I guess I'll treat rfkill the same as ethernet carrier.  If we cannot
> > > rely on rfkill notifications when the device is down (we already can't,
> > > since iwl3945 simply can't do it) 
> > 
> > I've just checked the 3945 and it is indeed possible to poll the killswitch
> > state even if the firmware is not loaded. Hence 3945 could also expose
> > the killswitch state while the interface is down (of course the driver would
> > have to poll for that information).
> 
> Even polling the state once every 2 - 4 seconds would be perfectly
> acceptable latency for me.  It doesn't have to be instantaneous, so we
> can certainly trade off latency for fewer wakeups.  Care to propose a
> patch?  it'll make a lot of people happy :)

if we can't get the rfkill state change via interrupt, then the kernel
driver has to poll for it (in the no-firmware cases). Or we have to
remove the rfkill support completely. Everything else is just not
acceptable. It is _not_ the responsibility of the userspace to make this
work with quirks.

Regards

Marcel


