Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2FFLxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:53:03 -0400
Message-ID: <1338983581.26346.2.camel@jlt3.sipsolutions.net> (sfid-20120606_135307_006832_6B1DF605)
Subject: Re: [RFC 07/14] cfg80211: track monitor interfaces count
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>, Kalle Valo <kvalo@adurom.com>
Date: Wed, 06 Jun 2012 13:53:01 +0200
In-Reply-To: <4FCF41AA.9070400@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	  <1338203942-5667-8-git-send-email-michal.kazior@tieto.com>
	 <1338973824.4513.42.camel@jlt3.sipsolutions.net>
	 <4FCF41AA.9070400@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 13:40 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > The other thing we might then want to is make this more general and not
> > just inform the driver about the monitor/no-monitor layout change, but
> > also tell it which interface combination we're in right now? Might look
> > a bit more like
> >
> > set_iface_combination(wiphy, dev, combination);
> >
> > or even
> > set_iface_combination(wiphy, dev, combination, have_monitor);
> >
> >
> > Then pure monitor would be "combination == NULL, have_monitor=True",
> > etc. The only downside is that we don't have combinations advertised for
> > when there's a single interface only, so we'd have to point to some
> > internal single-interface combinations then (static in cfg80211).
> > Thoughts?
> 
> I'm afraid we can't simply tell which combination we're in. I imagine 
> there may be two or three combinations matching at the same time. Take 
> this for example:
> 
>    comb1: 1xSTA + 1xAP (max channels = 1)
>    comb2: 2xSTA (max channels = 2)
> 
>    wlan0 is running as STA @ chan=1
> 
> Which combination are we in? Which one should we report to the driver?

Doesn't matter, right? Pick the one with most channels or something? :-)

> I don't see what passing current interface combination would be useful 
> for. Do you have something particular in mind?

I'm thinking about # of channels in the combination mostly, in
particular in combination with IBSS. OTOH, if we always reserve one
channel for IBSS in cfg80211 (unless it's fixed & driver supports that)
then it won't matter.

But then again, what about say 2xSTA being active and drivers with
connect() API?

johannes

