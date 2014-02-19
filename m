Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34484 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaBSO4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:56:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 4/7] ath10k: bypass htc for htt tx path
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-5-git-send-email-michal.kazior@tieto.com>
Date: Wed, 19 Feb 2014 16:56:12 +0200
In-Reply-To: <1392629563-31046-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 17 Feb 2014 10:32:40 +0100")
Message-ID: <87ppmjxib7.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_155621_814828_9E61EB11)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Going through full HTC tx path for HTT tx is a
> waste of resources. By skipping it it's possible
> to easily submit scatter-gather to the PCI HIF for
> reduced host CPU load and improved performance.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

For a change like this the commit log needs to be more descriptive.
There's no mention about dma pools, nothing about the basic principle
how this works now etc.

> @@ -1067,9 +1067,9 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
>  	 *
>  	 * For the lack of a better place do the check here.
>  	 */
> -	BUILD_BUG_ON(TARGET_NUM_MSDU_DESC >
> +	BUILD_BUG_ON(2*TARGET_NUM_MSDU_DESC >
>  		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
> -	BUILD_BUG_ON(TARGET_10X_NUM_MSDU_DESC >
> +	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
>  		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
>  
>  	ret = ath10k_pci_wake(ar);
> diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
> index 322e929..8eb7f99 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.h
> +++ b/drivers/net/wireless/ath/ath10k/ce.h
> @@ -23,7 +23,7 @@
>  
>  /* Maximum number of Copy Engine's supported */
>  #define CE_COUNT_MAX 8
> -#define CE_HTT_H2T_MSG_SRC_NENTRIES 2048
> +#define CE_HTT_H2T_MSG_SRC_NENTRIES 4096

Also document why you do these changes.

-- 
Kalle Valo
