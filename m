Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3HWNrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:47:18 -0400
Message-ID: <1377265633.14021.32.camel@jlt4.sipsolutions.net> (sfid-20130823_154720_839271_68759B95)
Subject: Re: [PATCH] mac80211: ignore obviously bogus ECSAs in probe
 response frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 Aug 2013 15:47:13 +0200
In-Reply-To: <20130822141011.GA24445@thinkpad-t410> (sfid-20130822_161016_818408_C83E5982)
References: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com>
	 <1377180063.14110.23.camel@jlt4.sipsolutions.net>
	 <20130822141011.GA24445@thinkpad-t410>
	 (sfid-20130822_161016_818408_C83E5982)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-22 at 09:10 -0500, Seth Forshee wrote:
> On Thu, Aug 22, 2013 at 04:01:03PM +0200, Johannes Berg wrote:
> > On Thu, 2013-08-22 at 08:53 -0500, Seth Forshee wrote:
> > > The Netgear WNDAP360 sends invalid ECSA IEs in probe response
> > > frames
> > 
> > I think we shouldn't be checking probe response frames at all. That
> > seems like a mistake. Can you try this?
> 
> I had considered this, but the spec says that it's at least valid for
> the AP to be sending ECSAs in probe responses. IEEE 802.11-2012 section
> 10.3.3.2:
> 
>   ...an AP shall inform associated STAs that the AP is moving to a new
>   channel and/or operating class and maintain the association by
>   advertising the switch using Extended Channel Switch Announcement
>   elements in any transmitted Beacon frames, Probe Response frames, and
>   Extended Channel Switch Announcement frames until the intended channel
>   switch time.
> 
> Perhaps we can still ignore them though? I suppose we'd expect to
> receive some other frame with the ECSA before it actually happens.

I suppose that's to avoid clients connecting to it when they find the
AP, I don't see any reason to actually react to that in our code - we
should have picked up a beacon already anyway.

johannes

