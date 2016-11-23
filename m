Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:32922 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933274AbcKWInw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 03:43:52 -0500
Received: by mail-pg0-f44.google.com with SMTP id 3so3828423pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 00:43:51 -0800 (PST)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Dmitry Shmidt <dimitrysh@google.com>
References: <94eb2c110db85c2379054172dad0@google.com>
 <1479799452.2517.39.camel@coelho.fi>
 <CAH7ZN-z+QytCTHDs3dkU172hMio=T2Mhr8y=mXKXu=DRA1vA3A@mail.gmail.com>
 <b81eaa82-8b03-1ac7-0130-e617c5a0904e@broadcom.com>
 <CAH7ZN-wHUU+zZx8F3jKX9k3VeHLvVoSUtrePfmKyaFGUgh3h-g@mail.gmail.com>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a803ed1f-14bf-0606-bb87-39932d32ba0b@broadcom.com> (sfid-20161123_094405_706645_2D98F796)
Date: Wed, 23 Nov 2016 09:43:45 +0100
MIME-Version: 1.0
In-Reply-To: <CAH7ZN-wHUU+zZx8F3jKX9k3VeHLvVoSUtrePfmKyaFGUgh3h-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-11-2016 21:54, Dmitry Shmidt wrote:
> On Tue, Nov 22, 2016 at 12:41 PM, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 22-11-2016 18:29, Dmitry Shmidt wrote:
>>> Hi Luca,
>>>
>>> On Mon, Nov 21, 2016 at 11:24 PM, Luca Coelho <luca@coelho.fi> wrote:
>>>> Hi Dmitry,
>>>> On Wed, 2016-11-16 at 22:47 +0000, dimitrysh@google.com wrote:
>>>>>  From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
>>>>> From: Dmitry Shmidt <dimitrysh@google.com>
>>>>> Date: Wed, 16 Nov 2016 14:27:26 -0800
>>>>> Subject: [PATCH] RFC: Universal scan proposal
>>>>>
>>>>>    Currently we have sched scan with possibility of various
>>>>> intervals. We would like to extend it to support also
>>>>> different types of scan.
>>>>>    In case of powerful wlan CPU, all this functionality
>>>>> can be offloaded.
>>>>>    In general case FW processes additional scan requests
>>>>> and puts them into queue based on start time and interval.
>>>>> Once current request is fulfilled, FW adds it (if interval != 0)
>>>>> again to the queue with proper interval. If requests are
>>>>> overlapping, new request can be combined with either one before,
>>>>> or one after, assuming that requests are not mutually exclusive.
>>>>>    Combining requests is done by combining scan channels, ssids,
>>>>> bssids and types of scan result. Once combined request was fulfilled
>>>>> it will be reinserted as two (or three) different requests based on
>>>>> their type and interval.
>>>>>    Each request has attribute:
>>>>> Type: connectivity / location
>>>>> Report: none / batch / immediate
>>>>>    Request may have priority and can be inserted into
>>>>> the head of the queue.
>>>>>    Types of scans:
>>>>> - Normal scan
>>>>> - Scheduled scan
>>>>> - Hotlist (BSSID scan)
>>>>> - Roaming
>>>>> - AutoJoin
>>>>>
>>>>> Change-Id: I9f3e4c975784f1c1c5156887144d80fc5a26bffa
>>>>> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
>>>>> ---
>>>>
>>>> I like the initiative and I think this is definitely something that can
>>>> improve concurrent scanning instances.  But IMHO the most important is
>>>> to discuss the semantics of this change, such as which scans can be
>>>> combined, who makes the decisions of combining them, how priorities are
>>>> sorted out etc.  I think the types of scan are not relevant in the
>>>> nl80211 API, but the characteristics of the scans are.  For instance,
>>>> "urgent scan" (for initial connection), best-effort scan for roaming...
>>>> and latency requirements, such as low-latency for location and initial
>>>> connection and high-latency for scheduled scan.  Then we decided, in
>>>> the kernel, how to combine and prioritize them according to their
>>>> characteristics, instead of having to map scan types to these
>>>> characteristics.
>>>>
>>>> What do you think?
>>>
>>> 1. Combining scans.
>>> There are two scenarios in general: combine scans that can be offload
>>> and scans that can not be offload due to "weak" FW / wlan SoC. In last
>>> case this approach maybe not attractive at all - non-mobile device
>>> may not need all these different types of scan.
>>> In case of offload - it will be FW code decision - I just wanted to propose
>>> the way how to do this efficiently.
>>
>> I think Luca is looking at it as a way to deal with multiple user-space
>> entities request the device to perform a scan. Ignoring the scan types
>> on android it can be wifi-hal and wpa_supplicant.
>>
>>> 2. Priority - very good point, we need to have it. I am just not sure
>>> that we need like scale priority - maybe just flag - urgent / not urgent.
>>> Urgent one will be inserted in queue as is and conflicting request
>>> should be postponed or combined.
>>
>> What if we get another urgent one?
> 
> We may restrict it only to one urgent scan - what is the use case for
> two requests?

We don't know I guess so we can restrict to one for now. Just wondered
reading this.

>>> 3. Scan types - I am not sure I fully understood your question, but
>>> if the idea is for kernel to decide about type of scan based on its
>>> characteristics instead of specific type request performance may
>>> cause confusion to wifi manager.
>>> However, it would definitely simplify kernel API. Still I am not sure
>>> if userspace wifi manager will "like" it.
>>
>> Actually the idea is to hide the notion of scan type entirely from the
>> API and kernel code. If you add the scan type as an attribute in the
>> API, you still need to provide additional attributes for that scan type
>> so the question is what the scan type itself provides, ie. how does it
>> affect the scan itself.
> 
> Right, some scans types can be easily hidden behind scan parameters
> like scan for SSID or BSSID or maybe even Roaming with list of
> SSIDs or BSSIDs, or mix... However, scan history for example should
> be separate, right?

Not sure what scan history means. cfg80211 currently maintains the
latest information for a given BSS. So I guess for a "scan history"
request user-space can specify "history depth" parameter. It may become
a bit memory intensive to retain all BSS information like that so we may
need to identify the BSS attributes for which historic values are needed
by user-space. Now what to do when a "scan history" is in progress and a
"normal scan" is requested with flush flag attribute set?

>>> 4. There is an interesting question: to separate scan results for
>>> connection and location or not? The problem is how to "trust" them.
>>> I mean scan results are scan results, but for location we may decide
>>> to look for fewer channels and even maybe specific BSSIDs, i.e. not
>>> full scan results, and we may need to indicate that right now
>>> scan results are not full in order not to confuse wifi manager.

Another things is that when combining requests, we are combining results
as well. So if requester A wants to look for SSIDs X and Y and requester
B wants to look for SSID Z, both requester A and B will get results for
X, Y, and Z when requests are combined.

Regards,
Arend
