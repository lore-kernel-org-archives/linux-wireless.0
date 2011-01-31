Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1AaMHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 07:07:19 -0500
Subject: Re: [RFC] mac80211: disable ps if an AP type vif is present
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110131115341.GB14176@vmraj-lnx.users.atheros.com>
References: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
	 <1296473558.3812.15.camel@jlt3.sipsolutions.net>
	 <20110131115341.GB14176@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 13:07:16 +0100
Message-ID: <1296475637.3812.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 17:23 +0530, Rajkumar Manoharan wrote:

> > >  	list_for_each_entry(sdata, &local->interfaces, list) {
> > >  		if (!ieee80211_sdata_running(sdata))
> > >  			continue;
> > > +		if (((sdata->vif.type == NL80211_IFTYPE_AP) ||
> > > +		     (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) &&
> > > +		    !sdata->vif.p2p) {
> > > +			count = 0;
> > > +			break;
> > 
> > I'd leave out the P2P check for now -- as soon as you have more than one
> > interface we don't go to PS,
> Not exactly. we are counting only station type, though we have multi vifs.

Right -- that was confusing.

> >and we don't have NoA things etc. yet.
> the p2p check means that infra AP only.

Yeah but do we have any drivers that handle PS in P2P mode? I guess
iwlwifi might if you have the right firmware, but ath9k surely won't?
I'd rather not have to worry about it right now.

johannes

