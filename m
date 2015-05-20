Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbbETNTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:19:53 -0400
Message-ID: <1432127990.19214.14.camel@sipsolutions.net> (sfid-20150520_151957_060330_A77617B5)
Subject: Re: [PATCH 1/2] cfg80211: ignore netif running state when changing
 iftype
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:19:50 +0200
In-Reply-To: <1432127874.19214.13.camel@sipsolutions.net> (sfid-20150520_151808_644260_5B1376EA)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150519_143715_930971_C928777B) <1432127874.19214.13.camel@sipsolutions.net>
	 (sfid-20150520_151808_644260_5B1376EA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 15:17 +0200, Johannes Berg wrote:

> > -	if (ntype != otype && netif_running(dev)) {
> > +	if (ntype != otype) {
> >  		dev->ieee80211_ptr->use_4addr = false;
> >  		dev->ieee80211_ptr->mesh_id_up_len = 0;
> >  		wdev_lock(dev->ieee80211_ptr);
> 
> I don't think that makes much sense - the code within this block really
> only makes sense when the interface *is* running, like disconnecting
> etc. Doing that when it's *not* would be entirely unexpected to the
> drivers, no?

The real problem here might be the assignment to use_4addr *before*
we've actually disconnected or anything, perhaps that should be moved?

Similarly, the mesh_id_up_len should probably be moved into the mesh
point switch case...

johannes

