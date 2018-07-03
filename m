Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42272 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932417AbeGCJv1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 05:51:27 -0400
Message-ID: <1530611484.4735.18.camel@sipsolutions.net> (sfid-20180703_115131_581506_6C55F63A)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Tue, 03 Jul 2018 11:51:24 +0200
In-Reply-To: <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
         <1529062392.10037.7.camel@sipsolutions.net>
         <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
         <1529357234.3092.57.camel@sipsolutions.net>
         <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
         <1530267147.3481.78.camel@sipsolutions.net>
         <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-06-29 at 23:14 +0200, Alexander Wetzel wrote:

> I was wrong here, this is not an issue. Tkip is simply dropping frames
> when the IV is too small and never verifies the MIC. And since only MIC
> errors can trigger counter measures we are fine as it is...

Err, yes, of course. My bad.

> > > 3) Is what I implemented. We try what we can with the existing API and
> > > any driver not working with that has to be considered buggy.
> > 
> > I don't think we can really do this though. We break - in a potentially
> > security-relevant way - the older drivers. We can't just say that's
> > driver bugs, IMHO.
> 
> We would not break it, only not fix it for all drivers. The current code
> is already leaking cleartext packets for at least ath9k and most likely
> many others when the PTK is rekeyed. The patch would improve that, but
> due to more working rekeys it could leak more packets in specific
> scenarios, I assume...

Yeah, ok, fair point. I don't really know.

> > Obviously if SW crypto is used none of this is a concern, so that's
> > another factor to take into account in this decision logic of whether to
> > disconnect or not?
> 
> I did not check the SW crypto code but I'm pretty sure that indeed works
> with the current code.

Me too.

> I assume the packets will only be decrypted after an RX aggregation is
> completed. That would filter out all packets send with the old key,
> since they simply can't be decrypted any more.

Oh, good point, but that's true - reordering happens before software
decryption.

> Shall we bypass stopping aggregation sessions if we are on SW crypto?
> We'll again lose the benefit that we prevent a broken remote STA to try
> a TX Agg. (I tend to still stop them, but do not have a real opinion
> here...)

I don't really know.

> > IOW - I'd rather get bugs that we now force a disconnect (if anyone even
> > notices), rather than potentially having a bug that causes unencrypted
> > packets to be sent.
> 
> Any suggestions how to trick hostap/wpa_supplicant into dropping the
> connection? For me it looks like we can just report an error on key
> install and expect the wpa_supplicant/hostapd to handle that.

I think easier would be to just disconnect ourselves? At least if we're
in managed mode...

> Will try that for the next version of the patch, with the other
> discussed improvements: If driver is not signalling "PTK0 rekey support"
> we'll simply not accept key installs when we already have a old PTK key
> for the connection.

Since I see you have a new patch - how did that work out? :)

johannes
