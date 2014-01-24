Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaAXPTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:19:39 -0500
Message-ID: <1390576776.4257.57.camel@jlt4.sipsolutions.net> (sfid-20140124_161957_361792_A1FF2FF6)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:19:36 +0100
In-Reply-To: <CAMcMvshGwDB1G1urY18jYHr8mdXTapktfRsSgX0nhJjuPFW5Jg@mail.gmail.com> (sfid-20140107_180500_544701_14625E03)
References: <20140106075126.GA31046@w1.fi>
	 <1389110387.4645.26.camel@jlt4.sipsolutions.net>
	 <20140107162655.GB9092@w1.fi>
	 <CAMcMvshGwDB1G1urY18jYHr8mdXTapktfRsSgX0nhJjuPFW5Jg@mail.gmail.com>
	 (sfid-20140107_180500_544701_14625E03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 09:04 -0800, Paul Stewart wrote:

> I've seen situations where it'd be useful to distinguish in user-space
> between scan types.  Here are a few scenarios:
> 
>  - Scanning for geo-location while associated (low-priority scan, tolerant
>    to delayed/incomplete results, definitely not intended to interrupt or
>    delay any inbound data traffic)
>  - Background scan.  If there is traffic during the scan, we should abort
>    (NL80211_SCAN_FLAG_LOW_PRIORITY should help with this).  If there is
>    a history of traffic (e.g, an active data transfer) we might want to flag
>    further that this scan should have shorter-than-usual dwell times as above.

This makes sense, I'm not sure the first is all that much different from
the second, though the precise meaning of "low priority" isn't all that
well defined.

>  - User-initiated scanning while idle in extremely congested networks
>    (may need to actually wait a full beacon interval on each channel since
>    the APs contend with each other to respond to probe requests -- user
>    initiated, so it behooves us to get a complete list).

That's an interesting situation, but I'm not sure how you'd ever detect
which channels are extremely congested?

johannes

