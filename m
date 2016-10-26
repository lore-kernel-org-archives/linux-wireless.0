Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47894 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbcJZF4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 01:56:09 -0400
Message-ID: <1477461362.4059.17.camel@sipsolutions.net> (sfid-20161026_075612_260056_D0567BD8)
Subject: Re: Bayesian rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjornsmedman@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Date: Wed, 26 Oct 2016 07:56:02 +0200
In-Reply-To: <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com> (sfid-20161026_052554_382209_FBBBAD2D)
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
         <1477286912.4085.1.camel@sipsolutions.net>
         <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
         <1477379678.4390.2.camel@sipsolutions.net>
         <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com>
         (sfid-20161026_052554_382209_FBBBAD2D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The intel 7260 and later parts also allow user controllable rate
> control and provide transmit completion feedback, but I don't know
> whether it's enough for your needs.

Perhaps. However, existing rate control is *very* tightly coupled to
the driver, and it'd be fairly pointless to disentangle just for the
sake of playing with a rate control algorithm.

Also, the device doesn't support per-frame control nor any kind of
sampling-with-table-fallback, only the rate table that you give to the
device and update.

Btw, mac80211_hwsim with wmediumd doing some medium simulation might
also be something to look at for just extending to VHT.

And come to think of it, there's this new driver Felix et al have been
working on, mt7601u, which also should support proper rate control
APIs.

johannes
