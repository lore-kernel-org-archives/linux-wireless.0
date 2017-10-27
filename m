Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37558 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbdJ0UPO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 16:15:14 -0400
Message-ID: <1509135311.2283.12.camel@sipsolutions.net> (sfid-20171027_221706_883633_B76A63F5)
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
Date: Fri, 27 Oct 2017 22:15:11 +0200
In-Reply-To: <db23762d-3e65-7707-ca78-ad7e7bc7dfa6@candelatech.com>
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
         <1507708948.1998.15.camel@sipsolutions.net>
         <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
         <1508312033.2674.9.camel@sipsolutions.net>
         <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
         <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de>
         <1508358869.2674.55.camel@sipsolutions.net>
         <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
         <1508360527.2674.61.camel@sipsolutions.net>
         <0bfb289d-a9fa-03d9-f9c7-cc0d01b0bd43@candelatech.com>
         <1508944670.2421.49.camel@sipsolutions.net>
         <db23762d-3e65-7707-ca78-ad7e7bc7dfa6@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-25 at 09:13 -0700, Ben Greear wrote:

> > Well it resulted in a WARN_ON because if the AP didn't have those
> > rates, we'd not find any usable rates while trying to transmit a frame,
> > and then ended up warning and falling down to the lowest possible rate.
> > 
> > I don't think I agree that configuring this should reject the
> > association, and I've already implemented the behaviour of dropping the
> > user's rate set in this case in the patch we're discussing.
> 
> So, as long as we are associating to a VHT AP, then we could still set the
> tx-rateset to (only) VHT MCS 8 and allow association, even if there are no additional
> rates set.  There is at least one common rate, so theoretically, the
> station and AP can communicate.
> 
> If we tried to associate this same station to an HT AP, then your work-around
> code could kick in and throw away the user's rateset configuration, preferably
> with a fairly noticeable warning message since you are overriding the user's
> preferred tx rateset?

There's only a debug message now, and I actually compare to the basic
rates. Like I said, we could fix that to compare to real rates, but
that gets a little trickier since we don't select from all possible
rates when we try to send management frames, only from legacy rates, so
we'd have to modify that code too.

> > This kind of problem is why I absolutely dislike out-of-band state that
> > affects the connection, rather than giving it in the connection
> > command(s) (connect, auth, associate, whatever). We're stuck with it
> > now, and needed to redefine that this selection may be dropped if not
> > usable.
> 
> You could start allowing the user to configure the full advertised and
> transmit rateset for each of these actions (and probe too), and user-space can add the fields
> to their netlink commands.  At least going forward, this might help
> make the behaviour more as expected.  If you would like to implement at
> least the basics in cfg/mac80211, I would be happy to work on the supplicant
> end of things.

I'm not sure we can really remove this, there are users out there (e.g.
Chrome's shill, IIRC), so we'd be stuck with two ways of doing things
... that's not so much better really :)

johannes
