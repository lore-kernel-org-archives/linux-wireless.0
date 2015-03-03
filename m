Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39470 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbCCMh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 07:37:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <liuzy@marvell.com>, <szli@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Subject: Re: [PATCH 1/4] mwifiex: avoid queue_work while work is ongoing
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
	<1424883057-12102-2-git-send-email-patila@marvell.com>
Date: Tue, 03 Mar 2015 14:37:50 +0200
In-Reply-To: <1424883057-12102-2-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Wed, 25 Feb 2015 22:20:54 +0530")
Message-ID: <87a8zu9rz5.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_133800_698389_A2FEF878)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> From: Marc Yang <yangyang@marvell.com>
>
> Current code does not check whether main_work_queue or
> rx_work_queue is running when preparing to do queue_work,
> this code fix add check before calling queue_work, reducing
> unnecessary queue_work switch.
>
> This change instead sets more_task flag to ensure we run main_process
> superloop once again.
>
> Signed-off-by: Marc Yang <yangyang@marvell.com>
> Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Really, it took six persons to write this patch? Or do you just dump the
same names to each patch?

> +void mwifiex_queue_main_work(struct mwifiex_adapter *adapter)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> +	if (adapter->mwifiex_processing) {
> +		adapter->more_task_flag = true;
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +		queue_work(adapter->workqueue, &adapter->main_work);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mwifiex_queue_main_work);
> +
> +static void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
> +	if (adapter->rx_processing) {
> +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
> +		queue_work(adapter->rx_workqueue, &adapter->rx_work);
> +	}
> +}

I can apply this patch, but to me this looks like a horrible hack.

-- 
Kalle Valo
