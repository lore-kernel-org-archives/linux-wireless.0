Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754244AbcLVPsS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 10:48:18 -0500
Date: Thu, 22 Dec 2016 21:18:01 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: merge extended peer info data with existing
 peers info
Message-ID: <20161222154801.GA16241@atheros-ThinkPad-T61> (sfid-20161222_164821_786274_E9ECA22E)
References: <20161216052418.GA8936@atheros-ThinkPad-T61>
 <20161217174634.4531-1-chunkeey@googlemail.com>
 <20161219164957.GA13022@atheros-ThinkPad-T61>
 <2696316.Ugl5Pim1oL@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2696316.Ugl5Pim1oL@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

once again sorry for the delay

> 
> On Monday, December 19, 2016 10:19:57 PM CET Mohammed Shafi Shajakhan wrote:
> > On Sat, Dec 17, 2016 at 06:46:34PM +0100, Christian Lamparter wrote:
> > > The 10.4 firmware adds extended peer information to the
> > > firmware's statistics payload. This additional info is
> > > stored as a separate data field. During review of
> > > "ath10k: add accounting for the extended peer statistics" [0]
> > > 
> > > Mohammed Shafi Shajakhan commented that the extended peer statistics
> > > lists are of little use:"... there is not much use in appending
> > > the extended peer stats (which gets periodically updated) to the
> > > linked list '&ar->debug.fw_stats.peers_extd)' and should we get
> > > rid of the below (and the required cleanup as well)
> > > 
> > > list_splice_tail_init(&stats.peers_extd,
> > >                 &ar->debug.fw_stats.peers_extd);
> > > 
> > > since rx_duration is getting updated periodically to the per sta
> > > information."
> > > 
> > > This patch replaces the extended peers list with a lookup and
> > > puts the retrieved data (rx_duration) into the existing
> > > ath10k_fw_stats_peer entry that was created earlier.
> > 
> > [shafi] Its good to maintain the extended stats variable
> > and retain the two different functions to update rx_duration.
> > 
> > a) extended peer stats supported - mainly for 10.4
> > b) extender peer stats not supported - for 10.2
> Well, I have to ask why you want to retain the two different
> functions to update the same arsta->rx_duration? I think a
> little bit of code that helps to explain what's on your mind
> (or how you would do it) would help immensely in this case.
> Since I have the feeling that this is the problem here. 
> So please explain it in C(lang).

[shafi] I see you prefer to stuff the 'rx_duration' from
the extended stats to the existing global 'ath10k_peer_stats'
The idea of extended stats is, ideally its not going to stop
for 'rx_duration' . Extended stats is maintained as a seperate
list / entry for addition of new fields as well

> 
> > > [0] <https://lkml.kernel.org/r/992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
> > > Cc: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
> > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > > ---
> > >  drivers/net/wireless/ath/ath10k/core.h        |  2 --
> > >  drivers/net/wireless/ath/ath10k/debug.c       | 17 --------------
> > >  drivers/net/wireless/ath/ath10k/debugfs_sta.c | 32 ++-----------------------
> > >  drivers/net/wireless/ath/ath10k/wmi.c         | 34 ++++++++++++++++++++-------
> > >  4 files changed, 28 insertions(+), 57 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> > > index 09ff8b8a6441..3fffbbb18c25 100644
> > > --- a/drivers/net/wireless/ath/ath10k/core.h
> > > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > > @@ -268,11 +268,9 @@ struct ath10k_fw_stats_pdev {
> > >  };
> > >  
> > >  struct ath10k_fw_stats {
> > > -	bool extended;
> > >  	struct list_head pdevs;
> > >  	struct list_head vdevs;
> > >  	struct list_head peers;
> > > -	struct list_head peers_extd;
> > >  };
> > >  
> > >  #define ATH10K_TPC_TABLE_TYPE_FLAG	1
> > > diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> > > index 82a4c67f3672..89f7fde77cdf 100644
> > > --- a/drivers/net/wireless/ath/ath10k/debug.c
> > > +++ b/drivers/net/wireless/ath/ath10k/debug.c
> > > @@ -315,25 +315,13 @@ static void ath10k_fw_stats_peers_free(struct list_head *head)
> > >  	}
> > >  }
> > >  
> > > -static void ath10k_fw_extd_stats_peers_free(struct list_head *head)
> > > -{
> > > -	struct ath10k_fw_extd_stats_peer *i, *tmp;
> > > -
> > > -	list_for_each_entry_safe(i, tmp, head, list) {
> > > -		list_del(&i->list);
> > > -		kfree(i);
> > > -	}
> > > -}
> > > -
> > >  static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
> > >  {
> > >  	spin_lock_bh(&ar->data_lock);
> > >  	ar->debug.fw_stats_done = false;
> > > -	ar->debug.fw_stats.extended = false;
> > 
> > [shafi] this looks fine, but not removing the 'extended' variable 
> > from ath10k_fw_stats structure, I see the design for 'rx_duration'
> > arguably some what convoluted !
> I removed extended because it is now a write-only variable.
> So I figured, there's no point in keeping it around? I don't have
> access to the firmware interface documentation, so I don't know
> if there's a reason why it would be good to have it later.
> So please tell me, what information do we gain from it?

[shafi] while parsing the stats from 'wmi' we clearly mark there whether
the extended stats is available (or) not and if its there parse it and
deal with it seperately

> 
> > *We get periodic events from firmware updating 'ath10k_debug_fw_stats_process'
> > *Fetch rx_duration from  'ath10k_wmi_pull_fw_stats(ar, skb, &stats)'
> > {certainly 'stats' object is for this particular update only, and freed
> > up later)
> > *Update immediately using 'ath10k_sta_update_rx_duration'
> > 
> > 'ath10k_wmi_pull_fw_stats' has a slightly different implementation
> > for 10.2 and 10.4 (the later supporting extended peer stats)
> 
> I see that 10.2.4's ath10k_wmi_10_2_4_op_pull_fw_stats()
> passes the rx_duration as part of the wmi_10_2_4_ext_peer_stats
> element which is basically a carbon-copy of wmi_10_2_4_peer_stats
> (but with one extra __le32 for the rx_duration at the end.)
> This rx_duration is then used to set the rx_duration field in the
> generated ath10k_fw_stats_peer struct.
> 
> 10.4's ath10k_wmi_10_4_op_pull_fw_stats() has a "fixed" wmi_10_4_peer_stats
> element and uses an separate "fixed" wmi_10_4_peer_extd_stats element for
> the communicating the rx_duration to the driver.
> 
> Thing is, both function have the same signature. They produce the same
> struct ath10k_fw_stats_peer for the given data in the sk_buff input. So
> why does 10.4 need to have it's peer_extd infrastructure, when it can use
> the existing rx_duration field in the *universal* ath10k_fw_stats_peer?

[shafi] agreed we need to fix that, it would have been easier if 10.2.4
and 10.4 had the same definitions.

> 
> What's with the extra layers / HAL here? Because it looks like it's merged
> back together in the same manner into the same arsta->rx_duration?
> [ath10k_sta_update_stats_rx_duration() vs. 
>  ath10k_sta_update_extd_stats_rx_duration() - they are almost carbon copies too]
> 
> > > diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> > > index c893314a191f..c7ec7b9e9b55 100644
> > > --- a/drivers/net/wireless/ath/ath10k/wmi.c
> > > +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> > > @@ -3044,23 +3044,41 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
> > >  	if ((stats_id & WMI_10_4_STAT_PEER_EXTD) == 0)
> > >  		return 0;
> > >  
> > > -	stats->extended = true;
> > > -
> > >  	for (i = 0; i < num_peer_stats; i++) {
> > >  		const struct wmi_10_4_peer_extd_stats *src;
> > > -		struct ath10k_fw_extd_stats_peer *dst;
> > > +		struct ath10k_fw_stats_peer *dst;
> > >  
> > >  		src = (void *)skb->data;
> > >  		if (!skb_pull(skb, sizeof(*src)))
> > >  			return -EPROTO;
> > >  
> > > -		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
> > > -		if (!dst)
> > > -			continue;
> > > +		/* Because the stat data may exceed htc-wmi buffer
> > > +		 * limit the firmware might split the stats data
> > > +		 * and delivers it in multiple update events.
> > > +		 * if we can't find the entry in the current event
> > > +		 * payload, we have to look in main list as well.
> > > +		 */

[shafi] thanks ! sorry i might have missed this bug, did you happen
to see this condition being hit ?

> > > +		list_for_each_entry(dst, &stats->peers, list) {
> > > +			if (ether_addr_equal(dst->peer_macaddr,
> > > +					     src->peer_macaddr.addr))
> > > +				goto found;
> > > +		}
> > > +

[shafi] Again, we can simply cache the macaddress and rx_duration
and deal with it later, rather than doing the whole lookup here ?
Will it be an overhead for large number of clients ?

> > > +#ifdef CONFIG_ATH10K_DEBUGFS
> > > +		list_for_each_entry(dst, &ar->debug.fw_stats.peers, list) {
> > > +			if (ether_addr_equal(dst->peer_macaddr,
> > > +					     src->peer_macaddr.addr))
> > > +				goto found;
> > > +		}
> > > +#endif

[shafi] again, this could be handled seperately.

> > > +
> > > +		ath10k_dbg(ar, ATH10K_DBG_WMI,
> > > +			   "Orphaned extended stats entry for station %pM.\n",
> > > +			   src->peer_macaddr.addr);
> > > +		continue;
> > >  
> > > -		ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
> > > +found:
> > >  		dst->rx_duration = __le32_to_cpu(src->rx_duration);
> > > -		list_add_tail(&dst->list, &stats->peers_extd);
> > >  	}
> > >  
> > >  	return 0;
> > 
> > [shafi] Yes i am bit concerned about this change making 10.4 to update
> > over the existing peer_stats structure, the idea is to maintain uniformity
> > between the structures shared between ath10k and its corresponding to avoid
> > confusion/ bugs in the future. Kindly let me know your thoughts, feel free
> > to correct me if any of my analysis is incorrect. thank you !
> Isn't the point of the ath10k_wmi_10_*_op_pull_fw_stats() functions to make 
> a "universal" statistic (in your case a unified ath10k_fw_stats_peer structure)
> that other functions can use, without caring about if the FW was 10.4 
> or 10.2.4?
> 
> There's no indication that the rx_duration field in wmi_10_2_4_ext_peer_stats
> conveys any different information than the rx_duration in 
> wmi_10_4_peer_extd_stats. So, what's going on here? Can't you just make
> wmi_10_4_peer_extd_stats's rx_duration use the existing field in
> ath10k_fw_stats_peer? And if not: why exactly?
>
[shafi] I will soon test your change and keep you posted. We will also
get Kalle's take/view on this. 

regards,
shafi
