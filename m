Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2IZISe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 04:18:34 -0400
Message-ID: <1348647549.10548.8.camel@jlt4.sipsolutions.net> (sfid-20120926_101840_368819_D5DE1ECC)
Subject: Re: [RFC] mac80211: Notify new IBSS network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Sep 2012 10:19:09 +0200
In-Reply-To: <20578.47013.636428.710724@gargle.gargle.HOWL>
References: <20578.31128.207010.660580@gargle.gargle.HOWL>
	 <1348643666.10548.2.camel@jlt4.sipsolutions.net>
	 <20578.44784.141822.850065@gargle.gargle.HOWL>
	 <1348645070.10548.5.camel@jlt4.sipsolutions.net>
	 <20578.47013.636428.710724@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 13:37 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > That looks a bit different from what I thought though? Not really sure I
> > understand that though :-)
> 
> The basic issue was that we were not initializing the timers based on
> the sync'd TSF.
> 
> > What I'm thinking is that if you always just start beaconing, wouldn't
> > you just reset the beacon whenever you notice a higher TSF show up in
> > the network?
> > 
> > Actually I think we call reset_tsf() or something like that? But all of
> > that has always seemed very quirky to me.
> 
> Currently, I don't think we reset the beacon/timers for IBSS mode.
> 
> For station mode, all of this is handled in ath9k using the 
> PS_WAIT_FOR_BEACON/PS_BEACON_SYNC flags. For IBSS creator mode, there is
> no problem because mac80211 calls reset_tsf() in __ieee80211_sta_join_ibss().
> For joiner mode, drivers like ath9k need to do a beacon-sync (like station),
> before starting to pollute the environment with beacons, but there is no way to know
> if an existing IBSS network is being joined.

Right, makes sense. I have no objections to this patch, just wanted to
understand the issue better.

johannes

