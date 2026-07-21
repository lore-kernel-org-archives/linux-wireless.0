Received: from ixit.cz (ixit.cz [185.100.197.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888E3BC68A;
	Tue, 21 Jul 2026 10:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.100.197.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630375; cv=none; b=Wh039y78D7iNE9fg6+L4I6LnDPNlVCOLuyzvUNjwR30uL3iILEonSgmLdy6caJYWdLWVHrxYQqprMdHnJwUuI2lUVx53vON7dVcsTRb/BP1jDtQwWhIcrPvl+Bq2fmlyKYM7BZFc14QgWur7Z7jF79q1gbUelE/k9tkGtZDAEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630375; c=relaxed/simple;
	bh=/hNqK7YRC1RSEZdjFS4a5vpTWW0bDD7sQRW+Z8zv3h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mt0ijDiKpdhDKs3SgHCb+GTVKGf5mJ4xJLYvyw3GgG5jbz87JagkcrXr5kF1hc1ARemWNMF39b+SPqM33Rm7crSJXzezuBjNq573jg6OSVp0hbZrWhUtP8bVE9GjEeXev0ThcjLk4uinK9Zsw8/8iJ3tX1+8o11G8Fwd1EkDpPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixit.cz; spf=pass smtp.mailfrom=ixit.cz; dkim=pass (1024-bit key) header.d=ixit.cz header.i=@ixit.cz header.b=DX7JhZaz; arc=none smtp.client-ip=185.100.197.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixit.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ixit.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ixit.cz header.i=@ixit.cz header.b="DX7JhZaz"
Received: from [172.16.124.192] (ip-78-44-13-22.bb.vodafone.cz [78.44.13.22])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ixit.cz (Postfix) with ESMTPSA id 5A66A53401EE;
	Tue, 21 Jul 2026 12:39:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
	t=1784630368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6R52rk6QYa9/i37aNodQp6F1XVJRiGVvf+hFyxj9CVw=;
	b=DX7JhZaz1SRw4Ruhbd4cbyRW+VU82m45YResZHI4RJZg3fpJX+8oxmaaU8ih5zXQT7kE/r
	lkddF5IajhUG+sCiwIHtUmFsr+ofYQlCJKXVH0vAjQI/gdzJ2n0LZLsvrJzCz9RDzNu+BP
	cR2TBDDhubsx0iSi9rtgFe1Ap4ekqCs=
Message-ID: <16c23505-cd3d-42b7-aec2-52f9b7492028@ixit.cz>
Date: Tue, 21 Jul 2026 12:39:27 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] wifi: ath10k: make in-order rx amsdu buffers
 persistent
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@qca.qualcomm.com>,
 Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 phone-devel@vger.kernel.org, Richard Acayan <mailingradian@gmail.com>
References: <20260719-ath10k-a-msdu-v2-1-f479bb9d1217@ixit.cz>
Content-Language: en-US
From: David Heidelberg <david@ixit.cz>
Autocrypt: addr=david@ixit.cz; keydata=
 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
In-Reply-To: <20260719-ath10k-a-msdu-v2-1-f479bb9d1217@ixit.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sharing Sashiko review, at the first part of it was something I wondered before 
resending the v2.

I'm not sure what exactly is achieved with the msdu & rxd assignment, as it 
seems to be really immediately discarded.

Please excuse my lack of knowledge in the wireless field, it's just patch which 
we carry for long time and it seems helps others projects using WCN3990 too

 > - 0016: WCN3990 splits A-MSDUs across multiple HTT in-order
 >   indications; mainline dropped them ("failed to extract amsdu: -11",
 >   rx_confused), collapsing TCP under load (49 kB/s). Persist the
 >   in-order MSDU list in driver state.
https://github.com/commaai/vamOS/commit/12d80d09e61188895e90d9e4245d513ad4d07f25

Thanks
David

--- Patch [1]: [PATCH RFC v2] wifi: ath10k: make in-order rx amsdu buffers 
persistent ---
commit 10e41b4de22d818aaaa807183134d42a4da09825
Author: Richard Acayan <mailingradian@gmail.com>

wifi: ath10k: make in-order rx amsdu buffers persistent

This commit moves the list tracking unprocessed MSDUs to the driver state,
allowing it to handle MPDUs that are split among multiple in-order
indications.

Link: 
https://lore.kernel.org/linux-wireless/20260210021249.12132-2-mailingradian@gmail.com/

 > diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c 
b/drivers/net/wireless/ath/ath10k/htt_rx.c
 > index ab2d373b4750d..732bd3a2f9992 100644
 > --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
 > +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c

[ ... ]

 > @@ -3161,6 +3165,10 @@ static int ath10k_htt_rx_extract_amsdu(struct 
ath10k_hw_params *hw,
 >  	if (WARN_ON(!skb_queue_empty(amsdu)))
 >  		return -EINVAL;
 >
 > +	msdu = skb_peek(list);
 > +	rxd = HTT_RX_BUF_TO_RX_DESC(hw,
 > +				    (void *)msdu->data - hw->rx_desc_ops->rx_desc_size);
 > +

This isn't a bug, but are these assignments to msdu and rxd unused?

They appear to be unconditionally overwritten in the while loop condition and
the first statement of the loop body without ever being read.

 >  	while ((msdu = __skb_dequeue(list))) {
 >  		__skb_queue_tail(amsdu, msdu);

[ ... ]

 > @@ -3339,12 +3364,15 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k 
*ar, struct sk_buff *skb)
 >  			ath10k_htt_rx_h_enqueue(ar, &amsdu, status);
 >  			break;
 >  		case -EAGAIN:
 > -			fallthrough;
 > +			htt->rx_in_ord_split_tid = tid;
 > +			htt->rx_in_ord_split_peer_id = peer_id;
 > +
 > +			return -EIO;

Will returning -EIO here prematurely abort the NAPI polling loop?

When a split AMSDU is received from the hardware and
ath10k_htt_rx_extract_amsdu() returns -EAGAIN, this -EIO return value is
propagated up to ath10k_htt_txrx_compl_task(), which interprets it as a
signal to abort the rx_in_ord_compl_q loop and reschedule NAPI.

This seems to leave any subsequent queued packets, potentially including the
remainder of the split AMSDU, unprocessed until the next NAPI poll.

 >  		default:
 >  			/* Should not happen. */
 >  			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
