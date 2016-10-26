Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52284 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942895AbcJZNMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 09:12:08 -0400
Message-ID: <1477487505.4059.49.camel@sipsolutions.net> (sfid-20161026_151230_149504_21512E0B)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 15:11:45 +0200
In-Reply-To: <580A2438.7030106@gmail.com> (sfid-20161021_163810_476016_D9B31C64)
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
         <1477038639.4068.28.camel@sipsolutions.net> <580A2438.7030106@gmail.com>
         (sfid-20161021_163810_476016_D9B31C64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 09:20 -0500, Denis Kenzior wrote:

> > It's actually not clear to me that this is really how it should be.
> > There's a point to be made that taking a more holistic "link
> > quality" would be a better choice. That's related, but maybe can be
> > a separate discussion.

> Can you elaborate on this 'link quality' idea?

Well, I didn't really want to - getting 3 system folks into a room will
result in 4 different ways of doing it - but you can take into account
not just the RSSI, but also the bitrate you can reasonably use on the
channel/with the AP, the noise you can perhaps detect (if you can), the
amount of packet loss or retransmissions you experience, etc.

I think that some systems (Android, maybe Windows) already do something
more complex than pure RSSI indicators, but I don't really know for
sure.

> > Yes, this would be ideal.
> > 
> > [...]

see my other email

> This sounds really brittle.  Furthermore, we also need a facility to 
> know when signal strength is getting low to trigger roaming
> logic.  This would mean sharing CQM facility between roaming & signal
> strength notifications.  As you wrote above, things become quite
> impractical.

This would likely go through the supplicant anyway, so it could manage
proper range overlaps etc. for this.

It does seem brittle if we just have a single value, but if we add
low/high thresholds (with hysteresis) then I think we can do this, and
gain more flexibility in the process. But let's discuss more details
over in the other email I just sent :)

johannes
