Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36507 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1BNOGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:06:20 -0500
Message-ID: <4D5936D8.3030906@openwrt.org>
Date: Mon, 14 Feb 2011 15:06:16 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
Subject: Re: [RFC v2 1/2] mac80211: add a function for setting the TIM bit
 for a specific station
References: <1297207937-88528-1-git-send-email-nbd@openwrt.org> <1297685367.3785.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1297685367.3785.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-14 1:09 PM, Johannes Berg wrote:
> On Wed, 2011-02-09 at 00:32 +0100, Felix Fietkau wrote:
>> When a driver wants to buffer some frames internally without feeding them
>> back to mac80211, this allows it to still wake up the station
> 
> Why would the driver want to do this though?
If a station enters powersave and the AP still has buffered frames for
aggregation, those frames need to stay in the queue, since the driver
controls the block ack window and keeps some state per frame (e.g.
number of software retransmissions).
If ath9k would send those frames back to mac80211, and mac80211 would
drop some of them, then the client's reorder window would get messed up
when the client comes back. This would also make managing frame sequence
numbers more complicated, since the driver would have to skip assigning
sequence numbers for frames where tx_info->flags has the
IEEE80211_TX_INTFL_RETRANSMISSION bit set, but then also look for gaps
caused by expired frames.

- Felix
