Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11482 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3BOKah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 05:30:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: Re: [PATCH 5/6] ath6kl: Fix a debugfs crash for USB devices
References: <1360834689-11187-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Fri, 15 Feb 2013 12:30:30 +0200
In-Reply-To: <1360834689-11187-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Thu, 14 Feb 2013 15:08:09
	+0530")
Message-ID: <871uchamyh.fsf@kamboji.qca.qualcomm.com> (sfid-20130215_113041_675294_37CF5E8F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Credit distribution stats is currently implemented
> only for SDIO. This fixes a crash in debugfs for
> USB interface.
>
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
> *pde = b62bd067
> Oops: 0000 [#1] SMP

[...]

> --- a/drivers/net/wireless/ath/ath6kl/debug.c
> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> @@ -658,6 +658,9 @@ static ssize_t read_file_credit_dist_stats(struct file *file,
>  	unsigned int buf_len, len = 0;
>  	ssize_t ret_cnt;
>  
> +	if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
> +		return -EINVAL;

Actually I think it would be better not to even create the debugfs when
using sdio.

-- 
Kalle Valo
