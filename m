Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2CSKFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:05:30 -0400
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4F6703EA.2020306@openwrt.org>
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-2-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-3-git-send-email-nbd@openwrt.org>
	 <1332065875.3609.3.camel@jlt3.sipsolutions.net>
	 <4F65C374.2060505@openwrt.org>
	 <1332146368.3359.12.camel@jlt3.sipsolutions.net>
	 <4F6703EA.2020306@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 11:05:26 +0100
Message-ID: <1332151526.3359.15.camel@jlt3.sipsolutions.net> (sfid-20120319_110533_434488_2A3A761B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 11:01 +0100, Felix Fietkau wrote:

> > I'm not really convinced, for making them deferrable we should analyse
> > the consequences of that more carefully, for example it seems possible
> > that the system wakes up to send a packet, and then the first thing that
> > happens is a few aggregation handshakes ... that wastes a lot of time
> > and power.
> How is that any more expensive than triggering a wakeup before that time
> caused by the session timer expiry?

It might not be more expensive, but the timing would be odd? You'd tear
down the session just to set it up again?

> > Also, at least for TX aggregation, you don't even give them a timeout in
> > ath9k so that wouldn't really be an issue?
> minstrel_ht does give it a timeout. OpenWrt is not using the ath9k rate
> control module.

Good point. Still though I suspect that this should be made
configurable, where aggregation sessions don't consume hardware
resources (like in our case) and you set them up with the first packet
it doesn't really make sense to time them out etc.?

johannes

