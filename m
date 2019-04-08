Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5A6C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FEC82083E
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfDHT2s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 15:28:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33118 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHT2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 15:28:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDZwg-0006Ms-IE; Mon, 08 Apr 2019 21:28:42 +0200
Message-ID: <afc28aafa9679a9720539f4cc8d1187378ff1d61.camel@sipsolutions.net>
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date:   Mon, 08 Apr 2019 21:28:40 +0200
In-Reply-To: <20190401131416.22646-2-john@phrozen.org> (sfid-20190401_151445_973127_5FDC52FE)
References: <20190401131416.22646-1-john@phrozen.org>
         <20190401131416.22646-2-john@phrozen.org>
         (sfid-20190401_151445_973127_5FDC52FE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-01 at 15:14 +0200, John Crispin wrote:
> 
> + * @IEEE80211_HW_SUPPORTS_80211_ENCAP: Hardware/driver supports 802.11
> + *	encap for data frames.

What's this needed for,

> +void ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable);

if you have this?

But then again this one's missing docs so I don't yet know what it's
actually doing :-)

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

"fall through" I believe is needed to shut up the compiler about it.

But is this really a good idea? To do this completely only on the
support check, vs. what's currently active?

And I think it should probably just disable the encap offload, rather
than reject TKIP.

> @@ -2379,6 +2386,9 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>  	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
>  		ieee80211_check_fast_xmit_all(local);
>  
> +		if (ieee80211_is_hw_80211_encap(local))
> +			return -EINVAL;

That seems misplaced? After checking fast_xmit? But again, similar as
above - IMHO it'd be better to disable encap offload.

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

false?

This should probably be a WARN_ON(), after all the driver is calling
this?

> +	if (!ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG) &&
> +	    (local->hw.wiphy->frag_threshold != (u32)-1))
> +		enable = 0;

The driver might need to know that you overrode it, so return the actual
value?

This is also asymmetric with my comment above - if you don't allow
enabling it while fragmentation is enabled, but at the same time don't
disable it when trying to enable fragmentation, suddenly the order of
the two operations starts to matter and that might be rather confusing.

> +	if (enable) {
> +		sdata->dev->netdev_ops = &ieee80211_dataif_8023_ops;

Can we really play with that pointer like that? Though I guess the two
are identical except for the TX so it probably won't really matter.

> +bool ieee80211_is_hw_80211_encap(struct ieee80211_local *local)

Maybe rename to "have_vif_with" instead of "is"? That gets a bit long,
but you get the point.

> +++ b/net/mac80211/key.c
> @@ -197,6 +197,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  			  key->conf.keyidx,
>  			  sta ? sta->sta.addr : bcast_addr, ret);
>  
> +	if (sdata->hw_80211_encap)
> +		return -EINVAL;
> +

Seems that should be inside the "out_unsupported" label:

>   out_unsupported:
>  	switch (key->conf.cipher) {
>  	case WLAN_CIPHER_SUITE_WEP40:

or possibly even inside the switch.

> +	if (ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)) {
> +		/* mac80211 always supports monitor unless we do 802.11
> +		 * encapsulation offloading.
> +		 */
> +		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
> +		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
> +	}

I really think we need this to be more flexible, Intel hardware for
example can do encap offload per queue, so theoretically we could even
enable/disable it per *station*, but I'd settle for per *interface*.

Certainly we don't want to suddenly find that monitor mode is limited
when we enable this?

Also, you still always have a way to disable it, right?
 
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

Do we really need this, vs. just using ieee80211_tx_status_noskb()?

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

That could use a comment, I had to think about it for a while ;-)

> @@ -1400,6 +1401,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
>  	struct fq *fq = &local->fq;
>  	struct fq_tin *tin = &txqi->tin;
>  
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);

blank line should be after this, not before :)

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

Maybe we should treat encap offload as a sort of hardware-accelerated
fast-xmit, and enable/disable based on whether we'd normally
enable/disable fast-xmit? That way we already have all the
infrastructure for keeping track of whether we can use it or not, etc.

>  	/* Locking here protects both the pointer itself, and against concurrent
> @@ -3554,6 +3558,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>  	hdr = (struct ieee80211_hdr *)skb->data;
>  	info = IEEE80211_SKB_CB(skb);
>  
> +	if (info->control.hw_80211_encap)
> +		goto out;

I'm not sure this is right, you would probably still at least do the
ieee80211_tx_h_select_key() call a bit later, and possibly the A-MPDU
stuff?

You also don't assign the right vif pointer, which will probably work in
some cases but quite likely not in general.

Again, maybe treating it like fast-xmit-offload would make sense here,
and we could do this in ieee80211_xmit_fast_finish().

But that might very well not be the right model since fast-xmit is per
station, though the conditions are mostly not depending on the station,
except for auth/assoc state - which has the same issues with encap
offload though! Like ... you probably need to send EAPOL frames through
a non-encap-offload path?

> +	/* TODO: Handle frames requiring wifi tx status to be notified */

:)

Maybe that means you do need ieee80211_tx_status_8023().

> +	memset(info, 0, sizeof(*info));
> +
> +	if (unlikely(sdata->control_port_protocol == ehdr->h_proto)) {
> +		if (sdata->control_port_no_encrypt)
> +			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
> +		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
> +	}
> +
> +	if (multicast)
> +		info->flags |= IEEE80211_TX_CTL_NO_ACK;
> +
> +	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
> +
> +	ieee80211_tx_stats(dev, skb->len);
> +
> +	if (sta) {
> +		sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
> +		sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
> +	}
> +
> +	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
> +		sdata = container_of(sdata->bss,
> +				     struct ieee80211_sub_if_data, u.ap);
> +
> +	info->control.hw_80211_encap = true;
> +	info->control.vif = &sdata->vif;

There's lots of duplicate code here, maybe split that out? Perhaps it
should be inlined, but then it can be an inline function to keep all the
stats etc.

> +netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
> +					    struct net_device *dev)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct sta_info *sta;
> +
> +	if (WARN_ON(unlikely(!sdata->hw_80211_encap))) {

WARN_ON() contains unlikely()

> +	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
> +		goto out_free;
> +
> +	ieee80211_8023_xmit(sdata, dev, sta, skb);

Does that handle ERR_PTR() sta correctly?

> @@ -4081,6 +4249,16 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
>  		}
>  		info->band = chanctx_conf->def.chan->band;
>  		result = ieee80211_tx(sdata, NULL, skb, true, 0);
> +	} else if (info->control.hw_80211_encap) {
> +		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
> +			dev_kfree_skb(skb);
> +			return true;
> +		}
> +
> +		if (IS_ERR(sta) || (sta && !sta->uploaded))
> +			sta = NULL;
> +
> +		result = ieee80211_tx_8023(sdata, skb, skb->len, sta, true);

This doesn't seem to make sense, how can you TX to a non-STA with encap
offload, you don't even know where to send the frame then?

johannes


