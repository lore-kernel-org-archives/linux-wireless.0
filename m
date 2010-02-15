Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:14593 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0BOXsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 18:48:41 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1341194eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2010 15:48:40 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] rt2800pci: actually handle tx interrupts
Date: Tue, 16 Feb 2010 00:48:38 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@kpnplanet.nl>
References: <20100215185933.GA12592@localhost.localdomain>
In-Reply-To: <20100215185933.GA12592@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002160048.38387.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> 1) We don't handle _any_ of the DMA_DONE interrupts, so we don't actually remove
> any of the entries when the card tells us we are done.  This is easy enough to
> fix.

Yes, but your fix is removing the handler INT_SOURCE_CSR_TX_FIFO_STATUS
which probably should still be handled anyway.

> 2) Turns out we are depending on the TX_STA_FIFO register on the card to give us
> per-tx statistics, but it appears to only be a sort of global statistic thing
> that doesn't even work most of the time.  I seperated out all of the TX_STA_FIFO
> reading stuff and either TX_STA_FIFO_VALID would be 0,
> TX_STA_FIFO_TX_ACK_REQUIRED would be 0, or TX_STA_FIFO_WCID would be 254, which
> is way higher than the queue limit.  So basically it gives us crap statistics.

I am not seeing this check in the code, only the complete removal of the TX_STA_FIFO handling.

> Looking through RaLinks driver it doesn't seem there is a way to get per-tx
> statistics, so you can't really tell if the tx failed or not.  So I've fixed
> rt2800pci_txdone to just say the tx succeeded and call rt2x00lib_txdone and be
> done with it.  I'm sure this is horribly wrong, but looking at the RaLink driver
> doesn't seem to indicate anyway to fail/retry a particular packet, so I'm not
> sure if there is anything else that can be done.

Returning success is bogus, it must return status unknown just like the USB drivers do.
It is up to rt2x00lib to determine if that should resolve to success or not (at the moment
it will resolve to success).

> This patch makes it so this driver works for me finally (minus a couple of
> quirks).  Thanks,

Ivo
