Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34317 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1J1NTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 09:19:06 -0400
Message-ID: <4EAAABB8.3030309@qca.qualcomm.com> (sfid-20111028_151911_209955_409FBF02)
Date: Fri, 28 Oct 2011 16:18:48 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath6kl: Perform WOW resume in RX path in case of
 SDIO IRQ wakeup
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-7-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1319539047-8756-7-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Empty commit log.

> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -1081,6 +1081,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
>  		return;
>  	}
>  
> +	ath6kl_pm_check_wow_status(ar);

Now we resume from two places, cfg80211 resume handler and here. Why do
we need to do that? Why isn't cfg80211 resume handler enough?

Kalle
