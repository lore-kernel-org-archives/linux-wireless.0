Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49480 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaCZJWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 05:22:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: split ce initialization and allocation
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
	<1395745943-29492-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Mar 2014 11:22:07 +0200
In-Reply-To: <1395745943-29492-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 25 Mar 2014 12:12:23 +0100")
Message-ID: <87ppl9z54w.fsf@kamboji.qca.qualcomm.com> (sfid-20140326_102217_090316_DB529CB4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Definitions by which copy engine structure are
> allocated do not change so it doesn't make much
> sense to re-create those structures each time
> device is booted (e.g. due to firmware recovery).
>
> This should decrease chance of memory allocation
> failures.
>
> Reported-By: Avery Pennarun <apenwarr@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/ce.h
> +++ b/drivers/net/wireless/ath/ath10k/ce.h
> @@ -104,7 +104,8 @@ struct ath10k_ce_ring {
>  	void *shadow_base_unaligned;
>  	struct ce_desc *shadow_base;
>  
> -	void **per_transfer_context;
> +	/* keep last */
> +	void *per_transfer_context[0];
>  };

If possible, I would prefer to have changes like this in a separate
patch as it makes easier to review. Or at least mention the change in
the commit log.

> @@ -2018,9 +2029,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
>  	ath10k_pci_free_early_irq(ar);
>  	ath10k_pci_kill_tasklet(ar);
>  	ath10k_pci_deinit_irq(ar);
> +	ath10k_pci_ce_deinit(ar);
>  	ath10k_pci_warm_reset(ar);
>  
> -	ath10k_pci_ce_deinit(ar);
>  	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
>  		ath10k_do_pci_sleep(ar);
>  }

Why this?

-- 
Kalle Valo
