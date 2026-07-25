Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443535C181
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784978707; cv=none; b=gMXu+fZa+5kPLLJ6aTsIV7ZgelTq4OujgaeaN6w3uq3bRJ4TEj0EDb4XOerjOegIQDyxW8MhVGneppkRGr4QAdyv3MEBmpQspYeMuUPvwzq4g/1IkDb9Jtm/uUfiNLq8nn++8WYqYmpYpdAHAMXEUDAggHBkfs7JJ+V7BaUpDWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784978707; c=relaxed/simple;
	bh=Rq3lzNswFfIYEhK5p/0mubinIFAPeB7nGHjY26yebvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aA4wGjr+iCCBbaCb7YzgPQLFrLXwv9G6JV/2A5d1DrYKHuRK7azrh3qhROUyLgdhcBhbHtbHTvHFqBopirZMyj7iGhDkYiAJtwyQA2btHirbAMcaqNm87SFCEdidaSQWbuU1IVN7DZY25iu71M9jnkRXHtddRARNGtWs4aGvBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KD298iOP; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KD298iOP"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4728c12ba97so769960f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 04:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784978704; x=1785583504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KohReyS6AJYnGPiV+qUeaij9orUKoMMitiIixb/+cRc=;
        b=KD298iOPraUPrNKWG1ETdss85yKHgfjuuumJmlmDRCRGunUU23FdBF/VE/8p/D8hvn
         TslySxJVAGotXasEIdN7dk5Bv4gUgUV3qDk7zLQFYMi+VYPQJslLqS0biq2q5Z6pFDAB
         5hREy/9yu3AWWUmiYjMEf2zG8JBH1uOhtQ17AMygKsZBNJjG+ZYYcquuF+iT5OiMKrl4
         rtRMTtIdDl9uxYciBKKp0ixFQ/fqTv4XnR0hT3dpLgIoOB5NKgOPD7xjOPK6JiZwSEJH
         KTt2y/ueUMtLC4UUaLJjnomeGUwjmEITldnt+K2noFpEH+SjXERI0FdTXtBo7tJN9qEZ
         1waA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784978704; x=1785583504;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KohReyS6AJYnGPiV+qUeaij9orUKoMMitiIixb/+cRc=;
        b=XwXkbyofUaAP8Z727WqdWfcD/TfzlbtcdN3K2Cnhw4a1YjEw2YKMhduDV++lLkGV09
         gI/L840MR8EPQbdQzb+/HCNZm5b17+iVUh90GJT1PgCueMAAyMerKnKpMQXjjbzaQ2uw
         Nq3vDEPhZLA49DYknPZFjOyD3GWb87SHhEMs4ize3+5uKz+zo7hAg30ulwgftLr3cNU+
         MvyUt6uhKGZcWh3alri1oIGmC3ldtw2bOoEyNNWsdOWVknJjshZaD5f7ALa12J0hMtFI
         I+INZNe5Omx/9epJnVEB+Vt0d5/zo/7MrlJhdq6JGvxwa4Fk7RgPGWVYKkGieCLauCEJ
         Bd9Q==
X-Gm-Message-State: AOJu0YwH+3ccG0HDQJ4H7Wn0nyy9zNPCfh1e8+sBUwZhyCWhcC8HMhgU
	Y2xt5a3jTnCyNVsTosDoh2Qsy/OsiO3G1aoobWhtKC6rUr/q5pDe4tNP
X-Gm-Gg: AR+sD11iUVMEVgqpjmD9ht2hEPrvb2+9PNJx87M7z3GL7FlhQir2N2A4vyVRiH9bqvo
	pHYrI2bC6czXI8EB6WNdg/58q68IXjov7QQD3ekp+K93zYWMYp1hFEQMaQYGTHyaLS9hnDyrRQV
	NuRj2EzzToxdZjN15f1ps581p4gwONsALga2q2gX1Gk7jidkiVgDR1JMhQFvdc0JwZ5G4tzInBd
	Y9CDeYd15i5uTwmkYwHov6LQ7/fBpmaikP/5MIFBDwaX7hh6hl6vo1O34ExYyte5rj8+ckfPab7
	JfvqG3aBw7IGiv7nqmpLQeoF5JSuGQhrL8Pxf4Hm4l0E/dteoBaXcPQtvGzGuFC5rNgCOe41K2n
	QpsWf4SyHRA85SoC4HEE/UuE+6fCM8Z04x5MQQYPL83f6OVcEbKnhh4v1EVgGJ8mweaZEsEih9A
	jZ7vNuF4QZ
X-Received: by 2002:a05:6000:2386:b0:47f:810c:8abe with SMTP id ffacd0b85a97d-47f9feb544emr2224500f8f.36.1784978703517;
        Sat, 25 Jul 2026 04:25:03 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531afsm33083322f8f.24.2026.07.25.04.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 04:25:03 -0700 (PDT)
Message-ID: <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
Date: Sat, 25 Jul 2026 14:25:00 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183235.196908-1-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724183235.196908-1-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:32, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> Enable the existing RX aggregation setup for this chip and select the
> larger DMA aggregation mode it needs. The RTL8723BS does not raise
> CPWM1, so leave that source out of its interrupt mask, and set the SDIO
> TX control bit the vendor driver uses to have transfers always
> recognised.
> 
> Interrupt status is also acknowledged differently: write back only the
> bits that are actually defined, and for this chip only those that are
> unmasked, rather than writing the raw status word back. Writing back
> undefined bits leaves the RTL8723BS raising a persistent interrupt after
> resume. Note that restricting the acknowledgment to defined bits
> applies to the other SDIO parts as well.

Why does it apply to the others?

> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 29 +++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/sdio.h |  9 +++++++
>  2 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
> index fcbb0ee601c1..1c2d8082f468 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -866,7 +866,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
>  {
>  	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
>  
> -	rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CPWM1;
> +	if (rtw_is_8723bs(rtwdev))
> +		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST;
> +	else
> +		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST |
> +				       REG_SDIO_HIMR_CPWM1;
>  }
>  
>  static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
> @@ -874,6 +878,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
>  	u8 size, timeout;
>  
>  	switch (rtwdev->chip->id) {
> +	case RTW_CHIP_TYPE_8723B:
>  	case RTW_CHIP_TYPE_8703B:
>  	case RTW_CHIP_TYPE_8821A:
>  	case RTW_CHIP_TYPE_8812A:
> @@ -901,6 +906,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
>  		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
>  
>  	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
> +	if (rtw_is_8723bs(rtwdev))
> +		rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);
>  }
>  
>  static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
> @@ -969,9 +976,19 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
>  
>  static int rtw_sdio_start(struct rtw_dev *rtwdev)
>  {
> +	u32 clear;
> +
>  	rtw_sdio_8723bs_check_rqpn(rtwdev);
>  	rtw_sdio_init_free_txpg(rtwdev);
>  	rtw_sdio_enable_rx_aggregation(rtwdev);
> +
> +	if (rtw_is_8723bs(rtwdev)) {
> +		clear = rtw_read32(rtwdev, REG_SDIO_HISR) &
> +			RTW_SDIO_HISR_CLEAR_MASK;
> +		if (clear)
> +			rtw_write32(rtwdev, REG_SDIO_HISR, clear);
> +	}
> +
>  	rtw_sdio_enable_interrupt(rtwdev);
>  
>  	return 0;
> @@ -1051,6 +1068,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
>  
>  	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
>  	val &= 0xfff8;
> +	if (rtw_is_8723bs(rtwdev))
> +		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
>  	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
>  }
>  
> @@ -1341,6 +1360,7 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
>  	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
>  	struct rtw_sdio *rtwsdio;
>  	struct rtw_dev *rtwdev;
> +	u32 clear;
>  	u32 hisr;
>  
>  	rtwdev = hw->priv;
> @@ -1357,7 +1377,12 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
>  		rtw_sdio_rx_isr(rtwdev);
>  	}
>  
> -	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
> +	if (rtw_is_8723bs(rtwdev))
> +		clear = hisr & rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
> +	else
> +		clear = hisr & RTW_SDIO_HISR_CLEAR_MASK;
> +	if (clear)
> +		rtw_write32(rtwdev, REG_SDIO_HISR, clear);
>  
>  	rtwsdio->irq_thread = NULL;
>  }
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
> index aa088c512b9c..208c91446f82 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.h
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.h
> @@ -22,6 +22,7 @@
>  
>  /* SDIO Tx Control */
>  #define REG_SDIO_TX_CTRL			(SDIO_LOCAL_OFFSET + 0x0000)
> +#define BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE	BIT(4)
>  
>  /*SDIO status timeout*/
>  #define REG_SDIO_TIMEOUT			(SDIO_LOCAL_OFFSET + 0x0002)
> @@ -77,6 +78,14 @@
>  /* the following two are RTL8188 SDIO Specific */
>  #define REG_SDIO_HISR_MCU_ERR			BIT(28)
>  #define REG_SDIO_HISR_TSF_BIT32_TOGGLE		BIT(29)
> +#define RTW_SDIO_HISR_CLEAR_MASK		\
> +	(REG_SDIO_HISR_TXERR | REG_SDIO_HISR_RXERR | \
> +	 REG_SDIO_HISR_TXFOVW | REG_SDIO_HISR_RXFOVW | \
> +	 REG_SDIO_HISR_TXBCNOK | REG_SDIO_HISR_TXBCNERR | \
> +	 REG_SDIO_HISR_C2HCMD | REG_SDIO_HISR_CPWM1 | \
> +	 REG_SDIO_HISR_CPWM2 | REG_SDIO_HISR_HSISR_IND | \
> +	 REG_SDIO_HISR_GTINT3_IND | REG_SDIO_HISR_GTINT4_IND | \
> +	 REG_SDIO_HISR_PSTIMEOUT | REG_SDIO_HISR_OCPINT)
>  
>  /* HCI Current Power Mode */
>  #define REG_SDIO_HCPWM				(SDIO_LOCAL_OFFSET + 0x0019)

