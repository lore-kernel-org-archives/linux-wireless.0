Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54713
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbXBNVxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 16:53:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Wed, 14 Feb 2007 22:52:45 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <larry.finger@lwfinger.net>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <1171481180.6093.11.camel@johannes.berg> <1171481275.6093.14.camel@johannes.berg>
In-Reply-To: <1171481275.6093.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702142252.45352.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 February 2007 20:27, Johannes Berg wrote:
> On Wed, 2007-02-14 at 20:26 +0100, Johannes Berg wrote:
> > On Wed, 2007-02-14 at 13:13 -0600, Larry Finger wrote:
> > 
> > > I've got a pair of BCM4306 rev 2 cards. One of them is certainly available. Its LEDS don't work
> > > anymore, but the rest is functional.
> > 
> > Oh good. Do they actually work right now?
> 
> Heh, stupid question if you say they're functional :)
> 
> Anyway, I'm not quite sure how we should keep those old code paths in
> there. Maybe having a different wireless driver for the older cores
> would be good, maybe split bcm43xx into three drivers, one for the
> PCI/SSB stuff and then two SSB drivers for old and new cores?

It's _really_ a pain to support both v3 and v4 fw in one driver.
I tried it, but it's really really hard to do. The API to the FW
is different in so many ways.
We would have to completely abstract the SharedMemory accesses.
That would mean a lot of additional code and functions (or we could
clutter the code with if{}else{} all over, which is even worse (IMO).

So, I would say we should have a seperate driver, probably also based
on d80211 for very old cards. But I don't really want to maintain
such a beast either. (I also don't have the required old HW).

-- 
Greetings Michael.
