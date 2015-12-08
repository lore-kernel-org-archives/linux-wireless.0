Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52633 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbbLHRMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 12:12:54 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Subject: Re: [PATCH 2/2] mac80211: support hw managing reorder logic
Date: Tue, 8 Dec 2015 17:12:49 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E912D06@hasmsx107.ger.corp.intel.com> (sfid-20151208_181258_866825_65BBA5E4)
References: <1449594545-31028-1-git-send-email-emmanuel.grumbach@intel.com>
 <1449594545-31028-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/08/2015 07:09 PM, Grumbach, Emmanuel wrote:
> From: Sara Sharon <sara.sharon@intel.com>
>
> Enable driver to manage the reordering logic itself.
> This is needed for example for the iwlwifi driver that
> supports hardware based reordering.
>
> type=feature

Ouch - sorry for that. I guess you'll edit? Or you want me to resend?

> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  include/net/mac80211.h  |  6 ++++++
>  net/mac80211/agg-rx.c   | 24 ++++++++++++++++++++++--
>  net/mac80211/debugfs.c  |  1 +
>  net/mac80211/sta_info.h | 21 ++++++++++++---------
>  4 files changed, 41 insertions(+), 11 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0fad29c..916c29c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1943,6 +1943,11 @@ struct ieee80211_txq {
>   *	by just its MAC address; this prevents, for example, the same station
>   *	from connecting to two virtual AP interfaces at the same time.
>   *
> + * @IEEE80211_HW_SUPPORTS_REORDERING_BUFFER: Hardware (or driver) manages the
> + *	reordering buffer internally, guaranteeing mac80211 receives frames in
> + *	order and does not need to manage its own reorder buffer or BA session
> + *	timeout.
> + *
>   * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
>   */
>  enum ieee80211_hw_flags {
> @@ -1979,6 +1984,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
>  	IEEE80211_HW_BEACON_TX_STATUS,
>  	IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR,
> +	IEEE80211_HW_SUPPORTS_REORDERING_BUFFER,
>  
>  	/* keep last, obviously */
>  	NUM_IEEE80211_HW_FLAGS
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index ec80db7..2ab5479 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -76,10 +76,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  	tid_rx = rcu_dereference_protected(sta->ampdu_mlme.tid_rx[tid],
>  					lockdep_is_held(&sta->ampdu_mlme.mtx));
>  
> -	if (!tid_rx)
> +	if (!test_bit(tid, sta->ampdu_mlme.agg_session_valid))
>  		return;
>  
>  	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
> +	__clear_bit(tid, sta->ampdu_mlme.agg_session_valid);
>  
>  	ht_dbg(sta->sdata,
>  	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> @@ -97,6 +98,13 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  		ieee80211_send_delba(sta->sdata, sta->sta.addr,
>  				     tid, WLAN_BACK_RECIPIENT, reason);
>  
> +	/*
> +	 * return here in case tid_rx is not assigned - which will happen if
> +	 * IEEE80211_HW_SUPPORTS_REORDERING_BUFFER is set.
> +	 */
> +	if (!tid_rx)
> +		return;
> +
>  	del_timer_sync(&tid_rx->session_timer);
>  
>  	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
> @@ -297,7 +305,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
>  	/* examine state machine */
>  	mutex_lock(&sta->ampdu_mlme.mtx);
>  
> -	if (sta->ampdu_mlme.tid_rx[tid]) {
> +	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
>  		ht_dbg_ratelimited(sta->sdata,
>  				   "unexpected AddBA Req from %pM on tid %u\n",
>  				   sta->sta.addr, tid);
> @@ -308,6 +316,16 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
>  						false);
>  	}
>  
> +	if (ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER)) {
> +		ret = drv_ampdu_action(local, sta->sdata, &params);
> +		ht_dbg(sta->sdata,
> +		       "Rx A-MPDU request on %pM tid %d result %d\n",
> +		       sta->sta.addr, tid, ret);
> +		if (!ret)
> +			status = WLAN_STATUS_SUCCESS;
> +		goto end;
> +	}
> +
>  	/* prepare A-MPDU MLME for Rx aggregation */
>  	tid_agg_rx = kmalloc(sizeof(struct tid_ampdu_rx), GFP_KERNEL);
>  	if (!tid_agg_rx)
> @@ -369,6 +387,8 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
>  	}
>  
>  end:
> +	if (status == WLAN_STATUS_SUCCESS)
> +		__set_bit(tid, sta->ampdu_mlme.agg_session_valid);
>  	mutex_unlock(&sta->ampdu_mlme.mtx);
>  
>  end_no_lock:
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index abbdff0..e433d0c 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -126,6 +126,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
>  	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
>  	FLAG(BEACON_TX_STATUS),
>  	FLAG(NEEDS_UNIQUE_STA_ADDR),
> +	FLAG(SUPPORTS_REORDERING_BUFFER),
>  
>  	/* keep last for the build bug below */
>  	(void *)0x1
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index d605162..f4d3899 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -1,6 +1,7 @@
>  /*
>   * Copyright 2002-2005, Devicescape Software, Inc.
>   * Copyright 2013-2014  Intel Mobile Communications GmbH
> + * Copyright(c) 2015 Intel Deutschland GmbH
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -212,20 +213,21 @@ struct tid_ampdu_rx {
>  /**
>   * struct sta_ampdu_mlme - STA aggregation information.
>   *
> + * @mtx: mutex to protect all TX data (except non-NULL assignments
> + *	to tid_tx[idx], which are protected by the sta spinlock)
> + *	tid_start_tx is also protected by sta->lock.
>   * @tid_rx: aggregation info for Rx per TID -- RCU protected
> - * @tid_tx: aggregation info for Tx per TID
> - * @tid_start_tx: sessions where start was requested
> - * @addba_req_num: number of times addBA request has been sent.
> - * @last_addba_req_time: timestamp of the last addBA request.
> - * @dialog_token_allocator: dialog token enumerator for each new session;
> - * @work: work struct for starting/stopping aggregation
>   * @tid_rx_timer_expired: bitmap indicating on which TIDs the
>   *	RX timer expired until the work for it runs
>   * @tid_rx_stop_requested:  bitmap indicating which BA sessions per TID the
>   *	driver requested to close until the work for it runs
> - * @mtx: mutex to protect all TX data (except non-NULL assignments
> - *	to tid_tx[idx], which are protected by the sta spinlock)
> - *	tid_start_tx is also protected by sta->lock.
> + * @agg_session_valid: bitmap indicating which TID has a rx BA session open on
> + * @work: work struct for starting/stopping aggregation
> + * @tid_tx: aggregation info for Tx per TID
> + * @tid_start_tx: sessions where start was requested
> + * @last_addba_req_time: timestamp of the last addBA request.
> + * @addba_req_num: number of times addBA request has been sent.
> + * @dialog_token_allocator: dialog token enumerator for each new session;
>   */
>  struct sta_ampdu_mlme {
>  	struct mutex mtx;
> @@ -233,6 +235,7 @@ struct sta_ampdu_mlme {
>  	struct tid_ampdu_rx __rcu *tid_rx[IEEE80211_NUM_TIDS];
>  	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
>  	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
> +	unsigned long agg_session_valid[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
>  	/* tx */
>  	struct work_struct work;
>  	struct tid_ampdu_tx __rcu *tid_tx[IEEE80211_NUM_TIDS];

