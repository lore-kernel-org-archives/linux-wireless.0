Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39637 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbbCCMj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 07:39:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>, <szli@marvell.com>
Subject: Re: [PATCH 3/4] mwifiex: remove_bss_prio_lock
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
	<1424883057-12102-4-git-send-email-patila@marvell.com>
Date: Tue, 03 Mar 2015 14:39:52 +0200
In-Reply-To: <1424883057-12102-4-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Wed, 25 Feb 2015 22:20:56 +0530")
Message-ID: <8761ai9rvr.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_134003_363786_A31DEDFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> From: Zhaoyang Liu <liuzy@marvell.com>
>
> This patch does away with spinlock in
> mwifiex_wmm_get_highest_priolist_ptr in order to improve TP.
>
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <patila@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

[...]

> @@ -727,6 +730,25 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
>  	}
>  
>  	mwifiex_deauthenticate(priv, NULL);
> +
> +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> +	adapter->main_locked = true;
> +	if (adapter->mwifiex_processing) {
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +		flush_workqueue(adapter->workqueue);
> +	} else {
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +	}
> +
> +	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
> +	adapter->rx_locked = true;
> +	if (adapter->rx_processing) {
> +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> +		flush_workqueue(adapter->rx_workqueue);
> +	} else {
> +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> +	}

And here the horrible hack just grows to other functions.

-- 
Kalle Valo
