Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2I0Jnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 05:43:53 -0400
Received: by weyt9 with SMTP id t9so500653wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2012 02:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEfFy58mDxSWjO3whptsGhHjBMLJDWkkh6K6CQtW-KnMBg@mail.gmail.com>
References: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
 <1348737219.10353.6.camel@jlt4.sipsolutions.net> <CAB3XZEfFy58mDxSWjO3whptsGhHjBMLJDWkkh6K6CQtW-KnMBg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 27 Sep 2012 11:43:36 +0200
Message-ID: <CA+XVXff3J=9rqQjcFSstib=ptOsq62a8o5dqMgneperL=vUk2w@mail.gmail.com> (sfid-20120927_114404_946029_C1BAC6F9)
Subject: Re: [PATCH 0/3] add scan flags support
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sleffler@chromium.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2012 at 11:31 AM, Eliad Peller <eliad@wizery.com> wrote:
> On Thu, Sep 27, 2012 at 11:13 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2012-09-25 at 15:49 -0700, Sam Leffler wrote:
>>> These add per-scan request controls for optional behaviours we've found
>>> useful (they've been in Chrome OS for a long time).  A patch for iw will
>>> follow separately and the mods for wpa_supplicant are in our repo and
>>> I'll push them to Jouni if these are accepted.
>>>
>>> Sam Leffler (3):
>>>   {nl,cfg}80211: add a flags word to scan requests
>>>   mac80211: add support for tx to abort scan requests
>>>   cfg80211: add support for flushing old scan results
>>
>> I like the flushing one, but I'm not so sure about the TX abort thing.
>> How do you suggest to handle that when scanning is offloaded to the
>> driver and/or firmware? Especially given that multi-channel is going to
>> require a firmware implementation, I'm not sure how to achieve good
>> behaviour across the different implementations.
>>
>> Maybe it'd be worthwhile to go for a more generic approach, marking
>> scans as "low priority" or "high priority" or similar, and then
>> implementing such behaviour based on such settings? Our device for
>> example has a notion of "background scan" vs. "forced scan", which
>> behave differently in the firmware, and it would be useful to be able to
>> use these different behaviours. However, I can't say that "TX abort"
>> would be a guaranteed scan behaviour for a "background scan".
>>
> we also have some "urgency" option in our hw scan, but we currently
> never use it (not really sure when it should be used... maybe for
> roaming on beacon loss?)
>
> the TX abort is relevant mainly for sw scan.
> i'm not sure we really want to couple it with scan priority, though.
> otoh, userspace doesn't really care (or know) if we use sw or hw scan,
> so configuring it all with a single "scan priority" option does make
> sense.

I think the wl12xx FW does something similar with Tx during scan
automatically - it makes the scan last longer, and hops on the Tx
channel so packets get sent. So at least their intended use-case we
have covered.
