Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34009 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaHOMEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 08:04:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: extra logging for core-restart state change logic.
References: <1407272099-6271-1-git-send-email-greearb@candelatech.com>
Date: Fri, 15 Aug 2014 15:04:11 +0300
In-Reply-To: <1407272099-6271-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 5 Aug 2014 13:54:59
	-0700")
Message-ID: <87egwij6x0.fsf@kamboji.qca.qualcomm.com> (sfid-20140815_140443_829485_3248F1D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -700,6 +700,7 @@ static void ath10k_core_restart(struct work_struct *work)
>  	switch (ar->state) {
>  	case ATH10K_STATE_ON:
>  		ar->state = ATH10K_STATE_RESTARTING;
> +		ath10k_warn("core-restart, going to state RESTARTING from ON\n");
>  		del_timer_sync(&ar->scan.timeout);
>  		ath10k_reset_scan((unsigned long)ar);
>  		ieee80211_restart_hw(ar->hw);
> @@ -713,10 +714,11 @@ static void ath10k_core_restart(struct work_struct *work)
>  		/* hw restart might be requested from multiple places */
>  		break;
>  	case ATH10K_STATE_RESTARTED:
> -		ar->state = ATH10K_STATE_WEDGED;
>  		/* fall through */
>  	case ATH10K_STATE_WEDGED:
> -		ath10k_warn("device is wedged, will not restart\n");
> +		ath10k_warn("device is wedged, will not restart (state %d)\n",
> +			ar->state);
> +		ar->state = ATH10K_STATE_WEDGED;
>  		break;
>  	}

I think state prints should be debug messages, not part of error
messages. For example, we could add new debug level ATH10K_DBG_CORE or
something like that.

-- 
Kalle Valo
