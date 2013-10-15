Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49461 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558Ab3JOStY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:49:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/7] ath10k: track vif list internally
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
	<20131015184656.14123.70575.stgit@localhost6.localdomain6>
Date: Tue, 15 Oct 2013 21:49:19 +0300
In-Reply-To: <20131015184656.14123.70575.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 15 Oct 2013 21:46:56 +0300")
Message-ID: <87a9iabc9c.fsf@kamboji.qca.qualcomm.com> (sfid-20131015_204930_213870_4AA1A5B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> mac80211 interface interations functions have
> peculiar locking issues. This patch introduces
> internal (to ath10k) vif list that will be used
> for vif iteration purposes.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -713,6 +713,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>  	mutex_init(&ar->conf_mutex);
>  	spin_lock_init(&ar->data_lock);
>  
> +	INIT_LIST_HEAD(&ar->arvifs);
>  	INIT_LIST_HEAD(&ar->peers);
>  	init_waitqueue_head(&ar->peer_mapping_wq);
>  
> @@ -824,6 +825,7 @@ int ath10k_core_start(struct ath10k *ar)
>  		goto err_disconnect_htc;
>  
>  	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
> +	INIT_LIST_HEAD(&ar->arvifs);
>  
>  	return 0;

Michal, why do the INIT_LIST_HEAD() twice? Isn't it enough to do it
core_start()?

-- 
Kalle Valo
