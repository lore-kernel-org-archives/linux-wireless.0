Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36113 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdBOKyr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:54:47 -0500
Received: by mail-pg0-f44.google.com with SMTP id v184so36184367pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:54:47 -0800 (PST)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170214132208.8715-1-johannes@sipsolutions.net>
 <20170214132208.8715-4-johannes@sipsolutions.net>
 <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com>
 <1487150216.4026.18.camel@sipsolutions.net>
 <d050648f-df94-8138-b9af-1ec18ba4af28@broadcom.com>
 <1487152112.4026.19.camel@sipsolutions.net>
 <1f3197b6-2860-632c-bbbb-3afac16f6edc@broadcom.com>
 <827a5262-4a4b-d550-d5fe-fd53f3bb53db@broadcom.com>
 <1487155302.4026.21.camel@sipsolutions.net>
Cc: j@w1.fi, greearb@candelatech.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e4778e0c-59b6-16ff-9e4d-fa4057290fd6@broadcom.com> (sfid-20170215_115450_625565_EC1AD681)
Date: Wed, 15 Feb 2017 11:54:42 +0100
MIME-Version: 1.0
In-Reply-To: <1487155302.4026.21.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-2-2017 11:41, Johannes Berg wrote:
> On Wed, 2017-02-15 at 11:34 +0100, Arend Van Spriel wrote:
>> On 15-2-2017 11:34, Arend Van Spriel wrote:
>>> On 15-2-2017 10:48, Johannes Berg wrote:
>>>> On Wed, 2017-02-15 at 10:36 +0100, Arend Van Spriel wrote:
>>>>>
>>>>>> I'm not really sure what to do - we don't really want to
>>>>>> print a
>>>>>> message on something that might have been received from the
>>>>>> peer, I
>>>>>> think? Though I suppose we should return 0 for the invalid
>>>>>> combinations, indicating that they're not supported.
>>>>>
>>>>> Ah. This is all non-functional code yet, right? At least having
>>>>> a
>>>>> static non-inline function in ieee80211.h will give build
>>>>> issues I
>>>>> would think.
>>>>
>>>> No, I marked it __maybe_unused so it'll be fine. I didn't want to
>>>> have
>>>> it inlined if you use it multiple times in a single source file,
>>>> but I
>>>> didn't want to move it to somewhere else either ...
>>>
>>> Ah. Now I understand the trickery ;-) Was there really no
>>> "somewhere
>>> else" to move it, because honestly it is confusing and a bit
>>> wasteful if
>>> used multiple times in cfg80211 and/or drivers.
>>
>> Although exporting it also comes at a cost.
> 
> Yeah, we could put it into cfg80211 and export it. I haven't really
> looked how big it is, but it does seem big.
> 
> The other thing is that the ieee80211.h file was pretty much standalone
> definitions of the spec until now - if we move it to cfg80211, should
> the function prototype really be declared in this file?

Well. You can look at it as being close to the spec (and it is), but if
it is a function for cfg80211-based drivers it should go in
include/net/cfg80211.h, right? Not sure though who will be using it
apart from mac80211. So I guess we can do with the trickery. Maybe
clearly mark it with a comment in ieee80211.h.

Regards,
Arend
