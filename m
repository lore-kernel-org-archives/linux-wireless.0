Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:29657 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754146Ab0KEORH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 10:17:07 -0400
Subject: Re: [RFC 03/15] nl80211: alloc and free the periodic_req data
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885396.3659.1.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-4-git-send-email-luciano.coelho@nokia.com>
	 <1288885396.3659.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 16:14:55 +0200
Message-ID: <1288966495.1849.26.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:43 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> 
> > +	/*
> > +	 * FIXME: Can this stay here? How will the auto-complete and other
> > +	 * cleanup cases work?
> > +	 */
> > +	kfree(rdev->periodic_req);
> > +	rdev->periodic_req = NULL;
> 
> No ... you want a new function that you call here, and also call the
> stop into the device at netdev down from the notifier in core.c.

Sure! I'll change it.


-- 
Cheers,
Luca.

