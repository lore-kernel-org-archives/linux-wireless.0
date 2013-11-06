Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52575 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab3KFMiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:38:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFT 12/12] ath10k: add some debug prints
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
	<1383133346-8135-13-git-send-email-michal.kazior@tieto.com>
Date: Wed, 6 Nov 2013 14:38:49 +0200
In-Reply-To: <1383133346-8135-13-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 30 Oct 2013 12:42:26 +0100")
Message-ID: <87eh6tso12.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_133858_746883_63538CEE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some errors were handled too silently. Also add a
> print indicating BMI is booted.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  static int ath10k_pci_hif_power_up(struct ath10k *ar)
> @@ -1860,8 +1862,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  		ath10k_do_pci_wake(ar);
>  
>  	ret = ath10k_pci_ce_init(ar);
> -	if (ret)
> +	if (ret) {
> +		ath10k_err("could not initialize CE (%d)\n", ret);

"could not initialize CE: %d\n"

That comment applies to all the error codes printed.

-- 
Kalle Valo
