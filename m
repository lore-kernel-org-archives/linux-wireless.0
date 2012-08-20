Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2HTL17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:27:59 -0400
Message-ID: <1345462075.4459.16.camel@jlt3.sipsolutions.net> (sfid-20120820_132803_113168_E4658471)
Subject: Re: [PATCH 1/2] mac80211: add sta_update_rates callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:27:55 +0200
In-Reply-To: <20120809094455.GH6767@ritirata.org>
References: <1344474712-22561-1-git-send-email-ordex@autistici.org>
	 <1344492897.4494.1.camel@jlt3.sipsolutions.net>
	 <20120809093245.GG6767@ritirata.org> <20120809094455.GH6767@ritirata.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-09 at 11:44 +0200, Antonio Quartulli wrote:
> On Thu, Aug 09, 2012 at 11:32:46AM +0200, Antonio Quartulli wrote:
> > On Thu, Aug 09, 2012 at 08:14:57AM +0200, Johannes Berg wrote:
> > > Also there's already an update call sta_rc_update() so I think you
> > > should just define a new change flag for that?
> > 
> > mh, at the very beginning I thought it was not correct what you said, but indeed
> > we should be able to do the job in sta_rc_update().
> > 
> > But then why does the ath9k_htc driver implement ath9k_htc_update_rate() to
> > update the rate used to talk to the AP? Should it use sta_rc_update() as well?
> 
> Well, I am digging into the driver a bit more and I realised that the supported
> rate set does not touch the RC at all. The supported rates are only stored in
> the device (this is why there is another function for doing that in case of STA
> mode) and then the RC will play its game from a different point.

That's strange, why would the device care about the supported rateset of
an IBSS peer? or does it have some rate control in the device?

> For the reason above sta_rc_update() can't do what we want. At this point I
> think we have two options:
> 1) mac80211 forces this change to be done by sta_rc_update() => ath9k has to
> adapt it's implementation to follow the API
> 2) mac80211 uses another callback (sta_update_rates()) to refresh the supported
> rates set.
> 
> I think that option 2) is probably the way to go, because the RC stuff is
> usually not strictly related to the real device (e.g. ath9k has its own rc
> routines shared among ath9k and ath9k_htc but they have different routins to set
> the supported_rates set for a station.)

But the rate control algorithm is re-inited in this case or something?

johannes

