Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44850 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbeCXAAm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 20:00:42 -0400
Subject: Re: [PATCH] ath9k: Protect queue draining by rcu_read_lock()
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
References: <20180202103645.12215-1-toke@toke.dk>
Cc: stable@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <155ca60c-48eb-5e64-b514-d9d5556b405c@candelatech.com> (sfid-20180324_010045_115240_10CFF6B1)
Date: Fri, 23 Mar 2018 17:00:39 -0700
MIME-Version: 1.0
In-Reply-To: <20180202103645.12215-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2018 02:36 AM, Toke Høiland-Jørgensen wrote:
> When ath9k was switched over to use the mac80211 intermediate queues,
> node cleanup now drains the mac80211 queues. However, this call path is
> not protected by rcu_read_lock() as it was previously entirely internal
> to the driver which uses its own locking.

As far as I can tell, this is not currently in Linus' tree.

Was this dropped on purpose?

Thanks,
Ben

>
> This leads to a possible rcu_dereference() without holding
> rcu_read_lock(); but only if a station is cleaned up while having
> packets queued on the TXQ. Fix this by adding the rcu_read_lock() to the
> caller in ath9k.
>
> Fixes: 50f08edf9809 ("ath9k: Switch to using mac80211 intermediate software queues.")
> Cc: stable@vger.kernel.org
> Reported-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 396bf05c6bf6..d8b041f48ca8 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2892,6 +2892,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
>  	struct ath_txq *txq;
>  	int tidno;
>
> +	rcu_read_lock();
> +
>  	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
>  		tid = ath_node_to_tid(an, tidno);
>  		txq = tid->txq;
> @@ -2909,6 +2911,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
>  		if (!an->sta)
>  			break; /* just one multicast ath_atx_tid */
>  	}
> +
> +	rcu_read_unlock();
>  }
>
>  #ifdef CONFIG_ATH9K_TX99
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
