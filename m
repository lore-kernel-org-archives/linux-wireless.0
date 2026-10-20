Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792478856;
	b=yPiUV/GkvviUumF7bt2xhgKVcFwpWPTuK42shAd/ViwQYVfWuoDiQ6ZSYIW8Gb6XDLtQ
	 lcui18Rby6HQxGQ/o3ORBvUieske2GxVEwk7BLKVUrw+558mSgo+iUC8xZR5S0ImouUCy
	 pAPACsv6Yir2XpyKIEyVU6lpD0Q1z13r0OyP8AuDAVWBa2r++vobfgX32nHgRLNh1/t44
	 QgO4OdUhnBaMoTsDmcIYEAxdTvit+hfygIFauN6XL/pr5GDl80MM1GrrKx6oLm9vig6u8
	 OTtzSAa6aUbL68ZOBZwbEgVQA5AkBMLGKGq8AiUi8ZcwL4/FpAp/3NFwIP5e/3YQpCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478856;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=Rp+adJvub7H00Gyu7NINvsVBTpXgrAtmTAGxQSRLBhA=;
	b=PcGi5Tqe0pGha2sMIKgo91GhZn9sOjFubuSi7P3ESh/8rujnADzi3EPyRyyHzQ7u5/A3
	 bZnQIEw5Vn46S51cDSG1lamksIEfMLAA5URvprTjPy7SAYnYmBI0WaK4Dx4U5zrAK/QR0
	 Mzzj1Xv1vdfuV8tqBrI3WwRRtPus0bw6KLYGBlj5CUHELUcUSiL9h7A479uRbtG66Ex0e
	 RzmpeLEwTb7wXe6iFWrPf7yOnH9kYbPNfpugr9yzyDJhSOdFtDcr4kcx0wDs8/iv9bMui
	 6YSZ0f8/dZlEe1j+wDFkZKksCREafIph7pYjDYpC0r02d3N7CV+xBdthh60PgVyplVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=C5j873nE;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB39606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 06:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DB39606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=C5j873nE
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69K6lNWZ12738898, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792478843; bh=Rp+adJvub7H00Gyu7NINvsVBTpXgrAtmTAGxQSRLBhA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=C5j873nERQIQvfyTPnVEwQpKS2ERMiNJdsp2D6LoZDU8IbvdLsZT8MXnSElFPqLgc
	 WCZxugc14OQ6V3NtSbUHrPdOwFpNPyIc5/l3kGEEHqi0MvpcvJMkoyAytu2tjvEfa3
	 rW3WzJcCmK1sMML0eDkZSgbqr6z80yKoC9qJKaZQCbzKq0kHIhrDtoh9V3uQtI7uWq
	 L4XWj+3+juAez/e066uGghE3VSrqD6vAMDTK+PrdzGmTcJQ9nn+oe+WZfkhyuzXHLe
	 i4Z9ssjOWjcAghJG1nZ9aqqYtn+uunO8WHYt+Mg8s5hRj5WJbucTo76XgWqE0egMnX
	 bRwaGIznT3suQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69K6lNWZ12738898
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 20 Oct 2026 14:47:23 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 14:47:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 20 Oct 2026 14:47:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jiaxin Li <18135327133@163.com>, <linux-wireless@vger.kernel.org>
CC: Jiaxin Li <18135327133@163.com>
Subject: Re: [PATCH] wifi: rtl8180: reject RX frames longer than MAX_RX_SIZE
In-Reply-To: <20261019115740.572-1-18135327133@163.com>
References: <20261019115740.572-1-18135327133@163.com>
Message-ID: <9c226783-4047-4b46-9473-05bd00b5e403@RTKEXHMBS05.realtek.com.tw>
Date: Tue, 20 Oct 2026 14:47:19 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jiaxin Li <18135327133@163.com> wrote:

> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> index 4a5989172..abd76741b 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
> @@ -255,7 +255,12 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  			goto done;
>  		else {
>  			struct ieee80211_rx_status rx_status = {0};
> -			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
> +			struct sk_buff *new_skb;
> +
> +			if (unlikely((flags & 0xFFF) > MAX_RX_SIZE))

Declare a local variable such as 'rx_len = flags & 0xFFF', and reuse it
by second argument of skb_put().

> +				goto done;
> +
> +			new_skb = dev_alloc_skb(MAX_RX_SIZE);
>  
>  			if (unlikely(!new_skb))
>  				goto done;



