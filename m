Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34190 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcHLQYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 12:24:09 -0400
Received: by mail-pa0-f46.google.com with SMTP id fi15so9981379pac.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 09:24:09 -0700 (PDT)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
 <1470919643.12075.7.camel@sipsolutions.net> <57ACA9E9.4020507@gmail.com>
 <1470938627.12075.25.camel@sipsolutions.net> <57ACC1F8.6070908@gmail.com>
 <1470981481.26902.4.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <57ADF825.5080409@gmail.com> (sfid-20160812_182413_059260_CFC4C179)
Date: Fri, 12 Aug 2016 11:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <1470981481.26902.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

 >
> No, I don't see a fault in the logic. I just think it's misleading. You
> make the code look like it relies on filter_wiphy != 0, but then you go
> and treat filter_wiphy==0 as a valid case.

It relies on a sentry condition with all 3 variables being zero, not 
just filter_wiphy.  The original patch is about the most non-invasive 
one I can come up with.  Maybe a comment will alleviate any concerns? 
Anyway, if you feel this is misleading, fair enough.

>
> In other places, like nl80211_prepare_wdev_dump(), we add 1 to the
> wiphy and subtract it again later to avoid exactly this. Perhaps you
> could do the same, and rely only on filter_wiphy instead of really
> relying only on wp_start/if_start.

Having looked at that particular piece of code, I ran away scared with 
the conclusion that the cure is probably much worse than the disease :)

I posted a slightly different solution in v2.  It is a bit more 
invasive, but is more explicit in what is going on.  I ran sanity checks 
on it and it works as expected.

Regards,
-Denis
