Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2FTIqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:46:35 -0400
Message-ID: <1340181992.4655.39.camel@jlt3.sipsolutions.net> (sfid-20120620_104641_245308_85548D46)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on
 op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 10:46:32 +0200
In-Reply-To: <1340181856.4655.37.camel@jlt3.sipsolutions.net> (sfid-20120620_104434_561430_DB0A480E)
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-3-git-send-email-victorg@ti.com>
	 <1340181856.4655.37.camel@jlt3.sipsolutions.net>
	 (sfid-20120620_104434_561430_DB0A480E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 10:44 +0200, Johannes Berg wrote:
> > +	if ((!chan->radar_detect_timeout ||
> > +	     time_is_after_jiffies(chan->radar_detect_timeout)) &&
> > +	    (chan->flags & IEEE80211_CHAN_RADAR))
> > +		return -EPERM;
> 
> Ok so you reject it if it's 0, but the jiffies calculation could return
> 0 too.. in fact, since jiffies start at -5 minutes on boot, you might
> even hit it if you start radar detection 4 minutes after boot.

Also, it seems that the value should be reset eventually ... at least on
interface down or so. Otherwise you can start CAC, then bring the
interface down to stop the device, and then bring it back up (CAC check
is no longer running) and then you can use the channel after some time
even though you never really checked for radar...

And if you start CAC on two different devices on the same channel, but
they happen to share channel structs in the driver then this will all
conflict quite badly.


This needs a lot of more thinking it seems.

johannes

