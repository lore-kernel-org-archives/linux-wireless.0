Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52932 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965842AbcKXPMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 10:12:21 -0500
Message-ID: <1480000334.4388.2.camel@sipsolutions.net> (sfid-20161124_161237_579769_23AE43E1)
Subject: Re: many "changed bandwidth, new config is" messages in the log
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Hocko <mhocko@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 24 Nov 2016 16:12:14 +0100
In-Reply-To: <20161124150723.GA4776@dhcp22.suse.cz>
References: <20161124150723.GA4776@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-24 at 15:07 +0000, Michal Hocko wrote:

> I have only now managed to move to 4.9-rc5 (from 4.8) and started
> seeing quite a lot of following messages
> "
> [  346.612211] wlan0: AP c0:4a:00:f1:48:f2 changed bandwidth, new
> config is 2472 MHz, width 1 (2472/0 MHz)
> [  352.655929] wlan0: AP c0:4a:00:f1:48:f2 changed bandwidth, new
> config is 2472 MHz, width 2 (2462/0 MHz)
> "

I don't think these messages are new in any way. checking ... nope,
it's been around that way since 3.9 :-)

> It always seems to be changing width from 1 -> 2 and back

Makes sense, that's 20 MHz <-> 40 MHz.

Did you buy a new device that says it's 40 MHz incompatible or
something? Or perhaps one of your neighbors did ... Or something is
causing interference that makes the AP switch around.

> $ dmesg | grep "changed bandwidth" | wc -l
> 42
> in 13 minutes of uptime. I have noticed this came in via 30eb1dc2c430
> ("mac80211: properly track HT/VHT operation changes").

Right, but that went into 3.9 :-)

> Is this something to be worried about?

Not at all. I suppose we could make this a debug message though, it's
not super useful when it happens OK (sometimes it causes disconnections
when we can't support the new mode, which is more relevant).

johannes
