Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXBMUzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 15:55:24 -0500
Subject: Re: network manager vs. missing firmware
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890702131213s715df387wa4bd4d1c66b4a664@mail.gmail.com>
References: <1171392106.10344.100.camel@johannes.berg>
	 <1171394598.5329.31.camel@localhost.localdomain>
	 <1171395459.10344.123.camel@johannes.berg>
	 <200702131443.16553.flamingice@sourmilk.net>
	 <43e72e890702131213s715df387wa4bd4d1c66b4a664@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 15:58:09 -0500
Message-Id: <1171400289.5329.51.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-13 at 15:13 -0500, Luis R. Rodriguez wrote:
> On 2/13/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Tuesday 13 February 2007 14:37, Johannes Berg wrote:
> > > > So this isn't really consistent.  I'm unclear as to why the ipw cards
> > > > need it on init rather than on dev open, but hey, why make things
> > > > easier?
> > >
> > > When is ->init() called anyway? Isn't it when you register the netdev so
> > > it would be on probe?
> > >
> > Yes, ipw2200 does it on probe... but I know it can be pushed off to open. I've
> > done it. However.. I think intersil cards really need firmware to read the
> > eeprom.
> 
> This is correct
> 
> > prism54 currently sets a fake MAC address so they can push it off to
> > open, but I think this is wrong.
> 
> This was suggested by Jean a long time ago after we asked for advice
> on what to do since we couldn't read the MAC before loading the
> firmware. Whatever we decide on we should standardize on it in case
> other new cards end up with same issue. One option was to have the
> probe() fail if no firmware was present but obviously this would force
> you to reload the module/reboot if you then get the firmware. We
> decided to leave the firmware upload on open() to overcome this but
> the problem then was the lack of a MAC address.
> 
> Anyone know if wireless network devices the only ones requiring a
> firmware? If not then we should think of slapping something onto
> net_device. Otherwise we should distinguish the requirement on
> cfg80211_config so userspace tools know WTF is going on and inform the
> user appropriately.

No; others include Apple iSight cameras (the built-in USB variants),
bluetooth devices (usually USB too), Keyspan serial adapters (usually
USB), a bunch of stuff in drivers/media/video/, some non-USB network
adapters, and some adaptec and qlogic sci drivers.

It seems that most USB devices require firmware no matter what type they
are.  Beyond that:

probe: scsi/qla2xxx, net/myri10ge, scsi/aic94xx, net/spidernet
open: serial/icom

Dan


