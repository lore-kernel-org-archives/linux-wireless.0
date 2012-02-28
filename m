Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18564 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2B1E0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 23:26:50 -0500
Date: Tue, 28 Feb 2012 09:56:35 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix memory leak of rx packets in endpoint 0
Message-ID: <20120228042632.GA2892@vasanth-laptop> (sfid-20120228_052654_195738_12E244A0)
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com>
 <4F4BBBE5.4060101@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F4BBBE5.4060101@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 07:22:45PM +0200, Kalle Valo wrote:
> On 02/10/2012 05:10 PM, Vasanthakumar Thiagarajan wrote:
> > htc_packet and htc_packet->buf_start are separately allocated
> > for endpoint 0. This is different for other endpoints where
> > packets are allocated as skb where htc_packet is skb->head
> > and they are freed properly. Free htc_packet and htc_packet->buf_start
> > separatly for endpoint 0.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath6kl/htc.c |   16 +++++++++++++++-
> >  1 files changed, 15 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> > index c703ef9..e50cc8e 100644
> > --- a/drivers/net/wireless/ath/ath6kl/htc.c
> > +++ b/drivers/net/wireless/ath/ath6kl/htc.c
> > @@ -2372,7 +2372,21 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
> >  				   "htc rx flush pkt 0x%p  len %d  ep %d\n",
> >  				   packet, packet->buf_len,
> >  				   packet->endpoint);
> > -			dev_kfree_skb(packet->pkt_cntxt);
> > +			/*
> > +			 * packets in rx_bufq of endpoint 0 have originally
> > +			 * been queued from target->free_ctrl_rxbuf where
> > +			 * packet and packet->buf_start are allocated
> > +			 * separately using kmalloc(). For other endpoint
> > +			 * rx_bufq, it is allocated as skb where packet is
> > +			 * skb->head. Take care of this difference while freeing
> > +			 * the memory.
> > +			 */
> > +			if (packet->endpoint == ENDPOINT_0) {
> > +				kfree(packet->buf_start);
> > +				kfree(packet);
> > +			} else {
> > +				dev_kfree_skb(packet->pkt_cntxt);
> > +			}
> 
> I didn't look at the code, but my question would it be possible to use
> skbs also with endpoint 0? That would be more consistent aproach than
> testing for a particular endpoint.

Yeah, using skbs for control buffer is the right thing, but for the time being
we can have this fix in.

> 
> And in the future we should get rid of that buf_start hack and use skbs
> directly anyway.

Agree.

Vasanth
