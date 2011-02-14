Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1BNMSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:18:01 -0500
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize
 latency
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <1297619803-2832-5-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-5-git-send-email-njs@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:17:51 +0100
Message-ID: <1297685871.3785.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> We maintain several ring buffers that queue up packets for the
> hardware to transmit. These buffers can be quite large, and the
> quality of wireless connections can vary greatly; as a result, it can
> be that a full queue might take multiple seconds to drain.
> 
> For instance, if there is a high-bandwidth outgoing flow, like a large
> file upload, then it will completely fill the tx queues. Once the
> queues are full, then any other outgoing packets -- like those sent
> when a user clicks on an HTTP link, or types into an SSH session --
> will have to wait at the end of the line, and will not actually be
> transmitted until multiple seconds have passed.  This results in a
> suboptimal level of interactive response.
> 
> So we really don't want to allow too many packets to get queued up. On
> the other hand, we do want to queue up *some* packets, to maintain
> throughput -- and the queue size that maintains interactivity for a
> degraded 1 Mb/s connection might not be so great for some
> super-fancy 802.11n 600 Mb/s connection.
> 
> This patch estimates how long it takes the hardware to transmit one
> packet (by comparing each packet's queue residency time to the number
> of packets it had to wait behind), and then further smooths these
> estimates with an EWMA. Then, it uses the estimated packet
> transmission time to choose the maximum queue size that will still
> produce reasonably bounded queue residency times, given current
> conditions.

This sounds nice -- but couldn't it just as well be implemented in
mac80211, at least for most devices (that have accurate TX status
reporting)?

johannes

