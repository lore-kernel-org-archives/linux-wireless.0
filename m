Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:63960 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZAFTn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 14:43:29 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2868549fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 11:43:27 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Date: Tue, 6 Jan 2009 20:41:45 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
References: <200812161307.07193.helmut.schaa@gmail.com> <200901051556.13403.helmut.schaa@gmail.com> <1231257584.14565.16.camel@localhost.localdomain>
In-Reply-To: <1231257584.14565.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901062041.46611.helmut.schaa@gmail.com> (sfid-20090106_204333_616815_3FD797A8)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 6. Januar 2009 schrieb Dan Williams:
> On Mon, 2009-01-05 at 15:56 +0100, Helmut Schaa wrote:
> > Am Mittwoch, 17. Dezember 2008 schrieb Dan Williams:
> > > On Wed, 2008-12-17 at 15:29 -0500, John W. Linville wrote:
> > > > On Wed, Dec 17, 2008 at 12:10:11PM -0800, mohamed salim abbas wrote:
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
> patch?

Will do that soon.

Helmut
