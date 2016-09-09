Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44310 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752115AbcIIRZv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 13:25:51 -0400
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: greearb@candelatech.com, ath10k@lists.infradead.org
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <a9add01b-4d5a-0e1c-d856-64dcf71bdb1c@nbd.name> (sfid-20160909_192555_094173_6B95B0EF)
Date: Fri, 9 Sep 2016 19:25:44 +0200
MIME-Version: 1.0
In-Reply-To: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-19 03:26, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> I was seeing kernel crashes due to accessing freed memory
> while debugging a 9984 firmware that was crashing often.
> 
> This patch fixes the crashes.  I am not certain if there
> is a better way or not.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 5659ef1..916119c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4172,8 +4172,10 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
>  static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>  {
>  	struct ath10k_txq *artxq = (void *)txq->drv_priv;
> +	struct ath10k_txq *tmp, *walker;
>  	struct ath10k_skb_cb *cb;
>  	struct sk_buff *msdu;
> +	struct ieee80211_txq *txq_tmp;
>  	int msdu_id;
>  
>  	if (!txq)
> @@ -4182,6 +4184,14 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>  	spin_lock_bh(&ar->txqs_lock);
>  	if (!list_empty(&artxq->list))
>  		list_del_init(&artxq->list);
> +
> +	/* Remove from ar->txqs in case it still exists there. */
> +	list_for_each_entry_safe(walker, tmp, &ar->txqs, list) {
> +		txq_tmp = container_of((void *)walker, struct ieee80211_txq,
> +				       drv_priv);
> +		if (txq_tmp == txq)
> +			list_del(&walker->list);
> +	}
This makes no sense at all. From txq_tmp == txq we can deduce that
walker == artxq. In the context above, it already does a
list_del_init(&artxq->list).

- Felix
