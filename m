Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61303 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab1FQPYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:24:33 -0400
Received: by vws1 with SMTP id 1so2018165vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 08:24:32 -0700 (PDT)
Message-ID: <4DFB71AC.7040604@lwfinger.net> (sfid-20110617_172435_854936_05EDAC20)
Date: Fri, 17 Jun 2011 10:24:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] rtlwifi: rtl8192{ce,cu,se}: Remove irq_enabled flag
References: <4DF93EBF.1070008@ring3k.org>
In-Reply-To: <4DF93EBF.1070008@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 06:22 PM, Mike McCormack wrote:
> This should be unnecessary if synchronize_irq is used.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/pci.c           |    3 ---
>   drivers/net/wireless/rtlwifi/pci.h           |    1 -
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 --
>   drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    9 ---------
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |    4 ----
>   5 files changed, 0 insertions(+), 19 deletions(-)

I am still testing this change; however, I must NACK it on a technicality. 
Driver rtl8192de, which is in the pipeline, will fail to compile if irq_enabled 
is removed from the rtl_pci struct now. In V2, please do not remove this member. 
When the dust clears, I will fix rtl8192de and remove the variable.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index cb4e5e8..d4c2da8 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -794,9 +794,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
>   	u32 inta = 0;
>   	u32 intb = 0;
>
> -	if (rtlpci->irq_enabled == 0)
> -		return IRQ_HANDLED;
> -
>   	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
>
>   	/*read ISR: 4/8bytes */
> diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
> index 671b1f5..12a25c5 100644
> --- a/drivers/net/wireless/rtlwifi/pci.h
> +++ b/drivers/net/wireless/rtlwifi/pci.h
> @@ -169,7 +169,6 @@ struct rtl_pci {
>   	bool first_init;
>   	bool being_init_adapter;
>   	bool init_ready;
> -	bool irq_enabled;

Do not remove this yet.
