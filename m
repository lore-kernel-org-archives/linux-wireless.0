Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1FAER1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 00:17:27 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DE54E16.7000709@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
	 <1306870354.29989.1.camel@jlt3.sipsolutions.net>
	 <4DE543E2.9070600@openwrt.org>
	 <1306872395.29989.3.camel@jlt3.sipsolutions.net>
	 <4DE54E16.7000709@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 06:17:23 +0200
Message-ID: <1306901843.3867.2.camel@jlt3.sipsolutions.net> (sfid-20110601_061730_484040_9A5E0515)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 22:22 +0200, Felix Fietkau wrote:
> On 2011-05-31 10:06 PM, Johannes Berg wrote:
> > On Tue, 2011-05-31 at 21:39 +0200, Felix Fietkau wrote:
> >>  On 2011-05-31 9:32 PM, Johannes Berg wrote:
> >>  >  On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
> >>  >>   When a STA entry is created too early, a lot of essential information
> >>  >>   required for rate control is missing.
> >>  >
> >>  >  I don't understand how you can rely on beacons for WDS.
> >>  You usually set up WDS links between APs on the same channel, each
> >>  running both a normal AP vif and a WDS vif. The remote AP's beacons are
> >>  then used to detect the capabilities of the peer.
> >
> > I don't think we can rely on "usually" unless we also enforce that
> > somehow. Otherwise this link will basically be dead. There's nothing
> > that requires you to add WDS to an AP interface only after all.
> I don't think using WDS without APs makes any sense. Since WDS alone 
> does not use beacons or probe requests, there's nothing else that would 
> ensure that rate information, HT capabilities, etc. get exchanged.

I just don't like the fact that you can create a non-functional WDS
interface by adding it when there's no AP interface.

johannes

