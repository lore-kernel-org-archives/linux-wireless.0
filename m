Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53210 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2HCQ7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 12:59:22 -0400
Received: by ggnl2 with SMTP id l2so1073662ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2012 09:59:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343976236.4482.4.camel@jlt3.sipsolutions.net>
References: <1343951274-24956-1-git-send-email-thomas@cozybit.com> <1343976236.4482.4.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 3 Aug 2012 09:59:00 -0700
Message-ID: <CAG6hwVPMvfpVBfW_W-X6jGy-_GcF-9rX-3n2rhTrVzQKRmt2KQ@mail.gmail.com> (sfid-20120803_185926_160319_B31E9027)
Subject: Re: [PATCH 1/4] mac80211: leave mesh when stopping the netdev
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 11:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-08-02 at 16:47 -0700, Thomas Pedersen wrote:
>> Previously, we would merely stop the beacon and fail to free any mesh
>> specific data structures on netdev down or unregister. Split mesh
>> beacon, data, timer, and work cancel steps into ieee80211_mesh_stop() to
>> avoid decrementing the filter counters twice, and call this in the
>> ndo_stop handler.
>
> Now you're going overboard a bit :-)
>
> This isn't needed, as cfg80211 will explicitly leave the mesh while the
> netdev is going down (NETDEV_GOING_DOWN notification handler) without
> mac80211 even knowing yet that it's be going down.

Thanks for pointing that out. It seems we still need to avoid
decrementing the filter counters twice (once by cfg80211 in
ieee80211_stop_mesh() and again by mac80211 in the ndo_stop callback).
I'll work on this and submit a v2.

>> +++ b/net/mac80211/iface.c
>> @@ -689,6 +689,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>>               local->fif_probe_req--;
>>       } else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
>>               local->fif_probe_req--;
>> +     } else if (ieee80211_vif_is_mesh(&sdata->vif)) {
>> +             local->fif_other_bss--;
>
> I think this may be wrong since it's only incremented when we join the
> mesh, so it will cause the number to become negative if we never join
> the mesh, or if we correctly leave it before going down (as we actually
> do)
>
>> @@ -733,6 +735,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>>               skb_queue_purge(&sdata->u.ap.ps_bc_buf);
>>       } else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>>               ieee80211_mgd_stop(sdata);
>> +     } else if (ieee80211_vif_is_mesh(&sdata->vif)) {
>> +             ieee80211_mesh_stop(sdata);
>>       }
>
> This isn't needed, since we already called stop_mesh from cfg.c via
> cfg80211.
>
>> @@ -771,14 +775,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>>               skb_queue_purge(&sdata->skb_queue);
>>
>>               /*
>> -              * Disable beaconing here for mesh only, AP and IBSS
>> -              * are already taken care of.
>> -              */
>> -             if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
>> -                     ieee80211_bss_info_change_notify(sdata,
>> -                             BSS_CHANGED_BEACON_ENABLED);
>
> This makes sense, it's already done anyway.
>
>
>> --- a/net/mac80211/mesh.c
>> +++ b/net/mac80211/mesh.c
>> @@ -611,14 +611,17 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>>                                               BSS_CHANGED_BEACON_INT);
>>  }
>>
>> -void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>> +void ieee80211_mesh_stop(struct ieee80211_sub_if_data *sdata)
>>  {
>> -     struct ieee80211_local *local = sdata->local;
>>       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>>
>> +     /* stop the beacon */
>>       ifmsh->mesh_id_len = 0;
>>       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>> -     sta_info_flush(local, NULL);
>> +
>> +     /* flush STAs and mpaths on this iface */
>> +     sta_info_flush(sdata->local, sdata);
>> +     mesh_path_flush_by_iface(sdata);
>>
>>       del_timer_sync(&sdata->u.mesh.housekeeping_timer);
>>       del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
>
> This also makes sense, of course.
>
>> @@ -630,6 +633,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>        * it no longer is.
>>        */
>>       cancel_work_sync(&sdata->work);
>> +}
>> +
>> +void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_local *local = sdata->local;
>> +
>> +     ieee80211_mesh_stop(sdata);
>>
>>       local->fif_other_bss--;
>>       atomic_dec(&local->iff_allmultis);
>
> Ok so you're trying to split it up, but I don't think that makes sense
> since we'll always call stop_mesh() before the interface goes down.
>
> johannes
>
