Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61714 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbYGASUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 14:20:40 -0400
Message-ID: <486A75C0.3010306@lwfinger.net> (sfid-20080701_202044_414320_C1C99C30)
Date: Tue, 01 Jul 2008 13:21:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de> <20080701143439.GA6962@khazad-dum.debian.net> <1214923097.3462.0.camel@johannes.berg> <20080701165036.GB6962@khazad-dum.debian.net> <1214931676.3462.5.camel@johannes.berg> <486A65F5.5030909@lwfinger.net> <20080701173502.GB24605@khazad-dum.debian.net>
In-Reply-To: <20080701173502.GB24605@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Tue, 01 Jul 2008, Larry Finger wrote:
>> On my HP laptop using the RFKILL code currently in wireless-testing,  
>> sliding the "Wireless switch" results in b43_rfkill_poll being called.  
> 
> Can you confirm (remove rfkill-input, hp-wmi, and anything else that could
> mess with the results) that the HP laptop wireless switch is wired directly
> to that b43 input pin?
> 
> Is it wired to anything else? e.g. can hp-wmi see that switch?

I removed rfkill_input and toggled the switch off - b43 reported that 
the hardware switch was set to DISABLED, but the light remained on. 
When the switch was turned on, b43 reported that it was ENABLED. It 
certainly seems that the switch is wired to some pin on the PCIe 
connector used by my BCM4312.

 From what I know, hp-wmi is a Windows process - when I need to use 
Windows, I go to a different computer.

Larry
