Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33214 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbbEUIQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 04:16:58 -0400
Received: by wgjc11 with SMTP id c11so77411389wgj.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 01:16:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432127653.19214.12.camel@sipsolutions.net>
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
	<1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
	<1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
	<1432127653.19214.12.camel@sipsolutions.net>
Date: Thu, 21 May 2015 10:16:56 +0200
Message-ID: <CA+BoTQkpjDodKNdSvj2ZdKemXU_2E39MVGZPob8+jkjBGESEfg@mail.gmail.com> (sfid-20150521_101705_105916_99CC23CF)
Subject: Re: [PATCH v2 2/2] mac80211: prevent possible crypto tx tailroom corruption
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 15:14, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2015-05-13 at 09:16 +0000, Michal Kazior wrote:
>> There was a possible race between
>> ieee80211_reconfig() and
>> ieee80211_delayed_tailroom_dec(). This could
>> result in inability to transmit data if driver
>> crashed during roaming or rekeying and subsequent
>> skbs with insufficient tailroom appeared.
>>
>> This race was probably never seen in the wild
>> because a device driver would have to crash AND
>> recover within 0.5s which is very unlikely.
>>
>> I was able to prove this race exists after
>> changing the delay to 10s locally and crashing
>> ath10k via debugfs immediately after GTK
>> rekeying. In case of ath10k the counter went below
>> 0. This was harmless but other drivers which
>> actually require tailroom (e.g. for WEP ICV or
>> MMIC) could end up with the counter at 0 instead
>> of >0 and introduce insufficient skb tailroom
>> failures because mac80211 would not resize skbs
>> appropriately anymore.
>>
>> Fixes: 8d1f7ecd2af5 ("mac80211: defer tailroom counter manipulation when roaming")
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>
>> Notes:
>>     While doing PATCH v2 [1/2] I've noticed a subtle bug in the
>>     delayed tailroom counter logic. Since this touches the
>>     codepaths [1/2] does I'm posting this as a pair.
>>
>>  net/mac80211/key.c  | 5 ++++-
>>  net/mac80211/main.c | 3 +++
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
>> index 577a11a13cdf..4c6f8c97d11a 100644
>> --- a/net/mac80211/key.c
>> +++ b/net/mac80211/key.c
>> @@ -695,10 +695,13 @@ void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata)
>>       mutex_lock(&sdata->local->key_mtx);
>>
>>       sdata->crypto_tx_tailroom_needed_cnt = 0;
>> +     sdata->crypto_tx_tailroom_pending_dec = 0;
>>
>>       if (sdata->vif.type == NL80211_IFTYPE_AP) {
>> -             list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
>> +             list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
>>                       vlan->crypto_tx_tailroom_needed_cnt = 0;
>> +                     vlan->crypto_tx_tailroom_pending_dec = 0;
>> +             }
>>       }
>>
>>       mutex_unlock(&sdata->local->key_mtx);
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index 3c956c5f99b2..d8e1cbdcbc43 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -246,6 +246,7 @@ static void ieee80211_restart_work(struct work_struct *work)
>>  {
>>       struct ieee80211_local *local =
>>               container_of(work, struct ieee80211_local, restart_work);
>> +     struct ieee80211_sub_if_data *sdata;
>>
>>       /* wait for scan work complete */
>>       flush_workqueue(local->workqueue);
>> @@ -254,6 +255,8 @@ static void ieee80211_restart_work(struct work_struct *work)
>>            "%s called with hardware scan in progress\n", __func__);
>>
>>       rtnl_lock();
>> +     list_for_each_entry(sdata, &local->interfaces, list)
>> +             cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
>
> Would it make sense to just flush the work here? That way we don't have
> to do all the other things.

Hmm.. dec_tailroom_needed_wk is queued on system workqueue now so
there's no feasible way of flushing it (restart_work is on a system
workqueue as well). It'd need to be moved to local->workqueue. I guess
that would work too.


Michał
