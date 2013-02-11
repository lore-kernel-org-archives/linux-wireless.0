Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3BKVeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:34:17 -0500
Message-ID: <1360618451.8738.46.camel@jlt4.sipsolutions.net> (sfid-20130211_223422_530836_2A816672)
Subject: Re: [PATCH 2/3] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 11 Feb 2013 22:34:11 +0100
In-Reply-To: <CAG6hwVN5vSxo5Cx0KypF4zQgy+rBudTgrDZ2z2dm8gsL-wRxgw@mail.gmail.com> (sfid-20130211_222455_883194_0E2B5F1F)
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
	 <1360616843-24618-2-git-send-email-thomas@cozybit.com>
	 <1360617458.8738.41.camel@jlt4.sipsolutions.net>
	 <CAG6hwVN5vSxo5Cx0KypF4zQgy+rBudTgrDZ2z2dm8gsL-wRxgw@mail.gmail.com>
	 (sfid-20130211_222455_883194_0E2B5F1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 13:24 -0800, Thomas Pedersen wrote:

> >> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> >> +     rcu_read_lock();
> >
> > This is weird since you already did it outside the function?
> 
> Yes, but we shouldn't rely on the caller creating an RCU read section?

I don't really see a problem with that, but the other locking issue
means that you need this anyway.

> >> +static int
> >> +ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
> >> +{
> >> +     struct ieee80211_sub_if_data *sdata;
> >> +     struct beacon_data *old_bcn;
> >> +     int ret;
> >> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> >> +
> >> +     rcu_read_lock();
> >> +     old_bcn = rcu_dereference(ifmsh->beacon);
> >> +     ret = ieee80211_mesh_build_beacon(ifmsh);
> >
> > This looks totally wrong. You must protect the assignment to
> > ifmsg->beacon by some lock, so then you don't need the rcu_read_lock()
> > here since you're under that lock, so this should be
> > rcu_dereference_protected(..., lockdep_is_held(whatever_lock));
> 
> OK, I guess we better protect assignment by some lock then :)

I'm sure there's some lock already? Otherwise doing mesh operations from
userspace and the workqueue would probably be quite racy?

> >> +     if (sdata->vif.bss_conf.enable_beacon &&
> >> +         (changed & (BSS_CHANGED_BEACON |
> >> +                     BSS_CHANGED_HT |
> >> +                     BSS_CHANGED_BASIC_RATES |
> >> +                     BSS_CHANGED_BEACON_INT)))
> >> +             if (ieee80211_mesh_rebuild_beacon(&sdata->u.mesh))
> >> +                     return;
> >
> > Does that return make any sense?
> 
> The alternative is to keep notifying the driver. I just wanted to stop
> everything since we're out of memory, but we can keep calling
> bss_info_change_notify() is you think that makes more sense.

Either way is fine to me.

> >> @@ -694,6 +833,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> >>       sdata->vif.bss_conf.enable_beacon = false;
> >>       clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
> >>       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
> >> +     kfree_rcu(ifmsh->beacon, rcu_head);
> >
> > I think you should set it to NULL first, just so it's clearer.
> 
> For who? It seems there is no need in this path, but OK.

You don't have any synchronize_rcu() here so how can you be sure there's
not someone, say in a tasklet, using ifmsh->beacon at this point?

> >> @@ -883,6 +1023,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
> >>       skb_queue_head_init(&ifmsh->ps.bc_buf);
> >>       spin_lock_init(&ifmsh->mesh_preq_queue_lock);
> >>       spin_lock_init(&ifmsh->sync_offset_lock);
> >> +     RCU_INIT_POINTER(ifmsh->beacon, NULL);
> >
> > Isn't everything initialized to 0/null?
> 
> Yep, I wanted any needed RCU magic to happen here though.

I don't think there's any RCU magic, particularly not with
RCU_INIT_POINTER, but I don't mind the assignment much :)

johannes

