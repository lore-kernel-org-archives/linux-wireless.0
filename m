Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5425 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaDJGLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:11:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: don't wait for device init if it crashed
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
	<1397038028-7665-3-git-send-email-michal.kazior@tieto.com>
Date: Thu, 10 Apr 2014 09:11:04 +0300
In-Reply-To: <1397038028-7665-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 9 Apr 2014 12:07:07 +0200")
Message-ID: <87siplhfyf.fsf@kamboji.qca.qualcomm.com> (sfid-20140410_081146_477265_509F95EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> When warm resetting it's possible for device to
> crash during initialization. Instead of waiting 3
> seconds just return failure as soon as
> FW_IND_EVENT_PENDING is set.
>
> This speeds up device bootup and recovery in some
> cases.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2452,6 +2452,9 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
>  		if (val == 0xffffffff)
>  			continue;
>  
> +		if (val & FW_IND_EVENT_PENDING)
> +			break;

Can you add a small comment here explaining why we do this? "device has
most probably crashed" or something like that.

-- 
Kalle Valo
