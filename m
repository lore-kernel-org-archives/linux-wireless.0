Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdJMJ4I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:56:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 03/10] rtlwifi: rtl8192ee: Make driver support 64bits DMA.
References: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
        <20170929194800.15617-4-Larry.Finger@lwfinger.net>
Date: Fri, 13 Oct 2017 12:56:02 +0300
In-Reply-To: <20170929194800.15617-4-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 29 Sep 2017 14:47:53 -0500")
Message-ID: <87mv4vwevh.fsf@purkki.adurom.net> (sfid-20171013_115613_371337_383C9E87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> 1. Both 32-bit and 64-bit use the same TX/RX buffer desc layout
> 2. Extend set_desc() and get_desc() to set and get 64-bit address
> 3. Remove directive DMA_IS_64BIT
> 4. Add module parameter to turn on 64-bit dma
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

I applied this already but I still want to give few general remarks
about frequent problems with rtlwifi patches:

> @@ -691,9 +691,10 @@ static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
>  		return 0;
>  	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
>  	if (rtlpriv->use_new_trx_flow) {
> +		/* skb->cb may be 64 bit address */
>  		rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
>  					    HW_DESC_RX_PREPARE,
> -					    (u8 *)&bufferaddress);
> +					    (u8 *)(dma_addr_t *)skb->cb);

What I see a lot are these very questionable looking use of casts like
here. Casting should be also avoided as much as possible and used only
when it's absolutely necessary. If you have to do (u8) or (u8 *) almost
in every second line something is very wrong.

> +static void platform_enable_dma64(struct pci_dev *pdev, bool dma64)
> +{
> +	u8	value;
> +
> +	pci_read_config_byte(pdev, 0x719, &value);
> +
> +	/* 0x719 Bit5 is DMA64 bit fetch. */
> +	if (dma64)
> +		value |= BIT(5);
> +	else
> +		value &= ~BIT(5);
> +
> +	pci_write_config_byte(pdev, 0x719, value);
> +}

Another gripe I have is about the use of magic values. There always
should be a define/enum with a descriptive name for register addresses
and values.

-- 
Kalle Valo
