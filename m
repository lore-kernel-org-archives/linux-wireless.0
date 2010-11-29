Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0K2PJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:09:12 -0500
Subject: Re: [PATCH RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20101129145439.GA31910@sig21.net>
References: <20101129145439.GA31910@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:09:09 +0100
Message-ID: <1291043349.3532.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 15:54 +0100, Johannes Stezenbach wrote:
> ieee80211_tx_status() documentation says "This function may not be
> called in IRQ context", and it is called by rt2800usb
> from a workqueue context.  Thus it needs to call
> netif_rx_ni() instead of netif_rx().
> This change fixes the "NOHZ: local_softirq_pending 08"
> messages I've been getting with rt2800usb.

> -					netif_rx(skb2);
> +					netif_rx_ni(skb2);

That's kinda pointless though for drivers that already call it from a
tasklet or similar -- how about instead adding an
ieee80211_tx_status_ni() inline along the lines of ieee80211_rx_ni()?

johannes

