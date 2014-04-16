Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56092 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaDPLB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 07:01:26 -0400
Received: by mail-ie0-f177.google.com with SMTP id rl12so10339739iec.36
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2014 04:01:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdxZqLVe3_wT3pY-rdY_7KXz_iXFd7Z8JCfXrDwpP8ciQ@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	<1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	<1393852248.10039.5.camel@jlt4.sipsolutions.net>
	<CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
	<CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
	<CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
	<CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
	<CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
	<CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com>
	<CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
	<CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
	<CAB3XZEc6iXzEYcpYXEdYMQ0-yJxMbNvRGay3ezJX-yaXFksH9g@mail.gmail.com>
	<CANrMYP7QPoT-b_6GRWz6fOFeoO0c8LU09deRi3HFRB_wQJiUKQ@mail.gmail.com>
	<CA+XVXfdxZqLVe3_wT3pY-rdY_7KXz_iXFd7Z8JCfXrDwpP8ciQ@mail.gmail.com>
Date: Wed, 16 Apr 2014 13:01:26 +0200
Message-ID: <CAFED-j=o7nLGu4w3BTpxqkBwN5wTgwz5K7DVPurdRomDOCRApA@mail.gmail.com> (sfid-20140416_130130_975325_54226B0D)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Colleen T <colleen@cozybit.com>, Eliad Peller <eliad@wizery.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-16 12:38 GMT+02:00 Arik Nemtsov <arik@wizery.com>:
> Thanks for testing Colleen!
>
> I'll respin the patch on top of wireless-testing.
>
Please don't remove "Pending regulatory reques ... " dbg print. This
could be usefull for debuging.

BR
Janusz

> Arik
>
> On Mon, Apr 14, 2014 at 10:27 PM, Colleen T <colleen@cozybit.com> wrote:
>> Hello,
>>
>> Applying Arik's patch on top of Luis' resolves our problem.
>>
>> You also get my:
>>
>> Tested-by: Colleen Twitty <colleen@cozybit.com>
>>
>> Thanks,
>> -Colleen
>>
>> On Sun, Apr 13, 2014 at 5:50 AM, Eliad Peller <eliad@wizery.com> wrote:
>>> On Wed, Apr 9, 2014 at 7:33 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>>>
>>>> Seems I might have found the culprit - reg_todo is called while the
>>>> request to CRDA is in flight and the patch in question causes the
>>>> already-in-process user-request to be handled again. Since it's the
>>>> same regdomain as the last request (it's the last request itself), we
>>>> get this:
>>>>
>>>> treatment = __reg_process_hint_user(user_request);
>>>> if (treatment == REG_REQ_IGNORE ||
>>>>    treatment == REG_REQ_ALREADY_SET) {
>>>> kfree(user_request); <------
>>>> return treatment;
>>>> }
>>>>
>>>> Can you try adding the attached patch? It just replaced relevant
>>>> kfree-s with a function that avoids freeing the last request.
>>>>
>>> i encountered a similar panic, and this patch seems to fix it.
>>> so you get my:
>>>
>>> Tested-by: Eliad Peller <eliad@wizery.com>
>>>
>>> Eliad.



-- 
Janusz Dziedzic
