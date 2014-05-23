Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10483 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaEWI1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:27:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 23 May 2014 11:27:01 +0300
In-Reply-To: <1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 10:42:02 +0200")
Message-ID: <87oayovr1m.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_102713_651362_47D8CDD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes sure no further tx requests are
> submitted to HTT before driver teardown.
>
> This should prevent invalid pointer/NULL
> dereference on htt tx pool in ath10k_htt_tx() in
> some cases of heavy traffic.
>
> Reported-By: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2289,6 +2289,21 @@ static void ath10k_tx(struct ieee80211_hw *hw,
>  /*
>   * Initialize various parameters with default vaules.
>   */
> +static void ath10k_drain_tx(struct ath10k *ar)
> +{
> +	/* workers can hold conf_mutex -- avoid deadlock */
> +	WARN_ON(lockdep_is_held(&ar->conf_mutex));

If CONFIG_LOCKDEP is disabled this will fail with:

drivers/net/wireless/ath/ath10k/mac.c:2301:2: error: implicit declaration of function 'lockdep_is_held' [-Werror=implicit-function-declaration]

I wasn't able to come up with any other way than adding '#ifdef
CONFIG_LOCKDEP' which is quite ugly. What should we do?

-- 
Kalle Valo
