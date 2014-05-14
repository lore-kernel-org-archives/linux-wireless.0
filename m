Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:6182 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaENTu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:50:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath10k: protect wep tx key setup
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1399637749-13489-5-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 22:50:48 +0300
In-Reply-To: <1399637749-13489-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 May 2014 14:15:48 +0200")
Message-ID: <87d2fgcf6v.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_215108_182072_AE25A956)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> All configuration sequences should be protected
> with conf_mutex to avoid concurrent/conflicting
> requests.
>
> This should make sure that wep tx key setup is not
> performed while hw is restarted (at least).

Locks and mutexes should protect data, not thread of execution. What are
we exactly protecting here, arvif->def_wep_key_idx?

The patch makes sense, I'm just trying to understand the idea behind the
implementation.

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -1888,8 +1888,10 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
>  						wep_key_work);
>  	int ret, keyidx = arvif->def_wep_key_newidx;
>  
> +	mutex_lock(&arvif->ar->conf_mutex);
> +
>  	if (arvif->def_wep_key_idx == keyidx)
> -		return;
> +		goto unlock;

BTW, shouldn't we also check the state and bail out if the state is not
ON (and possibly RESTARTED)? How can this work otherwise?

-- 
Kalle Valo
