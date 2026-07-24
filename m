Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17783A960A
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784932490; cv=none; b=UTiwTFvkNN6pPNHrEEH2zzhiERrY87WBzLGOr+AyGHvtux2MJ5b82qHouOuLAyYW874aOJwJLNtwoIQeK0tHHbmaQnT6LkDerLLowAOeGmR2Eso+HAGN4zjIajxTFX7EXTTmKn9eLXCCA8BzczCpKMbcOYBbIxbpRqEGtuJENko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784932490; c=relaxed/simple;
	bh=Za7tuLG+oJlXVZsNt2T1/1UpnkYjwnuqj8tc1Qh3GaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scum1OGou8rQyhBry/jArplITYmMqFtHUYWijKDvZUvU2WuTkthjLiNJ/FfFYZb9ULe18jC89q8bNL5Dk9WEi5/fdYHDB7uOe0ItXLGPWiJ29hLFDVDVLN9TDkRjQGhcxw0iHunUAJjlG3ZvX6ItvFSkQdLJSlMwibb60LES0g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jnrcCcMm; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnrcCcMm"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso740380f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784932486; x=1785537286; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yj67a1DgutWwa9X5sp8V7S4CDf9EKf8IVII2uXmKvNA=;
        b=jnrcCcMm18y+xKBSRl+eDdk2S1xuoEy45TqgdY6FOhoPXD+gXxndSl6jSy/8TJVFn/
         Ai6IxMpiskbbo5Swjv9buKtunqqJfQYSy3U5tTu8kME1aw2Uo9EFKWgrppO2avCsU4lV
         OmHFLQjFB5wltgT7YUvfxUO3mz1CH1fivgoi/DK5LZhRwig4lQWgUuS07ahySy7sLujo
         U10GXTCZEBsa3hOoLFmFFP/dJa2PZDhymS4cKUPjowp+NzSpKNJGAQl1SHZOdA4/s6Sg
         dASlaFsG+4jcCYpt6Q6jkz8aMjSs85a03WoTcx1eJ4l3/4u8QhNtFFFfT6vLkXba+Bee
         TOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784932486; x=1785537286;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yj67a1DgutWwa9X5sp8V7S4CDf9EKf8IVII2uXmKvNA=;
        b=Ny2HOyQmzK/SoMsK9nDoaJ6ceT9Wpf/ptL3GifwhTAMQtgKA6LBuOFB4uY5cLMF5Z9
         4j1abE9nbh0AsN8VjPdHDroFdj15HzJh6gfwBZNsLpSqB9GHUT4D1fdxTygxVi3a0USv
         yfoOt4SHW3DodBZCjlr7kg4Pm29BAXxLO64GWYeFnYrQgnO++8jsw4tmiotAjAlpU/vi
         K+nje/NPdpEWRkGwJYf1YvwG86NSXdtSR/57V8h8FVrItuw3q0GeyvsSH8xgadKLsscp
         oOWH/9/o2eLJysZlLXKudXyiz6gGyJf9ckwAAq8Ls56Yh8IpRCDePG+XsGqzIWywgPw6
         /gwQ==
X-Gm-Message-State: AOJu0YzFmu0vMnON5a9X9k7kfoiJewHZbSCW819LTlbz6LCb3Q45Id05
	v61JnDReFsqeodZvXHMf7iuA23gtbSkWjvy8tFZ3aTXSxXPJM7osKkXE
X-Gm-Gg: AR+sD10bHhrOMbeYSvTrWjrj9a4hxjI7NKBk1cUhKQpfSn1rOcoz4JUInte8lVwgZwX
	LrxJYjJnEboh17aEO8ua+hF6gbmXI3WjVxIXBJd4PM6bro6MLpPAnuTLHm4c2ycO3J8aluo5uWT
	zFfBhEEklhQF2Geov7qXPZpuQ5vzIy2i7FMSgGcAwBSZzlKfezDbmycDRVF/5s526DfZdCpRUwG
	b9hnmq93hYA9FedHnL2MgyOWbdoOq4EdRxeLs4BCcMFmtCqWN/cQXEMmuxmnlf8x22Jmb+sHMk1
	HUz2whqxNIUjT9eK/HejnTcTHQEk8IaiJbR2sZPkjKBh4GhqjJvdQJj5cJPktBsbV35JarWnkhQ
	j/lTkH316sOTkzXOG1L4c2QTeW9ENNXbZzagPQbQhC+9O6xOOQAUNNOtPNTa/tMgZoREvDha/Kh
	ArYZ3BnbVm
X-Received: by 2002:a05:6000:401e:b0:47f:934a:3029 with SMTP id ffacd0b85a97d-47f9febf056mr87198f8f.60.1784932485890;
        Fri, 24 Jul 2026 15:34:45 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bd77a9sm26007453f8f.14.2026.07.24.15.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 15:34:45 -0700 (PDT)
Message-ID: <e5cb3bb8-065c-4829-8743-f250f66f0eb1@gmail.com>
Date: Sat, 25 Jul 2026 01:34:43 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] wifi: rtw88: rx: mark zero length packets on
 RTL8723B
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724181858.192903-3-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724181858.192903-3-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:18, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> Like the RTL8703B, the RTL8723B reports receive descriptors with a zero
> packet length, which the vendor driver drops outright. rtw88 already
> flags these as having no PSDU for the RTL8703B, so extend the same
> handling to the RTL8723B rather than passing an empty frame up.
> 

I wonder if this only happens with SDIO? I don't think RTL8723BU does it.

> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
> index 01fd299abb7f..57facbc1b41f 100644
> --- a/drivers/net/wireless/realtek/rtw88/rx.c
> +++ b/drivers/net/wireless/realtek/rtw88/rx.c
> @@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
>  
>  	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
>  
> -	/* Rtl8723cs driver checks for size < 14 or size > 8192 and
> -	 * simply drops the packet.
> +	/* Rtl8723cs and rtl8723bs drivers check for size < 14 or size > 8192
> +	 * and simply drop the packet.
>  	 */
> -	if (rtwdev->chip->id == RTW_CHIP_TYPE_8703B && pkt_stat->pkt_len == 0) {
> +	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B ||
> +	     rtwdev->chip->id == RTW_CHIP_TYPE_8723B) &&
> +	    pkt_stat->pkt_len == 0) {
>  		rx_status->flag |= RX_FLAG_NO_PSDU;
>  		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
>  	}

