Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45040 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754286AbdBHMvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 07:51:18 -0500
Message-ID: <1486557177.24745.8.camel@sipsolutions.net> (sfid-20170208_135215_219750_E75BB426)
Subject: Re: [PATCH v4 3/5] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 13:32:57 +0100
In-Reply-To: <CAOq732KyMG26f7X4NiOdChyF3Qq=X9YgvCunecai+UrQAByByA@mail.gmail.com> (sfid-20170208_122615_680060_2C19C18A)
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
         <20170125114344.8179-3-andrew.zaborowski@intel.com>
         <1486547933.24745.2.camel@sipsolutions.net>
         <CAOq732KyMG26f7X4NiOdChyF3Qq=X9YgvCunecai+UrQAByByA@mail.gmail.com>
         (sfid-20170208_122615_680060_2C19C18A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I think it would make sense to unconditionally apply the hysteresis
> > to low/high, i.e. always set
> >  low = low - hyst
> >  high = high + hyst
> > 
> > so that you get "sticky" ranges once you're in them?
> 
> Yes, maybe that's better, I guess I want to avoid just adding a lag /
> delay in reporting changes that are not due to measurement error or
> temporary.  Could also do something in between, e.g. use "low - hyst"
> if signal is close to low, otherwise just "low".

That's sort of what you had, but except for the precise definition of
"close", no?

Actually, no, because you used "last - hyst" rather than "low - hyst"
it's different. I think we can live with checking if it's close, say
setting to "low - hyst" when it's within low + hyst - that avoids the
problem I outlined above and gets a bit more responsiveness, I guess.

> The question is how the current hysteresis parameter is defined, what
> is expected of the firmware and how do driver authors decide whether
> their firmware/hardware implements the same mechanism as expected by
> the kernel.  Would the same thing happen with firmware
> implementations if the hysteresis value is 3 and the rssi fluctuates
> by +/- 2?  Or would it have to be +/- 3 or +/- 4 before this starts
> to happen.  (If this isn't well specified then it makes more sense to
> try to do it in one place for consistency.)

I'm not sure it's well-defined.

johannes
