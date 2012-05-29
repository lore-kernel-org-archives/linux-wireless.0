Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1394 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2E2LPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 07:15:47 -0400
Message-ID: <4FC4AFDC.7030907@qca.qualcomm.com> (sfid-20120529_131550_019119_D71309AC)
Date: Tue, 29 May 2012 14:15:40 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 2/2] ath6kl: Fix unstable downlink throughput
References: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com> <1337941158-14895-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1337941158-14895-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 01:19 PM, Vasanthakumar Thiagarajan wrote:
> There is frequent downlink throughput drop to 0 when operating
> at the signal level between -42dBm to -53dBm. This has been root
> caused to the delay in releasing pending a-mpdu subframes in
> reorder buffer. Right now the timeout value is 400ms, there
> is also a race condition where timeout handler can be delayed
> to run at an extra timeout interval. This patch reduces the
> timout interval to reasonable 100ms and makes sure releasing
> pending frames are not skipped in the timeout handler by removing
> the flag (rxtid->progress) which can delay the timeout logic.
> 
> Reported-by: Yu Yanzhi <yanzhiy@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

[..]

> +	for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
> +		spin_lock_bh(&rxtid->lock);
> +		if (rxtid->hold_q[idx].skb) {
> +			/*
> +			 * There is a frame in the queue and no
> +			 * timer so start a timer to ensure that
> +			 * the frame doesn't remain stuck
> +			 * forever.
> +			 */
> +			agg_conn->timer_scheduled = true;
> +			mod_timer(&agg_conn->timer,
> +				  (jiffies + HZ * (AGGR_RX_TIMEOUT) / 1000));
> +			rxtid->timer_mon = true;
>  			spin_unlock_bh(&rxtid->lock);
> +			break;
>  		}
> +		spin_unlock_bh(&rxtid->lock);
> +	}

Same question about the loop here as well.

Kalle
