Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8964 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaI2IYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 04:24:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 07/10] ath10k: add fw-powerup-fail to ethtool stats.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-7-git-send-email-greearb@candelatech.com>
Date: Mon, 29 Sep 2014 11:24:36 +0300
In-Reply-To: <1411507045-18973-7-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 23 Sep 2014 14:17:22
	-0700")
Message-ID: <87a95i3kcb.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_102446_621060_5731CEFC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This gives user-space a normal-ish way to detect that
> firmware has failed to start and that a reboot is
> probably required.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1851,7 +1851,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  			    ret);
>  
>  		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
> -			return ret;
> +			goto out;
>  
>  		ath10k_warn(ar, "trying cold reset\n");
>  
> @@ -1859,11 +1859,17 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  		if (ret) {
>  			ath10k_err(ar, "failed to power up target using cold reset too (%d)\n",
>  				   ret);
> -			return ret;
> +			goto out;
>  		}
>  	}
>  
> -	return 0;
> +out:
> +	/* If we have failed to power-up, it may take a reboot to
> +	 * get the NIC back online.
> +	 * Set flag accordinly so that user-space can know.
> +	 */
> +	ar->fw_powerup_failed = !!ret;
> +	return ret;
>  }

Would it be better to use ATH10K_STATE_WEDGED for this and then just
export the state value to user space? Or should we have two different
states, like FW_WEDGED and HW_WEDGED?

-- 
Kalle Valo
