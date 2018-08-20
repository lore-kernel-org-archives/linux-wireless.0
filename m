Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbeHTPUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 11:20:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix tx99 with monitor mode interface
References: <20180820093751.63406-1-nbd@nbd.name>
Date: Mon, 20 Aug 2018 15:05:25 +0300
In-Reply-To: <20180820093751.63406-1-nbd@nbd.name> (Felix Fietkau's message of
        "Mon, 20 Aug 2018 11:37:51 +0200")
Message-ID: <87r2itp7ju.fsf@codeaurora.org> (sfid-20180820_140533_068460_3A2E3A98)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> Tx99 is typically configured via a monitor mode interface, which does
> not get added to the driver as a vif. Since the code currently expects
> a configured virtual interface for tx99, enabling tx99 via debugfs fails.
> Since the vif is not needed anyway, remove all checks for it.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

[...]

> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1251,15 +1251,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
>  	struct ath_vif *avp = (void *)vif->drv_priv;
>  	struct ath_node *an = &avp->mcast_node;
>  
> -	mutex_lock(&sc->mutex);
> +	if (IS_ENABLED(CPTCFG_ATH9K_TX99))
> +		return -EOPNOTSUPP;

Obviously this should be CONFIG_ATH9K_TX99, I'll fix that in the pending
branch.

-- 
Kalle Valo
