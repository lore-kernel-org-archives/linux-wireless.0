Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:8422 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbYEFVAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 17:00:06 -0400
Received: by ug-out-1314.google.com with SMTP id h2so443522ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 14:00:04 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add RTNL version of ieee80211_iterate_active_interfaces
Date: Tue, 6 May 2008 23:07:32 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200805061943.31902.IvDoorn@gmail.com> <1210099386.3914.21.camel@johannes.berg>
In-Reply-To: <1210099386.3914.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805062307.32504.IvDoorn@gmail.com> (sfid-20080506_225936_697813_4ECF6C01)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 May 2008, Johannes Berg wrote:
> 
> > +	 * requested configurations, make sure to use
> > +	 * the _rtnl version since the regular version
> > +	 * requires atomic context.
> 
> That's a bit misleading, the regular version requires that the callback
> is atomic :)

Ok, will fix.

> > +	 */
> > +	rtnl_lock();
> > +	ieee80211_iterate_active_interfaces_rtnl(rt2x00dev->hw,
> > +						 rt2x00lib_intf_scheduled_iter,
> > +						 rt2x00dev);
> > +	rtnl_unlock();
> 
> >  /**
> > + * ieee80211_iterate_active_interfaces_rtnl - iterate active interfaces
> > + *
> > + * This function iterates over the interfaces associated with a given
> > + * hardware that are currently active and calls the callback for them.
> > + * This function allows the iterator function to sleep, the caller is
> > + * responsible for proper locking mechanisms to prevent concurrency.
> 
> That description seems misleading. Also, since the mac80211 internal
> list management could possibly change (I don't see it changing but who
> knows), I think I'd prefer if this function acquired the rtnl itself

Ok, that is what I prefered as well, but the patch reverted it to the
original version ;)

> didn't have rtnl in the name. Can't think of a good name right now,
> maybe rename the other one to _atomic?

Ok, will fix.

Ivo
