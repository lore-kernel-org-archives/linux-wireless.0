Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41895 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbYIWV5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 17:57:31 -0400
Message-ID: <48D96647.2050509@lwfinger.net> (sfid-20080923_235735_679687_CAC34D63)
Date: Tue, 23 Sep 2008 16:57:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net, linville@tuxdriver.com,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
References: <48D82A43.7040604@oracle.com>	<200809230907.46130.IvDoorn@gmail.com>	<48D9188A.2090003@oracle.com>	<200809231951.00872.IvDoorn@gmail.com> <20080923140309.ecf8d030.randy.dunlap@oracle.com>
In-Reply-To: <20080923140309.ecf8d030.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap wrote:
> On Tue, 23 Sep 2008 19:51:00 +0200 Ivo van Doorn wrote:
> 
>> On Tuesday 23 September 2008, Randy Dunlap wrote:
>>> Ivo van Doorn wrote:
>>>> On Tuesday 23 September 2008, Randy Dunlap wrote:
>>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>>
>>>>> If RT2X00=y but RFKILL=m, these build errors happen:
>>>>>
>>>>> (.text+0x7c7d6): undefined reference to `rfkill_free'
>>>>> rt2x00rfkill.c:(.text+0x7c830): undefined reference to `rfkill_force_state'
>>>>> (.text+0x7c88d): undefined reference to `rfkill_unregister'
>>>>> (.text+0x7c8cd): undefined reference to `rfkill_register'
>>>>> (.text+0x7ca1a): undefined reference to `rfkill_allocate'
>>>>>
>>>>> so restrict RT2X00's RFKILL config level to that of the main RFKILL option.
>>>>> This is done by making the former a tristate instead of a bool
>>>>> config option.
>>>>>
>>>>>
>>>>> If RT2X00=y but LEDS_CLASS=m, these build errors happen:
>>>>>
>>>>> (.text+0x11859f): undefined reference to `led_classdev_resume'
>>>>> (.text+0x1185b3): undefined reference to `led_classdev_resume'
>>>>> (.text+0x1185c7): undefined reference to `led_classdev_resume'
>>>>> (.text+0x1185e4): undefined reference to `led_classdev_suspend'
>>>>> (.text+0x1185f8): undefined reference to `led_classdev_suspend'
>>>>> (.text+0x11860c): undefined reference to `led_classdev_suspend'
>>>>> rt2x00leds.c:(.text+0x118620): undefined reference to `led_classdev_unregister'
>>>>> rt2x00leds.c:(.text+0x118695): undefined reference to `led_classdev_register'
>>>>>
>>>>> so restrict RT2X00's LEDS config level to that of the main LEDS_CLASS option.
>>>>> This is done by making the former a tristate instead of a bool
>>>>> config option.
>>>> Is that really going to work correctly?
>>>> rfkill and leds support should be compiled into rt2x00lib.ko, which means that
>>>> should become a module instead of the rfkill/leds support part only.
>>> I wondered about that lib.ko.  Any working build fix is OK with me.
>>> What do you suggest?
>> Actually I was hoping that you answer to my question was going to be "yes it will be working correctly" ;)
>>
>> Would this work?
>>
>> config RT2X00_LIB_RFKILL
>> 	tristate
>>   	depends on RFKILL
>>   	default y
>>   
>> config RT2X00_LIB_LEDS
>> 	tristate
>>   	depends on NEW_LEDS
>>   	depends on LEDS_CLASS
>> 	default y
>>
>> config RT2X00_LIB
>> 	tristate
>> 	depends on RT2X00_LIB_RFKILL if (RT2X00_LIB_RFKILL != n)
>> 	depends on RT2X00_LIB_LEDS if (RT2X00_LIB_LEDS != n)
>>
>> It's ugly, and I can't test this right now, but perhaps you have an idea if this could do the trick?
> 
> I tried it:
> 
> drivers/net/wireless/rt2x00/Kconfig:22: invalid option
> drivers/net/wireless/rt2x00/Kconfig:23: invalid option
> 
> "depends ... if ..." is invalid.  Would be nice to have that.
> Maybe there is some other way to express that...

Wouldn't this do it?

depends on (RT2X00_LIB_RFKILL == m) || (RT2X00_LIB_RFKILL == y)

In b43, what I think is a similar configuration statement is written as

depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT &&
(INPUT_POLLDEV = y || INPUT_POLLDEV = B43)

Larry
