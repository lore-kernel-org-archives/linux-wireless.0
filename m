Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41282 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751932AbdBNJOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 04:14:23 -0500
Message-ID: <1487063659.4705.5.camel@sipsolutions.net> (sfid-20170214_101428_309075_BE63B59E)
Subject: Re: [PATCH] iw: Fix bitrate output when no rate info found
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Feb 2017 10:14:19 +0100
In-Reply-To: <a2ffeab5-dd9c-1c9d-3fd1-c098a6d1e748@gmail.com> (sfid-20170214_095559_603492_D396288B)
References: <1487049663-2942-1-git-send-email-masashi.honma@gmail.com>
         <1487061321.4705.1.camel@sipsolutions.net>
         <a2ffeab5-dd9c-1c9d-3fd1-c098a6d1e748@gmail.com>
         (sfid-20170214_095559_603492_D396288B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 17:55 +0900, Masashi Honma wrote:
> On 2017-02-14 17:35, Johannes Berg wrote:
> > On Tue, 2017-02-14 at 14:21 +0900, Masashi Honma wrote:
> > > Previously, bitrate showed uninitialized buffer when no rate info
> > > found.
> > 
> > When would this happen?
> 
> I could see in mesh STA connection with 11n and legacy mixed.
> STA A has disable_ht=1.
> STA B has disable_ht=0.

Interesting, ok.

>  > I'm not really sure this is right - perhaps we don't have
>  > RATE_INFO_BITRATE(32), but still have the MCS data?
> 
> I recognized there was a issue on such a case. I will send a patch
> to wpa_supplicant. Anyway, showing string message is better than
> showing raw binary data.
> 
> > How about we just add "(unknown)" or so and not return here?
> 
> Yes. First time, I supposed to use "unknown". 

Ok.

> But in the function 
> parse_bitrate(), nla_parse_nested() returns message "failed to parse 
> nested rate attributes!". This explains why the bitrate is unknown. 

Yes, this is bad! But if you saw that, why did you ever get to the
below code that checked for the BITRATE(32) attributes?

> So I used explaining message. We could see the message like this.
> 
> tx bitrate: No rate info found!
> rx bitrate: 48.0 MBit/s

Yeah I was just thinking we could also see

tx bitrate: (unknown)

and then if there was MCS anyway you'd see

tx bitrate: (unknown) MCS 7

or something like that?

johannes
