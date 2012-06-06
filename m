Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFJK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:10:26 -0400
Message-ID: <1338973824.4513.42.camel@jlt3.sipsolutions.net> (sfid-20120606_111029_713624_4F0864F2)
Subject: Re: [RFC 07/14] cfg80211: track monitor interfaces count
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Kalle Valo <kvalo@adurom.com>
Date: Wed, 06 Jun 2012 11:10:24 +0200
In-Reply-To: <1338203942-5667-8-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-8-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Implements .set_monitor_enabled(wiphy, enabled).
> 
> Notifies driver upon change of interface layout.
> 
> If only monitor interfaces become present it is
> called with 2nd argument being true. If
> non-monitor interface appears then 2nd argument
> is false. Driver is notified only upon change.
> 
> This makes it more obvious about the fact that
> cfg80211 supports single monitor channel. Once we
> implement multi-channel we don't want to allow
> setting monitor channel while other interface
> types are running. Otherwise it would be ambiguous
> once we start considering num_different_channels.
> 
> Change-Id: Ibd82a70c256c2de584eb541ea2c36663a59f09d4
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This is essentially how mac80211 behaves now, and I have no problem
imposing it on the rest of the stack as well, but I think we can
probably get rid of some more generic functionality then?

Like the software_iftypes. What if the driver actually wants us to track
the monitor channel like any other context? Doesn't make any sense for
mac80211, but before this it would have been possible.

Essentially you're saying that monitor is always a software iftype, and
that it should always behave like in mac80211 -- if it's alone then it's
a monitor, if not alone it just sees what the others see.

What do the others thing? Bing? Kalle?

The other thing we might then want to is make this more general and not
just inform the driver about the monitor/no-monitor layout change, but
also tell it which interface combination we're in right now? Might look
a bit more like

set_iface_combination(wiphy, dev, combination);

or even
set_iface_combination(wiphy, dev, combination, have_monitor);


Then pure monitor would be "combination == NULL, have_monitor=True",
etc. The only downside is that we don't have combinations advertised for
when there's a single interface only, so we'd have to point to some
internal single-interface combinations then (static in cfg80211).
Thoughts?

johannes


