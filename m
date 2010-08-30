Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37132 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0H3Tok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:44:40 -0400
Date: Mon, 30 Aug 2010 15:37:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw
Message-ID: <20100830193701.GF30864@tuxdriver.com>
References: <1283195671-4086-1-git-send-email-linville@tuxdriver.com>
 <1283195879.3694.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283195879.3694.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 09:17:59PM +0200, Johannes Berg wrote:
> On Mon, 2010-08-30 at 15:14 -0400, John W. Linville wrote:
> > This function exists to clean-up after a hardware error or something
> > similar.  The restart is accomplished using the same infrastructure used
> > to resume after a suspend.  The suspend path cancels running scans, so
> > it seems appropriate to do that here as well.
> 
> > -	/* use this reason, __ieee80211_resume will unblock it */
> > +	ieee80211_scan_cancel(local);
> > +
> > +	/* use this reason, ieee80211_reconfig will unblock it */
> 
> Hmm, yes .. but how will this interact with hw scan?

You tell me -- I would think that calling ieee80211_restart_hw
would effectively abandon all hope of a hardware scan completing.
Should the caller call ieee80211_scan_completed(..., 1)?  Or should
we do that (or equivalent) here too?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
