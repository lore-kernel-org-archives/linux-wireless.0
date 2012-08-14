Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11653 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2HNEw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 00:52:57 -0400
Date: Tue, 14 Aug 2012 10:23:03 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix potential memory leak in
 ath6kl_tx_complete()
Message-ID: <20120814045302.GA4335@vasanth-laptop> (sfid-20120814_065300_901108_CC92C3C2)
References: <1344865738-2416-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1344865738-2416-2-git-send-email-vthiagar@qca.qualcomm.com>
 <502915C5.30503@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <502915C5.30503@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2012 at 05:57:09PM +0300, Kalle Valo wrote:
> On 08/13/2012 04:48 PM, Vasanthakumar Thiagarajan wrote:
> > We bail out from ath6kl_tx_complete() if any of the sanity
> > checks on skb and ath6kl_cookie fails. By doing this we
> > potentially leak few remaining buffers in packet_queue.
> > Make sure to proceed processing the remaining buffers
> > as well. This issue is found during code review.
> > 
> > Reported-by: Wang yufeng <yufengw@qca.qualcomm.com>
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath6kl/txrx.c |   25 ++++++++++++++-----------
> >  1 files changed, 14 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
> > index aab8251..4b26ba0 100644
> > --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> > +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> > @@ -698,21 +698,29 @@ void ath6kl_tx_complete(struct htc_target *target,
> >  		list_del(&packet->list);
> >  
> >  		ath6kl_cookie = (struct ath6kl_cookie *)packet->pkt_cntxt;
> > -		if (!ath6kl_cookie)
> > -			goto fatal;
> > +		if (!ath6kl_cookie) {
> > +			WARN_ON(1);
> > +			continue;
> > +		}
> 
> Please use WARN_ON_ONCE() to avoid excess log messages (as this is in
> data path) and put the WARN_ON() inside if:
> 
> if (WARN_ON_ONCE(!ath6kl_cookie))
> 	continue;

Sure, thanks!.

> 
> > +		if (!skb || !skb->data) {
> > +			WARN_ON(1);
> > +			dev_kfree_skb(skb);
> > +			ath6kl_free_cookie(ar, ath6kl_cookie);
> > +			continue;
> > +		}
> 
> Same here.

Sure.

Vasanth
