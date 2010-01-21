Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61027 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab0AUVfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 16:35:05 -0500
Subject: Re: [PATCH v2 1/1] mac80211: tell driver when dtim change detected
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1264106695.11396.77.camel@johannes.local>
References: <1264105908-10757-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264106695.11396.77.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 13:31:33 -0800
Message-Id: <1264109493.11290.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-01-21 at 12:44 -0800, Johannes Berg wrote:
> On Thu, 2010-01-21 at 12:31 -0800, wey-yi.w.guy@intel.com wrote:
> 
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> 
> This is all in mlme.c, so ...
> 
> > +static void ieee80211_update_dtim(struct ieee80211_sub_if_data *sdata,
> > +				  struct ieee80211_local *local,
> > +				  struct ieee80211_bss *bss)
> > +{
> > +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
> > +		return;
> > +
> > +	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> 
> I don't think you need this check?

yes, that make sense.

> 
> > +	    sdata->vif.bss_conf.dtim_period != bss->dtim_period) {
> > +		sdata->vif.bss_conf.dtim_period = bss->dtim_period;
> > +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> > +		mutex_lock(&local->iflist_mtx);
> > +		ieee80211_recalc_ps(local, -1);
> > +		mutex_unlock(&local->iflist_mtx);
> 
> And afaict recalc_ps() will call hw_config() if appropriate.
> 
That is the part I am not sure, so I call the hw_config manually, since
you confirm hw_config will happen, then there is no point to call first

I will make those changes and submit again

Wey


