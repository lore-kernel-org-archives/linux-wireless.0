Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60185 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1GOTaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 15:30:22 -0400
Received: by wyg8 with SMTP id 8so1015982wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 12:30:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310723669.4164.18.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-2-git-send-email-thomas@cozybit.com>
	<1310723669.4164.18.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jul 2011 12:30:20 -0700
Message-ID: <CAG6hwVONFH+vkSasF7AaSaqvHK78wwNtZesi0RSUnuCi17d9Fw@mail.gmail.com> (sfid-20110715_213025_973006_332D30CE)
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
>
>> +     if (ieee80211_vif_is_mesh(&sdata->vif))
>> +             rcu_assign_pointer(sdata->u.mesh.beacon, new);
>
> I don't think this compiles if MESH isn't configured into mac80211. Not
> sure adding lots of ifdefs is good, but it's probably the only choice
> right now.

The ifdef is already in ieee80211_vif_is_mesh()

>
>> @@ -461,6 +462,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>>  {
>>       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>>       struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_mgmt *bcn_head;
>> +     struct beacon_parameters bcn_params;
>> +     u8 *pos;
>>
>>       local->fif_other_bss++;
>>       /* mesh ifaces must set allmulti to forward mcast traffic */
>> @@ -473,7 +477,44 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>>       set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
>>       ieee80211_mesh_root_setup(ifmsh);
>>       ieee80211_queue_work(&local->hw, &sdata->work);
>> +
>> +     /* Build fixed part of mesh beacon. */
>> +     memset(&bcn_params, 0, sizeof(struct beacon_parameters));
>> +
>> +     /* header + fixed fields + null ssid */
>> +     bcn_params.head_len = 24 + sizeof(bcn_head->u.beacon) + 2;
>> +     pos = kmalloc(bcn_params.head_len, GFP_KERNEL | __GFP_ZERO);
>
> Err, kzalloc, don't use __GFP_ZERO.
>
>> +     if (mac80211_config_ops.add_beacon(sdata->wdev.wiphy, sdata->dev,
>> +                             &bcn_params))
>> +             printk(KERN_ERR "Unable to configure mesh beacon\n");
>
> That's horrible. Don't do that. Just do whatever is necessary inline. If
> you restructure, you only need like 10% of the code from
> ieee80211_config_beacon() anyway.
>
>> @@ -498,6 +540,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>        * it no longer is.
>>        */
>>       cancel_work_sync(&sdata->work);
>> +     if (sdata->u.mesh.beacon)
>> +             mac80211_config_ops.del_beacon(sdata->wdev.wiphy, sdata->dev);
>
> Ditto.
>
>>       } else if (ieee80211_vif_is_mesh(&sdata->vif)) {
>> -             struct ieee80211_mgmt *mgmt;
>> -             u8 *pos;
>> -
>> +             struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>>  #ifdef CONFIG_MAC80211_MESH
>>               if (!sdata->u.mesh.mesh_id_len)
>>                       goto out;
>>  #endif
>> +             beacon = rcu_dereference(ifmsh->beacon);
>
> not going to compile w/o CONFIG_MAC80211_MESH

I'll look into this.

>
>> +             if (beacon) {
>> +                     /* headroom, head length, tail length, mesh_ies and
>> +                      * maximum TIM length */
>> +                     skb = dev_alloc_skb(local->tx_headroom +
>> +                                         beacon->head_len +
>> +                                         beacon->tail_len + 400);
>
> what's + 400? You can't really think the TIM IE is that long?

No, but you're right, that number is pretty arbitrary. Maximum length
of mesh IEs currently (Mesh ID + Mesh Conf + Mesh Awake) is only 47.
Since mesh IEs have to be added during beacon time, might it make
sense to track the needed length in the if_mesh?

>
>> -             /* headroom, head length, tail length and maximum TIM length */
>> -             skb = dev_alloc_skb(local->tx_headroom + 400 +
>> -                             sdata->u.mesh.ie_len);
>
> I guess it was even there before though ... huh?
>
> Couldn't more code here be shared between mesh and AP? I don't see any
> difference here between mesh and AP.
>
> Also ... since you'll need PS support eventually anyway, maybe you
> should refactor "struct ieee80211_if_ap" into something AP-specific
> (currently only VLANs) and the rest, and then use "the rest" in mesh as
> well to make all this code more unified.

I like this approach much better. Are you suggesting just factoring
out the PS data, or taking it further and creating a generic "if which
beacons"?
> johannes
>
>

Thanks,
Thomas
