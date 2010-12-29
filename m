Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55908 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0L2Nzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 08:55:32 -0500
Received: by fxm20 with SMTP id 20so10455243fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 05:55:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293529983.3526.9.camel@jlt3.sipsolutions.net>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
	<AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
	<201012281843.57453.br1@einfach.org>
	<1293529861.3526.8.camel@jlt3.sipsolutions.net>
	<1293529983.3526.9.camel@jlt3.sipsolutions.net>
Date: Wed, 29 Dec 2010 13:55:30 +0000
Message-ID: <AANLkTikrUTG-q1ZfqFEGT5x1HZRjpdyMhYLr6ZhjxEs2@mail.gmail.com>
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
From: Dave Kilroy <kilroyd@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 9:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-12-28 at 10:51 +0100, Johannes Berg wrote:
>
>> > ieee80211_dsss_chan_to_freq - atmel, airo, wl3501_cs, orinoco, rndis_wlan
>> > ieee80211_freq_to_dsss_chan - atmel, airo, orinoco, zd1201
>> >
>> > Anyhow i guess it would make sense to have a common channel to frequency
>> > mapping function for mac80211 and other wireless drivers? The problem is now
>> > we have to use enum ieee80211_band which is defined cfg80211.h...
>
> Interestingly, I just noticed that the above ones also have different
> semantics -- they try to round to the nearest channel rather than
> returning an error if the center frequency isn't exact.

I suspect I introduced these functions while refactoring orinoco (well
before the cfg80211 conversion). If I recall correctly, there was no
specific reason for the round to nearest behaviour - it just seemed
more appropriate than rounding down the frequencies. So if it helps, I
don't see why we shouldn't modify the behaviour of the ieee80211
functions where necessary.

Dave.
