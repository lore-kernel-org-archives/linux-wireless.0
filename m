Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr50068.outbound.protection.outlook.com ([40.107.5.68]:18656
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751168AbeDTTnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 15:43:37 -0400
Subject: Re: [PATCH 8/9] mac80211: Support adding duration for prepare_tx()
 callback
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20180420104926.8816-1-luca@coelho.fi>
 <20180420104926.8816-9-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <a36e55e5-1368-a3ef-9d5b-a53b0307e07d@bowerswilkins.com> (sfid-20180420_214343_785014_D63F158D)
Date: Fri, 20 Apr 2018 12:43:20 -0700
MIME-Version: 1.0
In-Reply-To: <20180420104926.8816-9-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

where is the 9th patch gone?


On 04/20/2018 03:49 AM, Luca Coelho wrote:
> From: Ilan Peer <ilan.peer@intel.com>
>
> There are specific cases, such as SAE authentication exchange, that
> might require long duration to complete. For such cases, add support
> for indicating to the driver the required duration of the prepare_tx()
> operation, so the driver would still be able to complete the frame
> exchange.
>
> Currently, indicate the duration only for SAE authentication exchange,
> as SAE authentication can take up to 2000 msec (as defined in IEEE
> P802.11-REVmd D1.0 p. 3504).
>
> As the patch modified the prepare_tx() callback API, also modify
> the relevant code in iwlwifi.
>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>   drivers/net/wireless/ath/ath9k/main.c         |  3 ++-
>   .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  6 ++++-
>   include/net/mac80211.h                        |  5 +++-
>   net/mac80211/driver-ops.h                     |  8 +++---
>   net/mac80211/mlme.c                           | 17 ++++++++-----
>   net/mac80211/trace.h                          | 25 ++++++++++++++++---
>   6 files changed, 49 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a3be8add56e1..b6663c80e7dd 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2544,7 +2544,8 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
>   }
>   
>   static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
> -				 struct ieee80211_vif *vif)
> +				 struct ieee80211_vif *vif,
> +				 u16 duration)
>   {
>   	struct ath_softc *sc = hw->priv;
>   	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> index 51b30424575b..4e428427d1ba 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
> @@ -2810,7 +2810,8 @@ static int iwl_mvm_mac_conf_tx(struct ieee80211_hw *hw,
>   }
>   
>   static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
> -				      struct ieee80211_vif *vif)
> +				       struct ieee80211_vif *vif,
> +				       u16 req_duration)
>   {
>   	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
>   	u32 duration = IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS;
> @@ -2823,6 +2824,9 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
>   	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PREPARE_TX))
>   		return;
>   
> +	if (req_duration > duration)
> +		duration = req_duration;
> +
>   	mutex_lock(&mvm->mutex);
>   	/* Try really hard to protect the session and hear a beacon */
>   	iwl_mvm_protect_session(mvm, vif, duration, min_duration, 500, false);
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 52f36c43f35f..cde1db0f6573 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -3378,6 +3378,8 @@ enum ieee80211_reconfig_type {
>    *	frame in case that no beacon was heard from the AP/P2P GO.
>    *	The callback will be called before each transmission and upon return
>    *	mac80211 will transmit the frame right away.
> + *      If duration is greater than zero, mac80211 hints to the driver the
> + *      duration for which the operation is requested.
>    *	The callback is optional and can (should!) sleep.
>    *
>    * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
> @@ -3697,7 +3699,8 @@ struct ieee80211_ops {
>   				  u32 sset, u8 *data);
>   
>   	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
> -				  struct ieee80211_vif *vif);
> +				  struct ieee80211_vif *vif,
> +				  u16 duration);
>   
>   	void	(*mgd_protect_tdls_discover)(struct ieee80211_hw *hw,
>   					     struct ieee80211_vif *vif);
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 4d82fe7d627c..8f6998091d26 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -2,6 +2,7 @@
>   /*
>   * Portions of this file
>   * Copyright(c) 2016 Intel Deutschland GmbH
> +* Copyright (C) 2018 Intel Corporation
>   */
>   
>   #ifndef __MAC80211_DRIVER_OPS
> @@ -813,7 +814,8 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
>   }
>   
>   static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
> -				      struct ieee80211_sub_if_data *sdata)
> +				      struct ieee80211_sub_if_data *sdata,
> +				      u16 duration)
>   {
>   	might_sleep();
>   
> @@ -821,9 +823,9 @@ static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
>   		return;
>   	WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
>   
> -	trace_drv_mgd_prepare_tx(local, sdata);
> +	trace_drv_mgd_prepare_tx(local, sdata, duration);
>   	if (local->ops->mgd_prepare_tx)
> -		local->ops->mgd_prepare_tx(&local->hw, &sdata->vif);
> +		local->ops->mgd_prepare_tx(&local->hw, &sdata->vif, duration);
>   	trace_drv_return_void(local);
>   }
>   
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 51021d3d2d18..e2d254a85bd3 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -864,7 +864,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
>   		return;
>   	}
>   
> -	drv_mgd_prepare_tx(local, sdata);
> +	drv_mgd_prepare_tx(local, sdata, 0);
>   
>   	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
>   	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
> @@ -2022,7 +2022,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>   		 */
>   		if (ieee80211_hw_check(&local->hw, DEAUTH_NEED_MGD_TX_PREP) &&
>   		    !ifmgd->have_beacon)
> -			drv_mgd_prepare_tx(sdata->local, sdata);
> +			drv_mgd_prepare_tx(sdata->local, sdata, 0);
>   
>   		ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
>   					       reason, tx, frame_buf);
> @@ -2560,7 +2560,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
>   	if (!elems.challenge)
>   		return;
>   	auth_data->expected_transaction = 4;
> -	drv_mgd_prepare_tx(sdata->local, sdata);
> +	drv_mgd_prepare_tx(sdata->local, sdata, 0);
>   	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
>   		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
>   			   IEEE80211_TX_INTFL_MLME_CONN_TX;
> @@ -3769,6 +3769,7 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
>   	u32 tx_flags = 0;
>   	u16 trans = 1;
>   	u16 status = 0;
> +	u16 prepare_tx_duration = 0;
>   
>   	sdata_assert_lock(sdata);
>   
> @@ -3790,7 +3791,11 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
>   		return -ETIMEDOUT;
>   	}
>   
> -	drv_mgd_prepare_tx(local, sdata);
> +	if (auth_data->algorithm == WLAN_AUTH_SAE)
> +		prepare_tx_duration =
> +			jiffies_to_msecs(IEEE80211_AUTH_TIMEOUT_SAE);
> +
> +	drv_mgd_prepare_tx(local, sdata, prepare_tx_duration);
>   
>   	sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
>   		   auth_data->bss->bssid, auth_data->tries,
> @@ -4994,7 +4999,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>   			   req->bssid, req->reason_code,
>   			   ieee80211_get_reason_code_string(req->reason_code));
>   
> -		drv_mgd_prepare_tx(sdata->local, sdata);
> +		drv_mgd_prepare_tx(sdata->local, sdata, 0);
>   		ieee80211_send_deauth_disassoc(sdata, req->bssid,
>   					       IEEE80211_STYPE_DEAUTH,
>   					       req->reason_code, tx,
> @@ -5014,7 +5019,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>   			   req->bssid, req->reason_code,
>   			   ieee80211_get_reason_code_string(req->reason_code));
>   
> -		drv_mgd_prepare_tx(sdata->local, sdata);
> +		drv_mgd_prepare_tx(sdata->local, sdata, 0);
>   		ieee80211_send_deauth_disassoc(sdata, req->bssid,
>   					       IEEE80211_STYPE_DEAUTH,
>   					       req->reason_code, tx,
> diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
> index 591ad02e1fa4..80a7edf8d314 100644
> --- a/net/mac80211/trace.h
> +++ b/net/mac80211/trace.h
> @@ -2,6 +2,7 @@
>   /*
>   * Portions of this file
>   * Copyright(c) 2016 Intel Deutschland GmbH
> +* Copyright (C) 2018 Intel Corporation
>   */
>   
>   #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
> @@ -1413,11 +1414,29 @@ DEFINE_EVENT(release_evt, drv_allow_buffered_frames,
>   	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
>   );
>   
> -DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
> +TRACE_EVENT(drv_mgd_prepare_tx,
>   	TP_PROTO(struct ieee80211_local *local,
> -		 struct ieee80211_sub_if_data *sdata),
> +		 struct ieee80211_sub_if_data *sdata,
> +		 u16 duration),
>   
> -	TP_ARGS(local, sdata)
> +	TP_ARGS(local, sdata, duration),
> +
> +	TP_STRUCT__entry(
> +		LOCAL_ENTRY
> +		VIF_ENTRY
> +		__field(u32, duration)
> +	),
> +
> +	TP_fast_assign(
> +		LOCAL_ASSIGN;
> +		VIF_ASSIGN;
> +		__entry->duration = duration;
> +	),
> +
> +	TP_printk(
> +		LOCAL_PR_FMT VIF_PR_FMT " duration: %u",
> +		LOCAL_PR_ARG, VIF_PR_ARG, __entry->duration
> +	)
>   );
>   
>   DEFINE_EVENT(local_sdata_evt, drv_mgd_protect_tdls_discover,
