Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48167 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0E0Dvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 23:51:47 -0400
Received: by vws9 with SMTP id 9so4965853vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 20:51:45 -0700 (PDT)
Message-ID: <4BFDEC5E.2090401@gmail.com>
Date: Wed, 26 May 2010 23:51:58 -0400
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
Can someone port this patch up so it includes the fix Johannes is 
speaking of? Kind of craptastic to have not one but TWO bugs which 
completely break monitor mode AND channel hopping.  If we fix both at 
once we can have a working driver :-) I have plenty of testers standing by.

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

