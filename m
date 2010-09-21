Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0IUTTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:19:09 -0400
Subject: Re: [mac80211/ath9k] mac80211/ath9k:  Support AMPDU with multiple
 VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C9904AE.7060107@candelatech.com>
References: <1285095455-29081-1-git-send-email-greearb@candelatech.com>
	 <1285096048.12764.9.camel@jlt3.sipsolutions.net>
	 <4C9904AE.7060107@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:19:09 +0200
Message-ID: <1285096749.12764.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 12:17 -0700, Ben Greear wrote:
> The tx path doesn't seem to pass in more than the hardware and the skb,
> and we don't always need to lookup the VIF, so looking it up early is
> probably a waste.
> 
> mac80211 could be changed to pass in the VIF in the xmit path,
> and then we could make sure that is passed through the entire
> xmit process, but that would touch a lot of drivers and code.

It does pass this through in the skb's CB.

> I'm more than happy to test any patches if someone thinks up
> a different approach.

I just don't want drivers using struct net_device pointers anywhere,
because they shouldn't have to worry about them.

johannes

