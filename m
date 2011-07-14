Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17508 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab1GNRMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 13:12:37 -0400
Date: Thu, 14 Jul 2011 22:42:41 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 3/3] mac80211: Report 40MHz Intolerance to associated AP.
Message-ID: <20110714171236.GB25573@vmraj-lnx.users.atheros.com> (sfid-20110714_191241_361966_E16858D3)
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1310559873-10314-3-git-send-email-rmanohar@qca.qualcomm.com>
 <1310638549.3874.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310638549.3874.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 12:15:49PM +0200, Johannes Berg wrote:
> On Wed, 2011-07-13 at 17:54 +0530, Rajkumar Manoharan wrote:
> > This patch adds support for 40MHz intolerance handling in STA
> > mode. STA should report of any 40MHz intolerance in case if it
> > finds a non-HT AP or a HT AP which prohibits 40MHz transmission
> > (i.e 40MHz intolerant bit is set in HT capabilities IE).
> > 
> > STA shall report this condition using 20/40 BSS coexistence
> > action frame.
> 
> I think it'd be smarter to add this logic to cfg80211, the scan parsing
> stuff can be generic, and even the action frame can be transmitted
> generically.
>
> Heck, come to think of it, why not do this in wpa_supplicant?
>
I prefer to go with the common layer for both wpa_s and iw. But cfg80211
seems to be better.
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -206,6 +206,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
> >  		channel_type = NL80211_CHAN_HT20;
> >  
> >  		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
> > +		    !(sband->ht_cap.cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
> >  		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
> >  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
> >  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index 08a45ac..29d50dd 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -74,6 +74,31 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
> >  	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
> >  }
> >  
> > +static void ieee80211_check_40mhz_intolerance(
> > +			struct ieee80211_sub_if_data *sdata,
> > +			struct ieee80211_channel *channel,
> > +			struct ieee802_11_elems *elems)
> > +{
> > +	struct ieee80211_local *local = sdata->local;
> > +
> > +	if ((local->_oper_channel_type != NL80211_CHAN_HT40MINUS) ||
> > +	    (local->_oper_channel_type != NL80211_CHAN_HT40PLUS))
> > +		return;
> > +
> > +	if (local->oper_channel->band != channel->band)
> > +		return;
> > +
> > +	if (!elems->ht_cap_elem ||
> > +	    (le16_to_cpu(elems->ht_cap_elem->cap_info) &
> > +		    IEEE80211_HT_CAP_40MHZ_INTOLERANT)) {
> > +		sdata->found_40mhz_intolerant = true;
> > +		if (!channel->is_40mhz_intolerant) {
> > +			channel->is_40mhz_intolerant = true;
> 
> I don't like mac80211 changing cfg80211 data structures much.
> 
> > +			sdata->intol_channels++;
> 
> If that's a counter, why is it a u8?
> 
> > @@ -434,6 +462,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >  	else
> >  		__set_bit(SCAN_SW_SCANNING, &local->scanning);
> >  
> > +	sdata->found_40mhz_intolerant = false;
> > +	sdata->intol_channels = 0;
> 
> This makes no sense, the scan could be on only some channels, but you're
> resetting all info.
> 
> >  	ieee80211_recalc_idle(local);
> >  
> >  	if (local->ops->hw_scan) {
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index 652e569..9ad5361 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1334,6 +1334,93 @@ int ieee80211_reconfig(struct ieee80211_local *local)
> >  	return 0;
> >  }
> >  
> > +static void ieee80211_send_public_action_frame(
> > +		struct ieee80211_sub_if_data *sdata)
> 
> Kidding, right?
> "send_public_action_frame", but then it creates a 40 intolerant frame?
>
Hmm.. 20/40 BSS coexistence management messages are exchanged by action frame
with public category. That why I named like that.
Forgive my poor naming convention.
> > +void ieee80211_process_40mhz_intolerance(struct ieee80211_local *local)
> > +{
> > +	struct ieee80211_hw *hw = &local->hw;
> > +	struct ieee80211_conf *conf = &hw->conf;
> > +	struct ieee80211_supported_band *sband =
> > +		local->hw.wiphy->bands[local->oper_channel->band];
> > +	struct ieee80211_sub_if_data *sdata;
> > +	int i;
> > +
> > +	mutex_lock(&local->iflist_mtx);
> > +	list_for_each_entry(sdata, &local->interfaces, list) {
> > +		if (!ieee80211_sdata_running(sdata))
> > +			continue;
> > +		if (!sdata->found_40mhz_intolerant)
> > +			continue;
> > +		if (!conf_is_ht40(conf))
> > +			continue;
> > +		ieee80211_send_public_action_frame(sdata);
> 
> What if the AP is HT40, we find the intolerant AP, but we're only 20 MHz
> capable? IOW -- this logic doesn't seem to make sense?
> 
> I really don't see why we can't do all of this in wpa_s.
>
I really appriciate your review comments. Will comeup with cfg80211 logic.

--
Rajkumar
