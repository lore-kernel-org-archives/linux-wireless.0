Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28283 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781Ab0I0QdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:33:13 -0400
Subject: Re: active vs. passive scans
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: ext Chuck Crisler <ccrisler@vgocom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285600151.4043.23.camel@jlt3.sipsolutions.net>
References: <15713CDD627C41D39E4B9725AE2B241D@ChuckPC>
	 <1285599964.5768.120.camel@chilepepper>
	 <1285600151.4043.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 19:32:58 +0300
Message-ID: <1285605178.30315.3.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 17:09 +0200, ext Johannes Berg wrote:
> On Mon, 2010-09-27 at 18:06 +0300, Luciano Coelho wrote:
> 
> > Usually the drivers stay for a certain period of time in each channel,
> > and that normally doesn't change if you have active or passive scan.  So
> > there will be no improvement in the overall scan speed.  Of course you
> > could do some tweaks that might improve scanning performance in specific
> > cases.
> 
> It's certainly different with mac80211:
> 
> #define IEEE80211_CHANNEL_TIME (HZ / 33)
> #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)

Right... Even in the wl1271 driver's hw scan we stay longer on each
channel for passive scans.  Obviously just listening to beacons we need
to wait more, because probe_reqs should be responded quickly.

-- 
Cheers,
Luca.

