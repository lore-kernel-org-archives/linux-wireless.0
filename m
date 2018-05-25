Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33977 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935358AbeEYMuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:50:25 -0400
Received: by mail-io0-f195.google.com with SMTP id p124-v6so6263666iod.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 05:50:24 -0700 (PDT)
Date: Fri, 25 May 2018 08:50:23 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Adrian Chadd <adrian.chadd@gmail.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: transmit queued frames after waking queues
Message-ID: <20180525125023.alc42lkgehc6iodg@localhost> (sfid-20180525_145043_151253_9B156146)
References: <20180517231512.13085-1-niklas.cassel@linaro.org>
 <CAJ-Vmon1ybhWs_8Nv=w62pmhSizDdDeYCgK8_HTTwPZ=EEC46g@mail.gmail.com>
 <20180521203701.GA7619@localhost.localdomain>
 <20180524155034.xse7cfm5figfktuj@localhost>
 <20180525123656.GB8780@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525123656.GB8780@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2018 at 02:36:56PM +0200, Niklas Cassel wrote:
> A spin lock does have the advantage of ordering: memory operations issued
> before the spin_unlock_bh() will be completed before the spin_unlock_bh()
> operation has completed.
> 
> However, ath10k_htt_tx_dec_pending() was called earlier in the same function,
> which decreases htt->num_pending_tx, so that write will be completed before
> our read. That is the only ordering we care about here (if we should call
> ath10k_mac_tx_push_pending() or not).

Sure.  I also understand that reading inside a lock and operating on the
value outside the lock isn't really the definition of synchronization
(doesn't really matter in this case though).

I was just suggesting that the implicit memory barrier in the spin unlock
that we are already paying for would be sufficient here too, and it matches
the semantic of "tx fields under tx_lock."  On the other hand, maybe it's
just me, but I tend to look askance at just-in-case READ_ONCEs sprinkled
about.

-- 
Bob Copeland %% https://bobcopeland.com/
