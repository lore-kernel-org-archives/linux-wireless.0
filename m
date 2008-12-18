Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:57472 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbYLRWov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:44:51 -0500
Message-ID: <494AD243.5070602@warmcat.com> (sfid-20081218_234511_745442_5628FD9D)
Date: Thu, 18 Dec 2008 22:44:19 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill
References: <20081218212234.GI5019@almesberger.net> <494ACE9B.8010709@warmcat.com> <200812182337.56050.mb@bu3sch.de>
In-Reply-To: <200812182337.56050.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Thursday 18 December 2008 23:28:43 Andy Green wrote:
>> Somebody in the thread at some point said:
>>
>>> In Openmoko, we're wondering whether we should make the Atheros AR6k
>> Let me put that simpler for you Werner :-)
>>
>> "In Openmoko" we already use the nice rfkill interface to turn our USB 
>> bluetooth device on and off... it certainly stops RF emissions from it.
>>
>> Now we plan to do the same for our AR6001 implementation... it has no 
>> switched power to the module, it is "always on".  It seems the only way 
>> to get it to a low power state is an IOCTL that currently needs to be 
>> set by a userspace app.
>>
>> In the same manner as we switch bluetooth, I have asked Werner to write 
>> a patch that will use rfkill to issue the IOCTL to switch the AR6001 
>> into low power / no RF mode.
>>
>> Does that raise any eyebrows?
> 
> Is the wireless kernel driver a binary blob?

No, Openmoko won't have anything to do with in-kernel binary blobs. 
There is binary firmware in it in flash though.

It's not very kernel style C:

http://git.openmoko.org/?p=kernel.git;a=tree;f=drivers/ar6000;h=ab7abd9222054919a3cd0ce6ecbec64b6057cbed;hb=andy-tracking

-Andy

