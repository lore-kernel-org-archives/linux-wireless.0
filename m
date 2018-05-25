Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36004 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936158AbeEYOVF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 10:21:05 -0400
Received: by mail-wr0-f195.google.com with SMTP id k5-v6so9557458wrn.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 07:21:04 -0700 (PDT)
Date: Fri, 25 May 2018 16:21:01 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Adrian Chadd <adrian.chadd@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: transmit queued frames after waking queues
Message-ID: <20180525142101.GA14422@localhost.localdomain> (sfid-20180525_162441_818572_21F68C68)
References: <20180517231512.13085-1-niklas.cassel@linaro.org>
 <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
 <20180521203701.GA7619@localhost.localdomain>
 <20180524155034.xse7cfm5figfktuj@localhost>
 <20180525123656.GB8780@localhost.localdomain>
 <20180525125023.alc42lkgehc6iodg@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525125023.alc42lkgehc6iodg@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2018 at 08:50:23AM -0400, Bob Copeland wrote:
> On Fri, May 25, 2018 at 02:36:56PM +0200, Niklas Cassel wrote:
> > A spin lock does have the advantage of ordering: memory operations issued
> > before the spin_unlock_bh() will be completed before the spin_unlock_bh()
> > operation has completed.
> > 
> > However, ath10k_htt_tx_dec_pending() was called earlier in the same function,
> > which decreases htt->num_pending_tx, so that write will be completed before
> > our read. That is the only ordering we care about here (if we should call
> > ath10k_mac_tx_push_pending() or not).
> 
> Sure.  I also understand that reading inside a lock and operating on the
> value outside the lock isn't really the definition of synchronization
> (doesn't really matter in this case though).
> 
> I was just suggesting that the implicit memory barrier in the spin unlock
> that we are already paying for would be sufficient here too, and it matches
> the semantic of "tx fields under tx_lock."  On the other hand, maybe it's
> just me, but I tend to look askance at just-in-case READ_ONCEs sprinkled
> about.

I agree, because of the implicit memory barrier from spin_unlock_bh(),
READ_ONCE shouldn't really be needed in this case.

I think that it's a good thing to be critical of all "just-in-case" things,
however, it's not always that obvious if you actually need READ_ONCE or not.

E.g. you might need to use it even when you are holding a spin_lock.

Some people recommend to use it for all concurrent non-read-only shared memory
accesses: https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

Is there a better guideline somewhere..?


Kind regards,
Niklas
