Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50469 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbcF2HTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 03:19:34 -0400
Message-ID: <1467184768.2461.4.camel@sipsolutions.net> (sfid-20160629_091958_135476_58BA010F)
Subject: Re: [PATCH] mac80211: rx: frames received out of order
From: Johannes Berg <johannes@sipsolutions.net>
To: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 29 Jun 2016 09:19:28 +0200
In-Reply-To: <20160628111510.8857-1-yanivma@ti.com> (sfid-20160628_131244_408880_6CCF5685)
References: <20160628111510.8857-1-yanivma@ti.com>
	 (sfid-20160628_131244_408880_6CCF5685)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-28 at 14:15 +0300, Yaniv Machani wrote:
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

Please rewrite this commit log in active voice, and explain the fix
too.

> Signed-off-by: Meirav Kama <meiravk@ti.com>
> Acked-by: Yaniv Machani <yanivma@ti.com>

See Julian's comment.

johannes

