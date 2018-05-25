Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41914 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933107AbeEYMhA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:37:00 -0400
Received: by mail-wr0-f193.google.com with SMTP id u12-v6so8954205wrn.8
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 05:36:59 -0700 (PDT)
Date: Fri, 25 May 2018 14:36:56 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Adrian Chadd <adrian.chadd@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: transmit queued frames after waking queues
Message-ID: <20180525123656.GB8780@localhost.localdomain> (sfid-20180525_143717_189301_8E7B259B)
References: <20180517231512.13085-1-niklas.cassel@linaro.org>
 <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
 <20180521203701.GA7619@localhost.localdomain>
 <20180524155034.xse7cfm5figfktuj@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180524155034.xse7cfm5figfktuj@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2018 at 11:50:34AM -0400, Bob Copeland wrote:
> On Mon, May 21, 2018 at 10:37:01PM +0200, Niklas Cassel wrote:
> > On Thu, May 17, 2018 at 03:26:25PM -0700, Adrian Chadd wrote:
> > > On Thu, 17 May 2018 at 16:16, Niklas Cassel <niklas.cassel@linaro.org>
> > > wrote:
> > > 
> > > > diff --git a/drivers/net/wireless/ath/ath10k/txrx.c
> > > b/drivers/net/wireless/ath/ath10k/txrx.c
> > > > index cda164f6e9f6..1d3b2d2c3fee 100644
> > > > --- a/drivers/net/wireless/ath/ath10k/txrx.c
> > > > +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> > > > @@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
> > > >                  wake_up(&htt->empty_tx_wq);
> > > >          spin_unlock_bh(&htt->tx_lock);
> > > 
> > > > +       if (htt->num_pending_tx <= 3 && !list_empty(&ar->txqs))
> > > > +               ath10k_mac_tx_push_pending(ar);
> > > > +
> > > 
> > > Just sanity checking - what's protecting htt->num_pending_tx? or is it
> > > serialised some other way?
> [...]
> > I can't see that any of the examples applies, but let's add READ_ONCE(),
> > to make sure that the compiler doesn't try to optimize this.
> 
> Couldn't you just move the num_pending_tx read inside tx_lock which is 2 lines
> above?  I think all the other manipulations are protected by tx_lock.

Hello Bob,

There is both a V2 and V3 of this patchset, V3 moves this to a sdio.c and
calls ath10k_mac_tx_push_pending() unconditionally.


But to answer your question,
it shouldn't matter if the read is done while holding the lock or not.

Sure, the compiler could do things so that the code path is always or never
executed, but that is why I added READ_ONCE() in V2.

A spin lock does have the advantage of ordering: memory operations issued
before the spin_unlock_bh() will be completed before the spin_unlock_bh()
operation has completed.

However, ath10k_htt_tx_dec_pending() was called earlier in the same function,
which decreases htt->num_pending_tx, so that write will be completed before
our read. That is the only ordering we care about here (if we should call
ath10k_mac_tx_push_pending() or not).


Kind regards,
Niklas
