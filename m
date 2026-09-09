Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAAA54A7C2;
	Wed,  9 Sep 2026 11:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954597; cv=none; b=iyUIu63qq2Jf2OI8+UqpXlfukWK6BU0B3x1Z1HE2BnRpZcoVLm2uKhs+ECWNQfJeFIWEELB9BM5YqgcTu29/+3gCTJ9yJ/O5U+6mlAzLeze6O6mTGT5f+Hcy0qTdDElwIwX1K67VGLJJuTL6cHpp5BA/8jdE1Ch5n//yvYBUlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954597; c=relaxed/simple;
	bh=sMfm7Xw3Exon5OBVIo0uzlO7Eq0nmhKo6R8EuGcUcnU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kp5L79KZwewaCTkraeS0T/5WRKH+j5GT+vMJJxI8CVw7sqNri962IeUbk9vgQSIf1nZdsqVJJXsBFys2nMDmNfpoIFxSVMvPR5kYAPCSXxvP3y9UBZjuYNnvyc063v5PNCTh2+Cm5YZoA8uKginQ5Sp7xT1Fy9BRW9nQk2EBKXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Georgios Karantzas <gck.kara@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Georgios
 Karantzas <gck.kara@gmail.com>
Subject: Re: [PATCH] wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE
In-Reply-To: <20260831173931.1672-1-gck.kara@gmail.com>
References: <20260831173931.1672-1-gck.kara@gmail.com>
Date: Wed, 09 Sep 2026 13:49:50 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875x0efxup.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Georgios Karantzas <gck.kara@gmail.com> writes:

> __hif_usb_tx() dequeues up to MAX_TX_AGGR_NUM (20) frames into a single tx_buf of MAX_TX_BUF_SIZE (32768) bytes, limiting the batch by record count but never by cumulative byte length.
>
> With large frames (MTU 2304), 20 aggregated frames of 2292 bytes each exceed the allocation (20 * 2296 = 45920 bytes), so the memcpy() in the loop writes up to 13152 bytes past tx_buf->buf before usb_submit_urb().
>
> Peek the queue head and stop before copying any record that would cross MAX_TX_BUF_SIZE, then dispatch the current batch. Leftover skbs remain queued and are drained on the next URB completion.
>
> Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>

Please wrap the commit message at 72 characters.

> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 29 +++++++++++++-----------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 0a3d2190b..3e9d0c59b 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -328,32 +328,35 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
>  	tx_skb_cnt = min_t(u16, hif_dev->tx.tx_skb_cnt, MAX_TX_AGGR_NUM);
>  
>  	for (i = 0; i < tx_skb_cnt; i++) {
> -		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
> +		nskb = skb_peek(&hif_dev->tx.tx_skb_queue);
> +		if (!nskb)
> +			break;
>  
> -		/* Should never be NULL */
> -		BUG_ON(!nskb);
> +		if (tx_buf->offset + nskb->len + 4 > MAX_TX_BUF_SIZE)
> +			break;
>  
> +		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
>  		hif_dev->tx.tx_skb_cnt--;

This bit is fine...

> -		buf = tx_buf->buf;
> -		buf += tx_buf->offset;
> +		buf = tx_buf->buf + tx_buf->offset;
>  		hdr = (__le16 *)buf;
>  		*hdr++ = cpu_to_le16(nskb->len);
>  		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
> -		buf += 4;
> -		memcpy(buf, nskb->data, nskb->len);
> -		tx_buf->len = nskb->len + 4;
> -
> -		if (i < (tx_skb_cnt - 1))
> -			tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
> +		memcpy(buf + 4, nskb->data, nskb->len);
>  
> -		if (i == (tx_skb_cnt - 1))
> -			tx_buf->len += tx_buf->offset;
> +		tx_buf->len = tx_buf->offset + nskb->len + 4;
> +		tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;

But this bit seems unrelated (and wrong?); please drop.

>  		__skb_queue_tail(&tx_buf->skb_queue, nskb);
>  		TX_STAT_INC(hif_dev, skb_queued);
>  	}
>  
> +	if (!i) {
> +		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
> +		hif_dev->tx.tx_buf_cnt++;
> +		return 0;
> +	}

It's not possible for a single packet to overflow the buffer size, so
we'll never hit this. So let's not add a pointless check.

-Toke
