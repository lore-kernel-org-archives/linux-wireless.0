Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:38336 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeEUUhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 16:37:05 -0400
Received: by mail-lf0-f66.google.com with SMTP id z142-v6so25802287lff.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 13:37:05 -0700 (PDT)
Date: Mon, 21 May 2018 22:37:01 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Adrian Chadd <adrian.chadd@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: transmit queued frames after waking queues
Message-ID: <20180521203701.GA7619@localhost.localdomain> (sfid-20180521_223728_285923_023C6B64)
References: <20180517231512.13085-1-niklas.cassel@linaro.org>
 <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 17, 2018 at 03:26:25PM -0700, Adrian Chadd wrote:
> On Thu, 17 May 2018 at 16:16, Niklas Cassel <niklas.cassel@linaro.org>
> wrote:
> 
> > diff --git a/drivers/net/wireless/ath/ath10k/txrx.c
> b/drivers/net/wireless/ath/ath10k/txrx.c
> > index cda164f6e9f6..1d3b2d2c3fee 100644
> > --- a/drivers/net/wireless/ath/ath10k/txrx.c
> > +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> > @@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
> >                  wake_up(&htt->empty_tx_wq);
> >          spin_unlock_bh(&htt->tx_lock);
> 
> > +       if (htt->num_pending_tx <= 3 && !list_empty(&ar->txqs))
> > +               ath10k_mac_tx_push_pending(ar);
> > +
> 
> Just sanity checking - what's protecting htt->num_pending_tx? or is it
> serialised some other way?

Hello Adrian,

I did not take the htt->tx_lock lock for this since it should not be
needed.

There are however some compiler optimizations that you have to look out
for:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/memory-barriers.txt?h=v4.17-rc6#n1547

I can't see that any of the examples applies, but let's add READ_ONCE(),
to make sure that the compiler doesn't try to optimize this.

Will send a V2 for this.

Regards,
Niklas

> 
> >          dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
> 
> >          ath10k_report_offchan_tx(htt->ar, msdu);
> > --
> > 2.17.0
