Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47834 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZAEO4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 09:56:40 -0500
Received: by bwz14 with SMTP id 14so22674728bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 06:56:37 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Date: Mon, 5 Jan 2009 15:56:12 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
References: <200812161307.07193.helmut.schaa@gmail.com> <20081217202943.GB3516@tuxdriver.com> <1229549485.26406.12.camel@localhost.localdomain>
In-Reply-To: <1229549485.26406.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901051556.13403.helmut.schaa@gmail.com> (sfid-20090105_155643_962787_DCAC3F31)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 17. Dezember 2008 schrieb Dan Williams:
> On Wed, 2008-12-17 at 15:29 -0500, John W. Linville wrote:
> > On Wed, Dec 17, 2008 at 12:10:11PM -0800, mohamed salim abbas wrote:
> > > the interrupt moved from pci_probe to mac_start for power saving. once
> > > the interface is up the driver will read some register to know rfkill
> > > status, if the interface in down the driver don't care to keep track
> > > of rfkill switch. I wonder what the purpose of changing this behavior?
> > 
> > I think it still isn't settled in everyone's minds whether rfkill
> > only matters if the device is "up" or if it is something that
> > e.g. NetworkManager might want to monitor as a clue to bring the
> > device up or down in response to rfkill changes.
> 
> The question is:  does NetworkManager just always keep the device 'up'
> irregardless of whether it's supposed to be associated with anything
> just so we can get rfkill events?

Another question is: is it worth to keep the interface up (and thus the
firmware loaded) even if the transceiver is killed by a hardware switch?
Wouldn't that consume even more power than just listening to rfkill
interrupts (or polling the killswitch state in case of 3945) with no
firmware loaded.

> I guess I'll treat rfkill the same as ethernet carrier.  If we cannot
> rely on rfkill notifications when the device is down (we already can't,
> since iwl3945 simply can't do it) 

I've just checked the 3945 and it is indeed possible to poll the killswitch
state even if the firmware is not loaded. Hence 3945 could also expose
the killswitch state while the interface is down (of course the driver would
have to poll for that information).

> if there are quirks for devices, those quirks need to live in the driver,
> not worked around in userspace.

Agreed.

Helmut
