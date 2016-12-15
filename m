Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42390 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757601AbcLOJ3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:29:09 -0500
Message-ID: <1481794142.31776.5.camel@sipsolutions.net> (sfid-20161215_102938_964410_E8E5838B)
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:29:02 +0100
In-Reply-To: <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> There is a field, no_80211_encap, added to ieee80211_tx_info:control
> to mark if the 802.11 encapsulation is offloaded to driver.
> There is also a new callback for tx completion status indication
> to handle data frames using 802.11 encap offload.

I'm not sure I see the need for this? Maybe I'll find out in this patch
:)

> +			/* XXX: This frame is not encaptulated with
> 802.11
> +			 * header. Should this be added to
> %IEEE80211_TX_CTRL_*
> +			 * flags?.
> +			 */
> +			bool no_80211_encap;
> +			/* 3 bytes free */
>  		} control;

probably - just to preserve more space.

> + * @IEEE80211_CONF_CHANGE_80211_HDR_OFFL: Offload configuration
> + *	implementing 802.11 encap/decap for data frames changed.
>   */
>  enum ieee80211_conf_changed {
>  	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
> @@ -1279,6 +1286,7 @@ enum ieee80211_conf_changed {
>  	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
>  	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
>  	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
> +	IEEE80211_CONF_CHANGE_80211_HDR_OFFL	= BIT(9),
>  };

Given the requirements (PN check, etc.) I'm not sure how this can
change dynamically?

> + * @encap_decap_80211_offloaded: Whether 802.11 header encap/decap
> offload
> + *	is enabled
>   */
>  struct ieee80211_conf {
>  	u32 flags;
> @@ -1346,6 +1357,7 @@ struct ieee80211_conf {
>  	struct cfg80211_chan_def chandef;
>  	bool radar_enabled;
>  	enum ieee80211_smps_mode smps_mode;
> +	bool encap_decap_80211_offloaded;

Please don't add anything here that's interface specific.

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -107,6 +107,10 @@ static int ieee80211_change_iface(struct wiphy
> *wiphy,
>  		}
>  	}
>  
> +	ieee80211_if_check_80211_hdr_offl(sdata,
> +					  params ? params->use_4addr 
> : false,
> +					  true);
> +
>  	return 0;
>  }

Wouldn't it be better to simply prohibit changing this while the
interface is up, and re-init it later when it goes up?

> +++ b/net/mac80211/ieee80211_i.h
> @@ -1373,6 +1373,8 @@ struct ieee80211_local {
>  	/* TDLS channel switch */
>  	struct work_struct tdls_chsw_work;
>  	struct sk_buff_head skb_queue_tdls_chsw;
> +
> +	bool data_80211_hdr_offloaded;

Again, don't put interface specific things into device structures.

> +int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
> +			    struct sk_buff *skb,
> +			    struct sta_info **sta_out);

Return the sta_info pointer, and ERR_PTR() if needed.

> +++ b/net/mac80211/iface.c
> @@ -698,6 +698,11 @@ int ieee80211_do_open(struct wireless_dev *wdev,
> bool coming_up)
>  		rcu_assign_pointer(local->p2p_sdata, sdata);
>  	}
>  
> +	if (local->open_count == 0 && local-
> >data_80211_hdr_offloaded) {
> +		local->hw.conf.encap_decap_80211_offloaded = true;
> +		hw_reconf_flags |=
> IEEE80211_CONF_CHANGE_80211_HDR_OFFL;
> +	}

I don't see how this helps anything, I think you should remove it.

> +void ieee80211_if_config_80211_hdr_offl(struct ieee80211_local
> *local,
> +					bool enable_80211_hdr_offl)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	unsigned long flags;
> +	int n_acs = IEEE80211_NUM_ACS;
> +	int ac;
> +
> +	ASSERT_RTNL();
> +
> +	if (!ieee80211_hw_check(&local->hw,
> SUPPORTS_80211_ENCAP_DECAP) ||
> +	    !(ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)))
> +		return;
> +
> +	if (local->hw.wiphy->frag_threshold != (u32)-1 &&
> +	    !local->ops->set_frag_threshold)
> +		return;
> +
> +	mutex_lock(&local->iflist_mtx);
> +
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (!sdata->dev)
> +			continue;
> +
> +		netif_tx_stop_all_queues(sdata->dev);
> +
> +		if (enable_80211_hdr_offl)
> +			sdata->dev->netdev_ops =
> &ieee80211_dataif_8023_ops;
> +		else
> +			sdata->dev->netdev_ops =
> &ieee80211_dataif_ops;
> +	}
> +
> +	mutex_unlock(&local->iflist_mtx);
> +
> +	local->data_80211_hdr_offloaded = enable_80211_hdr_offl;
> +
> +	if (local->started) {
> +		if (enable_80211_hdr_offl)
> +			local->hw.conf.encap_decap_80211_offloaded =
> true;
> +		else
> +			local->hw.conf.encap_decap_80211_offloaded =
> false;
> +		ieee80211_hw_config(local,
> +				    IEEE80211_CONF_CHANGE_80211_HDR_
> OFFL);
> +	}
> +
> +	mutex_lock(&local->iflist_mtx);
> +
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (!sdata->dev)
> +			continue;
> +
> +		if (local->hw.queues < IEEE80211_NUM_ACS)
> +			n_acs = 1;
> +
> +		spin_lock_irqsave(&local->queue_stop_reason_lock,
> flags);
> +		if (sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE
> ||
> +		    (local->queue_stop_reasons[sdata->vif.cab_queue] 
> == 0 &&
> +		     skb_queue_empty(&local->pending[sdata-
> >vif.cab_queue]))) {
> +			for (ac = 0; ac < n_acs; ac++) {
> +				int ac_queue = sdata-
> >vif.hw_queue[ac];
> +
> +				if (local-
> >queue_stop_reasons[ac_queue] == 0 &&
> +				    skb_queue_empty(&local-
> >pending[ac_queue]))
> +					netif_start_subqueue(sdata-
> >dev, ac);
> +			}
> +		}
> +		spin_unlock_irqrestore(&local-
> >queue_stop_reason_lock, flags);
> +	}
> +
> +	mutex_unlock(&local->iflist_mtx);
> +}

I really would prefer we could simply avoid doing these manipulations
while the interface is UP and can have data queued.

> +++ b/net/mac80211/key.c
> @@ -208,13 +208,25 @@ static int ieee80211_key_enable_hw_accel(struct
> ieee80211_key *key)
>  	case WLAN_CIPHER_SUITE_GCMP_256:
>  		/* all of these we can do in software - if driver
> can */
>  		if (ret == 1)
> -			return 0;
> +			goto check_8023_txrx;
>  		if (ieee80211_hw_check(&key->local->hw,
> SW_CRYPTO_CONTROL))
>  			return -EINVAL;
> -		return 0;
> +		goto check_8023_txrx;
>  	default:
>  		return -EINVAL;
>  	}
> +
> +check_8023_txrx:
> +	/* When sw crypto is enabled make sure data tx/rx happens
> +	 * in 802.11 format.
> +	 */
> +	if (key->local->data_80211_hdr_offloaded) {
> +		rtnl_lock();
> +		ieee80211_if_config_80211_hdr_offl(key->local,
> false);
> +		rtnl_unlock();
> +	}
> +
> +	return 0;
>  }

Why not just refuse the key instead? It also seems wrong to do anything
with local-> here, it should be per interface.

> +++ b/net/mac80211/status.c
> @@ -506,12 +506,14 @@ static void ieee80211_report_used_skb(struct
> ieee80211_local *local,
>  				      struct sk_buff *skb, bool
> dropped)
>  {
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -	struct ieee80211_hdr *hdr = (void *)skb->data;
> +	struct ieee80211_hdr *hdr;
>  	bool acked = info->flags & IEEE80211_TX_STAT_ACK;
>  
>  	if (dropped)
>  		acked = false;
>  
> +	hdr = (void *)skb->data;

That change make no sense.

>  	if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
>  		struct ieee80211_sub_if_data *sdata;
>  
> @@ -945,6 +947,85 @@ void ieee80211_tx_status(struct ieee80211_hw
> *hw, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(ieee80211_tx_status);
>  
> +void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
> +			      struct ieee80211_vif *vif,
> +			      struct sk_buff *skb)

I think this could share some code with the 802.11 version?

> +	/* XXX: Add a generic helper for this */
> +	if (sdata->vif.type == NL80211_IFTYPE_AP ||
> +	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> +	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
> +		ether_addr_copy(ra_addr, ehdr->h_dest);

nit, but the "A" in "RA" already means address ... :)

You also don't need to copy it - just keeping a pointer should be fine?

> +	/* TODO: Handle frames requiring wifi tx status to be
> notified */
> +	if (skb->sk && skb_shinfo(skb)->tx_flags &
> SKBTX_WIFI_STATUS)
> +		goto out_free;

Surely you shouldn't free them, even if you don't handle the status?!

johannes
