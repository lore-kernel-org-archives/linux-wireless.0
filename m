Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1BQIbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 03:31:12 -0500
Subject: Re: [RFC] mac80211: implement eBDP algorithm to fight bufferbloat
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>
In-Reply-To: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 09:31:09 +0100
Message-ID: <1297931469.3750.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-16 at 20:49 -0500, John W. Linville wrote:

> @@ -212,6 +216,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
>  			continue;
>  
> +		atomic_dec(&sta->sdata->enqueued);

Note that TX status isn't reliable under any circumstances. Many drivers
will reliably return the SKB if it was enqueued correctly to the device,
but that may already fail (failure to allocate URBs, DMA memory etc.) In
this case, the counter will continually be too high, leading the code
below to drop many more packets than necessary. This is what I was
referring to earlier :-)

> @@ -1323,6 +1325,20 @@ static int __ieee80211_tx(struct ieee80211_local *local,
>  
>  		sdata = vif_to_sdata(info->control.vif);
>  
> +		/* test for queue admission qualifications */
> +		tserv_ns_avg = ewma_read(&sdata->tserv_ns_avg);
> +		/* constants 2 msec and offset 5 should be tunable? */
> +		max_enqueued = 2 * NSEC_PER_MSEC / tserv_ns_avg + 5;
> +		if (atomic_read(&sdata->enqueued) > max_enqueued) {
> +			/* silently drop */
> +			dev_kfree_skb(skb);
> +			return IEEE80211_TX_OK;
> +		}

As Nathaniel pointed out, this should instead stop the queue to give
normal QoS mechanisms a chance (this one packet can be kept for later,
or transmitted anyway, or the code to test all this can be after the
packet is sent).

However, since "sdata->enqueued" will drift as explained above, this
isn't feasible anyhow.

> +		/* timestamp queue entry and increment queue length */
> +		skb->tstamp = ktime_get();
> +		atomic_inc(&sdata->enqueued);

Additionally, this assumes that tx() cannot fail -- it can until my void
patch.

Sorry, this approach just won't work because we don't have perfect skb
accounting across the stack.

johannes

