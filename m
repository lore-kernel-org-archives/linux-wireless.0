Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A4143746C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784933624; cv=none; b=ag51GcM5SplJ1w6F7o5eUcE5wdj4S9tu53PKaiZVEDMPo2eGNVq385grYjZuOw9tq2EcLlQOdBkYEuLDcA7MxgmkKV0wXrZi0Pr9Q18knlxe5zd8rp0vAYrmQSE3+te7eyZvj/2eWMAfFcFRjiSv0DnEWKBNS4/CbCiepptJ0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784933624; c=relaxed/simple;
	bh=G1KRuzLWlppfbpDPfjS3SPYT3SM6HjFCw6jdVoogfOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZKwPNWHbNzH/pf83KrZ6b1za8J1ESM2kpSNvuYbeBDw8v47ia0S1etDA0alP8dKsCik1YGNLrtn6TgzP0PlHN4QFC2zE+13PJJPbIOzUa4UVliHYbmV4WPJZ6pVdgJsFpcWFiTWUJThp0foRO4FxUXU0E7hmbrwTZbUL7zs9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNLMWoUr; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNLMWoUr"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954c0833b4so7499765e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784933615; x=1785538415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J8ldsZEUrwIIl9s0mESXWdsLuqTjjuPFtNa3yxETkTs=;
        b=UNLMWoUroeBReHCXDRUt8dgyd0iEHkZ8SIwPF+264DvnekWkMJSuxd7ARXB53EHwrw
         QlcXcAL691qKe+mFmGzo77pLZZyZIF4db3ButbxZ9z675DlpDyxgNXwAx7v4e43/2tuM
         mWuUuq+n9I32r4D8w4ENJaUfgkhSY7RatYnQ0Js9MEyKr6tvd4+ISfXW/i6f7Rh7DU1y
         v7BomvL89nvGC3+h2UsAqn1nd1NVfVfkIg/7O2ldBsF0azKvEDSY15cdNB4i26yGNHXN
         atIoRYHLlXObdSNPdx4RJ4gJ13Cp26/rNXM37aIEZcADxeu1vfyJlyFkz/OXuMJxbk0H
         vNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784933615; x=1785538415;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J8ldsZEUrwIIl9s0mESXWdsLuqTjjuPFtNa3yxETkTs=;
        b=eNYM8W/FUgbX3k4jhYXNHBoa8/9wagc4B+DIIQ6lX8bAn9AiKkJJJUuREohUfVXVDG
         EMmsVEIOTaQ7r6dMXHNLrtHCsS+gax5xZuY2rBTTxErmzEkR1LlWxkpabyFgC/mSUwB0
         2tS51y/vx6e47LCV44BzlEG8Ar4N8K2QjpGp7W7jCPPofv6F0DA1Y3WAx8nzgaFI5xAW
         ICziYtLQ4pCRg0xkwY8uKgf4sxW2C1GCOxorVZL3lA/GWK9A00djbqBH9sPsa6s2XW8M
         R922F79PQBjx2SkEQkxiTUqmlKz9Jq+Kfe5diZZdBjvN1hQdY8RvYesHJ+KFloz850K0
         nKNg==
X-Gm-Message-State: AOJu0YwvL36FbQglv8AaKoa+/ZhydHXzlFT1JWBx0G+DEX573CVcQ4VE
	gWEzd8Kxg952xuIvAXzO588h7Gh3XE45BF13wlABq9DmH5AARtkHdLjC
X-Gm-Gg: AR+sD11IIwWHR2WWiTkaKMAhLDsuTyZPO4QDbc9fmVByJAmKBoSvbci2rPy0oySuFaG
	tDyYqf4x9ZE5L15cnjBXMPcb+34GD0Ha1ZJShEDb1V1v+fOfZmVkOIrFpGGnVnj6dCEF+tcDGRc
	s2EiDmC01EXCPHgDt60eXboAvWs4ShON3INolOKnX5h7E9iJQvABwwCx3KnM3mXirRBpaeSxuOz
	2HMyiggo7+92ncVgcA1hd9wDloRherByaBTmFkCDULcHlReWx5yoI3oY1b6Axl3C98/Fb2e5V96
	BmMOa6e6jrIlDTwwfqDLLz9mvrcbrqUF+IsPApieXyXYhJ6Z6VTleqHUUO5/yBdKkruL1OHCdOl
	Vr0bzv4s9y/U96+3EYR5ZUjTyH4cYKcXddXKeFpYdsX2IB655nolNbqXUE0mHKddFOLWlhIUWgp
	mlBJfQeb23
X-Received: by 2002:a05:600c:c8c:b0:493:b6ee:fcb7 with SMTP id 5b1f17b1804b1-496b56f39dbmr2142255e9.14.1784933614656;
        Fri, 24 Jul 2026 15:53:34 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4866813sm27078245e9.8.2026.07.24.15.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 15:53:34 -0700 (PDT)
Message-ID: <45f43cd2-af91-48a0-a0b5-5862824109ec@gmail.com>
Date: Sat, 25 Jul 2026 01:53:32 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/19] wifi: rtw88: fw: handle the RTL8723BS management TX
 reports
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724181858.192903-5-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724181858.192903-5-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:18, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The vendor firmware used by the RTL8723BS does not report management
> frame transmission through C2H_CCX_TX_RPT. It uses event 0x12, and
> reuses 0x32 for scan probe reports, which rtw88 otherwise treats as a
> WLAN_RFON event and completes the LPS leave check with.
> 
> Route both events to the existing TX report handler for this chip, and
> defer 0x32 to the worker instead of consuming it in the interrupt path,
> so the reports are decoded and the LPS handshake is left alone. The
> payload layout is the same as C2H_CCX_TX_RPT, so no separate decode is
> needed.
> 

This is not right. 0x12 and 0x32 are not C2H IDs, they are the first
byte of the C2H_CCX_TX_RPT payload.

Since this patch changes the way C2H_WLAN_RFON is handled, it might
be responsible for some "failed to leave lps" messages? Maybe extending
the timeout (patch 3/19) is not necessary after all?

> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 18 ++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/fw.h |  4 ++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 945fedcd375b..a81ff15218e1 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -317,6 +317,15 @@ void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
>  	case C2H_CCX_TX_RPT:
>  		rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
>  		break;
> +	case C2H_VENDOR_TX_RPT:
> +	case C2H_WLAN_RFON:
> +		/*
> +		 * The RTL8723BS firmware reports management TX through these
> +		 * two events instead, using the same payload layout.
> +		 */
> +		if (rtw_is_8723bs(rtwdev))
> +			rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
> +		break;
>  	case C2H_BT_INFO:
>  		rtw_coex_bt_info_notify(rtwdev, c2h->payload, len);
>  		break;
> @@ -365,6 +374,15 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
>  		rtw_coex_info_response(rtwdev, skb);
>  		break;
>  	case C2H_WLAN_RFON:
> +		/* On 8723BS SDIO with v41 firmware, C2H 0x32 carries a scan TX
> +		 * report, not a WLAN_RFON event: defer it to rtw_fw_c2h_cmd_handle().
> +		 */
> +		if (rtw_is_8723bs(rtwdev)) {
> +			*((u32 *)skb->cb) = pkt_offset;
> +			skb_queue_tail(&rtwdev->c2h_queue, skb);
> +			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
> +			break;
> +		}
>  		complete(&rtwdev->lps_leave_check);
>  		dev_kfree_skb_any(skb);
>  		break;
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
> index 48ad9ceab6ea..6927d2041d24 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.h
> +++ b/drivers/net/wireless/realtek/rtw88/fw.h
> @@ -54,6 +54,10 @@ enum rtw_c2h_cmd_id {
>  	C2H_BT_MP_INFO = 0x0b,
>  	C2H_BT_HID_INFO = 0x45,
>  	C2H_RA_RPT = 0x0c,
> +	/* 8723BS SDIO vendor v41 firmware management TX report (0x32 is
> +	 * reported as C2H_WLAN_RFON, handled per-chip in the C2H dispatch).
> +	 */
> +	C2H_VENDOR_TX_RPT = 0x12,
>  	C2H_HW_FEATURE_REPORT = 0x19,
>  	C2H_WLAN_INFO = 0x27,
>  	C2H_WLAN_RFON = 0x32,

