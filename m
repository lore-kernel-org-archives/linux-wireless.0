Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A46457268E;
	Thu, 10 Sep 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789064735; cv=none; b=ryDejg8kexa/gtLXYS3xhVytKfciVycbqcPMgPE5Q08DWiFiUbHo3Vca52jrJk8Qgr4aNiKN2YqVuB7HIveXGnA+89baIK+L9RrBSa2OWeMp5mQEed+5LUDTNVkUdZDc2kVQPKsdpRgkTMeBLLD4cxiUUQ/kjRaUeVrtFAKa1p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789064735; c=relaxed/simple;
	bh=deY2krLPRGBmZOE9h6F0RqiZK050slPf2jLksF0/6QA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ho3igKxB4qF94ZOl+wBUjGYMDrAOKn3IPLpy3NI1qiWnxThfBOWfqiUgAWLIXYjgbKGdgfw2WTbu7vobrWm0Or4ozPiO5YO3ZO2mx2/huuy5Q6QGPOyKk+LQa6/NqY0K4yO6M6qVeMAXjRmRqB4u2yvKb5ng1gU9COv8tw5I1bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Georgios Karantzas <gck.kara@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Georgios
 Karantzas <gck.kara@gmail.com>
Subject: Re: [PATCH v2] wifi: ath9k_htc: bound TX aggregation to
 MAX_TX_BUF_SIZE
In-Reply-To: <20260909185921.1757-1-gck.kara@gmail.com>
References: <20260831173931.1672-1-gck.kara@gmail.com>
 <20260909185921.1757-1-gck.kara@gmail.com>
Date: Thu, 10 Sep 2026 20:25:19 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874ifxdkvk.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Georgios Karantzas <gck.kara@gmail.com> writes:

> Bound the TX batch by cumulative byte length, not just record count.
>
> Fixes: fb9987d0f748c983 ("ath9k_htc: Support for AR9271 chipset.")
> Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>
> ---
> v2:
> - 72-col wrap + Fixes: tag.

You seem to have dropped the commit message instead of just wrapping it.
Wrap does not mean "truncate", it just means "make sure each line stays
below 72 characters". The explanation in the commit message of v1 was
fine, the lines were just too long :)

> - Accounting kept: deferred len += offset never fires on early break.

Ah, right. Please explain this in the commit message. Also, see below:

> - (!i) guard dropped per review.
>
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 0a3d2190b..533e74565 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -328,11 +328,14 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
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
>  
>  		buf = tx_buf->buf;
> @@ -342,13 +345,8 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
>  		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
>  		buf += 4;
>  		memcpy(buf, nskb->data, nskb->len);
> -		tx_buf->len = nskb->len + 4;
> -
> -		if (i < (tx_skb_cnt - 1))
> -			tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
> -
> -		if (i == (tx_skb_cnt - 1))
> -			tx_buf->len += tx_buf->offset;
> +		tx_buf->len = tx_buf->offset + nskb->len + 4;
> +		tx_buf->offset += (((nskb->len + 3) / 4) + 1) * 4;

While we're fixing this, let's make it readable as well - this could be
(with an #include <linux/math.h>):

		tx_buf->offset += round_up(nskb->len + 4, 4);

-Toke
