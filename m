Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0EXIYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:24:21 -0400
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100524081455.GB19669@nalle>
References: <20100523162240.GZ19669@nalle>
	 <1274688345.3743.2.camel@jlt3.sipsolutions.net>
	 <20100524081455.GB19669@nalle>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:24:17 +0200
Message-ID: <1274689457.3743.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-24 at 11:14 +0300, Mikko Rapeli wrote:

> > > $ dmesg | tail -10
> > > [ 1986.772018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.776149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.780076] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.784020] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.788149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.792108] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.796070] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.800018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.804186] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > > [ 1986.808072] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > 
> > Hm. That's not supposed to happen over and over again that quickly, only
> > every few seconds. I wonder if that's related to the other timer issue
> > that we saw in ibss.
> 
> I've had this spamming problem since December 2009 with all 2.6.32 kernels
> from Debian unstable, so this not something new from 2.6.34.

Do I even want to comment on that? In any case -- it's not supposed to
be spamming you so we want to find the root cause. Can you enable
verbose IBSS debug to hopefully see why it's happening?

johannes

