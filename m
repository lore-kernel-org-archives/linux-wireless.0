Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E45C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C073720838
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="W0/uShIU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C073720838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbeI1VuF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 17:50:05 -0400
Received: from mail.toke.dk ([52.28.52.200]:40003 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbeI1VuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 17:50:05 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1538148348; bh=R+TQHCNIudKILwJ4AyKuHZrpI63L+cAuAEdA6wlwMl8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=W0/uShIUgUvuTKAn1+BEOVArbUEtqgVkT1MOz7WRA/COqHgMShddwmW1tclWiOYgI
         DLsj+La3Xdww55zS5kXRMEgKkASHOtMT2AirRAN4q7C4gEUp53BuRZdWrNrIXdMmbw
         o3/ZFT6Z05dWYOHPG4o3xvkNcisxlacHO0PMXQSjuLGLHHjY4XxwoJ0SMwpyx9Ua0Y
         Fnv/j7ud2wU6scX++03C+kgtHGMnc7YRSnVSXu0TMkzYbAXTDm8cwi6a9dnQs9I7NS
         iPCvsKwLcXVIv7DQvD17GZlPnkbt6xysHiad95eV5/zV8jHaPEE6WCghHMFFyWDqua
         KsVVCs1pgJ6sA==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org> <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
Date:   Fri, 28 Sep 2018 17:25:47 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87lg7lfxtw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> Transmit airtime will be estimated from last tx rate used.
> Firmware report tx rate by peer stats. Airtime is computed
> on tx path and the same will be reported to mac80211 upon
> tx completion.
>
> Signed-off-by: Kan Yan <kyan@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.h   |  2 ++
>  drivers/net/wireless/ath/ath10k/htt_rx.c |  1 +
>  drivers/net/wireless/ath/ath10k/mac.c    | 58 ++++++++++++++++++++++++++++++--
>  drivers/net/wireless/ath/ath10k/txrx.c   |  4 +++
>  4 files changed, 62 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index d3e20aaf8023..4bfc370bf659 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -123,6 +123,7 @@ struct ath10k_skb_cb {
>  	u8 flags;
>  	u8 eid;
>  	u16 msdu_id;
> +	u16 airtime_est;
>  	struct ieee80211_vif *vif;
>  	struct ieee80211_txq *txq;
>  } __packed;
> @@ -493,6 +494,7 @@ struct ath10k_sta {
>  	u32 smps;
>  	u16 peer_id;
>  	struct rate_info txrate;
> +	u32 last_tx_bitrate;
>  
>  	struct work_struct update_wk;
>  	u64 rx_duration;
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index f2aaa2f7a022..f1de9fc09d9f 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2809,6 +2809,7 @@ static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
>  
>  	arsta->txrate.nss = txrate.nss;
>  	arsta->txrate.bw = ath10k_bw_to_mac80211_bw(txrate.bw);
> +	arsta->last_tx_bitrate = cfg80211_calculate_bitrate(&arsta->txrate);
>  
>  	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
>  		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index d4648b22ad64..a694dae6f024 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3528,7 +3528,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
>  static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
>  				    struct ieee80211_vif *vif,
>  				    struct ieee80211_txq *txq,
> -				    struct sk_buff *skb)
> +				    struct sk_buff *skb, u16 airtime)
>  {
>  	struct ieee80211_hdr *hdr = (void *)skb->data;
>  	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
> @@ -3545,6 +3545,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
>  
>  	cb->vif = vif;
>  	cb->txq = txq;
> +	cb->airtime_est = airtime;
>  }
>  
>  bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
> @@ -3932,6 +3933,50 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
>  	return false;
>  }
>  
> +/* Return estimated airtime in microsecond, which is calculated using last
> + * reported TX rate. This is just a rough estimation because host driver has no
> + * knowledge of the actual transmit rate, retries or aggregation. If actual
> + * airtime can be reported by firmware, then delta between estimated and actual
> + * airtime can be adjusted from deficit.
> + */
> +#define IEEE80211_ATF_OVERHEAD		100	/* IFS + some slot time */
> +#define IEEE80211_ATF_OVERHEAD_IFS	16	/* IFS only */
> +static u16 ath10k_mac_update_airtime(struct ath10k *ar,
> +				     struct ieee80211_txq *txq,
> +				     struct sk_buff *skb)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	struct ath10k_sta *arsta;
> +	u32 pktlen;
> +	u16 airtime = 0;
> +
> +	if (!txq || !txq->sta || !ieee80211_is_data(hdr->frame_control))
> +		return airtime;
> +
> +	spin_lock_bh(&ar->data_lock);
> +	arsta = (struct ath10k_sta *)txq->sta->drv_priv;
> +
> +	pktlen = skb->len + 38; /* Assume MAC header 30, SNAP 8 for most case */
> +	if (arsta->last_tx_bitrate) {
> +		/* airtime in us, last_tx_bitrate in 100kbps */
> +		airtime = (pktlen * 8 * (1000 / 100))
> +				/ arsta->last_tx_bitrate;
> +		/* overhead for media access time and IFS */
> +		airtime += IEEE80211_ATF_OVERHEAD_IFS;
> +	} else {
> +		/* This is mostly for throttle excessive BC/MC frames, and the
> +		 * airtime/rate doesn't need be exact. Airtime of BC/MC frames
> +		 * in 2G get some discount, which helps prevent very low rate
> +		 * frames from being blocked for too long.
> +		 */
> +		airtime = (pktlen * 8 * (1000 / 100)) / 60; /* 6M */
> +		airtime += IEEE80211_ATF_OVERHEAD;
> +	}
> +	spin_unlock_bh(&ar->data_lock);
> +
> +	return airtime;
> +}
> +
>  int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>  			   struct ieee80211_txq *txq)
>  {
> @@ -3947,6 +3992,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>  	size_t skb_len;
>  	bool is_mgmt, is_presp;
>  	int ret;
> +	u16 airtime;
>  
>  	spin_lock_bh(&ar->htt.tx_lock);
>  	ret = ath10k_htt_tx_inc_pending(htt);
> @@ -3964,7 +4010,8 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
>  		return -ENOENT;
>  	}
>  
> -	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
> +	airtime = ath10k_mac_update_airtime(ar, txq, skb);
> +	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
>  
>  	skb_len = skb->len;
>  	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
> @@ -4230,8 +4277,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
>  	bool is_mgmt;
>  	bool is_presp;
>  	int ret;
> +	u16 airtime;
>  
> -	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
> +	airtime = ath10k_mac_update_airtime(ar, txq, skb);
> +	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb, airtime);
>  
>  	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
>  	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
> @@ -8446,6 +8495,9 @@ int ath10k_mac_register(struct ath10k *ar)
>  		wiphy_ext_feature_set(ar->hw->wiphy,
>  				      NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
>  
> +	if (ath10k_peer_stats_enabled(ar))
> +		wiphy_ext_feature_set(ar->hw->wiphy,
> +				      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
>  	/*
>  	 * on LL hardware queues are managed entirely by the FW
>  	 * so we only advertise to mac we can do the queues thing
> diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
> index 23606b6972d0..8e7c416cd330 100644
> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -95,6 +95,10 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>  		wake_up(&htt->empty_tx_wq);
>  	spin_unlock_bh(&htt->tx_lock);
>  
> +	if (txq && txq->sta)
> +		ieee80211_sta_register_airtime(txq->sta, txq->tid,
> +					       skb_cb->airtime_est, 0);
> +

So this just uses the calculated airtime based on rate and size? Wasn't
there supposed to be an airtime usage value reported by the firmware? :)

-Toke
