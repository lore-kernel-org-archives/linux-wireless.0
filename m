Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58247 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbZBFTOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 14:14:04 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 11:14:04 -0800
Date: Fri, 6 Feb 2009 11:13:22 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/11] mac80211: fix race in TX aggregation
Message-ID: <20090206191322.GB5031@tesla> (sfid-20090206_201410_381018_D6D354BE)
References: <20090205160738.990564487@sipsolutions.net> <20090205161133.193146777@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090205161133.193146777@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 08:07:45AM -0800, Johannes Berg wrote:
> When disabling TX aggregation because it was rejected or from
> the timer (it was not accepted), there is a window where we
> first set the state to operation, unlock, and then undo the
> whole thing. Avoid that by splitting up the stop function.
> Also get rid of the pointless sta_info indirection in the timer.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/agg-tx.c |   95 +++++++++++++++++++++++++-------------------------
>  1 file changed, 48 insertions(+), 47 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/agg-tx.c 2009-01-29 02:03:28.000000000 +0100
> +++ wireless-testing/net/mac80211/agg-tx.c      2009-01-29 02:03:30.000000000 +0100
> @@ -123,6 +123,34 @@ void ieee80211_send_bar(struct ieee80211
>         ieee80211_tx_skb(sdata, skb, 0);
>  }
> 
> +static int __ieee80211_stop_tx_ba_session(struct ieee80211_local *local,
> +                                         struct sta_info *sta, u16 tid,
> +                                         enum ieee80211_back_parties initiator)
> +{
> +       int ret;
> +       u8 *state;
> +
> +       state = &sta->ampdu_mlme.tid_state_tx[tid];
> +
> +       if (local->hw.ampdu_queues)
> +               ieee80211_stop_queue(&local->hw, sta->tid_to_tx_q[tid]);
> +
> +       *state = HT_AGG_STATE_REQ_STOP_BA_MSK |
> +               (initiator << HT_AGG_STATE_INITIATOR_SHIFT);
> +
> +       ret = local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_STOP,
> +                                      &sta->sta, tid, NULL);
> +
> +       /* HW shall not deny going back to legacy */
> +       if (WARN_ON(ret)) {
> +               *state = HT_AGG_STATE_OPERATIONAL;
> +               if (local->hw.ampdu_queues)
> +                       ieee80211_wake_queue(&local->hw, sta->tid_to_tx_q[tid]);
> +       }
> +
> +       return ret;
> +}
> +
>  /*
>   * After sending add Block Ack request we activated a timer until
>   * add Block Ack response will arrive from the recipient.
> @@ -135,23 +163,13 @@ static void sta_addba_resp_timer_expired
>          * flow in sta_info_create gives the TID as data, while the timer_to_id
>          * array gives the sta through container_of */
>         u16 tid = *(u8 *)data;
> -       struct sta_info *temp_sta = container_of((void *)data,
> +       struct sta_info *sta = container_of((void *)data,
>                 struct sta_info, timer_to_tid[tid]);
> -
> -       struct ieee80211_local *local = temp_sta->local;
> -       struct ieee80211_hw *hw = &local->hw;
> -       struct sta_info *sta;
> +       struct ieee80211_local *local = sta->local;
>         u8 *state;
> 
> -       rcu_read_lock();
> -
> -       sta = sta_info_get(local, temp_sta->sta.addr);
> -       if (!sta) {
> -               rcu_read_unlock();
> -               return;
> -       }
> -
>         state = &sta->ampdu_mlme.tid_state_tx[tid];
> +
>         /* check if the TID waits for addBA response */
>         spin_lock_bh(&sta->lock);
>         if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
> @@ -161,21 +179,15 @@ static void sta_addba_resp_timer_expired
>                 printk(KERN_DEBUG "timer expired on tid %d but we are not "
>                                 "expecting addBA response there", tid);
>  #endif
> -               goto timer_expired_exit;
> +               return;
>         }
> 
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>         printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
>  #endif
> 
> -       /* go through the state check in stop_BA_session */
> -       *state = HT_AGG_STATE_OPERATIONAL;
> +       __ieee80211_stop_tx_ba_session(local, sta, tid, WLAN_BACK_INITIATOR);
>         spin_unlock_bh(&sta->lock);
> -       ieee80211_stop_tx_ba_session(hw, temp_sta->sta.addr, tid,
> -                                    WLAN_BACK_INITIATOR);
> -
> -timer_expired_exit:
> -       rcu_read_unlock();
>  }

Do we not need the sta under rcu lock on the sta_addba_resp_timer_expired()?
With this patch wouldn't we have a race between passing this to
__ieee80211_stop_tx_ba_session() and it being removed using sta_info_destroy()?

  Luis
