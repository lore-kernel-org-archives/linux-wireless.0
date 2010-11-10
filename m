Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab0KJQVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 11:21:34 -0500
Subject: Re: [RFC 1/5] mac80211: Add support for transmit beam forming.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 08:22:53 -0800
Message-ID: <1289406173.3748.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 17:53 +0530, Vivek Natarajan wrote:

> +struct ieee80211_txbf_caps {
> +	u32 implicit_rx_capable:1,
> +	    rx_staggered_sounding:1,
> +	    tx_staggered_sounding:1,
> +	    rx_ndp_capable:1,
> +	    tx_ndp_capable:1,
> +	    implicit_txbf_capable:1,
> +	    calibration:2,
> +	    explicit_csi_txbf_capable:1,
> +	    explicit_noncomp_steering:1,
> +	    explicit_comp_steering:1,
> +	    explicit_csi_feedback:2,
> +	    explicit_noncomp_bf:2,
> +	    explicit_comp_bf:2,
> +	    minimal_grouping:2,
> +	    csi_bfer_antennas:2,
> +	    noncomp_bfer_antennas:2,
> +	    comp_bfer_antennas:2,
> +	    csi_max_rows_bfer:2,
> +	    channel_estimation_cap:2,
> +	    reserved:3;
> +};

No way, never use bitfields.

> @@ -862,7 +901,7 @@ struct ieee80211_ht_cap {
>  	struct ieee80211_mcs_info mcs;
>  
>  	__le16 extended_ht_cap_info;
> -	__le32 tx_BF_cap_info;
> +	struct ieee80211_txbf_caps tx_BF_cap_info;
>  	u8 antenna_selection_info;
>  } __attribute__ ((packed));

keep __le32 and add #defines for the bits.
 
> @@ -321,6 +321,8 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
>   * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
>   *	frame and selects the maximum number of streams that it can use.
> + * @IEEE80211_TX_CTL_TXBF_UPDATE: Channel information needs to be updated
> + *    for beamforming of Tx frames.
>   *
>   * Note: If you have to add new flags to the enumeration, then don't
>   *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
> @@ -349,6 +351,8 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
>  	IEEE80211_TX_CTL_LDPC			= BIT(22),
>  	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
> +	IEEE80211_TX_CTL_TXBF_UPDATE		= BIT(25),
> +	IEEE80211_TX_CTL_STAG_SOUND		= BIT(26),

Missing docs for the second entry.

>  #define IEEE80211_TX_CTL_STBC_SHIFT		23
> @@ -364,7 +368,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
>  	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
>  	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
> -	IEEE80211_TX_CTL_STBC)
> +	IEEE80211_TX_CTL_STBC | IEEE80211_TX_CTL_TXBF_UPDATE)

Therefore I cannot evaluate this change.

> @@ -900,7 +904,8 @@ struct ieee80211_sta {
>  	u8 addr[ETH_ALEN];
>  	u16 aid;
>  	struct ieee80211_sta_ht_cap ht_cap;
> -
> +	bool txbf;

not sure I like names that short -- docs missing too

> @@ -698,6 +698,13 @@ static void sta_apply_parameters(struct ieee80211_local *local,
>  						  params->ht_capa,
>  						  &sta->sta.ht_cap);
>  
> +	if (sta->sta.ht_cap.explicit_compbf ||
> +	    sta->sta.ht_cap.explicit_noncompbf ||
> +	    sta->sta.ht_cap.implicit_bf) {
> +		sta->sta.txbf = true;
> +		sta->bf_update_cv = true;
> +	}

I wonder at what point we should move the capability handling from
hostapd to the kernel ...

> @@ -99,6 +100,23 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
>  	/* handle MCS rate 32 too */
>  	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
>  		ht_cap->mcs.rx_mask[32/8] |= 1;
> +
> +	bfee = ht_cap_ie->tx_BF_cap_info;
> +	bfmr = sband->ht_cap.txbf;

Nice variable names... what?

> +	if (bfmr.explicit_comp_steering && (bfee.explicit_comp_bf != 0))
> +		ht_cap->explicit_compbf = true;
> +
> +	if (bfmr.explicit_noncomp_steering && (bfee.explicit_noncomp_bf != 0))
> +		ht_cap->explicit_noncompbf = true;
> +
> +	if (bfmr.implicit_txbf_capable && bfee.implicit_rx_capable)
> +		ht_cap->implicit_bf = true;

xx = a && b;

instead of the if?

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -63,6 +63,8 @@
>  #define TMR_RUNNING_TIMER	0
>  #define TMR_RUNNING_CHANSW	1
>  
> +#define TXBF_CV_TIMER		1000

Err ... missing units.


> +void ieee80211_txbf_cv_work(struct work_struct *work)
> +{
> +	struct sta_info *sta =
> +		container_of(work, struct sta_info, txbf_cv_work.work);
> +	struct ieee80211_local *local = sta->local;
> +
> +	sta->bf_update_cv = true;
> +	ieee80211_queue_delayed_work(&local->hw,
> +				     &sta->txbf_cv_work, TXBF_CV_TIMER);
> +}

self arming -- how does it get cancelled properly?

also, this is part of a sta_info entry, so why is it in mlme.c??

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1455,6 +1455,16 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
>  	if (!ieee80211_is_data_qos(hdr->frame_control))
>  		return RX_CONTINUE;
>  
> +	/* Qos frame with Order bit set indicates an HTC frame */
> +	if (ieee80211_has_order(hdr->frame_control)) {
> +		memmove(data + IEEE80211_QOS_HTC_LEN, data,
> +			       ieee80211_hdrlen(hdr->frame_control) -
> +			       IEEE80211_QOS_HTC_LEN);
> +		hdr = (struct ieee80211_hdr *)skb_pull(rx->skb,
> +						       IEEE80211_QOS_HTC_LEN);
> +		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_ORDER);
> +	}
> +
>  	/* remove the qos control field, update frame type and meta-data */
>  	memmove(data + IEEE80211_QOS_CTL_LEN, data,
>  		ieee80211_hdrlen(hdr->frame_control) - IEEE80211_QOS_CTL_LEN);
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 6d8f897..829398e 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -235,6 +235,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	spin_lock_init(&sta->flaglock);
>  	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
>  	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
> +	INIT_DELAYED_WORK(&sta->txbf_cv_work, ieee80211_txbf_cv_work);
>  	mutex_init(&sta->ampdu_mlme.mtx);
>  
>  	memcpy(sta->sta.addr, addr, ETH_ALEN);
> @@ -691,6 +692,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
>  	wiphy_debug(local->hw.wiphy, "Removed STA %pM\n", sta->sta.addr);
>  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
>  	cancel_work_sync(&sta->drv_unblock_wk);
> +	cancel_delayed_work_sync(&sta->txbf_cv_work);
>  
>  	rate_control_remove_sta_debugfs(sta);
>  	ieee80211_sta_debugfs_remove(sta);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 9265aca..61631e3 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -312,6 +312,12 @@ struct sta_info {
>  	struct sta_ampdu_mlme ampdu_mlme;
>  	u8 timer_to_tid[STA_TID_NUM];
>  
> +	bool txbf;
> +	bool bf_update_cv;
> +	bool bf_sound_pending;
> +	bool allow_cv_update;
> +	struct delayed_work txbf_cv_work;
> +
>  #ifdef CONFIG_MAC80211_MESH
>  	/*
>  	 * Mesh peer link attributes
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 3153c19..b0447ca 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -209,6 +209,25 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  			return;
>  		}
>  
> +		if (ieee80211_has_order(fc)) {
> +			if ((info->flags & IEEE80211_TX_STAT_ACK) &&
> +			    (sta->bf_sound_pending)) {
> +				sta->bf_sound_pending = false;
> +				ieee80211_queue_delayed_work(&local->hw,
> +						&sta->txbf_cv_work, 1000);

1000 what?

> +			} else
> +				sta->bf_update_cv = true;
> +		}
> +
> +
> +		if ((info->flags & IEEE80211_TX_CTL_TXBF_UPDATE) &&
> +		    !(sta->bf_sound_pending)) {
> +			if (sta->sta.ht_cap.explicit_compbf ||
> +			    sta->sta.ht_cap.explicit_noncompbf ||
> +			    sta->sta.ht_cap.implicit_bf)
> +				sta->bf_update_cv = true;
> +		}
> +
>  		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
>  		    (rates_idx != -1))
>  			sta->last_tx_rate = info->status.rates[rates_idx];
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 96c5943..5900cf2 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1888,6 +1888,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	if ((sta_flags & WLAN_STA_WME) && local->hw.queues >= 4) {
>  		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
>  		hdrlen += 2;
> +	if (sta->bf_update_cv)
> +		hdrlen += 4;

4?

> @@ -1973,9 +1975,28 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  
>  	if (ieee80211_is_data_qos(fc)) {
>  		__le16 *qos_control;
> -
> -		qos_control = (__le16*) skb_push(skb, 2);
> -		memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
> +		__le32 *htc;
> +
> +		if (sta->bf_update_cv) {

It seems to me that this variable access is racy between the hdrlen += 4
and checking it again here since there's no locking on it.

> +			hdr.frame_control |= cpu_to_le16(IEEE80211_FCTL_ORDER);
> +			htc = (__le32 *) skb_push(skb, 4);
> +			sta->bf_sound_pending = true;
> +			*htc = 0;
> +			sta->bf_update_cv = false;
> +
> +			if (sta->sta.ht_cap.explicit_compbf)
> +				*htc |= IEEE80211_HTC2_CSI_COMP_BF;

no cpu_to_le32? have you run sparse on this?

> +			qos_control = (__le16 *) skb_push(skb, 2);
> +			memcpy(skb_push(skb, hdrlen - 6), &hdr, hdrlen - 6);
> +		} else {
> +			qos_control = (__le16 *) skb_push(skb, 2);
> +			memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
> +		};

}; ???

also why not move this out of the if()?

johannes

