Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7596 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3KXN7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 08:59:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/8] ath10k: don't consume other's shared interrupts
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
	<1385125518-13461-2-git-send-email-michal.kazior@tieto.com>
Date: Sun, 24 Nov 2013 15:59:49 +0200
In-Reply-To: <1385125518-13461-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Nov 2013 14:05:11 +0100")
Message-ID: <87bo19sxwq.fsf@kamboji.qca.qualcomm.com> (sfid-20131124_150009_540858_3130EC0D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> ath10k assumed all interrupts were directed to it.
> This isn't the case for legacy shared interrupts.
> ath10k consumed interrupts for other devices.
>
> Check device irq status and return IRQ_NONE when
> appropriate.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -2085,6 +2103,9 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
>  	struct ath10k *ar = arg;
>  	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
>  
> +	if (!ath10k_pci_irq_pending(ar))
> +		return IRQ_NONE;
> +
>  	if (ar_pci->num_msi_intrs == 0) {
>  		/*
>  		 * IMPORTANT: INTR_CLR regiser has to be set after

What if you move ath10k_pci_irq_pending() call after
ar_pci->num_msi_intrs == 0 check? That way you could remove the
"ar_pci->num_msi_intrs == 0" check from irq_pending() function.

-- 
Kalle Valo
