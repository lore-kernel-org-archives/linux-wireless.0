Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:37932 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755903AbeBABJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 20:09:53 -0500
Received: by mail-pg0-f43.google.com with SMTP id y27so11562825pgc.5
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 17:09:53 -0800 (PST)
Subject: Re: [RFC v3 0/6] EAPoL over NL80211
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180131213329.25322-1-denkenz@gmail.com>
 <1517436000.28814.3.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <97c9744e-0f24-49d1-ed2c-eb4661e97289@gmail.com> (sfid-20180201_020957_653722_0F4D097F)
Date: Wed, 31 Jan 2018 19:09:51 -0600
MIME-Version: 1.0
In-Reply-To: <1517436000.28814.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 01/31/2018 04:00 PM, Johannes Berg wrote:
> Looks pretty good! Some comments over in separate emails.
> 
> Maybe you should consider reordering:
> 
> [1/6] keep
> [2/6] keep
> [3/6] introduce TX (now patch 5)
> [4/6] introduce RX (now patch 3)
>        modify this to require TX from the driver in order to be able to
>        set the new flag
> [5/6] add TX to mac80211
> [6/6] add RX to mac80211 and set the flag
> 
> Ok, you don't really have to do that, since you only set the flag in
> the last patch anyway, but that'd make it better to add the check that
> requires TX, so you don't have to do that in the TX patch and modify
> the RX portion again.

Err, Johannes Berg presents: Fun with Flags ;) So I re-read this about 
half a dozen times and I think I figured out what you wanted.  It seems 
you mean different flags in 4/6 and 6/6.  I reordered V4 with my 
interpretation.  Doesn't quite look like the above, but hopefully I 
groked what you wanted correctly.

I didn't put in the extra owner check on the tx operation since it 
wasn't clear whether you wanted that or not.

Thanks for the review.

Regards,
-Denis
