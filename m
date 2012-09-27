Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64541 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2I0QjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 12:39:12 -0400
Received: by ieak13 with SMTP id k13so4952337iea.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2012 09:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348737219.10353.6.camel@jlt4.sipsolutions.net>
References: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
	<1348737219.10353.6.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Sep 2012 09:39:12 -0700
Message-ID: <CA+yqC4bo9Xcy9HMeJYAFHqEYBCUErF+Y4ivfe9s+xQ+endCU-Q@mail.gmail.com> (sfid-20120927_183919_794862_7D7CD4B8)
Subject: Re: [PATCH 0/3] add scan flags support
From: Sam Leffler <sleffler@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, eliad <eliad@wizery.com>,
	coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2012 at 2:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-09-25 at 15:49 -0700, Sam Leffler wrote:
>> These add per-scan request controls for optional behaviours we've found
>> useful (they've been in Chrome OS for a long time).  A patch for iw will
>> follow separately and the mods for wpa_supplicant are in our repo and
>> I'll push them to Jouni if these are accepted.
>>
>> Sam Leffler (3):
>>   {nl,cfg}80211: add a flags word to scan requests
>>   mac80211: add support for tx to abort scan requests
>>   cfg80211: add support for flushing old scan results
>
> I like the flushing one, but I'm not so sure about the TX abort thing.
> How do you suggest to handle that when scanning is offloaded to the
> driver and/or firmware? Especially given that multi-channel is going to
> require a firmware implementation, I'm not sure how to achieve good
> behaviour across the different implementations.
>
> Maybe it'd be worthwhile to go for a more generic approach, marking
> scans as "low priority" or "high priority" or similar, and then
> implementing such behaviour based on such settings? Our device for
> example has a notion of "background scan" vs. "forced scan", which
> behave differently in the firmware, and it would be useful to be able to
> use these different behaviours. However, I can't say that "TX abort"
> would be a guaranteed scan behaviour for a "background scan".

Having a priority mechanism or similar would be fine. I usually
hesitate doing the generic thing because the actual semantics can very
so significantly from driver to driver that applications may end up
having to build in knowledge of which driver is being used to get what
they way want. But in fact what you suggest is how txabort is used--we
mark wpa_supplicant bgscan's w/ txabort while fgscan's are not marked
in this way.

>
> johannes
>
