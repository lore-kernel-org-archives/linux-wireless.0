Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756509AbdDFGzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 02:55:20 -0400
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
References: <20170329174751.13184-1-hdegoede@redhat.com>
 <4d1d3c02-eff6-0410-cee0-9360ec645e13@lwfinger.net>
 <d5fc988b-2962-9c44-7eac-96dba606f56a@redhat.com>
 <a848408c-edd9-075b-1bd5-8e77ca4f42f9@broadcom.com>
 <049673a4-647b-a270-bb9c-15bb2ab49fc4@redhat.com>
 <c9a1b5a2-d0a9-bb92-2d70-c54cc7bf1f8d@lwfinger.net>
 <560981e0-e1b0-7a06-80e4-14d677c7d64a@redhat.com>
 <15871468-0086-2d66-328b-0699ef6f4b31@lwfinger.net>
Cc: Bastien Nocera <hadess@hadess.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5d15c6e8-7c15-4226-c4be-d8db6ded29ef@redhat.com> (sfid-20170406_085715_022584_05A7DC61)
Date: Thu, 6 Apr 2017 08:55:15 +0200
MIME-Version: 1.0
In-Reply-To: <15871468-0086-2d66-328b-0699ef6f4b31@lwfinger.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 05-04-17 18:32, Larry Finger wrote:
> On 04/05/2017 04:36 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 05-04-17 01:41, Larry Finger wrote:
>>> On 04/04/2017 04:53 PM, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 04/04/2017 11:38 PM, Arend Van Spriel wrote:
>>>>>
>>>>>
>>>>> On 4-4-2017 20:53, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 04/04/2017 08:31 PM, Larry Finger wrote:
>>>>>>> On 03/29/2017 12:47 PM, Hans de Goede wrote:
>>>>>>>> The rtl8723bs is found on quite a few systems used by Linux users,
>>>>>>>> such as on Atom systems (Intel Computestick and various other
>>>>>>>> Atom based devices) and on many (budget) ARM boards such as
>>>>>>>> the CHIP.
>>>>>>>>
>>>>>>>> The plan moving forward with this is for the new clean,
>>>>>>>> written from scratch, rtl8xxxu driver to eventually gain
>>>>>>>> support for sdio devices. But there is no clear timeline
>>>>>>>> for that, so lets add this driver included in staging for now.
>>>>>>>
>>>>>>> Hans,
>>>>>>>
>>>>>>> I started looking at the Smatch errors. This one may be the result of
>>>>>>> a serious problem:
>>>>>>>
>>>>>>>   CHECK   drivers/staging/rtl8723bs/core/rtw_debug.c
>>>>>>> drivers/staging/rtl8723bs/core/rtw_debug.c:454 proc_get_survey_info()
>>>>>>> error: we previously assumed 'phead' could be null (see line 453)
>>>>>>> drivers/staging/rtl8723bs/core/rtw_debug.c:455 proc_get_survey_info()
>>>>>>> warn: variable dereferenced before check 'phead' (see line 454)
>>>>>>>
>>>>>>> A snippet of the code in question is as follows:
>>>>>>>
>>>>>>>         spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
>>>>>>>         phead = get_list_head(queue);
>>>>>>>         plist = phead ? get_next(phead) : NULL;
>>>>>>>         plist = get_next(phead);
>>>>>>>         if ((!phead) || (!plist)) {
>>>>>>>                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
>>>>>>>                 return 0;
>>>>>>>         }
>>>>>>>
>>>>>>> This code comes directly from the hadess repo, but I am suspicious of
>>>>>>> the double call to get_next(phead). I cannot imagine any valid reason
>>>>>>> to skip every other entry on that list.
>>>>>>
>>>>>> If you look closer and simplify the first getnext line what is written is:
>>>>>>
>>>>>>          plist = get_next(phead);
>>>>>>          plist = get_next(phead);
>>>>>>
>>>>>> Which indeed looks like it could use improvement, but I don't
>>>>>> think it is seriously broken.
>>>>>
>>>>> So get_list_head(queue) can never return NULL?
>>>>
>>>> I don't know.
>>>>
>>>>> Otherwise I don't know
>>>>> how close I need to get for a simplified look ;-)
>>>>
>>>> I simplified things so as to make clear that Larry's worry was
>>>> not really a problem, I do agree the smatch complaint is valid.
>>>
>>> I think the following fixes the problem:
>>>
>>> diff --git a/drivers/staging/rtl8723bs/core/rtw_debug.c
>>> b/drivers/staging/rtl8723bs/core/rtw_debug.c
>>> index d34747b29309..51cef55d3f76 100644
>>> --- a/drivers/staging/rtl8723bs/core/rtw_debug.c
>>> +++ b/drivers/staging/rtl8723bs/core/rtw_debug.c
>>> @@ -451,7 +451,6 @@ int proc_get_survey_info(struct seq_file *m, void *v)
>>>         spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
>>>         phead = get_list_head(queue);
>>>         plist = phead ? get_next(phead) : NULL;
>>> -       plist = get_next(phead);
>>>         if ((!phead) || (!plist)) {
>>>                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
>>>                 return 0;
>>>
>>> Pointer plist is set in the 3rd line, thus the second set of it can be removed.
>>
>> Agreed, when I've some time I plan to do a follow-up patch
>> to my initial submission fixing all the Smatch errors. But feel
>> free to beat me to it.
>>
>> Greg, if I understood you correctly you plan to merge my initial
>> submission as is and then we can fix this (and other things) with
>> follow up patches, right ?
>
> Hans,
>
> I took GregKH out of the Cc list when I started the discussion of the Smatch errors/warnings, and he probably has not seen the recent E-mails in this thread.

Ah I missed that (clearly I did).

> It it was my understanding that he planned to apply your submission in the form you sent.

That is my understanding too.

> I have several patches nearly ready to fix most of the Smatch warnings and errors. I will send them as soon as the original submission is applied.

Good thank you. So what is the plan with the github version ?

Note that my submission contains a few small fixes on top of
the github version, for which I intended to submit a pull-req
but I've not gotten around to that yet, I've done so now:

https://github.com/hadess/rtl8723bs/pull/125

But do we want to keep maintaining the github version (for a while
at least) I wonder, as that does mean double work?

Regards,

Hans
