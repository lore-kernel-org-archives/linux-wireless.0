Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25074 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3HLO0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:26:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath10k: use sizeof(*var) in kmalloc
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
	<1375949650-9699-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 12 Aug 2013 17:26:37 +0300
In-Reply-To: <1375949650-9699-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 10:14:08 +0200")
Message-ID: <87li47t276.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_162646_376105_B50BF320)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This fixes checkpatch warning from the latest
> 3.11-rc kernel tree.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index d95439b..1814af1 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -803,8 +803,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
>  			continue;
>  
>  		for (i = 0; i < completions; i++) {
> -			compl = kmalloc(sizeof(struct ath10k_pci_compl),
> -					GFP_KERNEL);
> +			compl = kmalloc(sizeof(*compl), GFP_KERNEL);
>  			if (!compl) {
>  				ath10k_warn("No memory for completion state\n");
>  				ath10k_pci_stop_ce(ar);

Just out of curiosity, what's the warning? kmalloc() should be called
with sizeof(*foo) style?

-- 
Kalle Valo
