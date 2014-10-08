Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaJHJwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 05:52:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 8 Oct 2014 12:52:04 +0300
In-Reply-To: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 8 Oct 2014 14:46:26 +0530")
Message-ID: <87a956hosb.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_115219_996092_95F2D639)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> The commit "ath10k: workaround fw beaconing bug" is freeing
> DMA-coherent memory in irq context which is hitting BUG ON
> in ARM platforms. Fix this by moving dma_free out of spin
> lock.
>
> kernel BUG at mm/vmalloc.c:1512!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
> CPU: 0 PID: 722 Comm: hostapd Not tainted 3.14.0 #3
> task: dd58b840 ti: da6a6000 task.ti: da6a6000
> PC is at vunmap+0x24/0x34
> LR is at __arm_dma_free.isra.21+0x12c/0x190
> [<c02a97d0>] (vunmap) from [<c021f81c>] (__arm_dma_free.isra.21+0x12c/0x190)
> [<c021f81c>] (__arm_dma_free.isra.21) from [<bf3b2440>]
> 			(ath10k_mac_vif_beacon_free+0xf4/0x100 [ath10k_core])
> [<bf3b2440>] (ath10k_mac_vif_beacon_free [ath10k_core]) from [<bf3b2490>]
> 			(ath10k_remove_interface+0x44/0x1ec [ath10k_core])
> [<bf3b2490>] (ath10k_remove_interface [ath10k_core]) from [<bf3352e4>]
> 			(ieee80211_add_virtual_monitor+0x9d8/0x9f0 [mac80211])
> [<bf3352e4>] (ieee80211_add_virtual_monitor [mac80211]) from [<bf33530c>]
> 			(ieee80211_stop+0x10/0x18 [mac80211])
> [<bf33530c>] (ieee80211_stop [mac80211]) from [<c040d144>]
> 			(__dev_close_many+0x9c/0xcc)
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> @@ -2404,8 +2389,15 @@ void ath10k_halt(struct ath10k *ar)
>  
>  	spin_lock_bh(&ar->data_lock);
>  	list_for_each_entry(arvif, &ar->arvifs, list)
> -		ath10k_mac_vif_beacon_cleanup(arvif);
> +		ath10k_mac_vif_beacon_free(arvif);
>  	spin_unlock_bh(&ar->data_lock);
> +	list_for_each_entry(arvif, &ar->arvifs, list) {
> +		if (!arvif->beacon_buf)
> +			continue;
> +		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
> +				  arvif->beacon_buf, arvif->beacon_paddr);
> +		arvif->beacon_buf = NULL;
> +	}
>  }

Until now we have protected arvif->beacon_buf with data_lock. How do we
know that this is safe to do without taking data_lock?

-- 
Kalle Valo
