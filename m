Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:55601 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966676AbeEXPug (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 11:50:36 -0400
Received: by mail-it0-f68.google.com with SMTP id 144-v6so2970852iti.5
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 08:50:36 -0700 (PDT)
Date: Thu, 24 May 2018 11:50:34 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Adrian Chadd <adrian.chadd@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: transmit queued frames after waking queues
Message-ID: <20180524155034.xse7cfm5figfktuj@localhost> (sfid-20180524_175148_770654_67F2CDFB)
References: <20180517231512.13085-1-niklas.cassel@linaro.org>
 <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
 <20180521203701.GA7619@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180521203701.GA7619@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2018 at 10:37:01PM +0200, Niklas Cassel wrote:
> On Thu, May 17, 2018 at 03:26:25PM -0700, Adrian Chadd wrote:
> > On Thu, 17 May 2018 at 16:16, Niklas Cassel <niklas.cassel@linaro.org>
> > wrote:
> > 
> > > diff --git a/drivers/net/wireless/ath/ath10k/txrx.c
> > b/drivers/net/wireless/ath/ath10k/txrx.c
> > > index cda164f6e9f6..1d3b2d2c3fee 100644
> > > --- a/drivers/net/wireless/ath/ath10k/txrx.c
> > > +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> > > @@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
> > >                  wake_up(&htt->empty_tx_wq);
> > >          spin_unlock_bh(&htt->tx_lock);
> > 
> > > +       if (htt->num_pending_tx <= 3 && !list_empty(&ar->txqs))
> > > +               ath10k_mac_tx_push_pending(ar);
> > > +
> > 
> > Just sanity checking - what's protecting htt->num_pending_tx? or is it
> > serialised some other way?
[...]
> I can't see that any of the examples applies, but let's add READ_ONCE(),
> to make sure that the compiler doesn't try to optimize this.

Couldn't you just move the num_pending_tx read inside tx_lock which is 2 lines
above?  I think all the other manipulations are protected by tx_lock.

-- 
Bob Copeland %% https://bobcopeland.com/
