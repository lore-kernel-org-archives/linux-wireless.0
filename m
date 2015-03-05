Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38604 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbbCEQ7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 11:59:22 -0500
Message-ID: <1425574759.2493.29.camel@sipsolutions.net> (sfid-20150305_175929_054986_644B3D83)
Subject: Re: [RFC] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Marek Lindner <marek@open-mesh.com>
Date: Thu, 05 Mar 2015 17:59:19 +0100
In-Reply-To: <4955461.tuO2xra8Dr@bentobox> (sfid-20150305_165241_332301_188B5342)
References: <1425569832-22373-1-git-send-email-johannes@sipsolutions.net>
	 <4955461.tuO2xra8Dr@bentobox> (sfid-20150305_165241_332301_188B5342)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-05 at 16:52 +0100, Sven Eckelmann wrote:
> On Thursday 05 March 2015 16:37:12 Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Both minstrel (reported by Sven Eckelmann) and the iwlwifi rate
> > control aren't properly taking concurrency into account. It's
> > likely that the same is true for other rate control algorithms.
> > 
> > In the case of minstrel this manifests itself in crashes when an
> > update and other data access are run concurrently, for example
> > when the stations change bandwidth or similar. In iwlwifi, this
> > can cause firmware crashes.
> > 
> > Since fixing all rate control algorithms will be very difficult,
> > just provide locking for invocations. This protects the internal
> > data structures the algorithms maintain.
> > 
> > I've manipulated hostapd to test this, by having it change its
> > advertised bandwidth roughly ever 150ms. At the same time, I'm
> > running a flood ping between the client and the AP, which causes
> > this race of update vs. get_rate/status to easily happen on the
> > client. With this change, the system survives this test.
> > 
> > Reported-by: Sven Eckelmann <sven@open-mesh.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Thanks a lot for the patch. This is mostly what I had in mind when asking for 
> the correct lock.
> 
> I will ask if it is possible to test this patch in an affected network.

Actually, don't. This patch has a bug that causes crashes.

johannes

