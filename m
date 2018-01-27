Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59871 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbeA0N3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 08:29:51 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath9k:  Print has_queued in debugfs.
In-Reply-To: <1517015397-30957-1-git-send-email-greearb@candelatech.com>
References: <1517015397-30957-1-git-send-email-greearb@candelatech.com>
Date: Sat, 27 Jan 2018 14:29:49 +0100
Message-ID: <874ln7v38y.fsf@toke.dk> (sfid-20180127_142955_648697_B169C590)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> The PAUSED field was never printed per tid.  Replace that
> with has_queued, which might help someone track down strange
> bugs related to aqm.
>
> And, make tx-queue debug info show peer BSSID as well as vdev
> MAC to aid debugging with multiple stations connected to the
> same peer.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath9k/debug_sta.c | 10 ++++++----
>  drivers/net/wireless/ath/ath9k/xmit.c      |  5 +++--
>  2 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
> index efc692e..a45f1f5 100644
> --- a/drivers/net/wireless/ath/ath9k/debug_sta.c
> +++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
> @@ -48,9 +48,10 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
>  			 an->mpdudensity);
>  
>  	len += scnprintf(buf + len, size - len,
> -			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
> +			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%9s\n",
>  			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
> -			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
> +			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED",
> +			 "HAS-QUED");
>  
>  	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
>  		tid = ath_node_to_tid(an, tidno);
> @@ -58,7 +59,7 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
>  		ath_txq_lock(sc, txq);
>  		if (tid->active) {
>  			len += scnprintf(buf + len, size - len,
> -					 "%3d%11d%10d%10d%10d%10d%9d%6d\n",
> +					 "%3d%11d%10d%10d%10d%10d%9d%6d%9d\n",
>  					 tid->tidno,
>  					 tid->seq_start,
>  					 tid->seq_next,
> @@ -66,7 +67,8 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
>  					 tid->baw_head,
>  					 tid->baw_tail,
>  					 tid->bar_index,
> -					 !list_empty(&tid->list));
> +					 !list_empty(&tid->list),
> +					 tid->has_queued);

Would it perhaps be useful to print the length of tid->retry_q instead
of / in addition to has_queued? Planning to get rid of the has_queued
variable entirely...

-Toke
