Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48078 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaHMOJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 10:09:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] ath10k: remove early irq handling
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-4-git-send-email-michal.kazior@tieto.com>
Date: Wed, 13 Aug 2014 17:09:45 +0300
In-Reply-To: <1407402260-29854-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:04:18 +0200")
Message-ID: <878umspjkm.fsf@kamboji.qca.qualcomm.com> (sfid-20140813_161004_454301_2D8A3925)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It's not really necessary to have a dedicated irq
> handler just for the sake of catching early fw
> crashes. It is now safe to use one handler even
> during early stages of device boot up.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Nice, this really needs to be cleaned up.

>  drivers/net/wireless/ath/ath10k/pci.c | 160 ++++++++--------------------------
>  1 file changed, 36 insertions(+), 124 deletions(-)

Shouldn't you also remove early_irq_tasklet from struct ath10k_pci?

> -static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
> +static bool ath10k_pci_fw_crashed(struct ath10k *ar)
>  {
> -	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
> -	u32 fw_indicator;
> -
> -	fw_indicator = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
> -
> -	if (fw_indicator & FW_IND_EVENT_PENDING) {
> -		/* ACK: clear Target-side pending event */
> -		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
> -				   fw_indicator & ~FW_IND_EVENT_PENDING);
> +	return ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
> +	       FW_IND_EVENT_PENDING;
> +}

Hehe, in Ben's firmware crash dump patches I renamed
ath10k_pci_hif_dump_area() to ath10k_pci_firmware_crashed(). So we now
have two very similarly named functions doing very different :)

I propose that you rename this function to ath10k_pci_is_fw_crashed() or
ath10k_pci_has_fw_crashed() and I rename ath10k_pci_hif_dump_area() to
ath10k_pci_fw_crashed_dump(). I think that we have pretty consistent
naming, no?

> +static void ath10k_pci_fw_crashed_clear(struct ath10k *ar)
> +{
> +	ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
> +			   (ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS) &
> +			    ~FW_IND_EVENT_PENDING));

Please don't embed calls like this, with a temporary variable you get it
more readable and the resulting code should be the same anyway.

> @@ -2412,14 +2322,6 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
>  		return -EIO;
>  	}
>  
> -	if (val & FW_IND_EVENT_PENDING) {
> -		ath10k_warn("device has crashed during init\n");
> -		ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS,
> -				   val & ~FW_IND_EVENT_PENDING);
> -		ath10k_pci_hif_dump_area(ar);
> -		return -ECOMM;
> -	}

I'm a bit worried about this. Are you relying now that the target will
always trigger an interrupt or what? If yes, how can we sure it will
happen on all possible cases? I would prefer to have some kind of safety
net anyway, even if it's just a simple warning.

-- 
Kalle Valo
