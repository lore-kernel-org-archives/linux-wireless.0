Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:39483 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeCWPCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 11:02:37 -0400
Received: by mail-ua0-f177.google.com with SMTP id m47so7942201uae.6
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 08:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521793079.4175.12.camel@sipsolutions.net>
References: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
 <1521793079.4175.12.camel@sipsolutions.net>
From: Tyler Gray <graytfg@gmail.com>
Date: Fri, 23 Mar 2018 11:02:35 -0400
Message-ID: <CAEo4QHwLarcoui=oh+2zX++TBh0juVjp1dV8Gjq77x=W+enAVQ@mail.gmail.com> (sfid-20180323_160241_930932_6471BBD9)
Subject: Re: iwlwifi intermittent beacon capture in monitor mode?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the reply.

I'm positive we're just in monitor mode.  I'm sure for a lot of
reasons, but I control the AP, so I'd see any connections in the
hostapd debug as well as in the pcaps if things were connecting to it.
We've been doing collection with Atheros devices for 5+ years, but
have recently been looking at the 7265.  It works great almost always,
but we've seen this quirk for some time now, and are trying to get to
the bottom of it.  This is as simple a test I could come up with to
show the problem, using just stock software.  Our ubuntu laptop does
not have network manager running, so the test is as easy as booting up
and:

rfkill unblock wifi
iw wlan0 set type monitor
ifconfig wlan0 up
iw wlan0 set channel 10
tcpdump -i wlan0 <optional filter for my AP>

To be clear, I'm not claiming I can set two devices up anywhere,
anytime, and run this test and see huge gaps in beacons, but we've
tested across multiple devices and multiple brands of devices with
7265 cards, and we have data collected in locations that are miles
apart that show the same behavior, so I'm confident this isn't just
one bad card or one incredibly unlucky setup that shows the problem.
I have determined spots where I'm far more likely to see the issue,
but I'll maintain that outside of a pathologically bad environment, I
should be able to see beacons from 6 feet away.

You mentioned the firmware can suppress beacons for powersaving.  Is
there any debug I could look at to see if that was happening?  I
posted some fw_rx_stats, would those counters be incremented before
that filtering would happen?  I just watched the counters during a
good period and a bad period.  In the "good" period I saw 15 CCK
packets/second, which is what I'd expect for my AP beaconing plus some
some probe responses and some beacons from the adjacent channel.
During the bad period the firmware saw 2 CCK packets in 7 seconds, and
none of the error counters for the bad period showed an additional 100
packets lost for any reason.  The two periods had fairly similar
plcp_err stats.

7 good seconds:  (beacons coming in)
ina_cnt: +152
fina_cnt: +152
plcp_err: +44
crc32_err: +3

7 bad seconds:  (No beacons coming in, basically no traffic)
ina_cnt:  +56
fina_cnt: +56
plcp_err: +54
crc32_err: +0

Any theories, other than I'm associating with the AP, as to why
changing the channel would make the beacons return for a couple of
seconds?  That log I posted was terrible to read (sorry about that)
but essentially it shows beacons totally stopped for 20 seconds.  As
soon as I change channels and back, I get around 2 seconds worth of
beacons before it freezes again, and I can do that over and over.

As a side note, if I have a device connect to the AP and run iperf to
generate data, I'll capture an average of 99% of the data packets, yet
I'll often see 0 beacons while the transfer is happening.  So it's not
that I can't receive packets at all, and capturing those data packets
should be a far harder task, but it seems beacons get dropped in a
variety of cases and I can't determine why.

Are there any known conflicts between the bluetooth and the wifi?  Is
there an easy answer to the best (lowest level) way to disable
bluetooth if so?

Thanks,
Tyler

On Fri, Mar 23, 2018 at 4:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> From a completely different angle than what James just said, are you
> sure you're using the 7265 NIC for *only* monitor mode? This behaviour
> would also be more or less consistent with the 7265 NIC being connected
> to the AP that you're monitoring the beacons, since it would then
> suppress beacon RX for powersaving purposes.
>
> johannes
