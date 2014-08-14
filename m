Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32737 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaHNMFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 08:05:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath10k: rework posting pci rx buffers
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
	<1407402308-29899-2-git-send-email-michal.kazior@tieto.com>
Date: Thu, 14 Aug 2014 15:05:07 +0300
In-Reply-To: <1407402308-29899-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:05:04 +0200")
Message-ID: <87oavnmg3w.fsf@kamboji.qca.qualcomm.com> (sfid-20140814_140521_847910_53D3E747)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was possible on a host system running low on
> memory to end up with no rx buffers on pci pipes.
>
> This also cleans up the code a bit and, as a side
> effect, makes it possible to call
> ath10k_hif_start() more than once.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

The rework is relatively big so it would be good to have a short
overview how you change it.

> +static void ath10k_pci_rx_replenish(struct ath10k_pci_pipe *pipe)
> +{
> +	struct ath10k *ar = pipe->hif_ce_state;
> +	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
> +	int ret;
> +
> +	spin_lock_bh(&ar_pci->ce_lock);
> +	ret = __ath10k_pci_rx_post_pipe(pipe);
> +	spin_unlock_bh(&ar_pci->ce_lock);
> +
> +	if (ret) {
> +		ath10k_warn("failed to replenish pci rx pipe %d: %d, arming retry timer\n",
> +			    pipe->pipe_num, ret);
> +		mod_timer(&ar_pci->rx_replenish_retry,
> +			  ATH10K_PCI_RX_REPLENISH_RETRY_MS);
> +	}
> +}

Buildbot sent a warning about this one which I think is valid:

drivers/net/wireless/ath/ath10k/pci.c:380 ath10k_pci_rx_replenish() warn: mod_timer() takes an absolute \
time not an offset.

-- 
Kalle Valo
