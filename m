Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A487449B3A
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550694; cv=none; b=pHCncudwPjZzUlpz13ILzS1w5bBh3vKvp10pIdA1H7i+cg6aJBHLzfJK3o0T+eaYQZxwFHP1IVm2M9FUteLJndR98EkEbmvkTF0ZS5a3hNr1CRH0dLZv2Bhi4tR+7fiVJXs2h7ZXFA76cmxBcHT2ptnhcaWE/fRkDL5u8Vg5LNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550694; c=relaxed/simple;
	bh=DTfyjQQ9QaZhOHLOFw2CFdJ3L2v5f+YHPDHs4G0YlSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mciZ1FHtDEkWWzWdqUvtypNzgU8J2JCnKgD+JEn42LTpQ8bYa3WH5n/D8Qeh3TV0bfgrwL4L4weRmwNeC9RpsIsGoWHL+XW1NMjVd5XU2YHzFF2gHut9wFO7vEhDp97DFiGf72PZkzMs3H7gXfuuCIYdADnIZxazsSlyTjecqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TxMoB1QN; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxMoB1QN"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49ff680331aso68050355e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 05:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791550690; x=1792155490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z8lzbZmWc3hYBJ722sfbQgqeG/5EFg1Z6AcAAII8xsM=;
        b=TxMoB1QNTXXw5hJb/lAWvxm3q39GdwOPlvzxLi+FvYagc5VIGVTTy1xlR93JqyorBS
         Alpx8Evk0ys5DOPTmo4rT0Zgg6fiMueDO2mumXWu3hpNgPUxnniwUHy4xdEFXz1GySvV
         Ola6LLSMuffCbmO5k59zzJN13Aau/rEnvC2MoGou+JmsC9RJCiOiCbBYPwqTCPdRlQl2
         i1suAmuvhnOJu3ouFmsdzoM3q9yLI1VPXN3bzC+oTaYhTlHoiWUc1MSeV4ULmkgiaOUf
         bhWaOGXNKu/3XDNe8AuWxOl5dz0PEiQBES9N+2ycFHjgaP6UxnXLZZ7iVncQ7vT9MwHN
         z9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791550690; x=1792155490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8lzbZmWc3hYBJ722sfbQgqeG/5EFg1Z6AcAAII8xsM=;
        b=AfPkWiosnHnvsoLmqp0Pl2FkzeY9BWI3rl2oRIO6KkJ0pBGrbqtrCszGMPQ7RTUlg+
         ea6ojj+/S3/slwUDLgbKfdP1DNSgZVSWOBeh0ylrgekwJplbDziL9Ew7VX/qh02uyODX
         u/g+C4q40DXtAHefqmi+NbgFkRpRfF8p9RodWAoA+uo6ZgLkiRfUumB32Qp3eXuXjxBd
         jSJXKsT4NA4ojnlvZfwxmI3Bt8H/uxk7V93r5VlLeEQqhh2rNsce1pSDGl4dNuekK0WO
         1HuJlVZK8GeI37iBShkADbuWUVRSzA0qN5OQY89T2Er380opxG5VwgO6tHGJbNu1PoiL
         a5BQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjzfd8R2HGLMfFgO1WSgozMuoURu+YGidVZiZiKRIQlM+9Y1gXL04v7l37JBecwRSLtbr0XEBuo/kJpGgK3A==@vger.kernel.org
X-Gm-Message-State: AFuF++k3FrfgczJoNG7tONJmAQHeNPTaNPFGny2JnkKlyzSkyC1yNL+Y
	vgLQ9fmy3G8m6Ag7+TBWUVMurLIKafXnJHRxndvZespljXwn0kb7RbdU
X-Gm-Gg: AYBFou2nVXOgxGirgb4yN0wxs+Hrv7sA4SdnrOQzPf02AOWYlx68oBuYyfCT/Gnf9Hg
	8U9ZIu4tWbcALIQJ+6sz/Cgo69zN34SvA2ZZhI/W2c76Ju1xw3Y1pb/fBuaPcJ2rbxeokXNC7kb
	kJU6yj7I5orwOjdIHh25Out6a9BSSQ1EcTI8sZVhq+RlvX9X9UHcx5zgPpyS0TO476LshzaAm0E
	mP9CcLNAhsOmW5pwRSFwKwSe2DLLUAmWklHXQsUY4MFs0N/70S1o3Tx+SVFC9I53ybHI8ZdhEAF
	dGWzO237MWwgaejvaQCifKxAg6O1Ipa6KNg0OQR1y3ZKtlm4GrPiubibM5XXcUOcWsYMUaGw/pl
	tc8vSllraV+B/IQKT5hWzbq9UPBRxrx62U+IsXDyS9K4KuxB3twWGQ8+2+EcwDkeVUYRdUIzIfw
	n+zMqnZEuw/CYrkyuHC0FUx/8GVlFBz88onFpZ7so2uugbJ9ROVS6EaCymdue7St1NNbHVLGJS7
	IT8aA==
X-Received: by 2002:a05:600c:4e02:b0:4a1:7428:8195 with SMTP id 5b1f17b1804b1-4a18e4aa2c2mr37465875e9.29.1791550690117;
        Fri, 09 Oct 2026 05:58:10 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18e4a3b4asm87903985e9.5.2026.10.09.05.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 05:58:09 -0700 (PDT)
Message-ID: <5af02fd9-1657-45dc-97ee-2d88ee858fa8@gmail.com>
Date: Fri, 9 Oct 2026 15:58:07 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND FIX PATCH wireless-next] wifi: mt7601u: add vnd_reset
 parameter to fix probe failure on Tenda U2
To: Herman Semenoff <germanaizek0@gmail.com>, kuba@kernel.org,
 kvalo@kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CAMnMt5aD83-6x8oRBo56kEwkrjPibZZ5SNR8MkwU9DSpM8HRqQ@mail.gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <CAMnMt5aD83-6x8oRBo56kEwkrjPibZZ5SNR8MkwU9DSpM8HRqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/09/2026 04:33, Herman Semenoff wrote:
> On certain MT7601U adapters, such as Tenda U2 (USB ID 148f:7601) and
> other newer hardware revisions, driver initialization consistently fails
> during probe with vendor request timeouts (-110 / -ETIMEDOUT):
> 
>     mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
>     mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640
>     mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
>     mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110
> 
> The failure occurs because mt7601u_load_firmware() unconditionally calls
> mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
> chunks. On these devices, issuing this vendor reset leaves the internal
> MCU / FCE DMA engine in an unresponsive state after the first firmware
> URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
> (0x09a8) immediately times out.
> 
> The USB device is already reset during mt7601u_probe() via
> usb_reset_device(), making this additional vendor-specific reset
> redundant. The vendor driver never used it, and devices that work with
> vendor reset also work properly without it.
> 
> Drop mt7601u_vendor_reset() and its definition to allow firmware upload
> and probe to succeed on all MT7601U adapters.
> 

The subject ("add vnd_reset parameter...") doesn't match anymore what
the patch is doing.

When you send a new version of a patch please add "v2", "v3", etc next to
"PATCH".

"RESEND" is only for a patch that you send again completely unchanged for
whatever reason.

> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301
> Link: https://www.opena.tv/viewtopic.php?t=63919
> Link: https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
> Link: https://bbs.archlinux.org/viewtopic.php?id=224859
> Link: https://reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/
> Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
> ---
>  drivers/net/wireless/mediatek/mt7601u/mcu.c | 3 ---
>  drivers/net/wireless/mediatek/mt7601u/usb.c | 6 ------
>  drivers/net/wireless/mediatek/mt7601u/usb.h | 3 ---
>  3 files changed, 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> index bad6ca821400..979bc506d4ed 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -459,9 +459,6 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
>   mt7601u_wr(dev, 0x94c, 0);
>   mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);
> 
> - mt7601u_vendor_reset(dev);
> - msleep(5);
> -
>   mt7601u_wr(dev, 0xa44, 0);
>   mt7601u_wr(dev, 0x230, 0x84210);
>   mt7601u_wr(dev, 0x400, 0x80c00);
> diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c
> b/drivers/net/wireless/mediatek/mt7601u/usb.c
> index 9306870cbc91..0d38644c491e 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/usb.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
> @@ -116,12 +116,6 @@ int mt7601u_vendor_request(struct mt7601u_dev
> *dev, const u8 req,
>   return ret;
>  }
> 
> -void mt7601u_vendor_reset(struct mt7601u_dev *dev)
> -{
> - mt7601u_vendor_request(dev, MT_VEND_DEV_MODE, USB_DIR_OUT,
> -       MT_VEND_DEV_MODE_RESET, 0, NULL, 0);
> -}
> -
>  /* should be called with vendor_req_mutex held */
>  static u32 __mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
>  {
> diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.h
> b/drivers/net/wireless/mediatek/mt7601u/usb.h
> index 723025f84483..49fede310c3b 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/usb.h
> +++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
> @@ -14,8 +14,6 @@
>  #define MT_VEND_REQ_MAX_RETRY 10
>  #define MT_VEND_REQ_TOUT_MS 300
> 
> -#define MT_VEND_DEV_MODE_RESET 1
> -
>  #define MT_VEND_BUF sizeof(__le32)
> 
>  enum mt_vendor_req {
> @@ -65,7 +63,6 @@ void mt7601u_complete_urb(struct urb *urb);
>  int mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
>     const u8 direction, const u16 val, const u16 offset,
>     void *buf, const size_t buflen);
> -void mt7601u_vendor_reset(struct mt7601u_dev *dev);
>  int mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
>       const u16 offset, const u32 val);
> 

