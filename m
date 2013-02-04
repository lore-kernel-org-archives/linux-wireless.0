Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59610 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3BDSKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 13:10:15 -0500
Received: by mail-qc0-f173.google.com with SMTP id b12so2742157qca.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 10:10:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359999430.17993.19.camel@jlt4.sipsolutions.net>
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
 <1359853341-29237-2-git-send-email-thomas@cozybit.com> <1359999430.17993.19.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 4 Feb 2013 10:09:54 -0800
Message-ID: <CAG6hwVMzisNe_x_5mpJWxC0X6uehafNqhdRSZohCe1qwmAfmBw@mail.gmail.com> (sfid-20130204_191019_937237_C6EA58E5)
Subject: Re: [PATCH 1/3] mac80211: cache mesh beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 4, 2013 at 9:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> +static int
>> +ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
>> +{
>> +     struct beacon_data *bcn;
>> +     int head_len, tail_len;
>> +     struct sk_buff *skb;
>> +     struct ieee80211_mgmt *mgmt;
>> +     struct ieee80211_chanctx_conf *chanctx_conf;
>> +     enum ieee80211_band band;
>> +     u8 *pos;
>> +     struct ieee80211_sub_if_data *sdata;
>> +     int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
>> +                   sizeof(mgmt->u.beacon);
>> +
>> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
>> +     rcu_read_lock();
>> +     chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
>> +     band = chanctx_conf->def.chan->band;
>> +     rcu_read_unlock();
>> +
>> +     RCU_INIT_POINTER(ifmsh->beacon, NULL);
>> +     synchronize_rcu();
>
> That doesn't seem right? Why force to NULL and synchronize, instead of
> just building an update and overwriting the old beacon with the new,
> using kfree_rcu() to get rid of the old afterwards? synchronize_rcu() is
> quite expensive (might take hundreds of milliseconds.)

OK, I just copied this from the IBSS code. Overwriting the old one
makes sense though.

> Also, doesn't this just leak the old one?

ieee80211_mesh_rebuild_beacon() will free it, but maybe that doesn't make sense.

>> +     /* need an skb for IE builders to operate on */
>> +     skb = dev_alloc_skb(max(head_len, tail_len));
>
> Heh. Might consider changing the IE builder functions?

Some IEs are variable length though, so I like how they append (and
can check for space) the right length to skb->len.

>> +static int
>> +ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
>> +
>> +     rcu_read_lock();
>> +     kfree(rcu_dereference(ifmsh->beacon));
>> +     rcu_read_unlock();
>> +
>> +     if (WARN_ON(ieee80211_mesh_build_beacon(ifmsh))) {
>
> The warning is probably not a good idea since it's really for allocation
> failures only which already print long messages.

OK.

>> +             mpl_dbg(sdata, "couldn't rebuild mesh beacon, stopping!\n");
>> +             ieee80211_stop_mesh(sdata);
>
> I'm not sure that's such a good idea? Nothing in userspace would expect
> to randomly stop the mesh.

So if rebuilding failed, just continue with the old beacon?

>> +             return -1;
>
> Why not have a proper error code and propagate it properly? :)

OK.

-- 
Thomas
