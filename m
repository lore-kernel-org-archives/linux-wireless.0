Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3176 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaENTRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:17:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath10k: protect wep tx key setup
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1399637749-13489-5-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 22:17:44 +0300
In-Reply-To: <1399637749-13489-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 May 2014 14:15:48 +0200")
Message-ID: <87ha4scgpz.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_211755_179600_D5246F99)
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
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -1902,10 +1904,12 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
>  		ath10k_warn("failed to update wep key index for vdev %d: %d\n",
>  			    arvif->vdev_id,
>  			    ret);
> -		return;
> +		goto unlock;
>  	}
>  
>  	arvif->def_wep_key_idx = keyidx;
> +unlock:
> +	mutex_unlock(&arvif->ar->conf_mutex);
>  }

Empty line before the label, please.

-- 
Kalle Valo
