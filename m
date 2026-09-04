Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC54646AA97;
	Fri,  4 Sep 2026 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523193; cv=none; b=dB5++vyb2ZBrjMMJkmOUON7/3A//rcWmuX2pf8Fo4AAJ7o7QMWWngt50cU8OIOm4tpgbnsPnC0CHbw2afrJg2KGAyaI2JYjqFWxAjYJFXp2EhlUShAIIex9GMOjulZvtpvsx+fVPB1Z6M29z8kYSHmbk+BjaB8CkQ1sTcmKKWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523193; c=relaxed/simple;
	bh=Xj8TA1cKS7tAXlzA1b88MAJM5sgtnSyLe1xDNVRbAAI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=l20E+hJmvYFq2tmelGt+ZOxvQtFyh28kYf8xn5+c9OLw2QMdfQ+YhhkRCWkabLxkMYzFMDnICctYalDXn/zKx8Av1GQTuIG5k5OBgh7ax/ygkb17RiXsZ+v8VLskWrLDgAVHI4fxwZGkK/IPIWR2hudo0fZDQ2pmsLVdFc/Q8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: validate RX stream lengths before copying
In-Reply-To: <20260701053823.49801-1-pengpeng@iscas.ac.cn>
References: <20260701053823.49801-1-pengpeng@iscas.ac.cn>
Date: Fri, 04 Sep 2026 13:59:49 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87qzj9tefe.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pengpeng Hou <pengpeng@iscas.ac.cn> writes:

> ath9k_hif_usb_rx_stream() reads RX stream headers and copies payload
> bytes from the current skb into newly allocated skbs. It also completes
> packets that span two URBs by copying the remaining bytes from the next
> skb into hif_dev->remain_skb.
>
> The parser checked the stream tag and an upper bound on pkt_len, but it
> did not first prove that the fixed header, the non-fragmented payload,
> or the bytes needed to complete a fragmented packet are present in the
> current skb. Reject malformed RX stream data before reading or copying
> beyond the received buffer.
>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

