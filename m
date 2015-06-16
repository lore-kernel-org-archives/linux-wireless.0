Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42883 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbbFPN21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 09:28:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.85)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Z4qug-0004S0-4b
	for linux-wireless@vger.kernel.org; Tue, 16 Jun 2015 15:28:26 +0200
Message-ID: <1434461305.2337.26.camel@sipsolutions.net> (sfid-20150616_152831_609582_3653D1D9)
Subject: Re: mac80211 and multiple RX queues (with RSS hashing)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 16 Jun 2015 15:28:25 +0200
In-Reply-To: <1434097914.2679.37.camel@sipsolutions.net> (sfid-20150612_103201_684238_7222E571)
References: <1434097914.2679.37.camel@sipsolutions.net>
	 (sfid-20150612_103201_684238_7222E571)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-06-12 at 10:31 +0200, Johannes Berg wrote:

>  * It would only support (non-null) data frames, management frames must
> not be
>    passed to the new API, but must be passed to the regular
> ieee80211_rx()
>    function.

Sorry about the line breaking - not sure how that happened.

Let me recap these points:
> * only real data frames allowed in "MQ RX" API
> * no _irqsafe variant
> * no software crypto
> * no monitor mode (TBD)

This makes no sense, I think I'll leave monitor mode.

> * no defragmentation
> * no client powersave support
> * no mesh, perhaps no IBSS
> * aggregation reorder already done
> * require NAPI struct (TBD)

Another item we might add:
 * no TDLS ethertype frames

Those are more control than data, so they shouldn't really go here. It
wouldn't be hard to support them going there, it just introduces race
conditions.

>  b) handling AP/GO powersaving clients
>     With RSS, we can end up with various races - right now we say TX
>     status and RX must be serialized by the driver, but clearly that
>     can no longer be guaranteed with multiple RX queues.

I'm just going to ignore this for now and disallow AP mode unless the HW
offload is enabled.

>     [also need to check if there are *other* things that require
>     serialization]

TBD

>  c) aggregation session timeout/reorder timer handling
>     There's a single field/timer (for each of this) per session,
>     obviously it's
>     not a great idea to hit these from multiple CPUs.

The reorder timeout is moot since we require already well-ordered
frames. Therefore, we can't even have it. Driver developers will have to
think about how to implement that though.

The aggregation session timeout handling actually doesn't really change,
just the data structure needs to be 'exploded' into per-queue structures
instead.

> a2) Alternatively, drivers could tell mac80211 before-hand how many
> queues they'll use, pass a queue identifier to mac80211 for each packet
> (e.g. in skb's queue_mapping) and have mac80211 gather per-queue
> statistics that get combined when read. This means allocating separate
> statistics/queue arrays for stations etc. in mac80211, and then using
> u64_stats_update_begin() etc. to get a consistent reading like we do
> with per-cpu netdev stats already (since my fairly recent patch.)

I'm going to go with this one, but block a few things like 'average
signal' and require drivers to implement those if needed.

johannes

