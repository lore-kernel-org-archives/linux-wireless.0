Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2IGP16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:27:58 -0400
Message-ID: <1347031704.4256.26.camel@jlt4.sipsolutions.net> (sfid-20120907_172810_525114_ECBC163D)
Subject: Re: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 17:28:24 +0200
In-Reply-To: <504A11C0.5030602@candelatech.com>
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
	 <504A11C0.5030602@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 08:24 -0700, Ben Greear wrote:
> On 09/07/2012 07:54 AM, Felix Fietkau wrote:
> > skb->dev might contain a stale reference to a device that was already
> > deleted, and using it unchecked can lead to invalid pointer accesses.
> > Since this is only used for nl80211 tx, iterate over active interfaces
> > to find a match for skb->dev, and discard the tx status if the device
> > is gone.
> 
> Nasty performance hit if we have lots of virtual
> interfaces, eh?  Maybe some sort of ref-counting
> would be better?  Or a hashed lookup on the netdev
> pointer/token?

As Felix also pointed out to me, no. Frames that need to go to nl80211
should be rare, this isn't the common case.

johannes

