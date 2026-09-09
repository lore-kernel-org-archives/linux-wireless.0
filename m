Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16D65328A3;
	Wed,  9 Sep 2026 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950619; cv=none; b=tD1YaWLrKScPaFxIXu2v+gIl3h4tIK0/i2XTABT+5IrRA87xHsJyH4eWWuRzxETlezaTWfkbXp94GGhvOba73HbXbkzLUb9eXxT/dLlnZomMK85WqdBiKopo91CsRANNVfMDbnSjJ93E9e9OA2BhaOLxt4JxOwpyJrlk+3vq/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950619; c=relaxed/simple;
	bh=f9hAYBsSLbiDfuWcu+L5vas1fg8Pu3vIqbkWV8+w2u8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KbFZxsuKdpZk7p7VvAh2Q2/N28zOavdNhdUHEGPBp0QmAtXJUC48b5yYIva05YeEyEDpRNH7yUj7KeN8Kykyt2ZNhO5FKjG/UOCRQWLwlp57QiNinRW7E3PZGNa0ZOEypKD2ZM7fuLC2UsGo1oRW325vdEMLTcGP5BUFbv7OuPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: validate RX stream lengths before copying
In-Reply-To: <6cda5b2b-34b0-430c-bff3-635df1080312@oss.qualcomm.com>
References: <20260701053823.49801-1-pengpeng@iscas.ac.cn>
 <87qzj9tefe.fsf@toke.dk>
 <6cda5b2b-34b0-430c-bff3-635df1080312@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 12:43:25 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87jyoug0xe.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jeff Johnson <jeff.johnson@oss.qualcomm.com> writes:

> On 9/4/2026 4:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Pengpeng Hou <pengpeng@iscas.ac.cn> writes:
>>=20
>>> ath9k_hif_usb_rx_stream() reads RX stream headers and copies payload
>>> bytes from the current skb into newly allocated skbs. It also completes
>>> packets that span two URBs by copying the remaining bytes from the next
>>> skb into hif_dev->remain_skb.
>>>
>>> The parser checked the stream tag and an upper bound on pkt_len, but it
>>> did not first prove that the fixed header, the non-fragmented payload,
>>> or the bytes needed to complete a fragmented packet are present in the
>>> current skb. Reject malformed RX stream data before reading or copying
>>> beyond the received buffer.
>>>
>>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
>>=20
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> Can you check the v2: 20260814075716.18804-1-pengpeng@iscas.ac.cn

Meh, the extra zeroing in v2 doesn't seem to serve any purpose, so let's
just go with this one...

-Toke
