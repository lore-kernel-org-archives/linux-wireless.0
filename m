Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44236 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbcK1PgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 10:36:02 -0500
Message-ID: <1480347358.8107.65.camel@sipsolutions.net> (sfid-20161128_163604_630327_3C267F1E)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <balrogg@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Nov 2016 16:35:58 +0100
In-Reply-To: <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com> (sfid-20161128_162954_738613_110F61FB)
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
         <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com>
         <1480344479.8107.60.camel@sipsolutions.net>
         <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com>
         (sfid-20161128_162954_738613_110F61FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-28 at 16:29 +0100, Andrew Zaborowski wrote:

> In order to keep the hardware offload feature when working with
> hardware that can only offload the old single-thresholds method, but
> where the kernel also wants to support the new method by looking at
> all the beacons in software.  IIRC I identified just one driver that
> would be in this situation: wl1271.

IMHO it would be better to not allow that. I'd think that wl1271 is
only used in devices where power consumption will be far more
interesting than providing this kind of API.

> This is a specific case and the semantics implemented by the wl1271
> may be a little different from those in the rest of the drivers so
> this may be worth very little.  I can change the comment to imply
> only one method should be implemented.

We might still have to allow both to be present for mac80211 though.

> > Seems there still should be a hysteresis? Or am I misunderstanding
> > the
> > intent here? I.e. isn't it meant to report low/medium/high later?
> 
> This isn't exposed directly to users, instead it's used by the code
> in
> nl80211.c which will always reset the thresholds when either
> threshold
> is crossed.  The hysteresis can then be either handled in nl80211.c
> (factored into the threshold values) or in the firmware/driver, this
> won't change the number of wakeups.

That's only if you assume you can actually react to this fast enough
though, no? If I offload this, I'd want to also offload a hysteresis to
firmware, I'd think.

johannes
