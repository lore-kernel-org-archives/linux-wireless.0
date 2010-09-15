Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0IONF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 09:05:29 -0400
Subject: Re: [RFC] mac80211: avoid recalc_idle in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20100915130526.GA18627@vmraj-lnx.users.atheros.com>
References: <1284551772-18574-1-git-send-email-rmanoharan@atheros.com>
	 <1284552730.7705.0.camel@jlt3.sipsolutions.net>
	 <20100915130526.GA18627@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 15:05:26 +0200
Message-ID: <1284555926.7705.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 18:35 +0530, Rajkumar Manoharan wrote:

> > > -	mutex_lock(&local->mtx);
> > > -	hw_reconf_flags |= __ieee80211_recalc_idle(local);
> > > -	mutex_unlock(&local->mtx);
> > > +	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> > > +		mutex_lock(&local->mtx);
> > > +		hw_reconf_flags |= __ieee80211_recalc_idle(local);
> > > +		mutex_unlock(&local->mtx);
> > > +	}
> > 
> > Hmm, that doesn't seem right, wouldn't it be idle to start with?

> not sure whether I am missing something here. Shouldn't we be receiving frames
> in monitor mode as soon as the interface is up and running. I don't see any
> reason why should we even care about IDLE state for MONITOR mode.

But if the device is already idle, adding the monitor wouldn't change it
either, which seems wrong, no?

johannes

