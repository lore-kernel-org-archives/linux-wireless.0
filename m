Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49694 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1KCPwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 11:52:02 -0400
Received: by bke11 with SMTP id 11so1169293bke.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 08:52:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
Date: Thu, 3 Nov 2011 16:51:45 +0100
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201111031651.46073.chunkeey@googlemail.com> (sfid-20111103_165211_510936_052EBF0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, November 03, 2011 02:55:53 PM Zefir Kurtisi wrote:
> This patch integrates the DFS module into ath9k, including
>  * building the module into ath9k_hw
>  * setting up DFS debugfs
>  * defining HW capability flag for DFS support
>  * setting this flag by DFS supporting devices
>    (so far: AR_SREV_9280_20_OR_LATER, TBC)
>  * setting PHYRADAR rx filter flag to enable radar
>    pulse reporting
>  * forward radar PHY errors to dfs module
> 
> This is WIP and at its current stage is limited to test ath9k
> pulse detection capabilities. The DFS pattern matching is
> TBD in the higher layers and is not part of this patch.
> 
> CONFIG_ATH9K_DFS must be set to enable pulse detection.
where? There's no kconfig option, yet it has the CONFIG_ perifx.
So people will be looking for it.

This is exactly why I made such a big fuss about CONFIG_XYZ issue last time.
<http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg06825.html> 
Just drop the ifdef.

> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>  drivers/net/wireless/ath/ath9k/debug.c  |    3 +++
>  drivers/net/wireless/ath/ath9k/debug.h  |    2 ++
>  drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h     |    1 +
>  drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++++++
>  drivers/net/wireless/ath/ath9k/recv.c   |   18 +++++++++++++-----
>  7 files changed, 50 insertions(+), 5 deletions(-)
> 
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2333,6 +2333,18 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>  		pCap->pcie_lcr_offset = 0x80;
>  	}
>  
> +#ifdef CONFIG_ATH9K_DFS
> +	/*
> +	 * enable radar detection on DFS supporting devices
> +	 */
> +	if (AR_SREV_9280_20_OR_LATER(ah)) {
> +		/*
> +		 * TODO: check for which chip-sets we want to support DFS
> +		 */
> +		pCap->hw_caps |= ATH9K_HW_CAP_DFS;
> +	}
> +#endif
> +
>  	tx_chainmask = pCap->tx_chainmask;
>  	rx_chainmask = pCap->rx_chainmask;
>  	while (tx_chainmask || rx_chainmask) {

Regards,
	Chr
