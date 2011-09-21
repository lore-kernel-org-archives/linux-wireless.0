Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:45731 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab1IUJEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 05:04:08 -0400
Received: by mail-bw0-f42.google.com with SMTP id r4so1558801bka.15
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 02:04:06 -0700 (PDT)
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: victorg@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1316594138.3940.10.camel@jlt3.sipsolutions.net>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <4E799DF9.9060807@ti.com>  <1316594138.3940.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 12:03:58 +0300
Message-ID: <1316595838.2157.468.camel@cumari> (sfid-20110921_110412_577381_002BC5C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 10:35 +0200, Johannes Berg wrote: 
> On Wed, 2011-09-21 at 11:19 +0300, Victor Goldenshtein wrote:
> 
> > Just talked with Luciano, and we though to make this event more generic 
> > and to pass the whole BSS info instead of just BSSID and rssi, what do 
> > you think?
> 
> I think there are two choices:
> 
> 1) do what you say, and send the whole BSS info in the event
> 
> 2) send a per-channel "scanned this channel" event, and allow filtering
> the BSS dump per channel
> 
> 
> There are a few trade-offs here:
> 
> advantages of 1:
> + info is directly available
> + very fine-grained
> 
> disadvantages of 1:
> - lots of context switches, fairly expensive

I just want to mention that these context switches will be there
regardless of whether the full BSS info is passed or not.


> advantages of 2:
> + adds more generic filtering capability

What do you mean here? I think we can have quite generic filtering in
both cases.


> + fewer context switches since retrieving BSS dump is limited & only
> needs very few messages

Indeed the number of switches will be smaller.  To improve it further,
as we discussed on IRC, we should also implement a per-channel BSS dump,
otherwise we would have to retrieve the same data over an over again.


> disadvantages of 2:
> - not quite as fine-grained

One more:
- this requires HW support (which we don't have in wl12xx ;), unless SW
scan is used


> Personally, I prefer 2 because of the context switches issue, and
> because I think there's little point in having so fine-grained
> information. But I'm willing to concede that there may be a point in it,
> more easily if you could explain why that's useful :-)

I see your point about reducing the context switches while still
increasing the granularity of scan results with this option 2, but I
think it's not going to be that helpful.  Sure we can stop the scan
earlier if we find what we want, but the possibilities will be smaller.

Also, with option 2, you may have more context switches too, if you're
scanning on not-so-crowded areas.  If we report results per-channel, we
will always have at least 37 events (with 11a and 11bg), each triggering
at least 3 context switches, because userspace requests the BSS dump
separately.  If we use per-results events, including all BSS info, we
will have just as many context switches as there are results available.

Thus, I think passing intermediate result events, as they come, is more
flexible and efficient in normal situations.  And if we really want to
reduce the context switches and data copied from kernel to userspace, we
also have the option of improving results filtering.  We could make some
similar "match" filters as I have recently implemented for sched_scans.

-- 
Cheers,
Luca.

