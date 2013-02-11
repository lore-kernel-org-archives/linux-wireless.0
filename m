Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65284 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3BKVY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:24:56 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so2785138bkw.40
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:24:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360617458.8738.41.camel@jlt4.sipsolutions.net>
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
 <1360616843-24618-2-git-send-email-thomas@cozybit.com> <1360617458.8738.41.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 11 Feb 2013 13:24:34 -0800
Message-ID: <CAG6hwVN5vSxo5Cx0KypF4zQgy+rBudTgrDZ2z2dm8gsL-wRxgw@mail.gmail.com> (sfid-20130211_222459_526130_C224D325)
Subject: Re: [PATCH 2/3] mac80211: cache mesh beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 1:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-02-11 at 13:07 -0800, Thomas Pedersen wrote:
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
>
> This is weird since you already did it outside the function?

Yes, but we shouldn't rely on the caller creating an RCU read section?

>> +     chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
>> +     band = chanctx_conf->def.chan->band;
>
> could be NULL? I guess not at this point though.

Yeah it will have been set.

>> +static int
>> +ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     struct beacon_data *old_bcn;
>> +     int ret;
>> +     sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
>> +
>> +     rcu_read_lock();
>> +     old_bcn = rcu_dereference(ifmsh->beacon);
>> +     ret = ieee80211_mesh_build_beacon(ifmsh);
>
> This looks totally wrong. You must protect the assignment to
> ifmsg->beacon by some lock, so then you don't need the rcu_read_lock()
> here since you're under that lock, so this should be
> rcu_dereference_protected(..., lockdep_is_held(whatever_lock));

OK, I guess we better protect assignment by some lock then :)

>> +     if (sdata->vif.bss_conf.enable_beacon &&
>> +         (changed & (BSS_CHANGED_BEACON |
>> +                     BSS_CHANGED_HT |
>> +                     BSS_CHANGED_BASIC_RATES |
>> +                     BSS_CHANGED_BEACON_INT)))
>> +             if (ieee80211_mesh_rebuild_beacon(&sdata->u.mesh))
>> +                     return;
>
> Does that return make any sense?

The alternative is to keep notifying the driver. I just wanted to stop
everything since we're out of memory, but we can keep calling
bss_info_change_notify() is you think that makes more sense.

>>       changed |= ieee80211_mps_local_status_update(sdata);
>>
>> +     if (WARN_ON(ieee80211_mesh_build_beacon(ifmsh))) {
>
> no warning for memory allocation failures please

OK.

>> @@ -694,6 +833,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>       sdata->vif.bss_conf.enable_beacon = false;
>>       clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
>>       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>> +     kfree_rcu(ifmsh->beacon, rcu_head);
>
> I think you should set it to NULL first, just so it's clearer.

For who? It seems there is no need in this path, but OK.

>> @@ -883,6 +1023,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
>>       skb_queue_head_init(&ifmsh->ps.bc_buf);
>>       spin_lock_init(&ifmsh->mesh_preq_queue_lock);
>>       spin_lock_init(&ifmsh->sync_offset_lock);
>> +     RCU_INIT_POINTER(ifmsh->beacon, NULL);
>
> Isn't everything initialized to 0/null?

Yep, I wanted any needed RCU magic to happen here though.

-- 
Thomas
