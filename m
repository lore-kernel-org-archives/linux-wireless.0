Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3ARUyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:54:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TwIxJ-0003iz-HQ
	for linux-wireless@vger.kernel.org; Fri, 18 Jan 2013 21:54:29 +0100
Message-ID: <1358542494.7922.3.camel@jlt4.sipsolutions.net> (sfid-20130118_215436_637859_B6251102)
Subject: Re: [PATCH] mac80211: improve aggregation debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 18 Jan 2013 21:54:54 +0100
In-Reply-To: <1358340217-22419-1-git-send-email-johannes@sipsolutions.net> (sfid-20130116_134319_101644_09148CE1)
References: <1358340217-22419-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130116_134319_101644_09148CE1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 13:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> A lot of the aggregation messages don't indicate the
> station so they're hard to understand if there are
> multiple sessions in progress. Make that easier by
> adding the MAC address to most messages. Also add
> the TID if it wasn't already there.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/agg-rx.c | 14 +++++++++-----
>  net/mac80211/agg-tx.c | 44 +++++++++++++++++++++++++++-----------------
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 808338a..31bf258 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -83,8 +83,8 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
>  			     &sta->sta, tid, NULL, 0))
>  		sdata_info(sta->sdata,
> -			   "HW problem - can not stop rx aggregation for tid %d\n",
> -			   tid);
> +			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
> +			   sta->sta.addr, tid);
>  
>  	/* check if this is a self generated aggregation halt */
>  	if (initiator == WLAN_BACK_RECIPIENT && tx)
> @@ -159,7 +159,8 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
>  	}
>  	rcu_read_unlock();
>  
> -	ht_dbg(sta->sdata, "rx session timer expired on tid %d\n", (u16)*ptid);
> +	ht_dbg(sta->sdata, "RX session timer expired on %pM tid %d\n",
> +	       sta->sta.addr, (u16)*ptid);
>  
>  	set_bit(*ptid, sta->ampdu_mlme.tid_rx_timer_expired);
>  	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
> @@ -247,7 +248,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
>  	status = WLAN_STATUS_REQUEST_DECLINED;
>  
>  	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
> -		ht_dbg(sta->sdata, "Suspend in progress - Denying ADDBA request\n");
> +		ht_dbg(sta->sdata,
> +		       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
> +		       sta->sta.addr, tid);
>  		goto end_no_lock;
>  	}
>  
> @@ -317,7 +320,8 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
>  
>  	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
>  			       &sta->sta, tid, &start_seq_num, 0);
> -	ht_dbg(sta->sdata, "Rx A-MPDU request on tid %d result %d\n", tid, ret);
> +	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
> +	       sta->sta.addr, tid, ret);
>  	if (ret) {
>  		kfree(tid_agg_rx->reorder_buf);
>  		kfree(tid_agg_rx->reorder_time);
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 2f0ccbc..e909118 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -387,12 +387,13 @@ static void sta_addba_resp_timer_expired(unsigned long data)
>  	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
>  		rcu_read_unlock();
>  		ht_dbg(sta->sdata,
> -		       "timer expired on tid %d but we are not (or no longer) expecting addBA response there\n",
> -		       tid);
> +		       "timer expired on %pM tid %d but we are not (or no longer) expecting addBA response there\n",
> +		       sta->sta.addr, tid);
>  		return;
>  	}
>  
> -	ht_dbg(sta->sdata, "addBA response timer expired on tid %d\n", tid);
> +	ht_dbg(sta->sdata, "addBA response timer expired on %pM tid %d\n",
> +	       sta->sta.addr, tid);
>  
>  	ieee80211_stop_tx_ba_session(&sta->sta, tid);
>  	rcu_read_unlock();
> @@ -429,7 +430,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
>  			       &sta->sta, tid, &start_seq_num, 0);
>  	if (ret) {
>  		ht_dbg(sdata,
> -		       "BA request denied - HW unavailable for tid %d\n", tid);
> +		       "BA request denied - HW unavailable for %pM tid %d\n",
> +		       sta->sta.addr, tid);
>  		spin_lock_bh(&sta->lock);
>  		ieee80211_agg_splice_packets(sdata, tid_tx, tid);
>  		ieee80211_assign_tid_tx(sta, tid, NULL);
> @@ -442,7 +444,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
>  
>  	/* activate the timer for the recipient's addBA response */
>  	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
> -	ht_dbg(sdata, "activated addBA response timer on tid %d\n", tid);
> +	ht_dbg(sdata, "activated addBA response timer on %pM tid %d\n",
> +	       sta->sta.addr, tid);
>  
>  	spin_lock_bh(&sta->lock);
>  	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
> @@ -489,7 +492,8 @@ static void sta_tx_agg_session_timer_expired(unsigned long data)
>  
>  	rcu_read_unlock();
>  
> -	ht_dbg(sta->sdata, "tx session timer expired on tid %d\n", (u16)*ptid);
> +	ht_dbg(sta->sdata, "tx session timer expired on %pM tid %d\n",
> +	       sta->sta.addr, (u16)*ptid);
>  
>  	ieee80211_stop_tx_ba_session(&sta->sta, *ptid);
>  }
> @@ -525,7 +529,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  
>  	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
>  		ht_dbg(sdata,
> -		       "BA sessions blocked - Denying BA session request\n");
> +		       "BA sessions blocked - Denying BA session request %pM tid %d\n",
> +		       sta->sta.addr, tid);
>  		return -EINVAL;
>  	}
>  
> @@ -566,8 +571,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
>  			HT_AGG_RETRIES_PERIOD)) {
>  		ht_dbg(sdata,
> -		       "BA request denied - waiting a grace period after %d failed requests on tid %u\n",
> -		       sta->ampdu_mlme.addba_req_num[tid], tid);
> +		       "BA request denied - waiting a grace period after %d failed requests on %pM tid %u\n",
> +		       sta->ampdu_mlme.addba_req_num[tid], sta->sta.addr, tid);
>  		ret = -EBUSY;
>  		goto err_unlock_sta;
>  	}
> @@ -576,8 +581,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  	/* check if the TID is not in aggregation flow already */
>  	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
>  		ht_dbg(sdata,
> -		       "BA request denied - session is not idle on tid %u\n",
> -		       tid);
> +		       "BA request denied - session is not idle on %pM tid %u\n",
> +		       sta->sta.addr, tid);
>  		ret = -EAGAIN;
>  		goto err_unlock_sta;
>  	}
> @@ -632,7 +637,8 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
>  
>  	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>  
> -	ht_dbg(sta->sdata, "Aggregation is on for tid %d\n", tid);
> +	ht_dbg(sta->sdata, "Aggregation is on for %pM tid %d\n",
> +	       sta->sta.addr, tid);
>  
>  	drv_ampdu_action(local, sta->sdata,
>  			 IEEE80211_AMPDU_TX_OPERATIONAL,
> @@ -802,7 +808,9 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
>  	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>  
>  	if (!tid_tx || !test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
> -		ht_dbg(sdata, "unexpected callback to A-MPDU stop\n");
> +		ht_dbg(sdata,
> +		       "unexpected callback to A-MPDU stop for %pM tid %d\n",
> +		       sta->sta.addr, tid);
>  		goto unlock_sta;
>  	}
>  
> @@ -861,13 +869,15 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>  		goto out;
>  
>  	if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
> -		ht_dbg(sta->sdata, "wrong addBA response token, tid %d\n", tid);
> +		ht_dbg(sta->sdata, "wrong addBA response token, %pM tid %d\n",
> +		       sta->sta.addr, tid);
>  		goto out;
>  	}
>  
>  	del_timer_sync(&tid_tx->addba_resp_timer);
>  
> -	ht_dbg(sta->sdata, "switched off addBA timer for tid %d\n", tid);
> +	ht_dbg(sta->sdata, "switched off addBA timer for %pM tid %d\n",
> +	       sta->sta.addr, tid);
>  
>  	/*
>  	 * addba_resp_timer may have fired before we got here, and
> @@ -877,8 +887,8 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>  	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
>  	    test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
>  		ht_dbg(sta->sdata,
> -		       "got addBA resp for tid %d but we already gave up\n",
> -		       tid);
> +		       "got addBA resp for %pM tid %d but we already gave up\n",
> +		       sta->sta.addr, tid);
>  		goto out;
>  	}
>  


