Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44806 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751258AbXGJOPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 10:15:24 -0400
Date: Tue, 10 Jul 2007 16:15:19 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net, mb@bu3sch.de,
	flamingice@sourmilk.net
Subject: Re: [PATCH 3/4] mac80211: improved short preamble handling
Message-ID: <20070710161519.5bbe2e07@logostar.upir.cz>
In-Reply-To: <20070706201119.735827B409F@zog.reactivated.net>
References: <20070706201119.735827B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri,  6 Jul 2007 21:11:18 +0100 (BST), Daniel Drake wrote:
> Index: wireless-dev/net/mac80211/ieee80211.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211.c
> +++ wireless-dev/net/mac80211/ieee80211.c
> @@ -443,12 +443,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
>  		tx->u.tx.control->rate = tx->u.tx.rate;
>  	}
>  	tx->u.tx.control->tx_rate = tx->u.tx.rate->val;
> -	if ((tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
> -	    tx->local->short_preamble &&
> -	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
> -		tx->u.tx.short_preamble = 1;
> -		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
> -	}
>  
>  	return TXRX_CONTINUE;
>  }
> @@ -699,16 +693,22 @@ static int ieee80211_frame_duration(stru
>  
>  
>  /* Exported duration function for driver use */
> -__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
> +__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw, int if_id,
>  					size_t frame_len, int rate)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> +	struct net_device *bdev = dev_get_by_index(if_id);
> +	struct ieee80211_sub_if_data *sdata;
>  	u16 dur;
>  	int erp;
>  
> +	if (unlikely(!bdev))
> +		return 0;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
>  	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
>  	dur = ieee80211_frame_duration(local, frame_len, rate,
> -				       erp, local->short_preamble);
> +				       erp, sdata->short_preamble);
>  
>  	return cpu_to_le16(dur);
>  }

Missing dev_put.

> @@ -805,7 +805,7 @@ static u16 ieee80211_duration(struct iee
>  	 * to closest integer */
>  
>  	dur = ieee80211_frame_duration(local, 10, rate, erp,
> -				       local->short_preamble);
> +				       tx->sdata->short_preamble);
>  
>  	if (next_frag_len) {
>  		/* Frame is fragmented: duration increases with time needed to
> @@ -814,7 +814,7 @@ static u16 ieee80211_duration(struct iee
>  		/* next fragment */
>  		dur += ieee80211_frame_duration(local, next_frag_len,
>  						txrate->rate, erp,
> -						local->short_preamble);
> +						tx->sdata->short_preamble);
>  	}
>  
>  	return dur;
> @@ -825,6 +825,7 @@ static ieee80211_txrx_result
>  ieee80211_tx_h_misc(struct ieee80211_txrx_data *tx)
>  {
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
> +	u16 fc = le16_to_cpu(hdr->frame_control);
>  	u16 dur;
>  	struct ieee80211_tx_control *control = tx->u.tx.control;
>  	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
> @@ -860,6 +861,16 @@ ieee80211_tx_h_misc(struct ieee80211_txr
>  	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
>  		control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
>  
> +	/* Transmit data frames using short preambles if the driver supports
> +	 * short preambles at the selected rate and short preambles are
> +	 * available on the network at the current point in time. */
> +	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
> +	    (tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
> +	    tx->sdata->short_preamble &&
> +	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
> +		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
> +	}
> +
>  	/* Setup duration field for the first fragment of the frame. Duration
>  	 * for remaining fragments will be updated when they are being sent
>  	 * to low-level driver in ieee80211_tx(). */
> @@ -1883,7 +1894,7 @@ struct sk_buff * ieee80211_beacon_get(st
>  			return NULL;
>  		}
>  
> -		control->tx_rate = (local->short_preamble &&
> +		control->tx_rate = (sdata->short_preamble &&
>  				    (rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
>  			rate->val2 : rate->val;
>  		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
> @@ -1898,16 +1909,24 @@ struct sk_buff * ieee80211_beacon_get(st
>  }
>  EXPORT_SYMBOL(ieee80211_beacon_get);
>  
> -__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
> +__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, int if_id,
>  			      size_t frame_len,
>  			      const struct ieee80211_tx_control *frame_txctl)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  	struct ieee80211_rate *rate;
> -	int short_preamble = local->short_preamble;
> +	struct net_device *bdev = dev_get_by_index(if_id);
> +	struct ieee80211_sub_if_data *sdata;
> +	int short_preamble;
>  	int erp;
>  	u16 dur;
>  
> +	if (unlikely(!bdev))
> +		return 0;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
> +	short_preamble = sdata->short_preamble;
> +
>  	rate = frame_txctl->rts_rate;
>  	erp = !!(rate->flags & IEEE80211_RATE_ERP);
>  

Missing dev_put.

> @@ -1926,16 +1945,24 @@ __le16 ieee80211_rts_duration(struct iee
>  EXPORT_SYMBOL(ieee80211_rts_duration);
>  
>  
> -__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
> +__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw, int if_id,
>  				    size_t frame_len,
>  				    const struct ieee80211_tx_control *frame_txctl)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  	struct ieee80211_rate *rate;
> -	int short_preamble = local->short_preamble;
> +	struct net_device *bdev = dev_get_by_index(if_id);
> +	struct ieee80211_sub_if_data *sdata;
> +	int short_preamble;
>  	int erp;
>  	u16 dur;
>  
> +	if (unlikely(!bdev))
> +		return 0;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
> +	short_preamble = sdata->short_preamble;
> +
>  	rate = frame_txctl->rts_rate;
>  	erp = !!(rate->flags & IEEE80211_RATE_ERP);
>  

Missing dev_put.

Other than that, looks good to me.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
