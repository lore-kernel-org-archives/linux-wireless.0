Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38261 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966037AbcKXPZO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 10:25:14 -0500
Date: Thu, 24 Nov 2016 16:25:11 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: many "changed bandwidth, new config is" messages in the log
Message-ID: <20161124152511.GC4776@dhcp22.suse.cz> (sfid-20161124_162524_926022_BF86839B)
References: <20161124150723.GA4776@dhcp22.suse.cz>
 <1480000334.4388.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1480000334.4388.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 24-11-16 16:12:14, Johannes Berg wrote:
> On Thu, 2016-11-24 at 15:07 +0000, Michal Hocko wrote:
> 
> > I have only now managed to move to 4.9-rc5 (from 4.8) and started
> > seeing quite a lot of following messages
> > "
> > [  346.612211] wlan0: AP c0:4a:00:f1:48:f2 changed bandwidth, new
> > config is 2472 MHz, width 1 (2472/0 MHz)
> > [  352.655929] wlan0: AP c0:4a:00:f1:48:f2 changed bandwidth, new
> > config is 2472 MHz, width 2 (2462/0 MHz)
> > "
> 
> I don't think these messages are new in any way. checking ... nope,
> it's been around that way since 3.9 :-)

Right you are. I must have missed them before and git grep + git blame
fooled me.

> > It always seems to be changing width from 1 -> 2 and back
> 
> Makes sense, that's 20 MHz <-> 40 MHz.
> 
> Did you buy a new device that says it's 40 MHz incompatible or
> something?

I am using this device for years now. It is a cheap TP-Link home
wireless router. So hard to tell about above. I am far from an expert.

> Or perhaps one of your neighbors did ... Or something is
> causing interference that makes the AP switch around.

This might be possible. There are quite some devices broadcasting around
$ sudo iwlist wlan0 scan | grep "Channel:" | sort | uniq -c
      6                     Channel:1
      6                     Channel:11
      1                     Channel:112
      2                     Channel:13
      2                     Channel:3
      7                     Channel:6
      1                     Channel:9

my router is at channel 13 so there seems to be something else sitting
there as well.

> > $ dmesg | grep "changed bandwidth" | wc -l
> > 42
> > in 13 minutes of uptime. I have noticed this came in via 30eb1dc2c430
> > ("mac80211: properly track HT/VHT operation changes").
> 
> Right, but that went into 3.9 :-)
> 
> > Is this something to be worried about?
> 
> Not at all. I suppose we could make this a debug message though, it's
> not super useful when it happens OK (sometimes it causes disconnections
> when we can't support the new mode, which is more relevant).

OK, I see. Then I would suggest lowering the loglevel ;)

Thanks!
-- 
Michal Hocko
SUSE Labs
