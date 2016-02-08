Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35219 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbcBHVoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 16:44:54 -0500
Received: by mail-oi0-f66.google.com with SMTP id x194so150856oia.2
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 13:44:54 -0800 (PST)
Subject: Re: [PATCH 2/2] rtlwifi: Remove unnecessary synchronize_irq() before
 free_irq()
To: Lars-Peter Clausen <lars@metafoo.de>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1454964073-25108-1-git-send-email-lars@metafoo.de>
 <1454964073-25108-2-git-send-email-lars@metafoo.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56B90C53.3070204@lwfinger.net> (sfid-20160208_224458_928682_AC461B58)
Date: Mon, 8 Feb 2016 15:44:51 -0600
MIME-Version: 1.0
In-Reply-To: <1454964073-25108-2-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2016 02:41 PM, Lars-Peter Clausen wrote:
> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered, on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.
>
> Patch was generated using the following semantic patch:
> // <smpl>
> @@
> expression irq;
> @@
> -synchronize_irq(irq);
>   free_irq(irq, ...);
> // </smpl>
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>   drivers/net/wireless/realtek/rtlwifi/pci.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 7f471bf..140d254 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -2392,7 +2392,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
>   	rtlpriv->cfg->ops->deinit_sw_vars(hw);
>
>   	if (rtlpci->irq_alloc) {
> -		synchronize_irq(rtlpci->pdev->irq);
>   		free_irq(rtlpci->pdev->irq, hw);
>   		rtlpci->irq_alloc = 0;
>   	}
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Makes sense to me.

Thanks,

Larry

