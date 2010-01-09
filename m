Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49313 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0AIDrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 22:47:18 -0500
Received: by ywh6 with SMTP id 6so20091945ywh.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jan 2010 19:47:17 -0800 (PST)
Message-ID: <4B47FC42.2050502@lwfinger.net>
Date: Fri, 08 Jan 2010 21:47:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: tim.gardner@canonical.com
CC: Michael Buesch <mb@bu3sch.de>,
	Martin Pitt <martin.pitt@ubuntu.com>, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
References: <20100107183517.A322FF88D8@sepang.rtg.net> <4B463953.1030806@canonical.com> <20100108173248.GB2546@piware.de> <201001082006.02121.mb@bu3sch.de> <4B47D98F.1000703@canonical.com>
In-Reply-To: <4B47D98F.1000703@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2010 07:19 PM, Tim Gardner wrote:
> Michael Buesch wrote:
>> On Friday 08 January 2010 18:32:48 Martin Pitt wrote:
>>> Tim Gardner [2010-01-07 12:43 -0700]:
>>>> AFAIK Jockey only needs to be able to tell if _any_ of the firmware
>>>> files have been installed and could therefore make an install decision
>>>> based on just one firmware file name.
>>> Correct.
>>>
>>>> Martin - if thats the case, then we need only list one firmware file in
>>>> the modinfo, correct?
>>> Right. If that's not practical to fix on the kernel side for some
>>> reason, we could also put in a quirk into the Broadcom handler in
>>> update-notifier. (Right now it just listens for FIRMWARE subsystem
>>> uevents and checksc if the value of it exists as a file).
>>>
>>> This was originally introduced for the DVB-T driver firmware packages,
>>> but if we could make it work for b43 as well, this would be nice.
>>
>> I think it would be OK to list all the ucodeX.fw files, but listing all
>> these initvals files seems overkill to me.
>> If you still need all initval filenames, you could theoretically ask
>> b43-fwcutter.
>> That would just need a new fwcutter commandline option, as far as I
>> can see.
>>
>> As you can see, we currently only export the b43 specific firmware ID
>> in MODULE_FIRMWARE().
>> That is a unique identifier for a whole set of firmware files.
>> b43-fwcutter also
>> knows about that firmware ID.
>>
>> (While we're at it, I think the FW-id that b43 announces should be
>> updated. Because
>> I think the firmware with the currently announced ID does not support
>> all LP devices.)
>>
> 
> How about the attached version that only includes the ucode files ?

This one looks good to me. Would you also like to do one for b43legacy with
ucode2.fw and ucode4.fw, or should I do it?

Larry
