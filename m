Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:50269 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0K2P1o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:27:44 -0500
Date: Mon, 29 Nov 2010 16:27:35 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
Message-ID: <20101129152735.GA32319@sig21.net>
References: <20101129145439.GA31910@sig21.net>
 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291043349.3532.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 04:09:09PM +0100, Johannes Berg wrote:
> On Mon, 2010-11-29 at 15:54 +0100, Johannes Stezenbach wrote:
> > ieee80211_tx_status() documentation says "This function may not be
> > called in IRQ context", and it is called by rt2800usb
> > from a workqueue context.  Thus it needs to call
> > netif_rx_ni() instead of netif_rx().
> > This change fixes the "NOHZ: local_softirq_pending 08"
> > messages I've been getting with rt2800usb.
> 
> > -					netif_rx(skb2);
> > +					netif_rx_ni(skb2);
> 
> That's kinda pointless though for drivers that already call it from a
> tasklet or similar -- how about instead adding an
> ieee80211_tx_status_ni() inline along the lines of ieee80211_rx_ni()?

It gets confusing...
There already is ieee80211_tx_status_irqsafe(), but you want a third
option, right?

Johannes
