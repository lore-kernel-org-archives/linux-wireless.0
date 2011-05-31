Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1EaUGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 16:06:40 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DE543E2.9070600@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
	 <1306870354.29989.1.camel@jlt3.sipsolutions.net>
	 <4DE543E2.9070600@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 22:06:35 +0200
Message-ID: <1306872395.29989.3.camel@jlt3.sipsolutions.net> (sfid-20110531_220643_609468_0C5BA6B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 21:39 +0200, Felix Fietkau wrote:
> On 2011-05-31 9:32 PM, Johannes Berg wrote:
> > On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
> >>  When a STA entry is created too early, a lot of essential information
> >>  required for rate control is missing.
> >
> > I don't understand how you can rely on beacons for WDS.
> You usually set up WDS links between APs on the same channel, each 
> running both a normal AP vif and a WDS vif. The remote AP's beacons are 
> then used to detect the capabilities of the peer.

I don't think we can rely on "usually" unless we also enforce that
somehow. Otherwise this link will basically be dead. There's nothing
that requires you to add WDS to an AP interface only after all.

johannes

