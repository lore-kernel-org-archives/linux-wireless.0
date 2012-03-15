Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55216 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031096Ab2COQCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 12:02:11 -0400
Date: Thu, 15 Mar 2012 11:58:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rndis_wlan: don't report station signal
Message-ID: <20120315155802.GE31717@tuxdriver.com> (sfid-20120315_170215_515351_67DBF5FF)
References: <1331820805.3432.17.camel@jlt3.sipsolutions.net>
 <20120315142527.GC31717@tuxdriver.com>
 <1331822834.3432.22.camel@jlt3.sipsolutions.net>
 <20120315150313.GD31717@tuxdriver.com>
 <1331825203.3432.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331825203.3432.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 04:26:43PM +0100, Johannes Berg wrote:
> On Thu, 2012-03-15 at 11:03 -0400, John W. Linville wrote:
> > On Thu, Mar 15, 2012 at 03:47:14PM +0100, Johannes Berg wrote:
> > > On Thu, 2012-03-15 at 10:25 -0400, John W. Linville wrote:
> > > > On Thu, Mar 15, 2012 at 03:13:25PM +0100, Johannes Berg wrote:
> > > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > > 
> > > > > The station signal value is supposed to be in dBm
> > > > > which the device can't give, so don't report it.
> > > > > 
> > > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > 
> > > > Won't this break functionality for users of this device?
> > > 
> > > I don't know if it breaks functionality, but filling in values in the
> > > wrong units doesn't seem like a good plan.
> > 
> > No, but if it isn't actually hurting anyting then I would rather
> > change a comment or two (and perhaps augment the nl80211 code) than
> > to simply break things for users.
> > 
> > FWIW, cfg80211_wireless_stats has been able to cope with the
> > unspecified units since it was implemented in commit 8990646d.
> > Maybe that was a bug but it is a user-visible one that has been around
> > for years now...
> 
> Interesting, I had no idea. I was more concerned with the actual nl80211
> exporting (nl80211_send_station), not wext. Seems like something like
> this patch would be sufficient then:
> http://p.sipsolutions.net/ca88e4afc69683ca.txt
> 
> Of course, we could add nl80211 attributes for unspec in the station
> info too.

Yes, I came-up with something similar -- patch to follow...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
