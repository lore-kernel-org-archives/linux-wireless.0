Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYLOPU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 10:20:28 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tony Vroon <tony@linx.net>, Len Brown <lenb@kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <20081215115336.GD17648@khazad-dum.debian.net>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
	 <1229172465.4010.11.camel@localhost>
	 <20081213132857.GA11428@khazad-dum.debian.net>
	 <1229274343.6775.15.camel@localhost.localdomain>
	 <20081215115336.GD17648@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 10:19:08 -0500
Message-Id: <1229354348.12163.20.camel@localhost.localdomain> (sfid-20081215_162033_724567_91DE6963)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 09:53 -0200, Henrique de Moraes Holschuh wrote:
> On Sun, 14 Dec 2008, Dan Williams wrote:
> > On Sat, 2008-12-13 at 11:28 -0200, Henrique de Moraes Holschuh wrote:
> > > On Sat, 13 Dec 2008, Tony Vroon wrote:
> > > > > What is the WLAN driver involved? Is it rfkill-aware?
> > > > 
> > > > The driver is iwlagn, which does indeed notice that it is killed.
> > > > This information does not reach NetworkManager. Relevant log
> > > > entries: Dec 12 00:59:01 amalthea iwlagn: Radio Frequency Kill
> > > > Switch is On: Dec 12 00:59:01 amalthea Kill switch must be turned
> > > > off for wireless networking to work.
> > > 
> > > Then, it is just a matter of time for it to be working correctly.  In
> > > fact, it might already be if you use wireless-testing and latest
> > > network manager.
> > 
> > If HAL's killswitch support doesn't know about the kernel killswitch
> > device, or it cannot get the state of the killswitch, then certainly
> > NetworkManager isn't going to know about it.
> 
> I see.  I have added "up-to-date HAL also required" to my mental list of
> stuff needed in userspace.

I plan to beat the shit out of the hal killswitch support pretty soon.
AFAIK it still doesn't know about softblock, which is part of the whole
reason for the rfkill rewrite in 2.6.26 anyway.  It also doesn't yet
(AFAIK) support uevents from killswitches either, which sucks.

Dan


