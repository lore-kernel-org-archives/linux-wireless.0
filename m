Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28700 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab0DGEkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 00:40:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 21:40:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19388.4470.438422.209224@gargle.gargle.HOWL>
Date: Wed, 7 Apr 2010 10:30:38 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath9k_htc: Protect RX stream variables
In-Reply-To: <p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
References: <19387.1459.438884.832345@gargle.gargle.HOWL>
	<p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> 2010/4/6 Sujith <Sujith.Manoharan@atheros.com>:
> > Use a spin lock to prevent concurrent access
> > to variables dealing with RX stream mode handling.
> 
> which variables are needed to be protected?
> 
> It seems hif_dev->rx_transfer_len, hif_dev->remain_skb
> and hif_dev->rx_pkt_len are only accessed in ath9k_hif_usb_rx_stream,
> which is only called in hard irq(urb->complete) context and now is
> serialized strictly, so the protection is useless, isn't it?

On a SMP machine, the RX callback can run on two CPUs, in this case,
appropriate protection is needed between the two hard-irq handlers.

> > Currently, no protection is implemented - which
> > causes problems in RX.
> 
> which problems? Could you describe them in detail?

The RX stream position-hooks would get mangled up if two
IRQ handlers access them without any kind of protection.
This corrupts the stream data - causing data loss.

Sujith
