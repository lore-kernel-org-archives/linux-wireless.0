Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CEAC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DE5206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfDLLhW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:37:22 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46436 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDLLhW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 07:37:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEuUi-000545-2G; Fri, 12 Apr 2019 13:37:20 +0200
Message-ID: <5ead666b3b473b5e72673007bfefdae3c82fd920.camel@sipsolutions.net>
Subject: Re: [RFC V4 1/2] mac80211: add hw 80211 encapsulation offloading
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date:   Fri, 12 Apr 2019 13:37:18 +0200
In-Reply-To: <20190410073514.12794-2-john@phrozen.org>
References: <20190410073514.12794-1-john@phrozen.org>
         <20190410073514.12794-2-john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-10 at 09:35 +0200, John Crispin wrote:
> The driver
> needs to enable the support on a per vif basis if it finds that all
> pre-reqs are meet.

> + * @IEEE80211_HW_SUPPORTS_80211_ENCAP: Hardware/driver supports 802.11
> + *	encap for data frames.

I'm still not sure I can reconcile these ... why do you need the latter
if the driver has to enable per vif anyway?

> +int ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable);

Add documentation please. Would be better to return bool too, to be
symmetric.

> +++ b/net/mac80211/cfg.c
> @@ -2379,6 +2379,9 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>  	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
>  		ieee80211_check_fast_xmit_all(local);
>  
> +		if (ieee80211_is_hw_80211_encap(local))
> +			return -EINVAL;

Why not do this like TKIP and disable encap?

> +int ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (enable == sdata->hw_80211_encap)
> +		return enable;

It feels like this is missing some locking? Or at least a lock
assertion, if it's always called with a certain lock held already.

> +	if (!sdata->dev)
> +		return 0;
> +
> +	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP))
> +		enable = 0;
> +
> +	switch (vif->type) {
> +	case NL80211_IFTYPE_STATION:
> +		if (sdata->u.mgd.use_4addr)
> +			enable = 0;
> +		break;
> +	case NL80211_IFTYPE_AP_VLAN:
> +		if (sdata->wdev.use_4addr)
> +			enable = 0;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (!ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG) &&
> +	    (local->hw.wiphy->frag_threshold != (u32)-1))
> +		enable = 0;

Shouldn't there be some kind of TKIP check here?

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

This might be better with RCU, though for proper usage you'd actually
have to call it with the mutex held, otherwise it can change while
you're iterating ...

> +	/* TKIP countermeasures wont work on encap offload mode */
> +	if (key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
> +		ieee80211_set_hw_80211_encap(&sdata->vif, 0);

false.

> @@ -197,6 +201,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  			  key->conf.keyidx,
>  			  sta ? sta->sta.addr : bcast_addr, ret);
>  
> +	if (sdata->hw_80211_encap)
> +		return -EINVAL;

Yeah, and this means you're also missing a "do we have a SW crypto key
right now" check above in ieee80211_set_hw_80211_encap().

> +	if (ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)) {
> +		/* mac80211 always supports monitor unless we do 802.11
> +		 * encapsulation offloading.
> +		 */
> +		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
> +		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
> +	}

Ok, maybe this addresses my question above about why we need both -
though it's not really clear what happens if the driver actually does
want to still enable monitor mode - which certainly we (iwlwifi) would.

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

no need for !! with bool :-)

> +	/* check for driver support and ieee80211 encap offload */
> +	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT) ||
> +	    sdata->hw_80211_encap)
>  		return;

That comment isn't very useful? :-)
 
> @@ -3573,6 +3576,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>  		goto begin;
>  	}
>  
> +	if (info->control.flags & IEEE80211_TX_CTRL_HW_80211_ENCAP)
> +		goto encap_out;
> +
>  	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
>  		info->flags |= IEEE80211_TX_CTL_AMPDU;

Wouldn't you still want this flag, perhaps?

Not with ath10k I guess, which offloads aggregation sessions, but still?
That's not necessarily a requirement for encap offload, is it?

> +	ieee80211_tx_stats(dev, skb->len);
> +
> +	if (sta) {
> +		sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
> +		sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
> +	}

This is something to think about, aren't we usually doing that after
encapsulation? So the counters will be off a bit now?

> +	if (WARN_ON(unlikely(!sdata->hw_80211_encap))) {

I feel I'm repeating myself - WARN_ON() includes unlikely().

johannes

