Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab0HaJaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 05:30:08 -0400
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100830193701.GF30864@tuxdriver.com>
References: <1283195671-4086-1-git-send-email-linville@tuxdriver.com>
	 <1283195879.3694.15.camel@jlt3.sipsolutions.net>
	 <20100830193701.GF30864@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 11:29:41 +0200
Message-ID: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 15:37 -0400, John W. Linville wrote:

> > > -	/* use this reason, __ieee80211_resume will unblock it */
> > > +	ieee80211_scan_cancel(local);
> > > +
> > > +	/* use this reason, ieee80211_reconfig will unblock it */
> > 
> > Hmm, yes .. but how will this interact with hw scan?
> 
> You tell me -- I would think that calling ieee80211_restart_hw
> would effectively abandon all hope of a hardware scan completing.
> Should the caller call ieee80211_scan_completed(..., 1)?  Or should
> we do that (or equivalent) here too?

Yeah, I guess the caller probably should since it may have internal
state that needs resetting for scans as well. Maybe we should
WARN_ON(scan in progress) here for the hw scan case, and do what you're
proposing only for SW scan?

johannes

