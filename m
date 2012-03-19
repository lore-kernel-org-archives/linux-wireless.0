Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51780 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab2CSKeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:34:10 -0400
Message-ID: <4F670B9C.8040908@openwrt.org> (sfid-20120319_113413_315892_6A1B0D3E)
Date: Mon, 19 Mar 2012 11:34:04 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout handling
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>  <1332025254-5048-2-git-send-email-nbd@openwrt.org>  <1332025254-5048-3-git-send-email-nbd@openwrt.org>  <1332065875.3609.3.camel@jlt3.sipsolutions.net>  <4F65C374.2060505@openwrt.org>  <1332146368.3359.12.camel@jlt3.sipsolutions.net>  <4F6703EA.2020306@openwrt.org> <1332151526.3359.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332151526.3359.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-19 11:05 AM, Johannes Berg wrote:
> On Mon, 2012-03-19 at 11:01 +0100, Felix Fietkau wrote:
> 
>> > I'm not really convinced, for making them deferrable we should analyse
>> > the consequences of that more carefully, for example it seems possible
>> > that the system wakes up to send a packet, and then the first thing that
>> > happens is a few aggregation handshakes ... that wastes a lot of time
>> > and power.
>> How is that any more expensive than triggering a wakeup before that time
>> caused by the session timer expiry?
> 
> It might not be more expensive, but the timing would be odd? You'd tear
> down the session just to set it up again?
I don't think it matters, since it's an extremely rare case anyway, and
without my change it would have to re-establish the aggregation session
anyway. It's much more likely for it to run into a wakeup from something
else on the system before that happens.

>> > Also, at least for TX aggregation, you don't even give them a timeout in
>> > ath9k so that wouldn't really be an issue?
>> minstrel_ht does give it a timeout. OpenWrt is not using the ath9k rate
>> control module.
> 
> Good point. Still though I suspect that this should be made
> configurable, where aggregation sessions don't consume hardware
> resources (like in our case) and you set them up with the first packet
> it doesn't really make sense to time them out etc.?
Yes, makes sense.

- Felix
