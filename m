Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754926AbdDDVxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 17:53:18 -0400
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20170329174751.13184-1-hdegoede@redhat.com>
 <4d1d3c02-eff6-0410-cee0-9360ec645e13@lwfinger.net>
 <d5fc988b-2962-9c44-7eac-96dba606f56a@redhat.com>
 <a848408c-edd9-075b-1bd5-8e77ca4f42f9@broadcom.com>
Cc: Bastien Nocera <hadess@hadess.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <049673a4-647b-a270-bb9c-15bb2ab49fc4@redhat.com> (sfid-20170404_235345_356389_9E2206B3)
Date: Tue, 4 Apr 2017 23:53:15 +0200
MIME-Version: 1.0
In-Reply-To: <a848408c-edd9-075b-1bd5-8e77ca4f42f9@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 04/04/2017 11:38 PM, Arend Van Spriel wrote:
>
>
> On 4-4-2017 20:53, Hans de Goede wrote:
>> Hi,
>>
>> On 04/04/2017 08:31 PM, Larry Finger wrote:
>>> On 03/29/2017 12:47 PM, Hans de Goede wrote:
>>>> The rtl8723bs is found on quite a few systems used by Linux users,
>>>> such as on Atom systems (Intel Computestick and various other
>>>> Atom based devices) and on many (budget) ARM boards such as
>>>> the CHIP.
>>>>
>>>> The plan moving forward with this is for the new clean,
>>>> written from scratch, rtl8xxxu driver to eventually gain
>>>> support for sdio devices. But there is no clear timeline
>>>> for that, so lets add this driver included in staging for now.
>>>
>>> Hans,
>>>
>>> I started looking at the Smatch errors. This one may be the result of
>>> a serious problem:
>>>
>>>   CHECK   drivers/staging/rtl8723bs/core/rtw_debug.c
>>> drivers/staging/rtl8723bs/core/rtw_debug.c:454 proc_get_survey_info()
>>> error: we previously assumed 'phead' could be null (see line 453)
>>> drivers/staging/rtl8723bs/core/rtw_debug.c:455 proc_get_survey_info()
>>> warn: variable dereferenced before check 'phead' (see line 454)
>>>
>>> A snippet of the code in question is as follows:
>>>
>>>         spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
>>>         phead = get_list_head(queue);
>>>         plist = phead ? get_next(phead) : NULL;
>>>         plist = get_next(phead);
>>>         if ((!phead) || (!plist)) {
>>>                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
>>>                 return 0;
>>>         }
>>>
>>> This code comes directly from the hadess repo, but I am suspicious of
>>> the double call to get_next(phead). I cannot imagine any valid reason
>>> to skip every other entry on that list.
>>
>> If you look closer and simplify the first getnext line what is written is:
>>
>>          plist = get_next(phead);
>>          plist = get_next(phead);
>>
>> Which indeed looks like it could use improvement, but I don't
>> think it is seriously broken.
>
> So get_list_head(queue) can never return NULL?

I don't know.

> Otherwise I don't know
> how close I need to get for a simplified look ;-)

I simplified things so as to make clear that Larry's worry was
not really a problem, I do agree the smatch complaint is valid.

Regards,

Hans
