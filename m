Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:55230 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYE0FXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 01:23:12 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2494630waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2008 22:23:10 -0700 (PDT)
Message-ID: <1ba2fa240805262223u4f884d16g5883dd6c7ba9c670@mail.gmail.com> (sfid-20080527_072315_212813_01B82758)
Date: Tue, 27 May 2008 08:23:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1211811554.4843.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
	 <1211811554.4843.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2008 at 5:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-05-26 at 17:09 +0300, Tomas Winkler wrote:
>> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>>
>> This patch fixes a deadlock of sta->lock use, occuring while changing
>> tx aggregation states, as dev_queue_xmit end up in new function
>> test_and_clear_sta_flags that uses that lock thus leading to deadlock
>
> Oh, good catch, thanks. Reminds me to debug the other deadlock I saw
> (not mac80211 related though)
>
>> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
>> ---
>>  net/mac80211/main.c |   10 +++++++---
>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index b0fddb7..5a9030c 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -662,6 +662,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
>>               goto start_ba_err;
>>       }
>>
>> +     spin_unlock_bh(&sta->lock);
>> +
>>       /* Will put all the packets in the new SW queue */
>>       ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
>>       spin_unlock_bh(&local->mdev->queue_lock);
>> @@ -688,9 +690,9 @@ start_ba_err:
>>       kfree(sta->ampdu_mlme.tid_tx[tid]);
>>       sta->ampdu_mlme.tid_tx[tid] = NULL;
>>       spin_unlock_bh(&local->mdev->queue_lock);
>> +     spin_unlock_bh(&sta->lock);
>>       ret = -EBUSY;
>>  start_ba_exit:
>> -     spin_unlock_bh(&sta->lock);
>>       rcu_read_unlock();
>>       return ret;
>>  }
>> @@ -829,10 +831,11 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
>>       }
>>       state = &sta->ampdu_mlme.tid_state_tx[tid];
>>
>> -     spin_lock_bh(&sta->lock);
>> +     /* no need to use sta->lock in this state check, as
>> +      * ieee80211_stop_tx_ba_session will let only
>> +      * one stop call to pass through per sta/tid */
>>       if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
>>               printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
>> -             spin_unlock_bh(&sta->lock);
>>               rcu_read_unlock();
>>               return;
>>       }
>> @@ -855,6 +858,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
>>        * ieee80211_wake_queue is not used here as this queue is not
>>        * necessarily stopped */
>>       netif_schedule(local->mdev);
>> +     spin_lock_bh(&sta->lock);
>>       *state = HT_AGG_STATE_IDLE;
>>       sta->ampdu_mlme.addba_req_num[tid] = 0;
>>       kfree(sta->ampdu_mlme.tid_tx[tid]);
>

This patch is wrong, it breaks error path.locking.Will resubmit
Tomas
