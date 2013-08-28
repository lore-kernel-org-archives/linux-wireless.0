Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43519 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3H1EMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 00:12:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] ath10k: use inline ce_state structure
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 28 Aug 2013 07:12:33 +0300
In-Reply-To: <1377601683-12072-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 27 Aug 2013 13:07:58 +0200")
Message-ID: <87y57mjvwu.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_061241_883109_3223CEEF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Simplifies memory managament of ce_state.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Sorry, I noticed this only in my second review round:

> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -233,7 +233,10 @@ struct ath10k_pci {
>  	spinlock_t ce_lock;
>  
>  	/* Map CE id to ce_state */
> -	struct ce_state *ce_id_to_state[CE_COUNT_MAX];
> +	struct ce_state ce_states[CE_COUNT_MAX];
> +
> +	/* makes sure that dummy reads are atomic */
> +	spinlock_t hw_v1_workaround_lock;
>  };

That lock doesn't look right. Is it a leftover from a rebase?

-- 
Kalle Valo
