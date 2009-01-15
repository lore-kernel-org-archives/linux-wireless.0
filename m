Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:59260 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936188AbZAOW7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 17:59:42 -0500
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-Id: <65BB63A7-75ED-464D-AD81-E34F3AD560BE@ing.unibs.it> (sfid-20090115_235948_765610_F14C8F3A)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <496F5D4F.3020805@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [b43] opensource firmware
Date: Fri, 16 Jan 2009 00:01:41 +0100
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com>	<1231965922.20309.0.camel@johannes> <200901151637.58196.mb@bu3sch.de> <496F5D4F.3020805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 15, 2009, at 4:59 PM, Larry Finger wrote:

> Michael Buesch wrote:
>> Yes, please introduce a feature-bitfield at some location in SHM  
>> that's unused
>> by the proprietary firmware. This bitfields would contain a bit for  
>> QoS and
>> a bit for hwcrypto.
>> Also change your firmware so the driver detects it as open-source  
>> firmware.
>> I think that's done by writing 0xFFFF to the date/time field in  
>> SHM. I don't
>> quite remember, but it's something like that.
>> Note that this might mean that the firmware watchdog in the driver  
>> will trigger,
>> as that's enabled by the open-source-firmware-flag. We might want  
>> to temporarly
>> disable the watchdog in the driver for the time being.
>
> I like the idea of encoding the capabilities in the firmware as it
> would be a self-documenting method as the firmware evolves.
>
> Is using the Broadcom names for the firmware the best course of
> action? What if the opensource firmware files were named something
> like "os-ucode5.fw", etc. and b43 were coded to check for those files
> first? It would then fall back to the standard firmware if the
> opensource version is not found.
>
> Larry
It could be interesting to also not separate the initvalues in two  
different files, everything could be coded in a single file. Never  
understood why original init values are split in two files.

Michael: SHM(0x0014) (16bit) is not used by the open source firmware,  
I know the b43 reads core revision from SHM(0x0016). Normally  
SHM(0x0014) is set to zero. We can put fw capabilities here (0x0014),  
e.g.:

- bit 0: [0 state that encryption should be handled by b43]
- bit 1: [0 state that qos is not supported]

We can prepare a firmware image with such feature + watchdog. Posting  
ASAP with new initvals (less values).

A question: is the standard kernel aware that date set to FFFF  
indicates an opensource firmware or some define should be activated on  
compilation?

Cheers,
-FG
