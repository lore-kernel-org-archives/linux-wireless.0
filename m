Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5BCC4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19056207E0
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbfDBJu1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:50:27 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40343 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729178AbfDBJuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:50:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id h22so11045753edw.7
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 02:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yh52U9OeiTcBOAzIuB+U5ihLYPZLSJjULslMLWmhpC8=;
        b=obUG3TBCUMzYbFUOf6ntn5gEQ+fK5WoQj3Wr9uYi4hUwmRQoE0SIMgqYGTGgLRmxlR
         LMnfvidcVhYYHXELCuZEuy3nKoH+2GBGxQ73/AaN/wlE2RTc1NFB4Jl9Fj0kxg5R8DSN
         ggCYfGN0Mo/IJ83ONBl3nINLsITibDwp1YjLvutjMZ+6VCBGDOg5CgLZcPAJoydT3tgJ
         ZpmG6JxrNWGqVyB/UxQYNOjPRRLyaU6jHLM0PmLJawbNxHHklDNjild6QnzfvxTPjcGJ
         KoaqJcyThQb8SBOqC/psIaoDDlJX/TRCBiNe0grrCR7bKnDn3G4HE3w2NRYvnTkqGn3c
         QqPw==
X-Gm-Message-State: APjAAAVba/03N6FMEJSAA/aZYrQcyKKnIPlhRSQZ9Q9to0pPczZSy8CV
        +pyDRZvjrdccoTHkUMaoGek+0w==
X-Google-Smtp-Source: APXvYqyT9KV60OYMrUcJJuSVKiGoUoq8EldTs07WXyWmccH6Q94XKfOWXYVojQ2+b+OhrA94ze/FdA==
X-Received: by 2002:a17:906:49d9:: with SMTP id w25mr38721979ejv.52.1554198623030;
        Tue, 02 Apr 2019 02:50:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id g3sm3862980edh.83.2019.04.02.02.50.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Apr 2019 02:50:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CF97618200F; Tue,  2 Apr 2019 11:50:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading support
In-Reply-To: <20190401131416.22646-2-john@phrozen.org>
References: <20190401131416.22646-1-john@phrozen.org> <20190401131416.22646-2-john@phrozen.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 02 Apr 2019 11:50:21 +0200
Message-ID: <87k1gcpwgy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Crispin <john@phrozen.org> writes:

> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>
> This patch adds a new transmit path for hardware that supports 802.11
> encapsulation offloading. In those cases 802.3a frames get passed
> directly to the driver allowing to hardware to handle the encapsulation.
>
> Certain features wont work and the patch masks these out.
> * monitor interfaces are not supported if any of the vif is in encap mode.
> * amsdu/non-linear frames wont work in encap offloading mode.
> * TKIP countermeasures cannot be triggered and hence those keys are not
>   accepted.
>
> The patch defines a secondary netdev_ops struct that the device is assigned
> to the device if 802.11 encap support is available and enabled. The driver
> needs to enable the support on a per vif basis if it finds that all
> pre-reqs are meet.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: John Crispin <john@phrozen.org>
> ---
>  include/net/mac80211.h     |  25 ++++++
>  net/mac80211/cfg.c         |  12 ++-
>  net/mac80211/debugfs.c     |   1 +
>  net/mac80211/ieee80211_i.h |  10 +++
>  net/mac80211/iface.c       |  54 +++++++++++++
>  net/mac80211/key.c         |   3 +
>  net/mac80211/main.c        |  10 ++-
>  net/mac80211/status.c      |  79 +++++++++++++++++++
>  net/mac80211/tx.c          | 188 +++++++++++++++++++++++++++++++++++++++++++--
>  9 files changed, 373 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index ac2ed8ec662b..3e8929770839 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1021,6 +1021,7 @@ struct ieee80211_tx_info {
>  			struct ieee80211_key_conf *hw_key;
>  			u32 flags;
>  			codel_time_t enqueue_time;
> +			u8 hw_80211_encap;
>  		} control;
>  		struct {
>  			u64 cookie;
> @@ -2243,6 +2244,9 @@ struct ieee80211_txq {
>   * @IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID: Hardware supports multi BSSID
>   *	only for HE APs. Applies if @IEEE80211_HW_SUPPORTS_MULTI_BSSID is set.
>   *
> + * @IEEE80211_HW_SUPPORTS_80211_ENCAP: Hardware/driver supports 802.11
> + *	encap for data frames.
> + *
>   * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
>   */
>  enum ieee80211_hw_flags {
> @@ -2294,6 +2298,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
>  	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
>  	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
> +	IEEE80211_HW_SUPPORTS_80211_ENCAP,
>  
>  	/* keep last, obviously */
>  	NUM_IEEE80211_HW_FLAGS
> @@ -4587,6 +4592,25 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
>  				 struct sk_buff *skb);
>  
>  /**
> + * ieee80211_tx_status_8023 - transmit status callback for 802.3 frame format
> + *
> + * Call this function for all transmitted data frames after their transmit
> + * completion. This callback should only be called for data frames which
> + * are are using driver's (or hardware's) offload capability of encap/decap
> + * 802.11 frames.
> + *
> + * This function may not be called in IRQ context. Calls to this function
> + * for a single hardware must be synchronized against each other.
> + *
> + * @hw: the hardware the frame was transmitted by
> + * @vif: the interface for which the frame was transmitted
> + * @skb: the frame that was transmitted, owned by mac80211 after this call
> + */
> +void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
> +			       struct ieee80211_vif *vif,
> +			       struct sk_buff *skb);
> +
> +/**
>   * ieee80211_report_low_ack - report non-responding station
>   *
>   * When operating in AP-mode, call this function to report a non-responding
> @@ -6359,4 +6383,5 @@ void ieee80211_nan_func_match(struct ieee80211_vif *vif,
>  			      struct cfg80211_nan_match_params *match,
>  			      gfp_t gfp);
>  
> +void ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable);
>  #endif /* MAC80211_H */
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 09dd1c2860fc..53b56f8fcdfc 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -367,8 +367,15 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
>  
>  	/* reject WEP and TKIP keys if WEP failed to initialize */
>  	switch (params->cipher) {
> -	case WLAN_CIPHER_SUITE_WEP40:
>  	case WLAN_CIPHER_SUITE_TKIP:
> +		/* countermeasures wont work on encap offload mode so reject
> +		 * TKIP keys
> +		 */
> +		if (ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP))
> +			return -EINVAL;
> +
> +		/* drop through */
> +	case WLAN_CIPHER_SUITE_WEP40:
>  	case WLAN_CIPHER_SUITE_WEP104:
>  		if (IS_ERR(local->wep_tx_tfm))
>  			return -EINVAL;
> @@ -2379,6 +2386,9 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>  	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
>  		ieee80211_check_fast_xmit_all(local);
>  
> +		if (ieee80211_is_hw_80211_encap(local))
> +			return -EINVAL;
> +
>  		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
>  
>  		if (err) {
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index 2d43bc127043..a4df6bca192f 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -221,6 +221,7 @@ static const char *hw_flag_names[] = {
>  	FLAG(TX_STATUS_NO_AMPDU_LEN),
>  	FLAG(SUPPORTS_MULTI_BSSID),
>  	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
> +	FLAG(SUPPORTS_80211_ENCAP),
>  #undef FLAG
>  };
>  
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index e170f986d226..d7569a455a06 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -987,6 +987,8 @@ struct ieee80211_sub_if_data {
>  	} debugfs;
>  #endif
>  
> +	bool hw_80211_encap;
> +
>  	/* must be last, dynamically sized area in this! */
>  	struct ieee80211_vif vif;
>  };
> @@ -1732,6 +1734,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  		     struct vif_params *params);
>  int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
>  			     enum nl80211_iftype type);
> +bool ieee80211_is_hw_80211_encap(struct ieee80211_local *local);
>  void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_remove_interfaces(struct ieee80211_local *local);
>  u32 ieee80211_idle_off(struct ieee80211_local *local);
> @@ -1759,6 +1762,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  					 struct net_device *dev);
>  netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  				       struct net_device *dev);
> +netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
> +					    struct net_device *dev);
>  void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>  				  struct net_device *dev,
>  				  u32 info_flags);
> @@ -1933,6 +1938,11 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
>  				 struct sk_buff *skb, int tid,
>  				 enum nl80211_band band, u32 txdata_flags);
>  
> +/* sta_out needs to be checked for ERR_PTR() before using */
> +int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
> +			    struct sk_buff *skb,
> +			    struct sta_info **sta_out);
> +
>  static inline void
>  ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
>  			  struct sk_buff *skb, int tid,
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 4a6ff1482a9f..4090c2c5fde0 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1177,6 +1177,59 @@ static const struct net_device_ops ieee80211_dataif_ops = {
>  	.ndo_get_stats64	= ieee80211_get_stats64,
>  };
>  
> +static const struct net_device_ops ieee80211_dataif_8023_ops = {
> +	.ndo_open		= ieee80211_open,
> +	.ndo_stop		= ieee80211_stop,
> +	.ndo_uninit		= ieee80211_uninit,
> +	.ndo_start_xmit		= ieee80211_subif_start_xmit_8023,
> +	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
> +	.ndo_set_mac_address	= ieee80211_change_mac,
> +	.ndo_select_queue	= ieee80211_netdev_select_queue,
> +	.ndo_get_stats64	= ieee80211_get_stats64,
> +};
> +
> +void ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (!sdata->dev)
> +		return;
> +
> +	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP))
> +		enable = 0;
> +
> +	if (!ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG) &&
> +	    (local->hw.wiphy->frag_threshold != (u32)-1))
> +		enable = 0;
> +
> +	if (enable) {
> +		sdata->dev->netdev_ops = &ieee80211_dataif_8023_ops;
> +		sdata->hw_80211_encap = true;
> +	} else {
> +		sdata->dev->netdev_ops = &ieee80211_dataif_ops;
> +		sdata->hw_80211_encap = false;
> +	}
> +}
> +EXPORT_SYMBOL(ieee80211_set_hw_80211_encap);
> +
> +bool ieee80211_is_hw_80211_encap(struct ieee80211_local *local)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	bool offloaded = false;
> +
> +	mutex_lock(&local->iflist_mtx);
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (sdata->hw_80211_encap) {
> +			offloaded = true;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&local->iflist_mtx);
> +
> +	return offloaded;
> +}
> +
>  static u16 ieee80211_monitor_select_queue(struct net_device *dev,
>  					  struct sk_buff *skb,
>  					  struct net_device *sb_dev,
> @@ -1409,6 +1462,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
>  	sdata->vif.bss_conf.idle = true;
>  
>  	sdata->noack_map = 0;
> +	sdata->hw_80211_encap = false;
>  
>  	/* only monitor/p2p-device differ */
>  	if (sdata->dev) {
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 4700718e010f..861b67d43eb7 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -197,6 +197,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  			  key->conf.keyidx,
>  			  sta ? sta->sta.addr : bcast_addr, ret);
>  
> +	if (sdata->hw_80211_encap)
> +		return -EINVAL;
> +
>   out_unsupported:
>  	switch (key->conf.cipher) {
>  	case WLAN_CIPHER_SUITE_WEP40:
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 800e67615e2a..a49bcec3891e 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1000,9 +1000,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
>  	}
>  
> -	/* mac80211 always supports monitor */
> -	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
> -	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
> +	if (ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)) {
> +		/* mac80211 always supports monitor unless we do 802.11
> +		 * encapsulation offloading.
> +		 */
> +		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
> +		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
> +	}
>  
>  	/* mac80211 doesn't support more than one IBSS interface right now */
>  	for (i = 0; i < hw->wiphy->n_iface_combinations; i++) {
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 5b9952b1caf3..8feafaab88a4 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -1019,6 +1019,85 @@ void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL(ieee80211_tx_rate_update);
>  
> +void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
> +			      struct ieee80211_vif *vif,
> +			      struct sk_buff *skb)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct sta_info *sta;
> +	int retry_count;
> +	int rates_idx;
> +	bool acked;
> +
> +	if (WARN_ON(!ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)))
> +		goto skip_stats_update;
> +
> +	sdata = vif_to_sdata(vif);
> +
> +	acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
> +	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
> +
> +	rcu_read_lock();
> +
> +	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
> +		rcu_read_unlock();
> +		goto counters_update;
> +	}
> +
> +	if (!sta || IS_ERR(sta)) {
> +		rcu_read_unlock();
> +		goto counters_update;
> +	}
> +
> +	if (!acked)
> +		sta->status_stats.retry_failed++;
> +
> +	if (rates_idx != -1)
> +		sta->tx_stats.last_rate = info->status.rates[rates_idx];
> +
> +	sta->status_stats.retry_count += retry_count;
> +
> +	if (ieee80211_hw_check(hw, REPORTS_TX_ACK_STATUS)) {
> +		if (acked && vif->type == NL80211_IFTYPE_STATION)
> +			ieee80211_sta_reset_conn_monitor(sdata);
> +
> +		sta->status_stats.last_ack = jiffies;
> +		if (info->flags & IEEE80211_TX_STAT_ACK) {
> +			if (sta->status_stats.lost_packets)
> +				sta->status_stats.lost_packets = 0;
> +
> +			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
> +				sta->status_stats.last_tdls_pkt_time = jiffies;
> +		} else {
> +			ieee80211_lost_packet(sta, info);
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +counters_update:
> +	ieee80211_led_tx(local);
> +
> +	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
> +	    !(info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED))
> +		goto skip_stats_update;
> +
> +	I802_DEBUG_INC(local->dot11TransmittedFrameCount);
> +	if (is_multicast_ether_addr(skb->data))
> +		I802_DEBUG_INC(local->dot11MulticastTransmittedFrameCount);
> +	if (retry_count > 0)
> +		I802_DEBUG_INC(local->dot11RetryCount);
> +	if (retry_count > 1)
> +		I802_DEBUG_INC(local->dot11MultipleRetryCount);
> +
> +skip_stats_update:
> +	ieee80211_report_used_skb(local, skb, false);
> +	dev_kfree_skb(skb);
> +}
> +EXPORT_SYMBOL(ieee80211_tx_status_8023);
> +
>  void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
>  {
>  	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 8a49a74c0a37..85356c208c02 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1253,7 +1253,8 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
>  	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
>  		return NULL;
>  
> -	if (unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
> +	if (!info->control.hw_80211_encap &&
> +	    unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
>  		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
>  		     ieee80211_is_bufferable_mmpdu(hdr->frame_control) ||
>  		     vif->type == NL80211_IFTYPE_STATION) &&
> @@ -1400,6 +1401,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
>  	struct fq *fq = &local->fq;
>  	struct fq_tin *tin = &txqi->tin;
>  
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  	ieee80211_set_skb_enqueue_time(skb);
>  	fq_tin_enqueue(fq, tin, skb,
>  		       fq_skb_free_func,
> @@ -2357,9 +2359,9 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
>  	       skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
>  }
>  
> -static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
> -				   struct sk_buff *skb,
> -				   struct sta_info **sta_out)
> +int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
> +			    struct sk_buff *skb,
> +			    struct sta_info **sta_out)
>  {
>  	struct sta_info *sta;
>  
> @@ -2855,7 +2857,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
>  	struct ieee80211_chanctx_conf *chanctx_conf;
>  	__le16 fc;
>  
> -	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT))
> +	/* check for driver support and ieee80211 encap offload */
> +	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT) ||
> +	    sdata->hw_80211_encap)
>  		return;
>  
>  	/* Locking here protects both the pointer itself, and against concurrent
> @@ -3554,6 +3558,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>  	hdr = (struct ieee80211_hdr *)skb->data;
>  	info = IEEE80211_SKB_CB(skb);
>  
> +	if (info->control.hw_80211_encap)
> +		goto out;
> +
>  	memset(&tx, 0, sizeof(tx));
>  	__skb_queue_head_init(&tx.skbs);
>  	tx.local = local;
> @@ -4003,6 +4010,167 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	return NETDEV_TX_OK;
>  }
>  
> +static bool ieee80211_tx_8023(struct ieee80211_sub_if_data *sdata,
> +			      struct sk_buff *skb, int led_len,
> +			      struct sta_info *sta,
> +			      bool txpending)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_tx_control control = {};
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_sta *pubsta = NULL;
> +	unsigned long flags;
> +	int q = info->hw_queue;
> +
> +	if (ieee80211_queue_skb(local, sdata, sta, skb))
> +		return true;

ieee80211_queue_skb() calls ieee80211_get_txq() which treats skb->data
like it contains an 802.11 header. That is probably not the intention
here, is it?

I guess we could augment the TXQ stuctures to also handle 802.3 frames
(and introduce ieee80211_queue_skb_8023())? Or would it be better to
have a qdisc on 802.3-mode interfaces and push packets back to that? I
guess we'd still benefit from per-station queueing of packets even if
they are Ethernet frames, which would mean amending the TXQs would be
better?

-Toke
