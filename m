Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3913B4EB5
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633627; cv=none; b=gnZB3CvbY5vlMaKeFbw8g3Lcx9RljsjYM5SM1Vqz00g3dPhvek6ng2H22BAZMq9g59S08UMHtktyuu5JaaQxt8limnstEXUSXecTlZh4IgmauTiLOqzWOg+TUn4tS9+ExSvtFIPyPhUab41Zfx0tb+AU9gVBLRSHyk0P+ZkVTkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633627; c=relaxed/simple;
	bh=o55Z0TctzZ1TV0FZdKaCHaRccaP3Zl3sp7oRzJhRtiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2H70q7HM4TkZBzTkiU7JhBT/R0X2499jHrE9EMcH31S0ubxh4ozzCVZrl8wmJg6B9oy/mF7mEy/g4JlVGXNf3+i5V9x2PhGiamB7JCR/KUSBUyyznQPOUWATTy/UbJgcH5iwcTovN9TmToiTgmsiNnM9YBVDKzE/NokYCweoi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQaMGKRi; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQaMGKRi"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso149185e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786633624; x=1787238424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cl8SsiBieJKZTfoRpN8BaDOycOWZISr8O2wW18dZcc0=;
        b=VQaMGKRiy2MJFzy2xFskqJOfMPLJ8LBMJ7ZgIgnb4jO79ad0qwg+wWrGBldoDc47lU
         nvuJdZ/64f9+uIh89V12rlb6qk4TdL0pPGZsSKsscu38uHv6YEQ08U4L/nIENQJwolmO
         WNCVpA7DQOsZl3hbTilITdGEjmHmVQrfdDMV501EZAHHLXNY2wNe/6FdbEmEATuVZsNQ
         NqDAZ6J9KsM6sV4F4hkCJdrLdoFHQR/wtFd5KF6d0akYlbnToyA0TlfnAqRE3tXlesfD
         tvsFrFv0Rgz+fETZh11qdItKPkm4sCPMHluEe8va6KvXl/j9vGG4duzUQy8tw4ayUVTR
         32hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786633624; x=1787238424;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cl8SsiBieJKZTfoRpN8BaDOycOWZISr8O2wW18dZcc0=;
        b=sNUVHCh+iw4RZ0b1p82fA/rGJTkILLXuG0RsJEM7Kpv//NpZsLLTOC/XLAS8Vk/pQX
         Fwkf8CxE5sZprCxhwUa/m/flzylfzAz0dXMmAfn5nnbTgEAru7eXovPOmeD9cfKjV1sb
         MIaZ040WyYs9M3orWWlRXNhuQRDnTDM4tiMmPoe7D9LHlP7ExG4uvJiwkRZebAEk19ZC
         kpw3fmHuxhqlkOhE/NDifeq4yBuyvh8QA3rHeClxfXYONvF2/aQJmXdeYU5emAb9+hx/
         7EZHMtWy7IpAv4LrxExYu3GzVFmiH37oeYnGoy0PsVXBgE7mtlPQTyP/dCymKyj3h51R
         2V8A==
X-Gm-Message-State: AOJu0Yy+3VDDqiCpxxh5kkTh7Ik232aYGLVlgnlTQmrMHwl81JIzglv3
	wzkxWyOLOg1o1J92nGh2whXpoQEHxgXer/y86y2B9wnYKC0LZ3X8PRF/
X-Gm-Gg: AR+sD12bDoTGvsUpIS5UaoCdaEO2J/Z9dnonGuiOI9jEE/mBpDwzg/GgpMUMEgF3eXF
	bCR5xEpPyb7KFtj/6EFHpPR70v35K1QNKU6Hjxdg/PW3hR482DQH+hSi0dOw9Menm4COEcZaFsC
	h88pzKBLQoBppaJpvJ4mdWGBJ+ZGMV5pKMmerzlq7Tbw9LaeNxQ5fuuFW1zy2O6iq6IAm5ZRVxl
	hjTmos+Aag0wDB1vDGCQfSDpBWuAGZW/68wcvQzFf5FN3iMnwo4JFdobHywRwc+jJYy0rMph0/L
	2PPIeEKOY0O6USJyHCkKGlIXNEhXwnJqKfNwR1f8a7f0dIju46qDYDe0lmguvIwJqD5rOEVfhic
	+Mf45Ja2kfAMA8pfpBYm9zRTElKU06/KkLdZOHM6xQkTvkCnEcWv4kdkBHujW36jRCOPBI3Z7Oc
	n+beatE7GdCziQI+ejRo13KTP/S/7NXI2PU09aA15vSU45s3lsznr+3ia02AIBp2R2g2GbhLw=
X-Received: by 2002:a05:600c:6287:b0:495:4689:1e98 with SMTP id 5b1f17b1804b1-499821845d2mr84008575e9.10.1786633623879;
        Thu, 13 Aug 2026 08:07:03 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499820f5d26sm48570965e9.1.2026.08.13.08.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 08:07:03 -0700 (PDT)
Message-ID: <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
Date: Thu, 13 Aug 2026 18:07:01 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via
 the AC queues
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mehmet Fide <mehmet.fide@screeningeagle.com>
References: <20260813131845.1330003-1-mehmet.fide@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260813131845.1330003-1-mehmet.fide@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/08/2026 16:18, Mehmet Fide wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> In AP mode every broadcast and multicast data frame is routed to
> TX_DESC_QSEL_HIGH, the after-DTIM queue. The firmware drains that
> queue at beacon pace, roughly a dozen frames per second, while a
> single associated client's mDNS/SSDP chatter alone exceeds that.
> The excess accumulates inside the chip until the shared TX page
> pool is exhausted; measured on RTL8822BU, 14 of 1803 pages were
> left. From that point every host-sourced frame queues behind the
> backlog: authentication responses reach the air seconds after the
> client has given up, so no station can associate anymore, and the
> beacon reserved-page download fails the BCN_VALID poll ("error
> beacon valid") because it needs pages from the same exhausted pool.
> The AP keeps beaconing throughout, so from the outside this looks
> like a silent receive stall, and only a reboot recovers.
> 
> On USB the HIGH, MGMT, BEACON and H2C queues additionally share one
> bulk-out endpoint, so the jam also head-of-line blocks firmware
> commands.
> 
> Route broadcast/multicast data through the regular AC queues
> instead. They then leave at line rate and the page pool never
> fills. The trade-off is that stations in power save may miss
> multicast that the after-DTIM queue would have buffered for them;
> at the chatter rates that trigger the jam those frames were being
> dropped anyway.
> 
> On a bench AP (RTL8822BU, USB2, 20 MHz, WPA2, hostapd, a Windows
> client driven through disconnect/reconnect cycles): reconnects fail
> 0/5 before this change and pass 5/5 with it, with the page pool
> staying healthy and no beacon errors logged.
> 
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

I wonder if you can reproduce this problem with kernel 6.5? It looks
like commit 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM
behavior") from 6.5 was supposed to fix the exact same problem.
This is also the commit which introduced the code you are now removing.

> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 64e1c3420..f528fe0f2 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -565,9 +565,6 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
>  
>  	if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
>  		qsel = TX_DESC_QSEL_MGMT;
> -	else if (is_broadcast_ether_addr(hdr->addr1) ||
> -		 is_multicast_ether_addr(hdr->addr1))
> -		qsel = TX_DESC_QSEL_HIGH;
>  	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
>  		qsel = skb->priority;
>  	else

