Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57691 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763527AbYHEUoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 16:44:22 -0400
Date: Tue, 5 Aug 2008 17:44:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080805204413.GA21738@khazad-dum.debian.net> (sfid-20080805_224428_051833_67BBE56C)
References: <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1217864565.3139.17.camel@localhost.localdomain> <20080804223052.GG24927@khazad-dum.debian.net> <1217890611.17793.17.camel@localhost.localdomain> <20080804233525.GI24927@khazad-dum.debian.net> <1217927541.3603.32.camel@johannes.berg> <20080805124814.GA32675@khazad-dum.debian.net> <1217940634.3603.42.camel@johannes.berg> <1217941148.3603.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217941148.3603.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 05 Aug 2008, Johannes Berg wrote:
> On Tue, 2008-08-05 at 14:50 +0200, Johannes Berg wrote:
> > On Tue, 2008-08-05 at 09:48 -0300, Henrique de Moraes Holschuh wrote:
> > 
> > > Maybe on net/wireless, but I am really not going to trust that one for,
> > > e.g., serial and USB drivers (USB being a bus that is often not shut down
> > > during suspend because there are USB wake devices), unless you clearly state
> > > you DID review them all, and which ones.
> > 
> > Look, this is _clearly_ the wrong thing to do, so unless you want your
> > patches blocked over it, just rip it out.
> 
> You can of course keep the current _wrong_ behaviour of blocking the
> radio when suspending, but instead of adding extra API for the
> wake-on-wlan case you should work on fixing that.
> 
> If you think that you then need to review all drivers, so be it. I don't
> think it makes sense because keeping the device alive requires
> additional code nobody in their right mind would write unless they knew
> they needed it, like libertas.
> 
> As it stands, rfkill also does the wrong thing for rfkill. You don't
> have to fix it, of course, but don't add workarounds.

I have prepared a patch that does exactly what you wanted (remove BLOCK on
suspend altogether), in the grounds that all drivers should be trying to
properly suspend and resume by themselves as much as possible, anyway.

I have added the maintainers of the drivers that *might* want to do
something about it (i.e. take action to block their transmitters explicitly)
in the CC, and documented the source files that might object to the change
in the commit message.

It will be in my next patchset.  I am NOT happy about doing things this way,
but I am just too tired of the issue to bother.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
