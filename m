Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16035 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752240Ab0DHENE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:13:04 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0270069983
	for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2010 13:13:03 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 3/4] ath5k: fix race condition in tx desc processing
Date: Thu, 8 Apr 2010 13:15:36 +0900
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1270698959-7844-1-git-send-email-me@bobcopeland.com> <1270698959-7844-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1270698959-7844-4-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201004081315.36390.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010 12:55:58 Bob Copeland wrote:
> As pointed out by Benoit Papillault, there is a potential
> race condition between the host and the hardware in reading
> the next link in the transmit descriptor list:
> 
> cpu0              hw
>                   tx for buf completed
>                   raise tx_ok interrupt
> process buf
> buf->ds_link = 0
>                   read buf->ds_link
> 
> This change checks txdp before processing a descriptor
> (if there are any subsequent descriptors) to see if
> hardware moved on.  We'll then process this descriptor on
> the next tasklet.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index 1e10439..f90c679 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2080,6 +2080,17 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct
> ath5k_txq *txq) list_for_each_entry_safe(bf, bf0, &txq->q, list) {
>  		ds = bf->desc;
> 
> +		/*
> +		 * It's possible that the hardware can say the buffer is
> +		 * completed when it hasn't yet loaded the ds_link from
> +		 * host memory and moved on.  If there are more TX
> +		 * descriptors in the queue, wait for TXDP to change
> +		 * before processing this one.
> +		 */
> +		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) == bf->daddr &&
> +		    !list_is_last(&bf->list, &txq->q))
> +			break;
> +
>  		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
>  		if (unlikely(ret == -EINPROGRESS))
>  			break;

for whatever it's worth :-)

Acked-by: Bruno Randolf <br1@einfach.org>
