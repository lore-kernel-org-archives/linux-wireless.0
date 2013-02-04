Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3BDSMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 13:12:55 -0500
Message-ID: <1360001598.17993.32.camel@jlt4.sipsolutions.net> (sfid-20130204_191302_377975_1213D0AB)
Subject: Re: [PATCH 1/3] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Feb 2013 19:13:18 +0100
In-Reply-To: <CAG6hwVMzisNe_x_5mpJWxC0X6uehafNqhdRSZohCe1qwmAfmBw@mail.gmail.com> (sfid-20130204_191020_701539_F2DCFF8C)
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
	 <1359853341-29237-2-git-send-email-thomas@cozybit.com>
	 <1359999430.17993.19.camel@jlt4.sipsolutions.net>
	 <CAG6hwVMzisNe_x_5mpJWxC0X6uehafNqhdRSZohCe1qwmAfmBw@mail.gmail.com>
	 (sfid-20130204_191020_701539_F2DCFF8C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 10:09 -0800, Thomas Pedersen wrote:
> On Mon, Feb 4, 2013 at 9:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> >> +static int
> >> +ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
> >> +{
> >> +     struct beacon_data *bcn;
> >> +     int head_len, tail_len;
> >> +     struct sk_buff *skb;
> >> +     struct ieee80211_mgmt *mgmt;
> >> +     struct ieee80211_chanctx_conf *chanctx_conf;
> >> +     enum ieee80211_band band;
> >> +     u8 *pos;
> >> +     struct ieee80211_sub_if_data *sdata;
> >> +     int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
> >> +                   sizeof(mgmt->u.beacon);
> >> +
> >> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> >> +     rcu_read_lock();
> >> +     chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> >> +     band = chanctx_conf->def.chan->band;
> >> +     rcu_read_unlock();
> >> +
> >> +     RCU_INIT_POINTER(ifmsh->beacon, NULL);
> >> +     synchronize_rcu();
> >
> > That doesn't seem right? Why force to NULL and synchronize, instead of
> > just building an update and overwriting the old beacon with the new,
> > using kfree_rcu() to get rid of the old afterwards? synchronize_rcu() is
> > quite expensive (might take hundreds of milliseconds.)
> 
> OK, I just copied this from the IBSS code. Overwriting the old one
> makes sense though.

What? I should check that out. OTOH, IBSS code never really changes its
beacon during operation, I think, so it might not matter much there?

> >> +     /* need an skb for IE builders to operate on */
> >> +     skb = dev_alloc_skb(max(head_len, tail_len));
> >
> > Heh. Might consider changing the IE builder functions?
> 
> Some IEs are variable length though, so I like how they append (and
> can check for space) the right length to skb->len.

Fair enough. It seemed a bit odd but I'm not worried about it.

> >> +             mpl_dbg(sdata, "couldn't rebuild mesh beacon, stopping!\n");
> >> +             ieee80211_stop_mesh(sdata);
> >
> > I'm not sure that's such a good idea? Nothing in userspace would expect
> > to randomly stop the mesh.
> 
> So if rebuilding failed, just continue with the old beacon?

That seems acceptable to me. You're probably running into bigger issues
if allocating a little bit of memory here already fails.

johannes

