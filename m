Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42134 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbdCPKij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:38:39 -0400
Message-ID: <1489659530.2370.10.camel@sipsolutions.net> (sfid-20170316_113842_231793_22A77A3C)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com, linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Thu, 16 Mar 2017 11:18:50 +0100
In-Reply-To: <58B09082.7020704@cococorp.com> (sfid-20170224_205905_277542_E6C0402D)
References: <58B09082.7020704@cococorp.com>
         (sfid-20170224_205905_277542_E6C0402D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry - this is the other half of my reply that I accidentally deleted
before sending...
 
> +static void flush_tx_skbs(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +	struct mesh_tx_queue *tx_node;
> +
> +	spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
> +
> +	/* Note that this check is important because of the two-
> stage
> +	 * way that ieee80211_if_mesh is initialized.
> +	 */

I think you should fix that rather than work around it. If this is
called with iftype != mesh then this is super problematic anyway, since
ifmsh->tx_queue_len would alias some other variable (there's a union).

> +	if (ifmsh->tx_queue_len > 0) {
> +		mhwmp_dbg(sdata, "flushing %d skbs", ifmsh-
> >tx_queue_len);
> +
> +		while (!list_empty(&ifmsh->tx_queue.list)) {
> +			tx_node = list_last_entry(&ifmsh-
> >tx_queue.list,
> +						  struct
> mesh_tx_queue, list);
> +			kfree_skb(tx_node->skb);
> +			list_del(&tx_node->list);
> +			kfree(tx_node);
> +		}
> +		ifmsh->tx_queue_len = 0;
> +	}
> +
> +	spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
> +}

All of this also gets *vastly* simpler if it's just skb_queue_purge()
:)

> +	spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
> +
> +	list_for_each_entry(tx_node, &ifmsh->tx_queue.list, list) {
> +		ieee80211_tx_skb(sdata, tx_node->skb);
> +	}

I don't think you should hold the lock across _tx_skb(), ISTR problems
with that - particularly with the STA lock, so this might be OK, but it
might also cause lock ordering issues. It's easy to avoid anyway, so
better not to do it.

johannes
