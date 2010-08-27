Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39126 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab0H0JHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 05:07:04 -0400
Date: Fri, 27 Aug 2010 12:06:55 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
Message-ID: <20100827090655.GA15873@jm.kir.nu>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 01:38:47AM -0400, Luis R. Rodriguez wrote:
> The new scan implementation only takes into consideration
> the the listen interval which the driver itself sets. The AP
> however will send all buffered broadcast and multicast data
> every dtim_period which typically is less than the listen
> interval. We are also currently not respecting the pm-qos
> network latency. Since dynamic powersave work already computes
> for us the minimum allowed sleep period reuse that work
> and ensure we don't sleep longer than what we allowed for.
> 
> Without this we drop buffered broadcast and multicast traffic.

Did you test how much this patch would help? While reducing the length
of each off-channel phase in background scan is indeed needed to receive
the broadcast frames, I don't see how this by itself would help at all.
Quite the opposite, I would not be surprised if this actually makes us
drop even larger number of broadcast frames by lengthening the total
scan duration and by adding more channel changes..

In order for this to provide real help for receiving broadcast/multicast
frames, the start of each off-channel scan sequence needs to be
synchronized with DTIM Beacon + PS broadcast/multicast RX. In other
words, when we are on the operating channel, we need to start the next
scan sequence immediately after receiving the last buffered
broadcast/multicast frame from our current AP (or if no buffered frames
are indicated in the DTIM Beacon, immediately after that Beacon frame is
received). This is obviously assuming that we are associated with an AP
(and only one AP for that matter; multiple virtual interfaces will make
this quite a bit more complex, but we can leave that for future work
while handling the simpler case now).

> If this requires a bit too many changes I am not sure how to handle
> this for stable. We'll see.

I would not even think about stable for this at the moment.. I don't
really consider this as a simple fix, but rather a completely new
feature for the background scan which was not previously designed to
handle broadcast/multicast receiving.

-- 
Jouni Malinen                                            PGP id EFC895FA
