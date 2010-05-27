Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab0E0JRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 05:17:38 -0400
Subject: Re: [RFC PATCHv3] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274951117.5277.3155.camel@wimaxnb.nmp.nokia.com>
References: <1274940287-18980-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274948667.3669.19.camel@jlt3.sipsolutions.net>
	 <1274951117.5277.3155.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 11:17:34 +0200
Message-ID: <1274951854.3669.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 12:05 +0300, Juuso Oikarinen wrote:

> > > +	/* We are concerned about IP addresses only when associated */
> > > +	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
> > > +	mutex_lock(&sdata->u.mgd.mtx);
> > > +	ifmgd = &sdata->u.mgd;
> > > +	if (ifmgd->associated)
> > > +		ieee80211_set_arp_filter(sdata);
> > > +	mutex_unlock(&sdata->u.mgd.mtx);
> > 
> > I'm sure this will fail in interesting ways since nothing guarantees
> > that this interface is in managed mode.
> 
> S***, I need a vacation. This is bound to fail even if the interface is
> in managed mode, as it's not protecting the right thing. 
> 
> I was already looking at the ifmgd->mtx but somehow managed to
> copy-paste this one :(

Hm? If you bail out on non-managed or something like that, it should be
fine? ifmgd->mtx is the same as sdata->u.mgd.mtx, you just don't need
the ifmgd variable here.

johannes

