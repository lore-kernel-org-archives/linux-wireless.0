Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61477 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3KRQW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 11:22:28 -0500
Received: by mail-wi0-f169.google.com with SMTP id hj6so99299wib.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 08:22:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384779666.17916.11.camel@jlt4.sipsolutions.net>
References: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com>
 <1384679792.14795.9.camel@jlt4.sipsolutions.net> <CABPxzY+XHXCFpKxU1NPZzb4eXP7x8i0-89eE+7uxWqGKnNsePw@mail.gmail.com>
 <1384779666.17916.11.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 18 Nov 2013 21:52:05 +0530
Message-ID: <CABPxzYJO7QDci9gVWpaBcLoJ4ib9EiJutWd7pDA2dNxf8ZL9Pw@mail.gmail.com> (sfid-20131118_172231_733289_16E9357E)
Subject: Re: [Query] Update mac80211 BSS info from cfg8011_bss_inform_frame
 when hw_scan is enabled
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 18, 2013 at 6:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2013-11-17 at 18:43 +0530, Krishna Chaitanya wrote:
>
>> > You're not supposed to even call cfg80211_bss_inform_frame() from a
>> > mac80211-based driver. Just report the RX frame properly.
>
>> Ours is a partial Full MAC driver which still uses mac80211 but mostly with
>> offloads to HW.
>>
>> With mac80211 + hw_scan if we just report the RX frames, then we are just
>> eliminating the SCAN SM from mac80211, is this just to reduce the host
>> cycles? (apart from speeding up the channel switch)
>
> When you post the driver for upstream we can talk about it. I have no
> interest in it otherwise - but
>
May not be possible.

>  (a) you can't call cfg80211 from the driver and then have cfg80211 call
> mac80211
>      - that's a gross layering violation
That was not my intention either.
>  (b) if you're offloading much, you're probably not using a lot of
> mac80211 and
>      should come with a proposal to refactor the code
If we want to truly offload the SCAN to HW then we should have some
way to update scan_results without ever sending the probe responses
and beacons up (saves lots of host cycles, assuming Connection
Monitoring is also offloaded).

For now, will change the driver to pass the beacons/probes up for
updating scan results.

Thanks.
