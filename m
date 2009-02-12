Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21222 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZBLEuD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:50:03 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:50:02 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.43402.286764.192456@gargle.gargle.HOWL> (sfid-20090212_055011_206921_63D16887)
Date: Thu, 12 Feb 2009 10:16:02 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: [PATCH] mac80211: fix aggregation for hardware with ampdu queues
In-Reply-To: <1234396313.16004.65.camel@johannes.local>
References: <1234396313.16004.65.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hardware with AMPDU queues currently has broken aggregation.
> 
> This patch fixes it by making all A-MPDUs go over the regular AC queues,
> but keeping track of the hardware queues in mac80211. As a first rough
> version, it actually stops the AC queue for extended periods of time,
> which can be removed by adding buffering internal to mac80211, but is
> currently not a huge problem because people rarely use multiple TIDs
> that are in the same AC (and iwlwifi currently doesn't operate as AP).
> 
> This is a short-term fix, my current medium-term plan, which I hope to
> execute soon as well, but am not sure can finish before .30, looks like
> this:
>  1) rework the internal queuing layer in mac80211 that we use for
>     fragments if the driver stopped queue in the middle of a fragmented
>     frame to be able to queue more frames at once (rather than just a
>     single frame with its fragments)
>  2) instead of stopping the entire AC queue, queue up the frames in a
>     per-station/per-TID queue during aggregation session initiation,
>     when the session has come up take all those frames and put them
>     onto the queue from 1)
>  3) push the ampdu queue layer abstraction this patch introduces in
>     mac80211 into the driver, and remove the virtual queue stuff from
>     mac80211 again
> 
> This plan will probably also affect ath9k in that mac80211 queues the
> frames instead of passing them down, even when there are no ampdu queues.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested with ath9k, works okay.

Sujith
