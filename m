Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25580 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JUGaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 02:30:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: remove P2P from supported interface modes for 10.X FW
References: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 21 Oct 2013 09:30:06 +0300
In-Reply-To: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 18 Oct 2013 12:07:57 +0200")
Message-ID: <87mwm3uoep.fsf@kamboji.qca.qualcomm.com> (sfid-20131021_083032_790521_48368974)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> FW 10.X does not support P2P, stop advertising it to mac80211.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

> @@ -3478,7 +3504,11 @@ int ath10k_mac_register(struct ath10k *ar)
>  	 */
>  	ar->hw->queues = 4;
>  
> -	ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
> +	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
> +		ar->hw->wiphy->iface_combinations = &ath10k_10x_if_comb;
> +	else
> +		ar->hw->wiphy->iface_combinations = &ath10k_if_comb;

I think it would be better to have a separate feature flag for this,
like NO_P2P or something like that. Just in case we want to disable P2P
in other firmware branches.

-- 
Kalle Valo
