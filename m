Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37373 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752981AbeEVVPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:15:25 -0400
Received: by mail-wm0-f66.google.com with SMTP id l1-v6so3556646wmb.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 14:15:24 -0700 (PDT)
Date: Tue, 22 May 2018 23:15:21 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org, erik.stromdahl@gmail.com
Subject: Re: [PATCH v2] ath10k: transmit queued frames after waking queues
Message-ID: <20180522211521.GA26123@localhost.localdomain> (sfid-20180522_231545_767958_A3727483)
References: <20180521204359.23884-1-niklas.cassel@linaro.org>
 <8195be7603a8cd659d25a9c3d898b891@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <8195be7603a8cd659d25a9c3d898b891@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2018 at 04:11:38PM -0700, Rajkumar Manoharan wrote:
> On 2018-05-21 13:43, Niklas Cassel wrote:
> > The following problem was observed when running iperf:
> [...]
> > 
> > In order to avoid trying to flush the queue every time we free a frame,
> > only do this when there are 3 or less frames pending, and while we
> > actually have frames in the queue. This logic was copied from
> > mt76_txq_schedule (mt76), one of few other drivers that are actually
> > using wake_tx_queue.
> > 
> > Suggested-by: Toke Høiland-Jørgensen <toke@toke.dk>
> > Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> > ---
> > Changes since V1: use READ_ONCE() to disallow the compiler
> > optimizing things in undesirable ways.
> > 
> >  drivers/net/wireless/ath/ath10k/txrx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/ath/ath10k/txrx.c
> > b/drivers/net/wireless/ath/ath10k/txrx.c
> > index cda164f6e9f6..264cf0bd5c00 100644
> > --- a/drivers/net/wireless/ath/ath10k/txrx.c
> > +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> > @@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
> >  		wake_up(&htt->empty_tx_wq);
> >  	spin_unlock_bh(&htt->tx_lock);
> > 
> > +	if (READ_ONCE(htt->num_pending_tx) <= 3 && !list_empty(&ar->txqs))
> > +		ath10k_mac_tx_push_pending(ar);
> > +
> Niklas,

Hello Rajkumar

> 
> Sorry for the late response. ath10k_mac_tx_push_pending is already called
> at the end of NAPI handler. Isn't that enough to process pending frames?

This is true for e.g. ATH10K_BUS_PCI and ATH10K_BUS_SNOC,
but not for e.g. ATH10K_BUS_SDIO and ATH10K_BUS_USB.

While there is some SDIO code merged in Kalle's tree already,
this problem was found when merging
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/?h=ath10k-pending-sdio-usb
with Kalle's ath-next branch.

> 
> Earlier we observed performance issues in calling push_pending from each
> tx completion. IMHO this change may introduce the same problem again.

I prefer functional TX over performance issues,
but I agree that it is unfortunate that SDIO doesn't use
ath10k_htt_txrx_compl_task().
Erik, is there a reason for this?

Perhaps it would be possible to call ath10k_mac_tx_push_pending()
from the equivalent to ath10k_htt_txrx_compl_task(),
but from SDIO's point of view.

Another solution might be to change so that we only call
ath10k_mac_tx_push_pending() from ath10k_txrx_tx_unref()
if (htt->num_pending_tx == 0). That should decrease the number
of calls to ath10k_mac_tx_push_pending(), while still avoiding
a "TX deadlock" scenario for SDIO.


Regards,
Niklas
