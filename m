Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752299AbcKVHYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 02:24:15 -0500
Message-ID: <1479799452.2517.39.camel@coelho.fi> (sfid-20161122_082424_342717_9DEDB4A2)
From: Luca Coelho <luca@coelho.fi>
To: dimitrysh@google.com, linux-wireless@vger.kernel.org
Date: Tue, 22 Nov 2016 09:24:12 +0200
In-Reply-To: <94eb2c110db85c2379054172dad0@google.com>
References: <94eb2c110db85c2379054172dad0@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] RFC: Universal scan proposal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,
On Wed, 2016-11-16 at 22:47 +0000, dimitrysh@google.com wrote:
>  From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
> From: Dmitry Shmidt <dimitrysh@google.com>
> Date: Wed, 16 Nov 2016 14:27:26 -0800
> Subject: [PATCH] RFC: Universal scan proposal
> 
>    Currently we have sched scan with possibility of various
> intervals. We would like to extend it to support also
> different types of scan.
>    In case of powerful wlan CPU, all this functionality
> can be offloaded.
>    In general case FW processes additional scan requests
> and puts them into queue based on start time and interval.
> Once current request is fulfilled, FW adds it (if interval != 0)
> again to the queue with proper interval. If requests are
> overlapping, new request can be combined with either one before,
> or one after, assuming that requests are not mutually exclusive.
>    Combining requests is done by combining scan channels, ssids,
> bssids and types of scan result. Once combined request was fulfilled
> it will be reinserted as two (or three) different requests based on
> their type and interval.
>    Each request has attribute:
> Type: connectivity / location
> Report: none / batch / immediate
>    Request may have priority and can be inserted into
> the head of the queue.
>    Types of scans:
> - Normal scan
> - Scheduled scan
> - Hotlist (BSSID scan)
> - Roaming
> - AutoJoin
> 
> Change-Id: I9f3e4c975784f1c1c5156887144d80fc5a26bffa
> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> ---

I like the initiative and I think this is definitely something that can
improve concurrent scanning instances.  But IMHO the most important is
to discuss the semantics of this change, such as which scans can be
combined, who makes the decisions of combining them, how priorities are
sorted out etc.  I think the types of scan are not relevant in the
nl80211 API, but the characteristics of the scans are.  For instance,
"urgent scan" (for initial connection), best-effort scan for roaming...
and latency requirements, such as low-latency for location and initial
connection and high-latency for scheduled scan.  Then we decided, in
the kernel, how to combine and prioritize them according to their
characteristics, instead of having to map scan types to these
characteristics.

What do you think?

--
Cheers,
Luca.
