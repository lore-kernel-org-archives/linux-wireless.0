Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1HILro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:47:44 -0400
Subject: Re: [RFC] mac80211: fix resuming when device is gone
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312890402.4109.24.camel@jlt3.sipsolutions.net> (sfid-20110809_134700_866928_217B169E)
References: <20110808141900.GA25857@redhat.com>
	 <1312819106.4372.37.camel@jlt3.sipsolutions.net>
	 <20110809092314.GA2152@redhat.com>
	 <1312882082.4109.2.camel@jlt3.sipsolutions.net>
	 <20110809093909.GB2152@redhat.com>
	 <1312883113.4109.5.camel@jlt3.sipsolutions.net>
	 <20110809113620.GA2488@redhat.com>
	 <1312890237.4109.22.camel@jlt3.sipsolutions.net>
	 (sfid-20110809_134410_503974_BF250E46)  <1312890325.4109.23.camel@jlt3.sipsolutions.net>
	 (sfid-20110809_134530_731807_FBE4BB9A)  <1312890402.4109.24.camel@jlt3.sipsolutions.net>
	 (sfid-20110809_134700_866928_217B169E)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 13:47:43 +0200
Message-ID: <1312890463.4109.25.camel@jlt3.sipsolutions.net> (sfid-20110809_134747_066652_79B1BFDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 13:46 +0200, Johannes Berg wrote:
> On Tue, 2011-08-09 at 13:45 +0200, Johannes Berg wrote:
> > On Tue, 2011-08-09 at 13:43 +0200, Johannes Berg wrote:
> > 
> > > > Yes, but __ieee80211_resume() calls directly ieee80211_reconfig().
> > > 
> > > Sure. Just trying to make sure I understand where it's coming from. So
> > > wiphy_unregister() is still running, before device_del(), but then we
> > > get the resume from the core...
> > > 
> > > Shouldn't we implement this logic you just did in cfg80211 instead?
> > 
> > Although I guess until wiphy_unregister() returns, drivers must still
> > expect callbacks, which clearly mac80211 didn't handle correctly here
> > with the timer...
> 
> Actually...
> 
> Doesn't that just mean we need to reorder the code in _free_hw()?

I mean ieee80211_unregister_hw().

>  If we
> do the timer stuff after wiphy_unregister(), we should be OK, and
> prevent other, similar problems in the future too.
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


