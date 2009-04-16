Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45298 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbZDPQBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 12:01:08 -0400
Date: Thu, 16 Apr 2009 19:00:56 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow scan to be requested in AP mode
Message-ID: <20090416160056.GA7912@jm.kir.nu> (sfid-20090416_180113_532614_83B9C475)
References: <20090416154453.GA7311@jm.kir.nu> <1239897117.14169.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239897117.14169.8.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 05:51:57PM +0200, Johannes Berg wrote:
> On Thu, 2009-04-16 at 18:44 +0300, Jouni Malinen wrote:
> > --- uml.orig/net/mac80211/cfg.c	2009-04-16 18:20:19.000000000 +0300
> > +++ uml/net/mac80211/cfg.c	2009-04-16 18:33:44.000000000 +0300
> > @@ -1167,7 +1167,8 @@ static int ieee80211_scan(struct wiphy *
> >  
> >  	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
> >  	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
> > -	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
> > +	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
> > +	    (sdata->vif.type != NL80211_IFTYPE_AP || sdata->u.ap.beacon))
> >  		return -EOPNOTSUPP;
> 
> Should this return a different error code for AP then? Maybe -EBUSY for
> AP && beacon? Then again, EBUSY is already returned for "already
> scanning". hmm.

I thought about that for a moment, but did not come up with a good error
code.. ;-)  EBUSY is not a good option here since that could be used by
applications to decide that they should try again (which would not help
here at all). If someone has a better one in mind, I would have no
problems changing this, but I don't see much problems with EOPNOTSUPP
either.

-- 
Jouni Malinen                                            PGP id EFC895FA
