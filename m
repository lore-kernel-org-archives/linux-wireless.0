Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2556 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754037AbcKOOyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:54:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Move generic entries below specific ones in
 ath_pci_id_table.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <ath9k-patch-20161003@vittgam.net>
References: <ath9k-patch-20161003@vittgam.net>
To: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
CC: <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <4e23eb6c1bcd430faab4591325a81cff@euamsexm01a.eu.qualcomm.com> (sfid-20161115_155407_817085_2F86FA6F)
Date: Tue, 15 Nov 2016 15:53:58 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Vittorio Gambaletta \(VittGam\)" <linux-wireless@vittgam.net> wrote:
> If generic entries are positioned above specific ones, then the
> former will be matched first and used instead of the latter.
> 
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <ath9k-devel@qca.qualcomm.com>
> Cc: <ath9k-devel@lists.ath9k.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -26,7 +26,6 @@
>  	{ PCI_VDEVICE(ATHEROS, 0x0023) }, /* PCI   */
>  	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCI-E */
>  	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
> -	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
>  
>  #ifdef CONFIG_ATH9K_PCOEM
>  	/* Mini PCI AR9220 MB92 cards: Compex WLM200NX, Wistron DNMA-92 */
> @@ -37,7 +36,7 @@
>  	  .driver_data = ATH9K_PCI_LED_ACT_HI },
>  #endif
>  
> -	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
> +	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
>  
>  #ifdef CONFIG_ATH9K_PCOEM
>  	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
> @@ -85,7 +84,11 @@
>  			 0x10CF, /* Fujitsu */
>  			 0x1536),
>  	  .driver_data = ATH9K_PCI_D3_L1_WAR },
> +#endif
>  
> +	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
> +
> +#ifdef CONFIG_ATH9K_PCOEM
>  	/* AR9285 card for Asus */
>  	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
>  			 0x002B,

Patch applied to ath-next branch of ath.git, thanks.

79e57dd113d3 ath9k: Really fix LED polarity for some Mini PCI AR9220 MB92 cards.

-- 
https://patchwork.kernel.org/patch/9360361/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
