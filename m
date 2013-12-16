Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59920 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LPONm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:13:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: split the if_limits and if_comb
References: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 16 Dec 2013 16:13:36 +0200
In-Reply-To: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 10 Dec 2013 16:20:39 +0100")
Message-ID: <87k3f4g9yn.fsf@kamboji.qca.qualcomm.com> (sfid-20131216_151344_759000_869B6F4F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Split the interface limits and inteface combination,
> to reflect the 10.X capabilites (no P2P, no STA and 8 VAP).
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Both patches applied. I did minor changes in patch 1, please double
check:

> @@ -3717,8 +3718,15 @@ int ath10k_mac_register(struct ath10k *ar)
>  	 */
>  	ar->hw->queues = 4;
>  
> -	ar->hw->wiphy->iface_combinations = ath10k_if_comb;
> -	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);
> +	if (!test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
> +
> +		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
> +		ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);
> +
> +	} else {
> +		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
> +		ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_10x_if_comb);
> +	}

I fixed checkpatch warnings here and reversed the test to get rid
unnecessary negation operator.

-- 
Kalle Valo
