Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60885 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0HaR7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 13:59:43 -0400
Date: Tue, 31 Aug 2010 13:55:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Miles Lane <miles.lane@gmail.com>,
	rjw@sisk.pl, maciej.rutecki@gmail.com
Subject: Re: [PATCH 2.6.36] wireless: register wiphy rfkill w/o holding
 cfg80211_mutex
Message-ID: <20100831175546.GD2484@tuxdriver.com>
References: <1283206222-21830-1-git-send-email-linville@tuxdriver.com>
 <1283237477.3733.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283237477.3733.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 31, 2010 at 08:51:17AM +0200, Johannes Berg wrote:
> Thanks,
> 
> > +	res = rfkill_register(rdev->rfkill);
> > +	if (res)
> > +		return res;
> > +
> >  	mutex_lock(&cfg80211_mutex);
> >  
> >  	res = device_add(&rdev->wiphy.dev);
> >  	if (res)
> >  		goto out_unlock;
> 
> but does that behave correctly in sysfs? rfkill_register should create
> some sysfs stuff that points to the device that now only gets added
> later, doesn't that break things?

Yeah, I see that now -- should have looked closer.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
