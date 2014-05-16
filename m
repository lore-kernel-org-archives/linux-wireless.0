Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8352 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaEPMcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 08:32:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<apenwarr@gmail.com>
Subject: Re: [PATCH 3/3] ath10k: add explicit memory barrier for ring index update
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1400158139-13836-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 16 May 2014 15:32:11 +0300
In-Reply-To: <1400158139-13836-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 14:48:59 +0200")
Message-ID: <87d2fd7vlg.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_143220_398177_0AB9C7D1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Avery reported he had some issues related to
> instructions being re-ordered on his ARM test
> system resulting in firmware crashes.
>
> This makes sure that data is in place before CE
> ring index is updated telling firmware it can
> fetch the data.
>
> Reported-By: Avery Pennarun <apenwarr@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

[...]

> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -63,6 +63,7 @@ static inline void ath10k_ce_dest_ring_write_index_set(struct ath10k *ar,
>  						       u32 ce_ctrl_addr,
>  						       unsigned int n)
>  {
> +	mb();
>  	ath10k_pci_write32(ar, ce_ctrl_addr + DST_WR_INDEX_ADDRESS, n);
>  }
>  
> @@ -76,6 +77,7 @@ static inline void ath10k_ce_src_ring_write_index_set(struct ath10k *ar,
>  						      u32 ce_ctrl_addr,
>  						      unsigned int n)
>  {
> +	mb();
>  	ath10k_pci_write32(ar, ce_ctrl_addr + SR_WR_INDEX_ADDRESS, n);
>  }

I see two new checkpatch warnings:

drivers/net/wireless/ath/ath10k/ce.c:66: CHECK: memory barrier without comment
drivers/net/wireless/ath/ath10k/ce.c:80: CHECK: memory barrier without comment

-- 
Kalle Valo
