Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:9318 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaBSMiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:38:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 1/7] ath10k: remove DMA mapping wrappers
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 19 Feb 2014 14:37:57 +0200
In-Reply-To: <1392629563-31046-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 17 Feb 2014 10:32:37 +0100")
Message-ID: <8738jfz3a2.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_133831_264255_D13CCEA2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There's no real benefit from using them. DMA-API
> already provides debugging. Some skbuffs are
> already mapped directly with DMA-API since wrapper
> arguments were insufficient and extending them
> would be pointless.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1360,7 +1360,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
>  	struct wmi_bcn_info *bcn_info;
>  	struct ath10k_vif *arvif;
>  	struct sk_buff *bcn;
> -	int vdev_id = 0;
> +	int err, vdev_id = 0;

We use ret, res and err as names for the status variable. We should try
to unify this and use ret everywhere.

-- 
Kalle Valo
