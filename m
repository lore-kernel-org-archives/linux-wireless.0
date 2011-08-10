Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57361 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1HJPbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 11:31:14 -0400
Received: by fxh19 with SMTP id 19so988224fxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 08:31:13 -0700 (PDT)
Subject: Re: [PATCH 4/4] mac80211: Add HT operation modes for IBSS
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312985033.4325.19.camel@jlt3.sipsolutions.net>
References: <1888623.Vt5VZUN2cU@alex-1>  <3091493.N5vzNRrbMZ@alex-1>
	 (sfid-20110808_141034_452490_4BA26D5D)  <1312985033.4325.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 17:31:08 +0200
Message-ID: <1312990268.3128.22.camel@alex-2> (sfid-20110810_173118_288188_9FA76161)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, den 10.08.2011, 16:03 +0200 schrieb Johannes Berg:
> On Mon, 2011-08-08 at 14:10 +0200, Alexander Simon wrote:
> > This means setting channel into HT mode and adding HT IEs in beacons.
> > Check if regdom allows this first.
> > 
> > If joining another HT network, use its HT mode.
> > If joining a non-HT network, use HT mode given by iw.
> > Join as legacy if neither iw nor remote beacon set an HT mode.
> 
> Do we really want this? I'm wondering if we shouldn't always do HT IBSS
> when joining, even if you didn't ask for it? Not really sure though.
> Thoughts? Are we joining as HT20 if you didn't ask for HT40? And are we
> joining as HT20 if you asked for HT40- but the network is HT40+?
In short: The HT parameter shall behave similar to the frequency:
Non-fixed mode: Only used when starting an IBSS or starting HT in an
non-IBSS.
Fixed mode: Only join when HT modes match.

This should answer your last questions:
When not fixed, the BSSID configuration always is preferred. Thus, we
would join as HT40 even though not requested.
So, when we requsted HT40-, but the IBSS is HT40+, we would work on -.

I wanted to have the opportunity to start HT on an existing IBSS.
The problem is that legacy station may "kill" the HT configuration:
If STA A starts in HT IBSS and lets say Windows STA B joins, B would
advertise that IBSS as non-HT as it ignores our HT IE.
Then, if STA A dies and STA C joins, it will be non-HT.
> > If we receive a beacon from another station within our BSSID with a different HT
> > mode than us, we switch to its HT mode. If there are several stations with
> > different HT modes, it may take some time until all will have the same mode.
> > There is no way we can distinguish the "older" station.
> 
> Actually, you can ... the highest TSF should win.
No, pretty sure not. We *are* already joined. That means the TSFs of all
stations *within* our BSSID match. TSFs can only tell whitch BSSID is
older...
So there is no way to distinguish which station first joined.
Or am i wrong? That would be good in that case :)
> 
> > Except for fixed channel mode, HT mode is also fixed. Join or merge ONLY if
> > channel AND HT mode matches.
> 
> makes sense.
> 
> > +++ b/net/mac80211/ibss.c
> > @@ -35,6 +35,76 @@
> >  
> >  #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
> >  
> > +static bool ieee80211_can_use_ext_chan(struct ieee80211_sub_if_data *sdata,
> > +				       struct ieee80211_channel *channel,
> > +				       enum nl80211_channel_type channel_type)
> > +{
> > +	/* check if we are legally allowed to use HT extension channel */
> > +	if ((channel_type == NL80211_CHAN_HT40PLUS) ||
> > +			(channel_type == NL80211_CHAN_HT40MINUS)) {
> > +		int sec_freq = channel->center_freq +
> > +			     (channel_type == NL80211_CHAN_HT40PLUS ? 20 : -20);
> > +		struct ieee80211_channel *sec_chan =
> > +			     ieee80211_get_channel(sdata->wdev.wiphy, sec_freq);
> > +		if (!sec_chan || sec_chan->flags & (IEEE80211_CHAN_DISABLED |
> > +					   IEEE80211_CHAN_PASSIVE_SCAN |
> > +					   IEEE80211_CHAN_NO_IBSS |
> > +					   IEEE80211_CHAN_RADAR)) {
> > +			return false;
> > +		}
> > +	}
> > +	return true;
> > +}
> 
> Isn't that already a function in cfg80211 that you could rename &
> export?
Hmm... Didn't want to do any changes to the module exports, but I'll use
it.
> 
> > +static void ieee80211_update_ht_elems(struct ieee80211_sub_if_data *sdata,
> > +				      struct ieee80211_mgmt *mgmt,
> > +				      struct ieee80211_ht_info *ht_info)
> > +{
> > +	struct ieee80211_local *local = sdata->local;
> > +	struct ieee80211_supported_band *sband =
> > +			local->hw.wiphy->bands[local->oper_channel->band];
> > +	enum nl80211_channel_type channel_type =
> > +			ieee80211_ht_info_to_channel_type(ht_info);
> > +
> > +	if (!ieee80211_can_use_ext_chan(sdata, local->oper_channel, channel_type))
> > +		channel_type = NL80211_CHAN_HT20;
> > +
> > +	if (channel_type != local->_oper_channel_type) {
> > +		struct sk_buff *skb = rcu_dereference_protected(
> > +				sdata->u.ibss.presp,
> > +				lockdep_is_held(&ifibss->mtx));
> > +		struct sk_buff *nskb;
> > +		u8 *ht_ie;
> > +
> > +		/* update HT IE. If not yet existing, create one */
> > +		nskb = skb_copy(skb, GFP_ATOMIC);
> > +		ht_ie = (u8 *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
> > +					       (const u8 *)(nskb->data + 24 +
> > +							sizeof(mgmt->u.beacon)),
> > +					       nskb->len - 24 -
> > +							sizeof(mgmt->u.beacon));
> > +		if (!ht_ie)
> > +			ht_ie = skb_put(nskb, 4 +
> > +					      sizeof(struct ieee80211_ht_cap) +
> > +					      sizeof(struct ieee80211_ht_info));
> > +
> > +		ht_ie = ieee80211_ie_build_ht_cap(ht_ie, sband,
> > +						  sband->ht_cap.cap);
> > +		ht_ie = ieee80211_ie_build_ht_info(ht_ie, &sband->ht_cap,
> > +					     local->oper_channel, channel_type);
> > +		rcu_assign_pointer(sdata->u.ibss.presp, nskb);
> > +		kfree_skb(skb);
> 
> RCU race here.
> 
> > @@ -104,8 +175,17 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
> >  
> >  	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
> >  
> > +	/* entering a legacy IBSS. Use given HT configuration. */
> > +	if (channel_type == NL80211_CHAN_NO_HT)
> > +		channel_type = ifibss->channel_type;
> >  	local->oper_channel = chan;
> > -	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
> > +
> > +	/* if phy is on a different extension channel, setting ht40 will fail */
> > +	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
> > +		channel_type = NL80211_CHAN_HT20;
> > +		WARN_ON(!ieee80211_set_channel_type(local, sdata,
> > +				                                 channel_type));
> > +	}
> 
> indentation
> 
> > @@ -404,7 +525,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
> >  		ieee80211_sta_join_ibss(sdata, bss);
> >  		supp_rates = ieee80211_sta_get_rates(local, elems, band);
> >  		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
> > -				       supp_rates, GFP_KERNEL);
> > +				    supp_rates, elems->ht_cap_elem, GFP_KERNEL);
> 
> indentation
> 
> johannes
> 


