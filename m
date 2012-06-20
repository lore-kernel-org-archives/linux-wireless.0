Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2FTL56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 07:57:58 -0400
Message-ID: <1340193471.4655.57.camel@jlt3.sipsolutions.net> (sfid-20120620_135812_247193_C2DF56E2)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on
 op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 13:57:51 +0200
In-Reply-To: <4FE1B9CB.2090206@neratec.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	  <1340111463-4554-3-git-send-email-victorg@ti.com>
	  <1340181856.4655.37.camel@jlt3.sipsolutions.net>
	  (sfid-20120620_104434_561430_DB0A480E) <1340181992.4655.39.camel@jlt3.sipsolutions.net>
	 <4FE1B9CB.2090206@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 13:53 +0200, Zefir Kurtisi wrote:
> On 06/20/2012 10:46 AM, Johannes Berg wrote:
> > On Wed, 2012-06-20 at 10:44 +0200, Johannes Berg wrote:
> >>> +	if ((!chan->radar_detect_timeout ||
> >>> +	     time_is_after_jiffies(chan->radar_detect_timeout)) &&
> >>> +	    (chan->flags & IEEE80211_CHAN_RADAR))
> >>> +		return -EPERM;
> >>
> >> Ok so you reject it if it's 0, but the jiffies calculation could return
> >> 0 too.. in fact, since jiffies start at -5 minutes on boot, you might
> >> even hit it if you start radar detection 4 minutes after boot.
> > 
> > Also, it seems that the value should be reset eventually ... at least on
> > interface down or so. Otherwise you can start CAC, then bring the
> > interface down to stop the device, and then bring it back up (CAC check
> > is no longer running) and then you can use the channel after some time
> > even though you never really checked for radar...
> > 
> No, if you bring it back up on the same DFS channel,
> radar_detection_timeout will be set back to +60s by
> start_radar_detection(). Looks safe to me.

You need to think a bit more outside the regular code flows ... What if
I'm not calling start_radar_detection()?

johannes

