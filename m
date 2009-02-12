Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbZBLEzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:55:51 -0500
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Sujith <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 11 Feb 2009 20:55:47 -0800
Subject: RE: [PATCH] mac80211: fix aggregation for hardware with ampdu queues
Message-ID: <E9954878DD1FB34FAE5187FB88C58A353F1ACF4B@orsmsx506.amr.corp.intel.com> (sfid-20090212_055553_724986_3E745133)
References: <1234396313.16004.65.camel@johannes.local>
 <18835.43402.286764.192456@gargle.gargle.HOWL>
In-Reply-To: <18835.43402.286764.192456@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for testing. Do you agree the medium-term sulution?

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: Sujith [mailto:Sujith.Manoharan@atheros.com] 
Sent: Wednesday, February 11, 2009 8:46 PM
To: Johannes Berg
Cc: John Linville; linux-wireless; Guy, Wey-Yi W
Subject: [PATCH] mac80211: fix aggregation for hardware with ampdu queues

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
