Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52522 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1HPRfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 13:35:53 -0400
Received: by vxi9 with SMTP id 9so127530vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 10:35:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312893424.4109.41.camel@jlt3.sipsolutions.net>
References: <1311762139-18252-1-git-send-email-guy@wizery.com>
	<1312893424.4109.41.camel@jlt3.sipsolutions.net>
Date: Tue, 16 Aug 2011 20:35:52 +0300
Message-ID: <CAA03844=+XDyJN_SG-moAn8CvTyEQ_GSd_9e_APSuxr67nhBQg@mail.gmail.com> (sfid-20110816_193557_052831_4C446B35)
Subject: Re: [PATCH v2 2/2] mac80211: fix race condition between assoc_done
 and first EAP packet
From: Guy Eilam <guy@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 3:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-27 at 13:22 +0300, Guy Eilam wrote:
>
>> +++ b/net/mac80211/mlme.c
>> @@ -1495,10 +1495,14 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>>
>>       ifmgd->aid = aid;
>>
>> -     sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
>> -     if (!sta) {
>> -             printk(KERN_DEBUG "%s: failed to alloc STA entry for"
>> -                    " the AP\n", sdata->name);
>> +     mutex_lock(&sdata->local->sta_mtx);
>> +     /*
>> +      * station info was already allocated and inserted before
>> +      * the association and should be available to us
>> +      */
>> +     sta = sta_info_get_rx(sdata, cbss->bssid);
>> +     if (WARN_ON(!sta)) {
>> +             mutex_unlock(&sdata->local->sta_mtx);
>>               return false;
>>       }
>>
>> @@ -1569,8 +1573,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
>>       if (elems.wmm_param)
>>               set_sta_flags(sta, WLAN_STA_WME);
>>
>> -     err = sta_info_insert(sta);
>> +     err = sta_info_insert_notify(sta);
>
> I think I'd prefer if you could just call sta_info_insert() again with
> the existing station entry?

I can't do that because I have a lock at this point. _insert_notify()
is exactly the same as _insert(), but it expects to have sta_mtx
locked already.

>
>>       sta = NULL;
>> +     /* sta_info_insert_notify changed the mutex lock with rcu lock */
>> +     rcu_read_unlock();
>
> This was previously part of sta_info_insert() right?

Yes. I can insert it to _insert_notify().

>
>> +++ b/net/mac80211/rx.c
>> @@ -842,8 +842,21 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
>>                     ieee80211_is_pspoll(hdr->frame_control)) &&
>>                    rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
>>                    rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
>> -                  (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC))))
>> +                  (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
>> +             if (rx->sta && rx->sta->dummy &&
>> +                 ieee80211_is_data(hdr->frame_control)) {
>> +                     u16 ethertype;
>> +                     u8 *payload;
>> +
>> +                     payload = rx->skb->data +
>> +                             ieee80211_hdrlen(hdr->frame_control);
>> +                     ethertype = (payload[6] << 8) | payload[7];
>> +                     if (cpu_to_be16(ethertype) ==
>> +                             rx->sdata->control_port_protocol)
>
> Is there a frame length check here? Also can you just indent the
> rx->sdata part with four spaces instead of a tab so it's more clearly
> part of the if please.

I should probably check ieee80211_is_data_present() instead of just
ieee80211_is_data().

>
>> +++ b/net/mac80211/sta_info.c
>> @@ -102,6 +102,30 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>>                                   lockdep_is_held(&local->sta_mtx));
>>       while (sta) {
>>               if (sta->sdata == sdata &&
>> +                 !sta->dummy &&
>
> maybe put those on one line
>
>> @@ -450,17 +510,28 @@ static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
>>        */
>>
>>       spin_lock_irqsave(&local->sta_lock, flags);
>> -     /* check if STA exists already */
>> -     if (sta_info_get_bss(sdata, sta->sta.addr)) {
>> -             spin_unlock_irqrestore(&local->sta_lock, flags);
>> -             mutex_unlock(&local->sta_mtx);
>> -             rcu_read_lock();
>> -             return -EEXIST;
>> +     /*
>> +      * check if STA exists already.
>> +      * only accept a scenario of a second call to sta_info_insert_mgd
>> +      * with a dummy station entry that was inserted earlier
>> +      * in that case - assume that the dummy station flag should
>> +      * be removed.
>> +      */
>> +     exist_sta = sta_info_get_bss_rx(sdata, sta->sta.addr);
>> +     if (exist_sta) {
>> +             if (exist_sta == sta && sta->dummy && !sta_list_add) {
>> +                     sta->dummy = false;
>
> two things: why "sta_list_add"? I think it can be implicit.
>
> Secondly, I think sta->dummy must only be set to false in
> finish_insert(), when it would typically add it into the hash table etc.
> to preserve the right order of things and not introduce races with
> finding a non-dummy station that hasn't been fully inserted yet.

You are correct, the dummy=false shuold be moved to _finish_insert().
And I can remove the sta_list_add from the _mdg()/_non_ibss() function.
But I do need the sta_list_add flag in the sta_info_finish_insert() function,
because it have no ability to distinguish between a newly inserted dummy
station and a reinsertion of one (I don't want to add another check to
that function).

>
>>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>> -     wiphy_debug(local->hw.wiphy, "Inserted STA %pM\n", sta->sta.addr);
>> +     wiphy_debug(local->hw.wiphy, "Inserted %sSTA %pM\n",
>> +                     sta->dummy ? "Dummy " : "", sta->sta.addr);
>>  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
>
> I think you should lowercase "dummy" in debug messages where it's and
> adjective :)
>
>>       /* move reference to rcu-protected */
>>       rcu_read_lock();
>>       mutex_unlock(&local->sta_mtx);
>>
>> -     if (ieee80211_vif_is_mesh(&sdata->vif))
>> +     if (ieee80211_vif_is_mesh(&sdata->vif) && !sta->dummy)
>>               mesh_accept_plinks_update(sdata);
>
> why this? can't have a dummy on mesh anyway, no?
>
>> @@ -435,9 +440,15 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
>>  struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>>                             const u8 *addr);
>>
>> +struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
>> +                           const u8 *addr);
>> +
>>  struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
>>                                 const u8 *addr);
>>
>> +struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
>> +                               const u8 *addr);
>> +
>>  static inline
>>  void for_each_sta_info_type_check(struct ieee80211_local *local,
>>                                 const u8 *addr,
>> @@ -458,6 +469,22 @@ void for_each_sta_info_type_check(struct ieee80211_local *local,
>>               _sta = nxt,                                             \
>>               nxt = _sta ? rcu_dereference(_sta->hnext) : NULL        \
>>            )                                                          \
>> +     /* run code only if address matches and it's not a dummy sta */ \
>> +     if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0 &&\
>
> please keep the backslashes lined up
>
> Ok the only real problem is the place where you set dummy=false, but I'd
> also make the patch & code simpler by making it more implicit -- instead
> of having the sta_list_add argument everywhere I'd just check if it's a
> dummy being re-inserted etc.
>
> johannes
>
>

Guy.
