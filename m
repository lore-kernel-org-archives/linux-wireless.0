Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22090 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3ILQtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:49:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/7] ath10k: improve beacon submission latency
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
	<1378821003-22925-6-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Sep 2013 19:47:36 +0300
In-Reply-To: <1378821003-22925-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 10 Sep 2013 15:50:01 +0200")
Message-ID: <87sixadm1j.fsf@qca.qualcomm.com> (sfid-20130912_184958_655855_75E4E3C3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The patch prevents beacon misses in some case of
> heavy load on a system.
>
> If a beacon can't be transmitted directly from an
> SWBA event it will be left in arvif->beacon and
> transmission will be retried once TX credits
> become available.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
>  {
> +	ath10k_wmi_tx_beacons_nowait(ar);
>  	wake_up(&ar->wmi.tx_credits_wq);
>  }
>  
> @@ -131,6 +174,7 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
>  	int ret = -EINVAL;
>  
>  	wait_event_timeout(ar->wmi.tx_credits_wq, ({
> +		ath10k_wmi_tx_beacons_nowait(ar);
>  		ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
>  		(ret != -EAGAIN);

Please add a short comment to both calls of
ath10k_wmi_tx_beacons_nowait(). Something like "first transmit all
pending beacons" or similar.

-- 
Kalle Valo
