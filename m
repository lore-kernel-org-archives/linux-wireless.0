Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932164AbcLSQ7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 11:59:12 -0500
Date: Mon, 19 Dec 2016 22:28:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: merge extended peer info data with existing
 peers info
Message-ID: <20161219165858.GB13022@atheros-ThinkPad-T61> (sfid-20161219_180008_267483_61BF8949)
References: <20161216052418.GA8936@atheros-ThinkPad-T61>
 <20161217174634.4531-1-chunkeey@googlemail.com>
 <20161219164957.GA13022@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219164957.GA13022@atheros-ThinkPad-T61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2016 at 10:19:57PM +0530, Mohammed Shafi Shajakhan wrote:
> Hi Christian,
> 
> On Sat, Dec 17, 2016 at 06:46:34PM +0100, Christian Lamparter wrote:
> > The 10.4 firmware adds extended peer information to the
> > firmware's statistics payload. This additional info is
> > stored as a separate data field. During review of
> > "ath10k: add accounting for the extended peer statistics" [0]
> > 
> > Mohammed Shafi Shajakhan commented that the extended peer statistics
> > lists are of little use:"... there is not much use in appending
> > the extended peer stats (which gets periodically updated) to the
> > linked list '&ar->debug.fw_stats.peers_extd)' and should we get
> > rid of the below (and the required cleanup as well)
> > 
> > list_splice_tail_init(&stats.peers_extd,
> >                 &ar->debug.fw_stats.peers_extd);
> > 
> > since rx_duration is getting updated periodically to the per sta
> > information."
> 
> [shafi] thanks !
> 
> > 
> > This patch replaces the extended peers list with a lookup and
> > puts the retrieved data (rx_duration) into the existing
> > ath10k_fw_stats_peer entry that was created earlier.
> 
> [shafi] Its good to maintain the extended stats variable
> and retain the two different functions to update rx_duration.
> 
> a) extended peer stats supported - mainly for 10.4
> b) extender peer stats not supported - for 10.2
> 
> 
> > 
> > [0] <https://lkml.kernel.org/r/992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
> > Cc: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/core.h        |  2 --
> >  drivers/net/wireless/ath/ath10k/debug.c       | 17 --------------
> >  drivers/net/wireless/ath/ath10k/debugfs_sta.c | 32 ++-----------------------
> >  drivers/net/wireless/ath/ath10k/wmi.c         | 34 ++++++++++++++++++++-------
> >  4 files changed, 28 insertions(+), 57 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> > index 09ff8b8a6441..3fffbbb18c25 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.h
> > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > @@ -268,11 +268,9 @@ struct ath10k_fw_stats_pdev {
> >  };
> >  
> >  struct ath10k_fw_stats {
> > -	bool extended;
> >  	struct list_head pdevs;
> >  	struct list_head vdevs;
> >  	struct list_head peers;
> > -	struct list_head peers_extd;
> >  };
> >  
> >  #define ATH10K_TPC_TABLE_TYPE_FLAG	1
> > diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> > index 82a4c67f3672..89f7fde77cdf 100644
> > --- a/drivers/net/wireless/ath/ath10k/debug.c
> > +++ b/drivers/net/wireless/ath/ath10k/debug.c
> > @@ -315,25 +315,13 @@ static void ath10k_fw_stats_peers_free(struct list_head *head)
> >  	}
> >  }
> >  
> > -static void ath10k_fw_extd_stats_peers_free(struct list_head *head)
> > -{
> > -	struct ath10k_fw_extd_stats_peer *i, *tmp;
> > -
> > -	list_for_each_entry_safe(i, tmp, head, list) {
> > -		list_del(&i->list);
> > -		kfree(i);
> > -	}
> > -}
> > -
> >  static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
> >  {
> >  	spin_lock_bh(&ar->data_lock);
> >  	ar->debug.fw_stats_done = false;
> > -	ar->debug.fw_stats.extended = false;
> 
> [shafi] this looks fine, but not removing the 'extended' variable 
> from ath10k_fw_stats structure, I see the design for 'rx_duration'
> arguably some what convoluted !
> 
> *We get periodic events from firmware updating 'ath10k_debug_fw_stats_process'
> *Fetch rx_duration from  'ath10k_wmi_pull_fw_stats(ar, skb, &stats)'
> {certainly 'stats' object is for this particular update only, and freed
> up later)
> *Update immediately using 'ath10k_sta_update_rx_duration'
> 
> 'ath10k_wmi_pull_fw_stats' has a slightly different implementation
> for 10.2 and 10.4 (the later supporting extended peer stats)
> 
> 
> 
> >  	ath10k_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
> >  	ath10k_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
> >  	ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
> > -	ath10k_fw_extd_stats_peers_free(&ar->debug.fw_stats.peers_extd);
> >  	spin_unlock_bh(&ar->data_lock);
> >  }
> >  
> > @@ -348,7 +336,6 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> >  	INIT_LIST_HEAD(&stats.pdevs);
> >  	INIT_LIST_HEAD(&stats.vdevs);
> >  	INIT_LIST_HEAD(&stats.peers);
> > -	INIT_LIST_HEAD(&stats.peers_extd);
> >  
> >  	spin_lock_bh(&ar->data_lock);
> >  	ret = ath10k_wmi_pull_fw_stats(ar, skb, &stats);
> > @@ -411,8 +398,6 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> >  
> >  		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
> >  		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
> > -		list_splice_tail_init(&stats.peers_extd,
> > -				      &ar->debug.fw_stats.peers_extd);
> >  	}
> >  
> >  	complete(&ar->debug.fw_stats_complete);
> > @@ -424,7 +409,6 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> >  	ath10k_fw_stats_pdevs_free(&stats.pdevs);
> >  	ath10k_fw_stats_vdevs_free(&stats.vdevs);
> >  	ath10k_fw_stats_peers_free(&stats.peers);
> > -	ath10k_fw_extd_stats_peers_free(&stats.peers_extd);
> >  
> >  	spin_unlock_bh(&ar->data_lock);
> >  }
> > @@ -2347,7 +2331,6 @@ int ath10k_debug_create(struct ath10k *ar)
> >  	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
> >  	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
> >  	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
> > -	INIT_LIST_HEAD(&ar->debug.fw_stats.peers_extd);
> >  
> >  	return 0;
> >  }
> > diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> > index fce6f8137d33..bf2d49cbb3bb 100644
> > --- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> > +++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> > @@ -18,27 +18,8 @@
> >  #include "wmi-ops.h"
> >  #include "debug.h"
> >  
> > -static void ath10k_sta_update_extd_stats_rx_duration(struct ath10k *ar,
> > -						     struct ath10k_fw_stats *stats)
> > -{
> > -	struct ath10k_fw_extd_stats_peer *peer;
> > -	struct ieee80211_sta *sta;
> > -	struct ath10k_sta *arsta;
> > -
> > -	rcu_read_lock();
> > -	list_for_each_entry(peer, &stats->peers_extd, list) {
> > -		sta = ieee80211_find_sta_by_ifaddr(ar->hw, peer->peer_macaddr,
> > -						   NULL);
> > -		if (!sta)
> > -			continue;
> > -		arsta = (struct ath10k_sta *)sta->drv_priv;
> > -		arsta->rx_duration += (u64)peer->rx_duration;
> > -	}
> > -	rcu_read_unlock();
> > -}
> > -
> > -static void ath10k_sta_update_stats_rx_duration(struct ath10k *ar,
> > -						struct ath10k_fw_stats *stats)
> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > +				   struct ath10k_fw_stats *stats)
> >  {
> >  	struct ath10k_fw_stats_peer *peer;
> >  	struct ieee80211_sta *sta;
> > @@ -56,15 +37,6 @@ static void ath10k_sta_update_stats_rx_duration(struct ath10k *ar,
> >  	rcu_read_unlock();
> >  }
> >  
> > -void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > -				   struct ath10k_fw_stats *stats)
> > -{
> > -	if (stats->extended)
> > -		ath10k_sta_update_extd_stats_rx_duration(ar, stats);
> > -	else
> > -		ath10k_sta_update_stats_rx_duration(ar, stats);
> > -}
> > -
> >  void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >  			   struct ieee80211_sta *sta,
> >  			   struct station_info *sinfo)
> > diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> > index c893314a191f..c7ec7b9e9b55 100644
> > --- a/drivers/net/wireless/ath/ath10k/wmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> > @@ -3044,23 +3044,41 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
> >  	if ((stats_id & WMI_10_4_STAT_PEER_EXTD) == 0)
> >  		return 0;
> >  
> > -	stats->extended = true;
> > -
> >  	for (i = 0; i < num_peer_stats; i++) {
> >  		const struct wmi_10_4_peer_extd_stats *src;
> > -		struct ath10k_fw_extd_stats_peer *dst;
> > +		struct ath10k_fw_stats_peer *dst;
> >  
> >  		src = (void *)skb->data;
> >  		if (!skb_pull(skb, sizeof(*src)))
> >  			return -EPROTO;
> >  
> > -		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
> > -		if (!dst)
> > -			continue;
> > +		/* Because the stat data may exceed htc-wmi buffer
> > +		 * limit the firmware might split the stats data
> > +		 * and delivers it in multiple update events.
> > +		 * if we can't find the entry in the current event
> > +		 * payload, we have to look in main list as well.
> > +		 */
> > +		list_for_each_entry(dst, &stats->peers, list) {
> > +			if (ether_addr_equal(dst->peer_macaddr,
> > +					     src->peer_macaddr.addr))
> > +				goto found;
> > +		}
> > +
> > +#ifdef CONFIG_ATH10K_DEBUGFS
> > +		list_for_each_entry(dst, &ar->debug.fw_stats.peers, list) {
> > +			if (ether_addr_equal(dst->peer_macaddr,
> > +					     src->peer_macaddr.addr))
> > +				goto found;
> > +		}
> > +#endif
> > +
> > +		ath10k_dbg(ar, ATH10K_DBG_WMI,
> > +			   "Orphaned extended stats entry for station %pM.\n",
> > +			   src->peer_macaddr.addr);
> > +		continue;
> >  
> > -		ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
> > +found:
> >  		dst->rx_duration = __le32_to_cpu(src->rx_duration);
> > -		list_add_tail(&dst->list, &stats->peers_extd);
> >  	}
> >  
> >  	return 0;
> 
> [shafi] Yes i am bit concerned about this change making 10.4 to update
> over the existing peer_stats structure, the idea is to maintain uniformity
> between the structures shared between ath10k and its corresponding *firmware* to avoid
> bugs in the future. Kindly let me know your thoughts, feel free
> to correct me if any of my analysis is incorrect. thank you !

> 
> regards,
> shafi
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
