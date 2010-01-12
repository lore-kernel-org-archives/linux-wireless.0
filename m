Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2914 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab0ALKIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 05:08:42 -0500
Message-ID: <4B4C4A1B.8090205@canonical.com>
Date: Tue, 12 Jan 2010 10:08:27 +0000
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>,
	Martin Pitt <martin.pitt@ubuntu.com>, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
References: <20100107183517.A322FF88D8@sepang.rtg.net> <4B463953.1030806@canonical.com> <20100108173248.GB2546@piware.de> <201001082006.02121.mb@bu3sch.de> <4B47D98F.1000703@canonical.com> <4B47FC42.2050502@lwfinger.net>
In-Reply-To: <4B47FC42.2050502@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 01/08/2010 07:19 PM, Tim Gardner wrote:
>> Michael Buesch wrote:
>>> On Friday 08 January 2010 18:32:48 Martin Pitt wrote:
>>>> Tim Gardner [2010-01-07 12:43 -0700]:
>>>>> AFAIK Jockey only needs to be able to tell if _any_ of the firmware
>>>>> files have been installed and could therefore make an install decision
>>>>> based on just one firmware file name.
>>>> Correct.
>>>>
>>>>> Martin - if thats the case, then we need only list one firmware file in
>>>>> the modinfo, correct?
>>>> Right. If that's not practical to fix on the kernel side for some
>>>> reason, we could also put in a quirk into the Broadcom handler in
>>>> update-notifier. (Right now it just listens for FIRMWARE subsystem
>>>> uevents and checksc if the value of it exists as a file).
>>>>
>>>> This was originally introduced for the DVB-T driver firmware packages,
>>>> but if we could make it work for b43 as well, this would be nice.
>>> I think it would be OK to list all the ucodeX.fw files, but listing all
>>> these initvals files seems overkill to me.
>>> If you still need all initval filenames, you could theoretically ask
>>> b43-fwcutter.
>>> That would just need a new fwcutter commandline option, as far as I
>>> can see.
>>>
>>> As you can see, we currently only export the b43 specific firmware ID
>>> in MODULE_FIRMWARE().
>>> That is a unique identifier for a whole set of firmware files.
>>> b43-fwcutter also
>>> knows about that firmware ID.
>>>
>>> (While we're at it, I think the FW-id that b43 announces should be
>>> updated. Because
>>> I think the firmware with the currently announced ID does not support
>>> all LP devices.)
>>>
>> How about the attached version that only includes the ucode files ?
> 
> This one looks good to me. Would you also like to do one for b43legacy with
> ucode2.fw and ucode4.fw, or should I do it?
> 
> Larry
> 

Uh, go ahead. I'm buried in London this week.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
