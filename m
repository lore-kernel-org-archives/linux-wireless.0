Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42280 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaGNNUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 09:20:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: sanitize tx ring index access properly
References: <1401954520-3365-1-git-send-email-michal.kazior@tieto.com>
	<1401954520-3365-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 14 Jul 2014 16:20:08 +0300
In-Reply-To: <1401954520-3365-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 5 Jun 2014 09:48:40 +0200")
Message-ID: <87vbr0krg7.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_152035_426967_2BA53613)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The tx ring index was immediately trimmed with a
> bitmask. This discarded the 0xFFFFFFFF error case
> (which theoretically can happen when a device is
> abruptly disconnected) and led to using an invalid
> tx ring index. This could lead to memory
> corruption.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/ce.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index d185dc0..7c6c7d5 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -603,16 +603,19 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
>  		if (ret)
>  			return ret;
>  
> -		src_ring->hw_index =
> -			ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
> -		src_ring->hw_index &= nentries_mask;
> +		read_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
> +		if (read_index == 0xFFFFFFFF)
> +			return -ENODEV;

I changed this to lower case, as it was before. Let's use lower case hex
values in ath10k.

-- 
Kalle Valo
