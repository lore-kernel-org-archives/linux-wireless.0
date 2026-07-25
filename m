Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797FF3B7B83
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784977691; cv=none; b=Fwe41y3iCZNy3o6AHNUt56eesiKtKS/tpek94NtQki9gk7bwwI2TF7Fdj0onurCs/2V5F1/E/AqapECVc6Om6eMD8+ENQ9f2S/hoC04kr/QAkHfXR6CWkw0m67LM6/UzR3LDF9gCAMmGr/nWkehW5aCEXYGyS9AYBdVYpUuZ7x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784977691; c=relaxed/simple;
	bh=eSNTLm6v9ZwRlI24U2eL1fhUQqXHp0RDZUi2X4BfXuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPi0MooHKH42Bz+23q2MkpONxcS58g5y+SZ01+wVRy9dhBCSbAqzZLyq5+9Q3E2U/74scZJHNRoc9SBFwgD6oo2D5FpEV+ifQLpcClm5RHpYhZHVg+YhxlM+fGkOY5Io+n5W3v+xvfZG7Qwdn6Gsad034rzfLWAIZSMeFP3kibA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+4/nRQz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+4/nRQz"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954d383e64so8062935e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 04:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784977688; x=1785582488; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RkzGUm18zBYfchA5uR342rVkKpX7P8GlAx2TTDiPHdw=;
        b=C+4/nRQzjq/2TE4fcFkOYjJdJGCxs5nhcCKTtyAbkUFOTo1ChiIqnyw51Ar1dzL69j
         dZgM7uh0KmXuNErIEJxeh2UBiRf02krpmb2/bs/d+/byX9R3yJcdkBuj0xmYLJFT5nLy
         8nvicFpp45zQOlLlOBr77LjvPq4AVPyi+a0ChlFgbuVlfG94a7Gyd4MQB2LhEgCl4cn2
         aW/Xmbp1nOcgXqFEwFT6ZSf7BqoTRwYrADCZ4JbSfkSSTsUnAob+c3wfrIHxdZsba8hC
         pNYy2xAxNBEn6s/8qoNQMhbtrfA6+xWYE7RPWifdmzsyNRRM8SEAkiE5Bi4YPKRoPUQ2
         J3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784977688; x=1785582488;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RkzGUm18zBYfchA5uR342rVkKpX7P8GlAx2TTDiPHdw=;
        b=NKA+JXZaaj9DNZQAjTKgfY/dXYussFUz4iZzqX1BjqMVUIA3vTx6VJc9YT8HxZIaPQ
         Qn7M0amIZFDTtmDYSlYEKvKlmZvNC9uqVOpthH/ItqMVCpbgPLqMcoCfyJZ5mDe+DEG6
         a7ylDE7IXImWuEUQwUHNWxoIG3MAiILwZHAGUn2PahG1LIwTraPJRm6Az+6aZ8Tc9tc6
         G9TmbuUIkjQ+szefvmpFdfQAhrevUhjFvj5DYTTiHDniIZV7jHFHDqXExxaCqbWIVMCq
         BQNfEco9tQws2X5LUvu/0FoZbUd2nx9p3iJc1CuWQOx8A+VwHSr5EjdV6Hazw5Axc8mb
         u4RQ==
X-Gm-Message-State: AOJu0YwuWwU6MDH8ASJYUXXtIciM6+E8w4VmX3lm5xhdSBsGypLm0kXu
	f2YQfJDxdndrlQe99XDOvGr+E8BJRD1u/4sU/1PrQ7yaljXMB35UGJ16
X-Gm-Gg: AR+sD11mzNWvgypkRw677WeC3C4HuvuyhgwIBBrTPYMnJgWTeHXWRstRCHMvv9ooxVw
	NNi58u8q8j/+hRW2rGXKF4UEtJZneRQhOcfkTtTTpKkys/G5FPJIAUPAyK1t8QodOq6DwMfJdH7
	zBwct0oeA2et63f1yY2KQQy2j35hX20tBYA9icljE48iXjvAaX3pKGBSDoP94TsIUhHu8/1i34s
	wbgUdmoP5Jz5shOGPcrpTfqNd8rL/UEZf3GgFE2eV02ony57zLkDlh65zPPtfwEzMQCttd+m3cV
	djcHYCsPj4pHXzg6bpSR/aRwz3mGm4iuxyjd8NWGaUYnuSI8NeFFa5edEP1Zt8bp+hUFkqcxBM1
	UsdpNAWFoywhnge1RAfZmFFbvDqGV+3Bh5yI0r4QuhAu1sQETyHt19xIKAjmfMFUwU49U/2Wue0
	jRP/XGoTGZ
X-Received: by 2002:a05:600c:c16d:b0:493:f822:ac5e with SMTP id 5b1f17b1804b1-496b56f1308mr22791375e9.23.1784977687443;
        Sat, 25 Jul 2026 04:08:07 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b49a5f98sm62973655e9.12.2026.07.25.04.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 04:08:07 -0700 (PDT)
Message-ID: <51ca65e1-93ed-461a-99ff-2e72488a3a6e@gmail.com>
Date: Sat, 25 Jul 2026 14:08:05 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/19] wifi: rtw88: sdio: handle the RTL8723BS management
 TX path
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183225.196856-1-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724183225.196856-1-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:32, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> Management and beacon frames on this chip go to the high queue rather
> than the extra one, and their descriptor has to sit at a fixed offset,
> which means the skb payload must be aligned before the descriptor is
> pushed instead of inserting padding after it. Doing the alignment can
> fail, so the prepare path now reports an error rather than returning
> void.
> 
> The vendor descriptor also leaves SW_DEFINE and the sequence number at
> zero for management frames, so there is no key to match an asynchronous
> C2H report against. Follow the vendor dump_mgntframe_and_wait() path and
> report completion at DMA completion for those frames, leaving data
> frames on the normal TX report queue. Record the descriptor offset per
> frame so the skb is unwound correctly on completion.
> 

Sequence numbers work for the other chips. Have you tried it?

> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 131 +++++++++++++++++-----
>  drivers/net/wireless/realtek/rtw88/sdio.h |   2 +
>  2 files changed, 104 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
> index adf0b509e2cc..fcbb0ee601c1 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -480,8 +480,14 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
>  		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
>  				    REG_SDIO_CMD_ADDR_TXFF_HIGH);
>  		break;
> -	case RTW_TX_QUEUE_VI:
>  	case RTW_TX_QUEUE_VO:
> +		if (rtw_is_8723bs(rtwdev)) {
> +			txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
> +					    REG_SDIO_CMD_ADDR_TXFF_HIGH);
> +			break;
> +		}
> +		fallthrough;
> +	case RTW_TX_QUEUE_VI:
>  		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
>  				    REG_SDIO_CMD_ADDR_TXFF_NORMAL);
>  		break;
> @@ -492,6 +498,8 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
>  		break;
>  	case RTW_TX_QUEUE_MGMT:
>  		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
> +				    rtw_is_8723bs(rtwdev) ?
> +				    REG_SDIO_CMD_ADDR_TXFF_HIGH :
>  				    REG_SDIO_CMD_ADDR_TXFF_EXTRA);
>  		break;
>  	default:
> @@ -765,12 +773,24 @@ static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queue,
>  	}
>  }
>  
> +static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +
> +	BUILD_BUG_ON(sizeof(struct rtw_sdio_tx_data) >
> +		     sizeof(info->status.status_driver_data));
> +
> +	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
> +}
> +
>  static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
>  			       enum rtw_tx_queue_type queue)
>  {
>  	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> +	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
>  	unsigned int orig_len = skb->len;
>  	bool rtl8723bs = rtw_is_8723bs(rtwdev);
> +	bool quiet = rtl8723bs && tx_data->is_mgmt;
>  	unsigned int pages;
>  	bool bus_claim;
>  	size_t txsize;
> @@ -825,6 +845,8 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
>  	if (bus_claim)
>  		sdio_release_host(rtwsdio->sdio_func);
>  
> +	if (!ret && quiet)
> +		usleep_range(1000, 2000);
>  	if (!ret && rtl8723bs) {
>  		pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
>  		rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
> @@ -1032,52 +1054,82 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
>  	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
>  }
>  
> -static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
> +static int rtw_sdio_align_tx_skb(struct sk_buff *skb, unsigned int headroom)
>  {
> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	unsigned int misalign, needed;
> +	int ret;
>  
> -	BUILD_BUG_ON(sizeof(struct rtw_sdio_tx_data) >
> -		     sizeof(info->status.status_driver_data));
> +	misalign = (unsigned long)skb->data & (RTW_SDIO_DATA_PTR_ALIGN - 1);
> +	if (!misalign)
> +		return 0;
>  
> -	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
> +	needed = headroom + RTW_SDIO_DATA_PTR_ALIGN - 1;
> +	if (skb_headroom(skb) < needed) {
> +		ret = pskb_expand_head(skb, needed - skb_headroom(skb), 0,
> +				       GFP_KERNEL);
> +		if (ret)
> +			return ret;
> +
> +		misalign = (unsigned long)skb->data &
> +			   (RTW_SDIO_DATA_PTR_ALIGN - 1);
> +		if (!misalign)
> +			return 0;
> +	}
> +
> +	needed = headroom + misalign;
> +	if (skb_headroom(skb) < needed)
> +		return -ENOSPC;
> +
> +	skb_push(skb, misalign);
> +	memmove(skb->data, skb->data + misalign, skb->len - misalign);
> +	skb_trim(skb, skb->len - misalign);
> +
> +	return 0;
>  }
>  
> -static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
> -				    struct rtw_tx_pkt_info *pkt_info,
> -				    struct sk_buff *skb,
> -				    enum rtw_tx_queue_type queue)
> +static int rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
> +				   struct rtw_tx_pkt_info *pkt_info,
> +				   struct sk_buff *skb,
> +				   enum rtw_tx_queue_type queue)
>  {
>  	const struct rtw_chip_info *chip = rtwdev->chip;
>  	unsigned long data_addr, aligned_addr;
> +	bool fixed_8723bs_offset;
>  	size_t offset;
>  	u8 *pkt_desc;
> +	int ret;
> +
> +	fixed_8723bs_offset = rtw_is_8723bs(rtwdev) &&
> +			      (queue == RTW_TX_QUEUE_MGMT ||
> +			       queue == RTW_TX_QUEUE_BCN);
> +
> +	if (fixed_8723bs_offset) {
> +		ret = rtw_sdio_align_tx_skb(skb, chip->tx_pkt_desc_sz);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
>  
>  	data_addr = (unsigned long)pkt_desc;
>  	aligned_addr = ALIGN(data_addr, RTW_SDIO_DATA_PTR_ALIGN);
>  
> -	if (data_addr != aligned_addr) {
> +	if (!fixed_8723bs_offset && data_addr != aligned_addr) {
>  		/* Ensure that the start of the pkt_desc is always aligned at
>  		 * RTW_SDIO_DATA_PTR_ALIGN.
>  		 */
>  		offset = RTW_SDIO_DATA_PTR_ALIGN - (aligned_addr - data_addr);
> -
>  		pkt_desc = skb_push(skb, offset);
> -
> -		/* By inserting padding to align the start of the pkt_desc we
> -		 * need to inform the firmware that the actual data starts at
> -		 * a different offset than normal.
> -		 */
>  		pkt_info->offset += offset;
> +		memset(pkt_desc + chip->tx_pkt_desc_sz, 0, offset);
>  	}
>  
>  	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
> -
>  	pkt_info->qsel = rtw_sdio_get_tx_qsel(rtwdev, skb, queue);
> -
>  	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
>  	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
> +
> +	return 0;
>  }
>  
>  static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
> @@ -1087,9 +1139,10 @@ static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
>  {
>  	int ret;
>  
> -	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
> -
> -	ret = rtw_sdio_write_port(rtwdev, skb, queue);
> +	memset(rtw_sdio_get_tx_data(skb), 0, sizeof(struct rtw_sdio_tx_data));
> +	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
> +	if (!ret)
> +		ret = rtw_sdio_write_port(rtwdev, skb, queue);
>  	dev_kfree_skb_any(skb);
>  
>  	return ret;
> @@ -1127,11 +1180,22 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
>  	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
>  	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
>  	struct rtw_sdio_tx_data *tx_data;
> -
> -	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
> +	int ret;
>  
>  	tx_data = rtw_sdio_get_tx_data(skb);
> +	memset(tx_data, 0, sizeof(*tx_data));
> +	if (skb->len >= sizeof(struct ieee80211_hdr_3addr)) {
> +		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +
> +		tx_data->is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
> +	}
> +
> +	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
> +	if (ret)
> +		return ret;
> +
>  	tx_data->sn = pkt_info->sn;
> +	tx_data->tx_pkt_offset = pkt_info->offset;
>  
>  	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
>  
> @@ -1410,11 +1474,20 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
>  	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  	struct ieee80211_hw *hw = rtwdev->hw;
> -
> -	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
> -
> -	/* enqueue to wait for tx report */
> -	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> +	u8 tx_pkt_offset = tx_data->tx_pkt_offset;
> +
> +	if (!tx_pkt_offset)
> +		tx_pkt_offset = rtwdev->chip->tx_pkt_desc_sz;
> +	skb_pull(skb, tx_pkt_offset);
> +
> +	/* The RTL8723BS vendor descriptor uses SW_DEFINE/sn=0 for management
> +	 * frames, so there is no unique key for matching asynchronous C2H TX
> +	 * reports. Report completion at SDIO DMA completion, as the vendor
> +	 * dump_mgntframe_and_wait() path does; data frames keep the normal C2H
> +	 * report queue.
> +	 */
> +	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS &&
> +	    !(rtw_is_8723bs(rtwdev) && tx_data->is_mgmt)) {
>  		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
>  		return;
>  	}
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
> index 12086f1aa280..aa088c512b9c 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.h
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.h
> @@ -140,6 +140,8 @@ struct sdio_device_id;
>  
>  struct rtw_sdio_tx_data {
>  	u8 sn;
> +	u8 tx_pkt_offset;
> +	bool is_mgmt;
>  };
>  
>  struct rtw_sdio_work_data {

