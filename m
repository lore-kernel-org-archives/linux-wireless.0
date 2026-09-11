Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5930635200F;
	Fri, 11 Sep 2026 10:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122035; cv=none; b=YrtiTTBjXT/SyQlpP3UsMwkCqMMnFJd+VolmOd8cVqSbSH7s4UIyoa7Ofzuu8WkBYpL1NjJqkbooSMADSIFxcY3WXCHFKQzxNGuaf8TOUf8FjD685KuEW+wQA9c1uB7ClyRowEzIPj6CbhmCTwnmEUhNzU5SFZ8E9zQf4WmAd2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122035; c=relaxed/simple;
	bh=76DmuMS3zR+DhDEe8uMFW6+C/YqopLz6Uvq9dlR2010=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qwpB5o9U0FvdUppGEHHU4/vejRMmfUre+o0wm0iAgIiV6rK5bWIhLViALPdYXv2jPg3GuuKGEdId3nGqlgLVaqmAy3AVFWxjO9emA3+IELz7vBG9dVn0f+oWE/y8olLRFdr5tUfT6eP/qTE/m7/B07GUFPLfPRyNTOyC7Co0VB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Georgios Karantzas <gck.kara@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Georgios
 Karantzas <gck.kara@gmail.com>
Subject: Re: [PATCH v3] wifi: ath9k_htc: bound TX aggregation to
 MAX_TX_BUF_SIZE
In-Reply-To: <20260911001143.4507-1-gck.kara@gmail.com>
References: <20260831173931.1672-1-gck.kara@gmail.com>
 <20260911001143.4507-1-gck.kara@gmail.com>
Date: Fri, 11 Sep 2026 12:20:28 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y0d8ccnn.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Georgios Karantzas <gck.kara@gmail.com> writes:

> __hif_usb_tx() dequeues up to MAX_TX_AGGR_NUM (20) frames into a
> single tx_buf of MAX_TX_BUF_SIZE (32768) bytes, limiting the batch
> by record count but never by cumulative byte length.
>
> With large frames (MTU 2304), 20 aggregated frames of 2292 bytes
> each exceed the allocation (20 * 2296 =3D 45920 bytes), so the
> memcpy() in the loop writes up to 13152 bytes past tx_buf->buf
> before usb_submit_urb().
>
> Peek the queue head and stop before copying any record that would
> cross MAX_TX_BUF_SIZE, then dispatch the current batch. Leftover
> skbs remain queued and are drained on the next URB completion.
>
> The byte bound changes the loop's exit semantics: it can now exit
> before i =3D=3D tx_skb_cnt - 1. Stock only finalized tx_buf->len on
> that last index (len +=3D offset), so an early break would submit a
> URB holding only the last record's length while every dequeued skb
> is freed on completion, silently dropping frames. Make tx_buf->len
> a running total and advance tx_buf->offset per record instead; the
> stride round_up(nskb->len + 4, 4) is identical to the stock stride
> when the loop runs to completion.
>
> Tested on hardware with an MTU 2304 flood: the loop stops at
> record 15 (len =3D 32144, offset =3D 32144, within 32768), no
> oversized URB is submitted, and MTU 1500 pings pass 20/20.
>
> Fixes: fb9987d0f748c983 ("ath9k_htc: Support for AR9271 chipset.")
> Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>

Looks good now, thanks!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
