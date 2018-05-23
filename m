Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36992 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934720AbeEWWot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 18:44:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id l1-v6so13392880wmb.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 15:44:49 -0700 (PDT)
Date: Thu, 24 May 2018 00:44:45 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: transmit queued frames after waking queues
Message-ID: <20180523224445.GB26565@localhost.localdomain> (sfid-20180524_004525_469625_FD93A580)
References: <20180521204359.23884-1-niklas.cassel@linaro.org>
 <8195be7603a8cd659d25a9c3d898b891@codeaurora.org>
 <20180522211521.GA26123@localhost.localdomain>
 <c131da6e-6479-3a40-fbd3-9c61d6690ba8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c131da6e-6479-3a40-fbd3-9c61d6690ba8@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2018 at 06:25:49PM +0200, Erik Stromdahl wrote:
> 
> 
> On 05/22/2018 11:15 PM, Niklas Cassel wrote:
> 
> <snip>
> > > 
> > > Earlier we observed performance issues in calling push_pending from each
> > > tx completion. IMHO this change may introduce the same problem again.
> > 
> > I prefer functional TX over performance issues,
> > but I agree that it is unfortunate that SDIO doesn't use
> > ath10k_htt_txrx_compl_task().
> > Erik, is there a reason for this?
> The reason is that the SDIO code has been derived mainly from qcacld and ath6kl
> and they don't implement napi.
> 
> ath10k_htt_txrx_compl_task is currently only called from the napi poll function,
> and the sdio bus driver doesn't have such a function.

Ok, thanks for the explanation. Perhaps we can change the SDIO code so that it
uses NAPI in the future.

<snip>

> > Another solution might be to change so that we only call
> > ath10k_mac_tx_push_pending() from ath10k_txrx_tx_unref()
> > if (htt->num_pending_tx == 0). That should decrease the number
> > of calls to ath10k_mac_tx_push_pending(), while still avoiding
> > a "TX deadlock" scenario for SDIO.
> Just out of curiosity, where did the limit of 3 come from?
> If it works with a limit of 0, I think it should be used instead.

It came from mt76_txq_schedule():

if (hwq->swq_queued >= 4 || list_empty(&hwq->swq))
	break;

len = mt76_txq_schedule_list(dev, hwq);

Since this used a break, I simply inverted the logic,
and called ath10k_mac_tx_push_pending() rather than
mt76_txq_schedule_list().

However, I've submitted a V4 now that mimics the behavior
in ath10k_htt_txrx_compl_task() instead, so now I call
ath10k_mac_tx_push_pending() regardless of num_pending_tx.

In most cases, ath10k_mac_tx_push_pending() will not dequeue
any frames, since the ar->txqs list will be empty, so this
shouldn't be so bad after all.

> 
> Another intersting thing that I stumbled upon when looking into the
> code (while writing this email) is the *wake_up(&htt->empty_tx_wq);*
> 
> For some reason I have considered it not to be applicable for HL devices.
> 
> The queue is waited for in the flush op (*ath10k_flush*).
> I am unsure what it is used for, but I don't think it affects the TX
> deadlock scenario.

It seems to be called by mac80211 in certain scenarios, but like you said,
it doesn't help with this problem.


Regards,
Niklas
