Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53880 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AaN4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 08:56:43 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 05:56:23 -0800
Date: Mon, 31 Jan 2011 19:25:55 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: disable ps if an AP type vif is present
Message-ID: <20110131135554.GC14176@vmraj-lnx.users.atheros.com>
References: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
 <1296473558.3812.15.camel@jlt3.sipsolutions.net>
 <20110131115341.GB14176@vmraj-lnx.users.atheros.com>
 <1296475637.3812.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1296475637.3812.18.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 05:37:16PM +0530, Johannes Berg wrote:
> On Mon, 2011-01-31 at 17:23 +0530, Rajkumar Manoharan wrote:
> 
> > > >  	list_for_each_entry(sdata, &local->interfaces, list) {
> > > >  		if (!ieee80211_sdata_running(sdata))
> > > >  			continue;
> > > > +		if (((sdata->vif.type == NL80211_IFTYPE_AP) ||
> > > > +		     (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) &&
> > > > +		    !sdata->vif.p2p) {
> > > > +			count = 0;
> > > > +			break;
> > > 
> > > I'd leave out the P2P check for now -- as soon as you have more than one
> > > interface we don't go to PS,
> > Not exactly. we are counting only station type, though we have multi vifs.
> 
> Right -- that was confusing.
> 
> > >and we don't have NoA things etc. yet.
> > the p2p check means that infra AP only.
> 
> Yeah but do we have any drivers that handle PS in P2P mode? I guess
> iwlwifi might if you have the right firmware, but ath9k surely won't?
> I'd rather not have to worry about it right now.
Ok. I leave the p2p check and send the patch. Thanks for the review.

--
Rajkumar
