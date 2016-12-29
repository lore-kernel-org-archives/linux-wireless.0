Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2OgB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 09:36:01 -0500
Date: Thu, 29 Dec 2016 20:05:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>, michal.kazior@tieto.com
Subject: Re: [PATCH] ath10k: merge extended peer info data with existing
 peers info
Message-ID: <20161229143459.GA3566@atheros-ThinkPad-T61> (sfid-20161229_153621_243297_D0145672)
References: <20161216052418.GA8936@atheros-ThinkPad-T61>
 <2696316.Ugl5Pim1oL@debian64>
 <20161222154801.GA16241@atheros-ThinkPad-T61>
 <1563376.k5ulprKP3Z@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1563376.k5ulprKP3Z@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,


On Thu, Dec 22, 2016 at 06:58:41PM +0100, Christian Lamparter wrote:
> Hello Shafi,
> 
> On Thursday, December 22, 2016 9:18:01 PM CET Mohammed Shafi Shajakhan wrote:
> > > On Monday, December 19, 2016 10:19:57 PM CET Mohammed Shafi Shajakhan wrote:
> > > > On Sat, Dec 17, 2016 at 06:46:34PM +0100, Christian Lamparter wrote:
> > > > > The 10.4 firmware adds extended peer information to the
> > > > > firmware's statistics payload. This additional info is
> > > > > stored as a separate data field. During review of
> > > > > "ath10k: add accounting for the extended peer statistics" [0]
> > > > > 
> > > > > Mohammed Shafi Shajakhan commented that the extended peer statistics
> > > > > lists are of little use:"... there is not much use in appending
> > > > > the extended peer stats (which gets periodically updated) to the
> > > > > linked list '&ar->debug.fw_stats.peers_extd)' and should we get
> > > > > rid of the below (and the required cleanup as well)
> > > > > 
> > > > > list_splice_tail_init(&stats.peers_extd,
> > > > >                 &ar->debug.fw_stats.peers_extd);
> > > > > 
> > > > > since rx_duration is getting updated periodically to the per sta
> > > > > information."
> > > > > 
> > > > > This patch replaces the extended peers list with a lookup and
> > > > > puts the retrieved data (rx_duration) into the existing
> > > > > ath10k_fw_stats_peer entry that was created earlier.
> > > > 
> > > > [shafi] Its good to maintain the extended stats variable
> > > > and retain the two different functions to update rx_duration.
> > > > 
> > > > a) extended peer stats supported - mainly for 10.4
> > > > b) extender peer stats not supported - for 10.2
> > > Well, I have to ask why you want to retain the two different
> > > functions to update the same arsta->rx_duration? I think a
> > > little bit of code that helps to explain what's on your mind
> > > (or how you would do it) would help immensely in this case.
> > > Since I have the feeling that this is the problem here. 
> > > So please explain it in C(lang).
> > 
> > [shafi] I see you prefer to stuff the 'rx_duration' from
> > the extended stats to the existing global 'ath10k_peer_stats'
> > The idea of extended stats is, ideally its not going to stop
> > for 'rx_duration' . Extended stats is maintained as a seperate
> > list / entry for addition of new fields as well
> I'm guessing you are trying to say here:
> 
> replace:
> 
> dst->rx_duration = __le32_to_cpu(src->rx_duration); 
> 
> with
> 
> dst->rx_duration += __le32_to_cpu(src->rx_duration);
> 
> in ath10k_wmi_10_4_op_pull_fw_stats()?

[shafi] oh no sorry, I am trying to say more members related
to stats shall be added in extended stats structure . The extended
stats structure is specifically introduced for adding more stats related
variables.

> 
> Is this correct? If so then can you tell me why ath10k_wmi_10_4_op_pull_fw_stats()
> is using for (i = 0; i < num_peer_stats; i++) to iterate over the extended peer
> stats instead of looking up the number of extended peer items. Because this does
> imply that there are the "same" (and every peer stat has a matching extended 
> peer stat)... (This will be important for the comment below - so ***).
> Of course, if this isn't true then this is a bug and should be fixed because
> otherwise the ath10k_wmi_10_4_op_pull_fw_stats functions might return -EPROTO
> at some point which causes a "failed to pull fw stats: -71" and unprocessed/lost
> stats.

[shafi] sorry i am not sure I got you, have you come across this error, please
let me know ?

> > > 
> > > > > [0] <https://lkml.kernel.org/r/992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
> > > > > Cc: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
> > > > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > > > > ---
> > > > >  drivers/net/wireless/ath/ath10k/core.h        |  2 --
> > > > >  drivers/net/wireless/ath/ath10k/debug.c       | 17 --------------
> > > > >  drivers/net/wireless/ath/ath10k/debugfs_sta.c | 32 ++-----------------------
> > > > >  drivers/net/wireless/ath/ath10k/wmi.c         | 34 ++++++++++++++++++++-------
> > > > >  4 files changed, 28 insertions(+), 57 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> > > > > index 09ff8b8a6441..3fffbbb18c25 100644
> > > > > --- a/drivers/net/wireless/ath/ath10k/core.h
> > > > > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > > > > @@ -268,11 +268,9 @@ struct ath10k_fw_stats_pdev {
> > > > >  };
> > > > >  
> > > > >  struct ath10k_fw_stats {
> > > > > -	bool extended;
> > > > >  	struct list_head pdevs;
> > > > >  	struct list_head vdevs;
> > > > >  	struct list_head peers;
> > > > > -	struct list_head peers_extd;
> > > > >  };
> > > > >  
> > > > >  #define ATH10K_TPC_TABLE_TYPE_FLAG	1
> > > > > diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> > > > > index 82a4c67f3672..89f7fde77cdf 100644
> > > > > --- a/drivers/net/wireless/ath/ath10k/debug.c
> > > > > +++ b/drivers/net/wireless/ath/ath10k/debug.c
> > > > > @@ -315,25 +315,13 @@ static void ath10k_fw_stats_peers_free(struct list_head *head)
> > > > >  	}
> > > > >  }
> > > > >  
> > > > > -static void ath10k_fw_extd_stats_peers_free(struct list_head *head)
> > > > > -{
> > > > > -	struct ath10k_fw_extd_stats_peer *i, *tmp;
> > > > > -
> > > > > -	list_for_each_entry_safe(i, tmp, head, list) {
> > > > > -		list_del(&i->list);
> > > > > -		kfree(i);
> > > > > -	}
> > > > > -}
> > > > > -
> > > > >  static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
> > > > >  {
> > > > >  	spin_lock_bh(&ar->data_lock);
> > > > >  	ar->debug.fw_stats_done = false;
> > > > > -	ar->debug.fw_stats.extended = false;
> > > > 
> > > > [shafi] this looks fine, but not removing the 'extended' variable 
> > > > from ath10k_fw_stats structure, I see the design for 'rx_duration'
> > > > arguably some what convoluted !
> > > I removed extended because it is now a write-only variable.
> > > So I figured, there's no point in keeping it around? I don't have
> > > access to the firmware interface documentation, so I don't know
> > > if there's a reason why it would be good to have it later.
> > > So please tell me, what information do we gain from it?

[shafi] sorry this is purely ath10k specific nothing to map with the firmware

> > 
> > [shafi] while parsing the stats from 'wmi' we clearly mark there whether
> > the extended stats is available (or) not and if its there parse it and
> > deal with it seperately
> No, there's no difference between stats or extended stats (10.2.4 vs 10.4):
> both ath10k_sta_update_extd_stats_rx_duration() [0]
> and ath10k_sta_update_stats_rx_duration() [1] are adding the
> ath10k_fw_stats_peer(_extd)->rx_duration to ath10k_sta->rx_duration.
> 
> With the merge of the peer stats and extended peer stats, this also
> removed the only usage of stats->extended. And hence it becomes a
> write-only variable. So there's no point in keeping it around ATM (as
> all other extended peer stats entries aren't used).

[shafi] ok, I see the extended stats structure is introduced for 10.4 and i was
thinking its good to have two seperate API's for updating the rx_duration ..

> 
> > > > *We get periodic events from firmware updating 'ath10k_debug_fw_stats_process'
> > > > *Fetch rx_duration from  'ath10k_wmi_pull_fw_stats(ar, skb, &stats)'
> > > > {certainly 'stats' object is for this particular update only, and freed
> > > > up later)
> > > > *Update immediately using 'ath10k_sta_update_rx_duration'
> > > > 
> > > > 'ath10k_wmi_pull_fw_stats' has a slightly different implementation
> > > > for 10.2 and 10.4 (the later supporting extended peer stats)
> > > 
> > > I see that 10.2.4's ath10k_wmi_10_2_4_op_pull_fw_stats()
> > > passes the rx_duration as part of the wmi_10_2_4_ext_peer_stats
> > > element which is basically a carbon-copy of wmi_10_2_4_peer_stats
> > > (but with one extra __le32 for the rx_duration at the end.)
> > > This rx_duration is then used to set the rx_duration field in the
> > > generated ath10k_fw_stats_peer struct.

[shafi] ok

> > > 
> > > 10.4's ath10k_wmi_10_4_op_pull_fw_stats() has a "fixed" wmi_10_4_peer_stats
> > > element and uses an separate "fixed" wmi_10_4_peer_extd_stats element for
> > > the communicating the rx_duration to the driver.

[shafi] ok

> > > 
> > > Thing is, both function have the same signature. They produce the same
> > > struct ath10k_fw_stats_peer for the given data in the sk_buff input. So
> > > why does 10.4 need to have it's peer_extd infrastructure, when it can use
> > > the existing rx_duration field in the *universal* ath10k_fw_stats_peer?
> > 
> > [shafi] agreed we need to fix that, it would have been easier if 10.2.4
> > and 10.4 had the same definitions.
> Ok, I don't know the internals of the firmware to know what's the difference
> between 10.2.4 and 10.4's rx_duration (how both firmwares define them 
> differently in this context) ? From what I can tell, it's just that
> the entry has moved from the peer stats to extended peer stats.
> Of course, this is based on the logic that both 10.2.4 and 10.4 rx_durations
> end up being added to arsta->rx_duration in the same way. There's no scaling
> or a comment that would indicate a difference.

[shafi] ok

> 
> > > 
> > > What's with the extra layers / HAL here? Because it looks like it's merged
> > > back together in the same manner into the same arsta->rx_duration?
> > > [ath10k_sta_update_stats_rx_duration() vs. 
> > >  ath10k_sta_update_extd_stats_rx_duration() - they are almost carbon copies too]

[shafi] my concern was for updating 'rx_duration' we just iterate over the list
and update the same.

> > > 
> > > > > diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> > > > > index c893314a191f..c7ec7b9e9b55 100644
> > > > > --- a/drivers/net/wireless/ath/ath10k/wmi.c
> > > > > +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> > > > > @@ -3044,23 +3044,41 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
> > > > >  	if ((stats_id & WMI_10_4_STAT_PEER_EXTD) == 0)
> > > > >  		return 0;
> > > > >  
> > > > > -	stats->extended = true;
> > > > > -
> > > > >  	for (i = 0; i < num_peer_stats; i++) {
> > > > >  		const struct wmi_10_4_peer_extd_stats *src;
> > > > > -		struct ath10k_fw_extd_stats_peer *dst;
> > > > > +		struct ath10k_fw_stats_peer *dst;
> > > > >  
> > > > >  		src = (void *)skb->data;
> > > > >  		if (!skb_pull(skb, sizeof(*src)))
> > > > >  			return -EPROTO;
> > > > >  
> > > > > -		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
> > > > > -		if (!dst)
> > > > > -			continue;
> > > > > +		/* Because the stat data may exceed htc-wmi buffer
> > > > > +		 * limit the firmware might split the stats data
> > > > > +		 * and delivers it in multiple update events.
> > > > > +		 * if we can't find the entry in the current event
> > > > > +		 * payload, we have to look in main list as well.
> > > > > +		 */
> > 
> > [shafi] thanks ! sorry i might have missed this bug, did you happen
> > to see this condition being hit ?
> This was copied from ath10k_debug_fw_stats_process() [2]. I've added Michal
> Kazior to the discussion since his patch "ath10k: fix fw stats processing"
> added this in debug.c. I think he knows the firmware internals well enough
> to tell if this is a problem or not. As it stands now, it is and will be
> in the future.

[shafi] sure.

>  
> > > > > +		list_for_each_entry(dst, &stats->peers, list) {
> > > > > +			if (ether_addr_equal(dst->peer_macaddr,
> > > > > +					     src->peer_macaddr.addr))
> > > > > +				goto found;
> > > > > +		}
> > > > > +
> > 
> > [shafi] Again, we can simply cache the macaddress and rx_duration
> > and deal with it later, rather than doing the whole lookup here ?
> > Will it be an overhead for large number of clients ?
> Well, show me how you would do it more efficiently otherwise? I don't
> see how you can cache the macaddress and rx_duration since you are
> basically forced to process all the peer stats first and later all
> the extended peer stats. They don't mix.

[shafi] hmmm, ok.

> 
> As for how expensive it is: From what I can tell, the 10.4 firmware
> sends the stat events every few seconds. So they are not part of any
> rx or tx hot-paths. The list_for_each within the for
> (i = 0; i < num_peers;i++)  is actually in the O(1) class as far
> as both loops go. This might sound funny at first, but the number of
> extended peer list is limited by TARGET_10_4_MAX_PEER_EXT_STATS to 16.
> And thanks to (***) the limit of num_peers is also 16. Furthermore
> we can add a if (ath10k_peer_stats_enabled(ar)) guard to skip it
> entirely if the stats are disabled.

[shafi] ok.
> 
> 
> > > > > +#ifdef CONFIG_ATH10K_DEBUGFS
> > > > > +		list_for_each_entry(dst, &ar->debug.fw_stats.peers, list) {
> > > > > +			if (ether_addr_equal(dst->peer_macaddr,
> > > > > +					     src->peer_macaddr.addr))
> > > > > +				goto found;
> > > > > +		}
> > > > > +#endif
> > 
> > [shafi] again, this could be handled seperately.
> This is more expensive. As fw_stats.peers can contain more entries than 16.
> However, this might be unnecessary if both peers and extended peers stats
> entries in the wmi event are always for the same stations.

[shafi] ok

> 
> Note: There's an alternative way too. Instead of writing rx_duration into
> ath10k_fw_stats, we could skip the middle man write it directly into
> arsta->rx_duration. This would also mean that we can get rid of
> ath10k_sta_update_extd_stats_rx_duration(), ath10k_sta_update_stats_rx_duration()
> and ath10k_sta_update_rx_duration(). This has the benifit that we can
> remove even more.
> 
> > > > > +
> > > > > +		ath10k_dbg(ar, ATH10K_DBG_WMI,
> > > > > +			   "Orphaned extended stats entry for station %pM.\n",
> > > > > +			   src->peer_macaddr.addr);
> > > > > +		continue;
> > > > >  
> > > > > -		ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
> > > > > +found:
> > > > >  		dst->rx_duration = __le32_to_cpu(src->rx_duration);
> > > > > -		list_add_tail(&dst->list, &stats->peers_extd);
> > > > >  	}
> > > > >  
> > > > >  	return 0;
> > > > 
> > > > [shafi] Yes i am bit concerned about this change making 10.4 to update
> > > > over the existing peer_stats structure, the idea is to maintain uniformity
> > > > between the structures shared between ath10k and its corresponding to avoid
> > > > confusion/ bugs in the future. Kindly let me know your thoughts, feel free
> > > > to correct me if any of my analysis is incorrect. thank you !
> > > Isn't the point of the ath10k_wmi_10_*_op_pull_fw_stats() functions to make 
> > > a "universal" statistic (in your case a unified ath10k_fw_stats_peer structure)
> > > that other functions can use, without caring about if the FW was 10.4 
> > > or 10.2.4?
> > > 
> > > There's no indication that the rx_duration field in wmi_10_2_4_ext_peer_stats
> > > conveys any different information than the rx_duration in 
> > > wmi_10_4_peer_extd_stats. So, what's going on here? Can't you just make
> > > wmi_10_4_peer_extd_stats's rx_duration use the existing field in
> > > ath10k_fw_stats_peer? And if not: why exactly?
> > >
> > [shafi] I will soon test your change and keep you posted. We will also
> > get Kalle's take/view on this. 
> Ok. That said, I added him to the CC from the beginning and so far
> he silently agreed.

[shafi] sure, I guess i quickly tested this change and I found things
are fine, it would be good if you can share your test results as well please
Yes we can discuss with Kalle and Michal ! If you guys think this is a more
optimized version of updating the peer stats, I am fine with that as well.
There is no doubt you guys know about open source better than me :-)


> 
> Regards,
> Christian
> 
> [0] <http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/debugfs_sta.c#L21>
> [1] <http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/debugfs_sta.c#L40>
> [2] <http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath10k/debug.c#L360>
> 
> 
