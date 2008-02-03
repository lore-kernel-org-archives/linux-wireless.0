Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:16675 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbYBCOv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:29 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2316098wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:28 -0800 (PST)
Message-ID: <1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com> (sfid-20080203_145131_618228_8222291B)
Date: Sun, 3 Feb 2008 16:51:27 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: cfg80211 API changes
Cc: linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1202049444.4188.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
	 <1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>
	 <1202049444.4188.125.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 3, 2008 4:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > I'm finding it a bit cumbersome,. now when tx_rate is pointer and
> > doesn't resides in the ieee80211_tx_control
> > I've seen in your patch you've just ripped this code off but our rate
> > scale algorithms doesn't work without it actually the code that read
> > this value in rate scale algorithm is there but it actually looking
> > into empty space...
> >
> >  -       tx_status->control.tx_rate =
> >  -               iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags);
> >
> >  I'm just asking if you had something in mind or it's just something you forgot.
>
> TBH, that confused me completely since the rate scale algorithm tells
> the hardware what rate to use so why does the hw need to assign a
> different rate in the tx status?

I see.  Rate scale algorithm only tels FW from what rate to start
transmission. FW is responsible to do downscaling.  Which is quite
reasonable as retransmission is real time process. Instead of
retransmitting on the same rate FW downscales. T X response provides
to the rate scaling algorithm the successful rate.
 There is a little difference between 4956 and 3945 how the rate scale
table is given to FW, but this is off the topic.

Thanks
Tomas

> johannes
>
