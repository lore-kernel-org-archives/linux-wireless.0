Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46536 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab0FPUkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 16:40:25 -0400
Received: by pva4 with SMTP id 4so856876pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 13:40:18 -0700 (PDT)
Message-ID: <4C1936BE.9030504@gmail.com>
Date: Wed, 16 Jun 2010 13:40:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"greg@kroah.com" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Peter Stuge <peter@stuge.se>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.32.y] ath9k: re-enable ps by default for new single
 chip families
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com> <20100616081227.GA1118@boggieman> <4C18D2A5.5080702@gmail.com> <AANLkTimDp52ULRcO9NMgeV34olfpD97wYfmr_atOQ5AF@mail.gmail.com> <4C18F560.1010408@gmail.com> <20100616175318.GA26198@tux> <4C1914C1.602@gmail.com> <20100616181622.GD26198@tux> <4C1922AB.9090604@gmail.com> <20100616200624.GE26198@tux>
In-Reply-To: <20100616200624.GE26198@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2010 01:06 PM, Luis R. Rodriguez wrote:
> On Wed, Jun 16, 2010 at 12:14:51PM -0700, Justin P. Mattock wrote:
>> On 06/16/2010 11:16 AM, Luis R. Rodriguez wrote:
>>> On Wed, Jun 16, 2010 at 11:15:29AM -0700, Justin P. Mattock wrote:
>>>> On 06/16/2010 10:53 AM, Luis R. Rodriguez wrote:
>>>>> On Wed, Jun 16, 2010 at 09:01:36AM -0700, Justin P. Mattock wrote:
>>>>>> On 06/16/2010 08:49 AM, Luis R. Rodriguez wrote:
>>>>>>> On Wed, Jun 16, 2010 at 6:33 AM, Justin P. Mattock
>>>>>>> <justinmattock@gmail.com>     wrote:
>>>>>>>> On 06/16/2010 01:12 AM, Kristoffer Ericson wrote:
>>>>>>>>>
>>>>>>>>> On Tue, Jun 15, 2010 at 06:19:19PM -0400, Luis R. Rodriguez wrote:
>>>>>>>>>>
>>>>>>>>>> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
>>>>>>>>>>
>>>>>>>>>> The newer single chip hardware family of chipsets have not been
>>>>>>>>>> experiencing issues with power saving set by default with recent
>>>>>>>>>> fixes merged (even into stable). The remaining issues are only
>>>>>>>>>> reported with AR5416 and since enabling PS by default can increase
>>>>>>>>>> power savings considerably best to take advantage of that feature
>>>>>>>>>> as this has been tested properly.
>>>>>>>>>
>>>>>>>>> I havent had any issues lately. But that said Ive moved on to
>>>>>>>>> 2.6.33, 2.6.34 which seems to work fine. Believe you set
>>>>>>>>> to disabled by default on those?
>>>>>>>>>
>>>>>>>>> /Kristoffer
>>>>>>>>>
>>>>>>>>
>>>>>>>> just tried to add this patch to the latest HEAD, but realized
>>>>>>>> ath_set_hw_capab is missing(or I cant seem to grep it)
>>>>>>>> if you have a patch for the latest tree let me know I can see if I'm hitting
>>>>>>>> anything like before.
>>>>>>>
>>>>>>> The patch would already be merged since 2.6.33.y, this patch is a
>>>>>>> backport for 2.6.32.y. I just hadn't had time to backport it yet,
>>>>>>> until today.
>>>>>>>
>>>>>>>       Luis
>>>>>>>
>>>>>>
>>>>>> so its already in there then..
>>>>>
>>>>> Right
>>>>>
>>>>>> if that's the case then the system runs
>>>>>> good with powersave on then..
>>>>>
>>>>> Did you read the patch by chance? It only enables power save for
>>>>> non-AR5416 hardware. What do you have?
>>>>>
>>>>>      Luis
>>>>>
>>>>
>>>> mine is the AR5008
>>>
>>> Ok I should say, all AR5008 and AR9001 family chipsets have
>>> power save disabled still. Only AR9002 and up have it enabled
>>> now. The patch was doing the same for 2.6.32.
>>>
>>>     Luis
>>>
>>
>> o.k. I have not tried what powersave does since the last time I looked
>> into this bug(if I remember 2.6.31/2 or so) I can manually
>> turn it on with iwconfig and see..
>
> Thanks but no need, its not the purpose of the patch.
>
>    Luis
>

o.k.

Justin P. Mattock
