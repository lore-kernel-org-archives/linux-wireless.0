Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33628 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601Ab1AMKva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 05:51:30 -0500
Date: Thu, 13 Jan 2011 12:50:40 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: sbrown@cortland.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Mesh join/leave
Message-ID: <20110113105040.GA17181@jm.kir.nu>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
 <1294823034.3639.15.camel@jlt3.sipsolutions.net>
 <1294828087.16447.2.camel@mythtv.ewol.com>
 <1294829180.3639.19.camel@jlt3.sipsolutions.net>
 <1294830560.2333.2.camel@mythtv.ewol.com>
 <1294830768.3639.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294830768.3639.20.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 12:12:48PM +0100, Johannes Berg wrote:

> > > Of course maybe mac80211 should be doings omething like this too:
> > > @@ -2299,6 +2299,11 @@ struct sk_buff *ieee80211_beacon_get_tim
> > > +#ifdef CONFIG_MAC80211_MESH
> > > +		if (!sdata->u.mesh.mesh_id_len)
> > > +			goto out;
> > > +#endif

> Yeah but evidently ath9k isn't cleanly stopping beaconing, it's still
> attempting to beacon but doesn't get a beacon from mac80211 so can't
> send one.

Sounds like SWBA interrupt should be disabled or at least masked in some
cases when mac80211 indicates some kind of change. I have not looked at
details on what exactly is missing from ath9k. Anyway, yes, it would be
good to make ieee80211_beacon_get_tim() return NULL when mac80211 does
not want any Beacon frames to be transmitted.

-- 
Jouni Malinen                                            PGP id EFC895FA
