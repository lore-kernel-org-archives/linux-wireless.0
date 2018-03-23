Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54194 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbeCWQ0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 12:26:09 -0400
Message-ID: <1521822366.28252.5.camel@sipsolutions.net> (sfid-20180323_172612_499084_61BA96FE)
Subject: Re: iwlwifi intermittent beacon capture in monitor mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tyler Gray <graytfg@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2018 17:26:06 +0100
In-Reply-To: <CAEo4QHwLarcoui=oh+2zX++TBh0juVjp1dV8Gjq77x=W+enAVQ@mail.gmail.com> (sfid-20180323_160239_305970_44135ABA)
References: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
         <1521793079.4175.12.camel@sipsolutions.net>
         <CAEo4QHwLarcoui=oh+2zX++TBh0juVjp1dV8Gjq77x=W+enAVQ@mail.gmail.com>
         (sfid-20180323_160239_305970_44135ABA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-23 at 11:02 -0400, Tyler Gray wrote:

> I'm positive we're just in monitor mode. [snip]

Ok, it was just a thought.

> To be clear, I'm not claiming I can set two devices up anywhere,
> anytime, and run this test and see huge gaps in beacons, but we've
> tested across multiple devices and multiple brands of devices with
> 7265 cards, and we have data collected in locations that are miles
> apart that show the same behavior, so I'm confident this isn't just
> one bad card or one incredibly unlucky setup that shows the problem.
> I have determined spots where I'm far more likely to see the issue,
> but I'll maintain that outside of a pathologically bad environment, I
> should be able to see beacons from 6 feet away.
> 
> You mentioned the firmware can suppress beacons for powersaving.  Is
> there any debug I could look at to see if that was happening?  I
> posted some fw_rx_stats, would those counters be incremented before
> that filtering would happen?  I just watched the counters during a
> good period and a bad period.  In the "good" period I saw 15 CCK
> packets/second, which is what I'd expect for my AP beaconing plus some
> some probe responses and some beacons from the adjacent channel.
> During the bad period the firmware saw 2 CCK packets in 7 seconds, and
> none of the error counters for the bad period showed an additional 100
> packets lost for any reason.  The two periods had fairly similar
> plcp_err stats.

I'd have to check.

ISTR being told that 8260 devices would make much better sniffers - any
chances you have one of those to try?

> As a side note, if I have a device connect to the AP and run iperf to
> generate data, I'll capture an average of 99% of the data packets, yet
> I'll often see 0 beacons while the transfer is happening.  So it's not
> that I can't receive packets at all, and capturing those data packets
> should be a far harder task, but it seems beacons get dropped in a
> variety of cases and I can't determine why.

Interesting.

> Are there any known conflicts between the bluetooth and the wifi?  Is
> there an easy answer to the best (lowest level) way to disable
> bluetooth if so?

rmmod btusb ;-)

I don't really know for sure, but I wouldn't really expect BT to affect
single-chain RX performance much.

Perhaps you could file a bug on bugzilla.kernel.org so we can track this
better.

johannes
