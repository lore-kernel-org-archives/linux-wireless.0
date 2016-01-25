Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37715 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcAYR7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 12:59:53 -0500
Subject: Re: [PATCH 1/2] mac80211: fix txq queue related crashes
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56A66298.1000607@candelatech.com> (sfid-20160125_185956_624980_9E872160)
Date: Mon, 25 Jan 2016 09:59:52 -0800
MIME-Version: 1.0
In-Reply-To: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2016 05:23 AM, Michal Kazior wrote:
> The driver can access the queue simultanously
> while mac80211 tears down the interface. Without
> spinlock protection this could lead to corrupting
> sk_buff_head and subsequently to an invalid
> pointer dereference.

Hard to know for certain, but this *appears* to fix the unexpectedly large
amount of CE/AXI ath10k firmware crashes that we saw in the 4.2 kernel (4.0 previously
ran much better han 4.2 for us).

We'll continue testing, in case we are just getting lucky so far.

Thanks,
Ben

>
> Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>   net/mac80211/iface.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 33ae3c81bfc5..0451f120746e 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -977,7 +977,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>   	if (sdata->vif.txq) {
>   		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
>
> +		spin_lock_bh(&txqi->queue.lock);
>   		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
> +		spin_unlock_bh(&txqi->queue.lock);
> +
>   		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
>   	}
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

