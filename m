Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099D437478
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 11:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448577; cv=none; b=WVXeyvoiDZMoxWsNkDMQdQB8niQzaZbmvevDbBd/C9ftm/AujeZIJib33NYIBBYJ/UYL7eObBZ9dm79HKWxwzQoLLcRNrUvpWlXXCr91EfIytvW3T2mK7hPj/8bhSVMmx9Qdm2ofM/CskGvUUgaW6mZeJAVN2LmyP6OmANJg7Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448577; c=relaxed/simple;
	bh=nKRl74F3nOtBPeC4OvhtgKoqtZBA/pT78nv8TtfgHao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OnRgXgYUgHO5kiPis2ByieCnWCjlVC9KiLm/AqSUyKH37sJb5EoHZxYgFxK/th/NugBOf7fFx7YPYPK1MBqU1BMjszYCQl7gj7HRTfsaRUq1wR+Ql4DFXs/SF2OQRYO5njAMbc7ZDQ5GF1FyqVJ+vmn7LTowyc4Jt+lcdCENero=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQqy/NJp; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQqy/NJp"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso20243635e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 04:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786448574; x=1787053374; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PguIILRDI2Cz6olUODS1ZFpILKY2KndU6D3MmlvOZHU=;
        b=fQqy/NJpaSJ1HvCmi73l94rABdfMW9Kuy7rM501vMn5SnZ+7s3PazYZvIpEg8FZqGm
         83DY8DV2pN6Dil2n3k3B0ye71foznMIlIGu50GYv1cjPZvHAruBe8pv8coCCVVJcCLCN
         pW0ydCZxVUoeXHRW50/8Qw+ddoUPsaiWbmIv+piG/bBPEqvhh9WRD53/uA9rxu9rs/yE
         pz02gA7/WoVMdZr9gDA+GwHH0IWv3K93ib8gDGzavqgVnDhhE6WDcr71v5ju5UA3cwFM
         p6IQBvBjRBknz+/SM6icJJQKRXFlaAAF3jRWF1ZQBRak5fbXeIdgOaWoURMRk/6Kjjl0
         nEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448574; x=1787053374;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PguIILRDI2Cz6olUODS1ZFpILKY2KndU6D3MmlvOZHU=;
        b=IEuFwUHxLOp5j0y0Hjz4mynxNTtwp94jGORh3f/1G1Y3TSdlfEzLGjiacLjXxej7eP
         wsOl5qzlL/EA/4RwWeo5ecfQuB/hJs47cvFyr0aQvdhi53118q8HnWuLl7Qq97fkPtXj
         tiCXIE9ftxASbuG/FprVTokxMKOL0yLHjTeMF4JtABNK0tpYFZi1wIJJYgFGsbWEzUBf
         snIhZLBOLHbXdHw/Ga8a2856QBBxl0QA7zP20P7vnvRqsR4kQ7GV7ICVw4WQay6YmYKQ
         vhNxLS+XwgpG/kJJSbkMuZPricPMoJFu1+mpkAkFqy/i+Ms2kpzZW7MNazd/91swy80q
         cr0Q==
X-Forwarded-Encrypted: i=1; AHgh+RpTaLm+3W1v6cjmd1E92DUmUZsGoilmAoAwie9qmxSs1O3fy5sEoXctXHw1Mu03PFFrgNmu6lwRntMlbd2QDA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5lh3hYYmka/ZyyzhAKvh3myFu7jAjarrry+4buoONJCrHuZz8
	Ly0dGxXlkwxrG4Hrrkb3V3O1tTAW22OUufa6mJHJam6ZPByI0ODGKpi+
X-Gm-Gg: AR+sD100yY/d3Z7dDA1X84TWXfmXlaTx0Uc+wX97p/nOrzSTAi57058wgOUIj1WYKLE
	h+t9k83uc70C4xZ1ayxecbrw4z8ML64qBR65lXwm2bUvDUQBtUNi4w0YiXadMV7QKU1UMr6UB6S
	r1KHV8AEaoxWIG7E2glXXQqedaSRfXXYNLdQnzmA0bOjpIrZ8le57RwqTNkabjBFPP1Fx2cP7GD
	BRakmJEbnweqgFWg8pc9fvONA3J2NYHumG2uF2NiFh+ycJXZFw2EXym6ZegSOfEACXsfWApzI2o
	kQ0L7hF7x8xQ4v05Qt5R8lb0w2dmR7lwaJdjwNPzRUUFlh3hAwcdDaMA0HBhaIrwHcP7LcPBjjo
	365axEPeduvMWz3+AH92oHJSPDMmUyqiyeAtl/SbtbGWlF1kytBLxVmJCTy15XodgKsdvhSieFu
	3hUdustffl2e2SfrOKXZbMEPnBiRW6zyqowsuS4/e1M3cC6j9XfLJkF5/w5r2b9wvyYIAh6g==
X-Received: by 2002:a05:600c:821b:b0:493:e365:ace9 with SMTP id 5b1f17b1804b1-49978444628mr49218605e9.11.1786448574297;
        Tue, 11 Aug 2026 04:42:54 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5be2aasm3916843f8f.13.2026.08.11.04.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 04:42:53 -0700 (PDT)
Message-ID: <4a6f14e0-1daa-4ac6-af10-988a38b14317@gmail.com>
Date: Tue, 11 Aug 2026 14:42:51 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] wifi: rtw88: fw: handle the RTL8723BS management
 TX reports
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
 linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-5-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260811091203.26841-5-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/08/2026 12:12, luka.gejak@linux.dev wrote:
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
> Without this, testers on ARM SDIO boards see "failed to get tx report
> from firmware" and "firmware failed to leave lps state" once power save
> engages under load.
> 

Please see your reply from July 30 regarding this subject:

https://lore.kernel.org/linux-wireless/20260730060903.30187-2-luka.gejak@linux.dev/

> Reported-by: Peter Robinson <pbrobinson@gmail.com>
> Closes: https://lore.kernel.org/all/CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com/
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 20 ++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/fw.h |  5 +++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 945fedcd375b..c85c0e3e60a9 100644
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
> @@ -365,6 +374,17 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
>  		rtw_coex_info_response(rtwdev, skb);
>  		break;
>  	case C2H_WLAN_RFON:
> +		/*
> +		 * On 8723BS SDIO with v41 firmware, C2H 0x32 carries a scan TX
> +		 * report, not a WLAN_RFON event: defer it to
> +		 * rtw_fw_c2h_cmd_handle().
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
> index 48ad9ceab6ea..bdda78dc6462 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.h
> +++ b/drivers/net/wireless/realtek/rtw88/fw.h
> @@ -54,6 +54,11 @@ enum rtw_c2h_cmd_id {
>  	C2H_BT_MP_INFO = 0x0b,
>  	C2H_BT_HID_INFO = 0x45,
>  	C2H_RA_RPT = 0x0c,
> +	/*
> +	 * 8723BS SDIO vendor v41 firmware management TX report (0x32 is
> +	 * reported as C2H_WLAN_RFON, handled per-chip in the C2H dispatch).
> +	 */
> +	C2H_VENDOR_TX_RPT = 0x12,
>  	C2H_HW_FEATURE_REPORT = 0x19,
>  	C2H_WLAN_INFO = 0x27,
>  	C2H_WLAN_RFON = 0x32,

