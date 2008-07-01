Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62688 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbYGARNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 13:13:18 -0400
Message-ID: <486A65F5.5030909@lwfinger.net> (sfid-20080701_191321_900614_13EED3C3)
Date: Tue, 01 Jul 2008 12:14:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>	 <200807011227.15805.mb@bu3sch.de>	 <20080701143439.GA6962@khazad-dum.debian.net>	 <1214923097.3462.0.camel@johannes.berg>	 <20080701165036.GB6962@khazad-dum.debian.net> <1214931676.3462.5.camel@johannes.berg>
In-Reply-To: <1214931676.3462.5.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-07-01 at 13:50 -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 01 Jul 2008, Johannes Berg wrote:
>>>> 1. It has an input pin that sometimes people connect buttons/switches
>>>> to.
>>>>
>>>> Does that input pin act as an input for a FLIP-FLOP (and that flip-flop
>>>> output is the hardware rfkill line), or is it the hardware rfkill line
>>>> itself?
>>> Neither. It's not hw kill, but it's not just edge detect either, it does
>>> have 'kill' and 'not kill' states.
>> What exactly the input pin does?  what exactly the hardware does when
>> the input pin state changes?
> 
> The hardware does nothing, it just sets a bit high or low depending on
> the input pin.

On my HP laptop using the RFKILL code currently in wireless-testing, 
sliding the "Wireless switch" results in b43_rfkill_poll being called. 
It then issues KEY_WLAN press and release events. This changes the 
state of the wireless light and the contents of a read-only bit in the 
status register of the device. I believe that if this bit is off, the 
radio is blocked by the hardware.

Larry
