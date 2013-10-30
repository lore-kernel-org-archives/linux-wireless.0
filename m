Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:51109 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752040Ab3J3RQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 13:16:48 -0400
Message-ID: <1383153399.9435.33.camel@joe-AO722> (sfid-20131030_181654_093339_2AD6DD26)
Subject: Re: [PATCH/RFT 12/12] ath10k: add some debug prints
From: Joe Perches <joe@perches.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	greearb@candelatech.com
Date: Wed, 30 Oct 2013 10:16:39 -0700
In-Reply-To: <1383133346-8135-13-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
	 <1383133346-8135-13-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-30 at 12:42 +0100, Michal Kazior wrote:
> Some errors were handled too silently.

These aren't really debug prints.

> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
[]
> @@ -1860,8 +1862,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  		ath10k_do_pci_wake(ar);
>  
>  	ret = ath10k_pci_ce_init(ar);
> -	if (ret)
> +	if (ret) {
> +		ath10k_err("could not initialize CE (%d)\n", ret);

Rather than try to reinterpret the function name,
perhaps it's better to simply emit the function name
as is done most other places like:

		ath10k_err("ath10k_pci_ce_init failed: (%d)\n", ret);


> @@ -1876,16 +1880,22 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  	}
>  
>  	ret = ath10k_pci_wait_for_target_init(ar);
> -	if (ret)
> +	if (ret) {
> +		ath10k_err("failed to wait for target to init (%d)\n", ret);
>  		goto err_irq;
> +	}

Like this one, because the function did wait,
but the init was unsuccessful.


