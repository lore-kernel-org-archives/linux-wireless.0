Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46678 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab0HBUVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:21:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 13:21:42 -0700
Date: Mon, 2 Aug 2010 13:21:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jan Friedrich <jft@dev2day.de>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
Message-ID: <20100802202137.GC8920@tux>
References: <4C57278E.1030601@dev2day.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C57278E.1030601@dev2day.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 02, 2010 at 01:16:14PM -0700, Jan Friedrich wrote:
> This patch addresses the erasure of ieee80211_rx_status.mactime.
> 
> After the mactime is set in "ath_rx_tasklet" it is immediately nulled in
> "ath9k_rx_skb_preprocess".

What effect does this have? What issue does this fix? Is this a
fix which also needs to be propagated to the stable kernels, if so
why? etc.

Your patch describes what it does, it doesn't say why its a good
fix or what was affected before. Please clarify all this as best
as you can so we can help ACK/NACK/propagate the patch to stable
if it is appropriate.

  Luis
>  		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
