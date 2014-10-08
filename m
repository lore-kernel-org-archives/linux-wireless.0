Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63316 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaJHDLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 23:11:44 -0400
Date: Wed, 8 Oct 2014 08:43:23 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add tracing for frame transmission
Message-ID: <20141008031321.GB3116@qca.qualcomm.com> (sfid-20141008_051147_324895_8592FD7E)
References: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87d2a3j1ja.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87d2a3j1ja.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2014 at 07:19:05PM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Add tracing support to forward management and data frames to
> > user space for packet inspection.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> [...]
> 
> > --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> > +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> > @@ -291,6 +291,9 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
> >  	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
> >  	htt->rx_ring.fill_cnt--;
> >  
> > +	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
> > +				     skb_tailroom(msdu));
> 
> Why add skb_tailroom() to the length? I think that deserves a comment.
>
It is used for rx crypto length. skb_tailroom is used in most of the
places even while dumping rx pkt by ath10k_dbg_dump.

-Rajkumar
