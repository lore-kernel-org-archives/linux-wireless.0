Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52814 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbcHKNE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 09:04:28 -0400
Message-ID: <1470920661.12075.12.camel@sipsolutions.net> (sfid-20160811_150432_720297_0F2377CE)
Subject: Re: [PATCH v3] mac80211: mesh: set tx_info->hw_queue to the correct
 queue upon packet forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 11 Aug 2016 15:04:21 +0200
In-Reply-To: <20160808070610.20563-1-yanivma@ti.com>
References: <20160808070610.20563-1-yanivma@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-08 at 10:06 +0300, Yaniv Machani wrote:
> From: Meirav Kama <meiravk@ti.com>
> 
> MP received data frames from another MP. Frames are forwarded
> from Rx to Tx to be transmitted to a third MP.
> Upon cloning the skb, the tx_info was zeroed, and the
> hw_queue wasn't set correctly, causing frames to be
> inserted to queue 0 (VOICE). If re-queue occurred for some
> reason, frame will be inserted to correct queue 2 (BE).
> In this case frames are now dequeued from 2 different queues and
> sent out of order.

Uh, sorry. I was so focused on the commit message and everything that I
neglected to look into the code change ... :(

>  	info->control.jiffies = jiffies;
> +	info->hw_queue = q;
> 
This is incorrect. 'q' appears to be the AC here, so you need to set
something like vif->hw_queue[q], afaict? Check out tx.c where this is
set.

johannes
