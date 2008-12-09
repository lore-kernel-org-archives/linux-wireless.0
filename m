Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42110 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbYLIAni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 19:43:38 -0500
Message-Id: <1228783416.25383.1288982771@webmail.messagingengine.com> (sfid-20081209_014342_980615_7796A90D)
From: "Dan E" <trg_info@mailhaven.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
 (sfid-20081208_002919_244971_30E436F9)
 <1228723993.22164.65.camel@johannes.berg>
 <1228778295.10662.1288975589@webmail.messagingengine.com>
 <1228778801.22164.156.camel@johannes.berg>
Subject: Re: Userspace tools: Roadmap?
In-Reply-To: <1228778801.22164.156.camel@johannes.berg>
Date: Mon, 08 Dec 2008 19:43:36 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 09 Dec 2008 00:26:41 +0100, "Johannes Berg"
<johannes@sipsolutions.net> said:
> There's libnl 1.2 and 2.0? That's news to me! Patches welcome. Sorry, I
> guess it needs 1.0 or 1.1, will fix the page.

Well at http://people.suug.ch/~tgr/libnl/ it still only lists 1.1 but
the git repository shows a clear move to 2.0 (forget I mentioned 1.2,
that was my own tracking label).  The code had a bunch of commits in
October.  In retrospect, if I just downloaded the 1.1 tarball from that
webpage instead of using the git HEAD everything would have been fine. 
Patches can probably wait until 2.0 is officially released.

> 
> > That's what I thought but I wasn't seeing any callbacks at all through
> > my ieee80211_ops pointers.  I did see the channel frequency change with
> > 'iwconfig wlan0', but no callbacks.  My fault, again, for not RTFM.  I
> > haven't gotten to the point yet on my driver where I expect 'ip link set
> > up dev wlan0' (or 'ifconfig wlan0 up', if you prefer) and now I see
> > that's why the config callback never happened.  
> 
> Ah. Yes, if the hw isn't started mac80211 won't try to configure it :)
> 
> > If I had RTFM I might
> > have noticed adding 'commit' at the end of the iwconfig command would
> > have done it without the 'up'.
> 
> No, it wouldn't, commit is pointless, don't worry about it, you'll never
> need to use it with mac80211.

When I reboot, modprobe the driver, and do 'iwconfig wlan0 channel 9
commit' the .config callback does run.  If I leave off the 'commit' it
does not.  I'm trying to validate as many callbacks as I can before
moving on to the next step, enabling the interface.

An additional question, if I may... Is wlan0 considered a "virtual
interface" or does that term only apply to additional interfaces created
with iw?  The whole vif thing has me a little confused.

Thanks for the help.

--
Dan

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

