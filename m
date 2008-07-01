Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYGAVWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 17:22:54 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <486A75C0.3010306@lwfinger.net>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
	 <20080701143439.GA6962@khazad-dum.debian.net>
	 <1214923097.3462.0.camel@johannes.berg>
	 <20080701165036.GB6962@khazad-dum.debian.net>
	 <1214931676.3462.5.camel@johannes.berg> <486A65F5.5030909@lwfinger.net>
	 <20080701173502.GB24605@khazad-dum.debian.net>
	 <486A75C0.3010306@lwfinger.net>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 17:20:51 -0400
Message-Id: <1214947251.28817.15.camel@localhost.localdomain> (sfid-20080701_232258_272719_B38F88CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-01 at 13:21 -0500, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > On Tue, 01 Jul 2008, Larry Finger wrote:
> >> On my HP laptop using the RFKILL code currently in wireless-testing,  
> >> sliding the "Wireless switch" results in b43_rfkill_poll being called.  
> > 
> > Can you confirm (remove rfkill-input, hp-wmi, and anything else that could
> > mess with the results) that the HP laptop wireless switch is wired directly
> > to that b43 input pin?
> > 
> > Is it wired to anything else? e.g. can hp-wmi see that switch?
> 
> I removed rfkill_input and toggled the switch off - b43 reported that 
> the hardware switch was set to DISABLED, but the light remained on. 
> When the switch was turned on, b43 reported that it was ENABLED. It 
> certainly seems that the switch is wired to some pin on the PCIe 
> connector used by my BCM4312.
> 
>  From what I know, hp-wmi is a Windows process - when I need to use 
> Windows, I go to a different computer.

No, it's a linux kernel module for HP laptops that talks to BIOS
routines to get the state of the killswitch on some HP laptops.
Unfortunately this has to happen through WMI hooks, even on Linux.

Dan


