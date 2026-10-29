Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275534;
	b=0GeU1haAQrtovp14Ngguvyx+f54UIHHyTY4XBqz5hA/7tqCGE3T740JY1W1mzRoFU3gB
	 /kf/e3yGDeDKb51vjygM+ovzAynnCgGA3vIoRUWbANqSMubgwMcDh6rFSdtV3ZiFqEENX
	 0fXk6qDtiTCi+wjPb0U7OmADYCJV/ipzFcHb+oCYQnPSPnrDKnIeUy9DvWYeuaJgEg89G
	 cQkk3mIgz2k2Yih7YBeEj7R9+k+Za80grl6itLz8X5DqCZ3NJEsjJSPawERnhIP4UgsFv
	 BtRiZda2U7volM6XMsJf6Cr3rrtRT/lcvbNn8KouDO+s/FHIHf92BBFqUpoPtf8Qm3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275534;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=n9mFEwFFpO19su1Su2/dD/jfL6JPiT+hq1VHmN7QHew=;
	b=etyzRUld63HSJ4+h21N7oAr6Mg3hkLq/c6L821LCRhqOLuSZcyEGHBbfCZQC9guchziL
	 51pRi4q64vrxjTYVtgOv/mjrr4JnGgdifwyAQTMRZQY/tRRjPF0dMW5cctcOQS+FXKNEM
	 6A1ubx6fWuEi8yo/YexI00r2DRfK1cRkLxqbLBsqUKkPjPaaqEQU8Nepu8C18RkE9gIzk
	 CFGUC/ZP7KTE7cjEx979sGcRo4yReQneS4tSIxkNauihHfDaGInCyXreR4IepM5PTEgP/
	 5oTqmnl8GYHPs4Gk2h2qh2EQ3WrIWnDwGQxShPzO+IviRNlj569ZSnhvE/fL7G/olgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U7aSJfER;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0B606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 12:05:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09A0B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U7aSJfER
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so8950035e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793275532; x=1793880332; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n9mFEwFFpO19su1Su2/dD/jfL6JPiT+hq1VHmN7QHew=;
        b=U7aSJfERfMma3anexYCQa1XKBhFizSuO9RH2R3Y5plWsRcRuHw+S05bXxWsNMNawsE
         BALGOypIGYvtAtuJAWOKFkbhvZ+pDp75Lc9QJy/jbd4gMpNIXYuZg0vk0BZ9ypK/TR8H
         84vRyf2EYzvOOMpMEK8A5w2M3M4H5Sbi6JChHjB33H1n1QLMTDzAQNRVpFR3Ji/wACQ7
         4JDU/X/UuSPCs9pRPg+uyvWtfG5wxV6TQsot+BQcy6Nte44Zkbf4XK4WEcIxMcjQbrPO
         vnIK5s3mzljeQ3PnpZRMF96NQOPxchDvxuo7gcncWT3Igk+FzQwmWuEHprW+l0ygvDEX
         1Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793275532; x=1793880332;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n9mFEwFFpO19su1Su2/dD/jfL6JPiT+hq1VHmN7QHew=;
        b=ZjJ83yxBixEV0Pk7HQB4cDz9h3+mJ+/ZhUYHyBSYSw9iM3PKIm1WgvRdWJVq5JxriZ
         IhG0kmd2qlOLaEVVzcgFf/ItfLb21bOuHKwOOkpbecYA1UOEYvHGHlScSaotldOeIGAY
         IT3pA/4BVwvGL6vuF9w2HH3/UYstiU5HtIvwghHe+MV2tX1muI/Gc8hoPazKSlBEBT+9
         9MxXCs1xWUarZzefXLqfBJ576n9XxWgj1JCqpAtZGz31PQDvPZ10ZQ4jp8dlSSLXs7fQ
         cNLYtv4FjENl6yuuiEwev2SPVb2ZNXuxlaXUfsVvHrzutu12hNc9O8FZmjzyMSTk7epW
         xfSg==
X-Gm-Message-State: AFq9FYLYh8hXDv4qt3bAE/miTVFUbrrukU0+bM9vznBx/83el9gSarrR
	2fzMt4CTrFTNCUtC5B1uCGS7XQPLRgiPgHkQVkouiljTQdu223MBUqudnmoH1w==
X-Gm-Gg: AYBFou1iBz2ndCg93gQaIc59MQNH9hw5oZK4y6eQQyaiRvYD2GMf+/L/VRyCKMUKIZn
	/11aqE72XlDKWdEPLhXGJP6vKUyYBI1/k+JOGZVte+B86Xoy8DUcr/7t2J3p66FSGyX+IwWthvh
	mDBjbfEOal0iGwJGleTlTMiGGEzPKxHbqXSk1Rmaj7F5YqflxaGoGXkkULTRmkjiNrxnI1lB0z6
	HNEdjt4PQ1nMJ0gc0w+/oHllBBp5+CMm02VEJ/3XJK6/DCzrX8tACh+AMz105Roz8ZqqLKV4qYr
	XL+oWgXGds1gV5xtbq1GUtIsTJ6YBmW1ZXYDv0bRfxuYgHh+5AhBfzeWlyGOzQVocKXGS17Hspo
	mB7jkH8lCTTANAFuhwlnwpt3BAnzk8udNm7LTZX/nQj6JzswnUZk6CiSbc4SXKQrocRF3QCkYPz
	4Gsbw1mTuNV4iJw6NmiooR8+3sySKUe8VutyVU0r+VeOGVsYLQMXZTlL8LmORIDFu47TvRhV9Qc
	JqtVO1uX82VfMceGGPRxcr3Z11JeUen9omanaq1L54skFHk44KpTieO1bErR085RMDjNrvEOrOy
	J9sBO/XN0PuZ6w5XNNTDzKgzfdnMBiPE5cBi
X-Received: by 2002:a05:600c:621a:b0:4a2:10f9:37db with SMTP id 5b1f17b1804b1-4aa871e8be0mr58934595e9.7.1793275532308;
        Thu, 29 Oct 2026 05:05:32 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80286fc6sm69394975e9.15.2026.10.29.05.05.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 05:05:31 -0700 (PDT)
Message-ID: <f74e2efb-561a-4327-9942-e6f014c99264@gmail.com>
Date: Thu, 29 Oct 2026 14:05:30 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] wifi: rtw88: allow driver-owned TX buffers to bypass
 mac80211 TX status
To: linux-wireless@vger.kernel.org
References: <20261029060859.90002-1-hjf3108@gmail.com>
 <20261029060859.90002-2-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261029060859.90002-2-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2026 08:08, Ho Jie Feng wrote:
> Add a flag so that the driver can flag certain frames that
> skip reporting back to mac80211. This is used for driver
> generated frames that aren't a TX from mac80211.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.h | 1 +
>  drivers/net/wireless/realtek/rtw88/pci.c  | 6 ++++++
>  drivers/net/wireless/realtek/rtw88/pci.h  | 1 +
>  drivers/net/wireless/realtek/rtw88/sdio.c | 6 ++++++
>  drivers/net/wireless/realtek/rtw88/sdio.h | 1 +
>  drivers/net/wireless/realtek/rtw88/usb.c  | 6 ++++++
>  drivers/net/wireless/realtek/rtw88/usb.h  | 1 +
>  7 files changed, 22 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index d59f6e323adf0..7bd2e224e845b 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -637,6 +637,7 @@ struct rtw_tx_pkt_info {
>  	u8 hw_ssn_sel;
>  	bool nav_use_hdr;
>  	bool bt_null;
> +	bool drv_frame;

This is always false. Why add it?

>  };
>  
>  struct rtw_rx_pkt_stat {
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index 66d2e5f514447..5f6df521e9c16 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -848,6 +848,7 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
>  	tx_data = rtw_pci_get_tx_data(skb);
>  	tx_data->dma = dma;
>  	tx_data->sn = pkt_info->sn;
> +	tx_data->drv_frame = pkt_info->drv_frame;
>  
>  	spin_lock_bh(&rtwpci->irq_lock);
>  
> @@ -992,6 +993,11 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
>  
>  		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
>  
> +		if (tx_data->drv_frame) {

This is always false.

> +			dev_kfree_skb_irq(skb);
> +			continue;
> +		}
> +
>  		info = IEEE80211_SKB_CB(skb);
>  
>  		/* enqueue to wait for tx report */
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
> index 8ffdea11378f0..37d90caf8269c 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.h
> +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> @@ -171,6 +171,7 @@ struct rtw_pci_tx_buffer_desc {
>  struct rtw_pci_tx_data {
>  	dma_addr_t dma;
>  	u8 sn;
> +	bool drv_frame;
>  };
>  
>  struct rtw_pci_ring {
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
> index dc2fd0f8f9fff..6666aa5245d70 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -1312,6 +1312,7 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
>  
>  	tx_data = rtw_sdio_get_tx_data(skb);
>  	tx_data->sn = pkt_info->sn;
> +	tx_data->drv_frame = pkt_info->drv_frame;
>  
>  	/* The TX worker may already have freed the skb, so do not touch it. */
>  	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
> @@ -1604,6 +1605,11 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
>  
>  	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
>  
> +	if (tx_data->drv_frame) {

This is always false.

> +		dev_kfree_skb_any(skb);
> +		return;
> +	}
> +
>  	/* enqueue to wait for tx report */
>  	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
>  		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
> index 6e7e6009744b0..19852077326a4 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.h
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.h
> @@ -153,6 +153,7 @@ struct sdio_device_id;
>  
>  struct rtw_sdio_tx_data {
>  	u8 sn;
> +	bool drv_frame;
>  };
>  
>  struct rtw_sdio_work_data {
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 715a2ce342d92..f03b00e517576 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -342,6 +342,11 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
>  
>  		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
>  
> +		if (tx_data->drv_frame) {
> +			dev_kfree_skb_any(skb);
> +			continue;
> +		}
> +
>  		/* enqueue to wait for tx report */
>  		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
>  			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> @@ -655,6 +660,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
>  	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
>  	tx_data = rtw_usb_get_tx_data(skb);
>  	tx_data->sn = pkt_info->sn;
> +	tx_data->drv_frame = pkt_info->drv_frame;
>  
>  	skb_queue_tail(&rtwusb->tx_queue[ep], skb);
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
> index 94ff21dd08463..e861e9a66ab22 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.h
> +++ b/drivers/net/wireless/realtek/rtw88/usb.h
> @@ -59,6 +59,7 @@ struct rx_usb_ctrl_block {
>  
>  struct rtw_usb_tx_data {
>  	u8 sn;
> +	bool drv_frame;
>  };
>  
>  struct rtw_usb {

