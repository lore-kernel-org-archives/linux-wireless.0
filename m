Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48350 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYIFTEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:04:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
Date: Sat, 6 Sep 2008 21:04:15 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> <200809062055.51797.mb@bu3sch.de> <1220727470.10102.9.camel@johannes.berg>
In-Reply-To: <1220727470.10102.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809062104.15274.mb@bu3sch.de> (sfid-20080906_210443_956400_8F0DEB28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 20:57:50 Johannes Berg wrote:
> On Sat, 2008-09-06 at 20:55 +0200, Michael Buesch wrote:
> > On Saturday 06 September 2008 20:52:53 Larry Finger wrote:
> > > Michael Buesch wrote:
> > > > On Saturday 06 September 2008 20:34:02 Larry Finger wrote:
> > > >> A coding error present since b43legacy was incorporated into the
> > > >> kernel has prevented the driver from using the rate-setting mechanism
> > > >> of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> > > > 
> > > > Does version3 firmware have a different bitlayout for the status?
> > > 
> > > It seems so. I found this because I was not getting any acks back to 
> > > net/mac80211/rc80211_pid_algo.c. I then reviewed the V3 specs, found 
> > > that bit 0, not bit 1, contained the ack. Test prints confirmed that 
> > > result. With this patch, both my BCM4306/2 and BCM4303 reach the 
> > > maximum rate. With the current code, 54 Mb/s is not as fast as 36 
> > > Mb/s, but at least the algorithm is working.
> > 
> > Yeah ok. I just asked, because it seems the _whole_ flags bitfield
> > is rightshifted by one (so the other flags are wrong, too. See the
> > intermediate flag)
> 
> It is, this isn't really a difference between the two but a result of
> you shifting it up/down due to the tx status via dma queue vs. tx status
> via registers thing.

Yeah, that's the point. larry's patch modified both the register and dmaqueue
mechanism. I think the register mechanism might be correct as-is (Or is it even
dead code and it's not used by any legacy device?)

-- 
Greetings Michael.
