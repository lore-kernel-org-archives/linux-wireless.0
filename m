Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57112 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0E1S2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:28:43 -0400
Received: by vws9 with SMTP id 9so1335262vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 11:28:42 -0700 (PDT)
Message-ID: <4C000B68.9000305@gmail.com>
Date: Fri, 28 May 2010 14:28:56 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Path for fixed channel issue in aircrack-ng suite
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com> <1274860275.3658.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1274860275.3658.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2010-05-26 at 00:54 +0200, Gábor Stefanik wrote:
>
>   
>>>> -       if (wdev)
>>>> -               wdev->channel = chan;
>>>> +       wdev = old_wdev;
>>>> +       wdev->channel = chan;
>>>>         
>>> NACK. That will crash when there really is no interface being passed in.
>>>
>>> johannes
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>       
>> Well, the original version already dereferences wdev in "if
>> (wdev->iftype...", so the crash is nothing new if it exists.
>>     
>
> It has also been fixed since.
>
>   
Is someone porting this fix into wireless-testing and stable or does 
that still need to be done? Fixed channel of -1 is sort of an issue for 
using monitor mode....

Thanks,
Rick
> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

