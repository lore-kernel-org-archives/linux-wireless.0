Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1ALLMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 06:12:09 -0500
Subject: Re: Mesh join/leave
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1294830560.2333.2.camel@mythtv.ewol.com>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
	 <1294823034.3639.15.camel@jlt3.sipsolutions.net>
	 <1294828087.16447.2.camel@mythtv.ewol.com>
	 <1294829180.3639.19.camel@jlt3.sipsolutions.net>
	 <1294830560.2333.2.camel@mythtv.ewol.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 12:12:48 +0100
Message-ID: <1294830768.3639.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 06:09 -0500, Steve Brown wrote:

> > Of course maybe mac80211 should be doings omething like this too:
> > 
> > johannes
> > 
> > --- wireless-testing.orig/net/mac80211/tx.c	2011-01-12 11:44:52.000000000 +0100
> > +++ wireless-testing/net/mac80211/tx.c	2011-01-12 11:45:52.000000000 +0100
> > @@ -2299,6 +2299,11 @@ struct sk_buff *ieee80211_beacon_get_tim
> >  		struct ieee80211_mgmt *mgmt;
> >  		u8 *pos;
> >  
> > +#ifdef CONFIG_MAC80211_MESH
> > +		if (!sdata->u.mesh.mesh_id_len)
> > +			goto out;
> > +#endif
> > +
> >  		/* headroom, head length, tail length and maximum TIM length */
> >  		skb = dev_alloc_skb(local->tx_headroom + 400 +
> >  				sdata->u.mesh.vendor_ie_len);
> > 
> > 
> With the patch, leave/join stop and restart beaconing.

Yeah but evidently ath9k isn't cleanly stopping beaconing, it's still
attempting to beacon but doesn't get a beacon from mac80211 so can't
send one.

johannes

