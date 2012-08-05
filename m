Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2HERVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 13:21:08 -0400
Message-ID: <1344187264.5765.4.camel@jlt3.sipsolutions.net> (sfid-20120805_192133_648139_FC40F06B)
Subject: Re: WDS vs. multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 05 Aug 2012 19:21:04 +0200
In-Reply-To: <501EA97B.3010703@openwrt.org>
References: <1343655393.4452.13.camel@jlt3.sipsolutions.net>
	 <501EA97B.3010703@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-05 at 19:12 +0200, Felix Fietkau wrote:
> On 2012-07-30 3:36 PM, Johannes Berg wrote:
> > Ok so I'm chipping away at multi-channel operation, but WDS is
> > troubling. Which channel should it use? It doesn't even have channel
> > configuration today, but relies on having a channel already, but that
> > breaks when you have multi-channel since then it either has to have its
> > own channel or be slaved to another channel...
> > 
> > Anyone have any ideas?
> Let's bind WDS interfaces to AP VIFs, then they can be slave to the AP's
> channel context. This is necessary for my yet-to-be-resubmitted WDS
> fixes anyway.

For now I decided that drivers supporting the channel context APIs will
not be allowed to support WDS interfaces :-P
(and the code in WDS TX will simply take the global channel as before)

So ... yes, I think this makes sense, but I'm not sure I care enough to
implement it right now, I have enough other things with multi-channel
still to do ... Though the question remains *how* we bind them. We could
try to match them by MAC address when they're brought up (and require
the same MAC address?), or do explicit binding, or something else
entirely ...

If you're going to require them to be bound to an AP though, where's the
difference to the current 4-addr AP_VLAN behaviour? It seems with that
you could actually implement a bound-to-AP-WDS entirely in userspace
since there's no requirement to actually go through the auth/assoc
sequence for hostapd to add the station entry?

johannes

