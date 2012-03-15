Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2COP0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 11:26:47 -0400
Subject: Re: [PATCH] rndis_wlan: don't report station signal
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20120315150313.GD31717@tuxdriver.com>
References: <1331820805.3432.17.camel@jlt3.sipsolutions.net>
	 <20120315142527.GC31717@tuxdriver.com>
	 <1331822834.3432.22.camel@jlt3.sipsolutions.net>
	 <20120315150313.GD31717@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 16:26:43 +0100
Message-ID: <1331825203.3432.25.camel@jlt3.sipsolutions.net> (sfid-20120315_162650_540944_9A093C96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 11:03 -0400, John W. Linville wrote:
> On Thu, Mar 15, 2012 at 03:47:14PM +0100, Johannes Berg wrote:
> > On Thu, 2012-03-15 at 10:25 -0400, John W. Linville wrote:
> > > On Thu, Mar 15, 2012 at 03:13:25PM +0100, Johannes Berg wrote:
> > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > 
> > > > The station signal value is supposed to be in dBm
> > > > which the device can't give, so don't report it.
> > > > 
> > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > Won't this break functionality for users of this device?
> > 
> > I don't know if it breaks functionality, but filling in values in the
> > wrong units doesn't seem like a good plan.
> 
> No, but if it isn't actually hurting anyting then I would rather
> change a comment or two (and perhaps augment the nl80211 code) than
> to simply break things for users.
> 
> FWIW, cfg80211_wireless_stats has been able to cope with the
> unspecified units since it was implemented in commit 8990646d.
> Maybe that was a bug but it is a user-visible one that has been around
> for years now...

Interesting, I had no idea. I was more concerned with the actual nl80211
exporting (nl80211_send_station), not wext. Seems like something like
this patch would be sufficient then:
http://p.sipsolutions.net/ca88e4afc69683ca.txt

Of course, we could add nl80211 attributes for unspec in the station
info too.

johannes

