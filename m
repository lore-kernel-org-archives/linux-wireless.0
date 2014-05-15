Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48870 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaEONVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 09:21:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath10k: wake up everything on core restart
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
	<1399638957-20449-5-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 May 2014 16:21:18 +0300
In-Reply-To: <1399638957-20449-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 May 2014 14:35:54 +0200")
Message-ID: <87fvkb89f5.fsf@kamboji.qca.qualcomm.com> (sfid-20140515_152130_621803_0A80AD59)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It makes sense to finish completions as they may
> be waited for while holding conf_mutex thus
> delaying hw restart.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 3f4d28f..bf7c323 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -709,6 +709,18 @@ void ath10k_core_restart(struct ath10k *ar)
>  	spin_lock_bh(&ar->data_lock);
>  	ar->wmi.drop = true;
>  	wake_up(&ar->wmi.tx_credits_wq);
> +
> +	complete(&ar->target_suspend);
> +	complete(&ar->debug.event_stats_compl);

We dropped this patchset already, but for the future, this patch
introduces a new warning:

   drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_restart':
>> drivers/net/wireless/ath/ath10k/core.c:714:14: error: 'struct ath10k'
>> has no member named 'debug'
     complete(&ar->debug.event_stats_compl);
                 ^

Maybe that complete call should be in debug.c?

-- 
Kalle Valo
