Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34899 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbcLEScs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 13:32:48 -0500
Received: by mail-io0-f169.google.com with SMTP id a124so610724295ioe.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 10:32:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480948100.31788.15.camel@sipsolutions.net>
References: <94eb2c110db85c2379054172dad0@google.com> <1480948100.31788.15.camel@sipsolutions.net>
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Mon, 5 Dec 2016 10:32:36 -0800
Message-ID: <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com> (sfid-20161205_193252_119697_31120007)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, Dec 5, 2016 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi Dmitry,
>
> Sorry I didn't respond earlier.
>
>>    Currently we have sched scan with possibility of various
>> intervals. We would like to extend it to support also
>> different types of scan.
>
> "Different types of scan" is a bit misleading though, isn't it? I mean,
> mostly they differ in the reporting modes - the scanning itself still
> happens at "various intervals"?
>
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
>
> I'm not super happy with this - after all, in theory nothing precludes
> using the results for one thing or the other, it's just about when and
> how they are gathered, no?

Indeed, results are results. I just want to take care of two things:
1) Memory consumption - we can clear stale scan results for connection,
but not for location if we are using history scan.
2) Use of insufficient results for connection - in case we had history
or hotlist scan only for very limited amount of channels, then we may not
have enough APs in our result for "sterling" connection decision.

> You do have a point wrt. an incomplete scan triggering something wrt.
> roaming or so in the connection manager, but I think that if it finds a
> better result there than the current connection it would make sense to
> pick it - even without full information.
>
> So ultimately, I think this might boil down to reporting the scan
> finished more accurately/precisely, rather than saying the type of
> scan?

This is intertwined with Luca's and yours point below - to use
scan by name or by description of the actions. Indeed maybe
this way is more generic and more useful.

>> Report: none / batch / immediate
>
> Not sure I see much point in "none"??
>
> Can you define these more clearly? Do you think "batch" reporting
> should be like the gscan buckets? Or actually have full information?

None - means that there is not need to report. It can be useful
in case of roaming scan, scheduling or hotlist scan - you didn't find
anything suitable - don't report that there is no scan results.
Batch - means to report only when buffer is full (or close to full) -
mostly for history scan or for example for case to report all scan
results together.

Immediate - is kind of self-explaining.

>>    Request may have priority and can be inserted into
>> the head of the queue.
>>    Types of scans:
>> - Normal scan
>> - Scheduled scan
>> - Hotlist (BSSID scan)
>> - Roaming
>> - AutoJoin
>
> I think somebody else said this but I didn't find it now - I think this
> would make more sense to define in terms of expected behaviour than use
> cases for each type of scan.

I think Luca made this statement. It is totally ok from SW point of
view - especially due to the fact that scan is scan. However,
I suspect it will be harder to handle from user experience. I mean
at the end wireless framework / driver / FW will convert special
scan type to usual scan with special params and response, but why
to put this burden on user?
Anyway, I am ok with this approach as well. If we see that it is
confusing we can use scan wrappers.

> johannes
>
