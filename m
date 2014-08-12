Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58808 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaHLIDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 04:03:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/6] ath10k: move fw init print
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-7-git-send-email-michal.kazior@tieto.com>
Date: Tue, 12 Aug 2014 10:53:04 +0300
In-Reply-To: <1407402212-29809-7-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:03:32 +0200")
Message-ID: <87ppg6qh3z.fsf@kamboji.qca.qualcomm.com> (sfid-20140812_100317_423521_BFDD43A6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware probing is done only once when driver is
> registered and firmware version is guaranteed to
> remain the same until driver is unregistered.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -816,24 +816,6 @@ int ath10k_core_start(struct ath10k *ar)
>  
>  	INIT_LIST_HEAD(&ar->arvifs);
>  
> -	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
> -		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
> -			    ar->hw_params.name,
> -			    ar->target_version,
> -			    ar->chip_id,
> -			    ar->hw->wiphy->fw_version,
> -			    ar->fw_api,
> -			    ar->htt.target_version_major,
> -			    ar->htt.target_version_minor);
> -		ath10k_info("debug %d debugfs %d tracing %d dfs %d\n",
> -			    config_enabled(CONFIG_ATH10K_DEBUG),
> -			    config_enabled(CONFIG_ATH10K_DEBUGFS),
> -			    config_enabled(CONFIG_ATH10K_TRACING),
> -			    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
> -	}
> -
> -	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);

Doesn't this break this print in pci.c:

        if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
           ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
                                    irq_mode, ath10k_pci_irq_mode,
                                                    ath10k_pci_reset_mode);

-- 
Kalle Valo
