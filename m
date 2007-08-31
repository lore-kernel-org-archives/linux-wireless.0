Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:26098 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbXHaImK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 04:42:10 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: don't send invalid QoS frames
References: <1188483732.3978.13.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Fri, 31 Aug 2007 11:43:10 +0300
In-Reply-To: <1188483732.3978.13.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 30 Aug 2007 16\:22\:12 +0200")
Message-ID: <87wsvcksbl.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Kalle Valo noticed that QoS frames are sent with an invalid QoS control
> field; this is because we increase the header length but neither
> initialise the space nor actually have enough space in the header
> structure for the QoS control field.
>
> This patch fixes it by treating the QoS field specially and appending it
> explicitly, initialising it to zero.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> ---
> Kalle, please check if this fixes the weird frames you saw. I think it
> will but would like to be sure. If it does, please say so and then we
> should merge this patch to 2.6.24 and wireless-dev and I may make one
> for -stable as well.

Now b43 won't send any unicast frames to N800 according to a wireless
sniffer (and packet loss is 100%, obviously). Broadcast frames are
sent and N800 replies to ARP requests just fine.

I was a bit surprised by the result, so I double checked my tests.
After reverting this patch unicast frames were sent again, just that
QoS frames were broken as expected. So this patch definetely broke
unicast QoS send.

Tested with wireless-dev#anything commit 60faa0c2 and N800 had PSM
disabled. I didn't have time to test with QoS disabled, sorry. But I
can test that later, if you want.

-- 
Kalle Valo
