Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43188 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbcLEO2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:28:23 -0500
Message-ID: <1480948100.31788.15.camel@sipsolutions.net> (sfid-20161205_152827_051758_080948A3)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: dimitrysh@google.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 15:28:20 +0100
In-Reply-To: <94eb2c110db85c2379054172dad0@google.com> (sfid-20161116_235236_736106_A8DBAB02)
References: <94eb2c110db85c2379054172dad0@google.com>
         (sfid-20161116_235236_736106_A8DBAB02)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Sorry I didn't respond earlier.

>    Currently we have sched scan with possibility of various
> intervals. We would like to extend it to support also
> different types of scan.

"Different types of scan" is a bit misleading though, isn't it? I mean,
mostly they differ in the reporting modes - the scanning itself still
happens at "various intervals"?

>    In case of powerful wlan CPU, all this functionality
> can be offloaded.
>    In general case FW processes additional scan requests
> and puts them into queue based on start time and interval.
> Once current request is fulfilled, FW adds it (if interval != 0)
> again to the queue with proper interval. If requests are
> overlapping, new request can be combined with either one before,
> or one after, assuming that requests are not mutually exclusive.
>    Combining requests is done by combining scan channels, ssids,
> bssids and types of scan result. Once combined request was fulfilled
> it will be reinserted as two (or three) different requests based on
> their type and interval.
>    Each request has attribute:
> Type: connectivity / location

I'm not super happy with this - after all, in theory nothing precludes
using the results for one thing or the other, it's just about when and
how they are gathered, no?

You do have a point wrt. an incomplete scan triggering something wrt.
roaming or so in the connection manager, but I think that if it finds a
better result there than the current connection it would make sense to
pick it - even without full information.

So ultimately, I think this might boil down to reporting the scan
finished more accurately/precisely, rather than saying the type of
scan?

> Report: none / batch / immediate

Not sure I see much point in "none"??

Can you define these more clearly? Do you think "batch" reporting
should be like the gscan buckets? Or actually have full information?

>    Request may have priority and can be inserted into
> the head of the queue.
>    Types of scans:
> - Normal scan
> - Scheduled scan
> - Hotlist (BSSID scan)
> - Roaming
> - AutoJoin

I think somebody else said this but I didn't find it now - I think this
would make more sense to define in terms of expected behaviour than use
cases for each type of scan.

johannes
