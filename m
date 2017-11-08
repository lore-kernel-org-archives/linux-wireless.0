Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdKHMTg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:19:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 07/11] rtlwifi: rtl_pci: Extend recognized interrupt parameters from two to four ISR
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
        <20171101152926.24971-8-Larry.Finger@lwfinger.net>
Date: Wed, 08 Nov 2017 14:19:31 +0200
In-Reply-To: <20171101152926.24971-8-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Wed, 1 Nov 2017 10:29:22 -0500")
Message-ID: <87r2t9otd8.fsf@purkki.adurom.net> (sfid-20171108_131941_395568_45179465)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> 8822be checks H2CQ by int_d, so we extend to four ISR.
> Also, irq_mask is extended to four.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> @@ -936,7 +937,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>  	rtlpriv->cfg->ops->disable_interrupt(hw);
>  
>  	/*read ISR: 4/8bytes */
> -	rtlpriv->cfg->ops->interrupt_recognized(hw, &inta, &intb);
> +	rtlpriv->cfg->ops->interrupt_recognized(hw, &inta, &intb, &intc, &intd);
>  
>  	/*Shared IRQ or HW disappeared */
>  	if (!inta || inta == 0xffff)
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
> index ce33fe7bc7c4..e7d070e8da2d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
> @@ -211,7 +211,7 @@ struct rtl_pci {
>  
>  	/*irq */
>  	u8 irq_alloc;
> -	u32 irq_mask[2];
> +	u32 irq_mask[4];	/* 0-1: normal, 2: unused, 3: h2c */
>  	u32 sys_irq_mask;
>  
>  	/*Bcn control register setting */
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
> index 2c671364c521..e30a18e64ff5 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
> @@ -1472,7 +1472,8 @@ void rtl88ee_card_disable(struct ieee80211_hw *hw)
>  }
>  
>  void rtl88ee_interrupt_recognized(struct ieee80211_hw *hw,
> -				  u32 *p_inta, u32 *p_intb)
> +				  u32 *p_inta, u32 *p_intb,
> +				  u32 *p_intc, u32 *p_intd)
>  {

In the future you might want to convert this to a struct which is a lot
easier to handle. But no need to resend because of this.

-- 
Kalle Valo
