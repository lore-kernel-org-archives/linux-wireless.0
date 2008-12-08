Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34248 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYLHXSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 18:18:16 -0500
Message-Id: <1228778295.10662.1288975589@webmail.messagingengine.com> (sfid-20081209_001824_312714_9872DB43)
From: "Dan E" <trg_info@mailhaven.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
 (sfid-20081208_002919_244971_30E436F9)
 <1228723993.22164.65.camel@johannes.berg>
Subject: Re: Userspace tools: Roadmap?
In-Reply-To: <1228723993.22164.65.camel@johannes.berg>
Date: Mon, 08 Dec 2008 18:18:15 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 08 Dec 2008 09:13:13 +0100, "Johannes Berg"
<johannes@sipsolutions.net> said:
> 
> Not really, in the short term, you still are using iwconfig (wireless
> extensions) with anything but hostapd.

Ugh.  I was afraid you were going to say that.

> > Userspace tools.  I want to proceed as if Wireless Extensions never
> > existed.  Is that even possible?
> 
> No, it's not.

My fault for assuming too much about the urgency to get away from WE.

> Yes, it should, and nl80211 even supports it, but iw itself doesn't yet.
> That's fairly easy to fix, too, but then iw won't support actually
> telling mac80211 to scan and associate etc.

Right.  I had a few early problems with iw.  For instance, the Linux
Wireless web pages say you need "at least" libnl-1.0-pre8, but it won't
build with libnl-1.2 or 2.0.  I had to go with libnl-1.1 to make it
happy.  iw seems to be like a redheaded stepchild.

> If you're writing a mac80211-based driver, there's no point where you
> could possibly get in touch with the userspace API. You're writing the
> driver completely to mac80211's internal driver API, and mac80211
> completely shields you from the userspace API. You'll never interact
> with either wireless extensions or nl80211.
> 
> > If somone could answer only 1 question (okay, it's a two-parter) the one
> > I would most like answered is this:  How does one, from userspace, ask
> > the driver to switch to a specific channel, and what callback(s) from
> > mac80211 should my driver expect to receive as a result?  
> 
> iwconfig wlan0 channel 7
> 
> then mac80211 calls your _ops->config() with the channel flag. Have you
> looked at the mac80211 book and the other documentation on
> http://wireless.kernel.org/?

That's what I thought but I wasn't seeing any callbacks at all through
my ieee80211_ops pointers.  I did see the channel frequency change with
'iwconfig wlan0', but no callbacks.  My fault, again, for not RTFM.  I
haven't gotten to the point yet on my driver where I expect 'ip link set
up dev wlan0' (or 'ifconfig wlan0 up', if you prefer) and now I see
that's why the config callback never happened.  If I had RTFM I might
have noticed adding 'commit' at the end of the iwconfig command would
have done it without the 'up'.

Thanks for the info, Johannes.  It answers a lot of my questions.

--
Dan

-- 
http://www.fastmail.fm - Access your email from home and the web

