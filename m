Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58915 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbaKSSrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:47:22 -0500
Message-ID: <546CE5B3.6080005@openwrt.org> (sfid-20141119_194724_881333_F3091413)
Date: Wed, 19 Nov 2014 19:47:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] mac80211: add ieee80211_tx_status_noskb
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>	 <1416094080-49220-6-git-send-email-nbd@openwrt.org> <1416422321.9374.24.camel@sipsolutions.net>
In-Reply-To: <1416422321.9374.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-19 19:38, Johannes Berg wrote:
> 
>>  /**
>> + * ieee80211_tx_status_noskb - transmit status callback without skb
>> + *
>> + * This function can be used as a replacement for ieee80211_tx_status
>> + * in drivers that cannot reliably map tx status information back to
>> + * specific skbs.
>> + *
>> + * This function may not be called in IRQ context. Calls to this function
>> + * for a single hardware must be synchronized against each other. Calls
>> + * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
>> + * may not be mixed for a single hardware. Must not run concurrently with
>> + * ieee80211_rx() or ieee80211_rx_ni().
> 
> None of that seems very likely. Did you just copy/paste it? :)
Yes, I copy/pasted it. I wasn't sure if these requirements would be
necessary for the no-skb status as well, just figured it'd be safe to
leave them in.

>> +static inline void
>> +rate_control_tx_status_noskb(struct ieee80211_local *local,
>> +			     struct ieee80211_supported_band *sband,
>> +			     struct sta_info *sta,
>> +			     struct ieee80211_tx_info *info)
>> +{
>> +	struct rate_control_ref *ref = local->rate_ctrl;
>> +	struct ieee80211_sta *ista = &sta->sta;
>> +	void *priv_sta = sta->rate_ctrl_priv;
>> +
>> +	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
>> +		return;
>> +
>> +	ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
>> +}
> 
> Oh, so you're adding another one ... I guess I understand better now.
> 
>> +
>> +
> 
> two blank lines?
Will fix that.

>> -static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
>> +static void ieee80211_lost_packet(struct sta_info *sta,
>> +				  struct ieee80211_tx_info *info)
>>  {
>> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> -
> 
> some of this refactoring might better be in a separate patch.
> 
>>  	/* This packet was aggregated but doesn't carry status info */
>>  	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
>>  	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
>> @@ -571,24 +570,13 @@ static void ieee80211_lost_packet(struct sta_info *sta, struct sk_buff *skb)
>>  	sta->lost_packets = 0;
>>  }
>>  
>> -void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>> +static int ieee80211_tx_get_rates(struct ieee80211_hw *hw,
>> +				  struct ieee80211_tx_info *info,
>> +				  int *retry_count)
>>  {
>> -	struct sk_buff *skb2;
>> -	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>> -	struct ieee80211_local *local = hw_to_local(hw);
>> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> -	__le16 fc;
>> -	struct ieee80211_supported_band *sband;
>> -	struct ieee80211_sub_if_data *sdata;
>> -	struct net_device *prev_dev = NULL;
>> -	struct sta_info *sta, *tmp;
>> -	int retry_count = -1, i;
>>  	int rates_idx = -1;
>> -	bool send_to_cooked;
>> -	bool acked;
>> -	struct ieee80211_bar *bar;
>> -	int rtap_len;
>> -	int shift = 0;
>> +	int count = -1;
>> +	int i;
> 
> ditto - too big for here.
OK.

>> +	acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
>> +	if (pubsta) {
>> +		struct sta_info *sta;
>> +
>> +		sta = container_of(pubsta, struct sta_info, sta);
>> +
>> +		if (info->flags & IEEE80211_TX_STATUS_EOSP)
>> +			clear_sta_flag(sta, WLAN_STA_SP);
> 
> That doesn't seem reasonable really - if you're reporting out of band
> then don't report it as TX status but rather with the eosp() call.
OK.

- Felix
