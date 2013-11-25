Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18913 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3KYMB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 07:01:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: allow explicit MSI/MSI-X disabling
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
	<1385125518-13461-9-git-send-email-michal.kazior@tieto.com>
Date: Mon, 25 Nov 2013 14:01:53 +0200
In-Reply-To: <1385125518-13461-9-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Nov 2013 14:05:18 +0100")
Message-ID: <871u24ofke.fsf@kamboji.qca.qualcomm.com> (sfid-20131125_130202_338149_57303573)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This can be useful for testing and debugging.
>
> Two new ath10k_pci module options are now available:
>
>  disable_msix - disable just MSI-X
>  disable_msi - disable MSI (along with MSI-X)
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This is useful but I think it's a bit too much to have two more options,
it would be simpler to have just one. Few quick ideas how to do this a
bit differently:

irq_mode: 0 = automatic, 2 = MSI, 1 = legacy

Here the problem is of course that we can't force use of MSI if the host
only supports legacy interrupts, but IMHO that's a minor nuisance and in
that case we should just enable legacy interrupts.

disable_msi: 0x1 = disable MSI-X, 0x2 = disable MSI

Basically this is just your booleans converted to a bitfield.

I vote for irq_mode because I think that's easier for the user to
understand. But I'm sure there is a better way to do this.

> +	if (msix_supported && !ath10k_disable_msix && !ath10k_disable_msi) {
> +		ar_pci->num_msi_intrs = MSI_NUM_REQUEST;
> +		ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
> +		if (ret == 0)
> +			return 0;
> +		if (ret > 0)
> +			pci_disable_msi(ar_pci->pdev);
> +
> +		/* fall-through */
> +	}

If we force some other irq mode than the default it would be good to
have an info print for that.

-- 
Kalle Valo
