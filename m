Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eidolon.nox.tf ([185.142.180.128]:35630 "EHLO eidolon.nox.tf"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbdHRXcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 19:32:10 -0400
Date: Sat, 19 Aug 2017 01:32:08 +0200
From: David Lamparter <equinox@diac24.net>
To: Matteo Croce <mcroce@redhat.com>
Cc: David Lamparter <equinox@diac24.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [POC/GIT] mac80211 multicast rate selection (help wanted!)
Message-ID: <20170818233208.GU773745@eidolon> (sfid-20170819_013212_967602_12E14C65)
References: <20170818222910.GT773745@eidolon>
 <1503097091.2730.14.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503097091.2730.14.camel@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 19, 2017 at 12:58:11AM +0200, Matteo Croce wrote:
> Il giorno sab, 19/08/2017 alle 00.29 +0200, David Lamparter ha scritto:
> > So, from some completely unrelated datacenter work, I have hacked up
> > the bridge to hand back down to the driver detailed info on
> > multicast receivers.  Then I took this and fudged around in the
> > minstrel_ht code and, well, it gave me 9 MBit/s ;)
> > 
> > Now, I have pretty little no clue about the Linux wireless stack, so
> > I'd appreciate if someone could tell me how massively wrong I'm
> > doing this and which places in particular are the wrongest!
[cut]
> So you are scanning the multicast receivers list to select the lowest
> rate, comparing the rates by data rate?

Right now it's just using the lowest rate index.  I did say I have no
clue, right? :)

> I think that this is incorrect, the data rate is a combination of many
> parameters (modulation, GI interval, coding rate, streams, etc.) so a
> rate with higher data rate could be better than another with lower
> speed in some circumstances. Or even worse, some station could not
> receive the packet at all (too many streams, unsupported modulations.
> etc.).
>
> You could try to select the lowest MCS rate, the longer GI and the
> minimum number of stream from all the receivers and use a data rate
> compatible with these settings, if any (not all combinations are
> allowed unfortunately)

Yes, basically I need to find the best rate in the common subset
supported by all receivers.  This is far from trivial and will have
'interesting' interactions (for example, if a station only does
multicast, minstrel has nothing to learn the rate on because multicast
isn't ACKed so you can't probe with it).  That said, my goal here is
"simple", not "perfect".  There's always room and time for
improvement...


-David
