Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34880 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNIkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:40:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath10k: split ce irq/handler setup
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-5-git-send-email-michal.kazior@tieto.com>
Date: Thu, 14 Aug 2014 11:40:43 +0300
In-Reply-To: <1407402260-29854-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:04:19 +0200")
Message-ID: <87a977o450.fsf@kamboji.qca.qualcomm.com> (sfid-20140814_104056_728891_CCE4961F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It doesn't make much sense to overwrite send_cb
> and recv_cb callbacks over and over again whenever
> transport starts. Just make sure to unmask copy
> engine interrupts when starting.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

The patch looks, just a followup question for the future:

> @@ -1674,7 +1639,9 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
>  		pipe_info->hif_ce_state = ar;
>  		attr = &host_ce_config_wlan[pipe_num];
>  
> -		ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
> +		ret = ath10k_ce_init_pipe(ar, pipe_num, attr,
> +					  ath10k_pci_ce_send_done,
> +					  ath10k_pci_ce_recv_data);

As we call ath10k_ce_init_pipe() only once and seem to have only one set
of functions, why even bother bother with function pointers? What if we
just call the functions directly?

-- 
Kalle Valo
