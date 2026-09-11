Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7AF40E8D6;
	Fri, 11 Sep 2026 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125057; cv=none; b=DlBhMcm5xsoT2TtyLm//b/o/8OUQopxsXkrY55If/k729T3RBLn4iEnhIqqhjNt5cp1ljD2knalc6L0+EyXj8KIrhel66mcAysF+jP3F8k+c3n2TSCiKwvuc+E+8f8b1HfGaxUNjHaCkREMYKx4VIeoz9oRpXNlCN86WiDTzV/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125057; c=relaxed/simple;
	bh=ilomzA4JlJqjeM+QLYCB67+k/lisGZKTdQVrWgC7lEM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NrqnLXgvT7TYwN/8hbu1j8dPsKw7eDr4IsWEQd+jPHqulfum/YQAP7vQUODoWI1VR6LgGkw/v14pb61Ea5f5PYvIzfMWm8WOEriWLypYrfMb4VAPcjRw2St3iJ7lghQSPciRx2I3n8gYT1fIBJLVwdpS9aqbEvdcmc2bV2Ale3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: unmap DMA and free skb for stale
 TX buffers on queue drain
In-Reply-To: <20260904212534.86403-1-rosenp@gmail.com>
References: <20260904212534.86403-1-rosenp@gmail.com>
Date: Fri, 11 Sep 2026 13:10:46 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87jyoscabt.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> When draining a TX queue (e.g. on device removal or reset), stale
> ath_buf descriptors were returned directly to the free pool via
> ath_tx_return_buffer without unmapping their DMA buffers or freeing
> their associated skbs. This leaks both DMA API resources and socket
> buffer memory.
>
> Unmap the DMA buffer and free the skb before returning the buffer
> to the pool.
>
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 89d8b3178784..89930eaf1fd3 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1884,8 +1884,17 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
>  		bf = list_first_entry(list, struct ath_buf, list);
>  
>  		if (bf->bf_state.stale) {
> -			list_del(&bf->list);
> +			struct sk_buff *skb = bf->bf_mpdu;
>  
> +			list_del(&bf->list);
> +			if (bf->bf_buf_addr) {
> +				dma_unmap_single(sc->dev, bf->bf_buf_addr,
> +						 skb ? skb->len : 0,
> +						 DMA_TO_DEVICE);

A zero-length unmap? That seems completely non-sensical. Is there even a
bug here? AFAICT, the only place where a buf is set as stale, the
aggregate subsequently goes through ath_tx_complete_buf(), which does
the unmapping.

Did you test this? Unless you can demonstrate a real bug here, I'm just
going to assume this is all LLM garbage output.

-Toke
