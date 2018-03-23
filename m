Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33327 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeCWS2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 14:28:43 -0400
Received: by mail-vk0-f44.google.com with SMTP id j85so7858604vke.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 11:28:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521822366.28252.5.camel@sipsolutions.net>
References: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
 <1521793079.4175.12.camel@sipsolutions.net> <CAEo4QHwLarcoui=oh+2zX++TBh0juVjp1dV8Gjq77x=W+enAVQ@mail.gmail.com>
 <1521822366.28252.5.camel@sipsolutions.net>
From: Tyler Gray <graytfg@gmail.com>
Date: Fri, 23 Mar 2018 14:28:42 -0400
Message-ID: <CAEo4QHxEwahfRxETqAKAmH5=pYnb99xxg0A3Rao5dsgnTSm6cQ@mail.gmail.com> (sfid-20180323_192847_583858_AE994F75)
Subject: Re: iwlwifi intermittent beacon capture in monitor mode?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2018 at 12:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2018-03-23 at 11:02 -0400, Tyler Gray wrote:
>> You mentioned the firmware can suppress beacons for powersaving.  Is
>> there any debug I could look at to see if that was happening?  I
>> posted some fw_rx_stats, would those counters be incremented before
>> that filtering would happen?  I just watched the counters during a
>> good period and a bad period.  In the "good" period I saw 15 CCK
>> packets/second, which is what I'd expect for my AP beaconing plus some
>> some probe responses and some beacons from the adjacent channel.
>> During the bad period the firmware saw 2 CCK packets in 7 seconds, and
>> none of the error counters for the bad period showed an additional 100
>> packets lost for any reason.  The two periods had fairly similar
>> plcp_err stats.
>
> I'd have to check.

It'd be great to know, or any other kind of debugging you'd suggest to
pin it down to the packet isn't received at all, it isn't making it
out of firmware, or it isn't making it out of the driver.  We did set
the debug level to 0xffffffff and that seems to generate 3-4 syslog
entries per packet received, and I again see no activity when the
beacons aren't showing up, so I'm pretty sure we're getting lost
before the driver level.

> ISTR being told that 8260 devices would make much better sniffers - any
> chances you have one of those to try?

The 7265 seems to be really popular in that 12x16mm soldered down
package, so we're kind of tied to it because it's in hardware we want
to use and there's no easy way to replace it.

> Perhaps you could file a bug on bugzilla.kernel.org so we can track this
> better.

Thanks, I'll submit something next week.
