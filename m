Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24027 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3G3Sfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 14:35:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move irq setup
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 30 Jul 2013 21:35:39 +0300
In-Reply-To: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Jul 2013 08:39:32 +0200")
Message-ID: <87d2pzuc90.fsf@kamboji.qca.qualcomm.com> (sfid-20130730_203550_919820_DD00EBCF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There was a slight race during PCI shutdown. Since
> interrupts weren't really stopped (only Copy
> Engine interrupts were disabled through device hw
> registers) it was possible for a firmware
> indication (crash) interrupt to come in after
> tasklets were synced/killed. This would cause
> memory corruption and a panic in most cases. It
> was also possible for interrupt to come before CE
> was initialized during device probing.
>
> Interrupts are required for BMI phase so they are enabled as soon as
> power_up() is called but are freed upon both power_down() and stop()
> so there's asymmetry here. As by design stop() cannot be followed by
> start() it is okay. Both power_down() and stop() should be merged
> later on to avoid confusion.

Why are the interrupts freed both in power_down() and stop()? I don't
get that.

What if we call disable_irq() in power_down() instead?

> Before this can be really properly fixed var/hw
> init code split is necessary.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> Please note: this is based on my (still under
> review at the time of posting) previous patchests:
> device setup refactor and recovery.
>
> I'm posting this before those patchsets are merged
> so anyone interested in testing this fix (I can't
> reproduce the problem on my setup) can give it a
> try.

This was reported by Ben, right? So this sould have a Reported-by line
attributing him.

> @@ -1783,16 +1792,24 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>  	return 0;
>  
>  err_ce:
> +	/* XXX: Until var/hw init is split it's impossible to fix the ordering
> +	 * here so we must call stop_intr() here too to prevent interrupts after
> +	 * CE is teared down. It's okay to double call the stop_intr()
> */

"FIXME:"

>  exit:
> +	ar_pci->intr_started = ret == 0;

A bit too clever for the sake of readibility for my taste, but I guess
it's ok.

> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -198,6 +198,7 @@ struct ath10k_pci {
>  	 * interrupts.
>  	 */
>  	int num_msi_intrs;
> +	bool intr_started;

Adding a new state variable makes me worried. I really would prefer a
solution which would not require that.

Also if we call request_irq() in ath10k_pci_probe() we should also call
free_irq() in ath10k_pci_remove() for symmetry. Just doing a temporary
hack will most likely stay forever :)

-- 
Kalle Valo
