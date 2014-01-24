Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:63724 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaAXPcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:32:19 -0500
Received: by mail-oa0-f49.google.com with SMTP id i7so3906952oag.36
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 07:32:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390576776.4257.57.camel@jlt4.sipsolutions.net>
References: <20140106075126.GA31046@w1.fi>
	<1389110387.4645.26.camel@jlt4.sipsolutions.net>
	<20140107162655.GB9092@w1.fi>
	<CAMcMvshGwDB1G1urY18jYHr8mdXTapktfRsSgX0nhJjuPFW5Jg@mail.gmail.com>
	<1390576776.4257.57.camel@jlt4.sipsolutions.net>
Date: Fri, 24 Jan 2014 07:32:18 -0800
Message-ID: <CAMcMvshUuaPYeH2TesPAaYg7JN12+SYDFWg+=fmUM=ZOtB+Waw@mail.gmail.com> (sfid-20140124_163223_143812_B26E6178)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan requests
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 24, 2014 at 7:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2014-01-07 at 09:04 -0800, Paul Stewart wrote:
>
> > I've seen situations where it'd be useful to distinguish in user-space
> > between scan types.  Here are a few scenarios:
> >
> >  - Scanning for geo-location while associated (low-priority scan, tolerant
> >    to delayed/incomplete results, definitely not intended to interrupt or
> >    delay any inbound data traffic)
> >  - Background scan.  If there is traffic during the scan, we should abort
> >    (NL80211_SCAN_FLAG_LOW_PRIORITY should help with this).  If there is
> >    a history of traffic (e.g, an active data transfer) we might want to flag
> >    further that this scan should have shorter-than-usual dwell times as above.
>
> This makes sense, I'm not sure the first is all that much different from
> the second, though the precise meaning of "low priority" isn't all that
> well defined.
>
> >  - User-initiated scanning while idle in extremely congested networks
> >    (may need to actually wait a full beacon interval on each channel since
> >    the APs contend with each other to respond to probe requests -- user
> >    initiated, so it behooves us to get a complete list).
>
> That's an interesting situation, but I'm not sure how you'd ever detect
> which channels are extremely congested?


Off the top of my head, I suppose one could devise a heuristic based
on the ratio of beacons to probe-responses received on channel.  Also,
some drivers support the "channel busy time" or some such measure in
the survey results.
>
>
> johannes
>
