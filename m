Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29710 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2E2LNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 07:13:12 -0400
Message-ID: <4FC4AF40.3060702@qca.qualcomm.com> (sfid-20120529_131315_641267_BF663F91)
Date: Tue, 29 May 2012 14:13:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/2] ath6kl: Fix race in aggregation reorder logic
References: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 01:19 PM, Vasanthakumar Thiagarajan wrote:
> There are many places where tid data are accessed without
> the lock (rxtid->lock), this can lead to a race condition
> when the timeout handler for aggregatin reorder and the
> receive function are getting executed at the same time.
> Fix this race, but still there are races which can not
> be fixed without rewriting the whole aggregation reorder
> logic, for now fix the obvious ones.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

[...]

> @@ -1188,6 +1189,7 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
>  		rxtid->progress = true;
>  	else
>  		for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
> +			spin_lock_bh(&rxtid->lock);
>  			if (rxtid->hold_q[idx].skb) {
>  				/*
>  				 * There is a frame in the queue and no
> @@ -1201,8 +1203,10 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
>  					   HZ * (AGGR_RX_TIMEOUT) / 1000));
>  				rxtid->progress = false;
>  				rxtid->timer_mon = true;
> +				spin_unlock_bh(&rxtid->lock);
>  				break;
>  			}
> +			spin_unlock_bh(&rxtid->lock);
>  		}

Here you take and release the lock multiple times inside the loop. Why
not take the lock before the loop?

> @@ -1627,12 +1631,15 @@ static void aggr_timeout(unsigned long arg)
>  
>  		if (rxtid->aggr && rxtid->hold_q) {
>  			for (j = 0; j < rxtid->hold_q_sz; j++) {
> +				spin_lock_bh(&rxtid->lock);
>  				if (rxtid->hold_q[j].skb) {
>  					aggr_conn->timer_scheduled = true;
>  					rxtid->timer_mon = true;
>  					rxtid->progress = false;
> +					spin_unlock_bh(&rxtid->lock);
>  					break;
>  				}
> +				spin_unlock_bh(&rxtid->lock);
>  			}

Same here.

Kalle
