Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37022 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbdJRVCJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 17:02:09 -0400
Message-ID: <1508360527.2674.61.camel@sipsolutions.net> (sfid-20171018_230213_057877_F3CE9C56)
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
Date: Wed, 18 Oct 2017 23:02:07 +0200
In-Reply-To: <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
         <1507708948.1998.15.camel@sipsolutions.net>
         <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
         <1508312033.2674.9.camel@sipsolutions.net>
         <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
         <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de>
         <1508358869.2674.55.camel@sipsolutions.net>
         <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-18 at 13:51 -0700, Ben Greear wrote:
> "
> I guess you could implement this part? I.e. iterating the clients and
> checking that they all support the rate that is set. However, then you
> also need to implement that this gets reset when a new client that
> doesn't support this rate connects.
> "
> 
> The first part seems OK, but the second seems like a pain.  Maybe just
> keep a new client from being able to connect at all if it doesn't support
> any available rates?

I suppose if you reject the NEW_STATION command, then hostapd will
reject the association though, so it's probably not hard to do.
However, I'm not really sure why you'd want that? If you do want that
then basically you're just implemented a very roundabout way of adding
this rate to the basic rates, so you might as well just add it and work
with the current basic rates check?


We'll need to be a little careful what happens with client-mode
interfaces, which is where we actually observed hitting the WARN_ON()
about not having any rates at all, but I think I already put a reset of
the rates there anyway if they're not compatible with the AP. At least
that's easier because there's only one client.

johannes
