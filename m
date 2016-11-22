Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38796 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754550AbcKVR3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 12:29:25 -0500
Received: by mail-it0-f51.google.com with SMTP id j191so17629147ita.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 09:29:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479799452.2517.39.camel@coelho.fi>
References: <94eb2c110db85c2379054172dad0@google.com> <1479799452.2517.39.camel@coelho.fi>
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Tue, 22 Nov 2016 09:29:24 -0800
Message-ID: <CAH7ZN-z+QytCTHDs3dkU172hMio=T2Mhr8y=mXKXu=DRA1vA3A@mail.gmail.com> (sfid-20161122_182936_816645_6A164982)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

On Mon, Nov 21, 2016 at 11:24 PM, Luca Coelho <luca@coelho.fi> wrote:
> Hi Dmitry,
> On Wed, 2016-11-16 at 22:47 +0000, dimitrysh@google.com wrote:
>>  From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
>> From: Dmitry Shmidt <dimitrysh@google.com>
>> Date: Wed, 16 Nov 2016 14:27:26 -0800
>> Subject: [PATCH] RFC: Universal scan proposal
>>
>>    Currently we have sched scan with possibility of various
>> intervals. We would like to extend it to support also
>> different types of scan.
>>    In case of powerful wlan CPU, all this functionality
>> can be offloaded.
>>    In general case FW processes additional scan requests
>> and puts them into queue based on start time and interval.
>> Once current request is fulfilled, FW adds it (if interval != 0)
>> again to the queue with proper interval. If requests are
>> overlapping, new request can be combined with either one before,
>> or one after, assuming that requests are not mutually exclusive.
>>    Combining requests is done by combining scan channels, ssids,
>> bssids and types of scan result. Once combined request was fulfilled
>> it will be reinserted as two (or three) different requests based on
>> their type and interval.
>>    Each request has attribute:
>> Type: connectivity / location
>> Report: none / batch / immediate
>>    Request may have priority and can be inserted into
>> the head of the queue.
>>    Types of scans:
>> - Normal scan
>> - Scheduled scan
>> - Hotlist (BSSID scan)
>> - Roaming
>> - AutoJoin
>>
>> Change-Id: I9f3e4c975784f1c1c5156887144d80fc5a26bffa
>> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
>> ---
>
> I like the initiative and I think this is definitely something that can
> improve concurrent scanning instances.  But IMHO the most important is
> to discuss the semantics of this change, such as which scans can be
> combined, who makes the decisions of combining them, how priorities are
> sorted out etc.  I think the types of scan are not relevant in the
> nl80211 API, but the characteristics of the scans are.  For instance,
> "urgent scan" (for initial connection), best-effort scan for roaming...
> and latency requirements, such as low-latency for location and initial
> connection and high-latency for scheduled scan.  Then we decided, in
> the kernel, how to combine and prioritize them according to their
> characteristics, instead of having to map scan types to these
> characteristics.
>
> What do you think?

1. Combining scans.
There are two scenarios in general: combine scans that can be offload
and scans that can not be offload due to "weak" FW / wlan SoC. In last
case this approach maybe not attractive at all - non-mobile device
may not need all these different types of scan.
In case of offload - it will be FW code decision - I just wanted to propose
the way how to do this efficiently.

2. Priority - very good point, we need to have it. I am just not sure
that we need like scale priority - maybe just flag - urgent / not urgent.
Urgent one will be inserted in queue as is and conflicting request
should be postponed or combined.

3. Scan types - I am not sure I fully understood your question, but
if the idea is for kernel to decide about type of scan based on its
characteristics instead of specific type request performance may
cause confusion to wifi manager.
However, it would definitely simplify kernel API. Still I am not sure
if userspace wifi manager will "like" it.

4. There is an interesting question: to separate scan results for
connection and location or not? The problem is how to "trust" them.
I mean scan results are scan results, but for location we may decide
to look for fewer channels and even maybe specific BSSIDs, i.e. not
full scan results, and we may need to indicate that right now
scan results are not full in order not to confuse wifi manager.

> --
> Cheers,
> Luca.
