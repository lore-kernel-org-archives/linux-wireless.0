Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373240;
	b=A/nQ4hAVMhnIrVFhSNnht3+S9541XgoJU65QwbsR+NU0rFiLUTl559hFGL0tJeovFlYp
	 59KfKsxwhw5XV3R/J0Bw7+EN8gry/6yAdNwrjGMhvwaFrKy5T7zOTfu6+mcmjwUmXFYzl
	 Nnw+fx6UtgjXEVr5PxnUyF6XMi6vH/1vXKmqNZzbzZ7YnmVzdD7DyWzNzO3f2/V05T6b5
	 2ANxfJrENBwp0VgLJauN3yTiMWguKwUUiL897RO1n+NQQV9z5BCPP84F2VC+YdIHM0ANa
	 5jrv4EEjAqhe3/FJYWS/y3rVETR6i0i9iFqLQ4qJ4skHYUNAtvulFNWDs3C5NXwGzMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373240;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=6uRPTLAAPB5LpFRFm556jUuMMOe80x68STRxPhrcY/E=;
	b=t/BRineZHPJAK5uh0m8lqBCeKuJhoim/v4BxtCTn3BGRQQzHFvPWTKnavIO3cK+3J7Sw
	 OzdkZjjX1UzpFIYyVUge2eidtPiJ2EjLjjlnK7LYHxs1YK6o2Ln5IxI0BWQxZ26a5GdPj
	 xKp3LqBvcxxpbCsGHbTNO0CWlS7UwUUCIAfKcVx14LnJSXBZhciN4jcYA1U8R9lnk9eU7
	 gPF+Pjpb71/anwGFQaEzdr9VN74tLVe8AsK12tUpY2rziSGXXmXqxcCvTLfTmLueeLXeq
	 +d1H6r7Tw79c3zDvGb8CsHVunbXAVu4WCJSgT7XnpZ1QKeap8C2/dFfgH3Z3uwi1EAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L5YyNOdy;
	arc=none smtp.remote-ip=95.215.58.60
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87B60A5BE1
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D87B60A5BE1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L5YyNOdy
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oKPbqXqkGObkrDmdt1bVlbSpHSviwwvJZLv7o60QC6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793373236; v=1; x=1793978036;
 b=L5YyNOdyt9RpjFwjNr8yyfOoninOmluWKpimRgRa80g+9aOsILdOif5pyiwKuXhhKi2XuSYY
 XyJQgUITRsZ2LTj9sKMhKbXVxEYOWtJGj0uBTZ7XOfN0S7yplskY/TbwPjslEdV/F/2OZ7glya8
 Q2qp7XQnUjDN/63a88cHwxD4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 104ed7a153b02233;
	Fri, 30 Oct 2026 15:13:56 +0000
X-Mizu-Trace-ID: 104ed7a153b02233
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 15:13:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3a48ce3d110a35e7b6683ea3228340fbaef445d4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
To: "Ho Jie Feng" <hjf3108@gmail.com>, "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, "Ho Jie Feng" <hjf3108@gmail.com>, "Kalle
 Valo" <kvalo@kernel.org>, "Hans Ulli Kroll" <linux@ulli-kroll.de>,
 "neo_jou" <neo_jou@realtek.com>, "Sascha Hauer" <s.hauer@pengutronix.de>,
 linux-kernel@vger.kernel.org
In-Reply-To: <20261030034649.300288-1-hjf3108@gmail.com>
References: <20261030034649.300288-1-hjf3108@gmail.com>

Hi Jie Feng,

Thanks for the v2. The fix looks right to me, just one small comment
below.

October 30, 2026 at 4:46 AM, "Ho Jie Feng" <hjf3108@gmail.com> wrote:

> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wir=
eless/realtek/rtw88/usb.c
> index 715a2ce342d92..d6ad0770657d7 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct =
urb *urb)
>
>               skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
>
> +             if (tx_data->drv_frame) {
> +                     dev_kfree_skb_any(skb);
> +                     continue;
> +             }
> +

As far as I can see this is the normal TX completion of the aggregate
buffer, so I think dev_consume_skb_any() fits better here.
dev_kfree_skb_any() frees it with SKB_DROP_REASON_NOT_SPECIFIED, so each
aggregated transfer would now show up as a drop in the skb:kfree_skb
tracepoint and in drop monitor.

Before this patch the buffer went through mac80211, which in the usual
case freed it with dev_kfree_skb(), and that is consume_skb().

Best regards,
Luka Gejak
