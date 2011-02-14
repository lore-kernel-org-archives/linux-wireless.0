Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab1BNOIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:08:19 -0500
Subject: Re: [RFC v2 1/2] mac80211: add a function for setting the TIM bit
 for a specific station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
In-Reply-To: <4D5936D8.3030906@openwrt.org>
References: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
	 <1297685367.3785.33.camel@jlt3.sipsolutions.net>
	 <4D5936D8.3030906@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 15:08:14 +0100
Message-ID: <1297692494.3953.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 15:06 +0100, Felix Fietkau wrote:
> On 2011-02-14 1:09 PM, Johannes Berg wrote:
> > On Wed, 2011-02-09 at 00:32 +0100, Felix Fietkau wrote:
> >> When a driver wants to buffer some frames internally without feeding them
> >> back to mac80211, this allows it to still wake up the station
> > 
> > Why would the driver want to do this though?
> If a station enters powersave and the AP still has buffered frames for
> aggregation, those frames need to stay in the queue, since the driver
> controls the block ack window and keeps some state per frame (e.g.
> number of software retransmissions).
> If ath9k would send those frames back to mac80211, and mac80211 would
> drop some of them, then the client's reorder window would get messed up
> when the client comes back. This would also make managing frame sequence
> numbers more complicated, since the driver would have to skip assigning
> sequence numbers for frames where tx_info->flags has the
> IEEE80211_TX_INTFL_RETRANSMISSION bit set, but then also look for gaps
> caused by expired frames.

Ok, that makes sense. In fact, I think iwlwifi will have the same issue
since it buffers in hw queues... will have to check that.

johannes

