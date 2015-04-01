Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58790 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbbDAOUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 10:20:07 -0400
Message-ID: <1427897999.3428.10.camel@sipsolutions.net> (sfid-20150401_162012_413407_A308DEF9)
Subject: Re: [PATCH v7] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Apr 2015 16:19:59 +0200
In-Reply-To: <1427488237-49660-1-git-send-email-nbd@openwrt.org>
References: <1427488237-49660-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-27 at 21:30 +0100, Felix Fietkau wrote:
> This allows drivers to request per-vif and per-sta-tid queues from which
> they can pull frames. This makes it easier to keep the hardware queues
> short, and to improve fairness between clients and vifs.
> 
> The task of scheduling packet transmission is left up to the driver -
> queueing is controlled by mac80211. Drivers can only dequeue packets by
> calling ieee80211_tx_dequeue. This makes it possible to add active queue
> management later without changing drivers using this code.
> 
> This can also be used as a starting point to implement A-MSDU
> aggregation in a way that does not add artificially induced latency.

Applied, with some minor changes:
 * documentation fixes
 * endian annotation fixes
 * made tracing a bit more efficient

johannes

